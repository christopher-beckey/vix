function ImageInfoManager(imageInfo) {
    this.imageInfo = JSON.parse(imageInfo);
    this.imageInfo.brightness = 100;
    this.imageInfo.contrast = 100;
}

ImageInfoManager.prototype.getWindowWidth = function () {
    return this.imageInfo.windowWidth;
};

ImageInfoManager.prototype.getWindowCenter = function () {
    return this.imageInfo.windowCenter;
};

ImageInfoManager.prototype.getBrightness = function () {
    return this.imageInfo.brightness;
};

ImageInfoManager.prototype.getContrast = function () {
    return this.imageInfo.contrast;
};

ImageInfoManager.prototype.getRescaleSlope = function () {
    return this.imageInfo.decimalRescaleSlope;
};

ImageInfoManager.prototype.getRescaleIntercept = function () {
    return this.imageInfo.decimalRescaleIntercept;
};

ImageInfoManager.prototype.getMaxPixelValue = function () {
    return this.imageInfo.maxPixelValue;
};

ImageInfoManager.prototype.getMinPixelValue = function () {
    return this.imageInfo.minPixelValue;
};

ImageInfoManager.prototype.setMaxPixelValue = function (maxPixelValue) {
    this.imageInfo.maxPixelValue = maxPixelValue;
};

ImageInfoManager.prototype.setMinPixelValue = function (minPixelValue) {
    this.imageInfo.minPixelValue = minPixelValue;
};

ImageInfoManager.prototype.isColor = function () {
    return this.imageInfo.isColor;
};

ImageInfoManager.prototype.isSigned = function () {
    return this.imageInfo.isSigned;
};

ImageInfoManager.prototype.isPlanar = function () {
    return this.imageInfo.isPlanar;
};

ImageInfoManager.prototype.getSamplesPerPixel = function () {
    return this.imageInfo.samplesPerPixel;
};

ImageInfoManager.prototype.getPlanarConfiguration = function () {
    return this.imageInfo.planarConfiguration;
};

ImageInfoManager.prototype.getPixelRepresentation = function () {
    return this.imageInfo.pixelRepresentation;
};

ImageInfoManager.prototype.getPhotometricInterpretation = function () {
    return this.imageInfo.photometricInterpretation;
};

ImageInfoManager.prototype.getFrameSize = function () {

    return this.imageInfo.frameSize;
};

ImageInfoManager.prototype.getNumberOfFrames = function () {
    return this.imageInfo.numberOfFrames;
};

ImageInfoManager.prototype.getColumns = function () {
    return this.imageInfo.imageWidth;
};
ImageInfoManager.prototype.setColumns = function (columns) {
    this.imageInfo.imageWidth = columns;
};
ImageInfoManager.prototype.getRows = function () {
    return this.imageInfo.imageHeight;
};
ImageInfoManager.prototype.setRows = function (rows) {
    this.imageInfo.imageHeight = rows;
};
ImageInfoManager.prototype.getHighBit = function () {
    return this.imageInfo.highBit;
};

ImageInfoManager.prototype.getBitsStored = function () {
    return this.imageInfo.bitsStored;
};

ImageInfoManager.prototype.getBitsAllocated = function () {
    return this.imageInfo.bitsAllocated;
};

ImageInfoManager.prototype.getBitDepth = function () {
    return this.imageInfo.highBit + 1;
};

ImageInfoManager.prototype.getPatientName = function () {
    return this.imageInfo.patientName;
};

ImageInfoManager.prototype.getStudyDate = function () {
    return this.imageInfo.studyDate;
};

ImageInfoManager.prototype.getStudyTime = function () {
    return this.imageInfo.studyTime;
};

ImageInfoManager.prototype.getAccessionNumber = function () {
    return this.imageInfo.accessionNumber;
};

ImageInfoManager.prototype.getManufacturer = function () {
    return this.imageInfo.manufacturer;
};

ImageInfoManager.prototype.getInstanceNumber = function () {
    return this.imageInfo.instanceNumber;
};

ImageInfoManager.prototype.getIsCompressed = function () {
    return this.imageInfo.isCompressed;
};

ImageInfoManager.prototype.getDirectionalMarkers = function () {
    return this.imageInfo.directionalMarkers;
};
ImageInfoManager.prototype.getCompressionMethod = function () {
    return this.imageInfo.compressionMethod;
};
ImageInfoManager.prototype.getUSRegions = function () {

    if ((this.imageInfo.measurement != null) && (this.imageInfo.measurement.usRegions != null)) {
        return this.imageInfo.measurement.usRegions;
    }

    return undefined;
};
ImageInfoManager.prototype.getContentTime = function () {
    var contentTime = this.imageInfo.contentTime;
    if (contentTime == undefined || contentTime == null) {
        contentTime = "";
    }

    return contentTime;
};

ImageInfoManager.prototype.getContentDate = function () {
    var contentDate = this.imageInfo.contentDate;
    if (contentDate == undefined || contentDate == null) {
        contentDate = "";
    }

    return contentDate;
};

ImageInfoManager.prototype.getModality = function () {
    var modality = this.imageInfo.modality;
    if (modality == undefined || modality == null) {
        modality = "";
    }

    return modality;
};
