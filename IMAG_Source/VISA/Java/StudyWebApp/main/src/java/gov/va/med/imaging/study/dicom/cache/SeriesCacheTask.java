package gov.va.med.imaging.study.dicom.cache;

import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.rest.types.StudySeriesesType;
import gov.va.med.logging.Logger;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.util.Date;

public class SeriesCacheTask extends CacheTask{

    private final String studyUrn;
    private final static Logger LOGGER = Logger.getLogger(SeriesCacheTask.class);
    private final StudySeriesesType input;

    public SeriesCacheTask(StudySeriesesType input, String studyUrn) throws CannotLoadConfigurationException {
        this.studyUrn = studyUrn;
        this.input = input;
        setFileName();
    }

    @Override
    public boolean isCached()
    { //includes cache expiration logic?
        File cf = new File(this.fileName);
        if (cf.exists() && cf.length() > 0) {
            Date fd = new Date(cf.lastModified());
            Date yd = new Date(System.currentTimeMillis() - 86400000); // 24hr old
            return fd.after(yd);
        } else {
            if(LOGGER.isDebugEnabled())
                LOGGER.debug("===isSeriesCached(metadata): VistaImagingStudySeries series metadata not cached for {}", studyUrn);
            return false;
        }
    }

    void setFileName() throws CannotLoadConfigurationException {
        String vixSiteId;
        String studyId;
        String patientId;
        if (studyUrn.indexOf("vastudy:") > 0) { // e.g.: urn:vastudy:994-71394192-1008689413V585605
            vixSiteId = studyUrn.substring(studyUrn.indexOf("vastudy:") + 8);
            studyId = vixSiteId.substring(vixSiteId.indexOf("-") + 1);
            vixSiteId = vixSiteId.substring(0, vixSiteId.indexOf("-"));
            patientId = studyId.substring(studyId.indexOf("-") + 1);
        } else {
            vixSiteId = "200";
            if (studyUrn.indexOf("bhiestudy:") > 0) { // e.g.: urn:bhiestudy:1.2.124.113532.80.22166.30969.20190219.144722.120765545-1606682812%5b1606682812%5d
                studyId = studyUrn.substring(studyUrn.indexOf("bhiestudy:") + 10);
                patientId = studyId.substring(studyId.lastIndexOf("-") + 1);
                studyId = studyId.substring(0, studyId.indexOf("-"));
                if (patientId.contains("["))
                    patientId = patientId.substring(0, patientId.indexOf("["));
                else if (patientId.contains("%5b"))
                    patientId = patientId.substring(0, patientId.indexOf("%5b"));
            } else { // urn:paid:2.16.840.1.113883.3.42.10012.100001.206-2.16.840.1.113883.3.42.10001.100001.999937-2.16.840.1.113883.3.42.10001.100001.999362_480965-VAAUSAPPCVX403C[1008689413V585605]
                studyId = studyUrn.substring(studyUrn.indexOf("paid:") + 5);
                patientId = studyId.substring(studyId.lastIndexOf("-") + 1);
                studyId = studyId.substring(studyId.indexOf("-") + 1);
                studyId = studyId.substring(0, studyId.indexOf("-"));
                patientId = patientId.substring(patientId.indexOf("[") + 1, patientId.length() - 1);
            }
        }

        String cacheDir = (System.getenv("vixcache") != null && System.getenv("vixcache").length() > 0) ?
                System.getenv("vixcache").replace("/", File.separator) : DicomService.getScpConfig().getCachedir(); // default, will come from config later

        String pidstr = patientId.contains("V") ? "icn(" + patientId + ")" : patientId;
        String org = vixSiteId.equals("200") ? "dod-metadata-region" : "va-metadata-region";
        String finalName = cacheDir + File.separator + org + File.separator + vixSiteId + File.separator + pidstr
                + File.separator + studyId + File.separator + "series.xml";
        if(LOGGER.isDebugEnabled())
            LOGGER.debug("series metadata getCacheFileName: urn={} filename={}", studyUrn, finalName);
        this.fileName = finalName;
    }

    public StudySeriesesType getFromCache() throws FileNotFoundException, JAXBException
    {
        if(!isCached()) throw new FileNotFoundException("Cannot get " + fileName + " from cache ");
        JAXBContext jaxbContext = JAXBContext
                .newInstance(StudySeriesesType.class);
        Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
        return (StudySeriesesType) jaxbUnmarshaller.unmarshal(new File(this.fileName));
    }

    @Override
    public void run() {
        if(input == null || this.isCached()) return;
        new File(this.fileName).getParentFile().mkdirs();
        try(OutputStream outputStream = new FileOutputStream(this.fileName)) {
            JAXBContext jaxbContext = JAXBContext.newInstance(StudySeriesesType.class);
            Marshaller marshaller = jaxbContext.createMarshaller();
            marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
            marshaller.marshal(this.input, outputStream);
            if(LOGGER.isDebugEnabled())
                LOGGER.debug("saveSeriesMetaToCache for {} metadata file saved to {} seriesCount={}", studyUrn, this.fileName, this.input.getSeries().length);
        } catch (Exception e) {
            LOGGER.error("saveSeriesMetaToCache got exception: {}", e);
        }
    }
}
