/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 26, 2008
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
package gov.va.med.imaging.exchange.storage;

import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.core.interfaces.StorageCredentials;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageConversionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.enums.StorageProximity;
import gov.va.med.imaging.exchange.proxy.ExchangeProxy;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ExchangeStorageUtility 
extends AbstractBufferedImageStorageFacade
{
	private final ExchangeProxy imagingProxy;
	
	public ExchangeStorageUtility(ExchangeProxy imagingProxy)
	{
		this.imagingProxy = imagingProxy;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.storage.AbstractBufferedImageStorageFacade#openImageStreamInternal(java.lang.String, gov.va.med.imaging.core.interfaces.StorageCredentials, gov.va.med.imaging.exchange.enums.StorageProximity, gov.va.med.imaging.exchange.business.ImageFormatQualityList)
	 */
	@Override
	protected ByteBufferBackedImageStreamResponse openImageStreamInternal(
		String imageIdentifier, StorageCredentials imageCredentials,
		StorageProximity imageProximity,
		ImageFormatQualityList requestFormatQualityList)
	throws ImageNearLineException, ImageNotFoundException,
		ConnectionException, ImageConversionException, MethodException
	{	
		SizedInputStream sizedStream = imagingProxy.getInstance(imageIdentifier, requestFormatQualityList, false);
		if(sizedStream == null)
			throw new ImageNotFoundException("No input stream returned from Exchange source [" + imagingProxy.getImageProxyService() + "] for image [" + imageIdentifier + "].");
		
		// JMW 3/21/2011 P104 - changed call to create new ByteBufferBackedImageInputStream to detect if the input stream
		// is an empty stream. 
		// If the stream is empty, then throw a new ImageNotFoundException to prevent the empty image from being used and cached	
		ByteBufferBackedImageInputStream imageInputStream = new ByteBufferBackedImageInputStream(
				sizedStream.getInStream(), sizedStream.getByteSize(), imagingProxy.getResponseChecksum(), true);
		if(imageInputStream.isEmptyStream())
			throw new ImageNotFoundException("Detected 0 length input stream response from Exchange for image '" + imageIdentifier + "'.");
		
		ByteBufferBackedImageStreamResponse response = 
			new ByteBufferBackedImageStreamResponse(imageInputStream);
		response.setImageQuality(imagingProxy.getRequestedQuality());
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.storage.AbstractBufferedImageStorageFacade#openTXTStreamInternal(java.lang.String, gov.va.med.imaging.core.interfaces.StorageCredentials, gov.va.med.imaging.exchange.enums.StorageProximity)
	 */
	@Override
	protected ByteBufferBackedInputStream openTXTStreamInternal(String imageIdentifier,
		StorageCredentials imageCredentials, StorageProximity imageProximity)
	throws ImageNearLineException, ImageNotFoundException,
		ConnectionException 
	{
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.ImageStorageFacade#openPhotoId(java.lang.String, gov.va.med.imaging.core.interfaces.StorageCredentials)
	 */
	@Override
	public ByteBufferBackedInputStream openPhotoId(String imageIdentifier,
			StorageCredentials imageCredentials) 
	throws ImageNotFoundException, ConnectionException {
		
		return null;
	}
}
