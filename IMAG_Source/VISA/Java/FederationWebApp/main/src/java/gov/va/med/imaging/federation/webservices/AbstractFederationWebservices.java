/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 4, 2009
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
package gov.va.med.imaging.federation.webservices;

import gov.va.med.PatientIdentifier;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.PatientNotFoundException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.ImagingFederationContext;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import java.io.IOException;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.List;
import org.apache.axis.AxisFault;
import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractFederationWebservices 
{
	protected abstract String getWepAppName();
	
	protected abstract String[] transformSitesToSiteNumberArray(List<ResolvedArtifactSource> sites) 
	throws RemoteException;
	
	
	private final static Logger LOGGER = Logger.getLogger(AbstractFederationWebservices.class);
	
	protected Logger getLogger()
	{
		return LOGGER;
	}
	
	protected void setTransactionId(String transactionId)
	{
        LOGGER.info("AbstractFederationWebservices.setTransactionId() --> to Id [{}]", transactionId);
		if(transactionId != null)
			TransactionContextFactory.get().setTransactionId(transactionId);	
	}
	
	protected String getVistaRadRequisitionReportInternal(long startTime, String transactionId, String studyUrnString)
	throws ConnectionException, MethodException, URNFormatException
	{
		setTransactionId(transactionId);
        LOGGER.info("AbstractFederationWebservices.getVistaRadRequisitionReportInternal() --> Start, transaction Id [{}]", transactionId);
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		StudyURN studyUrn = URNFactory.create(studyUrnString, StudyURN.class);
		transactionContext.setPatientID(studyUrn.getPatientId());
		transactionContext.setRequestType(getWepAppName() + " getVistaRadRequisitionReportInternal");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		setVistaRadImagingContext();
		FederationRouter router = ImagingFederationContext.getFederationRouter();
		if(router == null)
			throw new ConnectionException("AbstractFederationWebservices.getVistaRadRequisitionReportInternal() --> Internal error: unable to retrieve FederationRouter instance");
		
		String response = router.getExamRequisitionReport(studyUrn);
		transactionContext.setFacadeBytesSent(response == null ? 0L : response.length());
        LOGGER.info("AbstractFederationWebservices.getVistaRadRequisitionReportInternal() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}
	
	protected String getVistaRadRadiologyReportInternal(long startTime, String transactionId, String studyUrnString)
	throws ConnectionException, MethodException, URNFormatException
	{
		setTransactionId(transactionId);
        LOGGER.info("AbstractFederationWebservices.getVistaRadRadiologyReportInternal() --> Start, transaction Id [{}]", transactionId);
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		StudyURN studyUrn = URNFactory.create(studyUrnString, StudyURN.class);
		transactionContext.setPatientID(studyUrn.getPatientId());
		transactionContext.setRequestType(getWepAppName() + " getVistaRadRadiologyReportInternal");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		setVistaRadImagingContext();
		FederationRouter router = ImagingFederationContext.getFederationRouter();
		if(router == null)
			throw new ConnectionException("AbstractFederationWebservices.getVistaRadRadiologyReportInternal() --> Internal error: unable to retrieve FederationRouter instance");
		
		String response = router.getExamReport(studyUrn);
		transactionContext.setFacadeBytesSent(response == null ? 0L : response.length());
        LOGGER.info("AbstractFederationWebservices.getVistaRadRadiologyReportInternal() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}
	
	protected String[] getPatientSitesVisitedInternalHandleExceptions(String patientIcn, String transactionId, String siteId) 
	throws RemoteException
	{
		long startTime = System.currentTimeMillis();		
		TransactionContext transactionContext = TransactionContextFactory.get();		
		try
		{
			return getPatientSitesVisitedInternal(startTime, patientIcn, transactionId, siteId);
		}
		/*
		 * Could have shorten all these catches into the last one for this and other classes:
		    catch(Exception ex) 
		    {
		   		String msg = "className.methodName() --> " + ex.getClass().getSimpleName() + ": common message: " + ex.getMessage();
		   		LOGGER.error(msg);
				transactionContext.setErrorMessage(msg);
				transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
				throw createAxisFaultException(cX);
		    }
		 *
		 *  Left as they are = no testing to confirm
		 *  
		 */
		catch(MethodException mX)
		{
			String msg = "AbstractFederationWebservices.getPatientSitesVisitedInternalHandleExceptions() --> MethodException: Counld NOT get patient visited sites for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw createAxisFaultException(mX);
		}
		catch(ConnectionException cX)
		{
			String msg = "AbstractFederationWebservices.getPatientSitesVisitedInternalHandleExceptions() --> ConnectionException: Counld NOT get patient visited sites for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw createAxisFaultException(cX);
		}
		catch(Exception ex)
		{
			String msg = "AbstractFederationWebservices.getPatientSitesVisitedInternalHandleExceptions() --> Generic exception: Counld NOT get patient visited sites for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw createAxisFaultException(ex);
		}
	}
	
	protected String[] getPatientSitesVisitedInternal(long startTime, String patientIcn, String transactionId, String siteId) 
	throws ConnectionException, MethodException 
	{
		setTransactionId(transactionId);
        LOGGER.info("AbstractFederationWebservices.getPatientSitesVisitedInternal() --> Start, transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			transactionContext.setPatientID(patientIcn);
			transactionContext.setRequestType(getWepAppName() + " getPatientSitesVisitedInternal");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			FederationRouter router = ImagingFederationContext.getFederationRouter();
			if(router == null)
				throw new ConnectionException("AbstractFederationWebservices.getPatientSitesVisitedInternal() --> Internal error: unable to retrieve FederationRouter instance");
			
			List<ResolvedArtifactSource> sites = null;
			try
			{
				sites = router.getTreatingSites(RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId), 
						PatientIdentifier.icnPatientIdentifier(patientIcn));
			}
			catch(PatientNotFoundException pnfX)
			{
				// this version of federation expects an array of empty sites to be returned rather than an exception
				sites = new ArrayList<ResolvedArtifactSource>(0);
			}
			String [] response = transformSitesToSiteNumberArray(sites);
			transactionContext.setEntriesReturned( response == null ? 0 : response.length );
            LOGGER.info("AbstractFederationWebservices.getPatientSitesVisitedInternal() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}		
		catch(ClassCastException ccX)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(ccX);
		}
		catch(ImageNotFoundException infX)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(infX);
		}
		catch(IOException ioX)
		{
			// logging and transaction context setting handled by calling method
			throw new ConnectionException(ioX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
			throw new ConnectionException(rtfX);
		}	
	}
	
	protected String getImageSystemGlobalNodeInternal(long startTime, String imageUrn, String transactionId)
	throws MethodException, ConnectionException
	{
		setTransactionId(transactionId);
        LOGGER.info("AbstractFederationWebservices.getImageSystemGlobalNodeInternal() --> Start, transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		AbstractImagingURN urn = null;
		try
		{
			urn = URNFactory.create(imageUrn, AbstractImagingURN.class);
			transactionContext.setPatientID(urn.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " getImageSystemGlobalNodeInternal");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(imageUrn);
			FederationRouter router = ImagingFederationContext.getFederationRouter();
			if(router == null)
				throw new ConnectionException("AbstractFederationWebservices.getImageSystemGlobalNodeInternal() --> Internal error: unable to retrieve FederationRouter instance");
			
			String response = router.getImageSystemGlobalNode(urn);
			transactionContext.setFacadeBytesSent(response == null ? 0L : response.length());
            LOGGER.info("AbstractFederationWebservices.getImageSystemGlobalNodeInternal() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}
		catch(ClassCastException ccX)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(ccX);
		}
		catch(URNFormatException iurnfX)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(iurnfX);
		}
		catch(ImageNotFoundException infX)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(infX);
		}
	}
	
	protected String getImageSystemGlobalNodeInternalHandleExceptions(String imageUrn, String transactionId)
	throws RemoteException 
	{
		long startTime = System.currentTimeMillis();		
		TransactionContext transactionContext = TransactionContextFactory.get();		
		try
		{
			return getImageSystemGlobalNodeInternal(startTime, imageUrn, transactionId);
		}		
		catch(MethodException mX)
		{
			String msg = "AbstractFederationWebservices.getImageSystemGlobalNodeInternalHandleExceptions() --> MethodException: Counld NOT get image system global node for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw createAxisFaultException(mX);
		}
		catch(ConnectionException cX)
		{
			String msg = "AbstractFederationWebservices.getImageSystemGlobalNodeInternalHandleExceptions() --> ConnectionException: Counld NOT get image system global node for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw createAxisFaultException(cX);
		}
		catch(Exception ex)
		{
			String msg = "AbstractFederationWebservices.getImageSystemGlobalNodeInternalHandleExceptions() --> Generic exception: Counld NOT get image system global node for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw createAxisFaultException(ex);
		}
	}
	
	protected String getImageInformationInternalHandleExceptions(String imageUrn, String transactionId)
	throws RemoteException 
	{		
		long startTime = System.currentTimeMillis();				
		TransactionContext transactionContext = TransactionContextFactory.get();		
		try
		{
			return getImageInformationInternal(startTime, imageUrn, transactionId);
		}		
		catch(MethodException mX)
		{
			String msg = "AbstractFederationWebservices.getImageInformationInternalHandleExceptions() --> MethodException: Counld NOT get image information for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			LOGGER.info(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw createAxisFaultException(mX);
		}
		catch(ConnectionException cX)
		{
			String msg = "AbstractFederationWebservices.getImageInformationInternalHandleExceptions() --> ConnectionException: Counld NOT get image information for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw createAxisFaultException(cX);
		}
		catch(Exception ex)
		{
			String msg = "AbstractFederationWebservices.getImageInformationInternalHandleExceptions() --> Generic exception: Counld NOT get image information for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw createAxisFaultException(ex);
		}
	}
	
	protected String getImageInformationInternal(long startTime, String imageUrn, String transactionId)
	throws MethodException, ConnectionException 
	{
		setTransactionId(transactionId);
        LOGGER.info("AbstractFederationWebservices.getImageInformationInternal() --> Start, transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		AbstractImagingURN urn = null;
		try
		{
			urn = URNFactory.create(imageUrn, AbstractImagingURN.class);
			transactionContext.setPatientID(urn.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " getImageInformationInternal");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(urn.toString());
			FederationRouter router = ImagingFederationContext.getFederationRouter();
			if(router == null)
				throw new ConnectionException("AbstractFederationWebservices.getImageInformationInternal() --> Internal error: unable to retrieve FederationRouter instance");
			
			String response = router.getImageInformation(urn);
			transactionContext.setFacadeBytesSent(response == null ? 0L : response.length());
            LOGGER.info("AbstractFederationWebservices.getImageInformationInternal() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}
		catch(ClassCastException ccX)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(ccX);
		}
		catch(URNFormatException iurnfX)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(iurnfX);
		}
		catch(ImageNotFoundException infX)
		{
			// logging and transaction context setting handled by calling method
			throw infX;
		}
	}
	
	protected String getImageDevFieldsInternalHandleExceptions(String imageUrn, String flags, String transactionId) 
	throws RemoteException 
	{
		long startTime = System.currentTimeMillis();
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			return getImageDevFieldsInternal(startTime, imageUrn, flags, transactionId);
		}		
		catch(MethodException mX)
		{
			String msg = "AbstractFederationWebservices.getImageDevFieldsInternalHandleExceptions() --> MethodException: Counld NOT get image dev fields for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			LOGGER.info(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw createAxisFaultException(mX);
		}
		catch(ConnectionException cX)
		{
			String msg = "AbstractFederationWebservices.getImageDevFieldsInternalHandleExceptions() --> ConnectionException: Counld NOT get image dev fields for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw createAxisFaultException(cX);
		}
		catch(Exception ex)
		{
			String msg = "AbstractFederationWebservices.getImageDevFieldsInternalHandleExceptions() --> Generic exception: Counld NOT get image dev fields for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw createAxisFaultException(ex);
		}
	}
	
	protected String getImageDevFieldsInternal(long startTime, String imageUrn, String flags,
			String transactionId) 
	throws MethodException, ConnectionException
	{
		setTransactionId(transactionId);
        LOGGER.info("AbstractFederationWebservices.getImageDevFieldsInternal() --> Start, transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		AbstractImagingURN urn = null;
		try
		{
			urn = URNFactory.create(imageUrn, AbstractImagingURN.class);
			transactionContext.setPatientID(urn.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " getImageDevFieldsInternal");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(imageUrn);
			FederationRouter router = ImagingFederationContext.getFederationRouter();
			if(router == null)
				throw new ConnectionException("AbstractFederationWebservices.getImageDevFieldsInternal() --> Internal error: unable to retrieve FederationRouter instance");
			
			String response = router.getImageDevFields(urn, flags);
			transactionContext.setFacadeBytesSent(response == null ? 0L : response.length());
            LOGGER.info("AbstractFederationWebservices.getImageDevFieldsInternal() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}
		catch(ClassCastException ccX)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(ccX);
		}
		catch(URNFormatException iurnfX)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(iurnfX);
		}
		catch(ImageNotFoundException infX)
		{
			// logging and transaction context setting handled by calling method
			throw infX;
		}
	}
	
	protected AxisFault createAxisFaultException(Exception ex)
	{
		AxisFault af = new AxisFault(ex.getMessage());
		af.setFaultCodeAsString(ex.getClass().getName());
		return af;
	}
		
	protected void setVistaRadImagingContext()
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setImagingSecurityContextType(ImagingSecurityContextType.MAGJ_VISTARAD.toString());
	}
}
