package gov.va.med.imaging;

import gov.va.med.imaging.url.vista.VistaConnection;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.utils.FileUtilities;
import gov.va.med.imaging.utils.XmlUtilities;
import gov.va.med.logging.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;
import java.io.*;
import java.net.URL;
import java.util.Map;
import java.util.TreeMap;

/**
 * The StsFilter provides a security filter for authenticating requests via the VA "Secure Token Service" (STS)
 */
public class StsFilter implements Filter {
    // Logger
    private static final Logger LOGGER = Logger.getLogger(StsFilter.class);

    // Vix installer configuration file name and corresponding environment variable name for VixConfig
    private static final String VIX_INSTALLER_CONFIG_FILE = "VixInstallerConfig.xml";
    private static final String VIX_CONFIG_PROPERTY_NAME = "vixconfig";
    private static final String TAG_VISTA_SERVER_NAME = "VistaServerName";
    private static final String TAG_VISTA_SERVER_PORT = "VistaServerPort";

    // Headers used for authentication
    public static final String HEADER_SECURITY_TOKEN = "xxx-securityToken";

    // Messages echoed back to the user for failures
    private static final String MESSAGE_MISSING_HEADERS = "The required HTTP headers [" + HEADER_SECURITY_TOKEN + "]  was not provided. Please provide the [" + HEADER_SECURITY_TOKEN + "] header containing a valid STS token.";
    private static final String MESSAGE_INVALID_STS_TOKEN = "The provided STS token was not valid. Please ensure the provided token is in the correct format and contains the full SOAP XML token provided by the STS service.";
    private static final String MESSAGE_SITE_CONNECTION_ERROR = "VistA could not be connected to or signed into. This could be due to VistA being unavailable, or a malformed request to VistA. Please try again later.";
    private static final String MESSAGE_REJECTED_STS_TOKEN = "The provided STS token was rejected by the authenticating VistA site. This is typically due to the token having expired. Please ensure your provided token is valid. It is recommended for users to procure a fresh STS token for each C/VIX request.";
    private static final String MESSAGE_INTERNAL_ERROR = "An unexpected, internal error was encountered. Please contact your VIX administrator or VistA Imaging team for further details.";

    // Response wrappers for HTML, XML, and JSON (chosen based on request Accept-Type)
    private static final String ERROR_RESPONSE_HTML_PREFIX = "<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>Unauthorized</title></head><body><h1>Access denied</h1><h3>";
    private static final String ERROR_RESPONSE_HTML_SUFFIX = "</h3></body></html>";
    private static final String ERROR_RESPONSE_XML_PREFIX = "<error>";
    private static final String ERROR_RESPONSE_XML_SUFFIX = "</error>";
    private static final String ERROR_RESPONSE_JSON_PREFIX = "{ \"error\" : \"";
    private static final String ERROR_RESPONSE_JSON_SUFFIX = "\" }";

    // XPath to find and retrieve the SAML Assertion from a provided STS token
    private static final String SAML_ASSERTION_XPATH = "(//*[local-name() = 'Assertion' and namespace-uri() = 'urn:oasis:names:tc:SAML:2.0:assertion'])[1]";

