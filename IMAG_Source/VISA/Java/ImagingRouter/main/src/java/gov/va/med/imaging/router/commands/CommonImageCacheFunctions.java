/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 29, 2009
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
package gov.va.med.imaging.router.commands;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.imaging.DocumentURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.core.StreamImageFromCacheResponse;
import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.core.interfaces.StorageCredentials;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.commands.configuration.CommandConfiguration;
import gov.va.med.imaging.exchange.business.ImageFormatQuality;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.PatientPhotoIDInformation;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.storage.ByteBufferBackedInputStream;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;
import gov.va.med.imaging.exchange.storage.cache.ImmutableInstance;
import gov.va.med.imaging.router.commands.provider.ImagingCommandContext;
import gov.va.med.imaging.storage.cache.InstanceReadableByteChannel;
import gov.va.med.imaging.storage.cache.InstanceReadableVO;
import gov.va.med.imaging.storage.cache.InstanceWritableByteChannel;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;
import gov.va.med.imaging.storage.cache.exceptions.InstanceInaccessibleException;
import gov.va.med.imaging.storage.cache.exceptions.InstanceUnavailableException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.image.ImagingStorageCredentials;
import gov.va.med.imaging.vista.storage.SmbStorageUtility;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.Channels;
import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class CommonImageCacheFunctions 
{
	private final static Logger logger = Logger.getLogger(CommonImageCacheFunctions.class);
	
	/**
	 * @return the logger
	 */
	protected static Logger getLogger() {
		return logger;
	}

	/**
	 * Caches a TXT file.
	 * @param imageUrn
	 * @param txtStream
	 * @param returnStreamToFile Determines if the TXT file from the cache is reopened. 
	 * 	If so then the cache instance needs to be closed or it prevents others from accessing the cache instance
	 * @return null if not needed access to cached TXT file, or opened stream to cached TXT file
	 */
	public static DataSourceInputStream cacheTXTFile(ImagingCommandContext commandContext, 
			ImageURN imageUrn, DataSourceInputStream txtStream, boolean returnStreamToFile)
	{
		if(commandContext.isCachingEnabled()) 
		{

            getLogger().info("About to cache text file for image [{}]", imageUrn.toString());
			if(txtStream == null)
			{
				getLogger().info("txtStream is null, cannot cache text file");
				return null;			
			}
			InputStream textStream = txtStream.getInputStream();
			try {
				if (textStream == null) {
					getLogger().info("input stream in txtStream is null, cannot cache text file");
					return txtStream;
				}
                getLogger().info("Caching txt file for image Urn [{}]", imageUrn.toString());
				String imageQuality = ImageQuality.REFERENCE.name();
				String contentType = ImageFormat.TEXT_DICOM.getMime();
				String siteNumber = imageUrn.getOriginatingSiteId();
				ImmutableInstance instance = null;
				InstanceWritableByteChannel instanceWritableChannel = null;
				OutputStream cacheOutStream = null;
				try {
					if (ExchangeUtil.isSiteDOD(siteNumber)) {
						instance = commandContext.getExtraEnterpriseCache().createImage(imageUrn, imageQuality, contentType);
					} else {
						instance = commandContext.getIntraEnterpriseCacheCache().createImage(imageUrn, imageQuality, contentType);
					}

					instanceWritableChannel = instance.getWritableChannel();
					cacheOutStream = Channels.newOutputStream(instanceWritableChannel);
					try {
						ByteStreamPump pump = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.NetworkToNetwork);
						// if the cacheStream is null the ByteStreamPump will ignore it
						pump.xfer(textStream, cacheOutStream);
						if (textStream != null) {
							getLogger().debug("Closing txt input stream after writing to the cache");
							textStream.close();
						}
						cacheOutStream.close();
						getLogger().info("TXT file cached.");
						if (returnStreamToFile) {
							InputStream cacheInputStream = null;
							if (ExchangeUtil.isSiteDOD(siteNumber)) {
								instance = commandContext.getExtraEnterpriseCache().getImage(imageUrn, imageQuality, contentType);
							} else {
								instance = commandContext.getIntraEnterpriseCacheCache().getImage(imageUrn, imageQuality, contentType);
							}
							cacheInputStream = Channels.newInputStream(instance.getReadableChannel());
							getLogger().info("Returning stream to cached TXT file");

							return new ByteBufferBackedInputStream(cacheInputStream, (int) instance.getSize());
						} else {
							return null;
						}
					} finally {
						if (cacheOutStream != null) {
							try {
								cacheOutStream.close();
							} catch (Exception e) {
								// Ignore
							}
						}
					}
				} catch (InstanceInaccessibleException iaX) {
					// special exception handling, another thread is requesting to write to the instance
					// just before we did.  Try once again to read from the cache, our thread will be held until
					// the write is complete
					getLogger().debug(iaX);
					return txtStream;
				} catch (CacheException cX) {
					// any kind of cache exceptions should be logged, but the image must still be retreived from the DoD
					// from here on if cacheOutStream is not null we'll write to it
					getLogger().error(cX);
					instance = null;
					instanceWritableChannel = null;
					cacheOutStream = null;
				} catch (IOException ioX) {
					getLogger().error(ioX);
				}
			} finally {
				if (textStream != null) {
					try {
						textStream.close();
					} catch (Exception e) {
						// Ignore
					}
				}
			}
		}
		
		return null;
	}
	
	public static boolean isImageCached(ImagingCommandContext commandContext,
			ImageURN imageUrn, 
			ImageFormatQualityList requestAcceptList)
	{
		for(ImageFormatQuality requestQuality : requestAcceptList)
		{
			if(isImageCached(commandContext, imageUrn, requestQuality.getImageFormat(), requestQuality.getImageQuality()))
				return true;
		}
		return false;
	}
	
	/**
	 * If the instance is available in cache then stream it from there,
	 * else reurn null.
	 * This method will deal with retries if it gets cache exceptions that may be transient.
	 * 
	 * @param studyId
	 * @param imageId
	 * @param iQuality
	 * @param targetFormat
	 * @param outStream
	 * @return
	 * @throws IOException
	 */
	public static StreamImageFromCacheResponse streamImageFromCache(
			ImagingCommandContext commandContext,
			ImageURN imageUrn, 
			ImageFormatQualityList requestAcceptList,
			OutputStream outStream,
			ImageMetadataNotification callback)
	throws IOException
	{
		return streamImageFromCache(
				commandContext,
				imageUrn, 
				requestAcceptList,
				outStream,
				callback,
				false);
	}
	
	public static StreamImageFromCacheResponse streamImageFromCache(
			ImagingCommandContext commandContext,
			ImageURN imageUrn, 
			ImageFormatQualityList requestAcceptList,
			OutputStream outStream,
			ImageMetadataNotification callback,
			Boolean updateImageLocation)
	throws IOException
	{
		//WFP-put If folder Exist method call here.
		boolean isStudyFolderExist = isImageFilesCached(commandContext, imageUrn);

		if(isStudyFolderExist){
			for(ImageFormatQuality requestQuality : requestAcceptList)
			{
				int bytes = streamImageFromCache(
						commandContext, imageUrn, requestQuality.getImageFormat(), 
						requestQuality.getImageQuality(), outStream, callback, updateImageLocation);
				if(bytes > 0)
				{
					StreamImageFromCacheResponse response = new StreamImageFromCacheResponse(null, bytes, requestQuality);
					return response;
				}
			}
		}
		return null;
	}
	
	/**
	 * Determines if the image specified is already in the cache. It does not retrieve the image from the
	 * cache if it is there.
	 * 
	 * @param commandContext
	 * @param imageUrn
	 * @param imageFormat
	 * @param imageQuality
	 * @return
	 */
	public static boolean isImageCached(
			ImagingCommandContext commandContext,
			ImageURN imageUrn, 
			ImageFormat imageFormat,
			ImageQuality imageQuality)
	{
		boolean imageCached = false;
		
		ImmutableInstance instance = getImmutableInstance(commandContext, imageUrn, imageQuality, imageFormat.getMimeWithEnclosedMime());
		if(instance != null)
			imageCached = true;

		return imageCached;
	}
	
	public static ImageCacheResult getImageCachedResult(ImagingCommandContext commandContext,
		ImageURN imageUrn, 
		ImageFormatQualityList requestAcceptList)
	{
		List<ImageURN> urns = RegionalStorageCommonFunctions.getUrnsToSearchCacheFor(imageUrn, commandContext);
		
		for(ImageFormatQuality requestQuality : requestAcceptList)
		{
			for(ImageURN urn : urns)
			{
				if(isImageCached(commandContext, urn, requestQuality.getImageFormat(), requestQuality.getImageQuality()))
				{
					TransactionContextFactory.get().addDebugInformation("Found image [" + urn.toString(SERIALIZATION_FORMAT.RAW) + "] in cache with quality [" + requestQuality.getImageQuality() + "] and format [" + requestQuality.getImageFormat() + "] in cache");
					return new ImageCacheResult(urn, requestQuality.getImageFormat(), requestQuality.getImageQuality());
				}
			}
		}
		return null;
	}
	
	public static boolean isDocumentCached(
		ImagingCommandContext commandContext,
		DocumentURN documentUrn)
	{
		
		
		
		return false;
	}

	/**
	 * 
	 * @param commandContext
	 * @param imageUrn
	 * @param requestAcceptList
	 * @param imageMetadata
	 * @return
	 * @throws IOException
	 */
	public static boolean populateImageMetadata(
		ImagingCommandContext commandContext,
		ImageURN imageUrn, 
		ImageFormatQualityList requestAcceptList,
		ImageMetadataNotification imageMetadata)
	throws IOException
	{
		// see if any of the accept types are available in cache
		// return the metadat about the first since they are in preference order
		for(ImageFormatQuality requestQuality : requestAcceptList)
			if( populateImageMetadata(
				commandContext, imageUrn, requestQuality.getImageFormat(), 
				requestQuality.getImageQuality(), imageMetadata) )
					return true;
		
		return false;
	}
	
	/**
	 * 
	 * @param commandContext
	 * @param imageUrn
	 * @param requestAcceptList
	 * @param imageMetadata
	 * @return
	 * @throws IOException
	 */
	public static boolean populateImageMetadata(
		ImagingCommandContext commandContext,
		ImageCacheResult imageCacheResult,
		ImageMetadataNotification imageMetadata)
	throws IOException
	{
			if( populateImageMetadata(
				commandContext, imageCacheResult.getImageUrn(), imageCacheResult.getImageFormat(), 
					imageCacheResult.getImageQuality(), imageMetadata) )
					return true;
		
		return false;
	}

	
	/**
	 * Populate a ImageMetadataNotification instance with the 
	 * format, checksum and the image quality.
	 * 
	 * @param commandContext
	 * @param imageUrn
	 * @param imageFormat
	 * @param imageQuality
	 * @param imageMetadata
	 */
	public static boolean populateImageMetadata(
		ImagingCommandContext commandContext,
		ImageURN imageUrn, 
		ImageFormat imageFormat,
		ImageQuality imageQuality,
		ImageMetadataNotification imageMetadata)
	{
		InstanceReadableVO readableVO = getImageReadableChannelFromCache(
			commandContext, imageUrn, 
			imageQuality, imageFormat.getMimeWithEnclosedMime()
		);
		
		if(readableVO != null)
		{
			InstanceReadableByteChannel cacheReadChannel = readableVO.getReadByteChannel();
			if ((cacheReadChannel != null) && (cacheReadChannel.getCacheFile() != null)) {
				String cacheFilename = cacheReadChannel.getCacheFile().getAbsolutePath();
				TransactionContextFactory.get().setCacheFilename(cacheFilename);
                getLogger().debug("populateImageMetadata - Cache Filename = {}", cacheFilename);
			}

			imageMetadata.imageMetadata(readableVO.getChecksumValue(), imageFormat, 0, imageQuality);
			try{readableVO.getReadByteChannel().close();}
			catch(IOException ioX){}		// just eat the exception
			return true;
		}
		
		return false;
	}
	
	/**
	 * 
	 * @param commandContext
	 * @param imageUrn
	 * @param imageFormat
	 * @param imageQuality
	 * @param outStream
	 * @param callback
	 * @return
	 * @throws IOException
	 */
	public static int streamImageFromCache(
			ImagingCommandContext commandContext,
			ImageURN imageUrn, 
			ImageFormat imageFormat,
			ImageQuality imageQuality,
			OutputStream outStream,
			ImageMetadataNotification callback)
	throws IOException
	{
		return streamImageFromCache(
				commandContext,
				imageUrn, 
				imageFormat,
				imageQuality,
				outStream,
				callback,
				false);
	}
	
	public static int streamImageFromCache(
			ImagingCommandContext commandContext,
			ImageURN imageUrn, 
			ImageFormat imageFormat,
			ImageQuality imageQuality,
			OutputStream outStream,
			ImageMetadataNotification callback,
			Boolean updateImageLocation)
	throws IOException
	{
		String siteNumber = imageUrn.getOriginatingSiteId();

        getLogger().info("Searching cache for image [{}] with format [{}] and quality [{}]", imageUrn.toString(SERIALIZATION_FORMAT.RAW), imageFormat, imageQuality);
		int bytesOut = 0;		// return value indicates how many bytes were sent.
		InstanceReadableVO readableVO = getImageReadableChannelFromCache(
				commandContext, imageUrn, 
				imageQuality, imageFormat.getMimeWithEnclosedMime());
		InstanceReadableByteChannel cacheReadChannel = (readableVO == null ? null : readableVO.getReadByteChannel());
		
		if(readableVO != null && cacheReadChannel != null)
		{
			// image is in the cache and we have a usable ReadableByteChannel, 
			// notify the checksum notification listener if it exists
			//TODO: actually know the file length and set it here so that we can respond with the correct file length!
			String cacheFilename = null;
			
			if ((cacheReadChannel != null) && (cacheReadChannel.getCacheFile() != null)) {
				cacheFilename = cacheReadChannel.getCacheFile().getAbsolutePath();
				TransactionContextFactory.get().setCacheFilename(cacheFilename);
                getLogger().debug("streamImageFromCache - Cache Filename = {}", cacheFilename);
			}
			
			String checksum = readableVO.getChecksumValue();

			if(callback != null)
				callback.imageMetadata(checksum, imageFormat, 0, imageQuality);

			//If HEAD request coming from viewer, no need to return stream
			if (isViewerHeadRequest(siteNumber))
				return 0;

			// image is in the cache and we have a usable ReadableByteChannel, stream the image
			InputStream cacheInStream = Channels.newInputStream(cacheReadChannel);

			// get a byte stream pump from file (cache) to network (client)
			ByteStreamPump pump = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.FileToNetwork);
			// once we start the transfer we are committed to reading from the cache, 
			// i.e. failures result in errors, not retries from DOD
			try
			{
				//WFP-implement time stamping at a later time.
				//long startFromCacheTime = System.currentTimeMillis();
				bytesOut=pump.xfer(cacheInStream, outStream);
				//long endFromCacheTime = System.currentTimeMillis();
				//long duration = endFromCacheTime - startFromCacheTime;
				//TransactionContextFactory.get().setStreamingResponseDuration( duration );
                getLogger().debug("Pumped [{}] bytes to output stream", bytesOut);
			}
			catch(IOException ioX) 
			{
				getLogger().error(ioX); 
				throw ioX;
			}
			catch(IllegalArgumentException iaX)
			{
				getLogger().error(iaX);
				bytesOut = 0;
			}
			finally
			{
				try{cacheInStream.close();}
				catch(IOException ioX)
				{
                    getLogger().warn("IOException caught when closing '{}-{}', channel may have been closed earlier with a timeout.", imageUrn.toString(), imageQuality);
				}
			}
		}

        getLogger().debug("Returning [{}] bytes", bytesOut);
		return bytesOut;
	}
	
	
	public static boolean isViewerHeadRequest(String siteNumber)
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		boolean isViewerHeadRequest = (transactionContext.isViewerHeadRequest() == null ? false : transactionContext.isViewerHeadRequest());
		isViewerHeadRequest = (
				isViewerHeadRequest && 
				transactionContext.getSiteNumber().equals(siteNumber) &&
				(transactionContext.getCacheFilename() != null)
		);
        getLogger().debug("Is Viewer Head Request: {} Cached Filename={}", isViewerHeadRequest, transactionContext.getCacheFilename());
		return isViewerHeadRequest;
	}
	

	
	// ========================================================================================================
	// parameters affecting the retries for cache access
	// ========================================================================================================
	public final static int cacheReadRetry = 3;
	public final static int cacheReadRetryDelay = 200;		// milliseconds to wait between read attempts

	
	/**
	 * Get the requested image from the cache if it exists.
	 * If the image is found then the content will be written to the given output stream
	 * by the time this method returns.
	 * 
	 * NOTE: this method does NOT check the app configuration for whether caching is enabled.
	 * 
	 * @param imageUrn
	 * @param imageQuality
	 * @param targetFormat
	 * @return
	 */
	private static InstanceReadableVO getImageReadableChannelFromCache(
			ImagingCommandContext commandContext,
			ImageURN imageUrn, 
			ImageQuality imageQuality,
			String targetFormat)
	{		
		try
		{
			ImmutableInstance instance = getImmutableInstance(commandContext, imageUrn, imageQuality, targetFormat);
			
			// try to get image from Cache
			for( int retryCount = 0; instance != null && retryCount < cacheReadRetry; ++retryCount) 
			{
                getLogger().info("Image '{}' in cache, returning readable byte channel.", imageUrn.toString());

				// try block for retry-able exceptions
				try 
				{
					InstanceReadableByteChannel result = instance.getReadableChannel();
					String checksumValue = instance.getChecksumValue();

                    getLogger().info("InstanceReadableByteChannel obtained on retry #{}.", retryCount);
					return new InstanceReadableVO(result, checksumValue);
				}
				// cache access resulting in an InstanceUnavailableException may be reasonably retried
				catch (InstanceUnavailableException iue) 
				{
                    getLogger().info("InstanceUnavailableException caught (#{}{}{}", retryCount, (retryCount < cacheReadRetry) ? " -> retry): " : " FAILING): ", iue.getMessage());
					try
					{
						Thread.sleep(cacheReadRetryDelay);
					} 
					catch (InterruptedException x)
					{
						getLogger().warn(x);
						return null;
					}
				}
			}
		}

		// =============================================================================================
		// these exceptions should elicit an immediate exit, no retries cause it won't do any good
		// =============================================================================================
		// caught when the writing thread still has the file locked
		// I don't see that a retry should be done here because the
		// cache has already held this thread waiting for the writable channel to close.  
		// A retry just effectively lengthens the wait time that the cache already implements.
		// InstanceWritableChannelOpenException
		catch (InstanceInaccessibleException idne) 
		{
			getLogger().error(idne);
		}
		catch(CacheException cX) 
		{
			getLogger().error(cX);
		}

		return null;
	}
	
	private static InstanceReadableVO getPatientPhotoImageReadableChannelFromCache(
			ImagingCommandContext commandContext,
			String siteNumber,
			PatientIdentifier patientIdentifier)
	{		
		try
		{
			ImmutableInstance instance = getPatientPhotoImmutableInstance(commandContext, siteNumber, patientIdentifier);
			
			// try to get image from Cache
			for( int retryCount = 0; instance != null && retryCount < cacheReadRetry; ++retryCount) 
			{
                getLogger().info("Patient photo image for patient '{}' from site '{}' in cache, returning readable byte channel.", patientIdentifier, siteNumber);

				// try block for retry-able exceptions
				try 
				{
					InstanceReadableByteChannel result = instance.getReadableChannel();
					String checksumValue = instance.getChecksumValue();

                    getLogger().info("InstanceReadableByteChannel obtained on retry #{}.", retryCount);
					return new InstanceReadableVO(result, checksumValue);
				}
				// cache access resulting in an InstanceUnavailableException may be reasonably retried
				catch (InstanceUnavailableException iue) 
				{
                    getLogger().info("InstanceUnavailableException caught (#{}{}{}", retryCount, (retryCount < cacheReadRetry) ? " -> retry): " : " FAILING): ", iue.getMessage());
					try
					{
						Thread.sleep(cacheReadRetryDelay);
					} 
					catch (InterruptedException x)
					{
						getLogger().warn(x);
						return null;
					}
				}
			}
		}

		// =============================================================================================
		// these exceptions should elicit an immediate exit, no retries cause it won't do any good
		// =============================================================================================
		// caught when the writing thread still has the file locked
		// I don't see that a retry should be done here because the
		// cache has already held this thread waiting for the writable channel to close.  
		// A retry just effectively lengthens the wait time that the cache already implements.
		// InstanceWritableChannelOpenException
		catch (InstanceInaccessibleException idne) 
		{
			getLogger().error(idne);
		}
		catch(CacheException cX) 
		{
			getLogger().error(cX);
		}

		return null;
	}
	
	private static InstanceReadableVO getPatientPhotoImageReadableChannelFromCache(
			ImagingCommandContext commandContext,
			ImageURN imageUrn, ImageFormat imageFormat)
	{		
		try
		{
			ImmutableInstance instance = getPatientPhotoImmutableInstance(commandContext, imageUrn, imageFormat);
			
			// try to get image from Cache
			for( int retryCount = 0; instance != null && retryCount < cacheReadRetry; ++retryCount) 
			{
                getLogger().info("Patient photo image [{}] in cache, returning readable byte channel.", imageUrn.toString(SERIALIZATION_FORMAT.RAW));

				// try block for retry-able exceptions
				try 
				{
					InstanceReadableByteChannel result = instance.getReadableChannel();
					String checksumValue = instance.getChecksumValue();

                    getLogger().info("InstanceReadableByteChannel obtained on retry #{}.", retryCount);
					return new InstanceReadableVO(result, checksumValue);
				}
				// cache access resulting in an InstanceUnavailableException may be reasonably retried
				catch (InstanceUnavailableException iue) 
				{
                    getLogger().info("InstanceUnavailableException caught (#{}{}{}", retryCount, (retryCount < cacheReadRetry) ? " -> retry): " : " FAILING): ", iue.getMessage());
					try
					{
						Thread.sleep(cacheReadRetryDelay);
					} 
					catch (InterruptedException x)
					{
						getLogger().warn(x);
						return null;
					}
				}
			}
		}
		// =============================================================================================
		// these exceptions should elicit an immediate exit, no retries cause it won't do any good
		// =============================================================================================
		// caught when the writing thread still has the file locked
		// I don't see that a retry should be done here because the
		// cache has already held this thread waiting for the writable channel to close.  
		// A retry just effectively lengthens the wait time that the cache already implements.
		// InstanceWritableChannelOpenException
		catch (InstanceInaccessibleException idne) 
		{
			getLogger().error(idne);
		}
		catch(CacheException cX) 
		{
			getLogger().error(cX);
		}

		return null;
	}

	
	/**
	 * This method finds an instance in the cache that has the URN and is compatible with the
	 * format and quality requested.
	 * 
	 * @param imageUrn
	 * @param imageQuality
	 * @param targetFormat
	 * @return
	 */
	public static ImmutableInstance getImmutableInstance(
			ImagingCommandContext commandContext,
			ImageURN imageUrn, 
			ImageQuality imageQuality,
			String targetFormat)
	{
		String studyId = imageUrn.getStudyId();
		String imageId = imageUrn.getImageId();
		ImmutableInstance instance = null;

		// JMW 3/3/2010 - if the request was for a diagnostic quality image but the responding site gave us a diagnostic uncompressed image, 
		//	that should be used.
		// this occurs if the remote site stored a DICOM image, it won't get compressed/converted but it should be reused.
		// now create a list of possible qualities to search for.  This only applies for diagnostic images - NOT reference
		List<ImageQuality> allowedQualities = new ArrayList<ImageQuality>();
		allowedQualities.add(imageQuality); // add the initial quality and make sure it is first
		// only allowed if turned on
		if(CommandConfiguration.getCommandConfiguration().isReturnDiagnosticUncompressedForDiagnosticRequests())
		{
			// only if the initial request was for a diagnostic image
			if(imageQuality == ImageQuality.DIAGNOSTIC)
			{
				getLogger().info("Requested quality of diagnostic, adding diagnostic uncompressed as possible option to get from cache.");
				allowedQualities.add(ImageQuality.DIAGNOSTICUNCOMPRESSED);
			}
		}
		
		for(ImageQuality quality : allowedQualities)
		{
			try
			{
				if(ExchangeUtil.isSiteDOD(imageUrn.getOriginatingSiteId()))
				{				
					instance = commandContext.getExtraEnterpriseCache().getImage(imageUrn, quality.name(), targetFormat);
				}
				else
				{
					instance = commandContext.getIntraEnterpriseCacheCache().getImage(imageUrn, quality.name(), targetFormat);
				}
			} 
			catch (CacheException cX)
			{
				getLogger().error(cX);
				instance = null; // not really necessary but makes it clearer that the exception is treated as no instance in the cache
			}
			
			if(instance != null)
			{
                getLogger().info("Image '{}:{}' of format '{}' and quality '{}' in cache, returning readable byte channel.", studyId, imageId, targetFormat, quality.toString());
				return instance;
			}
			else
                getLogger().info("Image '{}:{}' of format '{}' and quality '{}' NOT in cache.", studyId, imageId, targetFormat, quality.toString());
		}
		
		// if we got to here then the image wasn't found in any quality			
		return instance;
	}
	
	public static ImmutableInstance getPatientPhotoImmutableInstance(
			ImagingCommandContext commandContext,
			String siteNumber,
			PatientIdentifier patientIdentifier)
	{
		ImmutableInstance instance = null;
		try
		{
			instance = commandContext.getIntraEnterpriseCacheCache().getPatientPhotoId(siteNumber, patientIdentifier);			
		} 
		catch (CacheException cX)
		{
			getLogger().error(cX);
			instance = null; // not really necessary but makes it clearer that the exception is treated as no instance in the cache
		}
		
		if(instance != null)
            getLogger().info("Patient photo image for patient '{}' from site '{}' in cache, returning readable byte channel.", patientIdentifier, siteNumber);
		else
            getLogger().info("Patient photo image for patient '{}' from site '{}' NOT in cache.", patientIdentifier, siteNumber);
			
		return instance;
	}
	
	public static ImmutableInstance getPatientPhotoImmutableInstance(
			ImagingCommandContext commandContext,
			ImageURN imageUrn, ImageFormat imageFormat)
	{
		ImmutableInstance instance = null;
		try
		{
			instance = commandContext.getIntraEnterpriseCacheCache().getPatientPhotoId(imageUrn, imageFormat);			
		} 
		catch (CacheException cX)
		{
			getLogger().error(cX);
			instance = null; // not really necessary but makes it clearer that the exception is treated as no instance in the cache
		}
		
		if(instance != null)
            getLogger().info("Patient photo image [{}] in cache, returning readable byte channel.", imageUrn.toString(SERIALIZATION_FORMAT.RAW));
		else
            getLogger().info("Patient photo image [{}] NOT in cache.", imageUrn.toString(SERIALIZATION_FORMAT.RAW));
			
		return instance;
	}


	/**
	 * This method finds an instance in the cache that has the URN and is compatible with the
	 * format and quality requested.
	 * 
	 * @param imageUrn
	 * @param imageQuality
	 * @param targetFormat
	 * @return
	 */
	public static ImmutableInstance getImmutableInstance(
		ImagingCommandContext commandContext,
		DocumentURN documentUrn)
	{
		String studyId = documentUrn.getGroupId();
		String documentId = documentUrn.getDocumentId();
		String repositoryId = documentUrn.getOriginatingSiteId();
		
		ImmutableInstance instance = null;
		try
		{
			if(ExchangeUtil.isSiteDOD(repositoryId))
			{				
				instance = commandContext.getExtraEnterpriseCache().getDocumentContent(documentUrn);
			}
			else
			{
				instance = commandContext.getIntraEnterpriseCacheCache().getDocumentContent(documentUrn);
			}
		} 
		catch (CacheException cX)
		{
			getLogger().error(cX);
			instance = null; // not really necessary but makes it clearer that the exception is treated as no instance in the cache
		}
		
		if(instance != null)
            getLogger().info("Found document '{}:{}' in cache, returning readable byte channel.", studyId, documentId);
		else
            getLogger().info("Document '{}:{}' NOT in cache.", studyId, documentId);
			
		return instance;
	}
	
	public static InputStream streamPatientPhotoImageFromCache(
			ImagingCommandContext commandContext,
			String siteNumber, 
			PatientIdentifier patientIdentifier)
	throws IOException
	{
		InstanceReadableVO readableVO = getPatientPhotoImageReadableChannelFromCache(commandContext, siteNumber, patientIdentifier);
		InstanceReadableByteChannel cacheReadChannel = (readableVO == null ? null : readableVO.getReadByteChannel());
		if(readableVO != null && cacheReadChannel != null)
		{
			// image is in the cache and we have a usable ReadableByteChannel, 		

			// image is in the cache and we have a usable ReadableByteChannel, return the stream.
			InputStream cacheInStream = Channels.newInputStream(cacheReadChannel);			
			return cacheInStream;
		}
		return null;
	}
	
	public static InputStream streamPatientPhotoImageFromCache(
			ImagingCommandContext commandContext,
			ImageURN imageUrn, ImageFormat imageFormat)
	throws IOException
	{
		InstanceReadableVO readableVO = getPatientPhotoImageReadableChannelFromCache(commandContext, imageUrn, imageFormat);
		InstanceReadableByteChannel cacheReadChannel = (readableVO == null ? null : readableVO.getReadByteChannel());
		if(readableVO != null && cacheReadChannel != null)
		{
			// image is in the cache and we have a usable ReadableByteChannel, 		

			// image is in the cache and we have a usable ReadableByteChannel, return the stream.
			InputStream cacheInStream = Channels.newInputStream(cacheReadChannel);			
			return cacheInStream;
		}
		return null;
	}

	
	public static void cacheImageFile(ImagingCommandContext commandContext, ImageURN imageUrn, 
			DataSourceInputStream imageStream, ImageQuality imageQuality, ImageFormat imageFormat)
	{
		if(commandContext.isCachingEnabled()) 
		{
			if(imageStream == null)
				return ;
			InputStream imgStream = imageStream.getInputStream();
			try {
				if (imgStream == null)
					return;
                getLogger().info("Caching txt file for image Urn [{}]", imageUrn.toString());

				String contentType = imageFormat.getMimeWithEnclosedMime();
				String siteNumber = imageUrn.getOriginatingSiteId();
				ImmutableInstance instance = null;
				InstanceWritableByteChannel instanceWritableChannel = null;
				OutputStream cacheOutStream = null;
				try {
					if (ExchangeUtil.isSiteDOD(siteNumber)) {
						instance = commandContext.getExtraEnterpriseCache().createImage(imageUrn,
								imageQuality.name(), contentType);
					} else {
						instance = commandContext.getIntraEnterpriseCacheCache().createImage(imageUrn,
								imageQuality.name(), contentType);
					}

					instanceWritableChannel = instance.getWritableChannel();
					try {
						cacheOutStream = Channels.newOutputStream(instanceWritableChannel);
						ByteStreamPump pump = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.NetworkToNetwork);
						// if the cacheStream is null the ByteStreamPump will ignore it
						pump.xfer(imgStream, cacheOutStream);
						if (imgStream != null) {
							getLogger().debug("Closing txt input stream after writing to the cache");
							imgStream.close();
						}
					} finally {
						if (cacheOutStream != null) {
							try {
								cacheOutStream.close();
							} catch (Exception e) {
								// Ignore
							}
						}
					}
					getLogger().info("TXT file cached.");
				} catch (InstanceInaccessibleException iaX) {
					// special exception handling, another thread is requesting to write to the instance
					// just before we did.  Try once again to read from the cache, our thread will be held until
					// the write is complete
					getLogger().debug(iaX);
				} catch (CacheException cX) {
					// any kind of cache exceptions should be logged, but the image must still be retreived from the DoD
					// from here on if cacheOutStream is not null we'll write to it
					getLogger().error(cX);
					instance = null;
					instanceWritableChannel = null;
					cacheOutStream = null;
				} catch (IOException ioX) {
					getLogger().error(ioX);
				}
			} finally {
				if (imgStream != null) {
					try {
						imgStream.close();
					} catch (Exception e) {
						// Ignore
					}
				}
			}
		}		
	}
	
	public static PatientPhotoIDInformation getPatientIDInformationFromCache(ImagingCommandContext commandContext, 
			RoutingToken routingToken, PatientIdentifier patientIdentifier)
	{
		PatientPhotoIDInformation result = null;
		if(commandContext.isCachingEnabled()) 
		{
			try
			{
				result = commandContext.getIntraEnterpriseCacheCache().getPatientPhotoIDInformation(routingToken, patientIdentifier);
			}
			catch(CacheException cX)
			{
                logger.warn("CacheException retrieving photo ID information for patient [{}] from cache, {}", patientIdentifier, cX.getMessage());
				return null;
			}
		}
		
		return result;
	}
	
	public static void cachePatientIDInformation(ImagingCommandContext commandContext, 
		RoutingToken routingToken, PatientIdentifier patientIdentifier, PatientPhotoIDInformation photoIdInformation)
	{
		if(commandContext.isCachingEnabled())
		{
			try
			{
				commandContext.getIntraEnterpriseCacheCache().createPatientPhotoIDInformation(routingToken, 
					patientIdentifier, photoIdInformation);
			}
			catch(CacheException cX)
			{
                logger.warn("Error caching photo ID image information for patient [{}], {}", patientIdentifier, cX.getMessage());
			}
		}
	}
	
	public static boolean isTextFileCached(ImagingCommandContext commandContext,
		ImageURN imageUrn)
	{
		String imageQuality = ImageQuality.REFERENCE.name();
		String contentType = ImageFormat.TEXT_DICOM.getMime();
		List<ImageURN> urns = RegionalStorageCommonFunctions.getUrnsToSearchCacheFor(imageUrn, commandContext);
		for(ImageURN urn : urns)
		{
			if(isImageCached(commandContext, urn, ImageFormat.TEXT_DICOM, ImageQuality.REFERENCE))
			{
				TransactionContextFactory.get().addDebugInformation("Found text file [" + urn.toString(SERIALIZATION_FORMAT.RAW) + "] in cache");
				return true;
			}
		}
		return false;
	}
	
	/**
	 * Determines if the image specified is already in the cache. It does not retrieve the image from the
	 * cache if it is there.
	 * 
	 * @param commandContext
	 * @param imageUrn
	 * @return
	 */
	public static boolean isImageFilesCached(
			ImagingCommandContext commandContext,
			ImageURN imageUrn)
	{
		if(ExchangeUtil.isSiteDOD(imageUrn.getOriginatingSiteId()))
		{				
			return commandContext.getExtraEnterpriseCache().isImageFilesCached(imageUrn);
		}
		else
		{
			return commandContext.getIntraEnterpriseCacheCache().isImageFilesCached(imageUrn);
		}
	}


}
