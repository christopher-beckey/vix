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

import gov.va.med.imaging.BaseWebFacadeRouter;
import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.javalogs.JavaLogFile;
import gov.va.med.imaging.javalogs.JavaLogFileDateModifiedComparator;
import gov.va.med.imaging.javalogs.JavaLogFileFilenameComparator;
import gov.va.med.imaging.javalogs.JavaLogFileSizeComparator;

import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.servlet.jsp.JspException;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class JavaLogCollectionTag 
extends AbstractJavaLogCollectionTag 
{
	private static final long serialVersionUID = 1L;
	private static final Logger LOGGER = Logger.getLogger(JavaLogCollectionTag.class);
	
	private String sortOrder = JavaLogSortOrder.filename.name();
	
	/**
	 * @return the sortOrder
	 */
	public String getSortOrder() {
		return this.sortOrder;
	}

	/**
	 * @param sortOrder the sortOrder to set
	 */
	public void setSortOrder(String sortOrder) {
		this.sortOrder = sortOrder;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.taglib.javalog.AbstractJavaLogCollectionTag#getFiles()
	 */
	@Override
	protected Collection<JavaLogFile> getFiles() 
	throws JspException 
	{
		try 
    	{
        	BaseWebFacadeRouter router = null;
        	
    		try
    		{
    			router = FacadeRouterUtility.getFacadeRouter(BaseWebFacadeRouter.class);
    		} 
    		catch (Exception x)
    		{
                LOGGER.error("JavaLogCollectionTag.getfiles() --> Unable to get BaseWebFacadeRouter implementation: {}", x.getMessage());
    			throw new JspException("JavaLogCollectionTag.getfiles() --> Unable to get BaseWebFacadeRouter implementation", x);
    		}
    		
    		List<JavaLogFile> files = router.getJavaLogFiles();
    		Collections.sort(files, getComparator());
    		return files;
    	}
    	catch(Exception ex)
    	{
            LOGGER.error("JavaLogCollectionTag.getfiles() --> Unable to get list of files: {}", ex.getMessage());
			throw new JspException("JavaLogCollectionTag.getfiles() --> Unable to get list of files", ex);
    	}
	}
	
	private Comparator<JavaLogFile> getComparator()
	{
		JavaLogSortOrder order = JavaLogSortOrder.valueOf(sortOrder);
		
		if((order == null) ||
			(order == JavaLogSortOrder.filename))
			return new JavaLogFileFilenameComparator();
		if(order == JavaLogSortOrder.dateModified)
		{
			return new JavaLogFileDateModifiedComparator();
		}
		else
			return new JavaLogFileSizeComparator();
	}
}
