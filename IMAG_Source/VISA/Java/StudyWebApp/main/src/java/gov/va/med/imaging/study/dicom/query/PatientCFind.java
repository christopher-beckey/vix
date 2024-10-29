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

import com.lbs.DCS.*;
import com.lbs.DDS.DDSException;
import com.lbs.DDS.DicomDataServiceListener;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.remote.NetworkFetchManager;
import gov.va.med.imaging.study.dicom.vista.PatientInfo;
import gov.va.med.imaging.study.lbs.VixDicomDataService;
import gov.va.med.imaging.study.rest.types.StudiesResultType;
import gov.va.med.imaging.study.rest.types.StudyFilterResultType;
import gov.va.med.imaging.study.rest.types.StudyType;
import gov.va.med.logging.Logger;

import java.io.UnsupportedEncodingException;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

public class PatientCFind extends VixDicomQuery { //this class does the primary C-FIND work of our feature, returning study metadata for all studies for this patient across VA and DoD

    private static final Logger logger = Logger.getLogger(PatientCFind.class);
    private static final Map<String, String> patientIcnByUid = new HashMap<>(); //used for reverse lookup
    private static final Map<String, String> studyUrnByUid = new HashMap<>();

    private Set<String> allowedSiteIds;
    private StudyFilterResultType studyFilterTerm;
    private int studySentCount = 0;
    private int lbsCFindResultCode = 0;
    private final String queriedPatientId;
    private final Map<String,Integer> logSiteStudyMap = new HashMap<>();

    public PatientCFind(String transactionGuid, PatientInfo patientInfo, String queriedPatientId,
                        StudyFilterResultType filterType) {//web service
        super(transactionGuid, patientInfo);
        this.queriedPatientId = queriedPatientId;
        try {
            allowedSiteIds = getFilteredMtfList(super.getCallingAe(), super.getCallingIp());
            studyFilterTerm = filterType;
        } catch (CannotLoadConfigurationException e) {
            logger.error("Could not set filtered tfl for {} msg: {}", this, e.getMessage());
        }
    }

    public PatientCFind(DimseMessage query, DicomDataServiceListener listener, AssociationAcceptor association,
                        PatientInfo patientInfo, String transactionGuid, QueryType queryType, long startMillis) throws DDSException {
        super(query, listener, association, patientInfo, transactionGuid, queryType, startMillis);

        String queriedPatientId1;
        try {
            queriedPatientId1 = query.data().getElementStringValue(DCM.E_PATIENT_ID);
        } catch (DCSException e) {
            if(logger.isDebugEnabled()){
                logger.debug("No queried patient id, should be study uid");
            }
            queriedPatientId1 = patientInfo.getIcn();
        }
        this.queriedPatientId = queriedPatientId1;
        try {
            setConfigValues(); //sets the allowedSites based on config + vista values
        } catch (ImagingDicomException e) {
            logger.error("Could not set filtered tfl for {}", this);
            throw new DDSException("Could not set filtered treating facility list");
        }
    }

    @Override
    public void performCFind() throws DDSException {
        try {
            long millisSpent = System.currentTimeMillis() - this.getStartMillis();
            long timeOutMillis = Integer.parseInt(DicomService.getScpConfig().getSiteFetchTimeLimit()) * 1000L;
            getPatientStudies(timeOutMillis - millisSpent); //unknown patients may have taken >1s to resolve from CVIX
        }catch(InterruptedException e){
            logger.error("Failed to perform CFIND msg {}", e.getMessage());
            if(logger.isDebugEnabled()){
                logger.debug("CFIND failure details ", e);
            }
            throw new DDSException("Failed to perform CFIND ",e);
        }
    }

    public Vector<DicomPersistentObjectDescriptor> performCMove() {
        //not implemented for this class
        return new Vector<DicomPersistentObjectDescriptor>(Collections.EMPTY_LIST);
    }

    public Map<String,List<StudyType>> getPatientStudies() throws ImagingDicomException, InterruptedException {
        return getPatientStudies(Long.parseLong(DicomService.getScpConfig().getSiteFetchTimeLimit()) * 1000L);
    }

