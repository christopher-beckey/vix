/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 4, 2008
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
package gov.va.med.imaging.federation.webservices;

import gov.va.med.PatientIdentifier;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.ImagingFederationContext;
import gov.va.med.imaging.federation.webservices.intf.ImageFederationMetadata;
import gov.va.med.imaging.federation.webservices.translator.FederationWebAppTranslator;
import gov.va.med.imaging.federation.webservices.types.FederationFilterType;
import gov.va.med.imaging.federation.webservices.types.FederationImageAccessLogEventType;
import gov.va.med.imaging.federation.webservices.types.FederationStudyType;
import gov.va.med.imaging.federation.webservices.types.PatientType;
import gov.va.med.imaging.federation.webservices.types.RequestorType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.rmi.RemoteException;
import java.text.ParseException;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationWebservices 
extends AbstractFederationWebservices
implements ImageFederationMetadata 
{
	private final static FederationWebAppTranslator federationTranslator = new FederationWebAppTranslator();
	private final static Logger LOGGER = Logger.getLogger(FederationWebservices.class);

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.ImageFederationMetadata#getPatientStudyList(gov.va.med.imaging.webservices.types.RequestorType, gov.va.med.imaging.webservices.types.VistaFilterType, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public FederationStudyType[] getPatientStudyList(RequestorType requestor,
			FederationFilterType filter, String patientId, String transactionId,
			String siteId) 
	throws RemoteException 
	{
		setTransactionId(transactionId);
		Long startTime = System.currentTimeMillis();
        LOGGER.info("FederationWebservices.getPatientStudyList() --> Start, transaction Id [{}]", transactionId);
		StudyFilter studyFilter = null;
		try
		{
			studyFilter = federationTranslator.transformFilter(filter);
		}
		catch (GlobalArtifactIdentifierFormatException x)
		{
			String msg = "FederationWebservices.getPatientStudyList() --> Couldn't transform filter, transaction Id [" + transactionId + "]: " + x.getMessage(); 
			LOGGER.error(msg);
			throw new RemoteException(msg, x);
		}
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("Federation WebApp getPatientStudyList");
		transactionContext.setPatientID(patientId);
		transactionContext.setQueryFilter(TransactionContextFactory.getFilterDateRange(studyFilter.getFromDate(), studyFilter.getToDate()));
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		FederationRouter router = ImagingFederationContext.getFederationRouter();
		if(router == null)
			throw new RemoteException("FederationWebservices.getPatientStudyList() --> Internal error: unable to retrieve FederationRouter instance");
		
		//transactionContext.setRequestingSource(transactionContext.getSiteNumber());
		// JMW 4/8/08 - the transaction context contains the current site details, not details from requestor, that is in the requestor object
		transactionContext.setRequestingSource(requestor.getFacilityId());
		// not sure about this next line... 4/8/08 jmw
		transactionContext.setSiteNumber(requestor.getFacilityId());
		gov.va.med.imaging.federation.webservices.types.FederationStudyType[] result = null;		
		try
		{
			List<Study> studies = router.getPatientStudyList(RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId), 
					PatientIdentifier.icnPatientIdentifier(patientId), studyFilter);
			transactionContext.setEntriesReturned( studies == null ? 0 : studies.size() );
            LOGGER.info("FederationWebservices.getPatientStudyList() --> Received [{}] study(ies) from router", studies == null ? 0 : studies.size());
			result = federationTranslator.transformStudies(studies);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices.getPatientStudyList() --> MethodException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException(msg, mX);
		}
		catch(ParseException pX)
		{
			String msg = "FederationWebservices.getPatientStudyList() --> ParseException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + pX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(pX.getClass().getSimpleName());
			throw new RemoteException(msg, pX);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices.getPatientStudyList() --> ConnectionException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "FederationWebservices.getPatientStudyList() --> RoutingTokenFormatException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + rtfX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException(msg, rtfX);
		}

        LOGGER.info("FederationWebservices.getPatientStudyList() --> Complete for transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return result;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.ImageFederationMetadata#postImageAccessEvent(java.lang.String, gov.va.med.imaging.webservices.types.VistaImageAccessLogEventType)
	 */
	@Override
	public boolean postImageAccessEvent(String transactionId, 
			FederationImageAccessLogEventType logEvent) 
	throws RemoteException 
	{
        LOGGER.info("FederationWebservices.postImageAccessEvent() --> Start, transaction Id [{}]", transactionId);
		
		setTransactionId(transactionId);
    	long startTime = System.currentTimeMillis();
    	TransactionContext transactionContext = TransactionContextFactory.get();

		FederationRouter router = ImagingFederationContext.getFederationRouter();
		if(router == null)
			throw new RemoteException("FederationWebservices.postImageAccessEvent() --> Internal error: unable to retrieve FederationRouter instance");

        LOGGER.info("FederationWebservices.postImageAccessEvent() -->  logEvent image Id [{}]", logEvent.getImageId());
		try
		{
			ImageAccessLogEvent event = federationTranslator.transformLogEvent(logEvent);
			// not sure if this should be here, what if ICN is empty?
			
			transactionContext.setPatientID(event.getPatientIcn());
			transactionContext.setRequestType("Federation WebApp postImageAccessEvent [" + logEvent.getEventType() + "]");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setRequestingSource(transactionContext.getSiteNumber());
			// need to use the Id from the webservice log event since it is the full URN and not just 
			// the individual image identifier
			transactionContext.setUrn(logEvent.getImageId());
			router.logImageAccessEvent(event);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices.postImageAccessEvent() --> MethodException: Counld NOT post image access for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException(msg, mX);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices.postImageAccessEvent() --> ConnectionException: Counld NOT post image access for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(URNFormatException iurnfX) 
		{
			String msg = "FederationWebservices.postImageAccessEvent() --> ConnectionException: Counld NOT post image access for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + iurnfX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException(msg, iurnfX);
		}

        LOGGER.info("FederationWebservices.postImageAccessEvent() --> Complete for transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.ImageFederationMetadata#prefetchStudyList(java.lang.String, java.lang.String, java.lang.String, gov.va.med.imaging.webservices.types.VistaFilterType)
	 */
	@Override
	public String prefetchStudyList(String transactionId, String siteId,
			String patientId, FederationFilterType filter) 
	throws RemoteException 
	{
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public String getImageDevFields(String imageUrn, String flags,
			String transactionId) 
	throws RemoteException 
	{
		return getImageDevFieldsInternalHandleExceptions(imageUrn, flags, transactionId);
	}

	@Override
	public String getImageInformation(String imageUrn, String transactionId)
	throws RemoteException 
	{
		return getImageInformationInternalHandleExceptions(imageUrn, transactionId);
	}

	@Override
	public String getImageSystemGlobalNode(String imageUrn, String transactionId)
	throws RemoteException 
	{
		return getImageSystemGlobalNodeInternalHandleExceptions(imageUrn, transactionId);
	}

	@Override
	public String[] getPatientSitesVisited(String patientIcn, String transactionId, 
		String siteId) 
	throws RemoteException 
	{
		return getPatientSitesVisitedInternalHandleExceptions(patientIcn, transactionId, siteId);
	}

	@Override
	public PatientType[] searchPatients(String searchCriteria,
			String transactionId, String siteId) 
	throws RemoteException 
	{
		setTransactionId(transactionId);
		long startTime = System.currentTimeMillis();
        LOGGER.info("FederationWebservices.searchPatients() --> Start, transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		try{
			transactionContext.setPatientID("n/a");
			transactionContext.setRequestType("Federation WebApp searchPatients");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setRequestingSource(transactionContext.getSiteNumber());
			FederationRouter router = ImagingFederationContext.getFederationRouter();
			if(router == null)
				throw new RemoteException("FederationWebservices.searchPatients() --> Internal error: unable to retrieve FederationRouter instance");
			
			List<Patient> patients = router.getPatientList(searchCriteria, RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId) );
			gov.va.med.imaging.federation.webservices.types.PatientType[] response = federationTranslator.transformPatients(patients);
			transactionContext.setEntriesReturned( response == null ? 0 : response.length );
            LOGGER.info("FederationWebservices.searchPatients() --> Complete for transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}		
		catch(MethodException mX)
		{
			String msg = "FederationWebservices.searchPatients() --> MethodException: Counld NOT search for patients for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException(msg, mX);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices.searchPatients() --> ConnectionException: Counld NOT search for patients for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "FederationWebservices.searchPatients() --> RoutingTokenFormatException: Counld NOT search for patients for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + rtfX.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException(msg, rtfX);
		}
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.AbstractFederationWebservices#getWepAppName()
	 */
	@Override
	protected String getWepAppName() 
	{
		return "Federation WebApp V1";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.AbstractFederationWebservices#transformSitesToSiteNumberArary(java.util.List)
	 */
	@Override
	protected String[] transformSitesToSiteNumberArray(List<ResolvedArtifactSource> sites) 
	{
		return federationTranslator.transformSitesToSiteNumberArary(sites);
	}
	
}
