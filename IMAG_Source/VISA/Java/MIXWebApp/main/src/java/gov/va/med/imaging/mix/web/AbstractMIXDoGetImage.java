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
// import gov.va.med.imaging.mix.webservices.rest.MixServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.AbstractBaseImageServlet;

import java.io.IOException;
import java.io.OutputStream;
import java.net.URLDecoder;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringEscapeUtils;
import gov.va.med.logging.Logger;

/**
 * @author Julian
 *
 */
public abstract class AbstractMIXDoGetImage
extends AbstractBaseImageServlet
{
	private static final long serialVersionUID = 4698967362249071150L;
	
	public static final String applicationDicomJp2 = "application/dicom+jp2";
	
	private final static Logger logger = Logger.getLogger(AbstractMIXDoGetImage.class);

	protected Logger getLogger()
	{
		return logger;
	}

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

    private final static String transactionLogHeaderTagName = "X-ConversationID";

	protected abstract ImageQuality getImageQuality(HttpServletRequest request);
	
	protected abstract String getOperationName();

	protected abstract boolean isBadContentType(HttpServletRequest request);

	protected abstract String getImageURN();

	protected abstract OutputStream getOutputStream()
	throws IOException;

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		String msg="";
		String imageUrnString = getImageURN();

		String requestURI = request.getProtocol() + "://" + request.getRemoteHost() + "/MIXWebApp/restservices/mix/RetrieveInstance/studies/{}/series/{}/instances/" + imageUrnString;
        @SuppressWarnings("deprecation")
		String requestURL = URLDecoder.decode((request.getRequestURI()==null)?requestURI:request.getRequestURI()  + "?" + request.getQueryString() ); // , "ISO-8859-1");
        getLogger().debug("MIX received GET REST image request: {}?{}", request.getPathInfo(), request.getQueryString());

		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("MIX Web App V1 " + getOperationName());
		String dasTALogId = request.getHeader(transactionLogHeaderTagName);
		if ((dasTALogId != null) && !dasTALogId.isEmpty()) {
			transactionContext.setTransactionId(dasTALogId);
		}

		// Note on imageQuality: 70 and 90 enforced in MIXDoGetImage; 
		//						100 is not supported, deferred to 90 in MIXDoGetImage
		ImageQuality iQ = getImageQuality(request);

		// check if contentType is ok in request else sendError -- Request not acceptable -- invalid contentType
		if (isBadContentType(request)) {
			// sendError Bad Request -- illegal content type
			msg = "MIX: Bad/No " + StringEscapeUtils.escapeHtml(getOperationName()) + " contentType is in received request: <" + StringEscapeUtils.escapeHtml(request.getRequestURI()) + "> -- contentType=" +
					StringEscapeUtils.escapeHtml(applicationDicomJp2) + " parameter is required!";
			getLogger().error(msg);
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			transactionContext.setErrorMessage(msg);
			response.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg); // 406
			return;
		}
		
		// Fortify change: added try-with-resources
		try (OutputStream outStream = getOutputStream())
		{
			ImageURN imageUrn = URNFactory.create(imageUrnString, SERIALIZATION_FORMAT.RAW, ImageURN.class); 
			transactionContext.setPatientID(imageUrn.getThePatientIdentifier().toString());
			transactionContext.setUrn(imageUrnString);

            getLogger().info("MIX retrieveInstance: Requesting {} image [ImageURN = {}]", iQ.name(), imageUrnString);
			long bytesTransferred = streamImageInstanceByUrn(imageUrn, iQ, 
				getAcceptableResponseContent(request), outStream, 
					new MixImageMetadataNotification(response), false);
			
			transactionContext.setEntriesReturned( bytesTransferred==0 ? 0 : 1 );
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
		}
		catch(URNFormatException urnfX)
		{
			msg = "MIX: URNFormatException (on instanceUid), " + urnfX.getMessage();
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
			int send_code = (isX.getResponseCode() < HttpServletResponse.SC_INTERNAL_SERVER_ERROR) ? isX.getResponseCode() : HttpServletResponse.SC_INTERNAL_SERVER_ERROR;
			response.sendError(send_code, isX.getMessage());
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