    // Shared values used for getting the host and port
    private static URL LOCAL_VISTA_URL = null;
    private static final Object SYNC_OBJECT = new Object();

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        if ((servletRequest instanceof HttpServletRequest) && (servletResponse instanceof HttpServletResponse)) {
            // Cast to appropriate HTTP types
            HttpServletRequest request = (HttpServletRequest) servletRequest;
            HttpServletResponse response = (HttpServletResponse) servletResponse;
            
            // Attempt to validate the STS token
            try {
                // Get the security token and auth site
                String securityTokenHeader = request.getHeader(HEADER_SECURITY_TOKEN);

                // Validate that we have non-empty values for both headers
                if ((securityTokenHeader == null) || (securityTokenHeader.trim().isEmpty())) {
                    sendErrorResponse(request, response, 400, MESSAGE_MISSING_HEADERS);
                    return;
                }

                // Get and validate the STS token
                String stsAssertion;
                try {
                    stsAssertion = getStsAssertion(securityTokenHeader);
                } catch (Exception e) {
                    sendErrorResponse(request, response, 400, MESSAGE_INVALID_STS_TOKEN);
                    return;
                }

                // Ensure we received a valid response
                if (stsAssertion == null) {
                    sendErrorResponse(request, response, 400, MESSAGE_INVALID_STS_TOKEN);
                    return;
                }

                // Get and connect to our local Vista
                VistaConnection vistaConnection = new VistaConnection(getLocalVistaUrl());
                try {
                    // Establish the connection
                    try {
                        vistaConnection.connect();
                    } catch (Exception e) {
                        LOGGER.warn("StsFilter.doFilter() --> Error encountered connecting to Vista: {}", e.getMessage());
                        sendErrorResponse(request, response, 500, MESSAGE_SITE_CONNECTION_ERROR);
                        return;
                    }

                    // Get and execute the signon query
                    try {
                        vistaConnection.call(new VistaQuery("XUS SIGNON SETUP"));
                    } catch (Exception e) {
                        LOGGER.warn("StsFilter.doFilter() --> Error encountered calling signon query: {}", e.getMessage());
                        sendErrorResponse(request, response, 500, MESSAGE_SITE_CONNECTION_ERROR);
                        return;
                    }

                    // Get and execute the STS query
                    try {
                        String queryResult = vistaConnection.call(getStsValidateQuery(stsAssertion));

                        // Validate the result
                        if ((queryResult == null) || (queryResult.contains("Unable"))) {
                            LOGGER.debug("StsFilter.doFilter() --> User failed to authenticate via STS");
                            sendErrorResponse(request, response, 401, MESSAGE_REJECTED_STS_TOKEN);
                            return;
                        }
                    } catch (Exception e) {
                        LOGGER.warn("StsFilter.doFilter() --> Error encountered calling STS query: {}", e.getMessage());
                        sendErrorResponse(request, response, 500, MESSAGE_SITE_CONNECTION_ERROR);
                        return;
                    }
                } finally {
                    // Disconnect
                    try {
                        vistaConnection.disconnect();
                    } catch (Exception e) {
                        // Ignore errors at this point
                    }
                }

                LOGGER.info("StsFilter.doFilter() --> User successfully authenticated via STS");
            } catch (Exception e) {
                // Log the generic exception
                if (LOGGER.isDebugEnabled()) {
                    LOGGER.debug("StsFilter.doFilter() --> Encountered a generic exception", e);
                } else {
                    LOGGER.warn("StsFilter.doFilter() --> Encountered a generic exception: {}", e.getMessage());

                }

                // Attempt to send a failure response
                try {
                    sendErrorResponse(request, response, 500, MESSAGE_INTERNAL_ERROR);
                    return;
                } catch (Exception e2) {
                    // Explicitly ignore
                }
            }
        }

