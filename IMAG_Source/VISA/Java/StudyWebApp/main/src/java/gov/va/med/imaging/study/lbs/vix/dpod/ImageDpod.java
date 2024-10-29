package gov.va.med.imaging.study.lbs.vix.dpod;

import gov.va.med.imaging.study.dicom.remote.image.ImageFetchDto;
import gov.va.med.imaging.study.dicom.query.StudyQuery;

public class ImageDpod extends VixDpod {

    public ImageDpod(int imageCount, StudyQuery studyQuery, int totalCount, ImageFetchDto imageFetchDto){
        super(imageCount, studyQuery, totalCount, imageFetchDto);
    }

    @Override
    public ImageFetchDto getFetchResult() {
        return (ImageFetchDto) super.getFetchResult();
    }
}
