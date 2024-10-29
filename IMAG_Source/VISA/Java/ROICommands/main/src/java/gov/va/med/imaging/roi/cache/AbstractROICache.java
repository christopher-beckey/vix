/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 4, 2012
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
package gov.va.med.imaging.roi.cache;

import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.exchange.storage.cache.ImmutableInstance;
import gov.va.med.imaging.router.commands.CommonImageCacheFunctions;
import gov.va.med.imaging.router.commands.provider.ImagingCommandContext;
import gov.va.med.imaging.storage.cache.InstanceReadableByteChannel;
import gov.va.med.imaging.storage.cache.InstanceReadableVO;
import gov.va.med.imaging.storage.cache.InstanceWritableByteChannel;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;
import gov.va.med.imaging.storage.cache.exceptions.InstanceInaccessibleException;
import gov.va.med.imaging.storage.cache.exceptions.InstanceUnavailableException;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.channels.Channels;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public abstract class AbstractROICache
{
	private final static Logger logger = Logger.getLogger(AbstractROICache.class);
	
	protected Logger getLogger()
	{
		return logger;
	}
	
	protected final ImagingCommandContext commandContext;

	public AbstractROICache(ImagingCommandContext commandContext)
	{
		this.commandContext = commandContext;
	}
	
	protected abstract String getCacheItemName();
	
	protected abstract String getCacheItemDescription();
	
	protected abstract ImmutableInstance createCacheItem()
	throws CacheException;
	
	protected abstract ImmutableInstance getItemFromCache()
	throws CacheException;
	
	public void cacheItem(InputStream inputStream)
	{
		if(commandContext.isCachingEnabled()) 
		{
			if(inputStream == null)
				return ;
            getLogger().info("Caching {} for {}", getCacheItemName(), getCacheItemDescription());

			ImmutableInstance instance = null;
			InstanceWritableByteChannel instanceWritableChannel = null;
			OutputStream cacheOutStream = null;
			try
			{				
				instance = createCacheItem();				
	
				instanceWritableChannel = instance.getWritableChannel();
				cacheOutStream = Channels.newOutputStream(instanceWritableChannel);
				try {
					ByteStreamPump pump = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.NetworkToNetwork);
					// if the cacheStream is null the ByteStreamPump will ignore it
					pump.xfer(inputStream, cacheOutStream);
					if (inputStream != null) {
                        getLogger().debug("Closing {} input stream after writing to the cache", getCacheItemName());
						inputStream.close();
					}
				} finally {
					cacheOutStream.close();
				}
                getLogger().info("{} cached.", getCacheItemName());
			}
			catch(InstanceInaccessibleException iaX)
			{
				// special exception handling, another thread is requesting to write to the instance
				// just before we did.  Try once again to read from the cache, our thread will be held until
				// the write is complete
				getLogger().debug(iaX);
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
			catch(IOException ioX)
			{
				getLogger().error(ioX);
			}
		}		
	}
	
	public InputStream getInputStreamItemFromCache()
	throws IOException
	{
		InstanceReadableVO readableVO = getCacheItemReadableChannelFromCache();
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
	
	public int streamItemFromCache(
			OutputStream outStream)
	throws IOException
	{
		int bytesOut = 0;		// return value indicates how many bytes were sent.
		InstanceReadableVO readableVO = getCacheItemReadableChannelFromCache();
		InstanceReadableByteChannel cacheReadChannel = (readableVO == null ? null : readableVO.getReadByteChannel());
		if(readableVO != null && cacheReadChannel != null)
		{
			// image is in the cache and we have a usable ReadableByteChannel, 
			// notify the checksum notification listener if it exists
			//TODO: actually know the file length and set it here so that we can respond with the correct file length!

			// image is in the cache and we have a usable ReadableByteChannel, stream the image
			InputStream cacheInStream = Channels.newInputStream(cacheReadChannel);

			// get a byte stream pump from file (cache) to network (client)
			ByteStreamPump pump = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.FileToNetwork);
			// once we start the transfer we are committed to reading from the cache, 
			// i.e. failures result in errors, not retries from DOD
			try
			{
				bytesOut=pump.xfer(cacheInStream, outStream);
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
                    getLogger().warn("IOException caught when closing '{}', channel may have been closed earlier with a timeout.", getCacheItemDescription());
				}
			}
		}
        getLogger().debug("Returning [{}] bytes", bytesOut);
		return bytesOut;
	}
	
	private InstanceReadableVO getCacheItemReadableChannelFromCache()
	{		
		try
		{
			ImmutableInstance instance = getCacheItemImmutableInstance();
			
			// try to get image from Cache
			for( int retryCount = 0; instance != null && retryCount < CommonImageCacheFunctions.cacheReadRetry; ++retryCount) 
			{
                getLogger().info("{} for {} in cache, returning readable byte channel.", getCacheItemName(), getCacheItemDescription());

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
                    getLogger().info("InstanceUnavailableException caught (#{}{}{}", retryCount, (retryCount < CommonImageCacheFunctions.cacheReadRetry) ? " -> retry): " : " FAILING): ", iue.getMessage());
					try
					{
						Thread.sleep(CommonImageCacheFunctions.cacheReadRetryDelay);
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
	
	
	
	private ImmutableInstance getCacheItemImmutableInstance()
	{
		ImmutableInstance instance = null;
		try
		{
			instance = getItemFromCache();			
		} 
		catch (CacheException cX)
		{
			getLogger().error(cX);
			instance = null; // not really necessary but makes it clearer that the exception is treated as no instance in the cache
		}
		
		if(instance != null)
            getLogger().info("{} for {} in cache, returning readable byte channel.", getCacheItemName(), getCacheItemDescription());
		else
            getLogger().info("{} for {} NOT in cache.", getCacheItemName(), getCacheItemDescription());
			
		return instance;
	}

}
