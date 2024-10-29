/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 4, 2008
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
import gov.va.med.URNFactory;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.clinicaldisplay.ImagingClinicalDisplayContext;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.PingServerTypeResponse;
import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator;
import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.Requestor.PurposeOfUse;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.rmi.RemoteException;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * @deprecated This version is no longer used - P72 clients can technically use this version but 
 * will always try to use a higher version. Older P72 clients only could use this version but they
 * would not be able to find this interface in the I6 ViX (looking at ImagingExchangeWebApp instead
 * of ClinicalDisplayWebApp).
 * @author VHAISWWERFEJ
 *
 */
public class ClinicalDisplayWebservices 
implements gov.va.med.imaging.clinicaldisplay.webservices.soap.ImageClinicalDisplayMetadata
{
	
	private final static Logger logger = Logger.getLogger(ClinicalDisplayWebservices.class);
	private final static ClinicalDisplayTranslator interpreter = new ClinicalDisplayTranslator();
	
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.ShallowStudyType[] getPatientShallowStudyList(
			java.lang.String transactionId, 
			java.lang.String siteId, 
			java.lang.String patientId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.FilterType filter, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.UserCredentials credentials) 
	throws java.rmi.RemoteException {
		setTransactionContext(credentials, transactionId);
		Long startTime = System.currentTimeMillis();
        logger.info("start ClinicalDisplay getPatientShallowStudyList transaction({})", transactionId);
		TransactionContext transactionContext = TransactionContextFactory.get();
		StudyFilter internalFilter = interpreter.transformFilter(filter);
		// initialize the transaction context
		//TODO: set Request type generically
		transactionContext.setRequestType("getPatientShallowStudyList");
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
		
		// get the message context first
        //MessageContext msgContext = MessageContext.getCurrentContext();
        //HttpServletRequest request = (HttpServletRequest) msgContext.getProperty(HTTPConstants.MC_HTTP_SERVLETREQUEST);
       		
		logger.debug("getPatientShallowStudyList transforming filter into business object.");
		
		ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
		//Router router = ImagingClinicalDisplayContext.getVixRouter();

        logger.debug("getPatientShallowStudyList getting patient studies list from {} type manager instance.", rtr.getClass().getName());
		gov.va.med.imaging.clinicaldisplay.webservices.soap.ShallowStudyType[] result = null;
		
		try 	
		{
			List<Study> studies = rtr.getPatientStudyList(
				RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId), 
				PatientIdentifier.icnPatientIdentifier(patientId), internalFilter);
			// update the transaction context with the study count
			transactionContext.setEntriesReturned( studies == null ? 0 : studies.size() );
			logger.debug("getPatientShallowStudyList transforming results from business objects.");
			result = interpreter.transformStudiesToShallowStudies(studies);
		}
		catch(MethodException mX)
		{
            logger.error("FAILED getPatientShallowStudyList method Exception: {} ms", mX.toString(), mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve patient studies", mX);
		}
		catch(ConnectionException cX)
		{
            logger.error("FAILED getPatientShallowStudyList connection Exception: {} ms", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve patient studies", cX);
		}
		catch(URNFormatException iurnfX)
		{
            logger.error("FAILED getPatientShallowStudyList transaction({}", transactionId, iurnfX);
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate study metadata", iurnfX);
		}	
		catch (RoutingTokenFormatException rtfX)
		{
            logger.error("FAILED getPatientShallowStudyList transaction({}", transactionId, rtfX);
			transactionContext.setErrorMessage(rtfX.getMessage());
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve study metadata", rtfX);
		}
        logger.info("complete ClinicalDisplay getPatientShallowStudyList transaction({}) in {} ms)", transactionId, System.currentTimeMillis() - startTime);
        return result;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.FatImageType[] getStudyImageList(
    		java.lang.String transactionId, 
    		java.lang.String studyId, 
    		gov.va.med.imaging.clinicaldisplay.webservices.soap.UserCredentials credentials) 
    throws java.rmi.RemoteException {
    	setTransactionContext(credentials, transactionId);
    	
    	long startTime = System.currentTimeMillis();
        logger.info("start ClinicalDisplay getStudyImageList transaction({})", transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		StudyURN studyUrn = null;
		List<gov.va.med.imaging.exchange.business.Image> images = null;
		gov.va.med.imaging.clinicaldisplay.webservices.soap.FatImageType[] result = null;
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
		
		transactionContext.setRequestType("getStudyImageList");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		try {
			studyUrn = URNFactory.create(studyId, StudyURN.class);
			
			transactionContext.setUrn(studyId);
			// update the transaction context with patientId
			transactionContext.setPatientID(studyUrn.getPatientId());
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			//Router vixCore = ImagingClinicalDisplayContext.getVixRouter();
			
			Study study = rtr.getPatientStudy(studyUrn);
			transactionContext.setEntriesReturned( study == null ? 0 : study.getImageCount());
			result = interpreter.transformStudyToFatImages(study);
			
			/*
			images = vixCore.getStudyImageList(studyUrn);
			// update the transaction context with the image count
			transactionContext.setEntriesReturned( images == null ? 0 : images.size() );
			result = (gov.va.med.imaging.clinicaldisplay.webservices.soap.FatImageType[])interpreter.transformImagesToFatImages(images);
			*/
		}
		catch (ClassCastException e)
        {
			// the URN.create() can throw a ClassCastException if the string URN has the wrong namespace identifier
			String msg = "'" + studyId + "' is not a valid study identifier (StudyURN).";
			logger.info(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(e.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate study Id", e);
        } 
		catch(URNFormatException iurnfX) {
            logger.info("FAILED getStudyImageList transaction({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, iurnfX);
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable " + ((studyUrn==null) ? "to translate study Id" : "to transform Images"), iurnfX);
		}
		catch(MethodException mX) {
            logger.info("FAILED getStudyImageList method exception ({}) after {} ms", transactionId, System.currentTimeMillis() - startTime, mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve study images", mX);
		}
		catch(ConnectionException cX)
		{
            logger.error("FAILED getPatientShallowStudyList connection Exception: {} ms", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve patient studies", cX);
		}
        logger.info("complete ClinicalDisplay getStudyImageList transaction({}) in {} ms", transactionId, System.currentTimeMillis() - startTime);
		return result;    	
    }

    public boolean postImageAccessEvent(java.lang.String transactionId, 
    		gov.va.med.imaging.clinicaldisplay.webservices.soap.ImageAccessLogEventType logEvent) 
    throws java.rmi.RemoteException {
    	setTransactionContext(logEvent.getCredentials(), transactionId);
    	TransactionContext transactionContext = TransactionContextFactory.get();
    	long startTime = System.currentTimeMillis();
        logger.info("start ClinicalDisplay postImageAccessEvent transaction({})", transactionId);
        logger.info("logEvent message [{}]", logEvent.getReason());
		try
		{
			ImageAccessLogEvent event = interpreter.transformLogEvent(logEvent);
			// not sure if this should be here, what if ICN is empty?			
			transactionContext.setPatientID(event.getPatientIcn());
			transactionContext.setRequestType("postImageAccessEvent");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			// need to use the Id from the webservice log event since it is the full URN and not just 
			// the individual image identifier
			transactionContext.setUrn(logEvent.getImageId());
			ClinicalDisplayRouter rtr = ImagingClinicalDisplayContext.getRouter(); 
			//Router vixCore = ImagingClinicalDisplayContext.getVixRouter();
			rtr.logImageAccessEvent(event);
		}
		catch(ConnectionException cX)
		{
            logger.error("FAILED postImageAccessEvent connection Exception: {} ms", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to post image access", cX);
		}
		catch(MethodException cX)
		{
            logger.error("FAILED postImageAccessEvent method Exception: {} ms", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to post image access", cX);
		}
		catch(URNFormatException iurnfX) 
		{
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			transactionContext.setErrorMessage(iurnfX.getMessage());
            logger.info("FAIlED postImageAccessEvent transaction ({}), unable to translate image Id", transactionId, iurnfX);
			throw new RemoteException("Internal error, unable to translate image Id", iurnfX);
		}
        logger.info("complete ClinicalDisplay postImageAccessEvent transaction({}) in {} ms", transactionId, System.currentTimeMillis() - startTime);
		return true;
    }

    public gov.va.med.imaging.clinicaldisplay.webservices.soap.PingServerTypeResponse pingServerEvent(
    		java.lang.String transactionId, 
    		java.lang.String clientWorkstation, 
    		java.lang.String requestSiteNumber) 
    throws java.rmi.RemoteException {
        logger.info("pingServerEvent from [{}] going to site number [{}]", clientWorkstation, requestSiteNumber);
    	
		IAppConfiguration appConfiguration = ImagingClinicalDisplayContext.getAppConfiguration();
		PingServerTypeResponse response = PingServerTypeResponse.SERVER_UNAVAILABLE;
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("pingServer: " + requestSiteNumber);
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		transactionContext.setTransactionId(transactionId);
		
		// check to see if this request is to the local site
		if(appConfiguration.getLocalSiteNumber().equalsIgnoreCase(requestSiteNumber)) 
		{
				response = PingServerTypeResponse.SERVER_READY;
		}
		else if("200".equalsIgnoreCase(requestSiteNumber))
		{
			response = PingServerTypeResponse.SERVER_READY;
		}

		//TODO: change this to call the router so it can make a better decision on whether or not to allow this connection to go through
		return response;
    }

    public java.lang.String prefetchStudyList(java.lang.String transactionId, java.lang.String siteId, java.lang.String patientId, gov.va.med.imaging.clinicaldisplay.webservices.soap.FilterType filter, gov.va.med.imaging.clinicaldisplay.webservices.soap.UserCredentials credentials) throws java.rmi.RemoteException {
        return null;
    }
    
    private void setTransactionContext(
			gov.va.med.imaging.clinicaldisplay.webservices.soap.UserCredentials credentials,
			String transactionId)
	{
		logger.info(
				"setTransactionContext, id='" + transactionId + 
				"', username='" + credentials == null || credentials.getFullname() == null ? "null" : "" + credentials.getFullname() + 
				"'.");
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
			transactionContext.setPurposeOfUse(PurposeOfUse.routineMedicalCare.getDescription());
		}		
	}
    
    private void setTransactionContext(String transactionId) {
		TransactionContext transactionContext = TransactionContextFactory.get();
		if(transactionId != null) {
			transactionContext.setTransactionId(transactionId);
		}
	}
    
  
}
