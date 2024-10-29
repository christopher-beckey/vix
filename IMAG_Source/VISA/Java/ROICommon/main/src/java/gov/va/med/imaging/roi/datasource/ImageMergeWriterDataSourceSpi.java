/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 27, 2012
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
package gov.va.med.imaging.roi.datasource;

import java.io.OutputStream;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.datasource.annotations.SPI;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.storage.DataSourceImageInputStream;

/**
 * @author VHAISWWERFEJ
 *
 */
@SPI(description="The service provider interface for merging images into a single image, usually a PDF")
public interface ImageMergeWriterDataSourceSpi
extends VersionableDataSourceSpi
{
	/**
	 * Ask the SPI for an output stream to write the specified object to
	 * @param groupIdentifier a unique identifier for the group of objects
	 * @param objectIdentifier a unique identifier within a group of objects
	 * @return an open output stream to write the object to
	 * @throws ConnectionException
	 * @throws MethodException
	 */
	public OutputStream getOutputStream(String groupIdentifier, String objectIdentifier, ImageFormat imageFormat, String objectDescription)
	throws ConnectionException, MethodException;
	
	/**
	 * When all of the objects have been written, call this to merge the objects in the specified group
	 * 
	 * @param groupIdentifier
	 * @return
	 * @throws ConnectionException
	 * @throws MethodException
	 */
	public DataSourceImageInputStream mergeObjects(String groupIdentifier, Patient patient)
	throws ConnectionException, MethodException;

}
