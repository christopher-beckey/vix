/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 23, 2009
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
package gov.va.med.imaging.federation.web;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.WellKnownOID;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageConversionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.ImagingFederationContext;
import gov.va.med.imaging.federation.web.FederationChecksumNotification.ChecksumNotificationImageType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.AbstractBaseFacadeImageServlet;
import gov.va.med.imaging.wado.query.WadoQuery;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractFederationServlet 
extends AbstractBaseFacadeImageServlet
{
	private static final long serialVersionUID = 3384484685833290124L;
	
	private final static String zipImageEntryKey = "image";
	private final static String zipTxtFileEntryKey = "txt";
	
	private final String zipApplicationMimeType = "application/zip";

	public abstract Long getImage(ImageURN imageUrn, 
			ImageFormatQualityList requestedFormatQuality, 
			OutputStream outStream,
			ImageMetadataNotification metadataCallback)
	throws MethodException, ConnectionException;
	
	public abstract Long getDocument(GlobalArtifactIdentifier gai,			
			OutputStream outStream, ImageMetadataNotification imageMetadataNotification)
	throws MethodException, ConnectionException;
	
	public abstract int getImageTxtFile(
			ImageURN imageUrn, 
			OutputStream outStream, 
			ImageMetadataNotification metadataNotification)
	throws MethodException, ConnectionException;	
	
	public abstract int getImageTxtFileAsChild(
			ImageURN imageUrn, 
			OutputStream outStream, 
			ImageMetadataNotification metadataNotification)
	throws MethodException, ConnectionException;	
	
	/**
	 * Determines if the text file should be included in the result (when appropriate)
	 * 
	 * @param gai GlobalArtifactIdentifier to possibly help determine if the text file should be included
	 * @return
	 */
	public abstract boolean includeTextFile(GlobalArtifactIdentifier gai);
	
	protected void streamImageIntoZipStream(
			GlobalArtifactIdentifier gai, 
			ImageQuality requestedImageQuality,
			List<ImageFormat> acceptableResponseContent, 
			HttpServletResponse response)
	throws IOException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("AbstractFederationServlet.streamImageIntoZipStream() --> App version [" + getWebAppVersion() + "], request type [" + transactionContext.getRequestType() + "]");
		response.setContentType(zipApplicationMimeType);
		ZipOutputStream zipOut = new ZipOutputStream(response.getOutputStream());		
		ImageFormatQualityList qualityList = new ImageFormatQualityList();
		qualityList.addAll(acceptableResponseContent, requestedImageQuality);
		try
		{
            getLogger().info("AbstractFederationServlet.streamImageIntoZipStream() --> Getting image Id [{}], file type [{}] and responding with Zip file output", gai.toString(), qualityList.getAcceptString(true));
			
			if(!validateRouterAvailable())
			{
				sendPanicResponse(response, "Unable to obtain reference to Federation Router implementation.");
				return;
			}
			
			long bytesTransferred = 0;
			ZipEntry entry = new ZipEntry(zipImageEntryKey);
			zipOut.putNextEntry(entry);			
			
			ImageURN imageUrn = null;
			if(gai instanceof ImageURN)
			{			
				imageUrn = (ImageURN)gai;
				bytesTransferred = getImage(imageUrn, qualityList, zipOut,
					new FederationChecksumNotification(response, ChecksumNotificationImageType.IMAGE));
			}
			else
			{
				bytesTransferred = getDocument(gai, zipOut, new FederationChecksumNotification(response, ChecksumNotificationImageType.IMAGE));
			}
            getLogger().info("AbstractFederationServlet.streamImageIntoZipStream() --> Wrote [{}] bytes for image file into zip stream", bytesTransferred);
			entry.setSize(bytesTransferred);
			zipOut.closeEntry();
			
			// Get the format of the response from the content type (which was set from the notification event
			ImageFormat responseFormat = ImageFormat.valueOfMimeType(response.getContentType());
			
			// only put the TXT file into the ZIP response if the request is not for a thumbnail quality image AND
			// if the image is NOT in a DICOM format (which already contains the contents in the header)
			if((!ImageFormat.isDICOMFormat(responseFormat)) && 
				(requestedImageQuality != ImageQuality.THUMBNAIL) && 
				(imageUrn != null) &&
				(includeTextFile(imageUrn)))
			{
				entry = new ZipEntry(zipTxtFileEntryKey);
				zipOut.putNextEntry(entry);	
				try 
				{
					// JMW 12/15/2010 call child command to get text file so it doesn't overwrite the previous
					// command to get the image
					int bytesRead = getImageTxtFileAsChild(imageUrn, zipOut, 
							new FederationChecksumNotification(response, ChecksumNotificationImageType.TXTFILE));
					bytesTransferred += bytesRead;
					entry.setSize(bytesRead);
                    getLogger().info("Wrote [{}] bytes for TXT file into zip stream", bytesRead);
				}
				catch(ImageNotFoundException infX)
				{					
					// Image not found thrown when trying to get TXT file
                    getLogger().warn("AbstractFederationServlet.streamImageIntoZipStream() --> Continue though image Id [{}] was not found:{}", imageUrn.toString(), infX.getMessage());
				}
				zipOut.closeEntry();
			}
			
			zipOut.flush();
			zipOut.close();
			
			getLogger().info("AbstractFederationServlet.streamImageIntoZipStream() --> Done writing zip file to output stream");
			transactionContext.setEntriesReturned( bytesTransferred==0 ? 0 : 1 );
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
		}
		catch(ImageNearLineException inlX)
		{
			String msg = "AbstractFederationServlet.streamImageIntoZipStream() --> Near-Line media access timeout when accessing image Id [" + gai.toString() + "]. Please try it again later!";			 
			TransactionContextFactory.get().setErrorMessage(msg + "\n" + inlX.getMessage());
			getLogger().error(msg);
			transactionContext.setExceptionClassName(inlX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_CONFLICT + "");
			response.sendError(HttpServletResponse.SC_CONFLICT, msg);
		}
		catch(ImageConversionException icX)
		{
			String msg = "AbstractFederationServlet.streamImageIntoZipStream() --> Could NOT convert image Id [" + gai.toString() + "] to response output stream: " + icX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(icX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE + "");
			response.sendError(HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE, msg);
		} 
		catch(ImageNotFoundException infX)
		{
			String msg = "AbstractFederationServlet.streamImageIntoZipStream() --> Image Id [" + gai.toString() + "] was NOT found: " + infX.getMessage();
			getLogger().error(msg);				
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(infX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_FOUND + "");
			response.sendError(HttpServletResponse.SC_NOT_FOUND, msg);
		}
		catch(MethodException mX)
		{
			String msg = "AbstractFederationServlet.streamImageIntoZipStream() --> Encountered MethodException while getting image Id [" + gai.toString() + "] to response output stream: " + mX.getMessage();
			getLogger().debug(msg);
			transactionContext.setErrorMessage(msg);
			SecurityCredentialsExpiredException sceX = findSecurityCredentialsException(mX);
			if(sceX != null)
			{
				msg = "AbstractFederationServlet.streamImageIntoZipStream() --> Encountered SecurityCredentialsExpiredException getting image Id [" + gai.toString() + "]: " + sceX.getMessage();
				transactionContext.setExceptionClassName(sceX.getClass().getSimpleName());
				transactionContext.setResponseCode(HttpServletResponse.SC_PRECONDITION_FAILED + "");
				response.sendError(HttpServletResponse.SC_PRECONDITION_FAILED, msg);	
			}
			else
			{
				transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
				transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg);	
			}			
		}
		catch(ConnectionException cX)
		{
			String msg = "AbstractFederationServlet.streamImageIntoZipStream() --> Encountered ConnectionException while getting image Id [" + gai.toString() + "] Please try it again later!";
			getLogger().debug(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_BAD_GATEWAY + "");
			response.sendError(HttpServletResponse.SC_BAD_GATEWAY, msg);
		}
	}
	
	protected void doGetTxtFile(ImageURN imageUrn, HttpServletResponse response)
	throws IOException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("Federation WebApp " + getWebAppVersion() + " TXT file transfer");		
		response.setContentType("text/plain");
        getLogger().info("AbstractFederationServlet.doGetTxtFile() --> Getting TXT file for image URN [{}]", imageUrn.toString());
		try
		{
			long bytesTransferred = getImageTxtFile(imageUrn, response.getOutputStream(), 
					new FederationChecksumNotification(response, ChecksumNotificationImageType.TXTFILE));
            getLogger().info("AbstractFederationServlet.doGetTxtFile() --> Wrote [{}] bytes for TXT file stream", bytesTransferred);
			transactionContext.setEntriesReturned(bytesTransferred==0 ? 0: 1);
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
		}
		catch(ImageNearLineException inlX)
		{
			String msg = "AbstractFederationServlet.doGetTxtFile() --> Near-Line media access timeout when accessing TXT file for image URN [" + imageUrn.toString() + "]. Please try it again later!";			 
			TransactionContextFactory.get().setErrorMessage(msg + "\n" + inlX.getMessage());
			getLogger().error(msg, inlX);
			transactionContext.setExceptionClassName(inlX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_CONFLICT + "");
			response.sendError(HttpServletResponse.SC_CONFLICT, msg);			
		}
		catch(ImageNotFoundException infX)
		{
			String msg = "AbstractFederationServlet.doGetTxtFile() --> Image wan NOT found while getting TXT file for image URN [" + imageUrn.toString() + "] to response output stream: " + infX.getMessage();
			getLogger().error(msg);				
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(infX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_FOUND + "");
			response.sendError(HttpServletResponse.SC_NOT_FOUND, msg);						
		}
		catch(MethodException mX)
		{
			String msg = "AbstractFederationServlet.doGetTxtFile() --> Encountered MethodException while getting image Id [" + imageUrn.toString() + "] to response output stream: " + mX.getMessage();
			getLogger().debug(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg);			
		}
		catch(ConnectionException cX)
		{
			String msg = "AbstractFederationServlet.streamImageIntoZipStream() --> Encountered ConnectionException while getting image Id [" + imageUrn.toString() + "] Please try it again later!";			 
			TransactionContextFactory.get().setErrorMessage(msg + "\n" + cX.getMessage());
			getLogger().error(msg, cX);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_BAD_GATEWAY + "");
			response.sendError(HttpServletResponse.SC_BAD_GATEWAY, msg);			
		}
	}
	
	/**
	 * @param string
	 */
	private void sendPanicResponse(HttpServletResponse response, String msg)
	{
		try
		{
            getLogger().error("AbstractFederationServlet --> Sending panic response: {}", msg);
			response.sendError(HttpServletResponse.SC_CONFLICT, msg);
		} 
		catch (IOException x)
		{
            getLogger().error("AbstractFederationServlet.sendPanicResponse() --> Unable to send error response [{}]", msg);
		}			
	}
	
	protected ImageQuality getImageQuality(WadoQuery wadoQuery)
	{		
		return ImageQuality.getImageQuality(wadoQuery.getImageQualityValue());
	}	
	
	protected FederationRouter getFederationRouter()
	{
		return ImagingFederationContext.getFederationRouter();
	}	
	
	private boolean validateRouterAvailable() 
	{
		FederationRouter router = getFederationRouter();
		if(router == null)
		{
			return false;
		}
		return true;
	}
	
	protected void setVistaRadImagingContext()
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setImagingSecurityContextType(ImagingSecurityContextType.MAGJ_VISTARAD.toString());
	}
	
	/**
	 * Base32 decode specified image URN
	 * @param requestedImageUrn
	 * @return
	 * @throws URNFormatException
	 */	
	protected ImageURN base32DecodeImageUrn(ImageURN requestedImageUrn)
	throws URNFormatException
	{
		// base 32 decode the URN
		ImageURN imageUrn = URNFactory.create(requestedImageUrn.toString(), SERIALIZATION_FORMAT.PATCH83_VFTP, ImageURN.class);
        getLogger().info("AbstractFederationServlet.base32DecodeImageUrn() --> Image URN base-32 decoded [{}]", imageUrn.toString());
		return imageUrn;
	}
	
	/**
	 * Return the version of the interface
	 * @return
	 */
	protected abstract String getWebAppVersion();
	
	/**
	 * Determines if the GlobalArtifactIdentifier is a VA image 
	 * 
	 * @param gai
	 * @return
	 */
	protected boolean isGaiVA(GlobalArtifactIdentifier gai)
	{
		if((WellKnownOID.VA_RADIOLOGY_IMAGE.isApplicable(gai.getHomeCommunityId())) ||
				(WellKnownOID.VA_DOCUMENT.isApplicable(gai.getHomeCommunityId())))
		{
			return true;
		}
		return false;
	}
}