    public Map<String,List<StudyType>> getPatientStudies(long timeOutMillis) throws InterruptedException {
        Map<String, List<StudyType>> toReturn = new HashMap<>();

        if (allowedSiteIds.size() == 0) {
            logger.warn("scpGetPatientStudies does not get remote VIX site list from VistA for {}", queriedPatientId);
            return new HashMap<>();
        }

        Map<String,Future<StudiesResultType>> futureResultsBySiteId = new HashMap<>();
        int doneCount = 0;
        for(String siteId : allowedSiteIds){
            futureResultsBySiteId.put(siteId, NetworkFetchManager.requestStudiesFromSite(siteId, this));
        }
        long startStudyFetchTime = System.currentTimeMillis();
        long millisPassed = 0;
        while(doneCount < allowedSiteIds.size() && millisPassed < timeOutMillis){ //write out the studies as their fetch completes
            Iterator<Map.Entry<String, Future<StudiesResultType>>> entryIterator = futureResultsBySiteId.entrySet().iterator();
            while(entryIterator.hasNext()){
                Map.Entry<String, Future<StudiesResultType>> entry = entryIterator.next();
                String siteId = entry.getKey();
                Future<StudiesResultType> futureResult = entry.getValue();
                if(futureResult.isDone()){
                    if(logger.isDebugEnabled()){
                        logger.debug("{} result complete for {}", super.getPatientInfo().getIcn(), siteId);
                    }
                    try{
                       toReturn.put(siteId, processStudyResult(futureResult, siteId));
                    } catch (ExecutionException | InterruptedException e) {
                        logger.error("Failed to get studies from site {} msg {}", siteId, e.getMessage());
                        if (logger.isDebugEnabled()){
                            logger.debug("Site {}study fetch failure details ", siteId, e);
                        }
                        toReturn.put(siteId, Collections.EMPTY_LIST);
                    }
                    entryIterator.remove();
                    doneCount++;
                    if(toReturn.get(siteId).size() == 0 && logger.isDebugEnabled()){
                        logger.debug("Site {} had no valid studies", siteId);
                    }
                }
            }
            if(doneCount < allowedSiteIds.size()){
                Thread.sleep(500); //TODO: Vertx, JavaRx ObservableFuture...How to do in vanilla java without busy waiting?
            }
            millisPassed = System.currentTimeMillis() - startStudyFetchTime;
        }

        if(getListener() != null && getQueryType().equals(QueryType.PATIENTCFIND)){
            completeCFind(allowedSiteIds);
        }

        return toReturn;
    }

    private void completeCFind(Set<String> attemptedSites){
        VixDicomDataService.completeCFind(getListener(), this.lbsCFindResultCode);
        long perfMillis = System.currentTimeMillis() - super.getStartMillis();
        logger.info("###===C-FIND COMPLETE for {} returned {} in {}ms. {}", super.getPatientInfo().getIcn(), studySentCount, perfMillis, this);

        DicomService.vistaLog(super.getStartMillis(), super.getPatientInfo().getIcn(), "C-FIND " + getQueryLevel(), super.getCallingAe(), studySentCount,
                studySentCount,"n/a", super.getCallingIp(),false, null, String.join(",", super.getQueriedModalities()),
                "Dicom C-FIND", "","n/a", "SCP", "C-FIND " + getQueryLevel(),
                String.join(",", attemptedSites), this.getTransactionGuid(), String.join(",", attemptedSites));
    }

    private List<StudyType> processStudyResult(Future<StudiesResultType> futureResult, String siteId)
            throws ExecutionException, InterruptedException {
        StudiesResultType resultContainer = futureResult.get();
        List<StudyType> toReturn = new ArrayList<>();
        if(resultContainer.isPartialResult()){
            logger.info("Partial result received for patient {} from site {}", super.getPatientInfo().getIcn(), siteId);
        }
        if(resultContainer.getErrors() != null
              && resultContainer.getErrors().getErrors() != null &&
                resultContainer.getErrors().getErrors().length > 0){
            logger.warn("Errors present for {} at site {} error code {} errors are {}", super.getPatientInfo().getIcn(), siteId, resultContainer.getErrors().getErrors()[0].getErrorCode(), String.join(";;", Arrays.toString(resultContainer.getErrors().getErrors())));
            //Do not throw here, can still have data. 200 returns errors if DDH is down but still returns images from ECIA
        }
        if(resultContainer.getStudies() == null || resultContainer.getStudies().getStudies().length == 0){
            return Collections.EMPTY_LIST;
        }
        logSiteStudyMap.putIfAbsent(siteId, 0);
        for(StudyType study : resultContainer.getStudies().getStudies()){
            if(study == null || study.getDicomUid() == null){
                logger.debug("Study has null uid. Skipping");
                continue;
            }
            String studyUid = study.getDicomUid();
            Set<String> modalities = getCleanModalities(study);
            String studyUrn = study.getStudyId();
            String dataSource = studyUrn.contains(":vastudy:") ? "VA" : "DOD";

            if (!QueryFactory.isModalityValid(modalities, super.getQueriedModalities(), super.getCallingAe(),
                    super.getCallingIp(), dataSource) ||
                    studyUrn.contains(":musestudy:") ||
                    study.getProcedureDate().toInstant().isBefore(this.getFromDate().toInstant().minus(1, ChronoUnit.DAYS)) ||
                    study.getProcedureDate().toInstant().isAfter(this.getToDate().toInstant().plus(1, ChronoUnit.DAYS)) ) {
                if(logger.isDebugEnabled()) {
                    logger.debug("This study is not valid! Will not be put in cache or return to SCU: urn={} modalities= {} procedure date: {}", studyUrn, String.join(",", modalities), study.getProcedureDate());
                }
                continue;
            }
            String newDesc = study.getDescription();
            studyUrnByUid.put(studyUid, studyUrn);
            patientIcnByUid.put(studyUid, super.getPatientInfo().getIcn());
            if (study.getSiteAbbreviation() != null && study.getSiteAbbreviation().length() > 0){
                newDesc = study.getSiteAbbreviation() + "- " + newDesc;
            }
            else{
                newDesc = siteId + "- " + newDesc;
            }
            newDesc = newDesc.replaceAll("[^\\p{ASCII}]", "");
            newDesc = newDesc.replaceAll("\\\\","^");
            toReturn.add(study);
            if(getListener() != null && getQueryType().equals(QueryType.PATIENTCFIND)){
                try {
                    lbsCFindResultCode = VixDicomDataService.sendStudyCFindResponse(study,
                            getCleanModalities(study),newDesc, this);
                    if(lbsCFindResultCode == -1){
                        logger.warn("failed to send study metadata for {} did the caller hang up? ", study.getStudyId());
                    }else if(lbsCFindResultCode == 0){
                        studySentCount++;
                        logSiteStudyMap.compute(siteId,(k,v) -> ++v);
                    }
                } catch (DCSException | ImagingDicomException | UnsupportedEncodingException e) {
                    logger.error("Failed to send study to {}{} for {} at site {} study is {} msg {}", super.getCallingAe(), super.getCallingIp(), super.getPatientInfo().getIcn(), siteId, studyUrn, e.getMessage());
                    if(logger.isDebugEnabled()) logger.debug("Study send failure details ", e);
                }
            }
        }
        return toReturn;
    }

