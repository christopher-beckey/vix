/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Sep 23, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.images;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.AbstractBaseImageServlet;

import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author Julian
 *
 */
public class TextServlet
extends AbstractBaseImageServlet
{
	private static final long serialVersionUID = -144703594063565958L;

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();

        getLogger().info("Beginning GET handler: servlet path=[{}],  path info=[{}],  HTTP method=[{}]\nquery string: [{}]", request.getServletPath(), request.getPathInfo(), request.getMethod(), request.getQueryString());
		
		transactionContext.setRequestType("Viewer Study WebApp V1 getTextFile");
		String imageUrnString = request.getParameter("imageURN");
		try
		{
			ImageURN imageUrn = URNFactory.create(imageUrnString, SERIALIZATION_FORMAT.RAW, ImageURN.class); 
			transactionContext.setPatientID(imageUrn.getPatientId());
			transactionContext.setUrn(imageUrnString);
			transactionContext.setViewerProcess(new Boolean(true));
			transactionContext.setHttpServletRequestMethod(request.getMethod());
			boolean viewerHeadRequest = (request.getMethod() != null) && (request.getMethod().equals("HEAD"));
			transactionContext.setViewerHeadRequest(viewerHeadRequest);
	
			OutputStream outStream = response.getOutputStream();
            getLogger().info("Requesting text file '{}'.", imageUrnString);
			long bytesTransferred = streamTxtFileInstanceByUrn(
					imageUrn, outStream, 
					new MetadataNotification(response, true));
			
			transactionContext.setEntriesReturned( bytesTransferred==0 ? 0 : 1 );
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
		}
		catch(URNFormatException urnfX)
		{
			String msg = "URNFormatException, " + urnfX.getMessage();
			getLogger().error(msg);
			transactionContext.setResponseCode(HttpServletResponse.SC_PRECONDITION_FAILED + "");
			transactionContext.setErrorMessage(msg);
			response.sendError(HttpServletResponse.SC_PRECONDITION_FAILED, msg);
		}
		catch(ImageServletException isX)
		{
			String msg = isX.getMessage();
			getLogger().error(msg);
			transactionContext.setResponseCode(isX.getResponseCode() + "");
			transactionContext.setErrorMessage(msg);
			response.sendError(isX.getResponseCode(), isX.getMessage());
		}
		catch(SecurityCredentialsExpiredException sceX)
		{
			String msg = "SecurityCredentials expired: " + sceX.getMessage();
			// logging of error already done
			// just need to set appropriate error code
			transactionContext.setResponseCode(HttpServletResponse.SC_PRECONDITION_FAILED + "");
			transactionContext.setErrorMessage(msg);
			response.sendError(HttpServletResponse.SC_PRECONDITION_FAILED, msg);
		}		
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#getUserSiteNumber()
	 */
	@Override
	public String getUserSiteNumber()
	{
		return null;
	}
}
