package gov.va.med.imaging.study.web;

import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.remote.NetworkFetchManager;
import gov.va.med.imaging.study.lbs.DicomScp;
import gov.va.med.imaging.study.lbs.VixDicomDataService;
import gov.va.med.logging.Logger;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class StudyServletContextListener implements ServletContextListener {
    private final Logger logger = Logger.getLogger(this.getClass());
    @Override
    public void contextInitialized(ServletContextEvent servletContextEvent) {
        String toLog = DicomScp.start();
        logger.info("***********************************************************");
        logger.info("*        in Study ServletContextListener init()           *");
        logger.info("***********************************************************");
        logger.info("gov.va.med.imaging.study.lbs.DicomScp.start()={}", toLog);
        DicomService dicomService = new DicomService();
    }

    @Override
    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        DicomScp.stop();
        NetworkFetchManager.shutdownServices();
        VixDicomDataService.shutdownServices();
        DicomService.shutDownFdt();
    }
}
