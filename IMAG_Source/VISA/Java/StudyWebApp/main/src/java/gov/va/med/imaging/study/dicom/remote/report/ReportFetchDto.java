package gov.va.med.imaging.study.dicom.remote.report;

import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.study.dicom.cache.ReportCacheTask;
import gov.va.med.imaging.study.dicom.remote.FetchDTO;
import gov.va.med.imaging.study.dicom.query.StudyQuery;

import java.util.Date;

public class ReportFetchDto extends FetchDTO {
    private String studyUrn;
    private final String studyUid;
    private final String patientId;
    private final String patientSsn;
    private final String patientName;
    private final Date procedureDate;
    private final String patientDob;
    private final String modality;
    private final String accessionNumber;
    private final String seriesUid;
    private final String studyDescription;
    private final boolean buildSc;
    private final String callingAe;
    private final String callingIp;
    private final String transId;

    public ReportFetchDto(StudyQuery query, ReportCacheTask cacheTask, String buildSc) throws ImagingDicomException {
        super(query, cacheTask, null);
        this.studyUid = query.getStudyUid();
        this.studyUrn = query.getStudyUrn();
        this.patientId = query.getPatientInfo().getIcn();
        this.patientSsn = query.getPatientInfo().getSsn();
        this.patientName = query.getStudyInfo().getPatientName();
        this.procedureDate = query.getStudyInfo().getProcedureDate();
        this.accessionNumber = query.getStudyInfo().getAccessionNumber();
        this.patientDob = query.getPatientInfo().getDob();
        this.modality = query.getStudyInfo().getProcedureDescription();
        this.seriesUid = query.getSeriesInfo().getSeries()[0].getSeriesUid();
        this.studyDescription = query.getStudyInfo().getDescription();
        this.buildSc = buildSc.equalsIgnoreCase("SC");
        this.callingAe = query.getCallingAe();
        this.callingIp = query.getCallingIp();
        this.transId = query.getTransactionGuid();
    }

    public String getStudyUrn() {
        return studyUrn;
    }

    public void setStudyUrn(String studyUrn) {
        this.studyUrn = studyUrn;
    }

    public String getStudyUid() {
        return studyUid;
    }

    public String getPatientId() {
        return patientId;
    }

    public String getPatientSsn() {
        return patientSsn;
    }

    public String getPatientName() {
        return patientName;
    }

    public Date getProcedureDate() {
        return procedureDate;
    }

    public String getPatientDob() {
        return patientDob;
    }

    public String getModality() {
        return modality;
    }

    public String getSeriesUid() {
        return seriesUid;
    }

    public String getStudyDescription() {
        return studyDescription;
    }

    public String getFileName() {
        return super.getCacheTask().getFileName();
    }

    public String getAccessionNumber() {
        return accessionNumber;
    }

    @Override
    public String toString() {
        return "StudyReportDto{" +
                "studyUrn='" + studyUrn + '\'' +
                ", studyUid='" + studyUid + '\'' +
                ", patientId='" + patientId + '\'' +
                ", patientSsn='" + patientSsn + '\'' +
                ", patientName='" + patientName + '\'' +
                ", procedureDate=" + procedureDate +
                ", patientDob='" + patientDob + '\'' +
                ", modality='" + modality + '\'' +
                ", accessionNumber='" + accessionNumber + '\'' +
                ", seriesUid='" + seriesUid + '\'' +
                ", studyDescription='" + studyDescription + '\'' +
                ", fileName='" + getFileName() + '\'' +
                ", buildSc=" + buildSc +
                '}';
    }

    public boolean isBuildSc() {
        return buildSc;
    }

    public String getCallingAe() {
        return callingAe;
    }

    public String getCallingIp() {
        return callingIp;
    }

    public String getTransId() {
        return transId;
    }
}
