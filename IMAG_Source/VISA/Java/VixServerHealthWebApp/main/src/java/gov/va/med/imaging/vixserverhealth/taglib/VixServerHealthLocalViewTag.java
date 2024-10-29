/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 29, 2013
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.vixserverhealth.taglib;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.health.VixServerHealthSource;
import gov.va.med.imaging.health.VixSiteServerHealth;
import gov.va.med.imaging.vixserverhealth.VixServerHealthRouter;
import gov.va.med.imaging.vixserverhealth.web.VixServerHealthView;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.Tag;

import gov.va.med.logging.Logger;
import org.springframework.web.servlet.support.JspAwareRequestContext;
import org.springframework.web.servlet.support.RequestContext;

/**
 * @author VHAISWWERFEJ
 *
 */
public class VixServerHealthLocalViewTag
extends AbstractVixServerHealthTag 
{

private static final long serialVersionUID = 1L;
	
	private Logger logger = Logger.getLogger(this.getClass());
	
	/**
	 * {@link javax.servlet.jsp.PageContext} attribute for page-level
	 * {@link RequestContext} instance.
	 */
	public static final String REQUEST_CONTEXT_PAGE_ATTRIBUTE = "org.springframework.web.servlet.tags.REQUEST_CONTEXT";

	private RequestContext requestContext;
	private VixServerHealthView vixServerHealthView = null;
	
	/**
	 * Return the current RequestContext.
	 */
	protected synchronized final RequestContext getRequestContext()
	{
		if(this.requestContext == null)
		{
			this.requestContext = (RequestContext) this.pageContext.getAttribute(REQUEST_CONTEXT_PAGE_ATTRIBUTE);
			if (this.requestContext == null)
			{
				this.requestContext = new JspAwareRequestContext(this.pageContext);
				this.pageContext.setAttribute(REQUEST_CONTEXT_PAGE_ATTRIBUTE, this.requestContext);
			}
		}
		
		return this.requestContext;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vixserverhealth.taglib.AbstractVixServerHealthTag#getVixServerHealthView()
	 */
	@Override
	protected VixServerHealthView getVixServerHealthView() 
	throws JspException 
	{
		if(this.vixServerHealthView == null)
    	{
	        try
            {
	        	VixServerHealthRouter router;
	    		try
	    		{
	    			router = FacadeRouterUtility.getFacadeRouter(VixServerHealthRouter.class);
	    		} 
	    		catch (Exception x)
	    		{
	    			logger.error("Exception getting the facade router implementation.", x);
	    			throw new JspException(x);
	    		}
	    		
	    		VixServerHealthSource [] vixServerHealthSources = new VixServerHealthSource [] 
	    				{
	    					VixServerHealthSource.custom_tomcatLogs,
	    					VixServerHealthSource.custom_transactionLog,
	    					VixServerHealthSource.environment_variables,
	    					VixServerHealthSource.jmx
	    				};
	    		
	    		VixSiteServerHealth health = router.getLocalSiteVixSiteServerHealth(vixServerHealthSources);
				vixServerHealthView = new VixServerHealthView(health);
            } 
    		catch (Exception e)
            {
    			throw new JspException(e);
            }
    	}
    	
    	return vixServerHealthView;
	}
	
	/**
     * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
     */
    @Override
    public int doEndTag() 
    throws JspException
    {
    	vixServerHealthView = null;
	    return Tag.EVAL_PAGE;
    }
}