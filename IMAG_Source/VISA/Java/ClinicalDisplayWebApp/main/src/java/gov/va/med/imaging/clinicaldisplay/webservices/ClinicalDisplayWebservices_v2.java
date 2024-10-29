/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 20, 2008
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
package gov.va.med.imaging.clinicaldisplay.webservices;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.clinicaldisplay.ImagingClinicalDisplayContext;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FatImageType;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FilterType;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageAccessLogEventType;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageClinicalDisplayMetadata;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.PingServerTypeResponse;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ShallowStudyType;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials;
import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator2;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.Requestor.PurposeOfUse;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.rmi.RemoteException;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ClinicalDisplayWebservices_v2 implements
		ImageClinicalDisplayMetadata {
	
	private final static Logger LOGGER = Logger.getLogger(ClinicalDisplayWebservices_v2.class);
	private final static ClinicalDisplayTranslator2 interpreter = new ClinicalDisplayTranslator2();

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageClinicalDisplayMetadata#getPatientShallowStudyList(java.lang.String, java.lang.String, java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FilterType, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials)
	 */
	@Override
	public ShallowStudyType[] getPatientShallowStudyList(String transactionId,
			String siteId, String patientId, FilterType filter,
			UserCredentials credentials) throws RemoteException {
		
		setTransactionContext(credentials, transactionId);
		Long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v2.getPatientShallowStudyList() --> Start with transaction Id [{}]", transactionId);
		TransactionContext transactionContext = TransactionContextFactory.get();
		StudyFilter internalFilter = interpreter.transformFilter(filter);
		// initialize the transaction context
		//TODO: set Request type generically
		transactionContext.setRequestType(getWepAppName() + " getPatientShallowStudyList");
		transactionContext.setPatientID(patientId);
		transactionContext.setQueryFilter(TransactionContextFactory.getFilterDateRange(internalFilter.getFromDate(), internalFilter.getToDate()));
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		if(ExchangeUtil.isSiteDOD(credentials.getSiteNumber()))
		{
			transactionContext.setRequestingSource("DOD");
		}
		else
		{
			transactionContext.setRequestingSource("VA");
		}
		
		ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 

		gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ShallowStudyType[] result = null;
		
		try 	
		{			
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId);
            LOGGER.info("ClinicalDisplayWebservices_v2.getPatientShallowStudyList() --> Routing to site [{}]", routingToken.toRoutingTokenString());
			// must call patient artifact command in order to get all studies if calling a VA site with patch 104 installed (since study graph SPI now only returns radiology data)
			ArtifactResults artifactResults = rtr.getStudyWithReportArtifactResultsForPatientFromSite(
					routingToken, 
					PatientIdentifier.icnPatientIdentifier(patientId),
					internalFilter, true, false);
			
			// update the transaction context with the study count
			transactionContext.setEntriesReturned( artifactResults == null ? 0 : artifactResults.getArtifactSize() );

			// Transform into business object
			result = interpreter.transformStudiesToShallowStudies(artifactResults);
		}
		catch(MethodException mX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getPatientShallowStudyList() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getPatientShallowStudyList() --> Internal error, unable to retrieve patient studies", mX);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getPatientShallowStudyList() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getPatientShallowStudyList() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(URNFormatException iurnfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getPatientShallowStudyList() --> FAILED URN format exception with transaction Id [{}]: {}", transactionId, iurnfX.getMessage());
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getPatientShallowStudyList() --> Internal error, unable to translate study metadata", iurnfX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getPatientShallowStudyList() --> FAILED routing token format exception with transaction Id [{}]{}", transactionId, rtfX.getMessage());
			transactionContext.setErrorMessage(rtfX.getMessage());
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getPatientShallowStudyList() --> Internal error, unable to translate study metadata", rtfX);
		}

		if( LOGGER.isDebugEnabled() )
		{
			StringBuilder sb = new StringBuilder();
			
			sb.append("ClinicalDisplayWebservices_v2.getPatientShallowStudyList() --> Returning " + (result == null ? "<null>" : result.length) + " study IDs: \n");
			
			for(int studyIndex = 0; result != null && studyIndex < result.length; ++studyIndex)
			{
				sb.append("  - " + result[studyIndex].getStudyId());
				if( result[studyIndex].getFirstImage() != null )
					sb.append(" - " + result[studyIndex].getFirstImage().getImageId());
				sb.append(" \n");
			}
			LOGGER.debug(sb.toString());
		}

        LOGGER.info("ClinicalDisplayWebservices_v2.getPatientShallowStudyList() --> Completed with transaction Id [{}] in {} ms)", transactionId, System.currentTimeMillis() - startTime);
		
        return result;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageClinicalDisplayMetadata#getStudyImageList(java.lang.String, java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials)
	 */
	@Override
	public FatImageType[] getStudyImageList(
		String transactionId,
		String studyId, 
		UserCredentials credentials) 
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
    	
    	long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v2.getStudyImageList() --> Start with transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		StudyURN studyUrn = null;
		String patientIdentifier = null;
		gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FatImageType[] result = null;
		// initialize the transaction context
		//TODO: set Request type generically
		
		if(ExchangeUtil.isSiteDOD(credentials.getSiteNumber()))
		{
			transactionContext.setRequestingSource("DOD");
		}
		else
		{
			transactionContext.setRequestingSource("VA");
		}
		
		transactionContext.setRequestType(getWepAppName() + " getStudyImageList");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		try 
		{
			studyUrn = URNFactory.create(studyId, SERIALIZATION_FORMAT.CDTP, StudyURN.class);
			patientIdentifier = studyUrn.getPatientId();
			
			transactionContext.setUrn(studyUrn.toString());
			// update the transaction context with patientId
			transactionContext.setPatientID(patientIdentifier);
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			//Router vixCore = ImagingClinicalDisplayContext.getVixRouter();
			
			Study study = rtr.getPatientStudy( (StudyURN)studyUrn );
			
			transactionContext.setEntriesReturned( study == null ? 0 : study.getImageCount());
			result = interpreter.transformStudyToFatImages(study);
		}
		catch(URNFormatException iurnfX) {
            LOGGER.info("ClinicalDisplayWebservices_v2.getStudyImageList() --> FAILED URN format exception with transaction Id [{}] after [{}ms]: {}", transactionId, System.currentTimeMillis() - startTime, iurnfX.getMessage());
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudyImageList() --> Internal error, unable " + ((studyUrn==null) ? "to translate study Id" : "to transform Images"), iurnfX);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudyImageList() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudyImageList() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX) {
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudyImageList() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudyImageList() --> Internal error, unable to retrieve study images", mX);
		}
        LOGGER.info("ClinicalDisplayWebservices_v2.getStudyImageList() --> Completed with transaction Id [{}] in {} ms", transactionId, System.currentTimeMillis() - startTime);
		return result;   
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageClinicalDisplayMetadata#pingServerEvent(java.lang.String, java.lang.String, java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials)
	 */
	@Override
	public PingServerTypeResponse pingServerEvent(String transactionId,
			String clientWorkstation, String requestSiteNumber, UserCredentials credentials) 
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
        LOGGER.info("ClinicalDisplayWebservices_v2.pingServerEvent() --> From [{}] going to site number [{}]", clientWorkstation, requestSiteNumber);
    	
		PingServerTypeResponse response = PingServerTypeResponse.SERVER_UNAVAILABLE;
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " pingServer to (" + requestSiteNumber + ")");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		transactionContext.setRequestingSource(credentials.getSiteNumber());
		
		// JMW 9/8/2008 - version 2 of the interface is now only for viewing DOD images for patch 72
		// Use version 3 for viewing VA images through Federation (Clin Display Patch 93)
		if(ExchangeUtil.isSiteDOD(requestSiteNumber))
		{
			response = PingServerTypeResponse.SERVER_READY;
		}

		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageClinicalDisplayMetadata#postImageAccessEvent(java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageAccessLogEventType)
	 */
	@Override
	public boolean postImageAccessEvent(String transactionId,
			ImageAccessLogEventType logEvent) 
	throws RemoteException 
	{
		setTransactionContext(logEvent.getCredentials(), transactionId);
		TransactionContext transactionContext = TransactionContextFactory.get();
    	long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v2.postImageAccessEvent() --> Start transaction Id [{}]", transactionId);
		
		try
		{	
			transactionContext.setRequestType(getWepAppName() + " postImageAccessEvent [" + logEvent.getEventType() + "]");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			// need to use the Id from the webservice log event since it is the full URN and not just 
			// the individual image identifier
			transactionContext.setUrn(logEvent.getImageId());
			ImageAccessLogEvent event = interpreter.transformLogEvent(logEvent);
			transactionContext.setPatientID(event.getPatientIcn());
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			//Router vixCore = ImagingClinicalDisplayContext.getVixRouter();
			rtr.logImageAccessEvent(event);
		}
		catch(URNFormatException iurnfX) {
            LOGGER.info("ClinicalDisplayWebservices_v2.postImageAccessEvent() --> FAILED URN format exception with transaction Id [{}] after [{}ms]: {}", transactionId, System.currentTimeMillis() - startTime, iurnfX.getMessage());
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.postImageAccessEvent() --> Internal error with transaction Id " + transactionId + "]: " + iurnfX.getMessage());
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.postImageAccessEvent() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.postImageAccessEvent() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX) {
            LOGGER.error("ClinicalDisplayWebservices_v2.postImageAccessEvent() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.postImageAccessEvent() --> Internal error, unable to retrieve study images", mX);
		}
        LOGGER.info("ClinicalDisplayWebservices_v2.postImageAccessEvent() --> Completed with transaction Id [{}] in {} ms", transactionId, System.currentTimeMillis() - startTime);
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.ImageClinicalDisplayMetadata#prefetchStudyList(java.lang.String, java.lang.String, java.lang.String, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.FilterType, gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials)
	 */
	@Override
	public String prefetchStudyList(String transactionId, String siteId, String patientId, 
			FilterType filter, UserCredentials credentials)
	throws RemoteException 
	{
		// TODO Auto-generated method stub
		return null;
	}
	
	
	@Override
	public String getImageInformation(String imageId, String transactionId,
			UserCredentials credentials) 
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
		long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v2.getImageInformation() --> Start with transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		ImageURN imageUrn = null;
		try{
			imageUrn = URNFactory.create(imageId, SERIALIZATION_FORMAT.CDTP, ImageURN.class);
			transactionContext.setPatientID(imageUrn.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " getImageInformation");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(imageUrn.toString());
			transactionContext.setRequestingSource(transactionContext.getSiteNumber());
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			//Router vixCore = ImagingClinicalDisplayContext.getVixRouter();
			String response = rtr.getImageInformation(imageUrn);
            LOGGER.info("ClinicalDisplayWebservices_v2.getImageInformation() --> Completed with transaction Id [{}] in {} ms", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}
		catch (ClassCastException e)
        {
			String msg = "ClinicalDisplayWebservices_v2.getImageInformation() --> Image Id [" + imageId + "] is not a valid image identifier (ImageURN): " + e.getMessage();
			LOGGER.error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(e.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageInformation() --> Internal error, unable to translate image Id", e);
        } 
		catch(URNFormatException iurnfX)
		{
            LOGGER.info("ClinicalDisplayWebservices_v2.getImageInformation() --> Unable to translate image Id [{}]: {}", imageId, iurnfX.getMessage());
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageInformation() --> Internal error, unable to translate image Id [" + imageId + "]", iurnfX);
		}
		catch(ImageNotFoundException infX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getImageInformation() --> Unable to find image for image Id [{}] after {} ms: {}", imageId, System.currentTimeMillis() - startTime, infX.getMessage());
			transactionContext.setErrorMessage(infX.getMessage());
			transactionContext.setExceptionClassName(infX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageInformation() --> Internal error, unable to retrieve image information", infX);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getImageInformation() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageInformation() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX) {
            LOGGER.error("ClinicalDisplayWebservices_v2.getImageInformation() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageInformation() --> Internal error, unable to retrieve study images", mX);
		}
	}

	@Override
	public String getStudyImageInformation(String studyId, String transactionId, 
			UserCredentials credentials)
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
		long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v2.getStudyImageInformation() --> Start with transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		StudyURN studyUrn = null;
		try{
			studyUrn = URNFactory.create(studyId, SERIALIZATION_FORMAT.CDTP, StudyURN.class);
			transactionContext.setPatientID(studyUrn.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " getStudyImageInformation");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(studyUrn.toString());
			transactionContext.setRequestingSource(transactionContext.getSiteNumber());
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			//Router vixCore = ImagingClinicalDisplayContext.getVixRouter();
			String response = rtr.getImageInformation(studyUrn);
            LOGGER.info("ClinicalDisplayWebservices_v2.getStudyImageInformation() --> Completed with transaction Id [{}] in {} ms", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}
		catch (ClassCastException e)
        {
			// the URN.create() can throw a ClassCastException if the string URN has the wrong namespace identifier
			String msg = "ClinicalDisplayWebservices_v2.getStudyImageInformation() --> study Id [" + studyId + "] is not a valid study identifier (StudyURN).";
            LOGGER.error("{} {}", msg, e.getMessage());
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(e.getClass().getSimpleName());
			throw new RemoteException(msg, e);
        } 
		catch(URNFormatException iurnfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudyImageInformation() --> Unable to translate study Id [{}]: {}", studyId, iurnfX.getMessage());
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudyImageInformation() --> Internal error, unable to translate study Id [" + studyId + "]", iurnfX);
		}
		catch(ImageNotFoundException infX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudyImageInformation() --> Unable to find image for study Id [{}] after {} ms: {}", studyId, System.currentTimeMillis() - startTime, infX.getMessage());
			transactionContext.setErrorMessage(infX.getMessage());
			transactionContext.setExceptionClassName(infX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudyImageInformation() --> Internal error, unable to retrieve image information", infX);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudyImageInformation() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudyImageInformation() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX) {
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudyImageInformation() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudyImageInformation() --> Internal error, unable to retrieve study images", mX);
		}
	}

	@Override
	public String getImageSystemGlobalNode(String imageId, String transactionId, 
		UserCredentials credentials)
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
		long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v2.getImageSystemGlobalNode() --> Start with transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		ImageURN imageUrn = null;
		try{
			imageUrn = URNFactory.create(imageId, SERIALIZATION_FORMAT.CDTP, ImageURN.class);
			transactionContext.setPatientID(imageUrn.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " getImageSystemGlobalNode");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(imageUrn.toString());
			transactionContext.setRequestingSource(transactionContext.getSiteNumber());
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			//Router vixCore = ImagingClinicalDisplayContext.getVixRouter();
			String response = rtr.getImageSystemGlobalNode(imageUrn);
            LOGGER.info("ClinicalDisplayWebservices_v2.getImageSystemGlobalNode() --> Completed with transaction Id [{}] in {} ms", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}
		catch (ClassCastException e)
        {
			String msg = "ClinicalDisplayWebservices_v2.getImageSystemGlobalNode() --> image Id [" + imageId + "] is not a valid study identifier (ImageURN).";
            LOGGER.error("{} {}", msg, e.getMessage());
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(e.getClass().getSimpleName());
			throw new RemoteException(msg, e);
        } 
		catch(URNFormatException iurnfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getImageSystemGlobalNode() --> Unable to translate study Id [{}]: {}", imageId, iurnfX.getMessage());
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageSystemGlobalNode() --> Internal error, unable to translate study Id [" + imageId + "]", iurnfX);
		}
		catch(ImageNotFoundException infX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getImageSystemGlobalNode() --> Unable to find image for study Id [{}] after {} ms: {}", imageId, System.currentTimeMillis() - startTime, infX.getMessage());
			transactionContext.setErrorMessage(infX.getMessage());
			transactionContext.setExceptionClassName(infX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageSystemGlobalNode() --> Internal error, unable to retrieve image information", infX);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getImageSystemGlobalNode() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageSystemGlobalNode() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX) {
            LOGGER.error("ClinicalDisplayWebservices_v2.getImageSystemGlobalNode() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageSystemGlobalNode() --> Internal error, unable to retrieve study images", mX);
		}
	}

	@Override
	public String getStudySystemGlobalNode(String studyId, String transactionId, 
		UserCredentials credentials)
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
		long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v2.getStudySystemGlobalNode() --> Start with transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		AbstractImagingURN urn = null;
		try
		{
			urn = URNFactory.create(studyId, SERIALIZATION_FORMAT.CDTP, AbstractImagingURN.class);
			transactionContext.setPatientID(urn.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " getStudySystemGlobalNode");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(urn.toString());
			transactionContext.setRequestingSource(transactionContext.getSiteNumber());
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			//Router vixCore = ImagingClinicalDisplayContext.getVixRouter();
			String response = rtr.getImageSystemGlobalNode(urn);
            LOGGER.info("ClinicalDisplayWebservices_v2.getStudySystemGlobalNode() --> Completed with transaction Id [{}] in {} ms", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}
		catch (ClassCastException e)
        {
			// the URN.create() can throw a ClassCastException if the string URN has the wrong namespace identifier
			String msg = "ClinicalDisplayWebservices_v2.getStudySystemGlobalNode() --> study Id [" + studyId + "] is not a valid study identifier (ImageURN).";
            LOGGER.error("{} {}", msg, e.getMessage());
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(e.getClass().getSimpleName());
			throw new RemoteException(msg, e);
        } 
		catch(URNFormatException iurnfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudySystemGlobalNode() --> Unable to translate study Id [{}]: {}", studyId, iurnfX.getMessage());
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudySystemGlobalNode() --> Internal error, unable to translate study Id [" + studyId + "]", iurnfX);
		}
		catch(ImageNotFoundException infX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudySystemGlobalNode() --> Unable to find image for study Id [{}] after {} ms: {}", studyId, System.currentTimeMillis() - startTime, infX.getMessage());
			transactionContext.setErrorMessage(infX.getMessage());
			transactionContext.setExceptionClassName(infX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudySystemGlobalNode() --> Internal error, unable to retrieve image information", infX);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudySystemGlobalNode() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudySystemGlobalNode() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX) {
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudySystemGlobalNode() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudySystemGlobalNode() --> Internal error, unable to retrieve study images", mX);
		}
	}

	@Override
	public String getImageDevFields(String imageId, String flags, String transactionId, 
			UserCredentials credentials)
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
		long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v2.getImageDevFields() --> Start with transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		ImageURN imageUrn = null;
		try{
			imageUrn = URNFactory.create(imageId, SERIALIZATION_FORMAT.CDTP, ImageURN.class);
			transactionContext.setPatientID(imageUrn.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " getImageDevFields");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(imageUrn.toString());
			transactionContext.setRequestingSource(transactionContext.getSiteNumber());
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			//Router vixCore = ImagingClinicalDisplayContext.getVixRouter();
			String response = rtr.getImageDevFields(imageUrn, flags);
            LOGGER.info("ClinicalDisplayWebservices_v2.getImageDevFields() --> Completed with transaction Id [{}] in {} ms", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}
		catch (ClassCastException e)
        {
			String msg = "ClinicalDisplayWebservices_v2.getImageDevFields() --> image Id [" + imageId + "] is not a valid study identifier (ImageURN).";
            LOGGER.error("{} {}", msg, e.getMessage());
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(e.getClass().getSimpleName());
			throw new RemoteException(msg, e);
        } 
		catch(URNFormatException iurnfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getImageDevFields() --> Unable to translate study Id [{}]: {}", imageId, iurnfX.getMessage());
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageDevFields() --> Internal error, unable to translate study Id [" + imageId + "]", iurnfX);
		}
		catch(ImageNotFoundException infX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getImageDevFields() --> Unable to find image for study Id [{}] after {} ms: {}", imageId, System.currentTimeMillis() - startTime, infX.getMessage());
			transactionContext.setErrorMessage(infX.getMessage());
			transactionContext.setExceptionClassName(infX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageDevFields() --> Internal error, unable to retrieve image information", infX);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getImageDevFields() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageDevFields() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX) {
            LOGGER.error("ClinicalDisplayWebservices_v2.getImageDevFields() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getImageDevFields() --> Internal error, unable to retrieve study images", mX);
		}
	}

	@Override
	public String getStudyDevFields(String studyId, String flags, String transactionId, 
			UserCredentials credentials)
	throws RemoteException 
	{
		setTransactionContext(credentials, transactionId);
		long startTime = System.currentTimeMillis();
        LOGGER.info("ClinicalDisplayWebservices_v2.getStudyDevFields() --> Start with transaction Id [{}]", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		AbstractImagingURN urn = null;
		try{
			urn = URNFactory.create(studyId, SERIALIZATION_FORMAT.CDTP, AbstractImagingURN.class);
			transactionContext.setPatientID(urn.getPatientId());
			transactionContext.setRequestType(getWepAppName() + " getStudyDevFields");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			transactionContext.setUrn(urn.toString());
			transactionContext.setRequestingSource(transactionContext.getSiteNumber());
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			//Router vixCore = ImagingClinicalDisplayContext.getVixRouter();
			String response = rtr.getImageDevFields(urn, flags);
            LOGGER.info("ClinicalDisplayWebservices_v2.getStudyDevFields() --> Completed with transaction Id [{}] in {} ms", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}
		catch(URNFormatException iurnfX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudyDevFields() --> Unable to translate study Id [{}]: {}", studyId, iurnfX.getMessage());
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudyDevFields() --> Internal error, unable to translate study Id [" + studyId + "]", iurnfX);
		}
		catch(ImageNotFoundException infX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudyDevFields() --> Unable to find image for study Id [{}] after {} ms: {}", studyId, System.currentTimeMillis() - startTime, infX.getMessage());
			transactionContext.setErrorMessage(infX.getMessage());
			transactionContext.setExceptionClassName(infX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudyDevFields() --> Internal error, unable to retrieve image information", infX);
		}
		catch(ConnectionException cX)
		{
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudyDevFields() --> FAILED connection exception: {}", cX.getMessage());
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudyDevFields() --> Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX) {
            LOGGER.error("ClinicalDisplayWebservices_v2.getStudyDevFields() --> FAILED method exception: {}", mX.getMessage());
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException("ClinicalDisplayWebservices_v2.getStudyDevFields() --> Internal error, unable to retrieve study images", mX);
		}
	}

	private void setTransactionContext(
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v2.UserCredentials credentials,
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
			if( credentials.getDuz() != null )
				transactionContext.setPurposeOfUse(credentials.getDuz());
			if( credentials.getSsn() != null )
				transactionContext.setSsn(credentials.getSsn());
			if(credentials.getDuz() != null)
				transactionContext.setDuz(credentials.getDuz());
			transactionContext.setPurposeOfUse(PurposeOfUse.routineMedicalCare.getDescription());
		}
	}
	
	private String getWepAppName()
	{
		return "Clinical Display WebApp V2";
	}
}
