CopyAttributes.prototype = new MouseTool();
CopyAttributes.prototype.constructor = CopyAttributes;

function CopyAttributes() {
    this.copyAttributesData = undefined;
}

CopyAttributes.prototype.hanleMouseDown = function (evt) {
    try {
        this.isMousePressed = true;
        if (!this.activeImageRenderer) {
            return;
        }

        if (!this.copyAttributesData) {
            return;
        }

        if (this.activeImageRenderer.seriesLevelDivId === this.copyAttributesData.sourceId) {
            return;
        }

        if (!this.copyAttributesData.appliedViewports) {
            this.copyAttributesData.appliedViewports = [];
        }

        if (this.copyAttributesData.appliedViewports.indexOf(this.activeImageRenderer.seriesLevelDivId) != -1) {
            return;
        }

        var viewport = dicomViewer.viewports.getViewport(this.activeImageRenderer.seriesLevelDivId);
        if (!viewport) {
            return;
        }

        this.copyAttributesData.appliedViewports.push(this.activeImageRenderer.seriesLevelDivId);
        var copyAttributeOptions = {
            brightnessContrast: $("#brightnesscontrast")[0].checked,
            windowLevel: $("#windowlevel")[0].checked,
            scale: $("#scale")[0].checked,
            invert: $("#invert")[0].checked,
            orientation: $("#orientation")[0].checked,
            pan: $("#pan")[0].checked
        };

        var copyAttributePState = this.copyAttributesData.data.presentationState;
        for (var key in viewport.getAllImageRenders()) {
            var imageRender = viewport.getImageRender(key);
            if (imageRender) {
                // Scale
                if (copyAttributeOptions.scale) {
                    if (this.copyAttributesData.data && this.copyAttributesData.data.scaleValue != undefined) {
                        var zoomLevel = "6_zoom" + "-" + (parseFloat(this.copyAttributesData.data.scaleValue) * 100).toString();
                        imageRender.setZoomLevel(zoomLevel);
                    }
                }

                //Window/Level
                if (viewport.imageType === this.copyAttributesData.imageType) {
                    if (copyAttributeOptions.windowLevel && viewport.imageType !== IMAGETYPE_RADECHO) {
                        imageRender.doWindowLevel(copyAttributePState.windowCenter, copyAttributePState.windowWidth, false);
                    } else if (copyAttributeOptions.brightnessContrast && viewport.imageType == IMAGETYPE_RADECHO) {
                        imageRender.doBrightnessContrast(copyAttributePState.getBrightness(), copyAttributePState.getContrast(), false);
                    }
                }

                //Invert
                if (copyAttributeOptions.invert) {
                    imageRender.getPresentation().setInvertFlag(copyAttributePState.getInvertFlag());
                }

                //Orientation
                if (copyAttributeOptions.orientation) {
                    imageRender.presentationState.setOrientation(copyAttributePState.getOrientation());
                }

                imageRender.renderImage(false);
                imageRender.applyOrRevertDisplaySettings(imageRender.getPresentation(), undefined, undefined, true);
            }
        }
    } catch (e) {}
};

CopyAttributes.prototype.hanleMouseMove = function (evt) {};

CopyAttributes.prototype.hanleMouseUp = function (evt) {
    this.isMousePressed = false;
};

CopyAttributes.prototype.hanleMouseOut = function (evt) {
    this.isMousePressed = false;
};

CopyAttributes.prototype.setCopyAttributesData = function (data) {
    this.copyAttributesData = data;
};

CopyAttributes.prototype.getCopyAttributesData = function () {
    return this.copyAttributesData;
};
