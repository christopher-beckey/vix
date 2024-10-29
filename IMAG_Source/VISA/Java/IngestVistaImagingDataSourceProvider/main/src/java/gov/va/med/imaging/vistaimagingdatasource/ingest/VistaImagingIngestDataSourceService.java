/**
 * 
 * 
 * Date Created: Dec 5, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.vistaimagingdatasource.ingest;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.exchange.FileTypeIdentifierStream;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.vistaimagingdatasource.ingest.conversion.GifConversion;
import gov.va.med.imaging.vistaimagingdatasource.ingest.conversion.MovConversion;
import gov.va.med.imaging.vistaimagingdatasource.ingest.conversion.Mp4Conversion;
import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.enums.VistaImageType;
import gov.va.med.imaging.ingest.business.ImageIngestParameters;
import gov.va.med.imaging.ingest.datasource.ImageIngestDataSourceSpi;
import gov.va.med.imaging.protocol.vista.VistaImagingTranslator;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.url.vista.image.ImagingStorageCredentials;
import gov.va.med.imaging.url.vista.storage.VistaImagingStorageManager;
import gov.va.med.imaging.vista.storage.SmbStorageUtility;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.AbstractVistaImagingDataSourceService;
import gov.va.med.imaging.vistaimagingdatasource.VistaImagingQueryFactory;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;
import gov.va.med.imaging.vistaimagingdatasource.ingest.configuration.VistaImagingIngestConfiguration;

import javax.imageio.ImageIO;
import javax.imageio.ImageReader;

/**
 * @author Administrator
 *
 */
