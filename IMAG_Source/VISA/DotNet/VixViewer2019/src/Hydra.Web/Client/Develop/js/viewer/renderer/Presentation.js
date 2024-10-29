function Presentation() {
    this.invert = false;
    this.brightness = 100;
    this.contrast = 100;
    this.windowWidth;
    this.windowCenter;
    this.rescaleSlope;
    this.rescaleIntercept;
    this.zoom = 1.0;
    this.sharpen = 0;
    this.zoomLevel = 1;
    this.windowLevel = 1;
    this.panX = 0;
    this.PanY = 0;
    this.rotation = 0;
    this.isRotation = false;
    this.orientation = 0;
    this.isFlipHorizontalRequired = false;
    this.presentationMode = "SCALE_TO_FIT"; //Could be SCALE_TO_FIT /MAGNIFY 
    this.lookupObj = new LookupTable();
    this.scaleMultiplier = 0.8;
    this.currentPreset = 0;
    this.minPixel = 0;
    this.maxPixel = 0;
    this.windowLevelLimits;
    this.vFlip = false;
    this.hFlip = false;
    this.fitToWindow = false;
    this.isRotationChange = false;
    this.rgbMode = 0;
    this.lastAppliedPan = undefined;
    this.defaultZoom = 1.0;
    this.pan = {
        x: 0,
        y: 0
    };
}

Presentation.prototype.copy = function (presentation) {
    presentation.invert = this.invert;
    presentation.brightness = this.brightness;
    presentation.contrast = this.contrast;
    presentation.windowWidth = this.windowWidth;
    presentation.windowCenter = this.windowCenter;
    presentation.rescaleSlope = this.rescaleSlope;
    presentation.rescaleIntercept = this.rescaleIntercept;
    presentation.zoom = this.zoom;
    presentation.sharpen = this.sharpen;
    presentation.panX = this.panX;
    presentation.PanY = this.PanY;
    presentation.rotation = this.rotation;
    presentation.isRotation = this.isRotation;
    presentation.orientation = this.orientation;
    presentation.isFlipHorizontalRequired = this.isFlipHorizontalRequired;
    presentation.presentationMode = this.presentationMode; //Could be SCALE_TO_FIT /MAGNIFY 
    presentation.lookupObj = this.lookupObj;
    presentation.scaleMultiplier = this.scaleMultiplier;
    presentation.currentPreset = this.currentPrese;
    presentation.minPixel = this.minPixel;
    presentation.maxPixel = this.maxPixel;
    presentation.windowLevelLimits = this.windowLevelLimits;
    presentation.vFlip = this.vFlip;
    presentation.hFlip = this.hFlip;
    presentation.fitToWindow = this.fitToWindow;
    presentation.rgbMode = this.rgbMode;
    presentation.zoomLevel = this.zoomLevel;
    presentation.windowLevel = this.windowLevel;
    presentation.lastAppliedPan = this.lastAppliedPan;
    presentation.defaultZoom = this.defaultZoom;
}

Presentation.prototype.setWindowLevel = function (dicominfo, minMax, invert) {
    this.rescaleSlope = dicominfo.getRescaleSlope();
    this.rescaleIntercept = dicominfo.getRescaleIntercept();
    this.minPixel = minMax.min;
    this.maxPixel = minMax.max;
    this.invert = invert;
    this.lookupObj.setData(this.windowCenter, this.windowWidth, this.rescaleSlope, this.rescaleIntercept, minMax, invert);
};

Presentation.prototype.setWindowingdata = function (wc, ww) {
    this.lookupObj.setWindowingdata(wc, ww);
    this.windowCenter = wc;
    this.windowWidth = ww;
};

Presentation.prototype.setBrightnessContrast = function (brightness, contrast) {
    this.brightness = brightness;
    this.contrast = contrast;
};

Presentation.prototype.setWindowLevelLimits = function (windowLevelLimits) {
    this.windowLevelLimits = windowLevelLimits;
};

Presentation.prototype.setInvertFlag = function (flag) {
    this.invert = flag;
    this.lookupObj.setInvertData(this.invert);
};

Presentation.prototype.getInvertFlag = function (flag) {
    return this.invert;
};

Presentation.prototype.getWindowWidth = function () {
    return this.windowWidth;
};

Presentation.prototype.getWindowCenter = function () {
    return this.windowCenter;
};

Presentation.prototype.setZoom = function (zoom) {
    this.zoom = zoom;
};

Presentation.prototype.getZoom = function () {
    return this.zoom;
};

Presentation.prototype.setSharpen = function (sharpen) {
    this.sharpen = sharpen;
};

Presentation.prototype.getSharpen = function () {
    return this.sharpen;
};


Presentation.prototype.setZoomLevel = function (zoomLevel) {
    this.zoomLevel = zoomLevel;
};

Presentation.prototype.setPresetWindowLevelValue = function (windowLevel) {
    this.windowLevel = windowLevel;
};

Presentation.prototype.getZoomLevel = function () {
    return this.zoomLevel;
};

