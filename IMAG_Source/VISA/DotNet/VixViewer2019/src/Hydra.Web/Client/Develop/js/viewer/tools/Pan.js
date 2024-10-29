Pan.prototype = new MouseTool();
Pan.prototype.constructor = Pan;
var lastX, lastY;

function Pan() {}

Pan.prototype.hanleMouseDown = function (evt) {
    this.isMousePressed = true;
    document.body.style.mozUserSelect = document.body.style.webkitUserSelect = document.body.style.userSelect = 'none';
    if (dicomViewer.scroll.isCineRunning(dicomViewer.getActiveSeriesLayout().getSeriesLayoutId())) {
        return;
    }
    var seriesLayout = dicomViewer.getActiveSeriesLayout();
    $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
        var imageLevelId = $(this).attr('id');
        var imageRender = seriesLayout.getImageRender(imageLevelId);
        if (imageRender) {
            var widget = imageRender.getRenderWidget();
            if (evt.type === "touchstart") {
                var touch = evt.touches[0];
                lastX = touch.pageX;
                lastY = touch.pageY;
            } else {
                lastX = evt.offsetX || (evt.pageX - widget.offsetLeft);
                lastY = evt.offsetY || (evt.pageY - widget.offsetTop);
            }

        }
    });
    evt.preventDefault();
};

Pan.prototype.hanleMouseMove = function (evt) {
    var imageRenderer = this.activeImageRenderer;
    if (this.isMousePressed && imageRenderer !== undefined && imageRenderer.imagePromise !== undefined) {
        if (dicomViewer.scroll.isCineRunning(dicomViewer.getActiveSeriesLayout().getSeriesLayoutId())) {
            return;
        }
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var tmplastX = tmplastY = 0;
        if (evt.type === "touchstart") {
            var touch = evt.touches[0];
            tmplastX = touch.pageX;
            tmplastY = touch.pageY;
        } else {
            tmplastX = evt.offsetX;
            tmplastY = evt.offsetY;
        }

        $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
            var imageLevelId = $(this).attr('id');
            var imageRender = seriesLayout.getImageRender(imageLevelId);
            if (imageRender) {
                var widget = imageRender.getRenderWidget();
                if (evt.type === "touchmove") {
                    var touch = evt.touches[0];
                    tmplastX = touch.pageX;
                    tmplastY = touch.pageY;
                } else {
                    tmplastX = evt.offsetX || (evt.pageX - widget.offsetLeft);
                    tmplastY = evt.offsetY || (evt.pageY - widget.offsetTop);
                }


                if (lastX === undefined || lastY === undefined) {
                    lastX = imageRender.getRenderWidget().width / 2;
                    lastY = imageRender.getRenderWidget().height / 2;
                }
                var dragStart = {
                    x: (tmplastX - lastX),
                    y: (tmplastY - lastY)
                };
                imageRender.doDragPan(dragStart, tmplastX, tmplastY);
            }
        });
        lastX = tmplastX;
        lastY = tmplastY;
    }
};

Pan.prototype.hanleMouseUp = function (evt) {
    this.isMousePressed = false;
};

Pan.prototype.showHUvalue = function (x, y) {
    /*var hupanel = document.getElementById("huDisplayPanel");
    hupanel.innerHTML = "WindowCenter :" + x + " WindowWidth :" + y;*/
};
