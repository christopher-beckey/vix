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
package gov.va.med.imaging.vixserverhealth.taglib;

import gov.va.med.imaging.utils.JspUtilities;

import java.io.IOException;
import java.io.Writer;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.Tag;
import javax.servlet.jsp.tagext.TagSupport;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractVixServerHealthViewAttributeTag 
extends BodyTagSupport 
{
	private VixServerHealthViewAttributeCollectionTag getParentCollectionTag()
	{
		return (VixServerHealthViewAttributeCollectionTag)TagSupport.findAncestorWithClass(this, VixServerHealthViewAttributeCollectionTag.class);
	}
	
	protected String getVixServerHealthAttributeKey()
	throws JspException 
	{
		VixServerHealthViewAttributeCollectionTag parent = getParentCollectionTag();
		if(parent == null)
			throw new JspException("AbstractVixServerHealthViewAttributeTag must have an ancestor VixServerHealthViewAttributeCollectionTag, and does not.");		
		return parent.getCurrentAttributeKey();
	}

	protected String getVixServerHealthAttributeValue()
	throws JspException 
	{
		VixServerHealthViewAttributeCollectionTag parent = getParentCollectionTag();
		if(parent == null)
			throw new JspException("AbstractVixServerHealthViewAttributeTag must have an ancestor VixServerHealthViewAttributeCollectionTag, and does not.");		
		return parent.getCurrentAttributeValue();
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
