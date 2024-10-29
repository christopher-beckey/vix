/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 14, 2009
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

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

/**
 * Servlet for VistARad image access
 * 
 * When a BSE token expires, the VIX will respond with a 412 (precondition failed) error message
 * 
 * @author vhaiswwerfej
 *
 */
public class VistaRadImageAccessServlet 
extends AbstractVistaRadExamImageAccessServlet
{
	private static final long serialVersionUID = -2634830179239567029L;

	/**
	 * Constructor of the object.
	 */
	public VistaRadImageAccessServlet() {
		super();
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.web.AbstractVistaRadExamImageAccessServlet#streamExamImageInstance(gov.va.med.imaging.ImageURN, gov.va.med.imaging.exchange.enums.ImageQuality, java.util.List, java.io.OutputStream, gov.va.med.imaging.core.interfaces.ImageMetadataNotification)
	 */
	@Override
	protected long streamExamImageInstance(
		ImageURN imageUrn,
		ImageQuality requestedImageQuality,
		List<ImageFormat> acceptableResponseContent, OutputStream outStream,
		ImageMetadataNotification checksumNotification,
		boolean allowedFromCache)
	throws IOException, SecurityCredentialsExpiredException,
		ImageServletException
	{
		return streamExamImageInstanceByUrn(imageUrn, requestedImageQuality, 
			acceptableResponseContent, outStream, checksumNotification, allowedFromCache);		
	}

	/**
	 * 
	 * @param imageUrn
	 * @param requestedImageQuality
	 * @param acceptableResponseContent
	 * @param allowedFromCache
	 * @return
	 * @throws IOException
	 * @throws SecurityCredentialsExpiredException
	 * @throws ImageServletException
	 */
	protected ImageMetadata getImageMetadata(
		ImageURN imageUrn,
		ImageQuality requestedImageQuality,
		List<ImageFormat> acceptableResponseContent,
		boolean allowedFromCache)
	throws IOException, SecurityCredentialsExpiredException,
		ImageServletException
	{
		return getImageMetadataByURN(imageUrn, requestedImageQuality, acceptableResponseContent, true, allowedFromCache);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.web.AbstractVistaRadExamImageAccessServlet#getExtraOperationTypeDescription()
	 */
	@Override
	protected String getExtraOperationTypeDescription()
	{
		return "";
	}
}