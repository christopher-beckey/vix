/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 29, 2009
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
package gov.va.med.imaging.federation.web;

import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.wado.AbstractBaseImageServlet;

/**
 * Servlet for providing Photo Ids for a patient through the Federation interface
 * 
 * @author vhaiswwerfej
 *
 */
public class FederationPhotoIdServlet 
extends AbstractBaseImageServlet
{
	private static final long serialVersionUID = -295979902757377789L;

	public FederationPhotoIdServlet()
	{
		super();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.wado.AbstractBaseImageServlet#doGet(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException 
	{
		TransactionContext transactionContext = TransactionContextFactory.get();			
		transactionContext.setRequestType("Federation WebApp V1 photo Id transfer");
		String siteNumber = request.getParameter("siteNumber");
		String patientIcn = request.getParameter("patientIcn");
		transactionContext.setPatientID(patientIcn);
		transactionContext.setQueryFilter("n/a");
		OutputStream outStream = response.getOutputStream();
        getLogger().info("Federation WebApp V1 photo Id transfer for patient [{}] at site [{}]", patientIcn, siteNumber);
		long startTime = System.currentTimeMillis();
		try
		{
			long bytesTransferred = streamPatientIdImageByPatientIcn(siteNumber,
					PatientIdentifier.icnPatientIdentifier(patientIcn), outStream);
			transactionContext.setEntriesReturned( bytesTransferred==0 ? 0 : 1 );
			transactionContext.setFacadeBytesSent(bytesTransferred);
			transactionContext.setResponseCode(HttpServletResponse.SC_OK + "");
            getLogger().info("complete Federation WebApp V1 photo Id transfer transaction({}) in {} ms", transactionContext.getTransactionId(), System.currentTimeMillis() - startTime);
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
		TransactionContext context = TransactionContextFactory.get();
		return context.getLoggerSiteNumber();
	}
}
