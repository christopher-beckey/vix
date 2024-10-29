/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created:
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:
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
/**
 * 
 */
package gov.va.med.imaging.router.commands;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.channels.CompositeIOException;
import gov.va.med.imaging.core.interfaces.PhotoIDInformationNotification;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.PatientPhotoID;
import gov.va.med.imaging.exchange.business.PatientPhotoIDInformation;
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
import java.util.UUID;

/**
 * @author vhaiswbeckec
 *
 */
public class GetPatientIdentificationImageCommandImpl 
extends AbstractImagingCommandImpl<InputStream> 
{
	private static final long serialVersionUID = 1797497988357747778L;
	private final PatientIdentifier patientIdentifier;
	private final RoutingToken routingToken;
	private final PhotoIDInformationNotification photoIdInformationNotification;
	private final boolean remote;
	private TransactionContext transactionContext;
	
	public GetPatientIdentificationImageCommandImpl(
			PatientIdentifier patientIdentifier, 
			RoutingToken routingToken,
			PhotoIDInformationNotification photoIdInformationNotification,
			boolean remote)
	{
		super();
		this.patientIdentifier = patientIdentifier;
		this.routingToken = routingToken;
		this.photoIdInformationNotification = photoIdInformationNotification;
		this.remote = remote;
		
		this.transactionContext = TransactionContextFactory.get();
		if(this.transactionContext.getTransactionId() == null)
		{
			this.transactionContext.setTransactionId(UUID.randomUUID().toString());
		}

	}
	
	public GetPatientIdentificationImageCommandImpl(
		PatientIdentifier patientIdentifier, 
		RoutingToken routingToken,
		PhotoIDInformationNotification photoIdInformationNotification)
	{
		this(patientIdentifier, routingToken, photoIdInformationNotification, false);
	}
	
	public GetPatientIdentificationImageCommandImpl(
		PatientIdentifier patientIdentifier, 
		RoutingToken routingToken)
	{
		this(patientIdentifier, routingToken, null);
	}
	
	/**
	 * @return the photoIdInformationNotification
	 */
	public PhotoIDInformationNotification getPhotoIdInformationNotification()
	{
		return photoIdInformationNotification;
	}
	/**
	 * @return the patientIdentifier
	 */
	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}


	public RoutingToken getRoutingToken()
	{
		return this.routingToken;
	}

	public Boolean isRemote()
	{
		return this.remote;
	}

	public String getSiteNumber()
	{
		return getRoutingToken().getRepositoryUniqueId();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append(getPatientIdentifier());
		sb.append(", ");
		sb.append(getSiteNumber());
		
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
				+ ((this.patientIdentifier == null) ? 0 : this.patientIdentifier.hashCode());
		result = prime * result
				+ ((this.routingToken == null) ? 0 : this.routingToken.hashCode());
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
		final GetPatientIdentificationImageCommandImpl other = (GetPatientIdentificationImageCommandImpl) obj;
		if (this.patientIdentifier == null)
		{
			if (other.patientIdentifier != null)
				return false;
		} else if (!this.patientIdentifier.equals(other.patientIdentifier))
			return false;
		if (this.routingToken == null)
		{
			if (other.routingToken != null)
				return false;
		} else if (!this.routingToken.equals(other.routingToken))
			return false;
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public InputStream callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException
	{
		if (isRemote())
		{
			return getRemotePatientIdentificationImage();
		}
		else
		{
			return getPatientIdentificationImage();
		}
	}
	
	
	private InputStream getRemotePatientIdentificationImage()
	throws MethodException, ConnectionException
	{

        getLogger().info("getRemotePatientIdentificationImage - Transaction ID [{}] from site [{}] for patient [{}].", transactionContext.getTransactionId(), routingToken.toString(), patientIdentifier);

		transactionContext.setServicedSource(routingToken.toRoutingTokenString());
		// if caching is enabled we will try to use the cache
		// cacheThisInstance indicates both that we write to and read from the cache for this instance
		boolean cacheThisInstance = patientIdentifier != null  &&  routingToken.getRepositoryUniqueId() != null  && getCommandContext().isCachingEnabled();

		// if the Image URN was successfully parsed and caching is enabled
		// try to retrieve the instance from the cache
		if( cacheThisInstance ) 
		{
            getLogger().info("Patient ID image '{}' from site '{}' caching enabled.", patientIdentifier, routingToken.toString());
			
			// don't get cached information, will automatically cache new information
			PatientPhotoIDInformation photoIdInformation =
				ImagingContext.getRouter().getPatientIdentificationImageInformation(routingToken, patientIdentifier, false);
			
			// if there is no photo ID information then there isn't a photo ID image
			if(photoIdInformation == null)
			{
                getLogger().info("Received null photo ID information from data source, indicates patient '{}' does not have a photo ID at site {}, returning null.", getPatientIdentifier(), getRoutingToken().toRoutingTokenString());
				return null; // indicates no photo ID for this patient at the site
			}
						
			try
			{
				// null check is unnecessary, but can't hurt!
				if(photoIdInformation != null)
				{
					InputStream cacheStream =
						CommonImageCacheFunctions.streamPatientPhotoImageFromCache(getCommandContext(), 
							photoIdInformation.getImageUrn(), photoIdInformation.getImageFormat());
					if(cacheStream != null)
					{
						transactionContext.setItemCached(Boolean.TRUE);
                        getLogger().info("Patient ID image '{}' from site '{}' found in the cache and returned stream.", patientIdentifier, routingToken.toString());
						return cacheStream;
					}
				}
                getLogger().info("Did not get patient ('{}') photo image from cache", patientIdentifier);
			}
			catch(CompositeIOException cioX) 
			{
				// if we know that no bytes have been written then we we can continue
				// otherwise we have to stop here and throw an error 
				if( cioX.isBytesWrittenKnown() && cioX.getBytesWritten() == 0 || cioX.getBytesWritten() == -1 )
				{
                    getLogger().warn("IO Exception when reading from cache, continuing with direct data source stream.{} bytes were indicated to have been written.Caused by : [{}] at {}.callSynchronouslyInTransactionContext()", cioX.getBytesWritten(), cioX.getMessage(), getClass().getName());
					return streamFromPatientIdImageDataSource();
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

			// if we get here then caching is enabled but the instance was not found in the cache
			// we try to grab the writable byte channel as soon as possible to lock other threads from writing to
			// it
			transactionContext.setItemCached(Boolean.FALSE);
			ImmutableInstance instance = null;
			InstanceWritableByteChannel instanceWritableChannel = null;
			OutputStream cacheOutStream = null;

			InputStream inputStream = null;
			try
			{				
				inputStream = streamFromPatientIdImageDataSource();
				if(inputStream == null)
				{
                    getLogger().info("Received null response from data source, indicates patient '{}' does not have a photo ID at site {}, returning null.", getPatientIdentifier(), getRoutingToken().toRoutingTokenString());
					return null; // indicates no photo ID for this patient at the site
				}
				getLogger().info("Received response from data source, putting into cache");
				// set the data source image format and image quality here 
				// since it is now in the cache.
				// JMW 10/6/2008
				// moved this here, if we get the image from the DS, need to use the format/quality from the DS to put/get the image from the cache
				// only clear these values if there is a cache exception (error writing to the cache)
				
				getLogger().debug("Attempting to create cache instance for photo image");
				instance = getCommandContext().getIntraEnterpriseCacheCache().createPatientPhotoId(photoIdInformation.getImageUrn(),
						photoIdInformation.getImageFormat());

				instanceWritableChannel = instance.getWritableChannel();
				cacheOutStream = Channels.newOutputStream(instanceWritableChannel);
				
				if(cacheOutStream != null)
				{
					getLogger().info("Pumping stream into cache");
					ByteStreamPump pump = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.NetworkToNetwork);
					// if the cacheStream is null the ByteStreamPump will ignore it
					int bytesReturned = pump.xfer(inputStream, cacheOutStream);
                    getLogger().info("Wrote '{}' bytes into cache for patient photo image.", bytesReturned);
					
				}// not really sure what to do in the alternative here...
				//TODO: move to finally!
				if(inputStream != null)
				{
					// close the input stream
					inputStream.close();
				}				
				cacheOutStream.close();				
			}
			catch(InstanceInaccessibleException iaX)
			{
				// special exception handling, another thread is requesting to write to the instance
				// just before we did.  Try once again to read from the cache, our thread will be held until
				// the write is complete
				try
				{
                    getLogger().warn("InstanceInaccessibleException caused by patient [{}:{}] photo", patientIdentifier, routingToken.toString(), iaX);
					
					getLogger().debug("Finding photo ID cached instance using format from data source response.");
					InputStream cacheResponse = CommonImageCacheFunctions.streamPatientPhotoImageFromCache(
							getCommandContext(), 
							photoIdInformation.getImageUrn(), 
							photoIdInformation.getImageFormat());
					if(cacheResponse != null)
					{
						getLogger().debug("Found photo ID instance in cache from data source response.");
						return cacheResponse;
					}
                    getLogger().info("Did not get patient '{}' photo from cache", patientIdentifier);
				}
				catch(CompositeIOException cioX) 
				{
					// if we know that no bytes have been written then we we can continue
					// otherwise we have to stop here and throw an error 
					if( cioX.isBytesWrittenKnown() && cioX.getBytesWritten() == 0 || cioX.getBytesWritten() == -1 )
					{
                        getLogger().warn("IO Exception when reading from cache, continuing with direct data source stream.{} bytes were indicated to have been written.Caused by : [{}] at {}.callSynchronouslyInTransactionContext()", cioX.getBytesWritten(), cioX.getMessage(), getClass().getName());
						return streamFromPatientIdImageDataSource();
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
                getLogger().warn("SimultaneousWriteException caused by patient '{}' photo image.", patientIdentifier, swX);
				// JMW 10/3/2008
				// occurs if 2 threads are attempting to write to the cache at the same time,
				// this thread will try to get the image from the cache which should cause this 
				// thread to wait for the other thread to complete before getting the image
				try
				{
					InputStream cacheResponse = CommonImageCacheFunctions.streamPatientPhotoImageFromCache(
							getCommandContext(), 
							photoIdInformation.getImageUrn(), 
							photoIdInformation.getImageFormat());
							
					if(cacheResponse != null)
					{
						getLogger().debug("Found photo ID instance in cache from data source response.");
						return cacheResponse;
					}
                    getLogger().info("Did not get patient '{}' photo from cache", patientIdentifier);
					
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
			}
			catch(IOException ioX)
			{
				cacheOutStream = null;
				try{instanceWritableChannel.error();}catch(Throwable t){}
				getLogger().error(ioX);
			} 
			catch (ImageNotFoundException e)
            {
				//return null;
				throw e;
            }
			catch(ImageNearLineException inlX)
			{
				//scheduleRequestOfNearlineImage();
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
				InputStream cacheResponse = CommonImageCacheFunctions.streamPatientPhotoImageFromCache(
						getCommandContext(), 
						photoIdInformation.getImageUrn(), 
						photoIdInformation.getImageFormat());
						
				if(cacheResponse != null)
				{
					getLogger().debug("Found photo ID instance in cache from data source response.");
					return cacheResponse;
				}
                getLogger().info("Did not get patient '{}' photo from cache", patientIdentifier);
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
		// stream directly from data source
		InputStream result = streamFromPatientIdImageDataSource();
		return result == null ? null : result;
	}
	
	private InputStream getPatientIdentificationImage()
	throws MethodException, ConnectionException
	{
        getLogger().info("getPhotoId - Transaction ID [{}] from site [{}] for patient [{}].", transactionContext.getTransactionId(), routingToken.toString(), patientIdentifier);

		transactionContext.setServicedSource(routingToken.toRoutingTokenString());
		// if caching is enabled we will try to use the cache
		// cacheThisInstance indicates both that we write to and read from the cache for this instance
		boolean cacheThisInstance = patientIdentifier != null  &&  routingToken.getRepositoryUniqueId() != null  && getCommandContext().isCachingEnabled();

		// if the Image URN was successfully parsed and caching is enabled
		// try to retrieve the instance from the cache
		if( cacheThisInstance ) 
		{
            getLogger().info("Patient ID image '{}' from site '{}' caching enabled.", patientIdentifier, routingToken.toString());
			
			// don't get cached information, will automatically cache new information
			PatientPhotoIDInformation photoIdInformation =
				ImagingContext.getRouter().getPatientIdentificationImageInformation(routingToken, patientIdentifier, false);
			
			// if there is no photo ID information then there isn't a photo ID image
			if(photoIdInformation == null)
			{
                getLogger().info("Received null photo ID information from data source, indicates patient '{}' does not have a photo ID at site {}, returning null.", getPatientIdentifier(), getRoutingToken().toRoutingTokenString());
				return null; // indicates no photo ID for this patient at the site
			}
						
			try
			{
				// null check is unnecessary, but can't hurt!
				if(photoIdInformation != null)
				{
					InputStream cacheStream =
						CommonImageCacheFunctions.streamPatientPhotoImageFromCache(getCommandContext(), 
							photoIdInformation.getImageUrn(), photoIdInformation.getImageFormat());
					if(cacheStream != null)
					{
						transactionContext.setItemCached(Boolean.TRUE);
                        getLogger().info("Patient ID image '{}' from site '{}' found in the cache and returned stream.", patientIdentifier, routingToken.toString());
						photoIdNotification(photoIdInformation);
						return cacheStream;
						// new ImageMetadata(imageUrn, response.imageFormat, null, response.bytesReturnedFromDataSource, response.bytesReturnedFromDataSource);
					}
				}
                getLogger().info("Did not get patient ('{}') photo image from cache", patientIdentifier);
			}
			catch(CompositeIOException cioX) 
			{
				// if we know that no bytes have been written then we we can continue
				// otherwise we have to stop here and throw an error 
				if( cioX.isBytesWrittenKnown() && cioX.getBytesWritten() == 0 || cioX.getBytesWritten() == -1 )
				{
                    getLogger().warn("IO Exception when reading from cache, continuing with direct data source stream.{} bytes were indicated to have been written.Caused by : [{}] at {}.callSynchronouslyInTransactionContext()", cioX.getBytesWritten(), cioX.getMessage(), getClass().getName());
					PatientPhotoID result = streamFromDataSource();
					photoIdNotification(result.getPhotoIdInformation());
					return result == null ? null : result.getInputStream();
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

			// if we get here then caching is enabled but the instance was not found in the cache
			// we try to grab the writable byte channel as soon as possible to lock other threads from writing to
			// it
			transactionContext.setItemCached(Boolean.FALSE);
			ImmutableInstance instance = null;
			InstanceWritableByteChannel instanceWritableChannel = null;
			OutputStream cacheOutStream = null;

			PatientPhotoID photoId = null;
			try
			{				
				photoId = streamFromDataSource();
				if(photoId == null || photoId.getInputStream() == null)
				{
                    getLogger().info("Received null response from data source, indicates patient '{}' does not have a photo ID at site {}, returning null.", getPatientIdentifier(), getRoutingToken().toRoutingTokenString());
					return null; // indicates no photo ID for this patient at the site
				}
				getLogger().info("Received response from data source, putting into cache");
				// set the data source image format and image quality here 
				// since it is now in the cache.
				// JMW 10/6/2008
				// moved this here, if we get the image from the DS, need to use the format/quality from the DS to put/get the image from the cache
				// only clear these values if there is a cache exception (error writing to the cache)
				
				getLogger().debug("Attempting to create cache instance for photo image");
				instance = getCommandContext().getIntraEnterpriseCacheCache().createPatientPhotoId(photoId.getPhotoIdInformation().getImageUrn(),
					photoId.getPhotoIdInformation().getImageFormat());

				instanceWritableChannel = instance.getWritableChannel();
				cacheOutStream = Channels.newOutputStream(instanceWritableChannel);
				
				InputStream inputStream = photoId.getInputStream();
				if(cacheOutStream != null)
				{
					getLogger().info("Pumping stream into cache");
					ByteStreamPump pump = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.NetworkToNetwork);
					// if the cacheStream is null the ByteStreamPump will ignore it
					int bytesReturned = pump.xfer(inputStream, cacheOutStream);
                    getLogger().info("Wrote '{}' bytes into cache for patient photo image.", bytesReturned);
					
				}// not really sure what to do in the alternative here...
				//TODO: move to finally!
				if(inputStream != null)
				{
					// close the input stream
					inputStream.close();
				}				
				cacheOutStream.close();				
			}
			catch(InstanceInaccessibleException iaX)
			{
				// special exception handling, another thread is requesting to write to the instance
				// just before we did.  Try once again to read from the cache, our thread will be held until
				// the write is complete
				try
				{
                    getLogger().warn("InstanceInaccessibleException caused by patient [{}:{}] photo", patientIdentifier, routingToken.toString(), iaX);
					
					getLogger().debug("Finding photo ID cached instance using format from data source response.");
					InputStream cacheResponse = CommonImageCacheFunctions.streamPatientPhotoImageFromCache(getCommandContext(), 
						photoId.getPhotoIdInformation().getImageUrn(), photoId.getPhotoIdInformation().getImageFormat());
					if(cacheResponse != null)
					{
						getLogger().debug("Found photo ID instance in cache from data source response.");
						photoIdNotification(photoId.getPhotoIdInformation());
						return cacheResponse;
					}
                    getLogger().info("Did not get patient '{}' photo from cache", patientIdentifier);
				}
				catch(CompositeIOException cioX) 
				{
					// if we know that no bytes have been written then we we can continue
					// otherwise we have to stop here and throw an error 
					if( cioX.isBytesWrittenKnown() && cioX.getBytesWritten() == 0 || cioX.getBytesWritten() == -1 )
					{
                        getLogger().warn("IO Exception when reading from cache, continuing with direct data source stream.{} bytes were indicated to have been written.Caused by : [{}] at {}.callSynchronouslyInTransactionContext()", cioX.getBytesWritten(), cioX.getMessage(), getClass().getName());
						PatientPhotoID result = streamFromDataSource();
						photoIdNotification(result.getPhotoIdInformation());
						return result == null ? null : result.getInputStream();
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
                getLogger().warn("SimultaneousWriteException caused by patient '{}' photo image.", patientIdentifier, swX);
				// JMW 10/3/2008
				// occurs if 2 threads are attempting to write to the cache at the same time,
				// this thread will try to get the image from the cache which should cause this 
				// thread to wait for the other thread to complete before getting the image
				try
				{
					InputStream cacheResponse = CommonImageCacheFunctions.streamPatientPhotoImageFromCache(getCommandContext(), 
						photoId.getPhotoIdInformation().getImageUrn(),
						photoId.getPhotoIdInformation().getImageFormat());
					if(cacheResponse != null)
					{
						getLogger().debug("Found photo ID instance in cache from data source response.");
						photoIdNotification(photoId.getPhotoIdInformation());
						return cacheResponse;
					}
                    getLogger().info("Did not get patient '{}' photo from cache", patientIdentifier);
					
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
			}
			catch(IOException ioX)
			{
				cacheOutStream = null;
				try{instanceWritableChannel.error();}catch(Throwable t){}
				getLogger().error(ioX);
			} 
			catch (ImageNotFoundException e)
            {
				//return null;
				throw e;
            }
			catch(ImageNearLineException inlX)
			{
				//scheduleRequestOfNearlineImage();
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
				InputStream cacheResponse = CommonImageCacheFunctions.streamPatientPhotoImageFromCache(getCommandContext(), 
					photoId.getPhotoIdInformation().getImageUrn(),
					photoId.getPhotoIdInformation().getImageFormat());
				if(cacheResponse != null)
				{
					getLogger().debug("Found photo ID instance in cache from data source response.");
					photoIdNotification(photoId.getPhotoIdInformation());
					return cacheResponse;
				}
                getLogger().info("Did not get patient '{}' photo from cache", patientIdentifier);
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
		// stream directly from data source
		PatientPhotoID result = streamFromDataSource();
		photoIdNotification(result.getPhotoIdInformation());
		return result == null ? null : result.getInputStream();
	}

	private PatientPhotoID streamFromDataSource()
	throws MethodException, ConnectionException
	{
        getLogger().info("Patient photo image from site [{}] for patient [{}] caching disabled, getting image from source.", routingToken.toString(), patientIdentifier);
		
		PatientPhotoID photoId = 
			ImagingContext.getRouter().getPatientPhotoIdentificationImage(
				getRoutingToken(), 
				getPatientIdentifier());

        getLogger().info("{} for patient '{}'.", (photoId == null) ? "Did not find ID image" : "Found ID image", patientIdentifier);
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setItemCached(Boolean.FALSE);
		
		if(photoId != null && photoId.getPhotoIdInformation() != null)
		{
			CommonImageCacheFunctions.cachePatientIDInformation(getCommandContext(), getRoutingToken(), 
				getPatientIdentifier(), photoId.getPhotoIdInformation());
		}
		
		
		return photoId;
	}
	
	private InputStream streamFromPatientIdImageDataSource()
	throws MethodException, ConnectionException
	{
        getLogger().info("Patient photo image from site [{}] for patient [{}] caching disabled, getting image from source.", routingToken.toString(), patientIdentifier);
		
		InputStream photoId = 
			ImagingContext.getRouter().getPatientIdentificationImage(
				getRoutingToken(), 
				getPatientIdentifier());
				//true);

        getLogger().info("{} for patient '{}'.", (photoId == null) ? "Did not find ID image" : "Found ID image", patientIdentifier);
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setItemCached(Boolean.FALSE);
		
		return photoId;
	}

	private void photoIdNotification(PatientPhotoIDInformation photoIdInformation)
	{
		if(photoIdInformationNotification != null)
			photoIdInformationNotification.photoIDInformation(photoIdInformation);
	}
}
