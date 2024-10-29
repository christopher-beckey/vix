/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 8, 2008
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
package gov.va.med.imaging.clinicaldisplay.web;

import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.http.exceptions.HttpHeaderParseException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.query.WadoRequest;
import gov.va.med.imaging.wado.query.exceptions.WadoQueryComplianceException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

/**
 * 
 * Version 3 implementation of the ClinicalDisplay web image servlet. The major difference
 * for version 3 from version is that version 3 does not explicitly log image access when
 * an image is requested. Image access logging is expected to be done by the client when
 * the image is actually viewed.
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ClinicalDisplayImageAccessServletV3 
extends AbstractBaseClinicalDisplayImageAccessServlet 
{
	
	private static final long serialVersionUID = 1L;
	
	private final static Logger logger = Logger.getLogger(ClinicalDisplayImageAccessServletV3.class);
	
	private static final List<ImageFormat> acceptableThumbnailResponseTypes;
	private static final List<ImageFormat> acceptableReferenceResponseTypes;
	private static final List<ImageFormat> acceptableDiagnosticResponseTypes;
	
	static
	{
		acceptableThumbnailResponseTypes = new ArrayList<ImageFormat>();		
		acceptableThumbnailResponseTypes.add(ImageFormat.JPEG);
		acceptableThumbnailResponseTypes.add(ImageFormat.BMP);
		acceptableThumbnailResponseTypes.add(ImageFormat.TGA);
		acceptableThumbnailResponseTypes.add(ImageFormat.ORIGINAL);
		
		acceptableReferenceResponseTypes = new ArrayList<ImageFormat>();		
		acceptableReferenceResponseTypes.add(ImageFormat.DICOMJPEG2000);
		//acceptableReferenceResponseTypes.add(ImageFormat.DICOM);
		acceptableReferenceResponseTypes.add(ImageFormat.TGA);
		acceptableReferenceResponseTypes.add(ImageFormat.PDF);
		acceptableReferenceResponseTypes.add(ImageFormat.DOC);
		acceptableReferenceResponseTypes.add(ImageFormat.RTF);
		acceptableReferenceResponseTypes.add(ImageFormat.TEXT_PLAIN);
		acceptableReferenceResponseTypes.add(ImageFormat.AVI);
		acceptableReferenceResponseTypes.add(ImageFormat.BMP);
		acceptableReferenceResponseTypes.add(ImageFormat.HTML);
		acceptableReferenceResponseTypes.add(ImageFormat.MP3);
		acceptableReferenceResponseTypes.add(ImageFormat.MPG);
		acceptableReferenceResponseTypes.add(ImageFormat.J2K);
		acceptableReferenceResponseTypes.add(ImageFormat.JPEG);
		acceptableReferenceResponseTypes.add(ImageFormat.TIFF);
		acceptableReferenceResponseTypes.add(ImageFormat.WAV);
		acceptableReferenceResponseTypes.add(ImageFormat.DOCX);
		acceptableReferenceResponseTypes.add(ImageFormat.XML);
		acceptableReferenceResponseTypes.add(ImageFormat.ORIGINAL);
		
		acceptableDiagnosticResponseTypes = new ArrayList<ImageFormat>();		
		acceptableDiagnosticResponseTypes.add(ImageFormat.DICOMJPEG2000);
		acceptableDiagnosticResponseTypes.add(ImageFormat.TGA);
		acceptableDiagnosticResponseTypes.add(ImageFormat.J2K);
		acceptableDiagnosticResponseTypes.add(ImageFormat.JPEG);
		acceptableDiagnosticResponseTypes.add(ImageFormat.PDF);
		acceptableDiagnosticResponseTypes.add(ImageFormat.DOC);
		acceptableDiagnosticResponseTypes.add(ImageFormat.RTF);
		acceptableDiagnosticResponseTypes.add(ImageFormat.TEXT_PLAIN);
		acceptableDiagnosticResponseTypes.add(ImageFormat.AVI);
		acceptableDiagnosticResponseTypes.add(ImageFormat.BMP);
		acceptableDiagnosticResponseTypes.add(ImageFormat.HTML);
		acceptableDiagnosticResponseTypes.add(ImageFormat.MP3);
		acceptableDiagnosticResponseTypes.add(ImageFormat.MPG);
		acceptableDiagnosticResponseTypes.add(ImageFormat.TIFF);
		acceptableDiagnosticResponseTypes.add(ImageFormat.WAV);
		acceptableDiagnosticResponseTypes.add(ImageFormat.DOCX);
		acceptableDiagnosticResponseTypes.add(ImageFormat.XML);
		acceptableDiagnosticResponseTypes.add(ImageFormat.ORIGINAL);
	}
	
	public ClinicalDisplayImageAccessServletV3()
	{
		super();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException 
	{
		WadoRequest wadoRequest=null;
		long bytesTransferred = 0;
		TransactionContext transactionContext = TransactionContextFactory.get();

        logger.info("Beginning GET handler: servlet path=[{}],  path info=[{}]\nquery string: [{}]", req.getServletPath(), req.getPathInfo(), req.getQueryString());
		
		try
		{
			wadoRequest = WadoRequest.createParsedCDTPCompliantWadoRequest(req);
			initTransactionContext(wadoRequest);
			transactionContext.setRequestType(getWepAppName() + " " + transactionContext.getRequestType());
            logger.debug("XCHANGE w/extensions compliance requested, Request is [{}]", wadoRequest.toString());
			bytesTransferred = doExchangeCompliantGet(wadoRequest, resp, false);
			transactionContext.setEntriesReturned( bytesTransferred==0 ? 0 : 1 );
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
		}
		catch( WadoQueryComplianceException wadoX )
		{
			String msg = "Request is not a valid Exchange (WAI) protocol request: " + wadoX.getMessage();
			logger.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(wadoX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			resp.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg );
		}
		catch( HttpHeaderParseException httpParseX )
		{
			String msg = "Error parsing HTTP header information: " + httpParseX.getMessage();
			logger.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(httpParseX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		}
		catch (IOException ioX) 
		{
			String msg = "I/O error when sending image content: " + ioX.getMessage();
			logger.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ioX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		} 
		catch (ImageServletException isX)
        {
			String msg = isX.getMessage();
			logger.error(msg);
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
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "Unexpected error building routing token: " + rtfX.getMessage();
			// logging of error already done
			// just need to set appropriate error code
			transactionContext.setResponseCode(HttpServletResponse.SC_PRECONDITION_FAILED + "");
			transactionContext.setErrorMessage(msg);
			resp.sendError(HttpServletResponse.SC_PRECONDITION_FAILED, msg);
		}

        logger.info("GET handler returned {} bytes for query string: [{}] ", bytesTransferred, req.getQueryString());
		
	}
	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#init()
	 */
	@Override
	public void init() throws ServletException {
		// TODO Auto-generated method stub
		super.init();
	}



	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.web.AbstractBaseClinicalDisplayImageAccessServlet#getAcceptableDiagnosticResponseTypes()
	 */
	@Override
	protected List<ImageFormat> getAcceptableDiagnosticResponseTypes(boolean includeSubTypes) 
	{
		if(includeSubTypes)
		{
			List<ImageFormat> formats = new ArrayList<ImageFormat>(acceptableDiagnosticResponseTypes);
			formats.add(0, ImageFormat.DICOM); // cannot be at the bottom (ORIGINAL must be last), top doesn't really matter
			formats.add(0, ImageFormat.DICOMJPEG);
			formats.add(0, ImageFormat.DICOMPDF);
			return formats;
		}
		else
		{
			return acceptableDiagnosticResponseTypes;
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.web.AbstractBaseClinicalDisplayImageAccessServlet#getAcceptableReferenceResponseTypes()
	 */
	@Override
	protected List<ImageFormat> getAcceptableReferenceResponseTypes(boolean includeSubTypes) 
	{
		if(includeSubTypes)
		{
			List<ImageFormat> formats = new ArrayList<ImageFormat>(acceptableReferenceResponseTypes);
			formats.add(0, ImageFormat.DICOM); // cannot be at the bottom (ORIGINAL must be last), top doesn't really matter
			formats.add(0, ImageFormat.DICOMJPEG);
			formats.add(0, ImageFormat.DICOMPDF);
			return formats;
		}
		else
		{
			return acceptableReferenceResponseTypes;
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.web.AbstractBaseClinicalDisplayImageAccessServlet#getAcceptableThumbnailResponseTypes()
	 */
	@Override
	protected List<ImageFormat> getAcceptableThumbnailResponseTypes() 
	{
		return acceptableThumbnailResponseTypes;
	}
	
	protected String getWepAppName() 
	{
		return "Clinical Display WebApp V3";
	}
}
