/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 13, 2009
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
package gov.va.med.imaging.vistarad.webservices;

import gov.va.med.RoutingToken;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.PassthroughInputMethod;
import gov.va.med.imaging.exchange.business.Requestor.PurposeOfUse;
import gov.va.med.imaging.exchange.business.vistarad.ActiveExams;
import gov.va.med.imaging.exchange.business.vistarad.Exam;
import gov.va.med.imaging.exchange.business.vistarad.ExamSite;
import gov.va.med.imaging.exchange.business.vistarad.ExamSiteCachedStatus;
import gov.va.med.imaging.exchange.business.vistarad.PatientEnterpriseExams;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.exchange.enums.SiteConnectivityStatus;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.vistarad.ImagingVistaRadContext;
import gov.va.med.imaging.vistarad.VistaRadRouter;
import gov.va.med.imaging.vistarad.webservices.exceptions.VistaRadSocketTimeoutException;
import gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType;
import gov.va.med.imaging.vistarad.webservices.translator.VistaRadTranslator;
import gov.va.med.imaging.webservices.common.WebservicesCommon;

import java.rmi.RemoteException;
import java.util.List;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class VistaRadWebServices
implements gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata
{
	private final static Logger logger = Logger.getLogger(VistaRadWebServices.class);	
			
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata#getSiteExamList(java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials, java.lang.String, java.lang.String, boolean)
	 */
	@Override
	public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite 
		getSiteExamList(String transactionId, 
			gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials,
			String patientIcn, String siteId, boolean forceRefresh)
	throws RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType
	{
		setTransactionContext(credentials, transactionId);
		Long startTime = System.currentTimeMillis();
        logger.info("start getSiteExamList transaction({})", transactionId);
		VistaRadRouter router = ImagingVistaRadContext.getVistaRadRouter();
		if(router == null)
			throw new RemoteException("Internal error, unable to retrieve site exams");					
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("VistARad WebApp getSiteExamList");							
		transactionContext.setQuality("n/a");
		transactionContext.setQueryFilter("n/a");
		try
		{			
			transactionContext.setPatientID(patientIcn);
			transactionContext.setUrn("n/a");	
			ExamSite examSite = router.getExamSiteBySiteNumber(
					RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId), 
				patientIcn, 
				forceRefresh,
				true);								
			gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite result = 
				VistaRadTranslator.transformExamSite(examSite);						
			transactionContext.setEntriesReturned(result == null ? 0 : (result.getExam() == null ? 0 : result.getExam().length));
            logger.info("SUCCESS getSiteExamList transaction({}) in {} ms)", transactionId, System.currentTimeMillis() - startTime);
            logger.info("Found exam site with '{}", examSite == null ? "<null exam site>" : "" + (examSite == null ? "<null exams>" : "" + examSite.size()) + "' exams.");
			return result;
		}
		catch(URNFormatException iurnfX)
		{
            logger.error("FAILED getSiteExamList transaction({}", transactionId, iurnfX);
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate exam metadata", iurnfX);
		}		
		catch(ConnectionException cX)
		{
            logger.error("FAILED getSiteExamList connection Exception: {}", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve patient site exams", cX);
		}
		catch(MethodException mX)
		{
            logger.error("FAILED getSiteExamList method Exception: {}", mX.toString(), mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve patient site exams", mX);
		}
		catch(VistaRadSocketTimeoutException vrstX)
		{
            logger.error("FAILED getSiteExamList VistaRadSocketTimeoutException: {}", vrstX.toString(), vrstX);
			transactionContext.setErrorMessage(vrstX.getMessage());
			transactionContext.setExceptionClassName(vrstX.getClass().getSimpleName());
			// don't need to call handleMethodException since not a BSE related error
			// need to ensure this is the error message for VistARad to pick it up
			// confirmed with Paul P. that VistARad looks for 'SocketTimeoutException' in error message
			throw new RemoteException("java.net.SocketTimeoutException: Read timed out");
		}
		catch(Exception ex)
		{
            logger.error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata#getActiveWorklist(java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType getActiveWorklist(
			String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials,
			String siteNumber, String userDivision, String listDescriptor)
	throws RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType 
	{
		setTransactionContext(credentials, transactionId);
		Long startTime = System.currentTimeMillis();
        logger.info("start getActiveWorklist transaction({})", transactionId);
		VistaRadRouter router = ImagingVistaRadContext.getVistaRadRouter();
		if(router == null)
			throw new RemoteException("Internal error, unable to retrieve active exams worklist");
					
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("VistARad WebApp getActiveWorklist");	
		if((userDivision != null) && (userDivision.length() > 0))		
			transactionContext.setUserDivision(userDivision);
				
		transactionContext.setQuality("n/a");
		transactionContext.setQueryFilter("n/a");
		try
		{			
			transactionContext.setPatientID("n/a");
			transactionContext.setUrn("n/a");	
			ActiveExams activeExams = router.getActiveExamsWorklist(RoutingTokenHelper.createSiteAppropriateRoutingToken(siteNumber), listDescriptor);		
			
			gov.va.med.imaging.vistarad.webservices.soap.v1.GetActiveWorklistResponseContentsType result = 
				VistaRadTranslator.transformActiveExams(activeExams);
			//transactionContext.setFacadeBytesSent(new Long(activeExamsString.length()));
			transactionContext.setEntriesReturned( activeExams == null ? 0 : activeExams.size() );
            logger.info("SUCCESS getActiveWorklist transaction({}) in {} ms)", transactionId, System.currentTimeMillis() - startTime);
			return result;
		}
		catch(ConnectionException cX)
		{
            logger.error("FAILED getActiveWorklist connection Exception: {}", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve active exams worklist", cX);
		}
		catch(MethodException mX)
		{
            logger.error("FAILED getActiveWorklist method Exception: {}", mX.toString(), mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve active exams worklist", mX);
		}
		catch(URNFormatException urnfX)
		{
            logger.error("FAILED getActiveWorklist transaction({}", transactionId, urnfX);
			transactionContext.setErrorMessage(urnfX.getMessage());
			transactionContext.setExceptionClassName(urnfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate active exams worklist", urnfX);
		}
		catch(Exception ex)
		{
            logger.error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata#getEnterpriseExamList(java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials, java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.FilterType)
	 */
	@Override
	public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite[] getEnterpriseExamList(String transactionId,
			gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, 
			String patientIcn)
	throws RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType 
	{
		setTransactionContext(credentials, transactionId);
		Long startTime = System.currentTimeMillis();
        logger.info("start getEnterpriseExamList transaction({})", transactionId);
		VistaRadRouter router = ImagingVistaRadContext.getVistaRadRouter();
		if(router == null)
			throw new RemoteException("Internal error, unable to retrieve patient studies");
		
		//VistaRadFilter examFilter = VistaRadTranslator.transformFilter();		
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("VistARad WebApp getEnterpriseExamList");			
		transactionContext.setPatientID(patientIcn);
		transactionContext.setQueryFilter("n/a");//TransactionContextFactory.getFilterDateRange(examFilter.getFromDate(), examFilter.getToDate()));		
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		try
		{
			if(true)
				throw new MethodException("Method is not available - you should know better!");
			PatientEnterpriseExams exams = router.getPatientEnterpriseExams(RoutingTokenHelper.createSiteAppropriateRoutingToken(RoutingToken.ROUTING_WILDCARD), patientIcn, false);
			gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSite[] examSiteTypes = 
				VistaRadTranslator.transformPatientEnterpriseExams(exams);
						
			transactionContext.setEntriesReturned( examSiteTypes == null ? 0 : examSiteTypes.length );
            logger.info("SUCCESS getEnterpriseExamList transaction({}) in {} ms)", transactionId, System.currentTimeMillis() - startTime);
			return examSiteTypes;
			
		}
		catch(ConnectionException cX)
		{
            logger.error("FAILED getEnterpriseExamList connection Exception: {}", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve patient exams", cX);
		}
		catch(MethodException mX)
		{
            logger.error("FAILED getEnterpriseExamList method Exception: {}", mX.toString(), mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve patient exams", mX);
		}
		catch(URNFormatException iurnfX)
		{
            logger.error("FAILED getEnterpriseExamList transaction({}", transactionId, iurnfX);
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate exam metadata", iurnfX);
		}
		catch(Exception ex)
		{
            logger.error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata#getExamDetails(java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials, java.lang.String)
	 */
	@Override
	public gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType getExamDetails(String transactionId,
			gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, String examId) 
	throws RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType 
	{
		setTransactionContext(credentials, transactionId);
		Long startTime = System.currentTimeMillis();
        logger.info("start getExamDetails transaction({})", transactionId);
		VistaRadRouter router = ImagingVistaRadContext.getVistaRadRouter();
		if(router == null)
			throw new RemoteException("Internal error, unable to retrieve patient studies");
					
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("VistARad WebApp getExamDetails");			
				
		transactionContext.setQuality("n/a");
		transactionContext.setQueryFilter("n/a");
		try
		{
			StudyURN studyUrn = URNFactory.create(examId, SERIALIZATION_FORMAT.CDTP, StudyURN.class);
			transactionContext.setPatientID(studyUrn.getPatientId());
			transactionContext.setUrn(examId);
			
			Exam exam = router.getExam(studyUrn);//  createExam(1);		
			gov.va.med.imaging.vistarad.webservices.soap.v1.FatExamType examType =  
				VistaRadTranslator.transformExamToFatExam(exam);
			transactionContext.setEntriesReturned( examType == null ? 0 : 1 );
            logger.info("SUCCESS getExamDetails transaction({}) in {} ms)", transactionId, System.currentTimeMillis() - startTime);
			return examType;
		}
		catch(ConnectionException cX)
		{
            logger.error("FAILED getExamDetails connection Exception: {}", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve exam details", cX);
		}
		catch(MethodException mX)
		{
            logger.error("FAILED getExamDetails method Exception: {}", mX.toString(), mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve exam details", mX);
		}
		catch(URNFormatException iurnfX)
		{
            logger.error("FAILED getExamDetails transaction({}", transactionId, iurnfX);
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate exam details", iurnfX);
		}	
		catch(Exception ex)
		{
            logger.error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata#getReport(java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials, java.lang.String)
	 */
	@Override
	public String getReport(String transactionId, 
		gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, String examId) 
	throws RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType 
	{
		setTransactionContext(credentials, transactionId);
		Long startTime = System.currentTimeMillis();
        logger.info("start getReport transaction({})", transactionId);
		VistaRadRouter router = ImagingVistaRadContext.getVistaRadRouter();
		if(router == null)
			throw new RemoteException("Internal error, unable to retrieve exam report");
					
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("VistARad WebApp getReport");			
				
		transactionContext.setQuality("n/a");
		transactionContext.setQueryFilter("n/a");
		try
		{
			StudyURN studyUrn = URNFactory.create(examId, SERIALIZATION_FORMAT.CDTP, StudyURN.class);
			transactionContext.setPatientID(studyUrn.getPatientId());
			transactionContext.setUrn(examId);
			
			String report = router.getExamReport(studyUrn);
			transactionContext.setFacadeBytesSent(report == null ? 0L : report.length());

            logger.info("SUCCESS getReport transaction({}) in {} ms)", transactionId, System.currentTimeMillis() - startTime);
			return report;
		}
		catch(ConnectionException cX)
		{
            logger.error("FAILED getReport connection Exception: {}", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve exam report", cX);
		}
		catch(MethodException mX)
		{
            logger.error("FAILED getReport method Exception: {}", mX.toString(), mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve exam report", mX);
		}
		catch(URNFormatException iurnfX)
		{
            logger.error("FAILED getReport transaction({}", transactionId, iurnfX);
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate exam report", iurnfX);
		}	
		catch(Exception ex)
		{
            logger.error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata#getRequisition(java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials, java.lang.String)
	 */
	@Override
	public String getRequisition(String transactionId,
			gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, String examId) 
	throws RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType 
	{
		setTransactionContext(credentials, transactionId);
		Long startTime = System.currentTimeMillis();
        logger.info("start getRequisition transaction({})", transactionId);
		VistaRadRouter router = ImagingVistaRadContext.getVistaRadRouter();
		if(router == null)
			throw new RemoteException("Internal error, unable to retrieve exam requisiton report");
					
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("VistARad WebApp getRequisition");			
				
		transactionContext.setQuality("n/a");
		transactionContext.setQueryFilter("n/a");
		try
		{
			StudyURN studyUrn = URNFactory.create(examId, SERIALIZATION_FORMAT.CDTP, StudyURN.class);
			transactionContext.setPatientID(studyUrn.getPatientId());
			transactionContext.setUrn(examId);
			
			String report = router.getExamRequisitionReport(studyUrn);
			transactionContext.setFacadeBytesSent(report == null ? 0L : report.length());
            logger.info("SUCCESS getRequisition transaction({}) in {} ms)", transactionId, System.currentTimeMillis() - startTime);
			return report;
		}
		catch(ConnectionException cX)
		{
            logger.error("FAILED getRequisition connection Exception: {}", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve exam requisition report", cX);
		}
		catch(MethodException mX)
		{
            logger.error("FAILED getRequisition method Exception: {}", mX.toString(), mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve exam requisition report", mX);
		}
		catch(URNFormatException iurnfX)
		{
            logger.error("FAILED getRequisition transaction({}", transactionId, iurnfX);
			transactionContext.setErrorMessage(iurnfX.getMessage());
			transactionContext.setExceptionClassName(iurnfX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to translate exam requisition report", iurnfX);
		}	
		catch(Exception ex)
		{
            logger.error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata#pingServer(java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials, java.lang.String, java.lang.String)
	 */
	@Override
	public gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse pingServer(String transactionId,
		gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, 
		String clientWorkstation, String requestSiteNumber) 
	throws RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType 
	{
		setTransactionContext(credentials, transactionId);
		long startTime = System.currentTimeMillis();
        logger.info("start pingServerEvent from [{}] going to site number [{}]", clientWorkstation, requestSiteNumber);
    	
		gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse response = 
			gov.va.med.imaging.vistarad.webservices.soap.v1.PingServerTypePingResponse.SERVER_UNAVAILABLE;
		
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("VistARad WebApp pingServer to (" + requestSiteNumber + ")");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
				
		VistaRadRouter router = ImagingVistaRadContext.getVistaRadRouter();
		if(router == null)
			throw new RemoteException("Internal error, unable to retrieve exam requisiton report");
		try
		{
			SiteConnectivityStatus siteStatus = router.getSiteConnectivityStatus(RoutingTokenHelper.createSiteAppropriateRoutingToken(requestSiteNumber));
			response = VistaRadTranslator.transformSiteConnectivityStatus(siteStatus);
		}
		catch(ConnectionException cX)
		{
            logger.error("FAILED pingServerEvent connection Exception: {}", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX)
		{
            logger.error("FAILED pingServerEvent connection Exception: {}", mX.toString(), mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve patient studies", mX);
		}		
		catch(Exception ex)
		{
            logger.error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
        logger.info("complete VistARad pingServerEvent transaction({}) in {} ms", transactionId, System.currentTimeMillis() - startTime);
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata#postImageAccessEvent(java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials, java.lang.String, java.lang.String)
	 */
	@Override
	public boolean postImageAccessEvent(String transactionId,
			gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, 
			String inputParameter, String siteId)
	throws RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType 
	{
		setTransactionContext(credentials, transactionId);
		Long startTime = System.currentTimeMillis();
        logger.info("start postImageAccessEvent transaction({})", transactionId);
		VistaRadRouter router = ImagingVistaRadContext.getVistaRadRouter();
		if(router == null)
			throw new RemoteException("Internal error, unable to post exam access event");
					
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("VistARad WebApp postExamAccessEvent");			
				
		transactionContext.setQuality("n/a");
		transactionContext.setQueryFilter("n/a");
		try
		{
			Boolean result = router.postExamAccessEvent(RoutingTokenHelper.createSiteAppropriateRoutingToken(siteId), inputParameter);
            logger.info("SUCCESS postImageAccessEvent transaction({}) in {} ms)", transactionId, System.currentTimeMillis() - startTime);
			return result;
		}
		catch(ConnectionException cX)
		{
            logger.error("FAILED postImageAccessEvent connection Exception: {}", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to post exam access event", cX);
		}
		catch(MethodException mX)
		{
            logger.error("FAILED postImageAccessEvent method Exception: {}", mX.toString(), mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to post exam access event", mX);
		}
		catch(Exception ex)
		{
            logger.error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata#prefetchExam(java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials, java.lang.String)
	 */
	@Override
	public gov.va.med.imaging.vistarad.webservices.soap.v1.PrefetchResponseTypePrefetchResponse prefetchExam(
		String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, 
		String examId)
	throws RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType 
	{
		setTransactionContext(credentials, transactionId);
		Long startTime = System.currentTimeMillis();
        logger.info("start prefetchExam transaction({})", transactionId);
		VistaRadRouter router = ImagingVistaRadContext.getVistaRadRouter();
		if(router == null)
			throw new RemoteException("Internal error, cannot find router");
					
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("VistARad WebApp prefetchExam");			
				
		transactionContext.setQuality("n/a");
		transactionContext.setQueryFilter("n/a");
		try
		{
			StudyURN studyUrn = URNFactory.create(examId, SERIALIZATION_FORMAT.CDTP, StudyURN.class);
			transactionContext.setPatientID(studyUrn.getPatientId());
			transactionContext.setUrn(examId);
			
			router.prefetchExamImages(studyUrn);
            logger.info("Scheduled prefetch of exam images complete transaction({}) in {} ms)", transactionId, System.currentTimeMillis() - startTime);
			return gov.va.med.imaging.vistarad.webservices.soap.v1.PrefetchResponseTypePrefetchResponse.SUBMITTED;
		}		
		catch(Exception ex)
		{
            logger.error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}	
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata#remoteMethodPassthrough(java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials, java.lang.String, java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterType[])
	 */
	@Override
	public String remoteMethodPassthrough(String transactionId,
			gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials, 
			String siteNumber, String methodName,
			gov.va.med.imaging.vistarad.webservices.soap.v1.RemoteMethodParameterType[] parameters) 
	throws RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType 
	{
		setTransactionContext(credentials, transactionId);
		long startTime = System.currentTimeMillis();
        logger.info("start remoteMethodPassthrough for method [{}] going to site number [{}]", methodName, siteNumber);
    	
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("VistARad WebApp remoteMethodPassthrough method (" + methodName + ")");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		
		VistaRadRouter router = ImagingVistaRadContext.getVistaRadRouter();
		if(router == null)
			throw new RemoteException("Internal error, unable to retrieve exam requisiton report");
		
		PassthroughInputMethod inputMethod = VistaRadTranslator.transformPassthroughMethod(methodName, parameters);		
		try
		{
			String response = router.postPassthroughMethod(RoutingTokenHelper.createSiteAppropriateRoutingToken(siteNumber), inputMethod);
			
			transactionContext.setFacadeBytesSent(response == null ? 0L : new Long(response.length()));

            logger.info("SUCCESS remoteMethodPassthrough transaction({}) in {} ms)", transactionId, System.currentTimeMillis() - startTime);
			return response;
		}
		catch(ConnectionException cX)
		{
            logger.error("FAILED remoteMethodPassthrough connection Exception: {}", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve patient studies", cX);
		}
		catch(MethodException mX)
		{
            logger.error("FAILED remoteMethodPassthrough connection Exception: {}", mX.toString(), mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve patient studies", mX);
		}
		catch(Exception ex)
		{
            logger.error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistarad.webservices.soap.v1.ImageVistaRadMetadata#getExamSiteMetadataCachedStatus(java.lang.String, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials, java.lang.String, java.lang.String[])
	 */
	@Override
	public gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType[] getExamSiteMetadataCachedStatus(
			String transactionId, gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials credentials,
			String patientIcn, String[] siteNumbers) 
	throws RemoteException, gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType  
	{
		setTransactionContext(credentials, transactionId);
		long startTime = System.currentTimeMillis();
        logger.info("start getExamSiteMetadataCachedStatus for '{}' sites for patient '{}'.", siteNumbers == null ? "null" : "" + siteNumbers.length, patientIcn);
    	
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setRequestType("VistARad WebApp getExamSiteMetadataCachedStatus from (" + VistaRadTranslator.transformSiteNumbersToString(siteNumbers) + ")");
		transactionContext.setQueryFilter("n/a");
		transactionContext.setQuality("n/a");
		transactionContext.setUrn("n/a");
		transactionContext.setPatientID(patientIcn);
		
		VistaRadRouter router = ImagingVistaRadContext.getVistaRadRouter();
		if(router == null)
			throw new RemoteException("Internal error, unable to retrieve exam sites cached status");
				
		try
		{
			RoutingToken[] routingTokens = new RoutingToken[siteNumbers.length];
			int index = 0;
			for(String siteNumber : siteNumbers)
				routingTokens[index++] = RoutingTokenHelper.createSiteAppropriateRoutingToken(siteNumber);
			
			List<ExamSiteCachedStatus> examSiteCachedStatuses = router.getExamsCacheStatus(patientIcn, routingTokens);
			//SiteNumber [] siteNumbers = VistaRadTranslator.transformSiteNumbers(siteNumber);
			//List<ExamSiteCachedStatus> examSiteCachedStatuses = router.getExamsCacheStatus(patientIcn, siteNumbers);		
			
			gov.va.med.imaging.vistarad.webservices.soap.v1.ExamSiteMetadataCachedStatusType[] result = 
				VistaRadTranslator.transformExamSiteCachedStatuses(examSiteCachedStatuses);			
			transactionContext.setEntriesReturned(result == null ? 0 : result.length);

            logger.info("SUCCESS getExamSiteMetadataCachedStatus transaction({}) in {} ms)", transactionId, System.currentTimeMillis() - startTime);
            logger.info("found '{} cached site results for patient '{}'.", result == null ? "<null>" : "" + result.length, patientIcn);
			return result;
		}
		catch(ConnectionException cX)
		{
            logger.error("FAILED getExamSiteMetadataCachedStatus connection Exception: {}", cX.toString(), cX);
			transactionContext.setErrorMessage(cX.getMessage());
			transactionContext.setExceptionClassName(cX.getClass().getSimpleName());
			throw new RemoteException("Internal error, unable to retrieve exam sites cached status", cX);
		}
		catch(MethodException mX)
		{
            logger.error("FAILED getExamSiteMetadataCachedStatus connection Exception: {}", mX.toString(), mX);
			transactionContext.setErrorMessage(mX.getMessage());
			transactionContext.setExceptionClassName(mX.getClass().getSimpleName());
			handleMethodException(mX);
			throw new RemoteException("Internal error, unable to retrieve exam sites cached status", mX);
		}
		catch(Exception ex)
		{
            logger.error("Generic exception: {}", ex.getMessage(), ex);
			transactionContext.setErrorMessage(ex.toString());
			transactionContext.setExceptionClassName(ex.getClass().getSimpleName());
			throw new RemoteException("Internal error, generic exception", ex);
		}
	}

	/**
	 * Set the transaction context properties that are passed in the webservices.
	 * @param requestor
	 * @param transactionId
	 */
	private void setTransactionContext(gov.va.med.imaging.vistarad.webservices.soap.v1.UserCredentials userCredentials,
		java.lang.String transactionId)
	{
		logger.info(
				"setTransactionContext, id='" + transactionId + 
				"', username='" + userCredentials == null || userCredentials.getFullname() == null ? "null" : "" + userCredentials.getFullname() +
				"'.");
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		if(transactionId != null)
			transactionContext.setTransactionId(transactionId);
		
		if(userCredentials != null)
		{
			if( userCredentials.getFullname() != null )
				transactionContext.setFullName(userCredentials.getFullname());
			if( userCredentials.getSiteNumber() != null )
				transactionContext.setSiteNumber(userCredentials.getSiteNumber());
			if( userCredentials.getSiteName() != null )
				transactionContext.setSiteName(userCredentials.getSiteName());
			if( userCredentials.getSsn() != null )
				transactionContext.setSsn(userCredentials.getSsn());
			if(userCredentials.getDuz() != null)
				transactionContext.setDuz(userCredentials.getDuz());
			if(userCredentials.getCacheLocationId() != null)
				transactionContext.setCacheLocationId(userCredentials.getCacheLocationId());
			if(userCredentials.getSecurityToken() != null)
				transactionContext.setBrokerSecurityToken(userCredentials.getSecurityToken());
			transactionContext.setPurposeOfUse(PurposeOfUse.routineMedicalCare.getDescription());
		}
		transactionContext.setImagingSecurityContextType(ImagingSecurityContextType.MAGJ_VISTARAD.toString());
	}
		
	private void handleMethodException(MethodException mX)
	throws gov.va.med.imaging.vistarad.webservices.soap.v1.SecurityCredentialsExpiredExceptionFaultType  
	{
		try
		{
			WebservicesCommon.throwSecurityCredentialsExceptionFromMethodException(mX);
		}
		catch(SecurityCredentialsExpiredException sceX)
		{
			TransactionContextFactory.get().setExceptionClassName(sceX.getClass().getSimpleName());
			throw new SecurityCredentialsExpiredExceptionFaultType(sceX.getMessage(), "");
		}
	}
}
