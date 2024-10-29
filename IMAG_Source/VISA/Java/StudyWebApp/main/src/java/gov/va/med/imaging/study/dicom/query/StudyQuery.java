package gov.va.med.imaging.study.dicom.query;

import com.lbs.DCS.*;
import com.lbs.DDS.DDSException;
import gov.va.med.URNFactory;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.cache.ImageCacheTask;
import gov.va.med.imaging.study.dicom.cache.ReportCacheTask;
import gov.va.med.imaging.study.dicom.remote.NetworkFetchManager;
import gov.va.med.imaging.study.dicom.remote.image.ImageFetchDto;
import gov.va.med.imaging.study.dicom.remote.report.ReportFetchDto;
import gov.va.med.imaging.study.dicom.vista.RemoteVistaDataSource;
import gov.va.med.imaging.study.lbs.VixDicomDataService;
import gov.va.med.imaging.study.lbs.vix.dpod.ImageDpod;
import gov.va.med.imaging.study.lbs.vix.dpod.ReportDpod;
import gov.va.med.imaging.study.lbs.vix.dpod.VixDpod;
import gov.va.med.imaging.study.rest.types.*;
import gov.va.med.imaging.url.vista.image.SiteParameterCredentials;
import gov.va.med.logging.Logger;
import org.apache.logging.log4j.LogManager;

import java.io.UnsupportedEncodingException;
import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeoutException;

//This class handles C-MOVE and C-FINDs that contain a specific studyUid
//C-FIND handling is rough as not many devices seem to use this data
//image level c-find: only Nil? we return dummy data about an SR, unchanged
//series level c-find: we return the queried study uid and series specific data for each series, unchanged
//study level c-find: we return the study uid and series specific data for each series, previously we returned the same return value as patientCFind but only for the specified study
public class StudyQuery extends VixDicomQuery {

    private static final Logger logger = Logger.getLogger(StudyQuery.class);
    private static final org.apache.logging.log4j.Logger logr = LogManager.getLogger(StudyQuery.class);

    private final String queriedStudyUid;
    private int lbsCFindResultCode = 0;
    private final StudySeriesesType studySerieses;
    private final StudyType studyMeta;
    private final String siteCode;
    private final String remoteHost;
    private final PatientCFind patientCFind;
    private final String destinationAe;
    private Map<String, Image> imagesInVAStudyByIen = new HashMap<>();
    private List<ImageFetchDto> imageDtos = new ArrayList<>();
    private int cachedCount = 0;
    private int pulledCount = 0;

    public StudyQuery(String transactionGuid, PatientCFind patientCFind, StudyURN studyURN, StudyType studyMeta,
                      StudySeriesesType studySeriesesType) {//web service
        super(transactionGuid, patientCFind.getPatientInfo());
        this.patientCFind = patientCFind;
        this.studySerieses = studySeriesesType;//web service hack
        this.studyMeta = studyMeta;//web service hack
        this.queriedStudyUid = studyURN.toString(); //web service hack
        this.siteCode = studyURN.getOriginatingSiteId();
        this.remoteHost = DicomService.getRemoteVixHost(siteCode);
        this.destinationAe = null;
    }

    public StudyQuery(StudyQuery toCopy) {
        super(toCopy);
        this.destinationAe = toCopy.destinationAe;
        this.queriedStudyUid = toCopy.queriedStudyUid;
        this.studySerieses = toCopy.studySerieses;
        this.studyMeta = toCopy.studyMeta;
        this.siteCode = toCopy.siteCode;
        this.remoteHost = toCopy.remoteHost;
        this.patientCFind = toCopy.patientCFind;
        this.imagesInVAStudyByIen = new HashMap<>(toCopy.imagesInVAStudyByIen);
        this.imageDtos = new ArrayList<>(toCopy.imageDtos);
    }