        // If we've reached this point, continue the filter chain
        try {
            filterChain.doFilter(servletRequest, servletResponse);
        } catch (Throwable t) {
            // Only do additional logging if we have debug enabled; these should be caught by other filters
            if (LOGGER.isDebugEnabled()) {
                LOGGER.error("StsFilter.doFilter() --> Error handling filter chain", t);
            }

            // Throw a servlet exception
            throw new ServletException("Generic exception caught by StsFilter", t);
        }
    }

    private static URL getLocalVistaUrl() throws Exception {
        synchronized (SYNC_OBJECT) {
            // Return the URL if we have it
            if (LOCAL_VISTA_URL != null) {
                return LOCAL_VISTA_URL;
            }

            // Get the location of the configuration directory
            String vixConfigLocation = System.getenv(VIX_CONFIG_PROPERTY_NAME);
            if ((vixConfigLocation == null) || (vixConfigLocation.trim().isEmpty())) {
                vixConfigLocation = "C:\\VixConfig";
            }

            // Get a file handle for the installer file
            File installerConfigurationFile = FileUtilities.getFile(vixConfigLocation, VIX_INSTALLER_CONFIG_FILE);

            // Get a safe document builder from XML utilities (ensures external entities aren't resolved, etc)
            DocumentBuilder docBuilder = XmlUtilities.getSafeDocumentBuilderFactory().newDocumentBuilder();

            // Parse the document, getting the host and port
            String vistaHostName = null;
            String vistaPort = null;
            try (FileInputStream fileInputStream = new FileInputStream(installerConfigurationFile)) {
                Document document = docBuilder.parse(fileInputStream);

                for (int i = 0; i < document.getDocumentElement().getChildNodes().getLength(); ++i) {
                    Node childNode = document.getDocumentElement().getChildNodes().item(i);
                    if ((childNode.getNodeType() == Node.ELEMENT_NODE) && (TAG_VISTA_SERVER_NAME.equals(childNode.getNodeName()))) {
                        vistaHostName = childNode.getTextContent().trim();
                    } else if ((childNode.getNodeType() == Node.ELEMENT_NODE) && (TAG_VISTA_SERVER_PORT.equals(childNode.getNodeName()))) {
                        vistaPort = childNode.getTextContent().trim();
                    }
                }
            }

            // Ensure we have values
            if ((vistaHostName == null) || (vistaPort == null)) {
                throw new Exception("Missing elements to provide VistA host and port");
            }

            // Return the URL
            LOCAL_VISTA_URL = new URL("vista://" + vistaHostName + ":" + vistaPort);
            return LOCAL_VISTA_URL;
        }
    }

    /**
     * Helper method to extract "Assertion" section from the given XML of the STK token
     *
     * @param token 			whole STS token to operate from
     * @return String			"Assertion" portion only, or null
     * @throws IOException		potential exception
     *
     */
    private String getStsAssertion(String token) throws IOException {
        try {
            // Get a safe document builder from XML utilities (ensures external entities aren't resolved, etc)
            DocumentBuilder docBuilder = XmlUtilities.getSafeDocumentBuilderFactory().newDocumentBuilder();

            // Parse the document (since we're provided a String, just get the bytes from it and treat that as an input stream (inefficient))
            Document doc = docBuilder.parse(new ByteArrayInputStream(token.getBytes("UTF-8")));

            // We only want the "Assertion", so we're lazily using XPath here to fetch it out
            XPath xpath = XPathFactory.newInstance().newXPath();
            Node node = (Node) xpath.evaluate(SAML_ASSERTION_XPATH, doc, XPathConstants.NODE);

            // Write the reduced node out to a string
            if (node != null) {
                try (StringWriter stringWriter = new StringWriter()) {
                    TransformerFactory.newInstance().newTransformer().transform(new DOMSource(node), new StreamResult(stringWriter));
                    return stringWriter.toString();
                }
            }
        } catch (Exception e) {
            String msg = "StsFilter.getStsAssertion() --> Encountered exception [" + e.getClass().getSimpleName() + "] while getting 'Assertion'. Error: " + e.getMessage();
            LOGGER.warn(msg);
            throw new IOException(msg);
        }

        // If we've reached this point we have no token, so return null
        return null;
    }

    public static VistaQuery getStsValidateQuery(String stsAssertion) {
        VistaQuery vistaQuery = new VistaQuery("XUS ESSO VALIDATE");

        int index = 0;
        Map<String, String> items = new TreeMap<String, String>();

        // For "GLOBAL" type, the first parameter for the query needs to be split into sections with a maximum length of 200
        for (int i = 0; i < stsAssertion.length(); i += 200) {
            int length = Math.min(stsAssertion.length() - i, 200);
            items.put("" + index++, stsAssertion.substring(i, i + length));
        }

        vistaQuery.addParameter(VistaQuery.GLOBAL, items);

        return vistaQuery;
    }

    private void sendErrorResponse(HttpServletRequest httpRequest, HttpServletResponse httpResponse, int statusCode, String message) throws IOException {
        // Set the response code
        httpResponse.setStatus(statusCode);

        // Write out the response
        try (OutputStream outputStream = httpResponse.getOutputStream(); Writer writer = new OutputStreamWriter(outputStream)) {
            // Generate a response based on the requested response type
            String acceptType = httpRequest.getHeader("accept");

            // Handle different types; we need to check for HTML first since Accept types can have xml in the string
            if ((acceptType != null) && (acceptType.contains("html"))) {
                writer.write(ERROR_RESPONSE_HTML_PREFIX);
                writer.write(message);
                writer.write(ERROR_RESPONSE_HTML_SUFFIX);
            } else if ((acceptType != null) && (acceptType.contains("json"))) {
                writer.write(ERROR_RESPONSE_JSON_PREFIX);
                writer.write(message);
                writer.write(ERROR_RESPONSE_JSON_SUFFIX);
            } else if ((acceptType != null) && (acceptType.contains("xml"))) {
                writer.write(ERROR_RESPONSE_XML_PREFIX);
                writer.write(message);
                writer.write(ERROR_RESPONSE_XML_SUFFIX);
            } else {
                writer.write(ERROR_RESPONSE_HTML_PREFIX);
                writer.write(message);
                writer.write(ERROR_RESPONSE_HTML_SUFFIX);
            }

            writer.flush();
        }
    }


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Do nothing
    }

    @Override
    public void destroy() {
        // Do nothing
    }
}
