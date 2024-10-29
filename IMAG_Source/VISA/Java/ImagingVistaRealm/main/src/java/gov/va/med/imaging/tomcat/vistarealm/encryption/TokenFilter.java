/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Sep 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tomcat.vistarealm.encryption;

import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

/**
 * @author Julian
 *
 */
public class TokenFilter
implements Filter
{
	protected final static Logger logger = Logger.getLogger(TokenFilter.class);
	private static final byte[] UNAUTHORIZED_RESPONSE_BYTES = "<html><head><title>401: Unauthorized</title></head><body><h3>401: Unauthorized</h3><h4>Required securityToken query parameter was missing, invalid, or expired</h4></body></html>".getBytes(StandardCharsets.UTF_8);
	
	/* (non-Javadoc)
	 * @see javax.servlet.Filter#destroy()
	 */
	@Override
	public void destroy()
	{
		
	}

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
		FilterChain chain)
	throws IOException, ServletException
	{
		if ((request instanceof HttpServletRequest) && (response instanceof HttpServletResponse))
		{
			HttpServletRequest servletRequest = (HttpServletRequest)request;
			HttpServletResponse servletResponse = (HttpServletResponse) response;
			String securityToken = servletRequest.getParameter("securityToken");
            logger.debug("Security Token from URL: {}", securityToken);
			
			// Ensure we've received a token
			if (securityToken == null) {
				logger.warn("User did not provide a security token");
				throw new ServletException("No secuirtyToken was provided");
			}
			
			// Handle the token
			try
			{
				// Do some logging
				logger.info("Authenticating user with provided security token");
				if (logger.isDebugEnabled()) {
                    logger.debug("Request String [{}]", servletRequest.getRequestURL().toString());
                    logger.debug("Query String [{}]", servletRequest.getQueryString());
                    logger.debug("Security Token [{}]", securityToken);
				}
				
				// Handle some odd case
				if(securityToken.endsWith("x/x"))
				{
					securityToken = securityToken.substring(0, securityToken.length() - 4);
                    logger.debug("Security token included bad trailing characters, token now [{}]", securityToken);
				}
				
				// Decrypt (and validate) the token
				EncryptionToken.decryptUserCredentials(securityToken);
			} 
			catch (AesEncryptionException teX)
			{
				sendUnauthorizedResponse(servletResponse);
				return;
			}
		}
		chain.doFilter(request, response);
	}

	private void sendUnauthorizedResponse(HttpServletResponse response) throws ServletException {
		try {
			response.setStatus(401);
			try (ServletOutputStream servletOutputStream = response.getOutputStream()) {
				servletOutputStream.write(UNAUTHORIZED_RESPONSE_BYTES);
			}
		} catch (Exception e) {
			throw new ServletException("Unauthorized", e);
		}
	}

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
	 */
	@Override
	public void init(FilterConfig filterConfig)
	throws ServletException
	{

	}
}
