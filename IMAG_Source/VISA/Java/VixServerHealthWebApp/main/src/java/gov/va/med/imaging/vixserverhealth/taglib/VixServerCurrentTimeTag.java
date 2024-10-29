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
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.BodyTagSupport;
import javax.servlet.jsp.tagext.Tag;

/**
 * @author vhaiswwerfej
 *
 */
public class VixServerCurrentTimeTag 
extends BodyTagSupport 
{
	private static final long serialVersionUID = 1L;
	
	protected Writer getWriter() 
	throws IOException
	{
		return pageContext.getOut();
	}
	
	@Override
    public int doEndTag() 
	throws JspException
    {
		SimpleDateFormat format = getDateFormat();
		Calendar now = Calendar.getInstance();
		JspUtilities.write(pageContext, format.format(now.getTime()));

    	return Tag.EVAL_PAGE;
    }
	
	private SimpleDateFormat getDateFormat()
	{
		return new SimpleDateFormat("MMM d, yyyy h:mm:ss aa");
	}

}