    public StudyQuery(AssociationAcceptor association, PatientCFind patientCFind, String queriedStudyUid) throws DDSException {
        super(patientCFind.getDimseQuery(), patientCFind.getListener(), association, patientCFind.getPatientInfo(),
                patientCFind.getTransactionGuid(), patientCFind.getQueryType(), patientCFind.getStartMillis());
        this.queriedStudyUid = queriedStudyUid;
        this.patientCFind = patientCFind;

        try {
            Map<String,StudyType> studyBySite = getStudyAndSite(patientCFind.getPatientStudies(), queriedStudyUid);
            Map.Entry<String, StudyType> entry = studyBySite.entrySet().iterator().next();
            this.studyMeta = entry.getValue();
            this.siteCode = this.studyMeta.getSiteNumber();
            this.remoteHost = DicomService.getRemoteVixHost(siteCode);
            String tempDestAe = null;
            if(getQueryType().equals(QueryType.CMOVE)) {
                try {
                    tempDestAe = getDimseQuery().moveDestination();
                } catch (DCSException e) {
                    logger.warn("Did not set destination AE from query, using calling AE. Msg: {}", e.getMessage());
                }
                if (tempDestAe == null) {
                    tempDestAe = getCallingAe();
                }
                if(DicomService.getScpConfig().isFdtEnabled()) {
                    try {
                        DicomService.preCacheWithFdt(studyMeta.getStudyId(), this.patientCFind.getCallingAe(),
                                this.patientCFind.getCallingIp(), this.patientCFind.getPatientInfo().getIcn(), siteCode);
                    }catch (Exception e){
                        logger.warn("FDT Pre Cache failed msg [{}]",e.getMessage());
                        if(logger.isDebugEnabled()){
                            logger.debug("FDT Pre Cache failure details",e);
                        }
                    }
                }
            }
            this.destinationAe = tempDestAe;
            this.studySerieses = loadStudyDetail();
            if(!this.studyMeta.getSiteNumber().equals("200CRNR") && getQueryType().equals(QueryType.CMOVE) &&
                    DicomService.getScpConfig().useDirectFetch()) { //revisit if we merge up CCIA code
                try {
                    StudyURN studyURN = URNFactory.create(this.studyMeta.getStudyId());
                    if (studyURN.isOriginVA()) {

                        RemoteVistaDataSource remoteVistaDataSource = new RemoteVistaDataSource(studyURN.getOriginatingSiteId(),
                                this.getCallingAe(), this.getCallingIp());
                        Study study = remoteVistaDataSource.getStudyByUrn(studyURN);
                        imagesInVAStudyByIen = getImageMapFromStudy(study);
                        SiteParameterCredentials siteCreds = RemoteVistaDataSource.getSiteParameterCredentials(siteCode, this.getCallingIp(), this.getCallingIp());//ensure site param creds are cached before we fetch images
                        logger.info("Direct fetch attempt for: {}. Vista Image Count = {} Study/restservices Image Count = {}", this.getStudyUrn(), imagesInVAStudyByIen.keySet().size(), this.studyMeta.getImageCount());
                        if(logger.isDebugEnabled()) {
                            logger.debug("Site parameter creds: {} - {} - {}****", siteCode, siteCreds.getUsername(), siteCreds.getPassword().substring(0, siteCreds.getPassword().length() - 4));
                        }
                    }
                } catch (URNFormatException | ImagingDicomException e) {
                    logger.warn("Could not prep for direct image fetch for {} will continue with https path. msg: {}", this, e.getMessage());
                }
            }
        } catch (CannotLoadConfigurationException | TimeoutException | InterruptedException
                | ExecutionException | ImagingDicomException e) {
            logger.error("Could not load series for {} msg: {}", this, e.getMessage());
            if(logger.isDebugEnabled()){
                logger.debug("Series load failure details ", e);
            }
            throw new DDSException("Failed to load series data for " + queriedStudyUid + " call from " +
                    this.getCallingAe()+this.getCallingIp(), e);
        }
    }

    public static Map<String, Image> getImageMapFromStudy(Study study){
        Map<String, Image> ret = new HashMap<>();
        for(Series series : study.getSeries()){
            for(Image image : series.getImages()) {
                ret.put(DicomService.getImageKey(image.getImageUrn()), image);
            }
        }
        return ret;
    }

