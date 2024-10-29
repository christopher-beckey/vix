var dicomViewer = (function (dicomViewer) {

    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var studyDetailsHolder = {};
    var listOfStudyUid = [];
    var reOrderedStudyUidList = [];

    /**
     *@param studyDeatils
     *set the study details to the studyDetailsHolder variable
     */
    function setStudyDetails(studyDeatils) {
        if (studyDeatils === undefined) {
            throw "StduyDeatils is undefined";
        }
        var studyUid = studyDeatils.studyUid;
        studyDetailsHolder[studyUid] = studyDeatils;
        listOfStudyUid[listOfStudyUid.length] = studyUid;
        addOrRemoveReOrderedStudyUid(studyUid, true);
    }

    /**
     *Get the study detail from the studyDetailsHolder variable
     */
    function getStudyDetails(studyUid) {
        return studyDetailsHolder[studyUid];
    }

    /**
     *Get the study id from the study detail
     */
    function getStudyId() {
        return studyDetailsHolder.studyId;
    }

    /**
     *Get the study id from the study detail
     */
    function getStudyUid() {
        return studyDetailsHolder.studyUid;
    }

    /**
     *@param seriesIndex
     *Get the series object based on the series index
     */
    function getSeries(studyUid, seriesIndex, imageIndex) {
        if (seriesIndex === undefined) {
            throw "Series Index is null/undefined";
        }

        var study = studyDetailsHolder[studyUid];
        if (study) {
            if (imageIndex !== undefined && study.isGeneral && study[0].imageType == IMAGETYPE_JPEG && study[seriesIndex].numberOfFrames > 1) {
                return study[seriesIndex]; //VAI-307 This was selecting the series not the image page frame index. imageIndex;
            } else if (study.series !== undefined) {
                var series = study.series[seriesIndex];
                if (!series && study.hasMutiframeImages) {
                    series = study.series[0];
                }
                return series;
            } else {
                 //Series Change AKA new image document selected by user (NEW PAGE) VAI-307
                var imageFile = study[seriesIndex].cacheLocator;
                if (imageFile.includes("Tiff;"))
                {
                    var isPageReady = PdfRequest.arePrintAndExportReady;
                    if (!isPageReady) {
                        var imageUid = study[seriesIndex].imageUid;
                        if (PdfRequest.findRequestStatus(imageUid) == PdfRequest.Status.complete)
                            isPageReady = true;
                    }
                    if (isPageReady == true)
                        showPrintAndExport(true);
                    else
                        showPrintAndExport(false);
                } else {
                    if (imageFile.includes("Jpeg;"))
                        showPrintAndExport(true);
                    else
                        showPrintAndExport(false);
                }
                return study[seriesIndex];
            }

        }

        return undefined;
    }

    /**
     *Get the series count from the study detail
     */
    function getSeriesCount(studyUid) {
        return getStudyDetails(studyUid).seriesCount;
    }

    /**
     *@param seriesIndex
     *get the image count based on the series index
     */
    function getImageCount(studyUid, seriesIndex) {
        var series;
        try {
            series = getSeries(studyUid, seriesIndex);
        } catch (e) {
            series = undefined;
        }
        if (series !== undefined)
            return series.imageCount;
        else
            return 0;
    }

    /**
     *@param seriesIndex
     *@param imageIndex
     *Get the image based on the series index and image index
     */
    function getImage(studyUid, seriesIndex, imageIndex) {

        if (imageIndex === undefined) {
            throw "Image Index is null/undefined"
        }
        if (getSeries(studyUid, seriesIndex) !== undefined)
            if (getSeries(studyUid, seriesIndex).images !== undefined) {
                return getSeries(studyUid, seriesIndex).images[imageIndex];
            } else {
                return getSeries(studyUid, seriesIndex, imageIndex);
            }
        else
            return undefined;
    }
    /**
     *@param seriesIndex
     *@param imageIndex
     *Get all images of the particular series
     */
    function getAllImages(studyUid, seriesIndex) {

        if (seriesIndex === undefined) {
            throw "Series Index is null/undefined"
        }

        return getSeries(studyUid, seriesIndex).images;
    }

    /*function getSerieIndex(studyUid, imageId)
    {
        var series = getSeriesCount(studyUid);
        for (var key in series.images)
        {
            if( series.images[key].imageId == imageId)
            {
                return key
            }
        }
        
        return -1;
    }
*/
    function getImageIndex(studyUid, seriesIndex, imageUid) {
        var series = getSeries(studyUid, seriesIndex);

        if (!series) {
            return -1;
        }

        // Get the non dicom image index 
        if (isDicomStudy(studyUid) === false && series !== undefined && series !== null) {
            if (series.imageCount == 1) {
                return 0;
            }
        }

        for (var key in series.images) {
            if (series.images[key].imageUid == imageUid) {
                return key
            }
        }

        return -1;
    }

    /**
     *@param image
     *Get image id based on the image
     */
    function getImageId(image) {
        if (image === undefined) {
            throw "image is null/undefined"
        }

        return image.imageId;
    }

    /**
     *@param image
     *Get the frame count based on the image
     */
    function getImageFrameCount(image) {
        if (image === undefined) {
            throw "image is null/undefined";
        }
        if (image.numberOfFrames !== undefined) {
            if (image.numberOfFrames === 0) {
                image.numberOfFrames += 1;
            }
            return image.numberOfFrames;
        }

        // Checking image info already cached or not
        var header = dicomViewer.header.getDicomHeader(dicomViewer.Series.Image.getImageUid(image));
        if (header === undefined) {
            return undefined;
        }
        image.numberOfFrames = header.getNumberOfFrames();

        if (image.numberOfFrames === undefined) {
            image.numberOfFrames = 1;
        }

        return image.numberOfFrames;
    }

    /**
     *@param seriesIndex
     *Get the modality based on the series index
     */
    function getModality(studyUid, seriesIndex) {
        if (seriesIndex === undefined) {
            throw "seriesIndex is null/undefined"
        }
        var series = getSeries(studyUid, seriesIndex);
        if (series == undefined) {
            return "";
        }
        return series.modality;
    }

    function getSeriesDescription(studyUid, seriesIndex) {
        if (studyUid === undefined) return "";
        var series = getSeries(studyUid, seriesIndex)
        if (series === undefined || series == null) {
            return "";
        }

        return series.description;
    }

    /**
     *@param image
     *get the instance number based on the image
     */
    function getInstanceNumber(image) {
        if (image === undefined) {
            throw "image is null/undefined"
        }
        if (image.instanceNumber !== undefined) {
            return image.instanceNumber;
        }
        // Checking image info already cached or not
        var header = dicomViewer.header.getDicomHeader(dicomViewer.Series.Image.getImageUid(image));
        if (header === undefined) {
            return undefined;
        }
        image.instanceNumber = header.getInstanceNumber();

        return image.instanceNumber;
    }

    /**
     *@param image
     *Get image id based on the image
     */
    function getImageUid(image) {
        if (image === undefined) {
            throw "image is null/undefined"
        }

        return image.imageUid;
    }

    function getListOfStudyUid(isResize) {
        if (reOrderedStudyUidList !== undefined && reOrderedStudyUidList !== null) {
            if (reOrderedStudyUidList.length > 0 && (reOrderedStudyUidList.length == listOfStudyUid.length || isResize)) {
                return reOrderedStudyUidList;
            }
        }

        return listOfStudyUid;
    }

    function removeStudyDetails(studyUid) {
        delete studyDetailsHolder[studyUid];
        var listOfstudyLength = listOfStudyUid.length;
        for (var index = 0; listOfstudyLength > index; index++) {
            var studyUidInList = listOfStudyUid[index]
            if (studyUid === studyUidInList) {
                listOfStudyUid.splice(index, 1);
                addOrRemoveReOrderedStudyUid(studyUid, false);
                dicomViewer.imageCache.clearCache(studyUid);
            }
        }
    }

    function isImageAvilable(studyUid, selectedImageUid) {
        if (studyUid !== undefined) {
            var seriesCount = getSeriesCount(studyUid)
            for (var index = 0; seriesCount > index; index++) {
                var allImages = getAllImages(studyUid, index);
                for (var imageIndex in allImages) {
                    var image = allImages[imageIndex];
                    var imageUid = getImageUid(image);
                    if (selectedImageUid === imageUid) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    /**
     * Check whether the given study is dicom or not
     * @param {Type} studyUid - Specifies the Study Uid
     */
    function isDicomStudy(studyUid) {
        var isDicom = false;
        var studyDetails = getStudyDetails(studyUid);
        if (studyDetails !== undefined) {
            isDicom = studyDetails.isDicom;
        }

        return isDicom;
    }

    /**
     * Check whether the given series is dicom or not
     * @param {Type} studyUid - Specifies the Study Uid
     * @param {Type} seriesIndex - Specifies the series index
     */
    function isDicomSeries(studyUid, seriesIndex) {
        var isDicom = false;
        var series = getSeries(studyUid, seriesIndex);
        if (series !== undefined) {
            isDicom = series.isDicom;
        }

        return isDicom;
    }

    /**
     * Set the reorder studyUids
     * @param {Type} reOrderedStudyUids - Specifies the reorder studyUids
     * @param {Type} isClear - Flag to clear the list
     */
    function setReOrderedStudyUids(reOrderedStudyUids, isClear) {
        try {
            if (isClear) {
                reOrderedStudyUidList = [];
            } else {
                reOrderedStudyUidList = reOrderedStudyUids;
            }
        } catch (e) {}
    }

    /**
     * Add or remove the studyUid from the reorder list
     * It will call while adding study with an existing session or close the revewport 
     * @param {Type} studyUid - Specifies the studyUid
     * @param {Type} isAdd - Flag to add/remove the studyUid from array
     */
    function addOrRemoveReOrderedStudyUid(studyUid, isAdd) {
        try {
            var index = reOrderedStudyUidList.indexOf(studyUid);
            if (isAdd && reOrderedStudyUidList.length > 0 && index == -1) {
                reOrderedStudyUidList.push(studyUid);
            } else if (!isAdd && index > -1) {
                reOrderedStudyUidList.splice(index, 1);
            }
        } catch (e) {}
    }

    /**
     * Reset the study details
     */
    function resetStudy() {
        reOrderedStudyUidList = [];
        listOfStudyUid = [];
    }

    /**
     * Get the image Urn
     * @param {Type} studyUid - Specifies the study Uid
     * @param {Type} seriesIndex - Specifies the series index
     * @param {Type} imageIndex - Specifies the image index
     */
    function getImageUrn(studyUid, seriesIndex, imageIndex) {
        var image = getImage(studyUid, seriesIndex, imageIndex);
        if (image) {
            return image.imageUrn;
        }

        return undefined;
    }

    function getImageFilePath(studyUid, seriesIndex, imageUid) {
        var series = getSeries(studyUid, seriesIndex);
        if (!series) {
            return -1;
        }

        if (!series.images) {
            return series.cacheLocator;
        }

        for (var key in series.images) {
            if (series.images[key].imageUid == imageUid) {
                return (!series.images[key].cacheLocator) ? "" : series.images[key].cacheLocator;
            }
        }

        return -1;
    }

    dicomViewer.setStudyDetails = setStudyDetails;
    dicomViewer.getStudyDetails = getStudyDetails;
    dicomViewer.getListOfStudyUid = getListOfStudyUid;
    dicomViewer.removeStudyDetails = removeStudyDetails;
    dicomViewer.isImageAvilable = isImageAvilable;
    dicomViewer.isDicomStudy = isDicomStudy;
    dicomViewer.isDicomSeries = isDicomSeries;
    dicomViewer.setReOrderedStudyUids = setReOrderedStudyUids;
    dicomViewer.resetStudy = resetStudy;
    dicomViewer.Study = {
        getSeriesCount: getSeriesCount,
        getStudyId: getStudyId,
        getStudyUid: getStudyUid
    };
    dicomViewer.Series = {
        getSeries: getSeries,
        getImageCount: getImageCount,
        getAllImages: getAllImages,
        Image: {
            getImageIndex: getImageIndex,
            getImage: getImage,
            getImageUid: getImageUid,
            getImageId: getImageId,
            getImageFrameCount: getImageFrameCount,
            getInstanceNumber: getInstanceNumber,
            getImageUrn: getImageUrn,
            getImageFilePath: getImageFilePath
        },
        getModality: getModality,
        getSeriesDescription: getSeriesDescription
    };

    return dicomViewer;
}(dicomViewer));
