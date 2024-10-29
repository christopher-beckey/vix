/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 15, 2009
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

import java.math.BigInteger;
import java.rmi.RemoteException;
import java.text.ParseException;
import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.business.PassthroughInputMethod;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.vistarad.ActiveExams;
import gov.va.med.imaging.exchange.business.vistarad.Exam;
import gov.va.med.imaging.exchange.business.vistarad.ExamImages;
import gov.va.med.imaging.exchange.business.vistarad.ExamSite;
import gov.va.med.imaging.exchange.business.vistarad.PatientRegistration;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.translation.AbstractTranslator;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.ImagingFederationContext;
import gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata;
import gov.va.med.imaging.federation.webservices.translation.v3.Translator;
import gov.va.med.imaging.federation.webservices.types.v3.FederationFilterType;
import gov.va.med.imaging.federation.webservices.types.v3.FederationImageAccessLogEventType;
import gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType;
import gov.va.med.imaging.federation.webservices.types.v3.FederationRemoteMethodParameterType;
import gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType;
import gov.va.med.imaging.federation.webservices.types.v3.FederationStudyLoadLevelType;
import gov.va.med.imaging.federation.webservices.types.v3.FederationStudyType;
import gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadActiveExamsType;
import gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamImagesType;
import gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamType;
import gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadPatientRegistrationType;
import gov.va.med.imaging.federation.webservices.types.v3.PatientSensitiveCheckResponseType;
import gov.va.med.imaging.federation.webservices.types.v3.PatientType;
import gov.va.med.imaging.federation.webservices.types.v3.RequestorType;
import gov.va.med.imaging.federation.webservices.types.v3.StudiesType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.webservices.common.WebservicesCommon;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationWebservices_v3 
extends AbstractFederationWebservices
implements ImageFederationMetadata 
{	
	static
	{
		AbstractTranslator.registerTranslatorClass(gov.va.med.imaging.federation.webservices.translation.v3.Translator.class);
	}

	/**
	 * 
	 */
	@Override
	public FederationVistaRadExamType getPatientExam(String transactionId, String studyUrnString) 
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType
	{
        getLogger().info("FederationWebservices_v3.getPatientExam() --> Start, StudyURN [{}], transaction Id [{}]", studyUrnString, transactionId);
		
		setTransactionId(transactionId);
		long startTime = System.currentTimeMillis();
		gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamType response = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " getPatientExam");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn(studyUrnString);
		setVistaRadImagingContext();
		
		FederationRouter router = ImagingFederationContext.getFederationRouter();
		if(router == null)
			throw new RemoteException("FederationWebservices_v3.getPatientExam() --> Internal error: unable to retrieve FederationRouter instance");

		try
		{
			StudyURN studyUrn = URNFactory.create(studyUrnString, SERIALIZATION_FORMAT.PATCH83_VFTP, StudyURN.class);
			transactionContext.setUrn(studyUrn.toString());
			transactionContext.setPatientID(studyUrn.getPatientId());
			Exam exam = router.getExam(studyUrn);
            getLogger().info("FederationWebservices_v3.getPatientExam() --> Transaction Id [{}] got {} exam business object from router.", transactionId, exam == null ? "null" : "not null");
			response = AbstractTranslator.translate(FederationVistaRadExamType.class, exam);
		}
		catch(URNFormatException iurnfX)
		{
			String msg = "FederationWebservices_v3.getPatientExam() --> URNFormatException: Counld NOT get patient exam for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + iurnfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException(msg, iurnfX);
		}	
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getPatientExam() --> ConnectionException: Counld NOT get patient exam for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getPatientExam() --> MethodException: Counld NOT get patient exam for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(TranslationException tX)
		{
			String msg = "FederationWebservices_v3.getPatientExam() --> TranslationException: Counld NOT get patient exam for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + tX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(tX.getClass().getSimpleName());
			throw new RemoteException(msg, tX);
		}
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getPatientExam() --> Generic exception: Counld NOT get patient exam for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}

        getLogger().info("FederationWebservices_v3.getPatientExam() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getNextPatientRegistration(java.lang.String, java.lang.String)
	 */
	@Override
	public FederationVistaRadPatientRegistrationType getNextPatientRegistration(String transactionId, String siteId) 
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
		setTransactionId(transactionId);
        getLogger().info("FederationWebservices_v3.getNextPatientRegistration() --> Start, transaction Id [{}] at site Id [{}]", transactionId, siteId);
		long startTime = System.currentTimeMillis();
		gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadPatientRegistrationType response = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " getNextPatientRegistration");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		setVistaRadImagingContext();
		
		FederationRouter router = ImagingFederationContext.getFederationRouter(); 
		if(router == null)
			throw new RemoteException("FederationWebservices_v3.getNextPatientRegistration() --> Internal error: unable to retrieve FederationRouter instance");

		try
		{
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId);
			PatientRegistration patientRegistration = router.getNextPatientRegistration(routingToken);
            getLogger().info("FederationWebservices_v3.getNextPatientRegistration() --> Transaction Id [{}] got {} patient registration business object from router.", transactionId, patientRegistration == null ? "null" : "not null");
			response = AbstractTranslator.translate(FederationVistaRadPatientRegistrationType.class, patientRegistration);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getNextPatientRegistration() --> ConnectionException: Counld NOT get next patient registration for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getNextPatientRegistration() --> MethodException: Counld NOT get next patient registration for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(TranslationException ex)
		{
			String msg = "FederationWebservices_v3.getNextPatientRegistration() --> TranslationException: Counld NOT get next patient registration for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getNextPatientRegistration() --> Generic exception: Counld NOT get next patient registration for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}

        getLogger().info("FederationWebservices_v3.getNextPatientRegistration() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getRelevantPriorCptCodes(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String[] getRelevantPriorCptCodes(String transactionId, String cptCode, String siteId) 
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.getRelevantPriorCptCodes() --> Start, cpt code [{}], at site Id [{}]", cptCode, siteId);
		
		setTransactionId(transactionId);
		long startTime = System.currentTimeMillis();
		String [] response = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " getRelevantPriorCptCodes");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		setVistaRadImagingContext();
		
		FederationRouter router = ImagingFederationContext.getFederationRouter(); 
		if(router == null)
			throw new RemoteException("FederationWebservices_v3.getRelevantPriorCptCodes() --> Internal error: unable to retrieve FederationRouter instance");

		try
		{
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId);
			response = router.getRelevantPriorCptCodes(routingToken, cptCode);
            getLogger().info("FederationWebservices_v3.getRelevantPriorCptCodes() --> Transaction Id [{}] got [{}] CPT Codes from router.", transactionId, response == null ? 0 : response.length);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getRelevantPriorCptCodes() --> ConnectionException: Counld NOT get cpt codes for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getRelevantPriorCptCodes() --> MethodException: Counld NOT get cpt codes for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getRelevantPriorCptCodes() --> Generic exception: Counld NOT get cpt codes for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}

        getLogger().info("FederationWebservices_v3.getRelevantPriorCptCodes() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.AbstractFederationWebservices#getWepAppName()
	 */
	@Override
	protected String getWepAppName() 
	{
		return "Federation WebApp V3";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.AbstractFederationWebservices#transformSitesToSiteNumberArary(java.util.List)
	 */
	@Override
	protected String[] transformSitesToSiteNumberArray(List<ResolvedArtifactSource> sites) 
	throws RemoteException 
	{
		try
		{
			//gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(sites);
			return AbstractTranslator.translate(String[].class, sites);
		}
		catch(TranslationException ex)
		{
			String msg = "FederationWebservices_v3.transformSitesToSiteNumberArray() --> Translation exception: " + ex.getMessage();
			getLogger().error(msg);
			throw new RemoteException(msg, ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getActiveWorklist(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public FederationVistaRadActiveExamsType getActiveWorklist(String transactionId, String siteId, String listDescriptor)
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.getRelevantPriorCptCodes() --> Start, list descriptor [{}], at site Id [{}]", listDescriptor, siteId);
		
		setTransactionId(transactionId);
		long startTime = System.currentTimeMillis();
		gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadActiveExamsType response = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " getActiveWorklist");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		setVistaRadImagingContext();
		
		FederationRouter router = ImagingFederationContext.getFederationRouter(); 
		if(router == null)
			throw new RemoteException("FederationWebservices_v3.getActiveWorklist() --> Internal error: unable to retrieve FederationRouter instance");

		try
		{
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId);
			ActiveExams activeExams = router.getActiveWorklist(routingToken, listDescriptor);
            getLogger().info("FederationWebservices_v3.getActiveWorklist() --> Transaction Id [{}] got [{}] ActiveExam business object from router.", transactionId, activeExams == null ? 0 : activeExams.size());
			if(activeExams != null)
				transactionContext.setEntriesReturned(activeExams.size());
			response = AbstractTranslator.translate(FederationVistaRadActiveExamsType.class, activeExams);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getActiveWorklist() --> ConnectionException: Counld NOT get active work list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getActiveWorklist() --> MethodException: Counld NOT get active work list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}
		catch(TranslationException ex)
		{
			String msg = "FederationWebservices_v3.getActiveWorklist() --> TranslationException: Counld NOT get active work list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}

		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getActiveWorklist() --> Generic exception: Counld NOT get active work list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}

        getLogger().info("FederationWebservices_v3.getActiveWorklist() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getExamImagesForExam(java.lang.String, java.lang.String)
	 */
	@Override
	public FederationVistaRadExamImagesType getExamImagesForExam(String transactionId, String studyUrnString) 
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.getExamImagesForExam() --> Start, StudyURN [{}], transaction Id [{}]", studyUrnString, transactionId);
		
		setTransactionId(transactionId);
		
		long startTime = System.currentTimeMillis();
		gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamImagesType response = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " getExamImagesForExam");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn(studyUrnString);
		setVistaRadImagingContext();
		
		FederationRouter router = ImagingFederationContext.getFederationRouter(); 
		if(router == null)
			throw new RemoteException("FederationWebservices_v3.getExamImagesForExam() --> Internal error: unable to retrieve FederationRouter instance");

		try
		{
			StudyURN studyUrn = URNFactory.create(studyUrnString, SERIALIZATION_FORMAT.PATCH83_VFTP, StudyURN.class);
			transactionContext.setUrn(studyUrn.toString());
			ExamImages examImages = router.getExamImages(studyUrn);
            getLogger().info("FederationWebservices_v3.getExamImagesForExam() --> Transaction Id [{}] got [{}] ExamImage business object from router.", transactionId, examImages == null ? 0 : examImages.size());
			if(examImages != null)
				transactionContext.setEntriesReturned(examImages.size());
			response = AbstractTranslator.translate(FederationVistaRadExamImagesType.class, examImages);
		}
		catch(URNFormatException iurnfX)
		{
			String msg = "FederationWebservices_v3.getExamImagesForExam() --> URNFormatException: Counld NOT get patient exam for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + iurnfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException(msg, iurnfX);
		}	
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getExamImagesForExam() --> ConnectionException: Counld NOT get patient exam for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getExamImagesForExam() --> MethodException: Counld NOT get patient exam for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(TranslationException tX)
		{
			String msg = "FederationWebservices_v3.getExamImagesForExam() --> TranslationException: Counld NOT get patient exam for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + tX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(tX.getClass().getSimpleName());
			throw new RemoteException(msg, tX);
		}
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getExamImagesForExam() --> Generic exception: Counld NOT get patient exam for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}

        getLogger().info("FederationWebservices_v3.getExamImagesForExam() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;		
	}
	
	private AbstractImagingURN createAbstractImagingUrnFromBase32EncodedUrn(String urn)
	throws MethodException
	{
		try
		{			
			AbstractImagingURN result = URNFactory.create(urn, SERIALIZATION_FORMAT.PATCH83_VFTP, AbstractImagingURN.class);
            getLogger().info("FederationWebservices_v3.createAbstractImagingUrnFromBase32EncodedUrn() --> Converted URN [{}] to [{}]", urn, result.toString());
			return result;
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException(urnfX);
		}		
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getImageDevFields(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String getImageDevFields(String imageUrn, String flags, String transactionId) 
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.getImageDevFields() --> Start, ImageURN [{}], transaction Id [{}]", imageUrn, transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		long startTime = System.currentTimeMillis();
		try
		{				
			AbstractImagingURN urn = createAbstractImagingUrnFromBase32EncodedUrn(imageUrn);
			return getImageDevFieldsInternal(startTime, urn.toString(), flags, transactionId);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getImageDevFields() --> ConnectionException: Counld NOT get image dev fields for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getImageDevFields() --> MethodException: Counld NOT get image dev fields for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getImageDevFields() --> Generic exception: Counld NOT get image dev fields for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getImageInformation(java.lang.String, java.lang.String)
	 */
	@Override
	public String getImageInformation(String imageUrn, String transactionId)
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.getImageInformation() --> Start, ImageURN [{}], transaction Id [{}]", imageUrn, transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		long startTime = System.currentTimeMillis();
		try
		{
			AbstractImagingURN urn = createAbstractImagingUrnFromBase32EncodedUrn(imageUrn);
			return getImageInformationInternal(startTime, urn.toString(), transactionId);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getImageInformation() --> ConnectionException: Counld NOT get image information for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getImageInformation() --> MethodException: Counld NOT get image information for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getImageInformation() --> Generic exception: Counld NOT get image information for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getImageSystemGlobalNode(java.lang.String, java.lang.String)
	 */
	@Override
	public String getImageSystemGlobalNode(String imageUrn, String transactionId)
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.getImageSystemGlobalNode() --> Start, ImageURN [{}], transaction Id [{}]", imageUrn, transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		long startTime = System.currentTimeMillis();
		try
		{
			AbstractImagingURN urn = createAbstractImagingUrnFromBase32EncodedUrn(imageUrn);
			return getImageSystemGlobalNodeInternal(startTime, urn.toString(), transactionId);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getImageSystemGlobalNode() --> ConnectionException: Counld NOT get image system global node for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getImageSystemGlobalNode() --> MethodException: Counld NOT get image system global node for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getImageSystemGlobalNode() --> Generic exception: Counld NOT get image system global node for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getPatientExams(java.lang.String, java.lang.String, java.lang.String, boolean)
	 */
	@Override
	public FederationVistaRadExamType[] getPatientExams(String transactionId, String siteId, String patientIcn,	boolean fullyLoaded)
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.getPatientExams() --> Start, patient Id [{}], transaction Id [{}]", patientIcn, transactionId);
		
		setTransactionId(transactionId);
		long startTime = System.currentTimeMillis();
		gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamType [] response = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " getPatientExams");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		transactionContext.setPatientID(patientIcn);
		setVistaRadImagingContext();
		
		FederationRouter router = ImagingFederationContext.getFederationRouter(); 
		if(router == null)
			throw new RemoteException("FederationWebservices_v3.getPatientExams() --> Internal error: unable to retrieve FederationRouter instance");
		
		try
		{
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId);
			ExamSite examSite = fullyLoaded ? router.getFullyLoadedExamSite(routingToken, patientIcn, false, true) 
											: router.getExamSite(routingToken, patientIcn, false, true);

            getLogger().info("FederationWebservices_v3.getPatientExams() --> Transaction Id [{}] got {} ExamSite business object from router.", transactionId, examSite == null ? "null" : "not null");
			response = AbstractTranslator.translate(FederationVistaRadExamType[].class, examSite);
			transactionContext.setEntriesReturned(response == null ? 0 : response.length);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getPatientExams() --> ConnectionException: Counld NOT get patient exams for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getPatientExams() --> MethodException: Counld NOT get patient exams for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(TranslationException tX)
		{
			String msg = "FederationWebservices_v3.getPatientExams() --> TranslationException: Counld NOT get patient exams for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + tX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(tX.getClass().getSimpleName());
			throw new RemoteException(msg, tX);
		}
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getPatientExams() --> Generic exception: Counld NOT get patient exams for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}

        getLogger().info("FederationWebservices_v3.getPatientExams() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getPatientSensitivityLevel(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public PatientSensitiveCheckResponseType getPatientSensitivityLevel(String transactionId, String siteId, String patientIcn)
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.getPatientSensitivityLevel() --> Start, patient Id [{}], transaction Id [{}]", patientIcn, transactionId);
		
		setTransactionId(transactionId);
		long startTime = System.currentTimeMillis();
		gov.va.med.imaging.federation.webservices.types.v3.PatientSensitiveCheckResponseType response = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " getPatientSensitivityLevel");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		transactionContext.setPatientID(patientIcn);
		
		FederationRouter router = ImagingFederationContext.getFederationRouter(); 
		if(router == null)
			throw new RemoteException("FederationWebservices_v3.getPatientSensitivityLevel() --> Internal error: unable to retrieve FederationRouter instance");
		
		try
		{
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId);
			PatientSensitiveValue sensitiveValue =  router.getPatientSensitiveValue(routingToken, patientIcn);
            getLogger().info("FederationWebservices_v3.getPatientSensitivityLevel() --> Transaction Id [{}] got [{}] PatientSensitiveValue business object from router.", transactionId, sensitiveValue == null ? "null" : "not null");
			response = AbstractTranslator.translate(PatientSensitiveCheckResponseType.class, sensitiveValue);			
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getPatientSensitivityLevel() --> ConnectionException: Counld NOT get patient sensitivity level for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getPatientSensitivityLevel() --> MethodException: Counld NOT get patient sensitivity level for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(TranslationException tX)
		{
			String msg = "FederationWebservices_v3.getPatientSensitivityLevel() --> TranslationException: Counld NOT get patient sensitivity level for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + tX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(tX.getClass().getSimpleName());
			throw new RemoteException(msg, tX);
		}
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getPatientSensitivityLevel() --> Generic exception: Counld NOT get patient sensitivity level for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}

        getLogger().info("FederationWebservices_v3.getPatientSensitivityLevel() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getPatientSitesVisited(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String[] getPatientSitesVisited(String patientIcn, String transactionId, String siteId) 
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.getPatientSitesVisited() --> Start, patient Id [{}], transaction Id [{}]", patientIcn, transactionId);
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		long startTime = System.currentTimeMillis();
		try
		{	
			return getPatientSitesVisitedInternal(startTime, patientIcn, transactionId, siteId);
		
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getPatientSitesVisited() --> ConnectionException: Counld NOT get patient visited sites for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getPatientSitesVisited() --> MethodException: Counld NOT get patient visited sites for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getPatientSitesVisited() --> Generic exception: Counld NOT get patient visited sites for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getPatientStudyList(gov.va.med.imaging.federation.webservices.types.v3.RequestorType, gov.va.med.imaging.federation.webservices.types.v3.FederationFilterType, java.lang.String, java.lang.String, java.lang.String, java.math.BigInteger, gov.va.med.imaging.federation.webservices.types.v3.FederationStudyLoadLevelType)
	 */
	@Override
	public StudiesType getPatientStudyList(RequestorType requestor, 
			FederationFilterType filter, String patientId,
			String transactionId, String siteId,
			BigInteger authorizedSensitivityLevel,
			FederationStudyLoadLevelType studyLoadLevelType)
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.getPatientStudyList() --> Start, patient Id [{}], transaction Id [{}]", patientId, transactionId);
		
		setTransactionId(transactionId);
		Long startTime = System.currentTimeMillis();
		StudyFilter studyFilter = null;
		try
		{
			studyFilter = gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(
					filter, authorizedSensitivityLevel.intValue(), siteId, patientId);
		}
		catch (GlobalArtifactIdentifierFormatException x)
		{
			String msg = "FederationWebservices_v3.getPatientStudyList() --> Couldn't translate: " + x.getMessage(); 
			getLogger().error(msg);
			throw new RemoteException(msg, x);
		}
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() +  " getPatientStudyList");
		transactionContext.setPatientID(patientId);
		transactionContext.setQueryFilter(TransactionContextFactory.getFilterDateRange(studyFilter.getFromDate(), studyFilter.getToDate()));
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		FederationRouter router = ImagingFederationContext.getFederationRouter();
		if(router == null)
			throw new RemoteException("FederationWebservices_v3.getPatientStudyList() --> Internal error: unable to retrieve FederationRouter instance");
		// not sure about this next line... 4/8/08 jmw
		transactionContext.setSiteNumber(requestor.getFacilityId());
		gov.va.med.imaging.federation.webservices.types.v3.StudiesType result = null;
		
		try
		{
			List<Study> studies = null;
			StudyLoadLevel studyLoadLevel = AbstractTranslator.translate(StudyLoadLevel.class, studyLoadLevelType);
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId);
			PatientIdentifier patientIdObj = PatientIdentifier.icnPatientIdentifier(patientId);
			
			if(studyLoadLevel == StudyLoadLevel.STUDY_ONLY)
				studies = router.getPatientShallowStudyList(routingToken, patientIdObj, studyFilter);
			else if(studyLoadLevel == StudyLoadLevel.STUDY_AND_REPORT)
				studies = router.getPatientShallowStudyWithReportList(routingToken, patientIdObj, studyFilter);
			else if(studyLoadLevel == StudyLoadLevel.STUDY_AND_IMAGES)
				studies = router.getPatientStudyWithImagesList(routingToken, patientIdObj, studyFilter);
			else			
				studies = router.getPatientStudyList(routingToken, patientIdObj, studyFilter);
			transactionContext.setEntriesReturned( studies == null ? 0 : studies.size() );

            getLogger().info("FederationWebservices_v2.getPatientStudyList() --> Received [{}] study(ies) from router", studies == null ? 0 : studies.size());
			result = AbstractTranslator.translate(StudiesType.class, studies);
		}
		catch(InsufficientPatientSensitivityException ipsX)
		{
			String msg = "FederationWebservices_v3.getPatientStudyList() --> InsufficientPatientSensitivityException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ipsX.getMessage();
			getLogger().error(msg);			
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ipsX.getClass().getSimpleName());
			try
			{
				result = AbstractTranslator.translate(StudiesType.class, ipsX);
			}
			catch(TranslationException ex)
			{
                getLogger().error("FederationWebservices_v3.getPatientStudyList() --> Translation exception: {}", ex.getMessage());
				transactionContext.setErrorMessage(ex.toString());
				transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
				throw new RemoteException(msg);
			}
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getPatientStudyList() --> MethodException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			throw new RemoteException(msg, mX);
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getPatientStudyList() --> ConnectionException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch (RoutingTokenFormatException rtfX)
		{
			String msg = "FederationWebservices_v3.getPatientStudyList() --> RoutingTokenFormatException: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + rtfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(rtfX.getClass().getSimpleName());
			throw new RemoteException(msg, rtfX);
		}
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getPatientStudyList() --> Generic exception: Counld NOT get patient study list for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}

        getLogger().info("FederationWebservices_v3.getPatientStudyList() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return result;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getStudyFromCprsIdentifier(java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public FederationStudyType getStudyFromCprsIdentifier(String patientId, String transactionId, String siteId, String cprsIdentifier)
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.getStudyFromCprsIdentifier() --> Start, patient Id [{}], transaction Id [{}]", patientId, transactionId);
		
		setTransactionId(transactionId);
		long startTime = System.currentTimeMillis();
		gov.va.med.imaging.federation.webservices.types.v3.FederationStudyType response = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " getStudyFromCprsIdentifier");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		FederationRouter router = ImagingFederationContext.getFederationRouter(); 
		if(router == null)
			throw new RemoteException("FederationWebservices_v3.getStudyFromCprsIdentifier() --> Internal error: unable to retrieve FederationRouter instance");

		try
		{
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId);
			List<Study> studies = router.getStudiesByCprsIdentifier(patientId, routingToken, new CprsIdentifier(cprsIdentifier));
            getLogger().info("FederationWebservices_v3.getStudyFromCprsIdentifier() --> Transaction Id [{}] got [{} Study business object(s) from router.", transactionId, studies == null ? 0 : studies.size());
			response = Translator.translateToStudy(studies);			
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getStudyFromCprsIdentifier() --> ConnectionException: Counld NOT get study from CPRS Id for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getStudyFromCprsIdentifier() --> MethodException: Counld NOT get study from CPRS Id sensitivity level for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(TranslationException tX)
		{
			String msg = "FederationWebservices_v3.getStudyFromCprsIdentifier() --> TranslationException: Counld NOT get study from CPRS Id for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + tX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(tX.getClass().getSimpleName());
			throw new RemoteException(msg, tX);
		}
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getStudyFromCprsIdentifier() --> Generic exception: Counld NOT get study from CPRS Id for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}

        getLogger().info("FederationWebservices_v3.getStudyFromCprsIdentifier() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getVistaRadRadiologyReport(java.lang.String, java.lang.String)
	 */
	@Override
	public String getVistaRadRadiologyReport(String transactionId, String studyUrn) 
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		long startTime = System.currentTimeMillis();
		try
		{			
			StudyURN decodedStudyUrn = URNFactory.create(studyUrn, SERIALIZATION_FORMAT.PATCH83_VFTP, StudyURN.class);
			return getVistaRadRadiologyReportInternal(startTime, transactionId, decodedStudyUrn.toString());
		}
		catch(URNFormatException iurnfX)
		{
			String msg = "FederationWebservices_v3.getVistaRadRadiologyReport() --> URNFormatException: Counld NOT get VistaRad radiology report for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + iurnfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new FederationMethodExceptionFaultType(msg, null);
		}	
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getVistaRadRadiologyReport() --> ConnectionException: Counld NOT get VistaRad radiology report for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getVistaRadRadiologyReport() --> MethodException: Counld NOT get VistaRad radiology report for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getVistaRadRadiologyReport() --> Generic exception: Counld NOT get VistaRad radiology report for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#getVistaRadRequisitionReport(java.lang.String, java.lang.String)
	 */
	@Override
	public String getVistaRadRequisitionReport(String transactionId, String studyUrn) 
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		long startTime = System.currentTimeMillis();
		try
		{			
			StudyURN decodedStudyUrn = URNFactory.create(studyUrn, SERIALIZATION_FORMAT.PATCH83_VFTP, StudyURN.class);
			return getVistaRadRequisitionReportInternal(startTime, transactionId, decodedStudyUrn.toString());
		}
		catch(URNFormatException iurnfX)
		{
			String msg = "FederationWebservices_v3.getVistaRadRequisitionReport() --> URNFormatException: Counld NOT get VistaRad requisition report for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + iurnfX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new FederationMethodExceptionFaultType(msg, null);
		}	

		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.getVistaRadRequisitionReport() --> ConnectionException: Counld NOT get VistaRad requisition report for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.getVistaRadRequisitionReport() --> MethodException: Counld NOT get VistaRad requisition report for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.getVistaRadRequisitionReport() --> Generic exception: Counld NOT get VistaRad requisition report for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#postImageAccessEvent(java.lang.String, gov.va.med.imaging.federation.webservices.types.v3.FederationImageAccessLogEventType)
	 */
	@Override
	public boolean postImageAccessEvent(String transactionId, FederationImageAccessLogEventType logEvent) 
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.postImageAccessEvent() --> Start, transaction Id [{}], log event image Id [{}]", transactionId, logEvent.getImageId());
		
		setTransactionId(transactionId);
    	long startTime = System.currentTimeMillis();
    	TransactionContext transactionContext = TransactionContextFactory.get();

		FederationRouter router = ImagingFederationContext.getFederationRouter();
		if(router == null)
			throw new RemoteException("FederationWebservices_v3.postImageAccessEvent() --> Internal error: unable to retrieve FederationRouter instance");
		
		try
		{
			ImageAccessLogEvent event = AbstractTranslator.translate(ImageAccessLogEvent.class, logEvent);
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
		catch(TranslationException tX)
		{
			String msg = "FederationWebservices_v3.postImageAccessEvent() --> TranslationException: Counld NOT post image access event for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + tX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(tX.getClass().getSimpleName());
			throw new RemoteException(msg, tX);
		}
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.postImageAccessEvent() --> Generic exception: Counld NOT post image access event for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}

        getLogger().info("FederationWebservices_v3.postImageAccessEvent() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#prefetchStudyList(java.lang.String, java.lang.String, java.lang.String, gov.va.med.imaging.federation.webservices.types.v3.FederationFilterType)
	 */
	@Override
	public String prefetchStudyList(String transactionId, String siteId, String patientId, FederationFilterType filter)
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#searchPatients(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public PatientType[] searchPatients(String searchCriteria, String transactionId, String siteId) 
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.searchPatients() --> Start, transaction Id [{}], site Id [{}]", transactionId, siteId);
		
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
				throw new RemoteException("FederationWebservices_v3.searchPatients() --> Internal error: unable to retrieve FederationRouter instance");

			List<Patient> patients = router.getPatientList( searchCriteria, RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId) );
            getLogger().info("FederationWebservices_v3.searchPatients() --> transaction Id [{}] got [{} Patient business object(s) from router.", transactionId, patients == null ? 0 : patients.size());
			gov.va.med.imaging.federation.webservices.types.v3.PatientType[] response = 
				AbstractTranslator.translate(gov.va.med.imaging.federation.webservices.types.v3.PatientType[].class, patients);
			transactionContext.setEntriesReturned( response == null ? 0 : response.length );
            getLogger().info("FederationWebservices_v3.searchPatients() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.searchPatients() --> ConnectionException: Counld NOT search for patients for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.searchPatients() --> MethodException: Counld NOT search for patients for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(TranslationException tX)
		{
			String msg = "FederationWebservices_v3.searchPatients() --> TranslationException: Counld NOT search for patients for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + tX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(tX.getClass().getSimpleName());
			throw new RemoteException(msg, tX);
		}
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.searchPatients() --> Generic exception: Counld NOT search for patients for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#remoteMethodPassthrough(java.lang.String, java.lang.String, java.lang.String, gov.va.med.imaging.federation.webservices.types.v3.FederationRemoteMethodParameterType[], java.lang.String)
	 */
	@Override
	public String remoteMethodPassthrough(String transactionId, String siteId,
			String methodName,
			FederationRemoteMethodParameterType[] parameters,
			String imagingContextType) 
	throws RemoteException, FederationMethodExceptionFaultType, FederationSecurityCredentialsExpiredExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.remoteMethodPassthrough() --> Start, transaction Id [{}], method name [{}]", transactionId, methodName);
		
		setTransactionId(transactionId);
		long startTime = System.currentTimeMillis();

		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			transactionContext.setPatientID("n/a");
			transactionContext.setRequestType(getWepAppName() + " remoteMethodPassthrough method (" + methodName + ")");
			transactionContext.setQueryFilter("n/a");
			transactionContext.setQuality("n/a");
			
			ImagingSecurityContextType securityContext = ImagingSecurityContextType.MAG_WINDOWS;
			
			if((imagingContextType != null) && (imagingContextType.length() > 0))
			{
				securityContext = ImagingSecurityContextType.valueOf(imagingContextType);	
			}
			transactionContext.setImagingSecurityContextType(securityContext.toString());
			
			
			FederationRouter router = ImagingFederationContext.getFederationRouter();
			if(router == null)
				throw new RemoteException("FederationWebservices_v3.searchPatients() --> Internal error: unable to retrieve FederationRouter instance");
			
			PassthroughInputMethod inputMethod = 
				gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(methodName, parameters);			
			String result = router.postPassthroughMethod(RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId),  inputMethod);
            getLogger().info("FederationWebservices_v3.remoteMethodPassthrough() --> transaction Id [{}] got [{} byte(s) back from router.", transactionId, result == null ? 0 : result.length());
			transactionContext.setFacadeBytesSent(result == null ? 0L : result.length());
            getLogger().info("FederationWebservices_v3.remoteMethodPassthrough() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
			return result;
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.remoteMethodPassthrough() --> ConnectionException: Counld NOT do method pass through for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.remoteMethodPassthrough() --> MethodException: Counld NOT do method pass through for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.remoteMethodPassthrough() --> Generic exception: Counld NOT do method pass through for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata#postVistaRadExamAccessEvent(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public boolean postVistaRadExamAccessEvent(String transactionId, String siteId, String inputParameter) 
	throws RemoteException, FederationSecurityCredentialsExpiredExceptionFaultType, FederationMethodExceptionFaultType 
	{
        getLogger().info("FederationWebservices_v3.postVistaRadExamAccessEvent() --> Start, transaction Id [{}], input parameter [{}]", transactionId, inputParameter);
		
		setTransactionId(transactionId);
		long startTime = System.currentTimeMillis();
		boolean response = false;
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType(getWepAppName() + " postVistaRadExamAccessEvent");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		setVistaRadImagingContext();
		
		FederationRouter router = ImagingFederationContext.getFederationRouter();
		if(router == null)
			throw new RemoteException("FederationWebservices_v3.postVistaRadExamAccessEvent() --> Internal error: unable to retrieve FederationRouter instance");
		
		try
		{
			RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId);
			String decodedInputParameter = Translator.translateDecodeExamImageAccessInputParameter(inputParameter);
            getLogger().info("FederationWebservices_v3.postVistaRadExamAccessEvent() --> Converted input parameter [{}] into [{}]", inputParameter, decodedInputParameter);
			response = router.postExamAccessEvent(routingToken, decodedInputParameter);
            getLogger().info("FederationWebservices_v3.postVistaRadExamAccessEvent() --> transaction Id [{}] got [{}] response from logging exam access.", transactionId, response ? "Success" : "Failure");
		}
		catch(ConnectionException cX)
		{
			String msg = "FederationWebservices_v3.postVistaRadExamAccessEvent() --> ConnectionException: Counld NOT post VistARad exam access event for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + cX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException(msg, cX);
		}
		catch(MethodException mX)
		{
			String msg = "FederationWebservices_v3.postVistaRadExamAccessEvent() --> MethodException: Counld NOT post VistARad exam access event for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + mX.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException(msg, mX);
		}		
		catch(Exception ex)
		{
			String msg = "FederationWebservices_v3.postVistaRadExamAccessEvent() --> Generic exception: Counld NOT post VistARad exam access event for transaction Id [" + transactionId + "] after [" + (System.currentTimeMillis() - startTime) + " ms]: " + ex.getMessage();
			getLogger().error(msg);
			transactionContext.setErrorMessage(msg);
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException(msg, ex);
		}

        getLogger().info("FederationWebservices_v3.postVistaRadExamAccessEvent() --> Completed, transaction Id [{}] in [{} ms]", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}
	
	private void handleMethodException(MethodException mX)
	throws FederationSecurityCredentialsExpiredExceptionFaultType  
	{
		try
		{
			WebservicesCommon.throwSecurityCredentialsExceptionFromMethodException(mX);
		}
		catch(SecurityCredentialsExpiredException sceX)
		{
			TransactionContextFactory.get().setExceptionClassName(sceX.getClass().getSimpleName());
			throw new FederationSecurityCredentialsExpiredExceptionFaultType(sceX.getMessage(), "");
		}
	}	
}