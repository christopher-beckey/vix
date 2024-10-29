/**
 * 
 */
package gov.va.med.imaging.router.commands;

import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.P34ImageURN;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.core.StreamImageFromCacheResponse;
import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.core.interfaces.StorageCredentials;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageConversionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ImageFormatQuality;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.ImageStreamResponse;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;
import gov.va.med.imaging.exchange.storage.cache.ImmutableInstance;
import gov.va.med.imaging.router.facade.ImagingContext;
import gov.va.med.imaging.storage.cache.InstanceWritableByteChannel;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;
import gov.va.med.imaging.storage.cache.exceptions.InstanceInaccessibleException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.image.ImagingStorageCredentials;
import gov.va.med.imaging.vista.storage.SmbStorageUtility;
import jcifs.smb.NtlmPasswordAuthentication;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.Channels;

/**
 * @author vhaiswbeckec
 *
 */
public class GetImageTextCommandImpl 
extends AbstractImageCommandImpl<Integer>
{
	private static final long serialVersionUID = -6808675853156543714L;
	private final ImageURN imageUrn;
	private final OutputStream outStream; 
	private final ImageMetadataNotification metadataCallback;

	/**
	 * @param commandContext - the context available to the command
	 * @param imageUrn - the universal identifier of the image
	 * @param outStream - the Output Stream where the image text will be available
	 * @param metadataCallback - the listener to be notified when metadata is available
	 */
	public GetImageTextCommandImpl(
		ImageURN imageUrn,
		OutputStream outStream, 
		ImageMetadataNotification metadataCallback)
	{
		super();
		
		this.imageUrn = imageUrn;
		this.outStream = outStream;
		this.metadataCallback = metadataCallback;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.router.commands.GetImageTextCommand#getImageMetadataNotification()
	 */
	public ImageMetadataNotification getImageMetadataNotification()
	{
		return this.metadataCallback;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.router.commands.GetImageTextCommand#getImageUrn()
	 */
	public ImageURN getImageUrn()
	{
		return this.imageUrn;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.router.commands.GetImageTextCommand#getOutStream()
	 */
	public OutputStream getOutStream()
	{
		return this.outStream;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(imageUrn.toString());
		sb.append(',');
		sb.append(outStream.toString()); 
		sb.append(',');
		sb.append(metadataCallback.toString());
		
		return sb.toString();
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((this.imageUrn == null) ? 0 : this.imageUrn.hashCode());
		result = prime
				* result
				+ ((this.metadataCallback == null) ? 0 : this.metadataCallback
						.hashCode());
		result = prime * result
				+ ((this.outStream == null) ? 0 : this.outStream.hashCode());
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
		final GetImageTextCommandImpl other = (GetImageTextCommandImpl) obj;
		if (this.imageUrn == null)
		{
			if (other.imageUrn != null)
				return false;
		} else if (!this.imageUrn.equals(other.imageUrn))
			return false;
		if (this.metadataCallback == null)
		{
			if (other.metadataCallback != null)
				return false;
		} else if (!this.metadataCallback.equals(other.metadataCallback))
			return false;
		if (this.outStream == null)
		{
			if (other.outStream != null)
				return false;
		} else if (!this.outStream.equals(other.outStream))
			return false;
		return true;
	}
		
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.router.Command#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Integer callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException
	{
		int bytesReturned=0;
		ImageQuality txtQuality = ImageQuality.REFERENCE;
		ImageFormat txtFormat = ImageFormat.TEXT_DICOM;
		ImageFormatQualityList qualityList = new ImageFormatQualityList();
		qualityList.add(new ImageFormatQuality(txtFormat, txtQuality));
		TransactionContext transactionContext = TransactionContextFactory.get();

        getLogger().info("RouterImpl.getTxtFileByImageURN({})", imageUrn.toString());
		if(outStream == null)
		{
			throw new MethodException("Outputstream is null");
		}
		
		if(imageUrn instanceof P34ImageURN){
			throw new MethodException("No associated TXT file for " + imageUrn.toString() + "Image in new data structure.");
		}
		
		// use this imageId to query the DOD
		String imageId = imageUrn.getImageId();
		String studyId = imageUrn.getStudyId();
		String siteNumber = imageUrn.getOriginatingSiteId();

		transactionContext.setServicedSource(imageUrn.toRoutingTokenString());
		
		//Bypass caching if the image is in local site.
		boolean isViewerProcess = (transactionContext.isViewerProcess() == null ? false : transactionContext.isViewerProcess());

		if (isViewerProcess && transactionContext.getSiteNumber().equals(siteNumber))
		{
            getLogger().info("Getting Local TXT file for '{} - bypass caching", imageUrn.toString());
			return streamLocalTXTFileFromDataSource();
		}
		
		// if caching is enabled we will try to use the cache
		// cacheThisInstance indicates both that we write to and read from the cache for this instance
		boolean cacheThisInstance = 
				(studyId != null)  &&  
				(imageId != null)  && 
				getCommandContext().isCachingEnabled();

		// if the Image URN was successfully parsed and caching is enabled
		// try to retrieve the instance from the cache
		if( cacheThisInstance ) 
		{
            getLogger().info("Image '{}' caching enabled", imageUrn.toString());
			try
			{
				StreamImageFromCacheResponse response = 
					CommonImageCacheFunctions.streamImageFromCache(getCommandContext(),
							imageUrn, qualityList, outStream, getImageMetadataNotification());
				if(response != null)
				{
					bytesReturned = response.getBytesReturnedFromDataSource();
					if( bytesReturned > 0 )
					{
						transactionContext.setItemCached(Boolean.TRUE);
                        getLogger().info("TXT file '{}' found in the cache and streamed to the destination.", imageUrn.toString());
						return bytesReturned;
					}
				}

                getLogger().info("Did not get txt file [{}] from cache", imageUrn.toString());
			}
			catch(IOException ioX)
			{
				// exception occured, we can't continue because the image may be partially written
				getLogger().error(ioX);
				throw new MethodException(
					"IO Exception when reading from cache, cannot continue because some bytes may be written, continuing could result in corrupted image." +
					"Caused by : [" + ioX.getMessage() +
					"] at " + getClass().getName() + ".callSynchronouslyInTransactionContext()."
				);
			}

			// if we get here then caching is enabled but the instance was not found in the cache
			// we try to grab the writable byte channel as soon as possible to lock other threads from writing to
			// it
			transactionContext.setItemCached(Boolean.FALSE);
			ImmutableInstance instance = null;
			InstanceWritableByteChannel instanceWritableChannel = null;
			OutputStream cacheOutStream = null;
			try
			{

				if(ExchangeUtil.isSiteDOD(siteNumber))
				{
					instance = getCommandContext().getExtraEnterpriseCache().createImage(imageUrn, txtQuality.name(), txtFormat.getMime());
				}
				else
				{
					instance = getCommandContext().getIntraEnterpriseCacheCache().createImage(imageUrn, txtQuality.name(), txtFormat.getMime());
				}

				instanceWritableChannel = instance.getWritableChannel();
				cacheOutStream = Channels.newOutputStream(instanceWritableChannel);
			}
			catch(InstanceInaccessibleException iaX)
			{
				// special exception handling, another thread is requesting to write to the instance
				// just before we did.  Try once again to read from the cache, our thread will be held until
				// the write is complete
				try
				{
					StreamImageFromCacheResponse response = CommonImageCacheFunctions.streamImageFromCache(getCommandContext(),
							imageUrn, qualityList, outStream, getImageMetadataNotification());
					if(response != null)
					{
						bytesReturned = response.getBytesReturnedFromDataSource();
						if( bytesReturned > 0 )
						{
                            getLogger().info("TXT File '{}' found in the cache and streamed to the destination.", imageUrn.toString());
							return bytesReturned;
						}
					}
                    getLogger().info("Did not get txt file [{}] from cache", imageUrn.toString());
				}
				catch(IOException ioX)
				{
					// exception occured, we can't continue because the image may be partially written
					getLogger().error(ioX);
					throw new MethodException(
						"IO Exception when reading from cache, cannot continue because some bytes may be written, continuing could result in corrupted image." +
						"Caused by : [" + ioX.getMessage() +
						"] at " + getClass().getName() + ".callSynchronouslyInTransactionContext() InstanceInaccessibleException handler."
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
			}

			// okay, we've got a stream to the cache instance, get the image from the DoD and write to it
			if(cacheOutStream != null)
			{
				try
				{
					bytesReturned = streamTXTFileFromDataSource(imageUrn, cacheOutStream); 
					cacheOutStream.close();
					
					// the image is now in the cache, the streams and channels are closed
					// now try to stream from the cache
					try
					{
						Boolean updateImageLocation = true;
						StreamImageFromCacheResponse response = CommonImageCacheFunctions.streamImageFromCache(getCommandContext(),
								imageUrn, qualityList, outStream, getImageMetadataNotification(), updateImageLocation);
						if(response != null)
						{
							bytesReturned = response.getBytesReturnedFromDataSource();
							if( bytesReturned > 0 )
							{
                                getLogger().info("TXT file '{}' found in the cache and streamed to the destination.", imageUrn.toString());
								return bytesReturned;
							}
						}
                        getLogger().info("Did not get txt file [{}] from cache", imageUrn.toString());
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
				catch(IOException ioX)
				{
					cacheOutStream = null;
					// Fortify change: commented out = already done in the finally block
					//try{instanceWritableChannel.error();}catch(Throwable t){}
					getLogger().error(ioX);
				}
				finally
				{
					// the instance absolutely positively must be closed
					// Fortify change: Added null check
					// OLD: if(instanceWritableChannel.isOpen())
						if((instanceWritableChannel != null) && (instanceWritableChannel.isOpen()))
					{
						getLogger().error("Cache instance writable byte channel being closed with error on unknown exception");
						try{instanceWritableChannel.error();}catch(Throwable t){}
					}
				}
			}
		}

		// disabling caching also makes checking checksums problematic because the cache
		// is where we do the checksum calculation
		else
		{
            getLogger().info("Image '{}' caching disabled, getting image from source.", imageUrn.toString());

			try
			{
				bytesReturned = streamTXTFileFromDataSource(imageUrn, outStream);
			} 
			catch (IOException ioX)
			{
				getLogger().error(ioX);
				throw new MethodException(ioX);
			}
		}
		
		return bytesReturned;
	}

	private ImageMetadataNotification getMetadataCallback() {
		return this.metadataCallback;
	}
	private Integer streamLocalTXTFileFromDataSource()
	throws MethodException, ImageConversionException,
		ImageNotFoundException
	{
        getLogger().info("Getting Local Image '{}' from source.", imageUrn.toString());
		
		InputStream imageStream = null;
		try
		{
			DataSourceInputStream streamResponse = 
					streamTXTFileFromDataSourceWithoutCache(imageUrn);
			
			if(getImageMetadataNotification() != null)
			{
				getImageMetadataNotification().imageMetadata(
					streamResponse.getProvidedChecksum() == null ? null : streamResponse.getProvidedChecksum().toString(),
					null, 0, null);
			}
		
			TransactionContext transactionContext = TransactionContextFactory.get();
		
			if ((transactionContext.getHttpServletRequestMethod() != null) && transactionContext.getHttpServletRequestMethod().equals("HEAD"))
			{
				return 0;
			}
			
			getLogger().info("Pumping response to client (bypassing cache)");
			ByteStreamPump pump = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.NetworkToNetwork);
			// if the cacheStream is null the ByteStreamPump will ignore it
			imageStream = streamResponse.getInputStream();
			int bytesReturned = pump.xfer(imageStream, outStream);	
			return bytesReturned;
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
		finally
		{
			if(imageStream != null)
			{
				try{imageStream.close();}
				catch(IOException ioX){getLogger().warn(ioX);}
			}
		}
	}
	
}
