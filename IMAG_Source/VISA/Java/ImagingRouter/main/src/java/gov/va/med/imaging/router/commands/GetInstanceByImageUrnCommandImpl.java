/**
 * 
 */
package gov.va.med.imaging.router.commands;

import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.channels.ChecksumValue;
import gov.va.med.imaging.channels.CompositeIOException;
import gov.va.med.imaging.channels.exceptions.ChecksumFormatException;
import gov.va.med.imaging.core.StreamImageFromCacheResponse;
import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.core.interfaces.exceptions.ImageConversionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.ImageStreamResponse;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.storage.cache.ImmutableInstance;
import gov.va.med.imaging.router.facade.ImagingContext;
import gov.va.med.imaging.storage.cache.InstanceWritableByteChannel;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;
import gov.va.med.imaging.storage.cache.exceptions.InstanceInaccessibleException;
import gov.va.med.imaging.storage.cache.exceptions.SimultaneousWriteException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.Channels;

/**
 * @author vhaiswbeckec
 *
 */
public class GetInstanceByImageUrnCommandImpl 
extends AbstractImageCommandImpl<Long>
{
	private static final long serialVersionUID = 1969186619792673657L;
	
	private final ImageURN imageUrn;
	private final ImageMetadataNotification imageMetadataNotification;
	private final OutputStream outStream;
	private final ImageFormatQualityList imageFormatQualityList;

	private final static int prefetchImageRetryDelayMinutes = 1;

	public GetInstanceByImageUrnCommandImpl(
			ImageURN imageUrn,
			ImageFormatQualityList imageFormatQualityList,
			OutputStream outStream)
	{
		this(imageUrn, imageFormatQualityList, outStream, (ImageMetadataNotification)null);
	}
	

	/**
	 * 
	 * @param commandContext - the context available to the command
	 * @param imageUrn - the universal identifier of the image
	 * @param outStream - the Output Stream where the image text will be available
	 * @param metadataCallback - the listener to be notified when metadata is available
	 * @param imageFormatQualityList - a list of acceptable format quality values
	 */
	public GetInstanceByImageUrnCommandImpl(
			ImageURN imageUrn,
			ImageFormatQualityList imageFormatQualityList,
			OutputStream outStream,
			ImageMetadataNotification imageMetadataNotification)
	{
		super();
		this.imageUrn = imageUrn;
		this.imageMetadataNotification = imageMetadataNotification;
		this.outStream = outStream;
		this.imageFormatQualityList = imageFormatQualityList;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		StringBuffer sb = new StringBuffer();
		
		sb.append(getImageUrn());
		sb.append(',');
		sb.append(getMetadataCallback() == null ? "<null callback>" : getMetadataCallback().toString());
		sb.append(',');
		sb.append(getOutStream() == null ? "<null out stream>" : getOutStream());
		sb.append(',');
		sb.append(getRequestedFormatQuality() == null ? "<null image format>" : getRequestedFormatQuality().toString());
		
		return sb.toString();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.router.commands.GetInstanceByImageUrnCommand#getImageUrn()
	 */
	public ImageURN getImageUrn()
	{
		return this.imageUrn;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.router.commands.GetInstanceByImageUrnCommand#getMetadataCallback()
	 */
	public ImageMetadataNotification getMetadataCallback()
	{
		return this.imageMetadataNotification;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.router.commands.GetInstanceByImageUrnCommand#getOutStream()
	 */
	public OutputStream getOutStream()
	{
		return this.outStream;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.router.commands.GetInstanceByImageUrnCommand#getRequestedFormatQuality()
	 */
	public ImageFormatQualityList getRequestedFormatQuality()
	{
		return this.imageFormatQualityList;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime
				* result
				+ ((this.imageFormatQualityList == null) ? 0
						: this.imageFormatQualityList.hashCode());
		result = prime
				* result
				+ ((this.imageMetadataNotification == null) ? 0
						: this.imageMetadataNotification.hashCode());
		result = prime * result
				+ ((this.imageUrn == null) ? 0 : this.imageUrn.hashCode());
		return result;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (getClass() != obj.getClass())
			return false;
		final GetInstanceByImageUrnCommandImpl other = (GetInstanceByImageUrnCommandImpl) obj;
		if (this.imageFormatQualityList == null)
		{
			if (other.imageFormatQualityList != null)
				return false;
		} else if (!this.imageFormatQualityList
				.equals(other.imageFormatQualityList))
			return false;
		if (this.imageMetadataNotification == null)
		{
			if (other.imageMetadataNotification != null)
				return false;
		} else if (!this.imageMetadataNotification
				.equals(other.imageMetadataNotification))
			return false;
		if (this.imageUrn == null)
		{
			if (other.imageUrn != null)
				return false;
		} else if (!this.imageUrn.equals(other.imageUrn))
			return false;
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callInTransactionContext()
	 */
	@Override
	public Long callSynchronouslyInTransactionContext()
	throws MethodException
	{
		int bytesReturned=0;
		TransactionContext transactionContext = TransactionContextFactory.get();

        getLogger().info("RouterImpl.getInstanceByImageURN({}, {})", imageUrn.toString(), getRequestedFormatQuality().getAcceptString(true, true));
		if(outStream == null)
		{
			throw new MethodException("Outputstream is null");
		}
		
		// use this imageId to query the DOD
		String imageId = imageUrn.getImageId();
		String studyId = imageUrn.getStudyId();
		String siteNumber = imageUrn.getOriginatingSiteId();
		transactionContext.setServicedSource(imageUrn.toRoutingTokenString());

		// if caching is enabled we will try to use the cache
		// cacheThisInstance indicates both that we write to and read from the cache for this instance
		boolean cacheThisInstance = studyId != null  &&  imageId != null  && getCommandContext().isCachingEnabled();

		// if the Image URN was successfully parsed and caching is enabled
		// try to retrieve the instance from the cache
		if( cacheThisInstance ) 
		{
			Image image = findImageInCachedStudyGraph(imageUrn);
            getLogger().info("Image '{}' caching enabled.", imageUrn.toString());
			try
			{
				transactionContext.setCacheFilename(null);
				
				StreamImageFromCacheResponse response = 
						CommonImageCacheFunctions.streamImageFromCache(
								getCommandContext(), imageUrn, 
								getRequestedFormatQuality(), outStream, 
								getMetadataCallback());

                getLogger().info("Cached Filename: {}", transactionContext.getCacheFilename());

				//For viewer Head request, no need to return stream, just return cached filename
				if (CommonImageCacheFunctions.isViewerHeadRequest(siteNumber)) 
					return new Long(0);
				
				if((response != null) && (response.getBytesReturnedFromDataSource() > 0))
				{
					transactionContext.setItemCached(Boolean.TRUE);
                    getLogger().info("Image '{}' found in the cache and streamed to the destination.", imageUrn.toString());
					if(image != null)
					{						
						if((image.getAlienSiteNumber() != null) && (image.getAlienSiteNumber().length() > 0))
						{
							getLogger().info("Found image metadata in cache with alien site number, updating serviced source of image");
							transactionContext.setServicedSource(image.getSiteNumber() + "(" + image.getAlienSiteNumber() + ")");
						}
					}
					
					return new Long(response.getBytesReturnedFromDataSource());
					// new ImageMetadata(imageUrn, response.imageFormat, null, response.bytesReturnedFromDataSource, response.bytesReturnedFromDataSource);
				}

                getLogger().info("Did not get image [{}] from local/remote cache", imageUrn.toString());
			}
			catch(CompositeIOException cioX) 
			{
				// if we know that no bytes have been written then we we can continue
				// otherwise we have to stop here and throw an error 
				if( cioX.isBytesWrittenKnown() && cioX.getBytesWritten() == 0 || cioX.getBytesWritten() == -1 )
				{
                    getLogger().warn("IO Exception when reading from cache, continuing with direct data source stream.{} bytes were indicated to have been written.Caused by : [{}] at {}.callSynchronouslyInTransactionContext()", cioX.getBytesWritten(), cioX.getMessage(), getClass().getName());
					return streamFromDataSource();
				}
				else
				{
					// exception occurred, we can't continue because the image may be partially written
					getLogger().error(cioX);
					throw new MethodException(
						"IO Exception when reading from cache, cannot continue because " + cioX.getBytesWritten() + 
						" bytes were known to have been written, continuing could result in corrupted image. " +
						"Caused by : [" + cioX.getMessage() +
						"] at " + getClass().getName() + ".callSynchronouslyInTransactionContext()"
					);
				}
			}
			catch(IOException ioX)
			{
				// exception occurred, we can't continue because the image may be partially written
				getLogger().error(ioX);
				throw new MethodException(
					"IO Exception when reading from cache, cannot continue because some bytes may be written, " + 
					"continuing could result in corrupted image. " +
					"Caused by : [" + ioX.getMessage() +
					"] at " + getClass().getName() + ".callSynchronouslyInTransactionContext()"
				);
			}

			// if we get here then caching is enabled but the instance was not found 
			// in the local cache nor remote cache, we try to grab the writable byte channel 
			// as soon as possible to lock other threads from writing to it
			transactionContext.setItemCached(Boolean.FALSE);
			ImmutableInstance instance = null;
			InstanceWritableByteChannel instanceWritableChannel = null;
			OutputStream cacheOutStream = null;
			
			// JMW 9/5/08 - if the image comes back from the datasource, use the properties of the
			// image (format/quality) from the datasource to find it in the cache
			ImageFormat dataSourceImageFormat = null;
			ImageQuality dataSourceImageQuality = null;
			
			try
			{
				ImageStreamResponse datasourceResponse = streamImageFromDataSource(imageUrn, getRequestedFormatQuality(), image);
				ImageFormat imgFormat = datasourceResponse.getImageFormat();
				getLogger().info("Received response from data source, putting into cache");
				// set the data source image format and image quality here 
				// since it is now in the cache.
				// JMW 10/6/2008
				// moved this here, if we get the image from the DS, need to use the format/quality from the DS to put/get the image from the cache
				// only clear these values if there is a cache exception (error writing to the cache)
				dataSourceImageFormat = imgFormat;
				dataSourceImageQuality = datasourceResponse.getImageQuality();

                getLogger().debug("Attempting to create cache instance with format [{}] and quality [{}]", dataSourceImageFormat, dataSourceImageQuality);
				if(ExchangeUtil.isSiteDOD(siteNumber))
				{
					instance = getCommandContext().getExtraEnterpriseCache().createImage(imageUrn, dataSourceImageQuality.name(), dataSourceImageFormat.getMimeWithEnclosedMime());
				}
				else
				{
					instance = getCommandContext().getIntraEnterpriseCacheCache().createImage(imageUrn, dataSourceImageQuality.name(), dataSourceImageFormat.getMimeWithEnclosedMime());
				}

				instanceWritableChannel = instance.getWritableChannel();
				cacheOutStream = Channels.newOutputStream(instanceWritableChannel);
				
				InputStream imageStream = datasourceResponse.getImageStream().getInputStream();
				
				if(cacheOutStream != null)
				{
					getLogger().info("Pumping stream into cache");
					ByteStreamPump pump = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.NetworkToNetwork);
					// if the cacheStream is null the ByteStreamPump will ignore it
					bytesReturned = pump.xfer(imageStream, cacheOutStream);
					
					
				}// not really sure what to do in the alternative here...
				
				// All these close() method calls and set to null should be done in the finally block.
				
				if(imageStream != null)
				{
					// close the input stream
					imageStream.close();
				}				
				String responseChecksum = datasourceResponse.getProvidedImageChecksum();
				cacheOutStream.close();
				boolean noResponseChecksum = false;
				if(responseChecksum != null)
				{
					noResponseChecksum = (responseChecksum.equals("ok") || responseChecksum.equals("not ok"));
				}					
				String cacheChecksum = instance.getChecksumValue();
				if(responseChecksum != null && cacheChecksum != null)
				{
					try
					{
						ChecksumValue responseCV;
						if (noResponseChecksum) responseCV = new ChecksumValue("");
						else responseCV = new ChecksumValue(responseChecksum);
						ChecksumValue cacheCV = new ChecksumValue(cacheChecksum);

						if (noResponseChecksum) {

							if (responseChecksum.equals("ok"))
                                getLogger().info("Checksum for inStream '{}' equals to data source cheksum.", imageUrn);
							else // "not ok"
                                getLogger().info("Checksum for inStream '{}' IS Not Equal to data source cheksum.", imageUrn);
						}
						else if (responseCV.getAlgorithm().equals(cacheCV.getAlgorithm())) {

							if (! responseCV.equals(cacheCV) )
                                getLogger().error("Checksums for instance '{}' ARE NOT EQUAL.", imageUrn);
							else
                                getLogger().info("Checksums for instance '{}' are equal.", imageUrn);
						}
						else
                            getLogger().warn("Checksums not compared for instance '{}' because response algorithm is '{}' and cache algorithm is '{}'.", imageUrn, responseCV.getAlgorithm(), cacheCV.getAlgorithm());
					} 
					catch (ChecksumFormatException x)
					{
                        getLogger().error("Invalidly formatted checksum value, either response header checksum '{}' or cache calculated checksum '{}'", responseChecksum, cacheChecksum);
					}
				}
			}
			catch(InstanceInaccessibleException iaX)
			{
				// special exception handling, another thread is requesting to write to the instance
				// just before we did.  Try once again to read from the cache, our thread will be held until
				// the write is complete
				try
				{
                    getLogger().warn("InstanceInaccessibleException caused by image [{}]", imageUrn.toString(), iaX);
					/*
					StreamImageFromCacheResponse response = streamImageFromCache(imageUrn, 
							requestedFormatQuality, outStream, metadataCallback);
					*/
					StreamImageFromCacheResponse response = null;
					// if the image was from the datasource, the dataSourceImageFormat and dataSourceImageQuality from the data source
					// should be set, get that instance from the cache (since the quality of the image cached might be higher
					// than the image requested). This prevents putting an item into the cache and then never retrieving it.
					if((dataSourceImageFormat != null) &&
						(dataSourceImageQuality != null))
					{
                        getLogger().debug("Finding cached instance using format [{}] and quality [{}] from data source response.", dataSourceImageFormat, dataSourceImageQuality);
						int bytes = CommonImageCacheFunctions.streamImageFromCache(getCommandContext(),
								imageUrn, dataSourceImageFormat, dataSourceImageQuality, outStream, getMetadataCallback());
						if(bytes > 0)
						{
							getLogger().debug("Found instance in cache using quality and format from data source response.");
							response = new StreamImageFromCacheResponse(null, bytes, dataSourceImageFormat, dataSourceImageQuality);
						} 
					}
					else
					{				
						response = CommonImageCacheFunctions.streamImageFromCache(getCommandContext(),
								imageUrn, getRequestedFormatQuality(), outStream, getMetadataCallback());
					}
					
					if (CommonImageCacheFunctions.isViewerHeadRequest(siteNumber)) 
						return new Long(0);
					
					if(response != null)
					{
						bytesReturned = response.getBytesReturnedFromDataSource();
						if( bytesReturned > 0 )
						{
                            getLogger().info("Image '{}' found in the cache and streamed to the destination.", imageUrn.toString());
							return new Long(bytesReturned); //new ImageMetadata(imageUrn, response.imageFormat, null, bytesReturned, bytesReturned);
						}
					}
                    getLogger().info("Did not get image [{}] from cache", imageUrn.toString());
				}
				catch(CompositeIOException cioX) 
				{
					// if we know that no bytes have been written then we we can continue
					// otherwise we have to stop here and throw an error 
					if( cioX.isBytesWrittenKnown() && cioX.getBytesWritten() == 0 || cioX.getBytesWritten() == -1 )
					{
                        getLogger().warn("IO Exception when reading from cache, continuing with direct data source stream.{} bytes were indicated to have been written.Caused by : [{}] at {}.callSynchronouslyInTransactionContext()", cioX.getBytesWritten(), cioX.getMessage(), getClass().getName());
						return streamFromDataSource();
					}
					else
					{
						// exception occurred, we can't continue because the image may be partially written
						getLogger().error(cioX);
						throw new MethodException(
							"IO Exception when reading from cache, cannot continue because " + cioX.getBytesWritten() + 
							" bytes were known to have been written, continuing could result in corrupted image. " +
							"Caused by : [" + cioX.getMessage() +
							"] at " + getClass().getName() + ".callSynchronouslyInTransactionContext()"
						);
					}
				}
				catch(IOException ioX)
				{
					// exception occured, we can't continue because the image may be partially written
					getLogger().error(ioX);
					throw new MethodException(
						"IO Exception when reading from cache, cannot continue because some bytes may be written, continuing could result in corrupted image." +
						"Caused by : [" + ioX.getMessage() +
						"] at " + getClass().getName() + ".callSynchronouslyInTransactionContext() in InstanceInaccessibleException handler"
					);
				}
			}
			catch(SimultaneousWriteException swX)
			{
                getLogger().warn("SimultaneousWriteException caused by image [{}]", imageUrn.toString(), swX);
				// JMW 10/3/2008
				// occurs if 2 threads are attempting to write to the cache at the same time,
				// this thread will try to get the image from the cache which should cause this 
				// thread to wait for the other thread to complete before getting the image
				try
				{
					
					StreamImageFromCacheResponse response = null;
					// if the image was from the datasource, the dataSourceImageFormat and dataSourceImageQuality from the data source
					// should be set, get that instance from the cache (since the quality of the image cached might be higher
					// than the image requested). This prevents putting an item into the cache and then never retrieving it.
					if((dataSourceImageFormat != null) &&
						(dataSourceImageQuality != null))
					{
                        getLogger().debug("Finding cached instance using format [{}] and quality [{}] from data source response.", dataSourceImageFormat, dataSourceImageQuality);
						int bytes = CommonImageCacheFunctions.streamImageFromCache(getCommandContext(),
								imageUrn, dataSourceImageFormat, dataSourceImageQuality, outStream, getMetadataCallback());
						if(bytes > 0)
						{
							getLogger().debug("Found instance in cache using quality and format from data source response.");
							response = new StreamImageFromCacheResponse(null, bytes, dataSourceImageFormat, dataSourceImageQuality);
						} 
					}
					else
					{				
						response = CommonImageCacheFunctions.streamImageFromCache(getCommandContext(), 
								imageUrn, getRequestedFormatQuality(), outStream, getMetadataCallback());
					}

					if (CommonImageCacheFunctions.isViewerHeadRequest(siteNumber)) 
						return new Long(0);

					if(response != null)
					{
						bytesReturned = response.getBytesReturnedFromDataSource();
						if( bytesReturned > 0 )
						{
                            getLogger().info("Image '{}' found in the cache and streamed to the destination.", imageUrn.toString());
							return new Long(bytesReturned); //new ImageMetadata(imageUrn, response.imageFormat, null, bytesReturned, bytesReturned);
						}
					}
                    getLogger().info("Did not get image [{}] from cache", imageUrn.toString());
				}
				catch(IOException ioX)
				{
					// exception occurred, we can't continue because the image may be partially written
					getLogger().error(ioX);
					throw new MethodException(
						"IO Exception when reading from cache, cannot continue because some bytes may be written, continuing could result in corrupted image." +
						"Caused by : [" + ioX.getMessage() +
						"] at " + getClass().getName() + ".callSynchronouslyInTransactionContext() in SimultaneousWriteException handler"
					);
				}
			}
			catch(CacheException cX)
			{
				// any kind of cache exceptions should be logged, but the image must still be retreived from the DoD
				// from here on if cacheOutStream is not null we'll write to it 
				getLogger().error(cX);
				instance = null;
				instanceWritableChannel= null;
				cacheOutStream = null;
				dataSourceImageFormat = null;
				dataSourceImageQuality = null;
			}
			catch(IOException ioX)
			{
				cacheOutStream = null;
				// Fortify change: commented out = already done in the finally block
				//try{instanceWritableChannel.error();}catch(Throwable t){}
				getLogger().error(ioX);
			} 
			catch (ImageNotFoundException e)
            {
				//return null;
				throw e;
            }
			catch(ImageNearLineException inlX)
			{
				scheduleRequestOfNearlineImage();
				throw inlX;
			}
			finally
			{
				// the instance absolutely positively must be closed
				if((instanceWritableChannel != null) && (instanceWritableChannel.isOpen()))
				{
					getLogger().error("Cache instance writable byte channel being closed with error on unknown exception");
					try{instanceWritableChannel.error();}catch(Throwable t){}
				}
			}

			// the image is now in the cache, the streams and channels are closed
			// now try to stream from the cache
			try
			{
				StreamImageFromCacheResponse response = null;
				// if the image was from the datasource, the dataSourceImageFormat and dataSourceImageQuality from the data source
				// should be set, get that instance from the cache (since the quality of the image cached might be higher
				// than the image requested). This prevents putting an item into the cache and then never retrieving it.
				if((dataSourceImageFormat != null) &&
					(dataSourceImageQuality != null))
				{
                    getLogger().debug("Finding cached instance using format [{}] and quality [{}] from data source response.", dataSourceImageFormat, dataSourceImageQuality);
					Boolean updateImageLocation = true;
					int bytes = CommonImageCacheFunctions.streamImageFromCache(getCommandContext(),
							imageUrn, dataSourceImageFormat, dataSourceImageQuality, outStream, getMetadataCallback(), updateImageLocation);
					if(bytes > 0)
					{
						getLogger().debug("Found instance in cache using quality and format from data source response.");
						response = new StreamImageFromCacheResponse(null, bytes, dataSourceImageFormat, dataSourceImageQuality);
					} 
				}
				else
				{				
					Boolean updateImageLocation = true;
					response = CommonImageCacheFunctions.streamImageFromCache(getCommandContext(),
							imageUrn, getRequestedFormatQuality(), outStream, getMetadataCallback(), updateImageLocation);
				}

				if (CommonImageCacheFunctions.isViewerHeadRequest(siteNumber)) 
					return new Long(0);

				// if the response is null, then didn't get anything from the cache (shouldn't happen)
				if(response != null)
				{
					bytesReturned = response.getBytesReturnedFromDataSource();
					if( bytesReturned > 0 )
					{
                        getLogger().info("Image '{}' found in the cache and streamed to the destination.", imageUrn.toString());
						return new Long(bytesReturned);// new ImageMetadata(imageUrn, response.imageFormat, null, bytesReturned, bytesReturned);
					}
				}
                getLogger().info("Did not get image [{}] from cache", imageUrn.toString());
			}
			catch(IOException ioX)
			{
				// exception occured, we can't continue because the image may be partially written
				getLogger().error(ioX);
				throw new MethodException(
					"IO Exception when reading from cache, cannot continue because some bytes may be written, continuing could result in corrupted image." +
					"Caused by : [" + ioX.getMessage() +
					"] at " + getClass().getName() + ".callSynchronouslyInTransactionContext() streaming from cache."
				);
			}
		}
		
		// caching is disabled or unusable for this instance
		// stream directly from cache
		return streamFromDataSource();
	}

	/**
	 * Stream the image from the data source and put it into the output stream. This method DOES NOT use the
	 * cache so it should only be called after cache attempts have failed.
	 * 
	 * @param bytesReturned
	 * @return
	 * @throws MethodException
	 * @throws ImageConversionException
	 * @throws ImageNotFoundException
	 * @throws ImageNearLineException
	 */
	private Long streamFromDataSource()
			throws MethodException, ImageConversionException,
			ImageNotFoundException, ImageNearLineException
	{
        getLogger().info("Image '{}' caching disabled, getting image from source.", imageUrn.toString());

		InputStream imageStream = null;
		try
		{
			ImageStreamResponse streamResponse = streamImageFromDataSource(imageUrn, getRequestedFormatQuality());
			if(getMetadataCallback() != null)
			{
				getMetadataCallback().imageMetadata(streamResponse.getProvidedImageChecksum(), 
					streamResponse.getImageFormat(), 0, streamResponse.getImageQuality());
			}
			getLogger().info("Pumping response to client (bypassing cache)");
			ByteStreamPump pump = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.NetworkToNetwork);
			// if the cacheStream is null the ByteStreamPump will ignore it
			imageStream = streamResponse.getImageStream().getInputStream();
			long bytesReturned = pump.xfer(imageStream, outStream);	
			return new Long(bytesReturned);// new ImageMetadata(imageUrn, streamResponse.getImageFormat(), null, bytesReturned, bytesReturned);
		} 
		catch (IOException ioX)
		{
			getLogger().error(ioX);
			throw new MethodException(ioX);
		} 
		catch (ImageNotFoundException e)
        {
			throw e;
        }
		catch(ImageNearLineException inlX)
		{
			scheduleRequestOfNearlineImage();
			throw inlX;
		}
		finally
		{
			if(imageStream != null)
			{
				try{imageStream.close();}
				catch(IOException ioX){getLogger().warn(ioX);}
			}
		}
	}
	
	
	/**
	 * Schedule a subsequent request of an image after a near-line exception has occurred.  A near-line exception
	 * implies the image is not currently available but will be shortly. Calling this function creates a new 
	 * prefetch request for the image and schedules it to execute after 1 minute at which point the hope is the
	 * image is available from the datasource. Because a prefetch command is used, this will only be attempted
	 * once.
	 */
	private void scheduleRequestOfNearlineImage()
	{
		try
		{
            getLogger().info("Image '{}' returned nearline, requesting image again in " + prefetchImageRetryDelayMinutes + " minute", getImageUrn().toString());
			ImagingContext.getRouter().prefetchInstanceByImageUrnDelayOneMinute(getImageUrn(), 
				getRequestedFormatQuality());
			/*
			Command<java.lang.Void> cmd = 
				getCommandContext().getCommandFactory().createCommand(null, 
					"PrefetchInstanceByImageUrnCommand", new Object[] {getImageUrn(), getRequestedFormatQuality()});
			Calendar now = Calendar.getInstance();
			now.add(Calendar.MINUTE, prefetchImageRetryDelayMinutes); // set to request again in 1 minute
			cmd.setAccessibilityDate(now.getTime());
			cmd.setPriority(ScheduledPriorityQueueElement.Priority.NORMAL.ordinal());
			getCommandContext().getRouter().doAsynchronously(cmd);
			*/
		}
		catch(Exception ex)
		{
			// just in case...
			getLogger().error("Error scheduling request of nearline image", ex);
		}
	}
}
