/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jan 30, 2008
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
package gov.va.med.imaging.exchange.business.taglib.series;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.Tag;

import gov.va.med.imaging.exchange.business.Series;

/**
 * @author VHAISWBECKEC
 *
 */
public abstract class AbstractSeriesTag 
extends BodyTagSupport
{
	private static final long serialVersionUID = 1L;

	protected abstract Series getSeries()
	throws JspException;
	
    @Override
    public int doStartTag() 
    throws JspException
    {
    	if(getSeries() != null)
    	{
    	    return BodyTag.EVAL_BODY_INCLUDE;
    	}
    	else
    		return Tag.SKIP_BODY;
    }
}
