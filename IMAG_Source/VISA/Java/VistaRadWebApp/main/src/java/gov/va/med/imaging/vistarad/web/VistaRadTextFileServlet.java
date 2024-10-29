/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 11, 2009
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

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import gov.va.med.URNFactory;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.vistarad.ImagingVistaRadContext;
import gov.va.med.imaging.wado.AbstractBaseImageServlet;

/**
 * @author vhaiswwerfej
 * 
 * When a BSE token expires, the VIX will respond with a 412 (precondition failed) error message
 *
 */
public class VistaRadTextFileServlet 
extends AbstractBaseImageServlet 
{
	private static final long serialVersionUID = -6041045607370974498L;
	
	private final static Logger logger = Logger.getLogger(VistaRadTextFileServlet.class);

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException 
	{
		long bytesTransferred = 0;
		TransactionContext transactionContext = TransactionContextFactory.get();

        logger.info("Beginning GET handler: servlet path=[{}],  path info=[{}]\nquery string: [{}]", request.getServletPath(), request.getPathInfo(), request.getQueryString());
		
		try
		{
			String studyUrnString = request.getParameter("studyUrn");

			StudyURN studyUrn = URNFactory.create(studyUrnString, StudyURN.class);
			
			transactionContext.setPatientID(studyUrn.getPatientId());
			transactionContext.setUrn(studyUrn.toString());	
			transactionContext.setQueryFilter("n/a");
			transactionContext.setRequestType("VistaRad WebApp Exam Text Files Transfer");
			transactionContext.setImagingSecurityContextType(ImagingSecurityContextType.MAGJ_VISTARAD.toString());
			//logger.debug("VRad w/extensions compliance requested, Request is [" + wadoRequest.toString() + "]" );
			
			bytesTransferred = ImagingVistaRadContext.getVistaRadRouter().getExamTextFiles(studyUrn, 
					response.getOutputStream());
			
			transactionContext.setEntriesReturned( bytesTransferred==0 ? 0 : 1 );
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
		}
		catch(URNFormatException urnfX)
		{
			String msg = "Request does not contain a valid study Urn: " + urnfX.getMessage();
			logger.error(msg, urnfX);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(urnfX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_NOT_ACCEPTABLE + "");
			response.sendError(HttpServletResponse.SC_NOT_ACCEPTABLE, msg );		
		}
		catch (IOException ioX) 
		{
			String msg = "I/O error requesting exam text files: " + ioX.getMessage();
			logger.error(msg, ioX);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ioX.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, msg );
		} 
		catch(MethodException mX)
		{
			String msg = "Exception when requesting exam text files: " + mX.getMessage();
			logger.error(msg, mX);
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
				"Internal server error in accessing exam text files ["  + "] \n" + 
				x.getMessage();
			getLogger().error(message, x);
			transactionContext.setErrorMessage(message);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_INTERNAL_SERVER_ERROR + "");
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, message);
		}
        logger.info("GET handler returned {} bytes for query string: [{}] ", bytesTransferred, request.getQueryString());
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