    private int calculateTotalToSend(){
        int totalImageInstances = studyMeta.getImageCount();
        StudySeriesType[] studySeriesTypes = studySerieses.getSeries();
        String dataSource = this.getStudyUrn().contains("vastudy") ? "VA" : "DOD";
        if(dataSource.equals("VA") && !getSiteCode().equals("200CRNR")){
            totalImageInstances += 1; //report
        }

        for(StudySeriesType series : studySeriesTypes) {
            String seriesMod = series.getModality();
            StudyImagesType images = series.getImages();
            if (!isValidModality(this.getCallingAe(),this.getCallingIp(),dataSource, seriesMod)) {
                logger.info("Series filtered out series with modality {}<= callingAE={} dataSource= {} for study= {}", seriesMod, this.getCallingAe(), dataSource, this.getStudyUrn());
                totalImageInstances -= series.getImages().getImages().length;
            }
            for (StudyImageType image : images.getImages()) {
                if (this.studyMeta.getSiteNumber().equals("200CRNR") &&
                        image.getImageType().equals("PDF")) {
                    logger.info("skipping cerner PDF in {}", this.getStudyUrn());
                    totalImageInstances -= 1;
                }
            }
        }
        return totalImageInstances;
    }

    private List<VixDpod> processImages() throws ImagingDicomException {
        StudySeriesType[] studySeriesTypes = null;
        List<VixDpod> dpods = new ArrayList<>();

        if (studySerieses == null) {
            logger.warn("Series Meta unretrievable for {}", this.getStudyUrn());
            return dpods;
        }else{
            studySeriesTypes = studySerieses.getSeries();
            if(studySeriesTypes == null){
                logger.warn("Series Meta unretrievable for {}", this.getStudyUrn());
                return dpods;
            }
        }
        String dataSource = this.getStudyUrn().contains("vastudy") ? "VA" : "DOD";
        long imageProcessStartTime = System.currentTimeMillis();
        int totalImageInstances = calculateTotalToSend();

        for(StudySeriesType series : studySeriesTypes){
            StudyImagesType images = series.getImages();
            String seriesMod = series.getModality();

            if (!isValidModality(this.getCallingAe(),this.getCallingIp(),dataSource, seriesMod)) {
                continue; //we need to check if this is the intended behavior, seems diametric to our instance error handling
            }

            for (StudyImageType image : images.getImages()) {
                ImageFetchDto imageFetchDto = buildImageFetchDto(image);
                if(this.studyMeta.getSiteNumber().equals("200CRNR" ) &&
                        image.getImageType().equals("PDF")){
                    continue;
                }
                imageDtos.add(imageFetchDto);

                if (imageFetchDto.getCacheTask().isCached()) {
                    cachedCount++;
                }else{
                    NetworkFetchManager.requestRemoteImage(imageFetchDto, totalImageInstances);
                    pulledCount++;
                }
                VixDpod instanceDpod = new ImageDpod((cachedCount + pulledCount), this, totalImageInstances,
                        imageFetchDto);
                dpods.add(instanceDpod);
            }
        }

        if(!siteCode.equals("200") && !siteCode.equals("200CRNR")){ //dont muck with reports for DoD, cerner reports currently only in viewer as pdf
            VixDpod reportDpod = null;
            try {
                reportDpod = buildReportDpod( totalImageInstances); //also fetches report info
            }catch (Exception e){
                logger.warn("Failed to get report for {}msg {}", this, e.getMessage());
            }
            if(reportDpod != null){
                dpods.add(reportDpod);
            }
        }

        logger.info("###=--Fetching {} studyImages({}) Cached={} Pulled={}. Took {} ms", totalImageInstances, studyMeta.getStudyId(), cachedCount, pulledCount, System.currentTimeMillis() - super.getStartMillis());
        DicomService.vistaLog(super.getStartMillis(), super.getPatientInfo().getLogIcn(), "C-MOVE", this.getCallingAe(),
                dpods.size(), dpods.size(),"DIAGNOSTIC", this.getCallingIp(), true, "",
                studyMeta.getProcedureDescription(), "Dicom C-MOVE", "", studyMeta.getStudyId(), "SCP",
                "C-MOVE", siteCode, this.getTransactionGuid(), studyMeta.getSiteNumber());
        if(logger.isDebugEnabled()){
            long imageProcessDuration = System.currentTimeMillis() - imageProcessStartTime;
            logger.debug("Internal image processing for{} took {}", studyMeta.getStudyId(), imageProcessDuration);
        }
        return dpods;
    }

