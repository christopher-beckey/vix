/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 16, 2009
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
package gov.va.med.imaging.exchange.business.taglib.javalog;

import java.text.DecimalFormat;

import gov.va.med.imaging.javalogs.JavaLogFile;

import javax.servlet.jsp.JspException;

/**
 * Tag to get the file size of a java log file
 * 
 * @author vhaiswwerfej
 *
 */
public class JavaLogFileSizeTag 
extends AbstractJavaLogPropertyTag 
{
	private static final long serialVersionUID = 1L;

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.taglib.javalog.AbstractJavaLogPropertyTag#getElementValue()
	 */
	@Override
	public String getElementValue() 
	throws JspException 
	{
		JavaLogFile file = getFile();
		return (file == null ? "" : "" + formatBytes(file.getFileSize()));
	}
	
	private String formatBytes(long bytes)
	{
		DecimalFormat format = new DecimalFormat("#.00");
		if (bytes < 1024)
        {
            return bytes + " bytes";
        }
        double kb = (double)bytes / 1024.0f;
        double mb = kb / 1024.0f;
        double gb = mb / 1024.0f;
        double tb = gb / 1024.0f;

        if (tb > 1.0)
        {
        	return format.format(tb) + " TB";
        }
        else if (gb > 1.0)
        {
        	return format.format(gb) + " GB";
        }
        else if (mb > 1.0)
        {
            return format.format(mb) + " MB";
        }
        else
        {
            return format.format(kb) + " KB";
        }
	}
}
