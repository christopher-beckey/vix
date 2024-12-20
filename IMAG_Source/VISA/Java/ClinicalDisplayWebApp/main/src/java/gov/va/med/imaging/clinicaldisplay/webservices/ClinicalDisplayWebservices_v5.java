/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 30, 2009
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
package gov.va.med.imaging.clinicaldisplay.webservices;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.BhieStudyURN;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.clinicaldisplay.ImagingClinicalDisplayContext;
import gov.va.med.imaging.clinicaldisplay.configuration.ClinicalDisplayWebAppConfiguration;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.RemoteMethodInputParameterType;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials;
import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator5;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.PassthroughInputMethod;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.Requestor.PurposeOfUse;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.SiteConnectivityStatus;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.math.BigInteger;
import java.rmi.RemoteException;

import org.apache.logging.log4j.Level;
import gov.va.med.logging.Logger;


/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayWebservices_v5 
extends AbstractClinicalDisplayWebservices 
implements gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageClinicalDisplayMetadata
{
	private final static Logger LOGGER = Logger.getLogger(ClinicalDisplayWebservices_v5.class);
	private final static ClinicalDisplayTranslator5 interpreter = new ClinicalDisplayTranslator5();

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.AbstractClinicalDisplayWebservices#getWepAppName()
	 */
	@Override
	protected String getWepAppName() 
	{
		return "Clinical Display WebApp V5";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageClinicalDisplayMetadata#getImageDevFields(java.lang.String, java.lang.String, java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials)
	 */
	@Override
	public String getImageDevFields(String imageId, String flags,
		String transactionId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials)
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
		return this.getImageDevFields(imageId, flags, transactionId);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageClinicalDisplayMetadata#getImageInformation(java.lang.String, java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials)
	 */
	@Override
	public String getImageInformation(String imageId, String transactionId,
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials) 
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
		return getImageInformation(imageId, transactionId);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageClinicalDisplayMetadata#getImageSystemGlobalNode(java.lang.String, java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials)
	 */
	@Override
	public String getImageSystemGlobalNode(String imageId, String transactionId,
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials) 
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
		return getImageSystemGlobalNode(imageId, transactionId);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageClinicalDisplayMetadata#getPatientSensitivityLevel(java.lang.String, java.lang.String, java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials)
	 */
	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitiveCheckResponseType getPatientSensitivityLevel(
		String transactionId, String siteId, String patientId,
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials) 
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
        LOGGER.info("ClinicalDisplayWebservices_v5.getPatientSensitivityLevel() --> Start transaction Id [{}]", transactionId);
		long startTime = System.currentTimeMillis();
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PatientSensitiveCheckResponseType response = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " getPatientSensitivityLevel");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
		try
		{
			RoutingToken routingToken = RoutingTokenImpl.createVARadiologySite(siteId);
			PatientSensitiveValue sensitiveValue =  rtr.getPatientSensitiveValue(routingToken, patientId);
			response = interpreter.transformPatientSensitiveValue(sensitiveValue);			
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.getPatientSensitivityLevel() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v5.getPatientSensitivityLevel() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.getPatientSensitivityLevel() --> FAILED routing token format exception with transaction Id [{}]{}", transactionId, rtfX.getMessage());
			transactionContext.setErrorMessage(rtfX.getMessage());
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v4.getPatientSensitivityLevel() --> Internal error, unable to translate study metadata", rtfX);
		}
		catch(Exception ex)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.getPatientSensitivityLevel() --> Generic exception: {}", ex.getMessage());
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v5.getPatientSensitivityLevel() --> Internal error, generic exception", ex);
		}

        LOGGER.info("ClinicalDisplayWebservices_v5.getPatientSensitivityLevel() --> Completed with transaction Id [{}] in {} ms", transactionId, System.currentTimeMillis() - startTime);
		
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageClinicalDisplayMetadata#getPatientShallowStudyList(java.lang.String, java.lang.String, java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FilterType, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials, java.math.BigInteger)
	 */
	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType getPatientShallowStudyList(
		String transactionId, String siteId, String patientId, 
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FilterType filter,
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials, 
		BigInteger authorizedSensitivityLevel)
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
		Long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v5.getPatientShallowStudyList() --> Start with transaction Id [{}]", transactionId);
		TransactionContext transactionContext = TransactionContextFactory.get();
		StudyFilter internalFilter = interpreter.transformFilter(filter, authorizedSensitivityLevel.intValue());
		// initialize the transaction context
		transactionContext.setRequestType(getWepAppName() + " getPatientShallowStudyList");
		transactionContext.setPatientID(patientId);
		transactionContext.setQueryFilter(TransactionContextFactory.getFilterDateRange(internalFilter.getFromDate(), 
				internalFilter.getToDate()));
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 

		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudiesType result = null;
		
		try 	
		{
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId);
            LOGGER.info("ClinicalDisplayWebservices_v5.getPatientShallowStudyList() --> Routing to site [{}]", routingToken.toRoutingTokenString());
			// must call patient artifact command in order to get all studies if calling a VA site with patch 104 installed (since study graph SPI now only returns radiology data)
			ArtifactResults artifactResults = rtr.getShallowArtifactResultsForPatientFromSite(
					routingToken, PatientIdentifier.icnPatientIdentifier(patientId),
					internalFilter, true, false);
			// update the transaction context with the study count
			transactionContext.setEntriesReturned( artifactResults == null ? 0 : artifactResults.getArtifactSize() );
			result = interpreter.transformStudiesToShallowStudies(artifactResults);
		}
		catch(InsufficientPatientSensitivityException ipsX)
		{
            LOGGER.warn("ClinicalDisplayWebservices_v5.getPatientShallowStudyList() --> FAILED connection exception: {}", ipsX.getMessage());
			transactionContext.setErrorMessage(ipsX.getMessage());
			transactionContext.setExceptionClassName(ipsX.getClass().getSimpleName());
			result = interpreter.transformExceptionToShallowStudiesType(ipsX);
			//throw new RemoteException("Internal error, unable to retrieve patient studies", mX);
		}
		catch(MethodException mX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.getPatientShallowStudyList() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v5.getPatientShallowStudyList() --> Internal error, unable to retrieve patient studies", mX);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.getPatientShallowStudyList() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v4.getPatientShallowStudyList() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(URNFormatException iurnfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.getPatientShallowStudyList() --> FAILED URN format exception with transaction Id [{}]: {}", transactionId, iurnfX.getMessage());
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v4.getPatientShallowStudyList() --> Internal error, unable to translate study metadata", iurnfX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.getPatientShallowStudyList() --> FAILED routing token format exception with transaction Id [{}]{}", transactionId, rtfX.getMessage());
			transactionContext.setErrorMessage(rtfX.getMessage());
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v5.getPatientShallowStudyList() --> Internal error, unable to translate study metadata", rtfX);
		}
		
		if( LOGGER.isDebugEnabled() )
		{
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ShallowStudyType[] studies = 
				result == null ? null : 
					result.getStudies() == null ? null :
						result.getStudies().getStudy();
			StringBuilder sb = new StringBuilder();
			
			sb.append("ClinicalDisplayWebservices_v5.getPatientShallowStudyList() --> returning " + (studies == null ? "<null>" : studies.length) + " study IDs: \n");
			
			for(int studyIndex = 0; studies != null && studyIndex < studies.length; ++studyIndex)
				sb.append("  - " + studies[studyIndex].getStudyId() + " \n");
			
			getLogger().debug(sb.toString());
		}

        LOGGER.info("ClinicalDisplayWebservices_v5.getPatientShallowStudyList() --> Completed with transaction Id [{}] in {} ms)", transactionId, System.currentTimeMillis() - startTime);
		
        return result;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageClinicalDisplayMetadata#getStudyImageList(java.lang.String, java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials)
	 */
	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[] getStudyImageList(
			String transactionId,
			String studyId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials) 
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
    	
    	long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v5.getStudyImageList() --> Start with transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		StudyURN studyUrn = null;
		try
		{
			studyUrn = URNFactory.create(studyId, SERIALIZATION_FORMAT.CDTP, StudyURN.class);
		}
		catch (Throwable x)
		{
			getLogger().error(x);
			throw new RemoteException(x.getMessage());
		}
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FatImageType[] result = null;
		// initialize the transaction context
		transactionContext.setRequestType(getWepAppName() + " getStudyImageList");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		Study study = null;
		try 
		{
			//studyUrn = URNFactory.create(studyId, StudyURN.class);		
			transactionContext.setUrn(studyId);
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			if(studyUrn instanceof StudyURN)
			{
				// update the transaction context with patientId
				transactionContext.setPatientID(((StudyURN)studyUrn).getPatientId());
				study = rtr.getPatientStudy((StudyURN)studyUrn);
			}
			else if(studyUrn instanceof BhieStudyURN)
			{
				// update the transaction context with patientId
				transactionContext.setPatientID(((BhieStudyURN)studyUrn).getPatientId());
				study = rtr.getPatientStudy((BhieStudyURN)studyUrn);
			}
				
			transactionContext.setEntriesReturned( study == null ? 0 : study.getImageCount());
			result = interpreter.transformStudyToFatImages(study);
		}
		catch(URNFormatException iurnfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.getStudyImageList() --> FAILED URN format exception with transaction Id [{}]: {}", transactionId, iurnfX.getMessage());
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v5.getStudyImageList() --> Internal error, unable to translate study metadata", iurnfX);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.getStudyImageList() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v5.getStudyImageList() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.getStudyImageList() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("ClinicalDisplayWebservices_v5.getStudyImageList() --> Internal error, unable to retrieve patient studies", mX);
		}

        LOGGER.info("ClinicalDisplayWebservices_v5.getStudyImageList() --> Completed with transaction Id [{}] in {} ms)", transactionId, System.currentTimeMillis() - startTime);
		
		return result;   
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageClinicalDisplayMetadata#getStudyReport(java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials, java.lang.String)
	 */
	@Override
	public String getStudyReport(String transactionId,
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials, String studyId) 
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
		return getStudyReport(studyId, transactionId);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageClinicalDisplayMetadata#pingServerEvent(java.lang.String, java.lang.String, java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials)
	 */
	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PingServerTypePingResponse pingServerEvent(
			String transactionId,
			String clientWorkstation, String requestSiteNumber,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials) 
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
		long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v5.pingServerEvent() --> From [{}] going to site number [{}]", clientWorkstation, requestSiteNumber);
    	
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PingServerTypePingResponse response = 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PingServerTypePingResponse.SERVER_UNAVAILABLE;
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " pingServer to (" + requestSiteNumber + ")");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
		try
		{
			ClinicalDisplayWebAppConfiguration configuration = getClinicalDisplayConfiguration();
			// if the requested site is DOD or if V2V is allowed, then check for site status
			// if not DOD and V2V not allowed, don't bother checking, just return unavailable
			if(ExchangeUtil.isSiteDOD(requestSiteNumber) || (configuration.getAllowV2V()))
			{
				SiteConnectivityStatus siteStatus = rtr.isSiteAvailable(RoutingTokenHelper.createSiteAppropriateRoutingToken(requestSiteNumber));			
				response = interpreter.transformServerStatusToPingServerResponse(siteStatus);
			}			
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.pingServerEvent() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v5.getStudyImageList() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.pingServerEvent() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("ClinicalDisplayWebservices_v5.pingServerEvent() --> Internal error, unable to retrieve patient studies", mX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.pingServerEvent() --> FAILED routing token format exception with transaction Id [{}]{}", transactionId, rtfX.getMessage());
			transactionContext.setErrorMessage(rtfX.getMessage());
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v4.pingServerEvent() --> Internal error, unable to translate study metadata", rtfX);
		}

        LOGGER.info("ClinicalDisplayWebservices_v5.pingServerEvent() --> Completed with transaction Id [{}] in {} ms", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageClinicalDisplayMetadata#postImageAccessEvent(java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventType)
	 */
	@Override
	public boolean postImageAccessEvent(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageAccessLogEventType logEvent) 
	throws RemoteException 
	{
		setTransactionContext(logEvent.getCredentials(), transactionId);
		TransactionContext transactionContext = TransactionContextFactory.get();
    	long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v5.postImageAccessEvent() --> Start transaction Id [{}]", transactionId);
    	
		try
		{
			transactionContext.setRequestType(getWepAppName() + " postImageAccessEvent [" + logEvent.getEventType() + "]");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			// need to use the Id from the webservice log event since it is the full URN and not just 
			// the individual image identifier
			transactionContext.setUrn(logEvent.getId());
			ImageAccessLogEvent event = interpreter.transformLogEvent(logEvent);
			transactionContext.setPatientID(event.getPatientIcn());
			
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			rtr.logImageAccessEvent(event);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.postImageAccessEvent() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v5.postImageAccessEvent() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.postImageAccessEvent() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("ClinicalDisplayWebservices_v5.postImageAccessEvent() --> Internal error, unable to retrieve patient studies", mX);
		}
		catch(URNFormatException iurnfX) {
            LOGGER.info("ClinicalDisplayWebservices_v5.postImageAccessEvent() --> FAILED URN format exception with transaction Id [{}] after [{}ms]: {}", transactionId, System.currentTimeMillis() - startTime, iurnfX.getMessage());
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v4.postImageAccessEvent() --> Internal error with transaction Id " + transactionId + "]: " + iurnfX.getMessage());
		}

        LOGGER.info("ClinicalDisplayWebservices_v5.postImageAccessEvent() --> Completed with transaction Id [{}] in {} ms", transactionId, System.currentTimeMillis() - startTime);
		
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.ImageClinicalDisplayMetadata#prefetchStudyList(java.lang.String, java.lang.String, java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FilterType, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials)
	 */
	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.PrefetchResponseTypePrefetchResponse prefetchStudyList(
			String transactionId, String siteId, 
			String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.FilterType filter, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials)
	throws RemoteException 
	{
		// TODO Auto-generated method stub
		return null;
	}	

	@Override
	public String remoteMethodPassthrough(
		String transactionId, 
		UserCredentials credentials, 
		String siteId,
		String methodName, 
		RemoteMethodInputParameterType inputParameters) 
	throws RemoteException
	{
		setTransactionContext(credentials, transactionId);
		long startTime = System.currentTimeMillis();
		if(methodName == null)
			throw new RemoteException("ClinicalDisplayWebservices_v5.remoteMethodPassthrough() --> methodName cannot be null.");

        LOGGER.info("ClinicalDisplayWebservices_v5.remoteMethodPassthrough() --> Start transaction Id [{}]", transactionId);
    	
		String response = null;
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " remoteMethodPassthrough method (" + methodName + ")");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
		try
		{
			PassthroughInputMethod inputMethod = interpreter.transformPassthroughMethod(methodName, inputParameters);
			response = rtr.postPassthroughMethod(RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId), inputMethod);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.remoteMethodPassthrough() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v5.remoteMethodPassthrough() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.remoteMethodPassthrough() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("ClinicalDisplayWebservices_v5.remoteMethodPassthrough() --> Internal error, unable to retrieve patient studies", mX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v5.remoteMethodPassthrough() --> FAILED routing token format exception with transaction Id [{}]{}", transactionId, rtfX.getMessage());
			transactionContext.setErrorMessage(rtfX.getMessage());
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v4.remoteMethodPassthrough() --> Internal error, unable to translate study metadata", rtfX);
		}

        LOGGER.info("ClinicalDisplayWebservices_v5.remoteMethodPassthrough() --> Completed with transaction Id [{}] in {} ms", transactionId, System.currentTimeMillis() - startTime);
		
		return response;
	}

	private void setTransactionContext(
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v5.UserCredentials credentials,
			String transactionId)
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		if(transactionId != null)
			transactionContext.setTransactionId(transactionId);
		
		if(credentials != null)
		{
			if( credentials.getFullname() != null )
				transactionContext.setFullName(credentials.getFullname());
			if( credentials.getSiteNumber() != null )
				transactionContext.setSiteNumber(credentials.getSiteNumber());
			if( credentials.getSiteName() != null )
				transactionContext.setSiteName(credentials.getSiteName());
			if( credentials.getSsn() != null )
				transactionContext.setSsn(credentials.getSsn());
			if(credentials.getDuz() != null)
				transactionContext.setDuz(credentials.getDuz());
			if(credentials.getSecurityToken() != null)
				transactionContext.setBrokerSecurityToken(credentials.getSecurityToken());
			transactionContext.setPurposeOfUse(PurposeOfUse.routineMedicalCare.getDescription());
		}		
	}
}
