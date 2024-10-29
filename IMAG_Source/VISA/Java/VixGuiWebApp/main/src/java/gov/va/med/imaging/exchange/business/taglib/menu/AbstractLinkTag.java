/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jul 14, 2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */
package gov.va.med.imaging.exchange.business.taglib.menu;

import gov.va.med.imaging.tomcat.vistarealm.PreemptiveAuthorization;
import gov.va.med.imaging.tomcat.vistarealm.VistaRealmPrincipal;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.io.IOException;
import java.security.Principal;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.Tag;
import javax.servlet.jsp.tagext.TagSupport;

/**
 * An abstract class for creating links within the Vix web app that
 * won't create a tag if the user does not have privileges to the target.
 * 
 * @author VHAISWBECKEC
 *
 */
public abstract class AbstractLinkTag 
extends TagSupport
{
	private static final long serialVersionUID = 1L;

	protected abstract String getHref();		// returns the basic href with no query string
	protected abstract String[] getPermissableRoles(String href);
	protected abstract Map<String, String> getQueryParameters();
	
	/**
	 * 
	 * @return
	 */
	protected String getAnchorStartElement()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append("<a ");
		sb.append("href=");
		sb.append(getAbsoluteHref());
		
		Map<String, String> queryParameters = getQueryParameters();
		if(queryParameters != null && queryParameters.size() > 0)
		{
			sb.append("?");

			boolean firstQueryParameter = true;
			for(String queryParameterKey : queryParameters.keySet())
			{
				String queryParameterValue = queryParameters.get(queryParameterKey);
				if(! firstQueryParameter)
					sb.append("&");
				
				sb.append(queryParameterKey);
				sb.append("=");
				sb.append(queryParameterValue == null ? "" : "" + queryParameterValue);
				firstQueryParameter = false;
			}
		}
		
		sb.append(">");
		
		return sb.toString();
	}
	
	protected abstract String getAnchorBody();
	
	protected String getAnchorEndElement()
	{
		return "</a>";
	}
	
	protected String getAbsoluteHref()
	{
		StringBuilder sb = new StringBuilder();
		HttpServletRequest httpReq = (HttpServletRequest)(pageContext.getRequest());
				
		sb.append(getHref());
		
		return sb.toString();
	}
	
	/**
     * @see javax.servlet.jsp.tagext.TagSupport#doStartTag()
     */
    @Override
    public int doStartTag() 
    throws JspException
    {
        HttpServletRequest httpReq = null;
        
    	try
        {
            httpReq = (HttpServletRequest)pageContext.getRequest();
            Principal principal = httpReq.getUserPrincipal();
            if(principal instanceof VistaRealmPrincipal)
            {
            	VistaRealmPrincipal vrp = ((VistaRealmPrincipal)principal);
            	if( PreemptiveAuthorization.Result.False != vrp.isAuthorized(pageContext.getServletContext(), getHref(), "GET") )
            	{
        			pageContext.getOut().write(getAnchorStartElement());
        			pageContext.getOut().write(getAnchorBody());
        			pageContext.getOut().write(getAnchorEndElement());
            	}
            }
            else
            {
    			pageContext.getOut().write(getAnchorStartElement());
    			pageContext.getOut().write(getAnchorBody());
    			pageContext.getOut().write(getAnchorEndElement());
            }
        } 
    	catch (RuntimeException e)
        {
    		throw new JspException("The tag handler '" + this .getClass().getName() + "' may only run in an HTTP context");
        } 
    	catch (IOException ioX)
        {
    		throw new JspException(ioX);
        }
    	
        return Tag.EVAL_BODY_INCLUDE;
    }

}
