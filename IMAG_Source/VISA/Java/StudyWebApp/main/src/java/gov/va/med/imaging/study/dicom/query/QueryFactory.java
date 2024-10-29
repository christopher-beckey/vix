/**
 *
 Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 Date Created: Mar 25, 2021
 Site Name:  Washington OI Field Office, Silver Spring, MD
 Developer:  VHAISWJIANGS
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
package gov.va.med.imaging.study.dicom.query;

import com.lbs.DCS.AssociationAcceptor;
import com.lbs.DCS.DCM;
import com.lbs.DCS.DCSException;
import com.lbs.DCS.DimseMessage;
import com.lbs.DDS.DDSException;
import com.lbs.DDS.DicomDataServiceListener;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.vista.LocalVistaDataSource;
import gov.va.med.imaging.study.dicom.vista.PatientInfo;
import gov.va.med.imaging.study.rest.types.StudyFilterResultType;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.ConnectionFailedException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.tomcat.vistarealm.exceptions.MethodException;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.logging.Logger;

import java.util.Collections;
import java.util.List;
import java.util.Set;

//This class is responsible for parsing objects received from LBS representing queries over the DICOM protocol
//it produces three types of queries (represented by only two classes): Patient C-FIND, Study C-FIND, and Study C-MOVE
//Do we need to support Study specific C-FINDS? Nil seems to do an image specific C-FIND that we have handling for, though it seems we may not be sure that handling is correct, it should be unchanged from p269
public class QueryFactory {
    private static final Logger logger = Logger.getLogger(QueryFactory.class);

    public static VixDicomQuery getQuery(AssociationAcceptor association, DimseMessage query,
                                         VixDicomQuery.QueryType queryType, DicomDataServiceListener listener)
            throws DDSException {
        long startMillis = System.currentTimeMillis();
        String calledTitle = association.getAssociationInfo().calledTitle();
        String callingIpAddr = association.getAssociationInfo().callingPresentationAddress().substring(0, association.getAssociationInfo().callingPresentationAddress().indexOf(":"));// we don't care about the port

        String tempCallingTitle = association.getAssociationInfo().callingTitle();
        if (tempCallingTitle.indexOf(",") > 0) {
            tempCallingTitle = tempCallingTitle.substring(0, tempCallingTitle.indexOf(","));
        }
        String callingTitle = tempCallingTitle;
        validateTitles(callingTitle, callingIpAddr, calledTitle);

        TransactionContext transactionContext;
        try {
            transactionContext = DicomService.prepareTransactionContext(callingIpAddr, callingTitle);
        } catch (CannotLoadConfigurationException | ConnectionFailedException | InvalidCredentialsException | MethodException e) {
            logger.error("Cannot prepare transaction context while processing query from {}{} msg {}", callingTitle, callingIpAddr, e.getMessage());
            if(logger.isDebugEnabled()) logger.debug("Transaction context preparation failure details " , e);
            throw new DDSException("Cannot prepare transaction context while processing query from " + callingTitle + callingIpAddr, e);
        }
        if(query.data() == null) {
            logger.error("null query received from {}", callingTitle);
            throw new DDSException("null query received from " + callingTitle);
        }
        String queriedStudyUid;
        try {
            queriedStudyUid = query.data().getElementStringValue(DCM.E_STUDY_INSTANCE_UID);
            if(queriedStudyUid != null && !queriedStudyUid.isEmpty() && !queryType.equals(VixDicomQuery.QueryType.CMOVE)){
                queryType = VixDicomQuery.QueryType.STUDYCFIND;
            }
        } catch (DCSException e) {
            logger.info("Query does not have studyUid.{}", e.getMessage());
            queriedStudyUid = null;
        }

        PatientInfo patientInfo;
        try {
            patientInfo = getAndValidatePatientInfo(query, queriedStudyUid, callingTitle,
                    transactionContext.getTransactionId(), StudyFilterResultType.valueOf(DicomService.getScpConfig().getConfigForAe(callingTitle, callingIpAddr).getStudyQueryFilter())
            );
        }catch(Exception e){
            logger.error("Unable to get patient info from vista for query from {}{} msg: {}", callingTitle, callingIpAddr, e.getMessage());
            if(logger.isDebugEnabled()){
                logger.debug("Patient info fetch from vista failure details ", e);
            }
            throw new DDSException("Problem validating query ", e);
        }

        PatientCFind patientCFind = new PatientCFind(query, listener, association, patientInfo,
                    transactionContext.getTransactionId(), queryType, startMillis);

        if(queriedStudyUid == null || queriedStudyUid.length() == 0){
            return patientCFind;
        }

        return new StudyQuery(association, patientCFind,queriedStudyUid);
    }

    public static boolean isModalityValid(Set<String> studyModalities, Set<String> queriedModalities, String currAE, String callingIp,
                                          String dataSource) {
        List<String> configmods = DicomService.getScpConfig().getModalityBlockList(currAE, callingIp, dataSource);
        if (studyModalities == null || configmods == null) return true; // ? when don't know mod of study, return anyway TODO: Ask Sonny
        if (configmods.containsAll(studyModalities)) return false; //Should it only filter the study if all modalities are blocked?
        return queriedModalities.size() <= 0 || !Collections.disjoint(studyModalities, queriedModalities);
    }

    private static void validateTitles(String callingTitle, String callingAddr, String calledTitle)
            throws DDSException {
        if (!DicomService.getScpConfig().isCallingAeAllowed(callingTitle, callingAddr)) {
            logger.error("callingAE {}_{} is NOT permitted to make QR on this DICOM SCP.", callingTitle, callingAddr);
            throw new DDSException("callingAE " + callingTitle + " is NOT permitted to perform QR on this DICOM SCP.");
        }

        if(!DicomService.getScpConfig().isCalledAeCorrect(calledTitle)){
            logger.error("calledAe {} is not correct. CalledTitle should be {}", calledTitle, DicomService.getScpConfig().getCalledAETitle());
            throw new DDSException("Query uses incorrect Ae Title to address VIX DICOM Q/R");
        }
    }

    private static PatientInfo getAndValidatePatientInfo(DimseMessage query, String queriedStudyUid, String callingTitle,
                                                         String transId, StudyFilterResultType filter)
            throws DDSException {
        String tempPatientId = null;
        PatientInfo patientInfo = null;
        try {
            tempPatientId = query.data().getElementStringValue(DCM.E_PATIENT_ID); // it has to have an ICN, IEN, SSN or EDIPI
        } catch (DCSException e) {
            logger.debug("Query does not have patientId. Okay for subsequent queries. {}", e.getMessage());
        }
        if (tempPatientId == null || tempPatientId.trim().length() < 1) {
            if (queriedStudyUid == null) {
                logger.error("no patient Id or study Id in C-FIND for calling AE {}", callingTitle);
                throw new DDSException("Received C-FIND with no Patient Id or Study Id from callingAe " + callingTitle);
            }

            tempPatientId = PatientCFind.getIcnByStudyUid(queriedStudyUid);
            if(tempPatientId == null){
                logger.error("unknown study uid {} queried in C-FIND from calling AE {}", queriedStudyUid, callingTitle);
                throw new DDSException("unknown study uid " + queriedStudyUid + " queried in C-FIND from calling AE "+ callingTitle);
            }
            logger.info("###=== Query with empty patientId and StudyUid={} will use patientId: {}", queriedStudyUid, tempPatientId);
        }

        try {
            tempPatientId = cleanUpPatientId(tempPatientId);
            patientInfo = LocalVistaDataSource.getPatientInfo(tempPatientId, transId, filter);
        } catch (ImagingDicomException e) {
            logger.error("Failed to process query for  {} for query from {} msg {}", tempPatientId, callingTitle, e.getMessage());
            if(logger.isDebugEnabled()){
                logger.debug("Query processing failure ", e);
            }
            throw new DDSException("Failed to process query for " + tempPatientId + " from " + callingTitle);
        }

        return patientInfo;
    }

    private static String cleanUpPatientId(String tempPatientId){ //this is for nil
        tempPatientId = tempPatientId.trim();
        tempPatientId = tempPatientId.replace("*","");
        tempPatientId = tempPatientId.toUpperCase();
        tempPatientId = tempPatientId.trim().replace("^", "-").replaceAll("-", "").replaceAll(" ", "");
        return tempPatientId;
    }

    public static PatientCFind getPatientCFindForWebService(String patientIcn, String filterType) throws ImagingDicomException {
        TransactionContext transactionContext;
        try {
            transactionContext = DicomService.prepareTransactionContext("WebService", "WebService");
        } catch (CannotLoadConfigurationException | ConnectionFailedException | InvalidCredentialsException | MethodException e) {
            logger.error("Cannot prepare transaction context while processing query from WebServiceWebService msg {}", e.getMessage());
            if (logger.isDebugEnabled()) logger.debug("Transaction context preparation failure details ", e);
            return null;
        }
        PatientInfo patientInfo;
        try{
            String pid = cleanUpPatientId(patientIcn);
            patientInfo = LocalVistaDataSource.getPatientInfo(pid, transactionContext.getTransactionId(), StudyFilterResultType.all);
        } catch (Exception e) {
            logger.error("Could not get patient info for web service query for {} msg: {}", patientIcn, e.getMessage());
            if(logger.isDebugEnabled()){
                logger.debug("webservice vista patient info failure details", e);
            }
            throw new ImagingDicomException("Could not get patient info for web service query for " + patientIcn,e);
        }
        StudyFilterResultType filter = StudyFilterResultType.all;
        try {
            filter = StudyFilterResultType.valueOf(filterType);
        }catch(Exception e){
            logger.error("Invalid filter type  received {} msg: {}", filterType, e.getMessage());
        }
        return new PatientCFind(transactionContext.getTransactionId(), patientInfo, patientIcn, filter );
    }
}
