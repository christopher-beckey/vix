package gov.va.med.imaging.study.dicom.remote.report;

import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.report.TextImage;
import gov.va.med.imaging.study.rest.StudyService;
import gov.va.med.logging.Logger;

import java.util.concurrent.Callable;

public class ReportFetchTask implements Callable<String> {
    private static final Logger LOGGER = Logger.getLogger(ReportFetchTask.class);
    private final ReportFetchDto studyReportDto;

    public ReportFetchTask(ReportFetchDto reportFetchDto){
        this.studyReportDto = reportFetchDto;
    }

    private void scpCreateSRFile(String reportText) {
        try {
            String fnwoext = studyReportDto.getFileName().substring(0, studyReportDto.getFileName().lastIndexOf("."));
            new TextImage().createReportArtifact(fnwoext, reportText, studyReportDto.getPatientName(),
                    studyReportDto.getPatientId(), studyReportDto.getPatientSsn(), studyReportDto.getProcedureDate(),
                    studyReportDto.getPatientDob(), studyReportDto.getModality(),studyReportDto.getStudyUrn(),
                    studyReportDto.getStudyUid(), studyReportDto.getAccessionNumber(), studyReportDto.getSeriesUid(), studyReportDto.getStudyDescription(),
                    studyReportDto.isBuildSc(), studyReportDto.getTransId());
        } catch (Exception e) {
            LOGGER.error("scpCreateSRFile exception: {}", e.getMessage());
        }
    }

    @Override
    public String call() throws Exception {
        DicomService.prepareTransactionContext(studyReportDto.getTransId());
        String rpt = new StudyService().getStudyReport(studyReportDto.getStudyUrn()).getValue();
        scpCreateSRFile(rpt);
        return studyReportDto.getFileName();
    }
}
