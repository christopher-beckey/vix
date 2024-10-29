function DicomMetaInfoReader() {
    this.dicomTags = new Object();
    this.referenceString;
};

DicomMetaInfoReader.prototype.loadDICOMInfo = function (returnString) {

    returnString = JSON.parse(returnString);
    this.referenceString = returnString;
    for (var i = 0; i < returnString.length; i++) {
        this.dicomTags[returnString[i].tag] = returnString[i].tagValue;
    }
};

DicomMetaInfoReader.prototype.getDicomTagValue = function (tag) {
    return (this.dicomTags['(' + tag + ')']);
};

DicomMetaInfoReader.prototype.getReference = function () {
    return this.referenceString;
};

DicomMetaInfoReader.prototype.getPhotometricInterpretation = function () {
    return this.dicomTags['(0028,0004)'];
};

DicomMetaInfoReader.prototype.getColumns = function () {
    //throw new Error("DICOM meta information is not loaded");
    return parseInt(this.dicomTags['(0028,0011)']);
};

DicomMetaInfoReader.prototype.getRows = function () {
    //throw new Error("DICOM meta information is not loaded");
    return parseInt(this.dicomTags['(0028,0010)']);
};

DicomMetaInfoReader.prototype.getBitDepth = function () {
    var tmpBitStored = parseInt(this.dicomTags['(0028,0100)']);
    if (tmpBitStored == 8) return 1;
    else if (tmpBitStored == 16) return 2;
};

DicomMetaInfoReader.prototype.getWindowWidth = function () {
    return parseInt(this.dicomTags['(0028,1051)']);
};

DicomMetaInfoReader.prototype.getWindowCenter = function () {
    return parseInt(this.dicomTags['(0028,1050)']);
};

DicomMetaInfoReader.prototype.getRescaleIntercept = function () {
    if (this.dicomTags['(0028,1052)'] === undefined) {
        return 0;
    } else {
        return parseInt(this.dicomTags['(0028,1052)']);
    }
};

DicomMetaInfoReader.prototype.getRescaleSlope = function () {
    if (this.dicomTags['(0028,1053)'] === undefined) {
        return 1;
    } else {
        return parseInt(this.dicomTags['(0028,1053)']);
    }
};

DicomMetaInfoReader.prototype.getPatientName = function () {
    return (this.dicomTags['(0010,0010)']);
};

DicomMetaInfoReader.prototype.getPatientId = function () {
    return (this.dicomTags['(0010,0020)']);
};

DicomMetaInfoReader.prototype.getPatientDOB = function () {
    return (this.dicomTags['(0010,0030)']);
};

DicomMetaInfoReader.prototype.getPatientSex = function () {
    return (this.dicomTags['(0010,0040)']);
};

DicomMetaInfoReader.prototype.getStudyDate = function () {
    return (this.dicomTags['(0008,0020)']);
};

DicomMetaInfoReader.prototype.getAccessionNumber = function () {
    return (this.dicomTags['(0008,0050)']);
};

DicomMetaInfoReader.prototype.getInstitutionName = function () {
    return (this.dicomTags['(0008,0080)']);
};

DicomMetaInfoReader.prototype.getManufacturer = function () {
    return (this.dicomTags['(0008,0070)']);
};

DicomMetaInfoReader.prototype.getReferringPhysicianName = function () {
    return (this.dicomTags['(0008,0090)']);
};

DicomMetaInfoReader.prototype.getStudyInstanceUID = function () {
    return (this.dicomTags['(0020,000D)']);
};

DicomMetaInfoReader.prototype.getSeriesInstanceUID = function () {
    return (this.dicomTags['(0020,000E)']);
};

DicomMetaInfoReader.prototype.getSopInstanceUID = function () {
    return (this.dicomTags['(0008,0018)']);
};

DicomMetaInfoReader.prototype.getInstanceNumber = function () {
    return (this.dicomTags['(0020,0013)']);
};

DicomMetaInfoReader.prototype.getColumnPixelSpacing = function () {
    return this.getPixelSpacing().column;
};

DicomMetaInfoReader.prototype.getRowPixelSpacing = function () {
    return this.getPixelSpacing().row;
};

DicomMetaInfoReader.prototype.getPixelSpacing = function () {
    var pixelSpacing = this.dicomTags['(0028,0030)'];
    if (pixelSpacing && pixelSpacing.length > 0) {
        var split = pixelSpacing.split('\\');
        return {
            row: parseFloat(split[0]),
            column: parseFloat(split[1])
        };
    } else {
        return {
            row: undefined,
            column: undefined
        };
    }
};
