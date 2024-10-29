package gov.va.med.imaging.study.dicom.cache;

import gov.va.med.URNFactory;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.query.StudyQuery;
import gov.va.med.logging.Logger;

import java.io.File;

public class ReportCacheTask extends CacheTask{

    private static final Logger logger = Logger.getLogger(StudyQuery.class);

    private final StudyURN studyUrn;
    private final String patientIcn;
    private final String callingAe;
    private final String callingIp;

    public ReportCacheTask(StudyQuery studyQuery) throws ImagingDicomException {
        try {
            this.studyUrn = URNFactory.create(studyQuery.getStudyUrn()); //TODO: save it in studyquery vs. parse twice
        } catch (URNFormatException e) {
            throw new ImagingDicomException("Failed to parse studyUrn while creating report cache task " + studyQuery.getStudyUrn() );
        }
        this.patientIcn = studyQuery.getPatientInfo().getIcn();
        this.callingAe = studyQuery.getCallingAe();
        this.callingIp = studyQuery.getCallingIp();
        this.fileName = formFileName();
    }

    public String formFileName(){
        if (studyUrn == null || !studyUrn.isOriginVA() || studyUrn.getOriginatingSiteId().equals("200CRNR")) {
            logger.warn("Attempted to create a report for a non valid study URN {}", studyUrn);
            return null;
        }
        String cacheDir = null;
        if (System.getenv("vixcache") != null && System.getenv("vixcache").length() > 0) {
            cacheDir = System.getenv("vixcache").replace("/", File.separator);
        } else {
            cacheDir = "C:" + File.separator+"VixCache";
        }

        // when this Task is called, fname won't be NONE.
        String fname = DicomService.getScpConfig().getAEbuildImageReport(callingAe, callingIp);
        String icn  = "icn(" + patientIcn + ")";

        return cacheDir + File.separator + "scp-region" + File.separator + studyUrn.getOriginatingSiteId() +
                File.separator + icn + File.separator + studyUrn.getGroupId() + File.separator + fname + "_report.dcm";
    }

    @Override
    public void run() {
        //not implemented yet
    }

}
