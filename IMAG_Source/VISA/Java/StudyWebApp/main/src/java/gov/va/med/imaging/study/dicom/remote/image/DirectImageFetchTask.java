package gov.va.med.imaging.study.dicom.remote.image;

import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.vista.ImageStorageShare;
import gov.va.med.logging.Logger;

public class DirectImageFetchTask extends ImageFetchTask{

    private final Image image;
    private final static Logger LOGGER = Logger.getLogger(DirectImageFetchTask.class);
    private final String imageType;
    private final String callingAe;
    private final String callingIp;

    public DirectImageFetchTask(LocalImage img){
        super(img.getImageUri(), img.getImageCacheTask(),"localhost",DicomService.getSiteInfo().getSiteCode());
        this.image = img.getImage();
        this.imageType = img.getImageType();
        this.callingAe = img.getCallingAe();
        this.callingIp = img.getCallingIp();
    }

    public DirectImageFetchTask(ImageFetchDto imageFetchDto){
        super(imageFetchDto.getImageUri(),imageFetchDto.getCacheTask(), imageFetchDto.getRemoteHost(),
                imageFetchDto.getRemoteSiteCode());
        this.image = imageFetchDto.getImage();
        imageType = imageFetchDto.getImageType();
        this.callingIp = imageFetchDto.getCallingIp();
        this.callingAe = imageFetchDto.getCallingAe();
    }

    @Override
    public String call(){
        String localCacheFileName = null;
        if(image != null && image.getFullFilename() != null && !cacheTask.isCached() &&
                imageType.equals("DICOM") && DicomService.getScpConfig().useDirectFetch() &&
                !image.getSiteNumber().contains("200")){
            LOGGER.debug("Direct Image Fetch: {} to {}", image.getFullFilename(), cacheTask.getFileName());
            ImageStorageShare imageStorageShare = new ImageStorageShare(image,callingIp,callingAe,remoteSiteNumber,cacheTask);
            try {
                localCacheFileName = imageStorageShare.cacheImage();
            } catch (Exception e) {
                LOGGER.error("Failed to cache image from share {} msg: {}",image.getFullFilename(), e.getMessage());
                LOGGER.error("Cache failure details ", e);
            }
        }else if(!cacheTask.isCached()){
            LOGGER.debug("Did not attempt direct fetch for image {} image is cached {} image type {} use direct fetch {}",
                    image, cacheTask.isCached(), imageType, DicomService.getScpConfig().useDirectFetch());
        }
        if(localCacheFileName == null || localCacheFileName.isEmpty() || !cacheTask.isCached()){
            return super.call();
        }
        return localCacheFileName;
    }
}
