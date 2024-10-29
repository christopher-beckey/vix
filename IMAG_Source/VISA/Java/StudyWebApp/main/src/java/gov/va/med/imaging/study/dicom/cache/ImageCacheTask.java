package gov.va.med.imaging.study.dicom.cache;

import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.dicom.exceptions.ImagingDicomException;
import gov.va.med.imaging.study.dicom.DicomService;
import org.apache.commons.io.FilenameUtils;
import gov.va.med.logging.Logger;

import java.io.File;
import java.io.FilenameFilter;
import java.util.Locale;

public class ImageCacheTask extends CacheTask{

    private final static Logger LOGGER = Logger.getLogger(ImageCacheTask.class);
    private final ImageURN imageUrn;
    private final String patientIcn;

    public ImageCacheTask(ImageURN imageUrn, String icn) throws URNFormatException, ImagingDicomException {
        if(imageUrn == null) {
            LOGGER.error("Cache Task Error: Image Urn is null cannot continue");
            throw new ImagingDicomException("Image Urn is null cannot continue");
        }
        this.imageUrn = imageUrn;
        this.patientIcn = icn;
        this.fileName = getImageCacheFileName(this.imageUrn, patientIcn);
    }

    public static String checkFileSystemForName(ImageURN imageUrn) throws ImagingDicomException, URNFormatException {

        //for VA files we can check to see if they are already on the file system, DoD images are not cached?
        //String existingFileName = getExistingVAFileName(imageUrn.getStudyId(), imageUrn.getImageId(),
        //        imageUrn.getOriginatingSiteId(), imageUrn.getPatientIdentifier(), "va-image-region");
        //if(!existingFileName.isEmpty()){ //Revisit if John Di wants us to check legacy cache
        //    return existingFileName;
        //} temporarily removed this, may revisit
        return getExistingVAFileName(imageUrn.getParentStudyURN(), imageUrn,
                imageUrn.getPatientIdentifier());
    }

    private String getImageCacheFileName(ImageURN imageUrn, String patientIcn) {

        try {
            String existingFileName = checkFileSystemForName(this.imageUrn);
            if (!existingFileName.isEmpty()) {
                return existingFileName;
            }
        }catch (ImagingDicomException | URNFormatException e){
            LOGGER.warn("Encountered exception while checking file system for {} msg: {}", imageUrn, e.getMessage());
        }

        String sfx = "-" + "%2fdicom";

        String ffname = null;
        String fileNameIcn = "icn(" + patientIcn + ")";
        String cacheDir = System.getenv("vixcache") + "\\" +"scp-region";
        if (imageUrn.isOriginVA()) {
            ffname = cacheDir + File.separator + imageUrn.getOriginatingSiteId() + File.separator + fileNameIcn
                    + File.separator + imageUrn.getGroupId() + File.separator + imageUrn.getImageId() + sfx;
        } else {
            String[] dodImageUrnParts = imageUrn.toString().split("-"); //0=urn:bhieimage:200/1=studyUid/2=seriesUid/3=instanceUid/4=modality?/5=EDIPI
            ffname = cacheDir + File.separator + imageUrn.getOriginatingSiteId() + File.separator + fileNameIcn
                    + File.separator + dodImageUrnParts[1] + File.separator + dodImageUrnParts[3] + sfx;
        }

        return ffname;
    }

    private static String getExistingVAFileName(StudyURN studyURN, ImageURN imageURN, String patientIcn) {
        String buffer = DicomService.getCacheFilePath(studyURN, patientIcn);
        File folder = new File(FilenameUtils.normalize(buffer));
        if(!folder.exists()){
            return ""; //File names cannot be predicted this way until they are on the system
        }
        File[] listFiles = folder.listFiles(new ImageFileCacheFilter(imageURN.getImageId()));
        if(listFiles == null || listFiles.length == 0){
            return "";
        }
        return listFiles[0].getAbsolutePath();
    }

    @Override
    public void run() {//cache to disk
        //revisit multithreading when this performance bottleneck warrants
    }

    public String getPatientIcn() {
        return patientIcn;
    }

    private static class ImageFileCacheFilter implements FilenameFilter {
        private String fnAbbrev = null;

        public ImageFileCacheFilter(String filename){
            this.fnAbbrev = filename.toLowerCase();
        }
        @Override
        public boolean accept(File folder, String name) {
            return name.toLowerCase(Locale.ENGLISH).startsWith(fnAbbrev);
        }
    }
}
