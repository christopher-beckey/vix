/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 9, 2010
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

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.URNFactory;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotCachedException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.AbstractBaseImageServlet;

/**
 * Abstract base servlet for retrieving exam image text files.
 * 
 * When a BSE token expires, the VIX will respond with a 412 (precondition failed) error message
 * 
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractVistaRadExamImageTextFileServlet
extends AbstractBaseImageServlet
{
	protected abstract int getExamImageTextFileByImageUrn(ImageURN imageUrn, 
		ImageMetadataNotification metadataCallback, OutputStream outStream)
	throws MethodException, ConnectionException;
	
	protected abstract String getOperationTypeDetails();

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		long bytesTransferred = 0;
		TransactionContext transactionContext = TransactionContextFactory.get();

        getLogger().info("Beginning GET handler: servlet path=[{}],  path info=[{}]\nquery string: [{}]", request.getServletPath(), request.getPathInfo(), request.getQueryString());
		String imageUrnString = request.getParameter("imageURN");
		if(imageUrnString == null)
			imageUrnString = request.getParameter("imageUrn");
		
		try
		{	
			ImageURN imageUrn = URNFactory.create(imageUrnString, ImageURN.class);
			
			transactionContext.setPatientID(imageUrn.getPatientId());
			transactionContext.setUrn(imageUrn.toString());	
			transactionContext.setQueryFilter("n/a");
			transactionContext.setRequestType("VistaRad WebApp Exam Image Text File Transfer" + getOperationTypeDetails());
			transactionContext.setImagingSecurityContextType(ImagingSecurityContextType.MAGJ_VISTARAD.toString());
			//logger.debug("VRad w/extensions compliance requested, Request is [" + wadoRequest.toString() + "]" );
			
			MetadataNotification  metadataNotification = new MetadataNotification(response, true);
			bytesTransferred = getExamImageTextFileByImageUrn(imageUrn, 
					metadataNotification, response.getOutputStream());
			
			transactionContext.setEntriesReturned( bytesTransferred==0 ? 0 : 1 );
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
		}
		catch(URNFormatException urnfX)
		{
			String msg = "Request does not contain a valid image Urn: " + urnfX.getMessage();
			getLogger().error(msg, urnfX);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(urnfX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			response.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg );		
		}
		catch(ImageNotCachedException incX)
		{
			String message = "Text file for exam image [" + imageUrnString + "] not found in cache.\n" + incX.getMessage();
			//TransactionContextFactory.get().setErrorMessage(message); // not needed here			
			getLogger().error(message, incX);
			transactionContext.setErrorMessage(message);			
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_FOUND + "");				
			transactionContext.setExceptionClassName(incX.getClass().getSimpleName());
			response.sendError(HttpServletResponse.SC_NOT_FOUND, message );
		}
		catch(ImageNotFoundException infX)
		{
			String message = "Text file for exam image [" + imageUrnString + "] not found.\n" + infX.getMessage();
			//TransactionContextFactory.get().setErrorMessage(message); // not needed here			
			getLogger().error(message, infX);
			transactionContext.setErrorMessage(message);			
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_FOUND + "");				
			transactionContext.setExceptionClassName(infX.getClass().getSimpleName());
			response.sendError(HttpServletResponse.SC_NOT_FOUND, message );
		}
		catch (IOException ioX) 
		{
			String msg = "I/O error requesting exam image text file: " + ioX.getMessage();
			getLogger().error(msg, ioX);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ioX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		} 
		catch(MethodException mX)
		{
			String msg = "Exception when requesting exam image text file: " + mX.getMessage();
			getLogger().error(msg, mX);
			transactionContext.setErrorMessage(msg);			
			SecurityCredentialsExpiredException sceX = findSecurityCredentialsException(mX);
			if(sceX != null)
			{
				transactionContext.setExceptionClassName(sceX.getClass().getSimpleName());
				transactionContext.setResponseCode(HttpServletResponse.SC_PRECONDITION_FAILED + "");
				response.sendError(HttpServletResponse.SC_PRECONDITION_FAILED, msg );	
			}
			else
			{			
				transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
				transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
			}
		}
		catch(Exception x) 
		{
			String message = 
				"Internal server error in accessing exam image text file ["  + "] \n" + 
				x.getMessage();
			getLogger().error(message, x);
			transactionContext.setErrorMessage(message);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, message);
		}
        getLogger().info("GET handler returned {} bytes for query string: [{}] ", bytesTransferred, request.getQueryString());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#getUserSiteNumber()
	 */
	@Override
	public String getUserSiteNumber()
	{
		TransactionContext context = TransactionContextFactory.get();
		return context.getLoggerSiteNumber();
	}

}
