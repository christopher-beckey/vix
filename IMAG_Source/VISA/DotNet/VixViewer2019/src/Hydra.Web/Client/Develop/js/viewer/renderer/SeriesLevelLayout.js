function SeriesLevelLayout(seriesLayoutId) {
    this.seriesLayoutId = seriesLayoutId;
    this.seriesIndex;
    this.imageLayoutDimension;
    this.imageCount;
    this.isOverlayEnable = false;
    this.imageRenders = new Array();
    this.preferenceInfo;

    this.scrollData = {
        imageIndex: 0,
        frameIndex: 0
    };
    this.isDragAndDrop = false;
    this.progressbar = undefined;
    this.imageType = undefined;
    this.leadValue = {};
    this.ecgCanvas = undefined;
    this.isCaliperEnable = true;
    this.studyUid = undefined;
    this.backupEnabled = false;
}

SeriesLevelLayout.prototype.getPreferenceInfo = function () {
    return this.preferenceInfo;
};

SeriesLevelLayout.prototype.setPreferenceInfo = function (preferenceInfo) {
    this.preferenceInfo = preferenceInfo;
};

SeriesLevelLayout.prototype.getImageIndex = function () {
    return this.scrollData.imageIndex;
};

SeriesLevelLayout.prototype.setImageIndex = function (index) {
    this.scrollData.imageIndex = index;
};

SeriesLevelLayout.prototype.setFrameIndex = function (index) {
    this.scrollData.frameIndex = index;
};

SeriesLevelLayout.prototype.getFrameIndex = function () {
    return this.scrollData.frameIndex;
};

SeriesLevelLayout.prototype.getSeriesLayoutId = function () {
    return this.seriesLayoutId;
};

SeriesLevelLayout.prototype.setSeriesIndex = function (seriesIndex) {
    this.seriesIndex = seriesIndex;
};

SeriesLevelLayout.prototype.getSeriesIndex = function () {
    return this.seriesIndex;
};

SeriesLevelLayout.prototype.setImageLayoutDimension = function (dimension) {
    this.imageLayoutDimension = dimension;
};

SeriesLevelLayout.prototype.getImageLayoutDimension = function () {
    return this.imageLayoutDimension;
};

SeriesLevelLayout.prototype.addImageRender = function (addImageRender, imageRender) {
    for (var key in this.imageRenders) {
        if ((this.imageRenders[key].seriesIndex == imageRender.seriesIndex) &&
            (this.imageRenders[key].seriesLevelDivId != imageRender.seriesLevelDivId)) {
            delete this.imageRenders[key];
        }
    }
    this.imageRenders[addImageRender] = imageRender;
};

SeriesLevelLayout.prototype.getImageRender = function (imageLayoutId) {
    return this.imageRenders[imageLayoutId];
};

SeriesLevelLayout.prototype.getAllImageRenders = function () {
    return this.imageRenders;
};

SeriesLevelLayout.prototype.removeAllImageRenders = function () {
    for (var key in this.imageRenders) {
        delete this.imageRenders[key];
    }
};

SeriesLevelLayout.prototype.getImageLayoutCount = function () {
    var dim = this.getImageLayoutDimension();
    if (!dim) {
        return 0;
    }
    var ir = dim.split("x");
    return parseInt(ir[0]) * parseInt(ir[1]);
};

SeriesLevelLayout.prototype.setImageCount = function (count) {
    this.imageCount = count;
};

SeriesLevelLayout.prototype.getImageCount = function () {
    return this.imageCount;
};

SeriesLevelLayout.prototype.getProgressbar = function () {
    return this.progressbar;
};

SeriesLevelLayout.prototype.setProgressbar = function (progressbar) {
    this.progressbar = progressbar;
};

SeriesLevelLayout.prototype.refreshViewports = function (soucre) {
    for (var key in this.imageRenders) {
        if (soucre == this.imageRenders[key]) {
            return;
        }
        this.imageRenders[key].drawDicomImage();
    }
};

SeriesLevelLayout.prototype.getDefaultRenderer = function () {
    for (var key in this.imageRenders) {
        if (this.imageRenders[key] != undefined) {
            return this.imageRenders[key];
        }
    }
};

SeriesLevelLayout.prototype.getDefaultRendererImageUid = function () {
    var aRenderer = this.getDefaultRenderer();
    if (aRenderer != undefined) {
        return aRenderer.imageUid;
    }
};
SeriesLevelLayout.prototype.getImageType = function () {
    return this.imageType;
};

SeriesLevelLayout.prototype.setImageType = function (imageType) {
    this.imageType = imageType;
};
SeriesLevelLayout.prototype.setStudyUid = function (studyUid) {
    this.studyUid = studyUid;
};
SeriesLevelLayout.prototype.getStudyUid = function () {
    return this.studyUid;
};
SeriesLevelLayout.prototype.setEcgCanvas = function (value) {
    this.ecgCanvas = value;
}
SeriesLevelLayout.prototype.getEcgCanvas = function () {
    return this.ecgCanvas;
}

SeriesLevelLayout.prototype.setCaliperEnable = function (isCaliperEnable) {
    this.isCaliperEnable = isCaliperEnable;
}
SeriesLevelLayout.prototype.isCaliperEnable = function () {
    return this.isCaliperEnable;
}
SeriesLevelLayout.prototype.updateImageRendersTo = function (oldSeriesLayoutId, newSeriesLayoutId) {
    for (var key in this.imageRenders) {
        if (key.indexOf(oldSeriesLayoutId) > -1) {
            var newKey = key.replace(oldSeriesLayoutId, newSeriesLayoutId);
            this.addImageRender(newKey, Object.create(this.imageRenders[key]));
            delete this.imageRenders[key];
        }
    }
}
SeriesLevelLayout.prototype.copy = function () {
    var viewport = new SeriesLevelLayout(this.seriesLayoutId);
    viewport.seriesLayoutId = this.seriesLayoutId;
    viewport.seriesIndex = this.seriesIndex;
    viewport.imageLayoutDimension = this.imageLayoutDimension;
    viewport.imageCount = this.imageCount;
    viewport.isOverlayEnable = this.isOverlayEnable;
    //viewport = this.imageRenders = new Array();
    for (var key in this.imageRenders) {
        viewport.addImageRender(key, this.imageRenders[key]);
    }
    viewport.preferenceInfo = this.preferenceInfo;
    if (this.scrollData !== undefined) {
        viewport.scrollData = {};
        viewport.scrollData.imageIndex = this.scrollData.imageIndex;
        viewport.scrollData.frameIndex = this.scrollData.frameIndex;
    }

    viewport.isDragAndDrop = this.isDragAndDrop;
    viewport.progressbar = this.progressbar;
    viewport.imageType = this.imageType;
    viewport.leadValue = this.leadValue;
    viewport.ecgCanvas = this.ecgCanvas;
    viewport.isCaliperEnable = this.isCaliperEnable;
    viewport.studyUid = this.studyUid;
    viewport.backupEnabled = this.backupEnabled;
    return viewport;
}
