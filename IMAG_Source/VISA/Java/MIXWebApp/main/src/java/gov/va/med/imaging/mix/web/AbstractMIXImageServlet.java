/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Jul 8, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.mix.web;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.AbstractBaseImageServlet;
import org.apache.commons.lang.StringEscapeUtils;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author Julian
 *
 */
public abstract class AbstractMIXImageServlet
extends AbstractBaseImageServlet
{
	private static final long serialVersionUID = 4698967362249071140L;

	public static final String imageJpeg = "image/jpeg";
	public static final String applicationDicomJp2 = "application/dicom+jp2";

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#getUserSiteNumber()
	 */
	@Override
	public String getUserSiteNumber()
	{
		return null;
	}
	
	protected abstract List<ImageFormat> getAcceptableResponseContent(HttpServletRequest request)
	throws MethodException;
	
	protected abstract ImageQuality getImageQuality(HttpServletRequest request);
	
	protected abstract String getOperationName();

	protected abstract boolean isBadContentType(HttpServletRequest request);

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		// Note on imageQuality: 20 is enforced in ThumbnailServlet; 70 and 90 enforced in ImageSerlet; 
		//						100 is not supported, deferred to 90 in ImageServlet
		ImageQuality iQ = getImageQuality(request);
        String requestURI = request.getProtocol() + "://" + request.getRemoteHost() + "/MIXWebApp/" + ((iQ.getCanonical()==20)?"retrieveThumbail":"retrieveInstance");
        @SuppressWarnings("deprecation")
		String requestURL = URLDecoder.decode((request.getRequestURI()==null)?requestURI:request.getRequestURI()  + "?" + request.getQueryString() ); // , "ISO-8859-1");
        getLogger().debug("MIX received GET {} image request: {}", iQ.name(), requestURL);

		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("MIX Web App V1 " + getOperationName());

		String msg="";
		String studyUrnString = null;  // TODO could be checked for special StudyURN format
		String seriesUIDString = null; // TODO could be checked for DUCOM UID syntax
		String imageUrnString = null;
//		String imageQualityString = null;
//		String transferSyntaxString = null;

		String requestType = request.getParameter("requestType");
		if ((requestType!=null) && (requestType.length()>0) && (requestType.equals("WADO")))
		{   // officially the ThumbNail case only, but extended for Ref and Diag use too for HAIMS compatibility
			studyUrnString = request.getParameter("studyUID");
			seriesUIDString = request.getParameter("seriesUID");
			imageUrnString = request.getParameter("objectUID");
//			imageQualityString = request.getParameter("imageQuality");
		} 
		else {
			// sendError: Request not acceptable -- not WADO
			msg = "MIX: Bad/No " + StringEscapeUtils.escapeHtml(getOperationName()) + " requestType is in received request: <" + StringEscapeUtils.escapeHtml(request.getRequestURI()) + ">  -- requestType=WADO parameter is required! ";
			getLogger().error(msg);
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			transactionContext.setErrorMessage(msg);
			response.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg); // 406
			return;
		}
		// check if contentType is ok in request else sendError -- Request not acceptable -- invalid contentType
		if (isBadContentType(request)) {
			// sendError Bad Request -- illegal content type
			msg = "MIX: Bad/No " + StringEscapeUtils.escapeHtml(getOperationName()) + " contentType is in received request: <" + StringEscapeUtils.escapeHtml(request.getRequestURI()) + "> -- contentType=" +
					StringEscapeUtils.escapeHtml(((iQ==ImageQuality.THUMBNAIL)?imageJpeg:applicationDicomJp2)) + " parameter is required!";
			getLogger().error(msg);
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			transactionContext.setErrorMessage(msg);
			response.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg); // 406
			return;
		}

		try
		{
			ImageURN imageUrn = URNFactory.create(imageUrnString, SERIALIZATION_FORMAT.RAW, ImageURN.class); 
			transactionContext.setPatientID(imageUrn.getThePatientIdentifier().toString());
			transactionContext.setUrn(imageUrnString);

			OutputStream outStream = response.getOutputStream();
            getLogger().info("MIX: Requesting {} image [ImageURN = {} -- Series UID = {}; StudyURN = {}]", iQ.name(), imageUrnString, seriesUIDString, studyUrnString);
			long bytesTransferred = streamImageInstanceByUrn(imageUrn, iQ, 
				getAcceptableResponseContent(request), outStream, 
					new MixImageMetadataNotification(response), false);
			
			transactionContext.setEntriesReturned( bytesTransferred==0 ? 0 : 1 );
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
		}
		catch(URNFormatException urnfX)
		{
			msg = "MIX: URNFormatException (on objectUID), " + urnfX.getMessage();
			getLogger().error(msg);
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			transactionContext.setErrorMessage(msg);
			response.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg); // 406
		}
		catch(ImageServletException isX)
		{
			msg = isX.getMessage();
			getLogger().error(msg);
			transactionContext.setResponseCode(isX.getResponseCode() + "");
			transactionContext.setErrorMessage(msg);
			response.sendError(isX.getResponseCode(), isX.getMessage());
		}
		catch(SecurityCredentialsExpiredException sceX)
		{
			msg = "MIX: SecurityCredentials expired: " + sceX.getMessage();
			// logging of error already done
			// just need to set appropriate error code
			transactionContext.setResponseCode(HttpServletResponse.SC_PRECONDITION_FAILED + "");
			transactionContext.setErrorMessage(msg);
			response.sendError(HttpServletResponse.SC_PRECONDITION_FAILED, msg); // 412
		}
		catch(MethodException mX)
		{
			msg = "MIX: MethodException, " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			transactionContext.setErrorMessage(msg);
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg); // 500
		}
		
	}
}