Presentation.prototype.setPan = function (x, y) {

    this.pan.x = x;
    this.pan.y = y;
};

Presentation.prototype.getPan = function () {
    return this.pan;
};
Presentation.prototype.setRotation = function (rotation) {
    if (rotation == 360) {
        this.rotation = 0;
    } else {
        this.rotation = rotation;
    }
    this.isRotation = true;
};

Presentation.prototype.getRotation = function () {
    return this.rotation;
};

Presentation.prototype.getlookupTable = function () {
    return this.lookupObj;
};

Presentation.prototype.isScaleToFitMode = function () {
    if (this.presentationMode == "SCALE_TO_FIT") return true;
    else return false;
};

Presentation.prototype.setPresentationMode = function (pMode) {
    this.presentationMode = pMode;
};

Presentation.prototype.getPresentationMode = function () {
    return this.presentationMode;
};

Presentation.prototype.setRGBMode = function (rgbMode) {
    this.rgbMode = rgbMode;
};

Presentation.prototype.getRGBMode = function () {
    return this.rgbMode;
};

Presentation.prototype.setVerticalFilp = function (vFlip) {
    this.vFlip = vFlip;
    this.isRotation = false;
};

Presentation.prototype.getVerticalFilp = function () {
    return this.vFlip;
};

Presentation.prototype.setHorizontalFilp = function (hFlip) {
    this.hFlip = hFlip;
    this.isRotation = false;
};

Presentation.prototype.getHorizontalFilp = function () {
    return this.hFlip;
};

Presentation.prototype.setOrientation = function (orientation) {
    this.orientation = orientation;
};

Presentation.prototype.getOrientation = function () {
    return this.orientation;
};

Presentation.prototype.isFlipHoriRequired = function () {
    return this.isFlipHorizontalRequired;
};

Presentation.prototype.setIsRotationChange = function (flag) {
    this.isRotationChange = flag;
};

Presentation.prototype.getIsRotationChange = function () {
    return this.isRotationChange;
};
Presentation.prototype.updateRotateAndFlip = function () {
    var isRotated = false;
    this.isFlipHorizontalRequired = false;

    if (this.hFlip === true) {
        if (this.rotation === 90 || this.rotation === 270) {
            isRotated = true;
        }
    }

    var isFlipNone = (this.hFlip === false && this.vFlip === false);
    var isFlipBoth = (this.hFlip === true && this.vFlip === true);
    if ((this.rotation == 0 && isFlipNone) || (this.rotation == 180 && isFlipBoth)) {
        this.rotation = 0;
        this.isFlipHorizontalRequired = false;
    } else if ((this.rotation == 90 && isFlipNone) || (this.rotation == 270 && isFlipBoth)) {
        this.rotation = 90;
        this.isFlipHorizontalRequired = false;
    } else if ((this.rotation == 180 && isFlipNone) || (this.rotation == 0 && isFlipBoth)) {
        this.rotation = 180;
        this.isFlipHorizontalRequired = false;
    } else if ((this.rotation == 270 && isFlipNone) || (this.rotation == 90 && isFlipBoth)) {
        this.rotation = 270;
        this.isFlipHorizontalRequired = false;
    } else if ((this.rotation == 0 && this.hFlip === true) || (this.rotation == 180 && this.vFlip === true)) {
        this.rotation = 0;
        this.isFlipHorizontalRequired = true;
    } else if ((this.rotation == 90 && this.hFlip === true) || (this.rotation == 270 && this.vFlip === true)) {
        if (isRotated) {
            this.rotation = 270;
        } else {
            this.rotation = 90;
        }
        this.isFlipHorizontalRequired = true;
    } else if ((this.rotation == 180 && this.hFlip === true) || (this.rotation == 0 && this.vFlip === true)) {
        this.rotation = 180;
        this.isFlipHorizontalRequired = true;
    } else if ((this.rotation == 270 && this.hFlip === true) || (this.rotation == 90 && this.vFlip === true)) {
        if (isRotated) {
            this.rotation = 90;
        } else {
            this.rotation = 270;
        }

        this.isFlipHorizontalRequired = true;
    }

    if (this.isFlipHorizontalRequired === true) {
        if (this.rotation === 90) {
            this.rotation = 270;
        } else if (this.rotation === 270) {
            this.rotation = 90;
        }
    }
};

Presentation.prototype.setBrightness = function (value) {
    this.brightness = value;
};

Presentation.prototype.getBrightness = function () {
    return this.brightness;
};

Presentation.prototype.setContrast = function (value) {
    this.contrast = value;
};

Presentation.prototype.getContrast = function () {
    return this.contrast;
};

Presentation.prototype.setLastAppliedPan = function (value) {
    this.lastAppliedPan = value;
};

Presentation.prototype.getLastAppliedPan = function () {
    return this.lastAppliedPan;
};

Presentation.prototype.setDefaultZoom = function (zoom) {
    this.defaultZoom = zoom;
};

Presentation.prototype.getDefaultZoom = function () {
    return this.defaultZoom;
};
