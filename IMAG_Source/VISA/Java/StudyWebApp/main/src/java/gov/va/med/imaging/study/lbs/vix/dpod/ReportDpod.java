package gov.va.med.imaging.study.lbs.vix.dpod;

import gov.va.med.imaging.study.dicom.query.StudyQuery;
import gov.va.med.imaging.study.dicom.remote.report.ReportFetchDto;

public class ReportDpod extends VixDpod {

    private final ReportFetchDto reportFetchResult;

    public ReportDpod(int imageCount, StudyQuery studyQuery, int totalCount, ReportFetchDto reportFetchResult){
        super(imageCount,studyQuery, totalCount, reportFetchResult);
        this.reportFetchResult = reportFetchResult;
        this.persistentId(reportFetchResult.getFileName());
    }

    @Override
    public ReportFetchDto getFetchResult() {
        return reportFetchResult;
    }
}
