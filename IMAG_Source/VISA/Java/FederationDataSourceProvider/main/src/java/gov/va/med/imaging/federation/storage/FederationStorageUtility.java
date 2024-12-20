/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 23, 2008
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
package gov.va.med.imaging.federation.storage;

import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.core.interfaces.StorageCredentials;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageConversionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ImageFormatQuality;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.enums.StorageProximity;
import gov.va.med.imaging.exchange.storage.AbstractBufferedImageStorageFacade;
import gov.va.med.imaging.exchange.storage.ByteBufferBackedImageStreamResponse;
import gov.va.med.imaging.exchange.storage.ByteBufferBackedInputStream;
import gov.va.med.imaging.federation.proxy.IFederationProxy;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationStorageUtility 
extends AbstractBufferedImageStorageFacade
{
	private final static Logger LOGGER = Logger.getLogger(FederationStorageUtility.class);
	
	private final IFederationProxy imagingProxy;
	private final Site site;
	
	public FederationStorageUtility(IFederationProxy imagingProxy, Site site)
	{
		this.imagingProxy = imagingProxy;
		this.site = site;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.storage.AbstractImageStorageFacade#openImageStream(java.lang.String, gov.va.med.imaging.core.interfaces.StorageCredentials, gov.va.med.imaging.exchange.enums.StorageProximity, gov.va.med.imaging.exchange.business.ImageFormatQualityList)
	 */
	/**
	 * Override this function for Federation because when Federation requests an image, it comes 
	 * back with the image and the TXT file in a ZIP Stream. Previously Federation was buffering
	 * both the image and the TXT stream and opening an InputStream to both files, now want to put
	 * the contents of the ZIP stream into the buffer pool without first buffering it (more efficient
	 * memory use). 
	 * 
	 * This implementation also ignores the useBuffer parameter because the input comes from a zip
	 * stream which means we have to buffer all data from Federation, so no benefit to try to not 
	 * use the buffer pool system.
	 * 
	 */
	@Override
	public ByteBufferBackedImageStreamResponse openImageStream(String imageIdentifier,
		StorageCredentials imageCredentials,
		StorageProximity imageProximity,
		ImageFormatQualityList requestFormatQualityList)
	throws ImageNearLineException, ImageNotFoundException,
		ConnectionException, ImageConversionException, MethodException
	{
		if(imageBuffer == null)
		{
			// Fortify change: moved here to enable closing in finally block
			SizedInputStream inputStream = null;
			ZipInputStream zipStream = null;

			try 
			{
				String imageId = imageIdentifier;
                LOGGER.info("FederationStorageUtility.openImageStream() --> Retrieving image [{}] from site [{}]", imageId, site.getSiteNumber());
				inputStream = imagingProxy.getInstance(imageId, requestFormatQualityList, true);
				zipStream = new ZipInputStream(inputStream.getInStream());
				
				int fileSize = imagingProxy.getFileLength();
				int txtSize = imagingProxy.getTxtLength();
				
				int dataSourceBytesReceived = 0;
				
				ZipEntry entry = zipStream.getNextEntry();
				while(entry != null)
				{
					if(entry.getName().equals("image"))
					{
                        LOGGER.info("FederationStorageUtility.openImageStream() --> Reading image from site [{}] into buffer...", site.getSiteNumber());
						// size of file will be ignored since it is read into a buffer
						// Reading into the buffer calls close on the input stream - I hope this is ok...
						imageBuffer = new FederationZipByteBufferBackedImageInputStream(zipStream, 
								fileSize, true, imagingProxy.getImageChecksum());
						dataSourceBytesReceived = imageBuffer.getSize();
						imageQuality = imagingProxy.getRequestedQuality();
					}
					else if("txt".equals(entry.getName()))
					{
                        LOGGER.info("FederationStorageUtility.openImageStream() --> Reading TXT file from site [{}] into buffer...", site.getSiteNumber());
						// JMW 3/24/09 - if the TXT file doesn't actually exist in the stream but there is an entry for it
						// need to catch when reading the TXT file - keep working since image ok
						try
						{
							txtBuffer = new FederationZipByteBufferBackedInputStream(zipStream, 
									txtSize, true, imagingProxy.getTxtChecksum());
							// if only getting text file then want to put the size in
							if(dataSourceBytesReceived <= 0)
								dataSourceBytesReceived = txtBuffer.getSize();
						}
						catch(IOException ioX)
						{
                            LOGGER.warn("FederationStorageUtility.openImageStream() --> Error reading TXT file from site [{}] into buffer, this may be caused by the TXT file not existing in the source: {}", site.getSiteNumber(), ioX.getMessage());
							txtBuffer = null;
						}								
					}
					try
					{
						entry = zipStream.getNextEntry();
					}
					catch(IOException ioX)
					{
                        LOGGER.warn("FederationStorageUtility.openImageStream() --> Error reading next entry from site [{}], this may be caused by the TXT file not existing in the source: {}", site.getSiteNumber(), ioX.getMessage());
						entry = null;
					}
				}
				
				//zipStream.close();  // moved to finally block
				TransactionContextFactory.get().setDataSourceBytesReceived((long)dataSourceBytesReceived);
			}
			catch(IOException ioX)
			{
				String msg = "FederationStorageUtility.openImageStream() --> Error reading zip response: " + ioX.getMessage();
				LOGGER.error(msg);
				throw new ConnectionException(msg, ioX);
			}
			finally
			{
	        	// Fortify change: added finally block
	        	try { if(inputStream != null) { inputStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
	        	try { if(zipStream != null) { zipStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
			}
		}
		ByteBufferBackedImageStreamResponse response = new ByteBufferBackedImageStreamResponse(imageBuffer);
		response.setImageQuality(imageQuality);
		
		if(txtBuffer != null)
		{
			response.setTxtStream(txtBuffer);
		}
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.storage.AbstractImageStorageFacade#openImageStreamInternal(java.lang.String, gov.va.med.imaging.core.interfaces.StorageCredentials, gov.va.med.imaging.exchange.enums.StorageProximity, gov.va.med.imaging.exchange.business.ImageFormatQualityList)
	 */
	@Override
	protected ByteBufferBackedImageStreamResponse openImageStreamInternal(String imageIdentifier,
		StorageCredentials imageCredentials,
		StorageProximity imageProximity,
		ImageFormatQualityList requestFormatQualityList)
	throws ImageNearLineException, ImageNotFoundException,
		ConnectionException 
	{
		LOGGER.fatal(new Exception("FederationStorageUtility.openImageStreamInternal() --> this function should NEVER be called... extreme error!"));
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.storage.AbstractImageStorageFacade#openTXTStreamInternal(java.lang.String, gov.va.med.imaging.core.interfaces.StorageCredentials, gov.va.med.imaging.exchange.enums.StorageProximity)
	 */
	@Override
	protected ByteBufferBackedInputStream openTXTStreamInternal(String imageIdentifier,
		StorageCredentials imageCredentials, StorageProximity imageProximity)
	throws ImageNearLineException, ImageNotFoundException,
		ConnectionException, MethodException
	{
		try
		{
			String imageId = imageIdentifier;
            LOGGER.info("FederationStorageUtility.openTXTStreamInternal() --> Retrieving TXT file [{}] from site [{}]", imageId, site.getSiteNumber());
			ImageFormatQualityList requestFormatQualityList = new ImageFormatQualityList();
			ImageFormatQuality txtQuality = new ImageFormatQuality(ImageFormat.TEXT_DICOM, ImageQuality.REFERENCE);
			requestFormatQualityList.add(txtQuality);
			SizedInputStream inputStream = imagingProxy.getInstance(imageId, requestFormatQualityList, true);
			//TODO: get the txt file checksum, need to return in something...
            LOGGER.info("FederationStorageUtility.openTXTStreamInternal() --> Got [{}] bytes from TXT file for image Id [{}]", inputStream == null ? "null" : inputStream.getByteSize(), imageId);
			if(inputStream == null)
				return null;
			return new ByteBufferBackedInputStream(inputStream.getInStream(), inputStream.getByteSize());
		}
		catch(ImageConversionException icX)
		{
			// this really should not happen, but in case it does, convert it to a image not found exception
			String msg = "FederationStorageUtility.openTXTStreamInternal() --> Encountered image conversion exception: " + icX.getMessage();
			LOGGER.error(msg);
			throw new ImageNotFoundException(msg, icX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.ImageStorageFacade#openPhotoId(java.lang.String, gov.va.med.imaging.core.interfaces.StorageCredentials)
	 */
	@Override
	public ByteBufferBackedInputStream openPhotoId(String imageIdentifier,
			StorageCredentials imageCredentials) 
	throws ImageNotFoundException, ConnectionException, MethodException
	{
        LOGGER.info("FederationStorageUtility.openPhotoId() --> Retrieving with photo Id [{}] from site [{}]", imageIdentifier, site.getSiteNumber());
		SizedInputStream inputStream = 
			imagingProxy.getPatientIdentifierImage(imageIdentifier, site.getSiteNumber());
        LOGGER.info("FederationStorageUtility.openPhotoId() --> Got [{}] bytes from Photo Id for patient [{}]", inputStream == null ? "null" : inputStream.getByteSize(), imageIdentifier);
		if(inputStream == null)
			return null;
		return new ByteBufferBackedInputStream(inputStream.getInStream(), inputStream.getByteSize());		
	}	
}
