/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 5, 2010
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
package gov.va.med.imaging.vistarad.web;

import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.business.ImageMetadata;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.wado.AbstractBaseImageServlet.ImageServletException;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

/**
 * Servlet to provide access to exam images (binary) only if the object is in the local cache.
 * 
 * @author vhaiswwerfej
 *
 */
public class VistaRadExamImageFromCacheAccessServlet
extends AbstractVistaRadExamImageAccessServlet
{

	/**
	 * 
	 */
	private static final long serialVersionUID = -1751947164182300570L;

	protected long streamExamImageInstance(
		ImageURN imageUrn, 
		ImageQuality requestedImageQuality,
		List<ImageFormat> acceptableResponseContent, 
		OutputStream outStream,
		ImageMetadataNotification checksumNotification,
		boolean allowedFromCache)
	throws IOException, SecurityCredentialsExpiredException, ImageServletException
	{
		return streamExamImageInstanceFromCacheByUrn(imageUrn, requestedImageQuality, 
			acceptableResponseContent, outStream, checksumNotification);
	}

	@Override
	protected ImageMetadata getImageMetadata(
		ImageURN imageUrn,
		ImageQuality requestedImageQuality,
		List<ImageFormat> acceptableResponseContent,
		boolean allowedFromCache) 
	throws IOException, SecurityCredentialsExpiredException, ImageServletException 
	{
		return getImageMetadataByURN(imageUrn, requestedImageQuality, acceptableResponseContent, false, allowedFromCache);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.web.AbstractVistaRadExamImageAccessServlet#getExtraOperationTypeDescription()
	 */
	@Override
	protected String getExtraOperationTypeDescription()
	{
		return " from cache";
	}

}