    private ImageFetchDto buildImageFetchDto(StudyImageType image) throws ImagingDicomException {
        String imageUri = null;

        String diagImageUri = image.getDiagnosticImageUri();
        String refImageUri = image.getReferenceImageUri();
        if (diagImageUri != null && diagImageUri.length() > 0){
            imageUri = diagImageUri;
        }
        else {
            logger.warn(" Diagnostic not available for {}", image.getImageId());
            imageUri = refImageUri; // use ref when diag is not avail
        }
        ImageURN imageURN = null;
        ImageCacheTask imageCacheTask = null;
        try{
            imageURN = URNFactory.create(imageUri.substring(imageUri.indexOf("=")+1, imageUri.indexOf("&")));
            imageCacheTask = new ImageCacheTask(imageURN, this.getPatientInfo().getIcn());
        } catch (URNFormatException e) {
            logger.error("Failed to correctly parse an imageURN from the URI, cannot proceed with image {} msg: {}", imageUri, e.getMessage());
            throw new ImagingDicomException("Failed to create cache representation of image " + imageUri.substring(imageUri.indexOf("=")+1), e); //per John Di better to send nothing than a silently incomplete study
        } catch (ImagingDicomException e) {
            logger.error("Failed to create cache store of image {} msg: {}", imageUri, e.getMessage());
            throw new ImagingDicomException("Failed to create cache representation of image " + imageUri, e);
        }
        Image imag = null;
        if(imagesInVAStudyByIen != null) {
            imag = imagesInVAStudyByIen.get(DicomService.getImageKey(imageURN));
        }else {
            if(logger.isDebugEnabled()) {
                logger.debug("No image objects from VistA available for {}", this.getStudyUrn());
            }
        }
        if(imag == null && imagesInVAStudyByIen.keySet().size() > 0){
            logger.warn("got a null image for {} only have images for {}study has image count of {}", imageURN, imagesInVAStudyByIen.keySet().size(), studyMeta.getImageCount());
        }
        return new ImageFetchDto(this, imag, imageCacheTask, imageUri, imageURN, image.getImageType());
    }

    private static Map<String, StudyType> getStudyAndSite(Map<String, List<StudyType>> studiesBySite, String queriedStudyUid)
            throws DDSException {
        Map<String, StudyType> quickHack = new LinkedHashMap<>();
        for(Map.Entry<String, List<StudyType>> entry : studiesBySite.entrySet()){
            String entrySite = entry.getKey();
            List<StudyType> studies = entry.getValue();
            for(StudyType study : studies){
                if(study.getDicomUid() != null && study.getDicomUid().equals(queriedStudyUid)){
                    quickHack.put(entrySite, study);
                    return quickHack;
                }
            }
        }
        if(logger.isDebugEnabled()){
            printStudySiteMap(studiesBySite);
        }
        throw new DDSException("Don't have study meta for " + queriedStudyUid);
    }

    private static void printStudySiteMap(Map<String, List<StudyType>> studiesBySite){
        StringBuilder toPrint = new StringBuilder();
        for(Map.Entry<String, List<StudyType>> entry : studiesBySite.entrySet()){
            String siteCode = entry.getKey();
            for(StudyType study : entry.getValue()){
                toPrint.append(siteCode);
                toPrint.append(": urn=").append(study.getStudyId()).append(" uid=").append(study.getDicomUid())
                        .append(" desc=").append(study.getDescription());
            }
        }
        logger.debug("cached study meta is : {}", toPrint);
    }

    @Override
    public void performCFind() throws DDSException {
        if (this.getQueryLevel().equals("IMAGE")) {
            logger.info("C-FIND Image Level query. Study_uid={}", queriedStudyUid);
            performImageLevelCFindForNilRead(); //This is the only time we receive image level queries based on IOC site logging and testing for p269
        }else{
            logger.info("C-FIND Study/Series Level query. Study_uid={}", queriedStudyUid);
            performStudySpecificCFind();
        }
    }

    @Override
    public Vector<DicomPersistentObjectDescriptor> performCMove() throws DDSException {
        logger.info("###===C-MOVE starts {}", this);
        try {
            List<VixDpod> dpods = processImages();
            long endMillis = System.currentTimeMillis() - this.getStartMillis();
            logger.info("###===C-MOVE completes. C-STORE occurring next. Returning records: {} time to locate records {}", dpods.size(), endMillis);
            return new Vector<>(dpods);
        } catch (ImagingDicomException e) {
            logger.error("failed to perform C-MOVE for {} msg: {}", this, e.getMessage());
            if(logger.isDebugEnabled()){
                logger.debug("C-MOVE failure details", e);
            }
            throw new DDSException("failed to perform C-MOVE ", e);
        }
    }

