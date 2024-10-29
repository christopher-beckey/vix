/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 5, 2010
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
package gov.va.med.imaging.vistarad.web;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.business.ImageMetadata;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.http.AcceptElement;
import gov.va.med.imaging.http.AcceptElementList;
import gov.va.med.imaging.http.exceptions.HttpHeaderParseException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;
import gov.va.med.imaging.vistarad.configuration.VistaRadWebAppConfiguration;
import gov.va.med.imaging.wado.AbstractBaseImageServlet;
import gov.va.med.imaging.wado.query.WadoQuery;
import gov.va.med.imaging.wado.query.WadoRequest;
import gov.va.med.imaging.wado.query.exceptions.WadoQueryComplianceException;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractVistaRadExamImageAccessServlet
extends AbstractBaseImageServlet
{
	private static final long serialVersionUID = 1L;
	
	public static final List<ImageFormat> acceptableReferenceResponseTypes;
	public static final List<ImageFormat> acceptableDiagnosticResponseTypes;
	
	static
	{
		acceptableReferenceResponseTypes = new ArrayList<ImageFormat>();
		acceptableReferenceResponseTypes.addAll(
				VistaRadWebAppConfiguration.getVistaRadConfiguration().getImageAccessReferenceQualityImageFormats());
		
		acceptableDiagnosticResponseTypes = new ArrayList<ImageFormat>();
		acceptableDiagnosticResponseTypes.addAll(
				VistaRadWebAppConfiguration.getVistaRadConfiguration().getImageAccessDiagnosticQualityImageFormats());		
	}	
	
	/**
	 * Stream the exam image instance from the source
	 * 
	 * @param imageUrn
	 * @param requestedImageQuality
	 * @param acceptableResponseContent
	 * @param outStream
	 * @param checksumNotification
	 * @return
	 * @throws IOException
	 * @throws SecurityCredentialsExpiredException
	 * @throws ImageServletException
	 */
	protected abstract long streamExamImageInstance(
		ImageURN imageUrn, 
		ImageQuality requestedImageQuality,
		List<ImageFormat> acceptableResponseContent, 
		OutputStream outStream,
		ImageMetadataNotification checksumNotification,
		boolean allowedFromCache)
	throws IOException, SecurityCredentialsExpiredException, ImageServletException;

	/**
	 * 
	 * @param imageUrn
	 * @param requestedImageQuality
	 * @param acceptableResponseContent
	 * @param allowedFromCache
	 * @return
	 * @throws IOException
	 * @throws SecurityCredentialsExpiredException
	 * @throws ImageServletException
	 */
	protected abstract ImageMetadata getImageMetadata(
		ImageURN imageUrn,
		ImageQuality requestedImageQuality,
		List<ImageFormat> acceptableResponseContent,
		boolean allowedFromCache)
	throws IOException, SecurityCredentialsExpiredException, ImageServletException;

	/**
	 * Method to get extra details to append to the end of the operation type transaction context field
	 * @return
	 */
	protected abstract String getExtraOperationTypeDescription();
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#getUserSiteNumber()
	 */
	@Override
	public String getUserSiteNumber() 
	{
		TransactionContext context = TransactionContextFactory.get();
		return context.getLoggerSiteNumber();
	}
	
	/**
	 * chooseXchangeContentType does HTTP request contentType check for non-WADO (XCHANGE) 
	 * compliant image requests. Returns accepted/selected contentType.
	 * For THUMBNAILs, only "image/jpeg" is accepted. For REFERENCE and DIAGNOSTIC quality images,
	 * "application/dicom" (default), and if alternate logic applies "image/jp2" and "image/jpeg"
	 * are accepted, if one or more are present the first is set.
	 * 
	 * @param acceptElementList list of requested contentType entries (AcceptElementList type)
	 * @return ImageContentType accepted/selected contentType
	 * @throws WadoQueryComplianceException
	 */
	private List<ImageFormat> validateContentType(
		ImageQuality imageQuality, 
		AcceptElementList acceptElementList)
	throws WadoQueryComplianceException
	{
		
		if(imageQuality == ImageQuality.THUMBNAIL)
			throw new WadoQueryComplianceException("Interface does not support thumbnail requests");
		else if(imageQuality == ImageQuality.REFERENCE)
			return validateContentType(acceptElementList, acceptableReferenceResponseTypes);
		else if(imageQuality == ImageQuality.DIAGNOSTIC)
			return validateContentType(acceptElementList, acceptableDiagnosticResponseTypes);
		else if(imageQuality == ImageQuality.DIAGNOSTICUNCOMPRESSED)
			return validateContentType(acceptElementList, acceptableDiagnosticResponseTypes);

		throw new 
		WadoQueryComplianceException("Unknown image quality value for "
			+ (imageQuality == null ? "null" : "" + imageQuality.name()) +			// 16Sep2008 CTB name() changed from toString()
			" image: '" + acceptElementList.toString() + "'" );
	}
	
	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	@Override
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException 
	{
		WadoRequest wadoRequest = null;
		long bytesTransferred = 0;
		TransactionContext transactionContext = TransactionContextFactory.get();

        getLogger().info("Beginning GET handler: servlet path=[{}],  path info=[{}]\nquery string: [{}]", req.getServletPath(), req.getPathInfo(), req.getQueryString());
		
		wadoRequest = parseAndValidateRequest(req, resp);
		if(wadoRequest != null)		// parseAndValidateRequest will send the response itself if there was an error
									// we just need to check that the wadoRequest was built
		{
			try
			{
				bytesTransferred = doExchangeCompliantGet(wadoRequest, resp);
				transactionContext.setEntriesReturned( bytesTransferred==0 ? 0 : 1 );
				transactionContext.setFacadeBytesSent(bytesTransferred);
				transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
			}
			catch (WadoQueryComplianceException e) 
			{
				// this should not occur because the parseAndValidateRequest method should have caught errors
				throw new ServletException(e);
			}
			catch (IOException ioX) 
			{
				String msg = "I/O error when sending image content: " + ioX.getMessage();
				getLogger().error(msg);
				transactionContext.setErrorMessage(msg);
				transactionContext.setExceptionClassName(ioX.getClass().getSimpleName());
				transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
				resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
			} 
			catch (ImageServletException isX)
	        {
				String msg = "Image servlet exception: " + isX.getMessage();
				getLogger().error(msg);
				transactionContext.setErrorMessage(msg);
				// don't set the transactionContext.setExceptionClassName() property here
				// it gets set in the AbstractBaseImageServlet because that is where the real
				// exception is caught
				//transactionContext.setExceptionClassName(isX.getClass().getName());
				transactionContext.setResponseCode(isX.getResponseCode() + "");
				resp.sendError(isX.getResponseCode(), msg );
	        }
			catch(SecurityCredentialsExpiredException sceX)
			{
				String msg = "SecurityCredentials expired: " + sceX.getMessage();
				// logging of error already done
				// just need to set appropriate error code
				transactionContext.setResponseCode(HttpServletResponse.SC_PRECONDITION_FAILED + "");
				transactionContext.setErrorMessage(msg);
				resp.sendError(HttpServletResponse.SC_PRECONDITION_FAILED, msg);
			} 
		}

        getLogger().info("GET handler returned {} bytes for query string: [{}] ", bytesTransferred, req.getQueryString());
	}
	
	/**
	 * Parse the HTTP request and return a WadoRequest
	 * If the parsing fails return a null after writing to the response
	 * 
	 * @param req
	 * @param resp
	 * @return
	 * @throws IOException 
	 */
	private WadoRequest parseAndValidateRequest(HttpServletRequest req, HttpServletResponse resp) 
	throws IOException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		WadoRequest wadoRequest = null;
		try
		{
			wadoRequest = WadoRequest.createParsedVRTPCompliantWadoRequest(req);
			initTransactionContext(wadoRequest);
			transactionContext.setRequestType("VistaRad WebApp " + transactionContext.getRequestType() + getExtraOperationTypeDescription());
			transactionContext.setImagingSecurityContextType(ImagingSecurityContextType.MAGJ_VISTARAD.toString());
            getLogger().debug("VRad w/extensions compliance requested, Request is [{}]", wadoRequest.toString());
			
			// this just validates that we can get to stuff
			WadoQuery wadoQuery = wadoRequest.getWadoQuery();
			ImageQuality imageQuality = ImageQuality.getImageQuality( wadoRequest.getWadoQuery().getImageQualityValue() );
			AcceptElementList contentTypeList = wadoQuery.getContentTypeList();
			validateContentType(imageQuality, contentTypeList);
		}
		catch( WadoQueryComplianceException wadoX )
		{
			String msg = "Request is not a valid Exchange (WAI) protocol request: " + wadoX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(wadoX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			resp.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg );		
			wadoRequest = null;
		}
		catch( HttpHeaderParseException httpParseX )
		{
			String msg = "Error parsing HTTP header information: " + httpParseX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(httpParseX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
			wadoRequest = null;
		}
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "Unexpected exception building routing token: " + rtfX.getMessage();
			// logging of error already done
			// just need to set appropriate error code
			transactionContext.setResponseCode(HttpServletResponse.SC_PRECONDITION_FAILED + "");
			transactionContext.setErrorMessage(msg);
			resp.sendError(HttpServletResponse.SC_PRECONDITION_FAILED, msg);
			wadoRequest = null;
		}
		
		return wadoRequest;
	}
	
	/**
	 * 
	 * @param wadoRequest
	 * @param resp
	 * @return
	 * @throws WadoQueryComplianceException
	 * @throws IOException
	 * @throws ImageServletException
	 * @throws SecurityCredentialsExpiredException
	 */
	protected long doExchangeCompliantGet(WadoRequest wadoRequest, HttpServletResponse resp) 
	throws WadoQueryComplianceException, IOException, ImageServletException, SecurityCredentialsExpiredException
	{
        getLogger().debug("Doing Exchange compliant GET:  {}", wadoRequest.toString());
		WadoQuery wadoQuery = wadoRequest.getWadoQuery();
		
		ImageURN imageUrn = wadoQuery.getInstanceUrn();
		ImageQuality imageQuality = ImageQuality.getImageQuality( wadoRequest.getWadoQuery().getImageQualityValue() );
		AcceptElementList contentTypeList = wadoQuery.getContentTypeList();
		List<ImageFormat> acceptableResponseContent = validateContentType(imageQuality, contentTypeList);
		
		// Do sanity check for non-Wado requests
        getLogger().debug("   GET params:  imageUrn=[{}]  ImageQuality=[{}]", imageUrn == null ? "NULL" : "" + imageUrn, imageQuality.name());
				
		// if the object (instance) GUID is supplied then just stream the instance
		// back, ignoring any other parameters
		
		MetadataNotification  metadataNotification = new MetadataNotification(resp, true);
		return streamExamImageInstance(
			imageUrn, imageQuality, acceptableResponseContent, 
			resp.getOutputStream(), metadataNotification, wadoQuery.isAllowedFromCache()
		);
	}
		
	/**
	 * from http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html
	 * 
	 * The HEAD method is identical to GET except that the server MUST NOT return a message-body in the response. 
	 * The metainformation contained in the HTTP headers in response to a HEAD request SHOULD be identical to the information sent 
	 * in response to a GET request. This method can be used for obtaining metainformation about the entity implied by the request 
	 * without transferring the entity-body itself. This method is often used for testing hypertext links for validity, accessibility, 
	 * and recent modification.
	 * 
	 * The response to a HEAD request MAY be cacheable in the sense that the information contained in the response MAY be used to update 
	 * a previously cached entity from that resource. If the new field values indicate that the cached entity differs from the current 
	 * entity (as would be indicated by a change in Content-Length, Content-MD5, ETag or Last-Modified), then the cache MUST treat the 
	 * cache entry as stale.
	 */
	@Override
	protected void doHead(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException 
	{
		WadoRequest wadoRequest = null;
		TransactionContext transactionContext = TransactionContextFactory.get();

        getLogger().info("Beginning GET handler: servlet path=[{}],  path info=[{}]\nquery string: [{}]", req.getServletPath(), req.getPathInfo(), req.getQueryString());
		
		wadoRequest = parseAndValidateRequest(req, resp);
		
		WadoQuery wadoQuery = wadoRequest.getWadoQuery();
		
		ImageURN imageUrn = wadoQuery.getInstanceUrn();
		ImageQuality imageQuality = ImageQuality.getImageQuality( wadoQuery.getImageQualityValue() );
		AcceptElementList contentTypeList = wadoQuery.getContentTypeList();
		List<ImageFormat> acceptableResponseContent = null;
		try 
		{
			acceptableResponseContent = validateContentType(imageQuality, contentTypeList);
			// Do sanity check for non-Wado requests
            getLogger().debug("   HEAD params:  imageUrn=[{}]  ImageQuality=[{}]", imageUrn == null ? "NULL" : "" + imageUrn, imageQuality.name());
			
			ImageMetadata imageMetadata = getImageMetadata(imageUrn, imageQuality, acceptableResponseContent, wadoQuery.isAllowedFromCache());
			
			populateResponseHeaders(resp, transactionContext, imageQuality, imageMetadata, true);				
		} 
		catch (WadoQueryComplianceException e) 
		{
			throw new ServletException(e);
		}
		catch (SecurityCredentialsExpiredException e) 
		{
			e.printStackTrace();
		} 
		catch (ImageServletException e) 
		{
			e.printStackTrace();
		}
		
		return;
	}

	/**
	 * @param resp
	 * @param transactionContext
	 * @param imageQuality
	 * @param imageMetadata
	 */
	private void populateResponseHeaders(
			HttpServletResponse resp,
			TransactionContext transactionContext, 
			ImageQuality imageQuality,
			ImageMetadata imageMetadata,
			boolean includeCustomHeaders) 
	{
		if(imageMetadata.getImageFormat() != null)
		{
			resp.setContentType(imageMetadata.getImageFormat().getMime());
			if(includeCustomHeaders)
			{
				resp.addHeader(TransactionContextHttpHeaders.httpHeaderVistaImageFormat, 
					imageMetadata.getImageFormat().getMimeWithEnclosedMime());
			}
			transactionContext.setFacadeImageFormatSent(imageMetadata.getImageFormat().toString());
		}	
		if(imageQuality != null)
		{
			if(includeCustomHeaders)
			{
				resp.addHeader(TransactionContextHttpHeaders.httpHeaderImageQuality, 
					imageQuality.getCanonical() + "");
			}
			transactionContext.setFacadeImageQualitySent(imageQuality.toString());
		}
		
		resp.setContentLength((int)imageMetadata.getBytesTransferred());
	}

	/**
	 * Validate that elements in the acceptElementList are in the acceptable response types.
	 * Any elements on the accept list that are not on the acceptable reponse types are ignored.
	 * If there are no common elements then it is an error because the client asked for something
	 * outside the specification definition. 
	 * The resulting list of ImageFormat will be in the order of the acceptable response types list.
	 */
	private List<ImageFormat> validateContentType(
		AcceptElementList acceptElementList, 
		List<ImageFormat> acceptableResponseTypes)
	throws WadoQueryComplianceException
	{
		List<ImageFormat> selectedContentType = new ArrayList<ImageFormat>();
				
		// JMW 7/3/2013 - copying this code from AbstractBaseFacadeImageServlet.  This should really extend that class but it doesn't
		// and I'm not changing it now.  The problem with the above is it loses the order of the request which is relevant
		
		for(int i = 0; i < acceptElementList.size(); i++)
		{
			AcceptElement acceptElement = acceptElementList.get(i);			
			String acceptElementType = acceptElement.getMediaType();
			String acceptElementSubType = acceptElement.getMediaSubType();
			String mime = acceptElementType + "/" + acceptElementSubType;
						
			for(ImageFormat imageFormat : acceptableResponseTypes)
			{
				// if the current requested format is anything, then want to add all of the formats this interface supports
				if(ImageFormat.ANYTHING.getMime().equals(mime))
				{
					addUniqueFormatToList(imageFormat, selectedContentType);
					// don't break here, keep looping through the list
				}
				else
				{
					if(imageFormat.getMime().equals(mime))
					{
						addUniqueFormatToList(imageFormat, selectedContentType);
						break; // break out of the for loop (already found the format that matches)
					}
				}	
			}
		}		
		
		if (selectedContentType.size() == 0) 
		{
			String msg = "Illegal Exchange accept type[s], values (";
			
			String acceptElementsString = null;
			for( AcceptElement acceptElement : acceptElementList )
				acceptElementsString += (acceptElementsString==null ? "" : ",") + acceptElement.toString();
			msg += acceptElementsString;

			msg += ") are not of the acceptable types (";
			
			String acceptableElementsString = null;
			for( ImageFormat acceptableImageFormat : acceptableResponseTypes )
				acceptableElementsString += (acceptableElementsString==null ? "" : ",") + acceptableImageFormat.toString();
			msg += acceptableElementsString;
			
			msg += ").";
			
			throw new 
				WadoQueryComplianceException( msg );
		}

		return selectedContentType;
	}
	
	/**
	 * Add a unique image format to the list
	 * @param imageFormat
	 * @param selectedContentType
	 */
	private void addUniqueFormatToList(ImageFormat imageFormat, List<ImageFormat> selectedContentType)
	{
		boolean alreadyInList = false;
		for(ImageFormat selectedFormat : selectedContentType)
		{
			if(selectedFormat == imageFormat)
			{
				alreadyInList = true;
				break;
			}
		}
		if(!alreadyInList)					
			selectedContentType.add(imageFormat);
	}
}
