package gov.va.med.imaging.study.dicom.remote.image;

import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.study.dicom.cache.ImageCacheTask;
import gov.va.med.imaging.study.dicom.remote.FetchDTO;
import gov.va.med.imaging.study.dicom.query.StudyQuery;

public class ImageFetchDto extends FetchDTO {

    private final Image image; //nullable, only get these for VistA-homed images
    private final ImageURN imageURN;
    private final String imageType;
    private final String remoteSiteCode;
    private final String cacheFileName;
    private final String imageUri;
    private final String patientIcn;
    private final String callingAe;
    private final String callingIp;
    private final String remoteHost;
    private final ImageCacheTask cacheTask;

    public ImageFetchDto(Image image, ImageCacheTask imageCacheTask, String imageUri,
                         ImageURN imageURN, String imageType, String callingAe, String callingIp, String icn, String remoteSiteCode,
                         String remoteHost){
        super(null, imageCacheTask, imageUri);
        this.image = image;
        this.cacheTask = imageCacheTask;
        this.imageUri = imageUri;
        this.imageURN = imageURN;
        this.imageType = imageType;
        this.callingAe = callingAe;
        this.callingIp = callingIp;
        this.patientIcn = icn;
        this.remoteSiteCode = remoteSiteCode;
        this.remoteHost = remoteHost;
        this.cacheFileName = cacheTask.getFileName();
    }

    public ImageFetchDto(StudyQuery studyQuery, Image image, ImageCacheTask imageCacheTask, String imageUri,
                         ImageURN imageURN, String imageType){
        super(studyQuery, imageCacheTask, imageUri);
        this.image = image;
        this.imageURN = imageURN;
        this.imageType = imageType;
        this.patientIcn = super.getQuery().getPatientInfo().getIcn();
        this.callingAe = super.getQuery().getCallingAe();
        this.callingIp = super.getQuery().getCallingIp();
        this.cacheTask = imageCacheTask;
        this.imageUri = imageUri;
        this.cacheFileName = imageCacheTask.getFileName();
        this.remoteSiteCode = studyQuery.getSiteCode();
        this.remoteHost = studyQuery.getRemoteHost();
    }


    @Override
    public String toString() {
        return "ImageFetchDto{" +
                "imageUri='" + super.getStringURL() + '\'' +
                ", imageURN=" + imageURN +
                ", imageCacheFile="+this.getCacheFileName() +
                ", imageType= " +this.getImageType()+
                '}';
    }

    public String getImageType() {
        return imageType;
    }

    public String getRemoteSiteCode() {
        return remoteSiteCode;
    }

    public Image getImage() {
        return image;
    }

    public ImageURN getImageURN() {
        return imageURN;
    }

    @Override
    public String getCacheFileName() {
        return cacheFileName;
    }

    public String getImageUri() {
        return imageUri;
    }

    public String getPatientIcn() {
        return patientIcn;
    }

    public String getCallingAe() {
        return callingAe;
    }

    public String getCallingIp() {
        return callingIp;
    }

    public String getRemoteHost() {
        return remoteHost;
    }

    @Override
    public ImageCacheTask getCacheTask() {
        return cacheTask;
    }
}
