package gov.va.med.imaging.study.dicom.remote.image;

import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.enums.VistaImageType;
import gov.va.med.imaging.study.dicom.cache.ImageCacheTask;
import gov.va.med.logging.Logger;

public class LocalImage {
    private final Image image;
    private final String imageUri;
    private final ImageURN imageURN;
    private final ImageCacheTask imageCacheTask;
    private final String imageType;
    private final String callingAe;
    private final String callingIp;
    private final static Logger LOGGER = Logger.getLogger(LocalImage.class) ;

    public LocalImage(Image image1, String imageUri1, ImageURN imageURN1, ImageCacheTask imageCacheTask1,
                      String callingAe, String callingIp) {
        this.image = image1;
        this.imageUri = imageUri1;
        this.imageURN = imageURN1;
        this.imageCacheTask = imageCacheTask1;
        String tempIt = null;
        try {
            tempIt = VistaImageType.valueOfImageType(image.getImgType()).name();
        }catch(Exception e){
            LOGGER.warn("Failed to get imageType for image [{}] msg [{}]", image.getImageUrn(), e.getMessage());
            tempIt = "";
        }
        imageType = tempIt;
        this.callingAe = callingAe;
        this.callingIp = callingIp;
    }

    public Image getImage() {
        return image;
    }

    public String getImageUri() {
        return imageUri;
    }

    public ImageURN getImageURN() {
        return imageURN;
    }

    public ImageCacheTask getImageCacheTask() {
        return imageCacheTask;
    }

    public String getImageType() {
        return imageType;
    }

    public String getCallingAe() {
        return callingAe;
    }

    public String getCallingIp() {
        return callingIp;
    }
}