    private static boolean isValidModality(String currAe, String callingIp, String dataSource, String seriesMod) {
        List<String> configModalities =  DicomService.getScpConfig().getModalityBlockList(currAe, callingIp, dataSource);

        if (configModalities == null || configModalities.size()  == 0) return true;
        if(seriesMod == null) return true;
        for(String x : configModalities) {
            if (x.toUpperCase().equalsIgnoreCase(seriesMod)) { // works even when seriesMod is null
                if(logger.isDebugEnabled()){
                    logger.debug("filtered series based on modality, caller: {}_{} modality: {}", currAe, callingIp, seriesMod);
                }
                return false;
            }
        }
        return true;
    }

    private ReportDpod buildReportDpod(int totalCount){
        try {
            String rptFlag = DicomService.getScpConfig().getAEbuildImageReport(this.getCallingAe(), this.getCallingIp());
            if (rptFlag.equalsIgnoreCase("NONE")) {
                if (logger.isDebugEnabled()){
                    logger.debug("report won't be generated as AE {} is configured as NONE for report.", this.getCallingAe());
                }
            	return null;
            }
            ReportCacheTask reportCacheTask = new ReportCacheTask(this);
            ReportFetchDto reportDto = new ReportFetchDto(this, reportCacheTask, rptFlag);
            if (reportCacheTask.isCached()) {
                cachedCount++;
            } else {
                pulledCount++;
                NetworkFetchManager.requestRemoteReport(reportDto);
            }
            return new ReportDpod((cachedCount+pulledCount), this, totalCount, reportDto);
        } catch (ImagingDicomException e) {
            logger.warn("Failed to create report DTO {} will attempt to return instances with no report ", this);
            if (logger.isDebugEnabled()){
                logger.debug("report fetch failure details ", e);
            }
            return null;
        }
    }

    private StudySeriesesType loadStudyDetail()
            throws ImagingDicomException, CannotLoadConfigurationException, ExecutionException, InterruptedException,
            TimeoutException {
        return NetworkFetchManager.getStudySeriesBlocking(this);
    }

    private void performStudySpecificCFind() throws DDSException {
        String studyUrn = PatientCFind.getStudyUrnByUid(queriedStudyUid);
        try {
            Set<String> mods = getCleanModalities(studyMeta);
            String newDesc = this.studyMeta.getDescription();
            if (this.studyMeta.getSiteAbbreviation() != null && this.studyMeta.getSiteAbbreviation().length() > 0){
                newDesc = this.studyMeta.getSiteAbbreviation() + "- " + newDesc;
            }else{
                newDesc = siteCode + "- " + newDesc;
            }
            this.lbsCFindResultCode = VixDicomDataService.sendStudyCFindResponse(this.studyMeta,mods,newDesc,this);
        } catch (DCSException | ImagingDicomException | UnsupportedEncodingException e) {
            logger.error("Failed to send study details for C-FIND {} msg{}", this, e.getMessage());
            if(logger.isDebugEnabled()){
                logger.debug("C-FIND study failure details ",e);
            }
            throw new DDSException("Failed to send study details for C-FIND ",e);
        }

        VixDicomDataService.completeCFind(getListener(), this.lbsCFindResultCode);
        long perfMillis = System.currentTimeMillis() - super.getStartMillis();
        logger.info("###===C-FIND Study/Series COMPLETE for {} returned {} in {}ms", studyUrn, studyMeta.getNumberOfSeries(), perfMillis);

        DicomService.vistaLog(super.getStartMillis(), PatientCFind.getIcnByStudyUid(queriedStudyUid), "C-FIND "
                        + this.getQueryLevel(), this.getCallingAe(), studyMeta.getNumberOfSeries(), studyMeta.getNumberOfSeries(),
                "n/a", this.getCallingIp(),false, null, String.join(",", super.getQueriedModalities()),
                "Dicom C-FIND", "", studyUrn, "SCP", "C-FIND " + this.getQueryLevel(),
                siteCode, this.getTransactionGuid(), this.getSiteCode());
    }

