DefaultTool.prototype = new MouseTool();
DefaultTool.prototype.constructor = DefaultTool;

function DefaultTool() {
    this.ToolType = "defaultTool";
    this.isDefaultToolActivated = false;
}

DefaultTool.prototype.hanleMouseDown = function (evt) {
    this.isMousePressed = true;
    this.isDefaultToolActivated = false;
    if (this.activeImageRenderer) {
        dicomViewer.measurement.removeTempdata();
    }

    evt.preventDefault();
};

DefaultTool.prototype.hanleMouseMove = function (evt) {
    if (this.isMousePressed && !this.isDefaultToolActivated) {
        this.isDefaultToolActivated = true;
        if (this.activeImageRenderer) {
            this.activeImageRenderer.doClickDefaultTool();
            evt.type = "mousedown";
            dicomViewer.mouseTools.getActiveTool().hanleMouseDown(evt);
        }
    }
};

DefaultTool.prototype.hanleDoubleClick = function (evt) {

};

DefaultTool.prototype.hanleMouseUp = function (evt) {
    this.isMousePressed = false;
    this.isDefaultToolActivated = false;
    if (evt.which === 3) {
        var imageRender = this.activeImageRenderer;
        if (imageRender === undefined || imageRender === null) {
            // Invalid render object
            return;
        }

        var pt = this.hitTestAndGetMousePosition(evt);

        // HitTest line measurement
        if (this.setAndValidateMeasurementDelete(pt, "linedelete")) {
            return;
        }

        // HitTest point measurement
        if (this.setAndValidateMeasurementDelete(pt, "pointdelete")) {
            return;
        }

        // HitTest angle measurement
        if (this.setAndValidateMeasurementDelete(pt, "angledelete")) {
            return;
        }

        // HitTest ellipse measurement
        if (this.setAndValidateMeasurementDelete(pt, "ellipsedelete")) {
            return;
        }

        // HitTest trace measurement
        if (this.setAndValidateMeasurementDelete(pt, "tracedelete")) {
            return;
        }

        // HitTest volume measurement
        if (this.setAndValidateMeasurementDelete(pt, "volumedelete")) {
            return;
        }

        // HitTest mitralGradient measurement
        if (this.setAndValidateMeasurementDelete(pt, "mitralGradientdelete")) {
            return;
        }

        // HitTest rectangle measurement
        if (this.setAndValidateMeasurementDelete(pt, "rectangledelete")) {
            return;
        }

        if (this.setAndValidateMeasurementDelete(pt, "pendelete")) {
            return;
        }
    }
};

DefaultTool.prototype.setAndValidateMeasurementDelete = function (pt, deleteType) {

    dicomViewer.measurement.setTempData({
        x: pt.x,
        y: pt.y,
        measureType: deleteType
    });
    this.activeImageRenderer.drawDicomImage(true);
    var dataToEdit = dicomViewer.measurement.getDataToDelete();
    if (dataToEdit === undefined || dataToEdit.keyId === "") {
        return false;
    }

    return true;
};
