/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Jul 8, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.ax.web;


import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.DocumentURN;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.AbstractBaseImageServlet;

import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

/**
 * @author Julian
 *
 */
public abstract class AbstractAxDoGetDocument
extends AbstractBaseImageServlet
{
	private static final long serialVersionUID = 4698967362249071150L;
	private final static String transactionLogHeaderTagName = "X-ConversationID";
	private final static Logger logger = Logger.getLogger(AbstractAxDoGetDocument.class);

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
		
	protected abstract String getOperationName();

	protected abstract String getDocumentURN();

	protected abstract OutputStream getOutputStream() throws IOException;

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		String msg = null;
		String documentUrnString = getDocumentURN();

        logger.debug("AbstractAxDoGetDocument.doGet() --> GET REST document request: {}?{}", request.getPathInfo(), request.getQueryString());

		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("AbstractAxDoGetDocument.doGet() --> Ax Web App V1 " + getOperationName());
		
		// If request header has a DAS transaction ID, plant it as our transaction ID!
		String dasTALogId = request.getHeader(transactionLogHeaderTagName);
		
		// If request header has no transaction ID, use the passed "transactionID" parameter as our transaction ID!
		if ((dasTALogId == null) || dasTALogId.isEmpty()) {
			dasTALogId = request.getParameter("transactionID");
		}
		
		if ((dasTALogId != null) && !dasTALogId.isEmpty()) {
			transactionContext.setTransactionId(dasTALogId);
		}
		
		// Fortify change: added try-with-resources 
		try (OutputStream outStream = getOutputStream())
		{
			DocumentURN documenteUrn = URNFactory.create(documentUrnString, SERIALIZATION_FORMAT.RAW, DocumentURN.class); 
			transactionContext.setPatientID(documenteUrn.getThePatientIdentifier().toString());
			transactionContext.setUrn(documentUrnString);

            logger.info("AbstractAxDoGetDocument.doGet() --> Requesting document URN [{}]", documentUrnString);
			long bytesTransferred = streamDocument(documenteUrn, outStream,	new AxImageMetadataNotification(response));
			
			transactionContext.setEntriesReturned( bytesTransferred == 0 ? 0 : 1 );
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
		}
		catch(URNFormatException urnfX)
		{
			msg  = "AbstractAxDoGetDocument.doGet() --> Encountered URNFormatException: " + urnfX.getMessage();
			logger.error(msg);
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			transactionContext.setErrorMessage(msg);
			response.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg); // 406 <= comment this line for FHIR error response
		}
		catch(ImageServletException isX)
		{
			msg = "AbstractAxDoGetDocument.doGet() --> Encountered ImageServletException: " + isX.getMessage();
			logger.error(msg);
			transactionContext.setResponseCode(isX.getResponseCode() + "");
			transactionContext.setErrorMessage(msg);
			// make sure no response code higher then 500 is sent out
			int respCode = (isX.getResponseCode() < HttpServletResponse.SC_INTERNAL_SERVER_ERROR) ? isX.getResponseCode() : HttpServletResponse.SC_INTERNAL_SERVER_ERROR;
			response.sendError(respCode, msg);
		}
	}
}
