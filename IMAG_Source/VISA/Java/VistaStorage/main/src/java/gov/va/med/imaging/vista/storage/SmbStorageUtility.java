/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 6, 2008
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
package gov.va.med.imaging.vista.storage;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.MalformedURLException;
import java.net.UnknownHostException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Scanner;

import gov.va.med.imaging.utils.FileUtilities;
import gov.va.med.imaging.utils.NetUtilities;
import jcifs.smb.*;
import org.apache.commons.io.FilenameUtils;
import gov.va.med.logging.Logger;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.ImageStorageFacade;
import gov.va.med.imaging.core.interfaces.StorageCredentials;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.ImageStreamResponse;
import gov.va.med.imaging.exchange.enums.StorageProximity;
import gov.va.med.imaging.exchange.storage.AbstractBufferedImageStorageFacade;
import gov.va.med.imaging.exchange.storage.ByteBufferBackedImageInputStream;
import gov.va.med.imaging.exchange.storage.ByteBufferBackedImageStreamResponse;
import gov.va.med.imaging.exchange.storage.ByteBufferBackedInputStream;
import gov.va.med.imaging.exchange.storage.DataSourceImageInputStream;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.vista.storage.configuration.VistaStorageConfiguration;
import jcifs.CIFSContext;
import jcifs.CIFSException;
import jcifs.config.PropertyConfiguration;
import jcifs.context.BaseContext;
import jcifs.context.SingletonContext;
import jcifs.util.transport.TransportException;

/**
 * Utility functions to open image shares and retrieve files
 * 
 * @author VHAISWWERFEJ
 *
 */