    private void setConfigValues() throws ImagingDicomException {
        try{
            allowedSiteIds = getFilteredMtfList(super.getCallingAe(), super.getCallingIp());
            studyFilterTerm = StudyFilterResultType.valueOf(DicomService.getScpConfig()
                    .getConfigForAe(this.getCallingAe(), this.getCallingIp()).getStudyQueryFilter());
        } catch (CannotLoadConfigurationException e){
            logger.error("Configuration load failure in patient study query {}", e.getMessage());
            throw new ImagingDicomException("Configuration load failure in patient study query " + e.getMessage(), e);
        }catch (IllegalArgumentException illegalArgumentException){
            logger.warn("Calling Ae {}{} has an invalid StudyFilter ResultType {}", this.getCallingAe(), this.getCallingIp(), DicomService.getScpConfig().getConfigForAe(this.getCallingAe(), this.getCallingIp()).getStudyQueryFilter());
            this.studyFilterTerm = StudyFilterResultType.all;//revisit default if CCIA supports new filtering
        }
    }

    private Set<String> getFilteredMtfList(String strAe, String pacsIp)
            throws CannotLoadConfigurationException{
        Set<String> fullSiteCodeSet = new HashSet<>(this.getPatientInfo().getMtfList());
        if(DicomService.getScpConfig().getConfigForAe(strAe, pacsIp) == null){
            return fullSiteCodeSet;
        }

        List<String> blackList = DicomService.getScpConfig().getConfigForAe(strAe, pacsIp).getSiteCodeBlacklist();
        Iterator<String> it = fullSiteCodeSet.iterator();
        boolean addDod = false;
        while(it.hasNext()){
            String siteCode = it.next();
            if(siteCode.startsWith("200") && !blackList.contains("200") && !siteCode.startsWith("200CRNR")) addDod = true;
            if(blackList.contains(siteCode) || siteCode.length() < 3 ||
                    (siteCode.startsWith("200") && (!siteCode.equals("200") && !siteCode.equals("200CRNR")))){
                it.remove();
            }
        }
        if(addDod){
            fullSiteCodeSet.add("200");
        }
        return fullSiteCodeSet;
    }

    @Override
    public String toString() {
        StringBuilder siteStudyString = new StringBuilder("studiesBySite = ");
        for(String siteId : logSiteStudyMap.keySet()){
            siteStudyString.append(siteId).append(" : ").append(logSiteStudyMap.get(siteId)).append(" studies, ");
        }
        return "VixDicomPatientQuery{" +
                " queryLevel= " + getQueryLevel() +
                ", patientIcn= " + super.getPatientInfo().getIcn() +
                ", fromDate= " + super.getFromDate() +
                ", toDate= " + super.getToDate() +
                ", callingAe = "+ super.getCallingAe() +
                ", callingIp = " + super.getCallingIp() +
                siteStudyString +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PatientCFind that = (PatientCFind) o;
        if(!this.getCallingAe().equals(that.getCallingAe())){
            return false;
        }else if(!this.getCallingIp().equals(that.getCallingIp())){
            return false;
        }else {
            return this.getPatientIcn().equals(that.getPatientIcn());
        }
    }

    public String getPatientIcn() {
        return super.getPatientInfo().getIcn();
    }

    public static String getIcnByStudyUid(String studyUid){
        return patientIcnByUid.get(studyUid);
    }

    public static String getStudyUrnByUid(String studyUid){
        if(!studyUrnByUid.containsKey(studyUid)){
            return null;
        }
        return studyUrnByUid.get(studyUid);
    }

    public StudyFilterResultType getStudyFilterTerm() {
        return studyFilterTerm;
    }

    public String getQueriedPatientId() {
        return queriedPatientId;
    }
}
