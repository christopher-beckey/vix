/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 15, 2010
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
package gov.va.med.imaging.vixserverhealth.taglib;

import gov.va.med.imaging.utils.JspUtilities;
import gov.va.med.imaging.vixserverhealth.web.VixServerHealthView;

import java.io.IOException;
import java.io.Writer;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.Tag;
import javax.servlet.jsp.tagext.TagSupport;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractVixServerHealthViewPropertyTag 
extends BodyTagSupport 
{
	protected AbstractVixServerHealthTag getParentJavaLogTag()
	{
		return (AbstractVixServerHealthTag)TagSupport.findAncestorWithClass(this, AbstractVixServerHealthTag.class);
	}
	
	private final static Logger logger = Logger.getLogger(AbstractVixServerHealthViewPropertyTag.class);
	
	protected Logger getLogger()
	{
		return logger;
	}

	/**
	 * 
	 * @return
	 * @throws JspException
	 */
	protected VixServerHealthView getVixServerHealthView() 
	throws JspException
	{
		AbstractVixServerHealthTag healthViewTag = getParentJavaLogTag();
		if(healthViewTag == null)
			throw new JspException("A VIX Server Health View Property tag does not have an ancestor VIX Server Health View tag.");
		
		VixServerHealthView view = healthViewTag.getVixServerHealthView();
		
		if(view == null)
			throw new JspException("A VIX Server Health View Property tag was unable to get the filename from its parent tag.");
		
		return view;
	}
	
	protected Writer getWriter() 
	throws IOException
	{
		return pageContext.getOut();
	}
	
	public abstract String getElementValue() 
	throws JspException;

	@Override
    public int doEndTag() 
	throws JspException
    {
		JspUtilities.write(pageContext, getElementValue());
    	return Tag.EVAL_PAGE;
    }

}
