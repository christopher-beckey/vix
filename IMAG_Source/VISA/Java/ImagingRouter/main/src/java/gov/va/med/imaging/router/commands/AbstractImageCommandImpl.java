/**
 * 
 */
package gov.va.med.imaging.router.commands;

import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.MuseImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.router.Command;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.business.*;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;
import gov.va.med.imaging.musedatasource.MuseDataSourceProvider;
import gov.va.med.imaging.musedatasource.configuration.MuseConfiguration;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.router.facade.ImagingContext;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * An abstract superclass of Study-related commands, grouped because there is significant
 * overlap in the Study commands that is contained here.
 * 
 * @author vhaiswbeckec
 *
 */
public abstract class AbstractImageCommandImpl<R extends Object> 
extends AbstractStudyCommandImpl<R>
{
	private static final long serialVersionUID = 6423391034697600460L;

	/**
	 * @param commandContext - the context available to the command
	 */
	public AbstractImageCommandImpl()
	{
		super();
	}

	/**
	 * This method should be called by any command that accesses an Image.
	 * Externally, in ClinicalDisplay only for now, an ImageAccessEvent may also 
	 * be created and posted by creating an instance of the PostImageAccessEvent
	 * implementation and submitting it for processing.
	 * 
	 * @param imageUrn
	 * @param imageQuality
	 * @throws MethodException
	 */
	protected void logImageAccessEvent(ImageURN imageUrn, ImageQuality imageQuality) 
	throws MethodException
	{
		// we don't log access to thumbnail images
		if(imageQuality == ImageQuality.THUMBNAIL)
		{
            getLogger().debug("logImageAccess - Transaction ID [{}], accessed thumbnail image [{}], skipping logging.", TransactionContextFactory.get().getTransactionId(), imageUrn.toString());
		}
		else
		{
            getLogger().info("RouterImpl.logImageAccess({}) by [{}].", imageUrn.toString(), TransactionContextFactory.get().getTransactionId());
			String siteNumber = imageUrn.getOriginatingSiteId();
			
			boolean dodImage = false;		
			if(ExchangeUtil.isSiteDOD(siteNumber))
				dodImage = true;
	
			// use originating site number here
			/*
			ImageAccessLogEvent logEvent = new ImageAccessLogEvent(imageId, "",
					imageUrn.getPatientIcn(), imageUrn.getOriginatingSiteId(), System.currentTimeMillis(), 
					"", ImageAccessLogEventType.IMAGE_ACCESS, dodImage);
			
			logImageAccessEvent(logEvent);
			*/
			getLogger().fatal(new Exception("Should not be doing logging from within the image command"));
		}
	}

	/**
	 * This method (or the above version) should be called by any command that 
	 * accesses an Image.
	 *  
	 * @param event
	 * @throws MethodException
	 */
	protected void logImageAccessEvent(ImageAccessLogEvent event)
	throws MethodException
	{
		Command<java.lang.Void> command = (Command<java.lang.Void>)  
			getCommandContext().getCommandFactory().createCommand(java.lang.Void.class, 
					"PostImageAccessEventCommand", null, 
					new Class<?>[]{ImageAccessLogEvent.class}, new Object[]{event});
		getCommandContext().getRouter().doAsynchronously(command);
	}

	protected ImageStreamResponse streamImageFromDataSource(ImageURN imageUrn, ImageFormatQualityList
			requestFormatQualityList) throws MethodException, IOException {
		Image image = findImageInCachedStudyGraph(imageUrn);
		return streamImageFromDataSource(imageUrn, requestFormatQualityList, image);
	}
	protected ImageStreamResponse streamImageFromDataSource(ImageURN imageUrn, ImageFormatQualityList
			requestFormatQualityList, Image image) throws MethodException, IOException {
		if ((imageUrn == null) || (requestFormatQualityList == null)) {
			throw new MethodException("Either imageURN or format quality has not been provided");
		}

		ImageStreamResponse imageResponse = null;
		
		String imageId = imageUrn.getImageId();

        getLogger().info("Requesting image [{}] of contentType [{}].", imageId, requestFormatQualityList.getAcceptString(true));
		
		// if the parent Study is in the cache get the Image instance from there, else we'll use the ImageURN later
		try {
			if(image != null)
			{
				imageResponse = ImagingContext.getRouter().getInstanceByImage(image, requestFormatQualityList);
				if((image.getAlienSiteNumber() != null) && (image.getAlienSiteNumber().length() > 0))
				{
					getLogger().info("Image contains alien site number, updating serviced source");
					TransactionContextFactory.get().setServicedSource(imageUrn.toRoutingTokenString() + "(" + image.getAlienSiteNumber() + ")");
				}
			}
			else {
				// Try and get the image via the router
				try {
					imageResponse = ImagingContext.getRouter().getInstanceByImageUrn(imageUrn, requestFormatQualityList);
				} catch (ImageNotFoundException e) {
					// If that failed, try MUSE if the site number and modality match
					String localSiteNUmber = getCommandContext().getRouter().getAppConfiguration().getLocalSiteNumber();
					if ((imageUrn.toString().endsWith("-MUSEECG")) && (localSiteNUmber.equals(imageUrn.getOriginatingSiteId()))) {
						getLogger().info("Image [{}] not found but MUSE modality and siteID match; attempting to fetch image via MUSE");
						imageResponse = getImageFromMuse(imageUrn, requestFormatQualityList);
					}
				}
			}

			// Check that we got contents (usually this throws an ImageNotFoundException, but this is technically possible)
			if (imageResponse == null) {
				throw new MethodException("No image found or image data returned for image [" + imageId + "]");
			}

			// Check if the actual stream is null
			if (imageResponse.getImageStream() == null) {
				throw new MethodException("No input stream returned from data source for image [" + imageId + "].");
			}

			// Check if the provided stream is actually readable
			if (!imageResponse.getImageStream().isReadable()) {
				throw new MethodException("No readable input stream returned from data source for image [" + imageId + "].");
			}

			// at this point the image has been returned
			CommonImageCacheFunctions.cacheTXTFile(getCommandContext(), imageUrn, imageResponse.getTxtStream(), false);
			
			ImageFormat curImgFormat = imageResponse.getImageFormat();
            getLogger().info("Image returned from datasource in format [{}]", curImgFormat);
			return imageResponse;	
		} catch (ConnectionException cX) {
			throw new IOException(cX);
		}
	}

	private ImageStreamResponse getImageFromMuse(ImageURN imageUrn, ImageFormatQualityList requestFormatQualityList) throws IllegalArgumentException, MethodException, ConnectionException {
		// Check imageURN
		if (imageUrn == null || requestFormatQualityList == null) {
			getLogger().error("Either required ImageUrn or ImageFormatQualityList is NOT given.");
			throw new IllegalArgumentException("Either required ImageUrn or ImageFormatQualityList is NOT given.");
		}

		// Get MUSE configuration
		MuseConfiguration museConfiguration = MuseDataSourceProvider.getMuseConfiguration();
		if (museConfiguration == null) {
			getLogger().error("No MUSE Configuration is available");
			throw new IllegalArgumentException("No MUSE Configuration is available");
		}

		// Get servers from the configuration
		List<MuseServerConfiguration> museServers = museConfiguration.getServers();
		if (museServers == null) {
			getLogger().error("No MUSE servers available in configuration");
			throw new IllegalArgumentException("No MUSE servers available in configuration");
		}

		// Iterate over available servers
		Iterator<MuseServerConfiguration> museServerIter = museServers.iterator();
		ImageStreamResponse museImageStreamResponse = null;
		while (museServerIter.hasNext() && museImageStreamResponse == null) {
			try {
				// Get the MUSE server, if available
				MuseServerConfiguration museServerConfiguration = museServerIter.next();
				if (museServerConfiguration == null) {
					continue;
				}

				// Get the MUSE server id (can be 0; is for some test contexts)
				int serverId = museServerConfiguration.getId();
                getLogger().debug("Querying MUSE server Id [{}] for image URN [{}]", serverId, imageUrn);

				// Generate a MuseImageURN for each available server
				MuseImageURN museImageURN = MuseImageURN.create(imageUrn.getOriginatingSiteId(), imageUrn.getImageId(), imageUrn.getStudyId(), imageUrn.getPatientId(), String.valueOf(museServerConfiguration.getId()), imageUrn.getImageModality());

				// Attempt to fetch the stream from the router via the URN.  If found something, loop will terminate
				museImageStreamResponse = ImagingContext.getRouter().getInstanceByImageUrn(museImageURN, requestFormatQualityList);

				// Validate the response
				if ((museImageStreamResponse == null) || (museImageStreamResponse.getImageStream() == null) || (! museImageStreamResponse.getImageStream().isReadable())) {
					museImageStreamResponse = null;
				}
			} catch (Exception e) {
                getLogger().error("Error retrieving MUSE image: {}", e.getMessage());
				throw new MethodException("Error retrieving MUSE image", e);
			}
		}

		// If we still haven't located the image, throw an exception
		if (museImageStreamResponse == null) {
			throw new ImageNotFoundException("Unable to find image [" + imageUrn + "]");
		}

		// Return the found object
		return museImageStreamResponse;
	}

	/**
	 * A method that simply makes the existence of the instance known to a derived command.
	 * 
	 * @param imageUrn
	 * @param imageQuality
	 * @param targetFormat
	 * @return
	 */
	protected boolean isInstanceInCache(
		ImageURN imageUrn, 
		ImageFormatQualityList requestAcceptList)
	{
		boolean acceptableImageInCache = false;
		
		for(ImageFormatQuality requestQuality : requestAcceptList)
		{
			acceptableImageInCache |= (CommonImageCacheFunctions.getImmutableInstance(getCommandContext(), imageUrn, requestQuality.getImageQuality(), requestQuality.getImageFormat().getMimeWithEnclosedMime()) != null);
			if(acceptableImageInCache)
				break;
		}
		
		
		return acceptableImageInCache;
	}

	/**
	 * 
	 * @param imageUrn
	 * @param outStream
	 * @return
	 * @throws MethodException
	 * @throws IOException
	 * @throws ImageNearLineException
	 * @throws ImageNotFoundException
	 */
	public int streamTXTFileFromDataSource(
			ImageURN imageUrn,
			OutputStream outStream) 
	throws MethodException, IOException, ImageNotFoundException
	{
		InputStream txtStream = null;
		DataSourceInputStream imageResponse = null;
		String imageId = imageUrn.getImageId();
		String siteNumber = imageUrn.getOriginatingSiteId();
        getLogger().info("Requesting txt file [{}] from site '{}'.", imageId, siteNumber);
		
		Image image = null;
		try 
		{
			StudyURN studyUrn = imageUrn.getParentStudyURN();
			
			Study study = getStudyFromCache(studyUrn);
			if(study != null)
			{
				Map<String,Image> images = extractImagesFromStudy(study);
				if(images.containsKey(imageUrn.getImageId())){
					image = images.get(imageUrn.getImageId());
				}

			}
		}
		catch(URNFormatException iurnfX)
		{
			getLogger().error(iurnfX);
		}
		try
		{
			if(image != null)
			{
				imageResponse = ImagingContext.getRouter().getInstanceTextFileByImage(image);
			}
			else
			{
				imageResponse = ImagingContext.getRouter().getInstanceTextFileByImageUrn(imageUrn);
			}				
			//sizedStream = imageResponse.getInputStream();
            getLogger().info("TXT file [{}] {}.", imageId, imageResponse == null ? "not found" : "found");
	
			
			
			if(imageResponse == null)
				throw new ImageNotFoundException("No input stream returned from data source for TXT file [" + imageId + "].");
			//inStream = sizedStream.getInStream();
			if(!imageResponse.isReadable())
				throw new MethodException("Unreadable input stream returned from data source for TXT file [" + imageId + "].");
			
	
			// write the input stream to the output stream, which could be the destination output stream or
			// the cache output stream (in this method we don't know or care).
			ByteStreamPump pump = ByteStreamPump.getByteStreamPump(ByteStreamPump.TRANSFER_TYPE.NetworkToNetwork);
			// if the cacheStream is null the ByteStreamPump will ignore it
			txtStream = imageResponse.getInputStream();
			return pump.xfer(txtStream, outStream);
		}
		catch(ConnectionException cX)
		{
			throw new IOException(cX);
		}
		finally
		{
			if(txtStream != null)
			{
				try
				{
					txtStream.close();					
				}
				catch(Exception ex) {getLogger().warn(ex); }
			}
		}
	}

	/**
	 * 
	 * @param imageUrn
	 * @return
	 * @throws MethodException
	 * @throws IOException
	 * @throws ImageNotFoundException
	 */
	protected DataSourceInputStream streamTXTFileFromDataSourceWithoutCache(
			ImageURN imageUrn) 
	throws MethodException, IOException, ImageNearLineException, ImageNotFoundException
	{
		DataSourceInputStream imageResponse = null;
		String imageId = imageUrn.getImageId();
		String siteNumber = imageUrn.getOriginatingSiteId();
        getLogger().info("Requesting txt file [{}] from site '{}'. No caching", imageId, siteNumber);
		
		try
		{
			imageResponse = ImagingContext.getRouter().getInstanceTextFileByImageUrn(imageUrn);
			//sizedStream = imageResponse.getInputStream();
            getLogger().info("TXT file [{}] {}.", imageId, imageResponse == null ? "not found" : "found");
			
			if(imageResponse == null)
				throw new ImageNotFoundException("No input stream returned from data source for TXT file [" + imageId + "].");
			//inStream = sizedStream.getInStream();
			if(!imageResponse.isReadable())
				throw new MethodException("Unreadable input stream returned from data source for TXT file [" + imageId + "].");
			
			TransactionContext transactionContext = TransactionContextFactory.get();

			//Use in the Viewer
			//boolean isViewerProcess = (transactionContext.isViewerProcess() == null ? false : transactionContext.isViewerProcess());

			//if (isViewerProcess)
			//{
            getLogger().debug("Viewer Head Request: CacheFilename: {}", transactionContext.getCacheFilename());
				transactionContext.setCacheFilename(imageResponse.getFilePath());
				transactionContext.setStorageSiteNumber(imageResponse.getStorageSiteNumber());
				transactionContext.setStorageUsername(imageResponse.getStorageUsername());
				transactionContext.setStoragePassword(imageResponse.getStoragePassword());
			//}
	
			return imageResponse;
		}
		catch(ConnectionException cX)
		{
			throw new IOException(cX);
		}
	}


}
