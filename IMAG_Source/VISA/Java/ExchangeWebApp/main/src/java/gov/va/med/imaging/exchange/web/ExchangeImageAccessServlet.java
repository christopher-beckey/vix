/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: August 10, 2006
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWTITTOC
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

package gov.va.med.imaging.exchange.web;

import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.http.AcceptElement;
import gov.va.med.imaging.http.AcceptElementList;
import gov.va.med.imaging.http.exceptions.HttpHeaderParseException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.AbstractBaseImageServlet;
import gov.va.med.imaging.wado.query.WadoQuery;
import gov.va.med.imaging.wado.query.WadoRequest;
import gov.va.med.imaging.wado.query.exceptions.WadoQueryComplianceException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.management.InstanceNotFoundException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

/**
 * @author Chris Beckey
 * @since 1.0
 *
 * --------------------------------------------------------------
 * @web.servlet 
 *   name="ExchangeImageAccessServlet" 
 *   display-name="Exchange Image Access" 
 *   description="Servlet implementing the WAI specification of VIX ICD."
 * 
 * @web.servlet-mapping 
 *   url-pattern="/image/*"
 * ----------------------------------------------------------------
 */
public class ExchangeImageAccessServlet
extends AbstractBaseImageServlet
{
	private static final long serialVersionUID = 1L;
	
	public static final List<ImageFormat> acceptableThumbnailResponseTypes;
	public static final List<ImageFormat> acceptableReferenceResponseTypes;
	public static final List<ImageFormat> acceptableDiagnosticResponseTypes;
	
	static
	{
		acceptableThumbnailResponseTypes = new ArrayList<ImageFormat>();
		acceptableThumbnailResponseTypes.add(ImageFormat.JPEG);
		
		acceptableReferenceResponseTypes = new ArrayList<ImageFormat>();
		acceptableReferenceResponseTypes.add(ImageFormat.DICOMJPEG2000);
		acceptableReferenceResponseTypes.add(ImageFormat.J2K);
		acceptableReferenceResponseTypes.add(ImageFormat.JPEG);
//		acceptableReferenceResponseTypes.add(ImageFormat.DICOM); // DICOM must be here because the request type will be application/dicom which literally converts to this one
		
		acceptableDiagnosticResponseTypes = new ArrayList<ImageFormat>();
		acceptableDiagnosticResponseTypes.add(ImageFormat.DICOMJPEG2000);
		acceptableDiagnosticResponseTypes.add(ImageFormat.J2K);
		acceptableDiagnosticResponseTypes.add(ImageFormat.JPEG);
//		acceptableDiagnosticResponseTypes.add(ImageFormat.DICOM); // DICOM must be here because the request type will be application/dicom which literally converts to this one
	}
	
	private final static Logger LOGGER = Logger.getLogger(ExchangeImageAccessServlet.class);	
	
	/**
	 * 
	 */
	public ExchangeImageAccessServlet()
	{
		super();
	}
	
	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occur
	 */
	public void init() 
	throws ServletException
	{
		super.init();
	}
	
	
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#getUserSiteNumber()
	 */
	@Override
	public String getUserSiteNumber() 
	{
		return ExchangeUtil.getDodSiteNumber();
	}
	
	protected String getWebAppName()
	{
		return "Exchange WebApp";
	}

	/**
	 * 
	 * @see javax.servlet.http.HttpServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
	throws ServletException, IOException
	{
		WadoRequest wadoRequest=null;
		long bytesTransferred = 0;
		TransactionContext transactionContext = TransactionContextFactory.get();

        LOGGER.info("ExchangeImageAccessServlet.doGet() --> Beginning GET handler: servlet path=[{}],  path info=[{}]\nquery string: [{}]", req.getServletPath(), req.getPathInfo(), req.getQueryString());
		
		try
		{
			wadoRequest = WadoRequest.createParsedXChangeCompliantWadoRequest(req);
			initTransactionContext(wadoRequest);
			transactionContext.setRequestType(getWebAppName() + " " + transactionContext.getRequestType());
            LOGGER.debug("ExchangeImageAccessServlet.doGet() --> XCHANGE w/extensions compliance requested, Request is [{}]", wadoRequest.toString());
			bytesTransferred = doExchangeCompliantGet(wadoRequest, resp);
			transactionContext.setEntriesReturned( bytesTransferred==0 ? 0 : 1 );
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
		}
		catch( WadoQueryComplianceException wadoX )
		{
			String msg = "ExchangeImageAccessServlet.doGet() --> Request is not a valid Exchange (WAI) protocol request: " + wadoX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(wadoX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			resp.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg );			
		}
		catch( HttpHeaderParseException httpParseX )
		{
			String msg = "ExchangeImageAccessServlet.doGet() --> Error parsing HTTP header information: " + httpParseX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(httpParseX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		}
		catch (IOException ioX) 
		{
			String msg = "ExchangeImageAccessServlet.doGet() --> I/O error when sending image content: " + ioX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ioX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		} 
		catch (ImageServletException isX)
        {
			String msg = "ExchangeImageAccessServlet.doGet() --> Error: " + isX.getMessage();
			LOGGER.error(isX); // want stack trace to figure out problem
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
			// for DoD - cannot return an error for security exception, return generic 500 error
			String msg = "ExchangeImageAccessServlet.doGet() --> Exception accessing image: " + sceX.getMessage();
			// logging of error already done
			// just need to set appropriate error code
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			transactionContext.setErrorMessage(msg);
			resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg);
		}
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "ExchangeImageAccessServlet.doGet() --> Error: " + rtfX.getMessage();
			LOGGER.error(rtfX); // want stack trace to figure out problem
			transactionContext.setErrorMessage(msg);
			// don't set the transactionContext.setExceptionClassName() property here
			// it gets set in the AbstractBaseImageServlet because that is where the real
			// exception is caught
			//transactionContext.setExceptionClassName(isX.getClass().getName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		}

        LOGGER.info("ExchangeImageAccessServlet.doGet() --> GET handler returned {} bytes for query string: [{}] ", bytesTransferred, req.getQueryString());
	}

	/**
	 * 
	 * @param wadoRequest
	 * @param resp
	 * @throws WadoQueryComplianceException
	 * @throws IOException
	 * @throws ImageServletException 
	 * @throws InstanceNotFoundException
	 */
	protected long doExchangeCompliantGet(WadoRequest wadoRequest, HttpServletResponse resp) 
	throws WadoQueryComplianceException, IOException, ImageServletException, SecurityCredentialsExpiredException
	{
        LOGGER.debug("ExchangeImageAccessServlet.doExchangeCompliantGet() --> WADO request [{}]", wadoRequest.toString());
		WadoQuery wadoQuery = wadoRequest.getWadoQuery();
		
		ImageURN imageUrn = wadoQuery.getInstanceUrn();
		ImageQuality imageQuality = ImageQuality.getImageQuality( wadoRequest.getWadoQuery().getImageQualityValue() );
		AcceptElementList contentTypeList = wadoQuery.getContentTypeList();
		List<ImageFormat> acceptableResponseContent = validateContentType(imageQuality, contentTypeList);
		
		// Do sanity check for non-Wado requests
        LOGGER.debug("ExchangeImageAccessServlet.doExchangeCompliantGet() --> GET params: imageUrn [{}]  ImageQuality [{}]", imageUrn == null ? "NULL" : imageUrn, imageQuality.name());
				
		// if the object (instance) GUID is supplied then just stream the instance
		// back, ignoring any other parameters
		
		MetadataNotification  metadataNotification = new MetadataNotification(resp);
		return streamImageInstanceByUrn(imageUrn, imageQuality, acceptableResponseContent, 
				resp.getOutputStream(), metadataNotification, true);
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
			return validateContentType(acceptElementList, acceptableThumbnailResponseTypes);
		else if(imageQuality == ImageQuality.REFERENCE)
			return validateContentType(acceptElementList, acceptableReferenceResponseTypes);
		else if(imageQuality == ImageQuality.DIAGNOSTIC)
			return validateContentType(acceptElementList, acceptableDiagnosticResponseTypes);
		else if(imageQuality == ImageQuality.DIAGNOSTICUNCOMPRESSED)
			return validateContentType(acceptElementList, acceptableDiagnosticResponseTypes);

		throw new 
		WadoQueryComplianceException("ExchangeImageAccessServlet.validateContentType() --> Unknown image quality value for "
			+ (imageQuality == null ? "null" : imageQuality.name()) +			// 16Sep2008 CTB name() changed from toString() 
			" image [" + acceptElementList.toString() + "]" );
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
		
		//		iQ = THUMBNAILS --> always JPEG (lossy) -- needs image/jpeg (default) or */*!
		//		iQ = REFERENCE, DIAGNOSTIC --> DICOM wrapped JPEG or J2K,
		//              -- only alternately plain J2K or JPEG
		//				-- needs application/dicom (default), alternately image/jp2, image/jpeg or */*!
		for(ImageFormat imageFormat : acceptableResponseTypes)
		{
			for(int i=0; i < acceptElementList.size(); ++i ) 
			{ 
				AcceptElement acceptElement = acceptElementList.get(i);
				String acceptElementType = acceptElement.getMediaType();
				String acceptElementSubType = acceptElement.getMediaSubType();
				String mime = acceptElementType + "/" + acceptElementSubType;
				if((imageFormat.getMime().equals(mime)) || (ImageFormat.ANYTHING.getMime().equals(mime)))
				{								
					selectedContentType.add(imageFormat);					
					// break here so that if there are multiple mime types in the request that match the
					// current ImageFormat, only take the first one (remove duplicates)
					break; 
				}
				/*
				ImageFormat acceptElementImageFormat = ImageFormat.valueOfMimeType(acceptElementType + "/" + acceptElementSubType);
				
				//if(acceptElementImageFormat == ImageFormat.ANYTHING || acceptElementImageFormat == imageFormat)
				// JMW 4/21/08 - compare mime types so that application/dicom for DICOM J2K will equal application/dicom (for uncompressed dicom)
				// then we put in the value from the acceptableResponseTypes list which will limit the response to J2K DICOM
				if(acceptElementImageFormat == ImageFormat.ANYTHING || 
						acceptElementImageFormat.getMime().equals(imageFormat.getMime()))
					selectedContentType.add(imageFormat);
				*/
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
}