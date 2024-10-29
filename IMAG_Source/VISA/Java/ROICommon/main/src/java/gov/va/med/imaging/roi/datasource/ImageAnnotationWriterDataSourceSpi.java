/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 22, 2012
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

import java.io.InputStream;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.datasource.annotations.SPI;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationDetails;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;

/**
 * @author VHAISWWERFEJ
 *
 */
@SPI(description="The service provider interface for writing image annotations to an image")
public interface ImageAnnotationWriterDataSourceSpi
extends VersionableDataSourceSpi
{
	
	/**
	 * 
	 * @param inputStream Input stream to raw image
	 * @param imageAnnotationDetails Annotation details to write to the image
	 * @return
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	public DataSourceInputStream burnImageAnnotations(InputStream inputStream, ImageFormat imageFormat, 
			ImageAnnotationDetails imageAnnotationDetails)
	throws MethodException, ConnectionException;

}
