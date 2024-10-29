/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 21, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.vixserverhealth.configuration.taglib;

import gov.va.med.imaging.vixserverhealth.configuration.VixServerHealthWebAppConfiguration;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.TagSupport;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractVixServerHealthConfigurationTag 
extends TagSupport 
{
	private VixServerHealthWebAppConfiguration configuration;
	
	protected abstract VixServerHealthWebAppConfiguration getVixServerHealthWebAppConfiguration()
	throws JspException;

	@Override
    public int doStartTag() 
	throws JspException
    {
		configuration = getVixServerHealthWebAppConfiguration();
		return configuration == null ? BodyTag.SKIP_BODY : BodyTag.EVAL_BODY_INCLUDE;
    }

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.TagSupport#doEndTag()
	 */
	@Override
	public int doEndTag() 
	throws JspException 
	{
		configuration = null;
		return super.doEndTag();
	}	
}
