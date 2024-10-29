/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 3, 2012
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

package gov.va.med.imaging.roi.web;

import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.exceptions.PatientIdentifierParseException;
import gov.va.med.imaging.GUID;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.channels.AbstractBytePump.TRANSFER_TYPE;
import gov.va.med.imaging.channels.ByteStreamPump;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.roi.commands.periodic.PeriodicROICommandStarter;
import gov.va.med.imaging.roi.ROIFacadeContext;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIDisclosureServlet
extends HttpServlet
{
	private static final long serialVersionUID = -596012649568845060L;
	private final static Logger logger = Logger.getLogger(ROIDisclosureServlet.class);
	protected Logger getLogger()
	{
		return logger;
	}
	
	private final String zipApplicationMimeType = "application/zip";

	public void init() 
	throws ServletException
	{
		logger.info("ROIDisclosureServlet init()");
		PeriodicROICommandStarter.startROIPeriodicCommands();
		logger.info("PeriodicROICommandStarter.startROIPeriodicCommands() called");
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("ROI WebApp V1 getDisclosure");
		String patientId = request.getParameter("patientId");
		String patientIdentifierTypeString = request.getParameter("patientIdentifierType");
		PatientIdentifierType patientIdentifierType = null;
		if(patientIdentifierTypeString != null && patientIdentifierTypeString.length() > 0)
			patientIdentifierType = PatientIdentifierType.valueOf(patientIdentifierTypeString);
		PatientIdentifier patientIdentifier = null;
		if(patientIdentifierType != null)
			patientIdentifier = new PatientIdentifier(patientId, patientIdentifierType);
		else
		{
			// assumes that patientId contains the identifier type, if not then ICN is assumed
			try {
			patientIdentifier = PatientIdentifier.fromString(patientId);
			} catch (PatientIdentifierParseException e) {
				throw new ServletException("Patient Identifier Parse Exception.");
			}
		}
		String guidString = request.getParameter("guid");		
		
		GUID guid = new GUID(guidString);
		
		transactionContext.setPatientID(patientId);
		transactionContext.setUrn(guidString);
		transactionContext.setQueryFilter("n/a");
		response.setContentType(zipApplicationMimeType);
		response.setHeader("Content-Disposition", "attachment; filename=\"" + StringUtil.cleanString(guidString) + ".zip" + "\"");
		OutputStream outStream = response.getOutputStream();
		
		try
		{
			long bytesTransferred = streamROIDisclosure(patientIdentifier, guid, outStream);
			transactionContext.setEntriesReturned( bytesTransferred==0 ? 0 : 1 );
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
		}
		catch(ImageServletException isX)
		{
			String msg = isX.getMessage();
			logger.error(msg);
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
	
	protected long streamROIDisclosure(
			PatientIdentifier patientIdentifier,
			GUID guid, 			
			OutputStream outStream)
	throws IOException, SecurityCredentialsExpiredException, ImageServletException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		long bytesTransferred = 0;
		try 
		{
			InputStream roiDisclosureStream = 
				ROIFacadeContext.getRoiFacadeRouter().getROIDisclosure(patientIdentifier, guid);
			
			if (roiDisclosureStream == null) 
			{
				String message = "No ROI disclosure for [" + guid + "].";
				TransactionContextFactory.get().setErrorMessage(message);
				getLogger().debug(message);
				throw new ImageServletException(HttpServletResponse.SC_NOT_FOUND, message);
			}
			else	// SUCCESS (SC_OK) -- 200
			{
				String message = "Pushing ROI disclosure for [" + guid + "].";
				getLogger().debug(message);
				
				ByteStreamPump pump = ByteStreamPump.getByteStreamPump(TRANSFER_TYPE.FileToNetwork);
				
				bytesTransferred = pump.xfer(roiDisclosureStream, outStream);
				roiDisclosureStream.close();
			}
		} 
		catch (ImageNotFoundException inle)
		{
			String message = "ROI disclosure for [" + guid + "] not found.";
			getLogger().debug(message);
			transactionContext.setExceptionClassName(inle.getClass().getSimpleName());
			throw new ImageServletException(HttpServletResponse.SC_NOT_FOUND, message);
		}
		catch(MethodException mX) 
		{
			String message = 
				"Internal server error in getting ROI disclosure for [" + guid + "] \n" + 
				mX.getMessage();
			getLogger().debug(message);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new ImageServletException(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, message);
		}
		catch(ConnectionException mX) 
		{
			String message = 
				"Internal server error in getting ROI disclosure for [" + guid + "] \n" + 
				mX.getMessage();
			getLogger().debug(message);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new ImageServletException(HttpServletResponse.SC_BAD_GATEWAY, message);
		}	
		return bytesTransferred;
	}
	

	public class ImageServletException
	extends Exception
	{
		private static final long serialVersionUID = 1L;
		private final int responseCode;
		
		ImageServletException(int responseCode, String message)
        {
	        super(message);
	        this.responseCode = responseCode;
        }

		public int getResponseCode()
        {
        	return responseCode;
        }
	}

}
