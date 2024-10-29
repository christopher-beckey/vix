package gov.va.med.imaging.transactioncontext;

import gov.va.med.imaging.encryption.AesEncryption;
import gov.va.med.imaging.utils.NetUtilities;
import org.apache.commons.lang.StringEscapeUtils;
import gov.va.med.logging.Logger;

import javax.servlet.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class SecurityTokenFilter implements Filter {
    private static final Logger LOGGER = Logger.getLogger(SecurityTokenFilter.class);

    private static final String PARAM_LOGIN_PAGE = "loginPage";
    private static final String PARAM_AUTH_CREDS = "authenticationCredentials";

    private static final String RESPONSE_HTML_HEADER_FAILED = "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>Unauthorized: Invalid or no security token header provided</title></head><body><h1>Access denied</h1><h2>An invalid or no security token header was provided.</h2><h3>Please visit <a href=\"";
    private static final String RESPONSE_HTML_HEADER_EXPIRED = "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>Unauthorized: Security token header has expired</title></head><body><h1>Access denied</h1><h2>The provided security token header has expired.</h2><h3>Please visit <a href=\"";
    private static final String RESPONSE_HTML_FOOTER = "\">here</a> to provide authentication credentials.</h3></body></html>";
    private static final String RESPONSE_JSON_FAILED = "{ \"error\" : \"An invalid or no security token (securityToken) header was provided\" }";
    private static final String RESPONSE_JSON_EXPIRED = "{ \"error\" : \"The provided security token (securityToken) header has expired\" }";
    private static final String RESPONSE_XML_FAILED = "<error>An invalid or no security token (securityToken) header was provided</error>";
    private static final String RESPONSE_XML_EXPIRED = "<error>The provided security token (securityToken) header has expired</error>";

    private String loginPage;
    private Map<String, String> authenticationCredentials;

    public void init(FilterConfig filterConfig) throws ServletException {
        // Determine the login page to redirect users to
        loginPage = filterConfig.getInitParameter(PARAM_LOGIN_PAGE);
        if ((loginPage == null) || (loginPage.length() == 0)) {
            loginPage = "[No loginPage parameter set in SecurityTokenFilter]";
        }

        // Add hard-coded (basic) allowed authentication values
        authenticationCredentials = new HashMap<String, String>();
        String authCreds = filterConfig.getInitParameter(PARAM_AUTH_CREDS);
        if ((authCreds != null) && (authCreds.length() > 0)) {
            for (String credentialToken : authCreds.split(",")) {
                String[] credentials = credentialToken.split(";");
                if (credentials.length == 2) {
                    authenticationCredentials.put(credentials[0], credentials[1]);
                }
            }
        }
    }

    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        String requestId = UUID.randomUUID().toString();

        LOGGER.debug("[{}] - Applying SecurityTokenFilter to request", requestId);
        boolean passedBasicAuth = false;

        if ((servletRequest instanceof HttpServletRequest) && (servletResponse instanceof HttpServletResponse)) {
            try {
                HttpServletRequest httpRequest = (HttpServletRequest) servletRequest;
                HttpServletResponse httpResponse = (HttpServletResponse) servletResponse;

                // Alternatively, allow basic auth
                String authorization = httpRequest.getHeader("Authorization");
                if (authorization == null) {
                    authorization = httpRequest.getHeader("authorization");
                }

                if (authorization != null) {
                    try {
                        // Grab the base64-encoded part
                        authorization = authorization.replaceFirst("Basic (.+)", "$1");
                        
                        // Attempt to base64 decode the value
                        byte[] decodedBytes = Base64.getDecoder().decode(authorization);
                        if (decodedBytes != null) {
                            String credentials = new String(decodedBytes);
                            String username = credentials.replaceFirst("(.+):(.+)", "$1");
                            String password = credentials.replaceFirst("(.+):(.+)", "$2");
                            String matchingPassword = authenticationCredentials.get(username);
                            if ((matchingPassword != null) && (matchingPassword.equals(password))) {
                                passedBasicAuth = true;
                            }
                        }
                    } catch (Exception e) {
                        // Log, but continue (allow for securityToken to work)
                        LOGGER.warn("[{}] - Error decoding authorization header", requestId, e);
                    }
                }

                if (! (passedBasicAuth)) {
                    // Get the security token
                    String securityToken = httpRequest.getParameter("securityToken");
                    if ((securityToken == null) || (securityToken.length() == 0)) {
                        // Try and get it from a cookie; some checks here necessary since there appear to be null cases
                        if (httpRequest.getCookies() != null) {
                            for (Cookie cookie : httpRequest.getCookies()) {
                                if ((cookie != null) && ("securityToken".equalsIgnoreCase(cookie.getName()))) {
                                    securityToken = cookie.getValue();
                                    if ((securityToken == null) || (securityToken.length() == 0)) {
                                        LOGGER.debug("[{}] - No \"securityToken\" header was provided; rejecting", requestId);
                                        sendAuthenticationFailedResponse(httpRequest, httpResponse, false);
                                        return;
                                    }
                                }
                            }
                        }
                    }

                    // Decrypt the security token
                    String decodedValue;
                    try {
                        // Decrypt the value
                        decodedValue = AesEncryption.decodeByteArray(securityToken);
                    } catch (Exception e) {
                        LOGGER.debug("[{}] - \"securityToken\" header failed to decrypt", requestId);
                        sendAuthenticationFailedResponse(httpRequest, httpResponse, false);
                        return;
                    }

                    // Add values to transaction context, if available
                    try {
                        // Set the various transaction context values
                        String[] tokens = decodedValue.split("\\|\\|");
                        // Check for security token timeout
                        long timeout = 0;
                        if (tokens.length > 9) {
                            try {
                                timeout = Long.parseLong(tokens[9]);
                            } catch (Exception e) {
                                // Ignore
                            }
                        }

                        if (System.currentTimeMillis() >= timeout) {
                            LOGGER.debug("[{}] - \"securityToken\" has expired", requestId);
                            sendAuthenticationFailedResponse(httpRequest, httpResponse, true);
                            return;
                        }

                        // Get the transaction context and set some basic values
                        TransactionContext transactionContext = TransactionContextFactory.get();
                        transactionContext.setStartTime(System.currentTimeMillis());
                        transactionContext.setMachineName(NetUtilities.getUnsafeLocalHostName());

                        // Set full name
                        if ((tokens.length > 0) && ((transactionContext.getFullName() == null) || (transactionContext.getFullName().length() == 0))) {
                            transactionContext.setFullName(tokens[0]);
                        }

                        // Set DUZ
                        if ((tokens.length > 1) && ((transactionContext.getDuz() == null) || (transactionContext.getDuz().length() == 0))) {
                            transactionContext.setDuz(tokens[1]);
                        }

                        // Set SSN
                        if ((tokens.length > 2) && ((transactionContext.getSsn() == null) || (transactionContext.getSsn().length() == 0))) {
                            transactionContext.setSsn(tokens[2]);
                        }

                        // Set site name
                        if ((tokens.length > 3) && ((transactionContext.getSiteName() == null) || (transactionContext.getSiteName().length() == 0))) {
                            transactionContext.setSiteName(tokens[3]);
                        }

                        // Set site number
                        if ((tokens.length > 4) && ((transactionContext.getSiteNumber() == null) || (transactionContext.getSiteNumber().length() == 0))) {
                            transactionContext.setSiteNumber(tokens[4]);
                        }

                        // Set BSE
                        if ((tokens.length > 5) && ((transactionContext.getBrokerSecurityToken() == null) || (transactionContext.getBrokerSecurityToken().length() == 0))) {
                            transactionContext.setBrokerSecurityToken(tokens[5]);
                        }

                        // Set access code
                        if ((tokens.length > 6) && ((transactionContext.getAccessCode() == null) || (transactionContext.getAccessCode().length() == 0))) {
                            transactionContext.setAccessCode(tokens[6]);
                        }

                        // Set verify code
                        if ((tokens.length > 7) && ((transactionContext.getVerifyCode() == null) || (transactionContext.getVerifyCode().length() == 0))) {
                            transactionContext.setVerifyCode(tokens[7]);
                        }

                        // Set security token application name
                        if ((tokens.length > 8) && ((transactionContext.getSecurityTokenApplicationName() == null) || (transactionContext.getSecurityTokenApplicationName().length() == 0))) {
                            transactionContext.setSecurityTokenApplicationName(tokens[8]);
                        }
                    } catch (Exception e) {
                        LOGGER.debug("[{}] - Failed to parse decrypted \"securityToken\" header", requestId);
                        sendAuthenticationFailedResponse(httpRequest, httpResponse, false);
                        return;
                    }

                    // Set authentication cookie
                    httpResponse.setHeader("Set-Cookie", "securityToken=" + securityToken);
                }
            } catch (Exception e) {
                LOGGER.error("Error handling applying securityToken filter", e);
                throw new ServletException("Error handling applying securityToken filter", e);
            }
        }

        LOGGER.debug("[{}] - Security token passed authentication", requestId);

        // If we've reached this point, continue the filter chain
        try {
            filterChain.doFilter(servletRequest, servletResponse);
        } catch (Throwable t) {
            LOGGER.error("Error handling filter chain", t);
            throw new ServletException("Generic exception caught by SecurityTokenFilter", t);
        }
    }

    public void destroy() {

    }

    private void sendAuthenticationFailedResponse(HttpServletRequest httpRequest, HttpServletResponse httpResponse, boolean expired) throws IOException {
        // Set response code to 401
        httpResponse.setStatus(401);

        // Get the login page (lp) if one is provided
        String providedLoginPage = httpRequest.getParameter("lp");
        if ((providedLoginPage == null) || (providedLoginPage.length() == 0)) {
            providedLoginPage = "https://"+httpRequest.getServerName()+ ":343/vix/viewer/tools";
        }

        // Write out the response
        try (OutputStream outputStream = httpResponse.getOutputStream(); Writer writer = new OutputStreamWriter(outputStream)) {
            // Generate a response based on the requested response type
            String acceptType = httpRequest.getHeader("accept");
			
			// If the header wasn't properly converted to lower-case
			if (acceptType == null) {
				acceptType = httpRequest.getHeader("Accept");
			}
			
			// Handle different types; we need to check for HTML first since Accept types can have xml in the string
            if ((acceptType != null) && (acceptType.contains("html"))) {
                writer.write((expired) ? (RESPONSE_HTML_HEADER_EXPIRED) : (RESPONSE_HTML_HEADER_FAILED));
                writer.write(StringEscapeUtils.escapeXml(providedLoginPage));
                writer.write(RESPONSE_HTML_FOOTER);
            } else if ((acceptType != null) && (acceptType.contains("json"))) {
                writer.write((expired) ? (RESPONSE_JSON_EXPIRED) : (RESPONSE_JSON_FAILED));
            } else if ((acceptType != null) && (acceptType.contains("xml"))) {
				// Default to XML since the browser should always be providing this
                writer.write((expired) ? (RESPONSE_XML_EXPIRED) : (RESPONSE_XML_FAILED));
            }

            writer.flush();
        }
    }
}