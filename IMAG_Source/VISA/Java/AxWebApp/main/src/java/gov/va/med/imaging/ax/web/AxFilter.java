/**
 * 
  Property of ISI Group, LLC
  Date Created: May 12, 2014
  Developer:  Julian Werfel
 */
package gov.va.med.imaging.ax.web;

import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;
import gov.va.med.imaging.tomcat.vistarealm.encryption.EncryptionToken;
import gov.va.med.imaging.tomcat.vistarealm.encryption.TokenExpiredException;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import gov.va.med.logging.Logger;

/**
 * @author Julian Werfel
 *
 */
public class AxFilter
implements Filter
{

	private final static Logger LOGGER = Logger.getLogger(AxFilter.class);
	
	/* (non-Javadoc)
	 * @see javax.servlet.Filter#destroy()
	 */
	@Override
	public void destroy() {}

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#doFilter(javax.servlet.ServletRequest, javax.servlet.ServletResponse, javax.servlet.FilterChain)
	 */
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
	throws IOException, ServletException
	{
		if(request instanceof HttpServletRequest)
		{
			HttpServletRequest servletRequest = (HttpServletRequest)request;
			String securityToken = servletRequest.getParameter("securityToken");
			if(securityToken != null && securityToken.length() > 0)
			{
				try
				{
					EncryptionToken.decryptUserCredentials(securityToken);
				} 
				catch(TokenExpiredException teX)
				{
                    LOGGER.error("AxFilter.doFilter() --> Security token has expired: {}", teX.getMessage());
					throw new ServletException("Security Token has expired");
				}
				catch (AesEncryptionException aesX)
				{
                    LOGGER.error("AxFilter.doFilter() --> Encountered encryption problem: {}", aesX.getMessage());
					throw new ServletException("AxFilter.doFilter() --> Encountered encryption problem");
				}
			}
		}
		chain.doFilter(request, response);
	}

	/* (non-Javadoc)
	 * @see javax.servlet.Filter#init(javax.servlet.FilterConfig)
	 */
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {}
}