public class VistaImagingIngestDataSourceService
extends AbstractVistaImagingDataSourceService
implements ImageIngestDataSourceSpi
{
	public final static String SUPPORTED_PROTOCOL = "vistaimaging";

	private final static Logger logger = Logger.getLogger(VistaImagingIngestDataSourceService.class);
	// The required version of VistA Imaging needed to execute the RPC calls for this operation
	public final static String MAG_REQUIRED_VERSION ="3.0P59";

	private static int fileCounter = 1;


	private SmbStorageUtility storageUtility = new SmbStorageUtility();
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public VistaImagingIngestDataSourceService(ResolvedArtifactSource resolvedArtifactSource, 
			String protocol)
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}

	public static VistaImagingIngestDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws ConnectionException, UnsupportedProtocolException
	{
		return new VistaImagingIngestDataSourceService(resolvedArtifactSource, protocol);
	}
	
	/**
	 * The artifact source must be checked in the constructor to assure that it is an instance
	 * of ResolvedSite.
	 * 
	 * @return
	 */
	protected ResolvedSite getResolvedSite()
	{
		return (ResolvedSite)getResolvedArtifactSource();
	}
	
	protected Site getSite()
	{
		return getResolvedSite().getSite();
	}
	
	private VistaSession getVistaSession() 
    throws IOException, ConnectionException, MethodException
    {
	    return VistaSession.getOrCreate(getMetadataUrl(), getSite());
    }
	
	private Logger getLogger()
	{
		return logger;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImagingPatientDataSource#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible() 
	throws SecurityCredentialsExpiredException
	{
		String version = VistaImagingCommonUtilities.getVistaDataSourceImagingVersion(
				getVistaImagingConfiguration(), this.getClass(), 
				MAG_REQUIRED_VERSION);

        logger.info("isVersionCompatible searching for version [{}], TransactionContext ({}).", version, TransactionContextFactory.get().getDisplayIdentity());
		VistaSession localVistaSession = null;
		try
		{
			localVistaSession = getVistaSession();	
			return VistaImagingCommonUtilities.isVersionCompatible(version, localVistaSession);	
		}
		catch(SecurityCredentialsExpiredException sceX)
		{
			// caught here to be sure it gets thrown as SecurityCredentialsExpiredException, not ConnectionException
			throw sceX;
		}
		catch(MethodException mX)
		{
			logger.error("There was an error finding the installed Imaging version from VistA", mX);
			TransactionContextFactory.get().addDebugInformation("isVersionCompatible() failed, " + (mX == null ? "<null error>" : mX.getMessage()));
		}
		catch(ConnectionException cX)
		{
			logger.error("There was an error finding the installed Imaging version from VistA", cX);
			TransactionContextFactory.get().addDebugInformation("isVersionCompatible() failed, " + (cX == null ? "<null error>" : cX.getMessage()));
		}		
		catch(IOException ioX)
		{
			logger.error("There was an error finding the installed Imaging version from VistA", ioX);
			TransactionContextFactory.get().addDebugInformation("isVersionCompatible() failed, " + (ioX == null ? "<null error>" : ioX.getMessage()));
		}
		finally
		{
			if (localVistaSession != null) {
				try {
					localVistaSession.close();
				} catch (Throwable t) {
				}
			}
		}		
		return false;
	}
	
	protected String getDataSourceVersion()
	{
		return "1";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.ingest.datasource.ImageIngestDataSourceSpi#storeImage(gov.va.med.RoutingToken, java.io.InputStream)
	 */
	@Override
	public ImageURN storeImage(RoutingToken globalRoutingToken,
		InputStream imageInputStream, ImageIngestParameters imageIngestParameters, boolean createGroup)
	throws MethodException, ConnectionException
	{
		ImageFormat imageFormat = imageIngestParameters.getImageFormat();
		if(imageFormat == ImageFormat.ORIGINAL || imageFormat == ImageFormat.ANYTHING
				|| imageFormat == ImageFormat.TEXT_PLAIN){
			imageFormat = determineImageFormat(imageIngestParameters.getOriginalFilename(), imageIngestParameters.getMimeType());
		}
		VistaImageType vistaImageType = VistaImageType.getFromImageFormat(imageFormat);
		//VistaImageType vistaImageType = VistaImageType.getFromImageFormat(imageIngestParameters.getImageFormat());
		String cacheFilePath = null;
		String convertingFilename = null;
		String convertedFilename = null;
		FileInputStream convertedFileInputStream = null;
		FileTypeIdentifierStream convertedFileTypeIdentifierStream = null;
		BufferedInputStream finalStream = null;
		try {
			boolean isConverted = false;
			boolean isMP4Convert = VistaImagingIngestDataSourceProvider.getConfiguration().isConvertMP4ToAVI();
			if (vistaImageType == null || !isFormatAllowedForVistaImaging(vistaImageType) || (vistaImageType == VistaImageType.MP4 && isMP4Convert)) {
				isConverted = true;
				//IF format is not allowed, see if possible to convert to an allowable format.
				//	This only applies to mimes video/mov and image/gif at this time.
				cacheFilePath = generateConvertingFoldername();
				convertingFilename = generateConvertingFilename(imageFormat);

				FileTypeIdentifierStream fileTypeIdentifierStream = new FileTypeIdentifierStream(imageInputStream);
				//boolean isMultiImage = fileTypeIdentifierStream.isMultiImageGIF();
				//String cachedFilespec = cacheFilePath + File.separatorChar + convertingFilename;

				String cachedImageFilename = cacheImageForConversion(fileTypeIdentifierStream, cacheFilePath, convertingFilename);

				convertedFilename = convertImageFormat(cacheFilePath, convertingFilename, imageFormat);

				String convertedFilespec = cacheFilePath + File.separatorChar + convertedFilename;
				try {
					convertedFileInputStream = new FileInputStream(convertedFilespec);
					convertedFileTypeIdentifierStream = new FileTypeIdentifierStream(convertedFileInputStream);
					ImageFormat convertedImageFormat = null;
					if (convertedFilename.endsWith(".jpg")) {
						convertedImageFormat = ImageFormat.JPEG;
					} else if (convertedFilename.endsWith(".avi")) {
						convertedImageFormat = ImageFormat.AVI;
					} else {
						convertedImageFormat = convertedFileTypeIdentifierStream.getImageFormat();
					}
					imageIngestParameters.setImageFormat(convertedImageFormat);
					vistaImageType = VistaImageType.getFromImageFormat(convertedImageFormat);
				} catch (FileNotFoundException fnfX) {
					throw new MethodException("File not found, [" + convertedFilespec + "]", fnfX);
				}

				if (vistaImageType == null || !isFormatAllowedForVistaImaging(vistaImageType)) {
					throw new MethodException("VistaImageType [" + vistaImageType.getImageType() +
							"] is not supported, cannot import image");
				}
				finalStream = new BufferedInputStream(convertedFileTypeIdentifierStream);
			} else {
				finalStream = new BufferedInputStream(imageInputStream);
			}

			VistaCommonUtilities.setDataSourceMethodAndVersion("storeImage", getDataSourceVersion());
			VistaSession vistaSession = null;
            getLogger().info("storeImage({}) TransactionContext ({}).", imageIngestParameters.getPatientIdentifier().toString(), TransactionContextFactory.get().getTransactionId());
			try {
				vistaSession = getVistaSession();
				String patientDfn = getPatientDfn(vistaSession, imageIngestParameters.getPatientIdentifier());

				StudyURN studyUrn = imageIngestParameters.getStudyUrn();
				VistaQuery siteIenQuery = VistaImagingIngestQueryFactory.createGetSiteIen(getSite().getSiteNumber());
				String siteIen = vistaSession.call(siteIenQuery).trim();

				if (studyUrn == null && createGroup) {
					studyUrn = createImageGroup(vistaSession, imageIngestParameters, patientDfn, siteIen);
				}

				VistaQuery query = VistaImagingIngestQueryFactory.createImportImageQuery(imageIngestParameters,
						patientDfn, studyUrn, siteIen);

				String rtn = vistaSession.call(query);
				if (rtn.startsWith("0"))
					throw new MethodException("Error storing image, " + rtn);

				String imageIen = StringUtils.MagPiece(rtn, StringUtils.CARET, 1);
				String imageDirectory = StringUtils.MagPiece(rtn, StringUtils.CARET, 2);
				String imageFilename = StringUtils.MagPiece(rtn, StringUtils.CARET, 3);
                logger.info("Created image entry [{}] with file path [{}{}]", imageIen, imageDirectory, imageFilename);
				ImageURN imageURN = storeImage(vistaSession, finalStream, imageIen, imageDirectory,
						imageFilename, imageIngestParameters, patientDfn, vistaImageType);
				if (isConverted) {
					purgeConvertingFiles(cacheFilePath, convertingFilename, convertedFilename);
				}

				return imageURN;
			} catch (VistaMethodException vmX) {
				throw new MethodException(vmX);
			} catch (InvalidVistaCredentialsException icX) {
				throw new InvalidCredentialsException(icX);
			} catch (IOException ioX) {
				throw new ConnectionException(ioX);
			} finally {
				if (vistaSession != null) {
					try {
						vistaSession.close();
					} catch (Throwable t) {
					}
				}
			}
		} finally {
			if (convertedFileInputStream != null) {
				try {
					convertedFileInputStream.close();
				} catch (Exception e) {
					// Ignore
				}
			}

			if (convertedFileTypeIdentifierStream != null) {
				try {
					convertedFileTypeIdentifierStream.close();
				} catch (Exception e) {
					// Ignore
				}
			}

			if (finalStream != null) {
				try {
					finalStream.close();
				} catch (Exception e) {
					// Ignore
				}
			}
		}
	}
	
	private StudyURN createImageGroup(VistaSession vistaSession, ImageIngestParameters imageIngestParameters, 
		String patientDfn, String siteIen)
	throws MethodException, IOException, InvalidVistaCredentialsException, VistaMethodException
	{
		VistaQuery query = VistaImagingIngestQueryFactory.createGroupQuery(imageIngestParameters, 
			patientDfn, siteIen);
		String rtn = vistaSession.call(query);
		if(rtn.startsWith("0"))
			throw new MethodException("Error creating group, " + rtn);
		String studyIen = StringUtils.MagPiece(rtn, StringUtils.CARET, 1);
		
		try
		{
			StudyURN studyUrn = StudyURN.create(getSite().getRepositoryId(), studyIen, 
				imageIngestParameters.getPatientIdentifier().getValue());
			studyUrn.setPatientIdentifierTypeIfNecessary(imageIngestParameters.getPatientIdentifier().getPatientIdentifierType());
			return studyUrn;
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException(urnfX);
		}
	}
	
	private String cacheImage(InputStream inputStream, String imageIen, String imageFilename)
	throws MethodException
	{
		OutputStream output = null;
		
		try
		{
			String filename = getTempFilename(imageIen, imageFilename);
            logger.info("Caching image [{}] locally to [{}]", imageIen, filename);
			output = new FileOutputStream(filename);
			ByteStreamPump pump = ByteStreamPump.getByteStreamPump();
			pump.xfer(inputStream, output);
			return filename;
		}		
		catch (FileNotFoundException fnfX)
		{
			throw new MethodException("Error caching image [" + imageIen + "], " + fnfX.getMessage());
		}
		catch(IOException ioX)
		{
			throw new MethodException("Error caching image [" + imageIen + "], " + ioX.getMessage());
		}
		finally
		{
			if(output != null)
				try {output.close();} catch(Exception ex) {}
			if(inputStream != null)
				try {inputStream.close();} catch(Exception ex) {}
		}		
	}

	private String cacheImageForConversion(InputStream inputStream, String convertingFilePath, String imageFilename)
			throws MethodException
	{
		OutputStream output = null;

		try
		{
			String filename = convertingFilePath + File.separatorChar + imageFilename;
            logger.info("Caching image locally to [{}]", filename);
			output = new FileOutputStream(filename);
			ByteStreamPump pump = ByteStreamPump.getByteStreamPump();
			pump.xfer(inputStream, output);
			return filename;
		}
		catch (FileNotFoundException fnfX)
		{
			throw new MethodException("Error caching image [" + imageFilename + "], " + fnfX.getMessage());
		}
		catch(IOException ioX)
		{
			throw new MethodException("Error caching image [" + imageFilename + "], " + ioX.getMessage());
		}
		finally
		{
			if(output != null)
				try {output.close();} catch(Exception ex) {}
			if(inputStream != null)
				try {inputStream.close();} catch(Exception ex) {}
		}
	}

	private String getTempFilename(String imageIen, String imageFilename)
	{
		String tempImageDirectory = VistaImagingIngestDataSourceProvider.getConfiguration().getTempImageDirectory();
		
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		File todayDirectory = new File(tempImageDirectory + File.separatorChar + 
			dateFormat.format(new Date()) + File.separatorChar + imageIen);
		if(!todayDirectory.exists())
		{
			todayDirectory.mkdirs();
		}
		return todayDirectory.getAbsolutePath() + File.separatorChar + imageFilename;
	}

	private void deleteImageEntry(VistaSession vistaSession, String imageIen)
	throws IOException, InvalidVistaCredentialsException, VistaMethodException
	{
		VistaQuery query = VistaImagingIngestQueryFactory.createDeleteImageEntryQuery(imageIen);
		String rtn = vistaSession.call(query);
		if(rtn.startsWith("0"))
			throw new VistaMethodException("Error deleting image [" + imageIen + "], " + rtn);
	}

	private ImageURN storeImage(VistaSession vistaSession, InputStream imageInputStream, String ien, String imageDirectory, String imageFilename,
		ImageIngestParameters imageIngestParameters, String patientDfn, VistaImageType vistaImageType)
	throws MethodException, IOException, ConnectionException, InvalidVistaCredentialsException, VistaMethodException
	{
		String cachedImageFilename = null;
		try
		{
			cachedImageFilename = cacheImage(imageInputStream, ien, imageFilename);
			
			// if the image is a JPG then the orientation of the image might need to be adjusted. Only JPG supported
			if(vistaImageType == VistaImageType.JPEG)
			{				
				String cachedUpdatedImageFilename = createAdjustedImageFilename(cachedImageFilename);
				if(ImageOrientationAdjuster.adjustImageOrientation(cachedImageFilename, cachedUpdatedImageFilename))
					cachedImageFilename = cachedUpdatedImageFilename;
			}
			
			String serverShare = VistaImagingTranslator.extractServerShare(imageDirectory);
            logger.info("Storing image on share [{}]", serverShare);
			ImagingStorageCredentials imagingStorageCredentials = null;
            logger.info("Searching for Imaging Storage Credentials for server share [{}]", serverShare);
			imagingStorageCredentials = VistaImagingStorageManager.getImagingStorageCredentialsFromCache(imageDirectory, getSite().getSiteNumber());
			if(imagingStorageCredentials == null)
			{
                logger.info("Imaging Storage Credentials for site '{}' does not exist in the network location cache, getting from VistA", getSite().getSiteNumber());
				imagingStorageCredentials = VistaImagingStorageManager.getImagingStorageCredentialsFromVista(vistaSession, serverShare, getSite());					
			}
			else
			{
                logger.info("Imaging Storage Credentials for [{}] found in the network location cache", serverShare);
			}
			String imageFullFilename = imageDirectory + imageFilename;			
			if(imagingStorageCredentials == null)
			{
				String msg = "No Imaging Storage Credentials found for image share [" + serverShare + "] for image [" + imageFullFilename + "]";
				logger.error(msg);
				throw new MethodException(msg);
			}
			
			try
			{
				int bytes = moveFile(cachedImageFilename, imageFullFilename, imagingStorageCredentials, false);
				TransactionContext transactionContext = TransactionContextFactory.get();
				transactionContext.setDataSourceBytesSent(new Long(bytes));
				// JMW - 1/17/2014 not really the right place for this information however since the input from the facade is never changed, 
				// what is stored is what was received so this is safe to say (even if ugly)
				transactionContext.setFacadeBytesReceived(new Long(bytes));
			}
			catch(IOException ioX)
			{
				deleteImageEntry(vistaSession, ien);
				throw new MethodException("Error copying image [" + ien + "] to network share, deleting image entry, " + ioX.getMessage());
			}
			VistaImageInformation vistaImageInformation = null;
			
			if(vistaImageType.isGenerateThumbnail())
			{
				vistaImageInformation = createThumbnail(vistaSession, cachedImageFilename, imageFullFilename, ien, imagingStorageCredentials);
			}
			else
			{
                logger.info("Image [{}] of format [{}] uses a canned abstract, thumbnail will not be generated.", ien, vistaImageType);
				vistaImageInformation = getImageInformation(vistaSession, ien);
			}			
				
			createTextFile(vistaSession, patientDfn, imagingStorageCredentials, imageFullFilename, imageIngestParameters);
			addImageQueueEntries(vistaSession, ien, imageFilename);
			return createImageURN(vistaImageInformation, ien, imageIngestParameters.getPatientIdentifier());
		}
		finally
		{
			if(cachedImageFilename != null)
				purgeCachedImages(cachedImageFilename);
		}
	}
	
	private String createAdjustedImageFilename(String cachedFilename)
	{
		int loc = cachedFilename.lastIndexOf(".");
		return cachedFilename.substring(0, loc) + "_adjusted" + cachedFilename.substring(loc);
	}
	
	private void purgeCachedImages(String cachedImageFilename)
	{
		File cachedImage = new File(cachedImageFilename);
		File parentDirectory = cachedImage.getParentFile();
		if(parentDirectory.exists())
		{
            logger.info("Deleting cached directory [{}]", parentDirectory.getAbsolutePath());
			for(File file : parentDirectory.listFiles())
			{
				file.delete();
			}
			parentDirectory.delete();			
		}
	}
	
	private void createTextFile(VistaSession vistaSession, String patientDfn,
		ImagingStorageCredentials imagingStorageCredentials, String imageFilePath,
		ImageIngestParameters imageIngestParameters)
	throws IOException, InvalidVistaCredentialsException, VistaMethodException, MethodException
	{
		String textFilePath = storageUtility.changeFileExtension(imageFilePath, "TXT");
		PrintWriter writer = null;		
		Patient patient = getPatientInformation(vistaSession, patientDfn);
		
		try
		{
			OutputStream outputStream = storageUtility.openOutputStream(textFilePath, imagingStorageCredentials);
			writer = new PrintWriter(outputStream);
			/*
			 * 
			 	t.Add('$$BEGIN IMAGE DATA');
			    t.Add('TRANSACTION_ID=' + FTrkNum);
			
			    FDBBroker.RPMagPatInfo(stat, patinfo, FDFN);
			    t.Add('PATIENTS_NAME=' + FMagUtils.magpiece(patinfo, '^',
			                  3));
			    //Pt Name );
			    t.Add('PATIENTS_ID=' + FMagUtils.magpiece(patinfo, '^', 6));
			    //Pt SSN );
			    t.Add('PATIENTS_BIRTH_DATE=' + FMagUtils.magpiece(patinfo,
			                    '^', 5));
			    //Pt DOB );
			    t.Add('PATIENTS_SEX=' + FMagUtils.magpiece(patinfo, '^',
			                  4));
			    // PT SEX );
			    t.Add('IMAGE_DATE=' + CapDt);
			    t.Add('CAPTURED BY=' + CapBy);
			    t.Add('ACQ_DEVICE=' + FAcqDev);
			    
			    t.Add('$$END IMAGE DATA');
			 */
			TransactionContext transactionContext = TransactionContextFactory.get();
			
			writer.write("$$BEGIN IMAGE DATA\r\n");
			writer.write("TRANSACTION_ID=" + (imageIngestParameters.getTrackingNumber() == null ? "" : imageIngestParameters.getTrackingNumber()) + "\r\n");
			writer.write("PATIENTS_NAME=" + patient.getPatientName() + "\r\n");
			writer.write("PATIENTS_DFN=" + patientDfn + "\r\n");
			writer.write("PATIENTS_ID=" + StringUtils.cleanString(patient.getSsn()) + "\r\n");
			SimpleDateFormat dobFormat = new SimpleDateFormat("MM/dd/yy");
			writer.write("PATIENTS_BIRTH_DATE=" + dobFormat.format(patient.getDob()) + "\r\n");
			writer.write("PATIENTS_SEX=" + patient.getPatientSex().name().toUpperCase() + "\r\n");
			SimpleDateFormat imageDateFormat = new SimpleDateFormat("MMM dd, yyyy@HH:mm");
			writer.write("IMAGE_DATE=" + (imageIngestParameters.getCaptureDate() == null ? "" : imageDateFormat.format(imageIngestParameters.getCaptureDate())) + "\r\n");
			writer.write("CAPTURED BY=" + transactionContext.getFullName() + "\r\n");
			writer.write("ACQ_DEVICE=" + (imageIngestParameters.getAcquisitionDevice() == null ? "" : imageIngestParameters.getAcquisitionDevice()) + "\r\n");
			writer.write("$$END IMAGE DATA\r\n");
            logger.info("Wrote text file to [{}]", textFilePath);
		}
		finally
		{
			if(writer != null)
				try {writer.close();} catch(Exception ex) {}
		}
	}
	
	private VistaImageInformation createThumbnail(VistaSession vistaSession, String tempFilename, 
		String imageFilePath, String imageIen, ImagingStorageCredentials imagingStorageCredentials) 
	throws IOException, InvalidVistaCredentialsException, VistaMethodException
	{
		String absFilePath = storageUtility.changeFileExtension(imageFilePath, "ABS");
		String tempAbsFilePath = storageUtility.changeFileExtension(tempFilename, "ABS");
		VistaImageInformation vistaImageInformation = getImageInformation(vistaSession, imageIen);
		String magneticImageNetworkLocationIen = vistaImageInformation.getMagneticNetworkLocationIen(); // use to set the stored image (hack!)
		
		VistaImagingIngestConfiguration configuration = VistaImagingIngestDataSourceProvider.getConfiguration();
		
		StringBuilder sb = new StringBuilder();
		sb.append(configuration.getThumbnailMakerExe());
		sb.append(" -s ");
		sb.append("\"" + tempFilename + "\"");
		sb.append(" -d ");
		sb.append("\"" + tempAbsFilePath + "\"");
		sb.append(" -f JPG");

        logger.info("Creating thumbnail with parameters [{}]", sb.toString());
		Process process = Runtime.getRuntime().exec(sb.toString());
		try
		{
			process.waitFor();
		}
		catch(InterruptedException iX)
		{
            logger.error("Error creating thumbnail, {}", iX.getMessage());
			return vistaImageInformation;
		}
		
		File tempAbsFile = new File(tempAbsFilePath);
		if(!tempAbsFile.exists())
		{
            logger.warn("Did not create thumbnail with filename [{}], cannot generate thumbnail", tempAbsFilePath);
			return vistaImageInformation;
		}
		
		// stuff to do:
		/*
		 * 1) Copy image to temp location - DONE
		 * 2) stream from temp to server - DONE
		 * 3) generate thumbnail in temp - DONE
		 * 4) move thumbnail to server - DONE
		 * 5) call RPC to update abs file path 
		 * 6) delete temp image and thumbnail - DONE (later)
		 * 7) use VistaImageInformation from this method to create the URN (rather than get this info twice) - DONE
		 * 
		 * 
		 */
		moveFile(tempAbsFilePath, absFilePath, imagingStorageCredentials, true);
		
		// call RPC to set the path of the abstract
		VistaQuery query = VistaImagingIngestQueryFactory.createUpdateThumbnailNetworkLocationQuery(imageIen, magneticImageNetworkLocationIen);
		vistaSession.call(query);
		
		return vistaImageInformation;
	}
	
	private int moveFile(String localFilePath, String remoteFilePath, 
		ImagingStorageCredentials imagingStorageCredentials, boolean deleteLocalWhenDone)
	throws IOException
	{
		int bytes = 0;
		InputStream inputStream = null;
		OutputStream outputStream = null;
		try
		{
			inputStream = new FileInputStream(localFilePath);
			outputStream = storageUtility.openOutputStream(remoteFilePath, imagingStorageCredentials);
			ByteStreamPump pump = ByteStreamPump.getByteStreamPump();
			bytes = pump.xfer(inputStream, outputStream);
            logger.info("Wrote [{}] to image [{}]", bytes, remoteFilePath);
		}
		finally
		{
			if(inputStream != null)
				try {inputStream.close();} catch(Exception ex) {}
			if(outputStream != null)
				try {outputStream.close();} catch(Exception ex) {}
		}
		if(deleteLocalWhenDone)
		{
			File localFile = new File(localFilePath);
			localFile.delete();
		}
		return bytes;
	}
	
	private void addImageQueueEntries(VistaSession vistaSession, String imageIen, String imageFilename)
	throws IOException, InvalidVistaCredentialsException, VistaMethodException
	{

		boolean generateAbs = false;// isAbstractGeneratedForExtension(extension);
        logger.info("Adding queue entries for image [{}], creating abstract [{}]", imageIen, generateAbs);
		
		VistaQuery query = VistaImagingIngestQueryFactory.createAbsJBQueueQuery(imageIen, generateAbs);
		vistaSession.call(query);
		query = VistaImagingIngestQueryFactory.createPostProcessQueuesQuery(imageIen);
		vistaSession.call(query);
	}

	private ImageURN createImageURN(VistaImageInformation vistaImageInformation, String imageIen, PatientIdentifier patientIdentifier)
	throws MethodException
	{
		try
		{
			ImageURN imageUrn = ImageURN.create(getSite().getSiteNumber(), imageIen, vistaImageInformation.getGroupIen(), 
				patientIdentifier.getValue());
			imageUrn.setPatientIdentifierTypeIfNecessary(patientIdentifier.getPatientIdentifierType());
			return imageUrn;
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException(urnfX);
		}
	}
	
	private Patient getPatientInformation(VistaSession vistaSession, String patientDfn) 
	throws IOException, InvalidVistaCredentialsException, VistaMethodException, MethodException
	{
		VistaQuery query = VistaImagingQueryFactory.createGetPatientInfoQuery(patientDfn);
		String rtn = vistaSession.call(query);
		if(rtn.startsWith("0"))
			throw new MethodException("Patient [" + patientDfn + "] not found");
		try
		{
			return VistaImagingTranslator.convertPatientInfoResultsToPatient(rtn, false); // sensitivity doesn't matter for this
		}
		catch(ParseException pX)
		{
			throw new MethodException("Error parsing patient DOB date, " + pX.getMessage());
		}
	}
	
	private VistaImageInformation getImageInformation(VistaSession vistaSession, String imageIen) 
	throws IOException, InvalidVistaCredentialsException, VistaMethodException
	{
		VistaQuery query =
			VistaImagingIngestQueryFactory.createGetImageInformationQuery(imageIen);
		String rtn = vistaSession.call(query);
		return new VistaImageInformation(imageIen, rtn); 
	}

	private boolean isFormatAllowedForVistaImaging(VistaImageType vistaImageType){

		for (VistaImageType type : VistaImageType.values()) {
			if(vistaImageType == type) {
				return true;
			}
		}
		return false;
	}


	protected String generateConvertingFoldername(){
		File convertingFolder = null;
		String tempImageDirectory = VistaImagingIngestDataSourceProvider.getConfiguration().getTempImageDirectory();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		convertingFolder = new File(tempImageDirectory + File.separatorChar + dateFormat.format(new Date()));
		if(!convertingFolder.exists())
		{
			convertingFolder.mkdirs();
		}
		return convertingFolder.getAbsolutePath();
	}


	protected String generateConvertingFilename(ImageFormat imageFormat) {

		SimpleDateFormat timeFormat = new SimpleDateFormat("HHmmssSSS");
		String imageFilename = null;
		long threadId = Thread.currentThread().getId();
			imageFilename =  threadId + StringUtil.DASH + getCount() + StringUtil.DASH + timeFormat.format(new Date())
					+ StringUtil.PERIOD + imageFormat.getExtension();
		return imageFilename;
	}


	private synchronized int getCount(){
		return fileCounter++;
	}


	//need to purge temp converting files
	protected void purgeConvertingFiles(String convertingFoldername, String convertingFilename, String convertedFilename){

		if(convertingFoldername == null) {
			return;
		}
        logger.info("Deleting cached conversion files in [{}]", convertingFoldername);

		if(convertingFilename != null){
			File file1 = new File(convertingFoldername + File.separatorChar + convertingFilename);
			file1.delete();
		}
		if(convertedFilename != null){
			File file2 = new File(convertingFoldername + File.separatorChar + convertedFilename);
			file2.delete();
		}
	}

	private String convertImageFormat(String cacheFilePath, String cachedFilename, ImageFormat imageFormat) throws MethodException {
		String convertedFilename = null;
		if (imageFormat == ImageFormat.MOV) {
			MovConversion movConversion = new MovConversion();
			convertedFilename = movConversion.convertMovVideo(cacheFilePath, cachedFilename, imageFormat);
		}
		else if (imageFormat == ImageFormat.MP4) {
			Mp4Conversion mp4Conversion = new Mp4Conversion();
			convertedFilename = mp4Conversion.convertMP4Video(cacheFilePath, cachedFilename, imageFormat);
		}
		else if (imageFormat == ImageFormat.GIF) {
			GifConversion gifConversion = new GifConversion();
			boolean isMultiFrameGIF = false;
			try {
				isMultiFrameGIF = gifConversion.isGIFMultiImage(cacheFilePath+File.separatorChar + cachedFilename);
			} catch (IOException e) {
				getLogger().warn("Failed to check if GIF file is single- or multi-image.  Will assume single-image.");
			}
			if(isMultiFrameGIF){
				convertedFilename = gifConversion.convertMultiImageGif(cacheFilePath, cachedFilename, imageFormat);
			}
			else{
				convertedFilename = gifConversion.convertSingleImageGif(cacheFilePath, cachedFilename, imageFormat);
			}
		}
		return convertedFilename;
	}

	private ImageFormat determineImageFormat(String originalFilename, String mimeType){
		ImageFormat result = null;

		String extension = null;
		extension = StringUtil.MagPiece(originalFilename, StringUtil.PERIOD, 2);
		if(extension != null && extension.length() == 3){
			extension = extension.toUpperCase(Locale.ENGLISH);
			for(ImageFormat imageFormat : ImageFormat.values()){
				if(imageFormat.getExtension().equals(extension)){
					return imageFormat;
				}
			}
		}
		else {
			if (isMOVmimeType(mimeType)) {
				result = ImageFormat.MOV;
			} else if (isGIFmimeType(mimeType)) {
				result = ImageFormat.GIF;
			} else if (isMP4mimeType(mimeType)) {
				result = ImageFormat.MP4;
			}
		}
		return result;
	}

	private boolean isMOVmimeType(String mimeType){
		if(mimeType.equals("video/quicktime") || mimeType.equals("video/mov") || mimeType.equals("video/x-quicktime")){
			return true;
		}
		return false;
	}

	private boolean isGIFmimeType(String mimeType){
		if(mimeType.equals("image/gif")){
			return true;
		}
		return false;
	}

	private boolean isMP4mimeType(String mimeType){
		if(mimeType.equals("video/mp4")){
			return true;
		}
		return false;
	}

}
