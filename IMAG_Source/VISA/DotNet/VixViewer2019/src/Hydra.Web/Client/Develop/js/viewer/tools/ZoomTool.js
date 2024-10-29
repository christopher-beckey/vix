/**
 * Zoom Tool
 */
ZoomTool.prototype = new MouseTool();
ZoomTool.prototype.constructor = ZoomTool;
var lastX, lastY;

function ZoomTool() {}

ZoomTool.prototype.hanleMouseDown = function (evt) {
    this.isMousePressed = true;
    if (dicomViewer.scroll.isCineRunning(dicomViewer.getActiveSeriesLayout().getSeriesLayoutId())) {
        return;
    }
    document.body.style.mozUserSelect = document.body.style.webkitUserSelect = document.body.style.userSelect = 'none';
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

ZoomTool.prototype.hanleMouseMove = function (evt) {
    var imageRenderer = this.activeImageRenderer;
    if (this.isMousePressed && imageRenderer !== undefined && imageRenderer.imagePromise !== undefined) {
        if (dicomViewer.scroll.isCineRunning(dicomViewer.getActiveSeriesLayout().getSeriesLayoutId())) {
            return;
        }
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var tmplastX = tmplastY = 0;
        if (evt.type === "touchmove") {
            var touch = undefined;
            var firstTouch = evt.touches[0];
            var secondTouch = evt.touches[1];

            //Getting the type of gesture whether it is one touch or multi-touch(Pinch-in/Pinch-out)
            if (evt.touches.length == 1) {
                touch = firstTouch;
            } else if (firstTouch.clientX < secondTouch.clientX && firstTouch.clientY < secondTouch.clientY) {
                touch = firstTouch;
            } else if ((firstTouch.clientX > secondTouch.clientX && firstTouch.clientY > secondTouch.clientY)) {
                touch = secondTouch;
            } else if (firstTouch.clientX > secondTouch.clientX && firstTouch.clientY < secondTouch.clientY) {
                touch = firstTouch;
            } else if (firstTouch.clientX < secondTouch.clientX && firstTouch.clientY > secondTouch.clientY) {
                touch = secondTouch;
            }
            tmplastX = touch.pageX;
            tmplastY = touch.pageY;
        } else {
            tmplastX = evt.offsetX || (evt.pageX - widget.offsetLeft);
            tmplastY = evt.offsetY || (evt.pageY - widget.offsetTop);
        }

        //var delta = Math.max((lastX - tmplastX),(lastY - tmplastY));
        var delta = 0;
        var tempX = lastX - tmplastX;
        var tempY = lastY - tmplastY;
        if (Math.abs(tempX) > Math.abs(tempY)) {
            delta = tempX;
        } else {
            delta = tempY;
        }

        if (delta != 0) {
            $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
                var imageLevelId = $(this).attr('id');
                var imageRender = seriesLayout.getImageRender(imageLevelId);
                if (imageRender) {
                    if (lastX === undefined || lastY === undefined) {
                        lastX = imageRender.getRenderWidget().width / 2;
                        lastY = imageRender.getRenderWidget().height / 2;
                    }
                    imageRender.doZoom(delta, tmplastX, tmplastY);
                }
            });
        }
        lastX = tmplastX;
        lastY = tmplastY;
    }
};

ZoomTool.prototype.hanleMouseUp = function (evt) {
    this.isMousePressed = false;
};

ZoomTool.prototype.hanleMouseWheel = function (evt) {
    if (dicomViewer.scroll.isCineRunning(dicomViewer.getActiveSeriesLayout().getSeriesLayoutId())) {
        return;
    }
    lastX = evt.offsetX || (evt.pageX - widget.offsetLeft);
    lastY = evt.offsetY || (evt.pageY - widget.offsetTop);
    var delta = evt.wheelDelta ? evt.wheelDelta / 40 : evt.detail ? -evt.detail : 0;
    if (delta) {
        //zoom(delta);
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        $("#" + seriesLayout.getSeriesLayoutId() + " div").each(function () {
            var imageLevelId = $(this).attr('id');
            var imageRender = seriesLayout.getImageRender(imageLevelId);
            if (imageRender) {
                if (typeof lastX == 'undefined') {
                    lastX = imageRender.getRenderWidget().width / 2;
                    lastY = imageRender.getRenderWidget().height / 2;
                }
                //	evt.target.style.cursor = "url(./images/toolbar/24x24/zoomin.png), auto";
                imageRender.doZoom(delta, lastX, lastY);
            }
        });
    }
    return evt.preventDefault() && false;
};
