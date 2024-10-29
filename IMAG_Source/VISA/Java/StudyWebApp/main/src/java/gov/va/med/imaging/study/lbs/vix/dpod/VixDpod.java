package gov.va.med.imaging.study.lbs.vix.dpod;

import com.lbs.DCS.DicomPersistentObjectDescriptor;
import gov.va.med.imaging.study.dicom.query.StudyQuery;
import gov.va.med.imaging.study.dicom.remote.FetchDTO;

public class VixDpod extends DicomPersistentObjectDescriptor {
    private final int imageCount;
    private final String studyUid;
    private final int totalCount;
    private final String patientIcn;
    private final long startMillis;
    private final String destAe;
    private final String srcSiteCode;
    private final StudyQuery studyQuery;
    private final FetchDTO fetchResult;

    public VixDpod(int imageCount, StudyQuery studyQuery, int totalCount, FetchDTO fetchResult){
        this.imageCount = imageCount;
        this.studyUid = studyQuery.getStudyUid();
        this.totalCount = totalCount;
        this.patientIcn = studyQuery.getPatientInfo().getIcn();
        this.startMillis = studyQuery.getStartMillis();
        this.destAe = studyQuery.getDestinationAe();
        this.srcSiteCode = studyQuery.getSiteCode();
        this.studyQuery = new StudyQuery(studyQuery);
        this.fetchResult = fetchResult;
        this.persistentId(this.fetchResult.getCacheFileName());
    }

    @Override
    public String toString() {
        return "VixDpod{" +
                "imagesSent=" + imageCount +
                ", totalImages=" + totalCount +
                ", sent to '" + destAe + '\'' +
                ", for patient " + patientIcn + " and studyUid " + studyUid +
                '}';
    }

    public int getImageCount() {
        return imageCount;
    }

    public String getStudyUid() {
        return studyUid;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public String getPatientIcn() {
        return patientIcn;
    }

    public long getStartMillis() {
        return startMillis;
    }

    public String getDestAe() {
        return destAe;
    }

    public String getSrcSiteCode() {
        return srcSiteCode;
    }

    public StudyQuery getStudyQuery() {
        return studyQuery;
    }

    public FetchDTO getFetchResult() {
        return fetchResult;
    }
}
