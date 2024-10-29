package gov.va.med.imaging.study.dicom.cache;

import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.rest.types.StudiesResultType;
import gov.va.med.logging.Logger;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;

public class StudyCacheTask extends CacheTask{
    private final String vixSiteId;
    private final String patientIcn;
    private final StudiesResultType input;
    private final static Logger LOGGER = Logger.getLogger(StudyCacheTask.class);

    public StudyCacheTask(StudiesResultType studyResultType, String vixSiteId, String patientIcn) throws CannotLoadConfigurationException {
        this.input = studyResultType;
        this.vixSiteId = vixSiteId;
        this.patientIcn = patientIcn;
        setFileName();
    }

    @Override
    public void run()
    { //used to save to cache
        if(input == null || isCached()) return;
        new File(this.getFileName()).getParentFile().mkdirs();
        try( OutputStream outputStream = new FileOutputStream(this.getFileName())) {
            JAXBContext jaxbContext = JAXBContext.newInstance(StudiesResultType.class);
            Marshaller marshaller = jaxbContext.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
            marshaller.marshal(this.input, outputStream);
            if(LOGGER.isDebugEnabled())
                LOGGER.debug("studies for {} at site {} metadata file saved to {} studyCount={}", patientIcn, vixSiteId, this.getFileName(), ((StudiesResultType) this.input).getSize());
        } catch (Exception e) {
            LOGGER.error("saving study metadata got exception: {}", e.getMessage());
            if(LOGGER.isDebugEnabled()) LOGGER.debug("saving study metadata got exception: ", e);
        }
    }

    void setFileName() throws CannotLoadConfigurationException {
        String cacheDir = (System.getenv("vixcache") != null && System.getenv("vixcache").length() > 0) ?
                System.getenv("vixcache").replace("/", File.separator) : DicomService.getScpConfig().getCachedir();
        String org = vixSiteId.equals("200") ? "dod-metadata-region" : "va-metadata-region";
        String pidstr = "icn(" + patientIcn + ")";
        this.fileName = cacheDir + File.separator + org + File.separator + vixSiteId + File.separator + pidstr
                + File.separator + "studies.xml";
    }

    public StudiesResultType getFromCache() throws Exception
    { //TODO: investigate streaming this from file system to client, not currently possible with JaxB and relatively small gains
        if(!isCached()) throw new Exception(this.getFileName() + " is not currently cached");
        JAXBContext jaxbContext = JAXBContext
                .newInstance(StudiesResultType.class);
        Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
        return (StudiesResultType) jaxbUnmarshaller.unmarshal(new File(this.getFileName()));
    }
}