    private void performImageLevelCFindForNilRead() throws DDSException {
        try {
            sendReportData();
            super.getListener().findObjectsComplete(lbsCFindResultCode, null);
            VixDicomDataService.completeCFind(getListener(), this.lbsCFindResultCode);
            long perfMillis = System.currentTimeMillis() - super.getStartMillis();
            logger.info("###===C-FIND Image COMPLETE in {}", perfMillis);

            DicomService.vistaLog(super.getStartMillis(), super.getPatientInfo().getLogIcn(), "NIL IMG C-FIND",
                    this.getCallingAe(), 1, 1, "DIAGNOSTIC", this.getCallingIp(),  false, null,
                    null, "Dicom C-FIND", "", studyMeta.getStudyId(), "SCP",
                    "C-FIND(image)", siteCode, this.getTransactionGuid(), this.getSiteCode());
        } catch ( DCSException ex) {
            logger.error("IMAGE level query error: {}", ex.getMessage());
            throw new DDSException("IMAGE level query error: " + ex.getMessage());
        }
    }

    private DicomDataSet sendReportData() throws DCSException {
        DicomDataSet loaded_dataset = new DicomDataSet();
        loaded_dataset.insert(DCM.E_STUDY_INSTANCE_UID, queriedStudyUid);
        loaded_dataset.insert(DCM.E_SERIES_DESCRIPTION, "99999");
        loaded_dataset.insert(DCM.E_SERIES_NUMBER, "1");
        loaded_dataset.insert(DCM.E_MODALITY, "SR");
        loaded_dataset.insert(DCM.E_QUERYRETRIEVE_LEVEL, this.getQueryLevel());
        loaded_dataset.insert(DCM.E_NUM_SERIES_REL_INSTANCES, 1);
        loaded_dataset.insert(DCM.E_RETRIEVE_AE_TITLE, DicomService.getScpConfig().getCalledAETitle());
        lbsCFindResultCode = super.getListener().findObjectsResult(loaded_dataset, DimseStatus.PENDING);
        return loaded_dataset;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        StudyQuery that = (StudyQuery) o;

        if (!queriedStudyUid.equals(that.queriedStudyUid)) return false;
        if (!getStudyUrn().equals(that.getStudyUrn())) return false;
        if (!super.getPatientInfo().getIcn().equals(that.getPatientInfo().getIcn())) return false;
        return super.getQueriedModalities().equals(that.getQueriedModalities());
    }

    @Override
    public String toString() {
        return "StudyQuery{" +
                "studyUid='" + queriedStudyUid + '\'' +
                ", studyUrn='" + studyMeta.getStudyId() + '\'' +
                ", patientIcn='" + super.getPatientInfo().getIcn() + '\'' +
                ", queryLevel='" + this.getQueryLevel() + '\'' +
                ", callingIpAddr='" + this.getCallingIp() + '\'' +
                ", callingTitle='" + this.getCallingAe() + '\'' +
                ", transactionGuid='" + super.getTransactionGuid() + '\'' +
                ", queryType=" + super.getQueryType() +
                '}';
    }

    @Override
    public int hashCode() {
        int result = queriedStudyUid.hashCode();
        result = 31 * result + getStudyUrn().hashCode();
        result = 31 * result + super.getPatientInfo().getIcn().hashCode();
        result = 31 * result + super.getQueriedModalities().hashCode();
        return result;
    }

    public String getStudyUrn() {
        return studyMeta.getStudyId();
    }

    public String getSiteCode() {
        return siteCode;
    }

    public String getRemoteHost() {
        return remoteHost;
    }

    public String getDestinationAe() {
        return destinationAe;
    }

    public String getStudyUid() {
        return queriedStudyUid;
    }

    public StudyType getStudyInfo() {
        return this.studyMeta;
    }

    public StudySeriesesType getSeriesInfo(){
        return this.studySerieses;
    }

    private boolean isImageModalityValid(DicomPersistentObjectDescriptor dpod, String dataSource){
        try {//TODO: investigate if we need this, expensive
            DicomFileInput dfi = new DicomFileInput(dpod.persistentId());
            dfi.setReadPixelData(false);
            dfi.open();
            DicomDataSet imageHeaders = dfi.readDataSet();
            String modality = imageHeaders.getElementStringValue(DCM.E_MODALITY);
            dfi.close();
            return QueryFactory.isModalityValid(Collections.singleton(modality),super.getQueriedModalities(),this.getCallingAe(),this.getCallingIp(), dataSource);
        } catch (DCSException e) {
            logger.error("Could not parse modality from image {} msg  {}", dpod.persistentId(), e.getMessage());
            if(logger.isDebugEnabled()){
                logger.debug("modality image load failure details queried modalities are {}", String.join(",", super.getQueriedModalities()), e);
            }
            return false;
        }
    }
}
