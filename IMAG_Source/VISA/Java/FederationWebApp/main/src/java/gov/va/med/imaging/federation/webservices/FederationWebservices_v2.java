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
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.ImagingFederationContext;
import gov.va.med.imaging.federation.webservices.translator.FederationWebAppTranslator_v2;
import gov.va.med.imaging.federation.webservices.types.v2.FederationFilterType;
import gov.va.med.imaging.federation.webservices.types.v2.FederationStudyLoadLevelType;
import gov.va.med.imaging.federation.webservices.types.v2.RequestorType;
import gov.va.med.imaging.federation.webservices.types.v2.StudiesType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.math.BigInteger;
import java.rmi.RemoteException;
import java.text.ParseException;
import java.util.List;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationWebservices_v2 
extends AbstractFederationWebservices
implements gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata
{
	private FederationWebAppTranslator_v2 federationTranslator = new FederationWebAppTranslator_v2();

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata#getImageDevFields(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String getImageDevFields(String imageUrn, String flags,
			String transactionId) 
	throws RemoteException 
	{
		return getImageDevFieldsInternalHandleExceptions(imageUrn, flags, transactionId);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata#getImageInformation(java.lang.String, java.lang.String)
	 */
	@Override
	public String getImageInformation(String imageUrn, String transactionId)
	throws RemoteException 
	{
		return getImageInformationInternalHandleExceptions(imageUrn, transactionId);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata#getImageSystemGlobalNode(java.lang.String, java.lang.String)
	 */
	@Override
	public String getImageSystemGlobalNode(String imageUrn, String transactionId)
	throws RemoteException 
	{
		return getImageSystemGlobalNodeInternalHandleExceptions(imageUrn, transactionId);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata#getPatientSensitivityLevel(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public gov.va.med.imaging.federation.webservices.types.v2.PatientSensitiveCheckResponseType getPatientSensitivityLevel(
			String transactionId, String siteId, String patientIcn)
	throws RemoteException 
	{
		setTransactionId(transactionId);
        getLogger().info("FederationWebservices_v2.getPatientSensitivityLevel() --> For transaction Id [{}] at site Id [{}]", transactionId, siteId);
		long startTime = System.currentTimeMillis();
		gov.va.med.imaging.federation.webservices.types.v2.PatientSensitiveCheckResponseType response = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " getPatientSensitivityLevel");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		transactionContext.setPatientID(patientIcn);
		FederationRouter router = ImagingFederationContext.getFederationRouter(); 
		try
		{
			PatientSensitiveValue sensitiveValue =  router.getPatientSensitiveValue(RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId), patientIcn);
			response = federationTranslator.transformPatientSensitiveValue(sensitiveValue);			
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v2.getPatientSensitivityLevel() --> ConnectionException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v2.getPatientSensitivityLevel() --> MethodException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException(msg, mX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "FederationWebservices_v2.getPatientSensitivityLevel() --> RoutingTokenFormatException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + rtfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException(msg, rtfX);
		}

        getLogger().info("FederationWebservices_v2.getPatientSensitivityLevel() --> Complete for transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata#getPatientSitesVisited(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String[] getPatientSitesVisited(String patientIcn,
			String transactionId, String siteId) 
	throws RemoteException 
	{
		return getPatientSitesVisitedInternalHandleExceptions(patientIcn, transactionId, siteId);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata#getPatientStudyList(gov.va.med.imaging.federation.webservices.types.v2.RequestorType, gov.va.med.imaging.federation.webservices.types.v2.FederationFilterType, java.lang.String, java.lang.String, java.lang.String, java.math.BigInteger, gov.va.med.imaging.federation.webservices.types.v2.FederationStudyLoadLevelType)
	 */
	@Override
	public StudiesType getPatientStudyList(RequestorType requestor,
			FederationFilterType filter, String patientId,
			String transactionId, String siteId,
			BigInteger authorizedSensitivityLevel,
			FederationStudyLoadLevelType studyLoadLevelType) 
	throws RemoteException 
	{
		setTransactionId(transactionId);
		Long startTime = System.currentTimeMillis();
        getLogger().info("FederationWebservices_v2.getPatientStudyList() --> For transaction Id [{}] at site Id [{}]", transactionId, siteId);
		StudyFilter studyFilter = null;
		try
		{
			studyFilter = federationTranslator.transformFilter(filter, authorizedSensitivityLevel.intValue());
		}
		catch (GlobalArtifactIdentifierFormatException x)
		{
			String msg = "FederationWebservices_v2.getPatientStudyList() --> Couldn't transform filter, transaction Id [" + transactionId + "]: " + x.getMessage(); 
			getLogger().error(msg);
			throw new RemoteException(msg, x);
		}
		StudyLoadLevel studyLoadLevel = federationTranslator.transformStudyLoadLevel(studyLoadLevelType);
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() +  " getPatientStudyList");
		transactionContext.setPatientID(patientId);
		transactionContext.setQueryFilter(TransactionContextFactory.getFilterDateRange(studyFilter.getFromDate(), studyFilter.getToDate()));
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		FederationRouter router = ImagingFederationContext.getFederationRouter();
		if(router == null)
			throw new RemoteException("FederationWebservices_v2.getPatientStudyList() --> Internal error: unable to retrieve FederationRouter instance");
		// not sure about this next line... 4/8/08 jmw
		transactionContext.setSiteNumber(requestor.getFacilityId());
		gov.va.med.imaging.federation.webservices.types.v2.StudiesType result = null;		
		try
		{
			List<Study> studies = null;
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId);
			PatientIdentifier patientIdObj = PatientIdentifier.icnPatientIdentifier(patientId);
			
			if(studyLoadLevel == StudyLoadLevel.STUDY_ONLY)
				studies = router.getPatientShallowStudyList(routingToken, patientIdObj, studyFilter);
			else if(studyLoadLevel == StudyLoadLevel.STUDY_AND_REPORT)
				studies = router.getPatientShallowStudyWithReportList(routingToken,	patientIdObj, studyFilter);
			else			
				studies = router.getPatientStudyList(routingToken, patientIdObj, studyFilter);
			
			transactionContext.setEntriesReturned( studies == null ? 0 : studies.size() );
            getLogger().info("FederationWebservices_v2.getPatientStudyList() --> Received [{}] study(ies) from router", studies == null ? 0 : studies.size());
			result = federationTranslator.transformStudiesToResponse(studies);
		}
		catch(InsufficientPatientSensitivityException ipsX)
		{
			String msg = "FederationWebservices_v2.getPatientStudyList() --> InsufficientPatientSensitivityException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ipsX.getMessage();
			getLogger().error(msg);			
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ipsX.getClass().getSimpleName());
			result = federationTranslator.transformExceptionToShallowStudiesType(ipsX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v2.getPatientStudyList() --> MethodException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException(msg, mX);
		}
		catch(ParseException pX)
		{
			String msg = "FederationWebservices_v2.getPatientStudyList() --> ParseException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + pX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(pX.getClass().getSimpleName());
			throw new RemoteException(msg, pX);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v2.getPatientStudyList() --> ConnectionException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "FederationWebservices_v2.getPatientStudyList() --> RoutingTokenFormatException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + rtfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException(msg, rtfX);
		}

        getLogger().info("FederationWebservices_v2.getPatientStudyList() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return result;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata#postImageAccessEvent(java.lang.String, gov.va.med.imaging.federation.webservices.types.v2.FederationImageAccessLogEventType)
	 */
	@Override
	public boolean postImageAccessEvent(String transactionId,
			gov.va.med.imaging.federation.webservices.types.v2.FederationImageAccessLogEventType logEvent) 
	throws RemoteException 
	{
        getLogger().info("FederationWebservices_v2.postImageAccessEvent() --> Start, transaction Id [{}]", transactionId);
		
		setTransactionId(transactionId);
    	long startTime = System.currentTimeMillis();
    	TransactionContext transactionContext = TransactionContextFactory.get();

		FederationRouter router = ImagingFederationContext.getFederationRouter();
		if(router == null)
			throw new RemoteException("FederationWebservices_v2.postImageAccessEvent() --> Internal error: unable to retrieve FederationRouter instance");

        getLogger().info("FederationWebservices_v2.postImageAccessEvent() -->  logEvent image Id [{}]", logEvent.getImageId());
		try
		{
			ImageAccessLogEvent event = federationTranslator.transformLogEvent(logEvent);
			// not sure if this should be here, what if ICN is empty?
			
			transactionContext.setPatientID(event.getPatientIcn());
			transactionContext.setRequestType(getWepAppName() + " postImageAccessEvent [" + logEvent.getEventType() + "]");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			// need to use the Id from the webservice log event since it is the full URN and not just 
			// the individual image identifier
			transactionContext.setUrn(logEvent.getImageId());
			router.logImageAccessEvent(event);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v2.postImageAccessEvent() --> MethodException: Counld NOT post image access for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException(msg, mX);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v2.postImageAccessEvent() --> ConnectionException: Counld NOT post image access for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(URNFormatException iurnfX) 
		{
			String msg = "FederationWebservices_v2.postImageAccessEvent() --> ConnectionException: Counld NOT post image access for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + iurnfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException(msg, iurnfX);
		}

        getLogger().info("FederationWebservices_v2.postImageAccessEvent() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata#prefetchStudyList(java.lang.String, java.lang.String, java.lang.String, gov.va.med.imaging.federation.webservices.types.v2.FederationFilterType)
	 */
	@Override
	public String prefetchStudyList(String transactionId, String siteId, String patientId, 
			gov.va.med.imaging.federation.webservices.types.v2.FederationFilterType filter)
			throws RemoteException {
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata#searchPatients(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public gov.va.med.imaging.federation.webservices.types.v2.PatientType[] searchPatients(
			String searchCriteria, String transactionId, String siteId) 
	throws RemoteException 
	{
        getLogger().info("FederationWebservices_v2.searchPatients() --> Start, transaction Id [{}]", transactionId);
		
		setTransactionId(transactionId);
		long startTime = System.currentTimeMillis();
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		try
		{
			transactionContext.setPatientID("n/a");
			transactionContext.setRequestType(getWepAppName() + " searchPatients");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			FederationRouter router = ImagingFederationContext.getFederationRouter();
			if(router == null)
				throw new RemoteException("FederationWebservices_v2.searchPatients() --> Internal error: unable to retrieve FederationRouter instance");

			List<Patient> patients = router.getPatientList(searchCriteria, RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId));
			gov.va.med.imaging.federation.webservices.types.v2.PatientType[] response =	federationTranslator.transformPatients(patients);
			transactionContext.setEntriesReturned( response == null ? 0 : response.length );
            getLogger().info("FederationWebservices_v2.searchPatients() --> Complete for transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}		
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v2.searchPatients() --> MethodException: Counld NOT search for patients for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException(msg, mX);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v2.searchPatients() --> ConnectionException: Counld NOT search for patients for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "FederationWebservices_v2.searchPatients() --> RoutingTokenFormatException: Counld NOT search for patients for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + rtfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException(msg, rtfX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata#getStudyFromCprsIdentifier(java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType getStudyFromCprsIdentifier(
			String patientId, String transactionId, String siteId, String cprsIdentifier)
	throws RemoteException 
	{
        getLogger().info("FederationWebservices_v2.getStudyFromCprsIdentifier() --> Start, transaction Id [{}]", transactionId);
		
		setTransactionId(transactionId);
		long startTime = System.currentTimeMillis();
		gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType response = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " getStudyFromCprsIdentifier");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		FederationRouter router = ImagingFederationContext.getFederationRouter(); 
		try
		{
			List<Study> studies = router.getStudiesByCprsIdentifier(patientId, 
					RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId), new CprsIdentifier(cprsIdentifier));			
			response = federationTranslator.transformStudiesToStudy(studies);			
		}
		catch(ParseException pX)
		{
			String msg = "FederationWebservices_v2.getStudyFromCprsIdentifier() --> ParseException: Counld NOT get study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + pX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(pX.getClass().getSimpleName());
			throw new RemoteException(msg, pX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v2.getStudyFromCprsIdentifier() --> MethodException: Counld NOT get study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException(msg, mX);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v2.getStudyFromCprsIdentifier() --> ConnectionException: Counld NOT get study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "FederationWebservices_v2.getStudyFromCprsIdentifier() --> RoutingTokenFormatException: Counld NOT get study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + rtfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException(msg, rtfX);
		}

        getLogger().info("FederationWebservices_v2.getStudyFromCprsIdentifier() --> Complete for transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.AbstractFederationWebservices#getWepAppName()
	 */
	@Override
	protected String getWepAppName() 
	{
		return "Federation WebApp V2";
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