public class SmbStorageUtility
extends AbstractBufferedImageStorageFacade
implements ImageStorageFacade
{
	private final static Logger logger = Logger.getLogger(SmbStorageUtility.class);

	public final static int DEFAULT_MAX_RETRIES = 3;
	public final static long DEFAULT_RETRY_DELAY = 2000L;

	// parameters that affect retry logic for off-line images.
	private int maxNearLineRetries = DEFAULT_MAX_RETRIES;
	private long nearLineRetryDelay = DEFAULT_RETRY_DELAY;	
	
	private int getNearLineRetries()
    {
	    return maxNearLineRetries;
    }

	public long getNearLineRetryDelay()
    {
    	return nearLineRetryDelay;
    }
	
	static
	{
		Properties props = new Properties();
		props.put("jcifs.netbios.cachePolicy", "3600"); 
		props.put("jcifs.smb.client.soTimeout", "35000");
		props.put("jcifs.smb.client.responseTimeout", "35000");

        logger.info("JCIFS Configuration - jcifs.netbios.cachePolicy = {}", jcifs.Config.getInt(props, "jcifs.netbios.cachePolicy"));
        logger.info("JCIFS Configuration - jcifs.smb.client.soTimeout = {}", jcifs.Config.getInt(props, "jcifs.smb.client.soTimeout"));
        logger.info("JCIFS Configuration - jcifs.smb.client.responseTimeout = {}", jcifs.Config.getInt(props, "jcifs.smb.client.responseTimeout"));
	}

//	static {
//		Properties props = new Properties();
//		props.put("jcifs.netbios.cachePolicy", "3600"); //  cache the network names for 1 hour (value in seconds, 0 is no caching, -1 is forever)
//		// JMW 1/3/2008
//		// Set the timeout values, these are supposed to be the default values but for some reason they were not set by default properly.
//		// We should do some experimenting with these values to be sure they are sufficient to access images across the WAN
//		props.put("jcifs.smb.client.soTimeout", "35000");
//		props.put("jcifs.smb.client.responseTimeout", "35000");
//		jcifs.Config.setProperties(props);
//	}
	
	/**
	 * Change the extension of a file
	 * @param filename The filename to change
	 * @param newExtension The new extension for the filename (do not include the '.')
	 * @return
	 */
	public String changeFileExtension(String filename, String newExtension) {
		String fname = filename;
		int loc = filename.lastIndexOf(".");
		if(loc >= 0) {
			fname = filename.substring(0, loc);
			fname += "." + newExtension;
		}
		return fname;
	}
	
	public String getFileExtension(String filename)
	{
		int loc = filename.lastIndexOf(".");
		if(loc >= 0) 
		{
			return filename.substring(loc + 1);
		}
		return filename;
	}

	
	private ByteBufferBackedImageStreamResponse openFileStream(SmbCredentials smbCredentials, NtlmPasswordAuthenticator ntPassAuth, StorageProximity imageProximity)
	throws ImageNotFoundException, ImageNearLineException, SmbException, IOException
	{
		SmbServerShare smbServerShare = smbCredentials.getSmbServerShare();
        logger.info("Opening image with URL '{}'.", smbServerShare.getSmbPath());
		ByteBufferBackedImageStreamResponse response = null;
		CIFSContext context = null;
		for(int nearlineRetry=0; nearlineRetry < getNearLineRetries(); ++nearlineRetry)
		{			
			if(context == null){
				//context = SingletonContext.getInstance();
				context = SingletonContext.getInstance().withCredentials(ntPassAuth);
			}
            logger.debug("Credentials stored in CIFS Context: {}", context.getCredentials().toString());
			SmbFile imageFile = new SmbFile(smbServerShare.getSmbPath(), context);
			// logger.info("Image opened");
			if( imageFile.canRead() ) 
			{
				int fileLength = (int)imageFile.length();
				if(fileLength > 0)
				{
                    logger.info("File '{}' has fileLength={}, reading image into buffer.", smbServerShare.getSmbPath(), fileLength);
					response = new ByteBufferBackedImageStreamResponse(
							new ByteBufferBackedImageInputStream(imageFile.getInputStream(), 
									(int)imageFile.length(), true));
                    logger.info("File '{}' read into buffer.", smbServerShare.getSmbPath());
					imageFile.close();
					return response;
				}
				else
				{
					imageFile.close();
					// was throwing FileNotFoundException (extends IOException) - changed to ImageNotFoundException and improved error message
					throw new ImageNotFoundException("File [" + smbServerShare.getSmbPath() + "] has length of [" + fileLength + "], not greated than 0 therefore no image data");
				}
			}
			// if we cannot read the file and the problem is not that the image is
			// probably near-line then bug out
			else if( imageProximity == null || imageProximity != StorageProximity.NEARLINE )
				imageFile.close();
				throw new ImageNotFoundException("Cannot read image file " + smbServerShare.getSmbPath() + ", indicates file does not exist on storage system.");
		}
		// if we get to here then the all nearline retries have been exhausted
		// throw a near-line exception
		throw new ImageNearLineException("Cannot read Near-Line image file '" + smbServerShare.getSmbPath() + "' yet, retry later.");						
	}
	
	private List<Integer> getSortedConnectionPorts(SmbServerShare smbServerShare)
	{
		List<Integer> connectionPorts = new ArrayList<Integer>();
		SmbConnectionInformationManager smbConnectionInformationManager = getSmbConnectionInformationManager();
		int firstTryPort = 
			smbConnectionInformationManager.getSuccessfulPort(smbServerShare.getServer(), 
					SmbServerShare.defaultServerSharePort);
		connectionPorts.add(firstTryPort);
		
		for(int port : SmbServerShare.possibleConnectionPorts)
		{
			// don't add the initial port again
			if(port != firstTryPort)
				connectionPorts.add(port);
		}		
		return connectionPorts;
	}
	
	private SmbConnectionInformationManager getSmbConnectionInformationManager()
	{
		return SmbConnectionInformationManager.getSmbConnectionInformationManager();
	}
	
	private void updateSuccessfulPort(SmbServerShare smbServerShare)
	{
		if(smbServerShare != null)
		{
			SmbConnectionInformationManager smbConnectionInformationManager = 
				getSmbConnectionInformationManager();
			smbConnectionInformationManager.updateSuccessfulPort(smbServerShare.getServer(), 
					smbServerShare.getPort());
		}
	}
	
	/**
	 * Open the input stream for the file and create a SizedInputStream that contains the filesize
	 * @param filename The filename to open (full UNC path)
	 * @param storageCredentials The network location that stores the file (with credentials set)
	 * @param imageProximity The current location of the image (magnetic, worm, offline)
	 * @return The SizedInputStream with the input stream open and set to the desired file and the number of bytes from the file set
	 * @throws ImageNearLineException Occurs if the image is on a jukebox and is not readable
	 * @throws ImageNotFoundException Occurs if the image does not exist (cannot be read and is on magnetic)
	 */
	private ByteBufferBackedImageStreamResponse openFileStream(
			String filename, 
			StorageCredentials storageCredentials, 
			StorageProximity imageProximity)
	throws ImageNearLineException, ImageNotFoundException, MethodException
	{
        logger.debug("StorageCredentials Username() : {}   System username: {}", storageCredentials.getUsername(), System.getProperty("user.name"));
		
		if (storageCredentials.getUsername().equalsIgnoreCase(System.getProperty("user.name")))
		{
			return openLocalFileStream(filename, storageCredentials, imageProximity);
		}
		
		String storageCredUsername = null;
		String[] storageCredUser = storageCredentials.getUsername().split("\\\\");
		if (storageCredUser.length > 3)
		{
			//Example: \\{domain}\{user}
			storageCredUsername = storageCredUser[3]; 
		}
		else if (storageCredUser.length > 1)
		{
			//Example: {domain}\{user}
			storageCredUsername = storageCredUser[1]; 
		}
		else
		{
			storageCredUsername = storageCredUser[0]; 
		}
		
		String systemUsername = null;
		String[] systemUser = System.getProperty("user.name").split("\\\\");
		if (systemUser.length > 1)
		{
			systemUsername = systemUser[1]; 
		}
		else
		{
			systemUsername = systemUser[0]; 
		}

        logger.debug("StorageCredUsername: {}   System username: {}", storageCredUsername, systemUsername);

		if (storageCredUsername.equalsIgnoreCase(systemUsername))
		{
			return openLocalFileStream(filename, storageCredentials, imageProximity);
		}
		else
		{
			return openUncFileStream(filename, storageCredentials, imageProximity);
		}
	}
	

	private ByteBufferBackedImageStreamResponse openLocalFileStream(
            String filename, StorageCredentials storageCredentials, StorageProximity imageProximity)
    throws ImageNearLineException, ImageNotFoundException, MethodException
    {
        logger.info("Opening local image with File path '{}'.", filename);
        ByteBufferBackedImageStreamResponse response = openLocalFileStream(filename, imageProximity);
        if (response == null)
        {
    		return openUncFileStream(filename, storageCredentials, imageProximity);
        }
        else
        {
        	return response;
        }
    }

	private ByteBufferBackedImageStreamResponse openLocalFileStream(
            String filename, StorageProximity imageProximity)
    {
        logger.info("Opening local image with File path '{}'.", filename);
        ByteBufferBackedImageStreamResponse response = null;
        for(int nearlineRetry=0; nearlineRetry < getNearLineRetries(); ++nearlineRetry)
        {           
            File imageFile = new File(filename);
            if(!imageFile.exists())
                //throw new ImageNotFoundException("Local file '" + filename + "' does not exist");
            	return null;
            
            // logger.info("Image opened");
            if( imageFile.canRead() ) 
            {
                int fileLength = (int)imageFile.length();
                if(fileLength > 0)
                {
                    logger.info("Local file '{}' has fileLength={}, reading image into buffer.", filename, fileLength);
                    try
                    {
                        response = new ByteBufferBackedImageStreamResponse(
                                new ByteBufferBackedImageInputStream(new FileInputStream(imageFile), 
                                        (int)fileLength, true));
                    }
                    catch(IOException ioX)
                    {
                    	return null;
                    }
                    logger.info("Local file '{}' read into buffer.", filename);
                    return response;
                }
                else
                {
                	return null;
                }
            }
            // if we cannot read the file and the problem is not that the image is
            // probably near-line then bug out
            else if( imageProximity == null || imageProximity != StorageProximity.NEARLINE )
            	return null;
        }
        
        // if we get to here then the all nearline retries have been exhausted
        return null;
    }
	
	private ByteBufferBackedImageStreamResponse openUncFileStream(
			String filename, 
			StorageCredentials storageCredentials, 
			StorageProximity imageProximity)
	throws ImageNearLineException, ImageNotFoundException, MethodException
	{
		SmbServerShare smbServerShare = null;
		try
		{
			smbServerShare = new SmbServerShare(filename);
		}
		catch(MalformedURLException murlX)
		{
			String msg = "MalformedURLException creating smb server share, " + murlX.getMessage();
			logger.error(msg, murlX);
			throw new MethodException(murlX);			
		}
		List<Integer> connectionPorts = getSortedConnectionPorts(smbServerShare);

		NtlmPasswordAuthenticator ntPassAuth = null;
		CIFSContext context = null;
		Iterator<Integer> portIterator = connectionPorts.iterator();
		while(portIterator.hasNext())
		{
			try
			{
				int connectionPort = portIterator.next();
				smbServerShare.setPort(connectionPort);
                logger.debug("Trying this possible ConnectionPort: {} smbServerShare: {}", connectionPort, smbServerShare.toString());
				if(context == null){
					context = SingletonContext.getInstance();
				}
				SmbCredentials smbCredentials = SmbCredentials.create(smbServerShare, 
						storageCredentials);
				// ntPassAuth doesn't change based on connection port, so only create it once
				if(ntPassAuth == null)
				{
                    logger.debug("SmbCredential Domain: {}   username: {}   password: <protected>", smbCredentials.getDomain(), smbCredentials.getUsername());
					/*ntPassAuth =
						new NtlmPasswordAuthentication(context, smbCredentials.getDomain(), smbCredentials.getUsername(), 
								smbCredentials.getPassword());*/
					ntPassAuth =
							new NtlmPasswordAuthenticator(smbCredentials.getDomain(), smbCredentials.getUsername(),
									smbCredentials.getPassword());
				}
				context.withCredentials(ntPassAuth);
				ByteBufferBackedImageStreamResponse response = 
					openFileStream(smbCredentials, ntPassAuth, imageProximity);
				updateSuccessfulPort(smbServerShare);
				return response;
			}
			catch(SmbException smbX)
			{
				// if the exception is a Connection Timeout, the root cause will be a TransportException
				logger.error(smbX);
				boolean includesRootCause = false;
				String msg = smbX.getMessage();
				if((msg == null) || (msg.length() <= 0))
				{
					if(smbX.getRootCause() != null)
					{
						msg = smbX.getRootCause().getMessage();
						includesRootCause = true;
					}
				}
				boolean throwException = true;
				if((smbX.getRootCause() != null) && (smbX.getRootCause() instanceof TransportException))
				{
                    logger.warn("SmbException rootCause is TransportException, will attempt to use next port to connect. Error='{}'.", smbX.getRootCause().getMessage());
					// if it is a transport exception then it could be a connection timeout exception which
					// indicates the VIX is not connecting on the right port, want to try the next available port
					if(portIterator.hasNext())
					{
						
						// if there is another port to try, don't throw the exception just yet
						throwException = false;
					}
					else
					{
						logger.warn("No more available ports to connect to share with, will throw exception");
					}
				}
				else if((!includesRootCause) && (smbX.getRootCause() != null) && (smbX.getRootCause() instanceof UnknownHostException))
				{
					// if JCIFS has an UnknownHostException, it is caught here
					// just want to make sure unknownhost gets into the exception message
					msg += ", " + smbX.getRootCause().toString();
				}						
				
				if(throwException)
				{
					throw new ImageNotFoundException("SMBException opening SMB file '" + filename + "', NT status [" + smbX.getNtStatus() + "], " + msg, smbX);					
				}
			}
			catch(UnknownHostException uhX)
			{
				// this doesn't ever seem to be triggered, caught as SmbException
				logger.error(uhX);
				//throw new ImageNotFoundException("UnknownHostException opening SMB file '" + filename + "', " + uhX.getMessage(), uhX);
				// if there is an UnknownHostException, throw this as a MethodException since the VIX cannot resolve the host name - this is a problem which should be corrected!
				throw new MethodException("UnknownHostException opening SMB file '" + filename + "', " + uhX.getMessage(), uhX);
			}
			catch(IOException ioX)
			{
				logger.error(ioX);
				throw new ImageNotFoundException("IOException opening SMB file '" + filename + "', " + ioX.getMessage(), ioX);
			}
		}
		// if we've gotten here then we've run out of possible ports to try to connect to image shares on
		
		
		return null;
	}	
	
	private ByteBufferBackedImageStreamResponse openDirectAccessFileStream(
            String filename, StorageProximity imageProximity)
    {
        logger.info("Opening direct access of image with File path '{}'.", StringUtil.cleanString(filename));
        ByteBufferBackedImageStreamResponse response = null;
        for(int nearlineRetry=0; nearlineRetry < getNearLineRetries(); ++nearlineRetry)
        {           
            File imageFile = new File(StringUtil.cleanString(filename));
            if(!imageFile.exists())
            {
                logger.debug("Local file '{}' does not exist", StringUtil.cleanString(filename));
            	return null;
            }
            
            // logger.info("Image opened");
            if( imageFile.canRead() ) 
            {
                int fileLength = (int)imageFile.length();
                if(fileLength > 0)
                {
                    logger.info("Local file '{}' has fileLength={}, reading image into buffer.", StringUtil.cleanString(filename), fileLength);
                    try
                    {
                        response = new ByteBufferBackedImageStreamResponse(
                                new ByteBufferBackedImageInputStream(new FileInputStream(imageFile), 
                                        (int)fileLength, true));
                    }
                    catch(IOException ioX)
                    {
                    	return null;
                    }
                    logger.info("direct access file '{}' read into buffer.", StringUtil.cleanString(filename));
                    return response;
                }
                else
                {
                	return null;
                }
            }
            // if we cannot read the file and the problem is not that the image is
            // probably near-line then bug out
            else if( imageProximity == null || imageProximity != StorageProximity.NEARLINE )
            	return null;
        }
        
        // if we get to here then the all nearline retries have been exhausted
        return null;
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
		ConnectionException, MethodException
	{
		ByteBufferBackedImageStreamResponse response = 
			openFileStream(imageIdentifier, imageCredentials, imageProximity);
		// set the data source response value, not needed in image conversion since set by http client
		// put in here so not changed by TXT file request
		if((response != null) && (response.getImageStream() != null))
		{					
			TransactionContext context = TransactionContextFactory.get();
			context.setDataSourceBytesReceived(new Long(response.getImageStream().getSize()));
		}
		return response;
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
		String txtFilename = changeFileExtension(imageIdentifier, "txt");
		ByteBufferBackedImageStreamResponse response = 
			openFileStream(txtFilename, imageCredentials, imageProximity);
		if(response != null)
			return response.getImageStream();
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.interfaces.ImageStorageFacade#openPhotoId(java.lang.String, gov.va.med.imaging.core.interfaces.StorageCredentials)
	 */
	@Override
	public ByteBufferBackedInputStream openPhotoId(String imageIdentifier,
			StorageCredentials imageCredentials) 
	throws ImageNotFoundException, ConnectionException, MethodException 
	{
		try
		{
			ByteBufferBackedImageStreamResponse response = openFileStream(imageIdentifier, 
					imageCredentials, StorageProximity.ONLINE);
			if(response != null)
			{				
				return response.getImageStream();
			}
			throw new ConnectionException("Image stream response is null");
		}
		catch(ImageNearLineException inlX)
		{
			logger.error("Nearline exception getting photo id", inlX);
			throw new ImageNotFoundException(inlX);
		}
	}
	
	public DataSourceImageInputStream openFileInputStream(String uncFilePath,
			StorageCredentials imageCredentials) 
	throws ImageNotFoundException, ConnectionException, MethodException 
	{
		try
		{
			ImageStreamResponse response;
			
			if (IsLocalFile(uncFilePath))
			{
				//Try direct access first
				response = openDirectAccessFileStream(uncFilePath, 
					StorageProximity.ONLINE);

				if(response != null)
				{				
					return response.getImageStream();
				}
				
				//Can't do direct access, use smb after replace hostname to localhost
				uncFilePath = useLocalhostName(uncFilePath);
			}
			
			//Use Smb
			response = openFileStream(uncFilePath, 
					imageCredentials, StorageProximity.ONLINE);
			if(response != null)
			{				
				return response.getImageStream();
			}
			throw new ConnectionException("Image stream response is null");
		}
		catch(ImageNearLineException inlX)
		{
			logger.error("Nearline exception getting Image", inlX);
			throw new ImageNotFoundException(inlX);
		}
	}
	
	private String useLocalhostName(String uncFilePath) 
	{
		String[] filepathParse = uncFilePath.split("\\\\");
		if (filepathParse.length > 2)
		{
			String ahostname = filepathParse[2];
			String localhostFilePath =  uncFilePath.replace(StringUtil.cleanString(ahostname), "localhost");
            logger.debug("uncFilePath: {} --> localhostFilePath: {}", uncFilePath, localhostFilePath);
			return localhostFilePath;
		}
		
		return uncFilePath;
	}

	private static boolean IsLocalFile(String filepath) 
	{
		String cacheFilename = filepath.replace("\\", "/");
		String[] cacheFilenameParse = cacheFilename.split("/");
		if (cacheFilenameParse.length > 2)
		{
			String cachehostname = cacheFilenameParse[2];
			return NetUtilities.getUnsafeLocalHostName().equals(cachehostname);
		}
		else
		{
			return false;
		}
	}

	private VistaStorageConfiguration getVistaStorageConfiguration()
	{
		return VistaStorageConfiguration.getVistaStorageConfiguration();
	}
	
	public OutputStream openOutputStream(String filename, StorageCredentials storageCredentials) 
	throws  IOException
	{
        logger.info("Opening output stream to file [{}]", filename);
		SmbFile file = getSmbFile(filename, storageCredentials);
		file.createNewFile();
		return file.getOutputStream();	
		
	}

	public void deleteFile(String filename, StorageCredentials storageCredentials) 
	throws  IOException
	{
        logger.info("Deleting file [{}]", filename);
		SmbFile file = getSmbFile(filename, storageCredentials);
		file.delete();
	}

	public void copyFile(String sourcePath, String destinationPath, StorageCredentials storageCredentials) 
	throws IOException
	{
        logger.info("Copying file [{}] to file [{}]", sourcePath, destinationPath);
		SmbFile sourceFile = getSmbFile(sourcePath, storageCredentials);
		SmbFile destinationFile = getSmbFile(destinationPath, storageCredentials);
		sourceFile.copyTo(destinationFile);
	}

	public void copyRemoteFileToLocalFile(String remotePath, String localPath, StorageCredentials storageCredentials) 
	throws  IOException
	{
		// Fortify change: normalized 'remotePath' and made sure the file separator is OK
		String source = StringUtil.toSystemFileSeparator(FilenameUtils.normalize(remotePath));
		String destination = StringUtil.toSystemFileSeparator(FilenameUtils.normalize(localPath));

        logger.info("Copying file [{}] to file [{}]", source, destination);
		
		File destinationFile = new File(destination); // FIX HERE
		
		if(!destinationFile.exists()) {
			destinationFile.getParentFile().mkdirs();
			destinationFile.createNewFile();
		} 

		byte[] buffer = new byte[16904]; 
		int read = 0;
		
		// Fortify change: added try-with-resources
		try( SmbFileInputStream in = new SmbFileInputStream(getSmbFile(source, storageCredentials));
			 FileOutputStream out = new FileOutputStream(destinationFile, false)	) {
		while ((read = in.read(buffer)) > 0) 
		    out.write(buffer, 0, read); 
		}
	}

	public void renameFile(String filename, String newFilename, StorageCredentials storageCredentials) 
	throws  IOException
	{
        logger.info("renaming file [{}]", filename);
		SmbFile oldFile = getSmbFile(filename, storageCredentials);
		SmbFile newFile = getSmbFile(newFilename, storageCredentials);
		oldFile.renameTo(newFile);
	}

	public boolean fileExists(String filename, StorageCredentials storageCredentials) 
	throws  IOException
	{
        logger.info("Checking to see if file exists [{}]", filename);
		SmbFile file = getSmbFile(filename, storageCredentials);
		return file.exists();
	}
	
	public String readFileAsString (String filename, StorageCredentials storageCredentials) 
	throws  IOException
	{
        logger.info("Reading file [{}] as string", filename);
		SmbFile file = getSmbFile(filename, storageCredentials);
		
	    StringBuilder text = new StringBuilder();
	    String NL = System.getProperty("line.separator");
	    Scanner scanner = new Scanner(new SmbFileInputStream(file));
	    try {
	      while (scanner.hasNextLine()){
	        text.append(scanner.nextLine() + NL);
	      }
	    }
	    finally{
	      scanner.close();
	    }
	    
		return text.toString();
	}
	
	public void writeStringToFile(String fileContents, String filename, StorageCredentials storageCredentials) 
	throws  IOException
	{
        logger.info("Writing to file [{}]", filename);
		
	    Writer out = new OutputStreamWriter(openOutputStream(filename, storageCredentials));
	    try {
	      out.write(fileContents);
	    }
	    finally {
	      out.close();
	    }	    
	}

	public List<String> getDicomFilenames (String dcmPath, StorageCredentials storageCredentials) 
	throws  IOException
	{
		logger.info("list path [" + dcmPath + "]");
		List<String> lst = new ArrayList<String>();
		SmbFile smb = getSmbFile(dcmPath, storageCredentials);
		SmbFile[] dcmFiles = smb.listFiles("*.dcm");
		for (int i=0; i<dcmFiles.length; i++)
		{
			lst.add(dcmFiles[i].getPath() + "^" + dcmFiles[i].getName());
		}
		return lst;
	}
	
	private SmbFile getSmbFile(String filename, StorageCredentials storageCredentials)
	throws MalformedURLException, SmbException 
	{
		SmbCredentials fileCredentials = SmbCredentials.create(new SmbServerShare(filename), 
				storageCredentials);
		
		SmbCredentials directoryCredentials = SmbCredentials.create(new SmbServerShare(this.getDirectory(filename)),
				storageCredentials);

		SmbFile file = null;
		SmbFile directory = null;
		
		try {
			BaseContext bc = new BaseContext(new PropertyConfiguration(System.getProperties()));
			NtlmPasswordAuthentication ntPassAuth = 
					new NtlmPasswordAuthentication(bc, 
							fileCredentials.getDomain(),
							fileCredentials.getUsername(),
							fileCredentials.getPassword());

			CIFSContext context = bc.withCredentials(ntPassAuth);
			
			directory = new SmbFile(directoryCredentials.getSmbServerShare().getSmbPath(), context);
		
			if (!directory.exists()){
				directory.mkdirs();
			}
			
			file = new SmbFile(fileCredentials.getSmbServerShare().getSmbPath(), context);
			
		} catch (CIFSException e) {
			throw new SmbException(e.getMessage());
		}
		
		directory.close();
		return file;
	}

	protected String getDirectory(String fullFileSpec){
		int endIndex = fullFileSpec.lastIndexOf("\\");
		return fullFileSpec.substring(0, endIndex);
	}
	
	//==================================== TEST SMB =====================================
	// %catalina_home%/lib >
	// java.exe -cp ./*;VistaStorage-0.1.jar gov.va.med.imaging.vista.storage.SmbStorageUtility %DOMAIN% %USERNAME% "PASSWORD% %SMBPATH%
	// java.exe -cp ./*;VistaStorage-0.1.jar gov.va.med.imaging.vista.storage.SmbStorageUtility null administrator Vista2014 SMB://54.235.85.212:445/d$/vixcache/va-image-region/500/icn(10121V598061)/5162/5163-DIAGNOSTICUNCOMPRESSED-video%2fx-msvideo
	// java.exe -cp ./*;VistaStorage-0.1.jar gov.va.med.imaging.vista.storage.SmbStorageUtility I873VSTWIN-T1 vtnIU Access1. SMB://I873VSTWIN-T1/image1$/PAN0/00/00/01/24/PAN00000012424.jpg 
	//=====================================================================================
	@SuppressWarnings("unused")
	public static void main(String[] args)
	{
	    String domain = "WORKGROUP";
	    String username = "administrator"; //"vaaaccvxcluster";
	    String a_key = "Vista2014"; //"Password1";
	    String smbPath = "SMB://54.235.85.212:445/d$/vixcache/va-image-region/500/icn(10121V598061)/5162/5163-DIAGNOSTICUNCOMPRESSED-video%2fx-msvideo"; //"SMB://vaausappcvx403c:445/E$/VixCache/dod-image-region/2.16.840.1.113883.3.42.10012.100001.207/200/1012740020V38703/200-1.2.124.113532.34.6413.11009.20140109.162021.237611678-1.3.51.5146.11973.20090401.1160914-1-REFERENCE-application%2fdicom%2fimage%2fj2k";
	    if (args.length > 2)
	    {
	      domain = args[0];
	      username = args[1];
	      a_key = args[2];
	      smbPath = args[3];
	    }
	    System.out.println("Domain: " + domain);
	    System.out.println("username: " + username);
	    System.out.println("pwd: " + a_key);
	    System.out.println("smbPath/filename: " + smbPath);
	    
	    if (domain.equals("localhost"))
	    {
	    	try
	    	{
	    		File imageFile = FileUtilities.getFile(smbPath);
	    		if(!imageFile.exists())
	    		{
                    System.out.println("Local file '" + smbPath + "' doesn't exist!");
                    return;
	    		}
	    		
	    		if( imageFile.canRead() ) 
	    		{
	    			int fileLength = (int)imageFile.length();
	    		    System.out.println("READ!! Content Length: " + fileLength);
	    		    
	    		    
	    		    try
                    {
	    		    	ByteBufferBackedImageStreamResponse response = new ByteBufferBackedImageStreamResponse(
                                new ByteBufferBackedImageInputStream(new FileInputStream(imageFile), 
                                        (int)fileLength, true));
	    		    	if (response == null)
	    		    	{
	    		    		System.out.println("NULL response");
	    		    	}
	    		    	else
	    		    	{
	    		    		System.out.println("response: " + response.getImageSize());
	    		    	}
                    }
                    catch(IOException ioX)
                    {
            	        System.out.println("UNABLE TO READ!! " + ioX.getMessage());
                    }
	    		    
                }
                else
                {
        	        System.out.println("UNABLE TO READ!!");
                }
            }
		    catch (Exception e)
		    {
		      System.out.println(e.getMessage());
		      System.out.println(e.getStackTrace());
		    }
	    }
	    else
	    {
		    try
		    {
			  BaseContext bc = new BaseContext(new PropertyConfiguration(System.getProperties()));

		       NtlmPasswordAuthentication ntPassAuth = new NtlmPasswordAuthentication(
		    		  bc, domain, username, a_key);

			  CIFSContext context = bc.withCredentials(ntPassAuth);
			  String smbDirPath = "SMB://I873VSTWIN-T1/image1$/PAN0/00/00/01/24";
					  
			  SmbFile directory = new SmbFile(smbDirPath, context);

			  if (!directory.exists())
			  {
					directory.mkdirs();
			  }
			  		  
		      SmbFile imageFile = new SmbFile(smbPath, context);
		      if (imageFile.canRead())
		      {
		        int fileLength = (int)imageFile.length();
		        System.out.println("READ!! Content Length: " + fileLength);
		      }
		      else
		      {
		        System.out.println("UNABLE TO READ!!");
		      }
		    }
		    catch (Exception e)
		    {
		      System.out.println(e.getMessage());
		      System.out.println(e.getStackTrace());
		    }
	    }
	}


}
