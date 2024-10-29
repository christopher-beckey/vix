function MouseTool() {
    this.isMousePressed = false;
    this.activeImageRenderer;
    this.ToolType;
}

MouseTool.prototype.hanleMouseUp = function (evet) {
    this.isMousePressed = false;
};

MouseTool.prototype.hanleMouseOver = function (evet) {
    this.isMousePressed = false;
};

MouseTool.prototype.hanleMouseOut = function (evet) {
    this.isMousePressed = false;
};

MouseTool.prototype.hanleMouseDown = function (evet) {
    this.isMousePressed = true;
};

MouseTool.prototype.hanleDoubleClick = function (evet) {};


MouseTool.prototype.hanleMouseMove = function (evet) {};

MouseTool.prototype.isMousePressed = function () {
    return this.isMousePressed;
};

MouseTool.prototype.getActiveImageRenderer = function () {
    return this.activeImageRenderer;
};

MouseTool.prototype.setActiveImageRenderer = function (activeImageRenderer) {
    this.activeImageRenderer = activeImageRenderer;
};

MouseTool.prototype.hitTestAndGetMousePosition = function (evt, isTextAreaEvent) {
    try {
        // Check whether the render object is valid
        if (this.activeImageRenderer === undefined || this.activeImageRenderer === null) {
            return undefined;
        }

        // Get the image object to get the current presentation 
        var imageCanvas = null;
        this.activeImageRenderer.imagePromise.then(function (image) {
            imageCanvas = image;
        });

        // Calculate the image region with in the viewport region
        var canvas = this.activeImageRenderer.getRenderWidget();
        var viewportRect = canvas.getBoundingClientRect();
        var viewportLeftOffset = (viewportRect.left < 0 ? 0 : viewportRect.left);
        var viewportTopOffset = (viewportRect.top < 0 ? 0 : viewportRect.top);
        var scale = parseFloat(this.activeImageRenderer.scaleValue);
        var canvasMidX = viewportRect.width / 2;
        var canvasMidY = viewportRect.height / 2;
        var scaledImageWidth = (imageCanvas.columns * scale);
        var scaledImageHeight = (imageCanvas.rows * scale);
        var imageMidX = scaledImageWidth / 2;
        var imageMidY = scaledImageHeight / 2;
        var x = Math.round(canvasMidX - imageMidX);
        var dx = Math.round(canvasMidX + imageMidX);
        var y = Math.round(canvasMidY - imageMidY);
        var dy = Math.round(canvasMidY + imageMidY);

        // Get the current mouse position
        var pointX = 0;
        var pointY = 0;
        if (evt.touches === undefined) {
            if (evt.offsetX !== undefined && evt.offsetY !== undefined && isTextAreaEvent != true) {
                pointX = evt.offsetX - 5;
                pointY = evt.offsetY - 5;
            } else {
                pointX = evt.pageX - viewportLeftOffset;
                pointY = evt.pageY - viewportTopOffset;
            }
        } else if (evt.touches.length > 0) {
            //Touch event
            pointX = evt.touches[0].pageX - viewportLeftOffset;
            pointY = evt.touches[0].pageY - viewportTopOffset;
        } else if (evt.changedTouches.length > 0) {
            pointX = evt.changedTouches[0].pageX - viewportLeftOffset;
            pointY = evt.changedTouches[0].pageY - viewportTopOffset;
        }

        // Assign the default X value if the current mouse X value is not in the viewport region.
        if (pointX < 0) {
            pointX = 5
        } else if (pointX >= viewportRect.width) {
            pointX = viewportRect.width - 5;
        }

        // Assign the default Y value if the current mouse Y value is not in the viewport region.
        if (pointY < 0) {
            pointY = 5
        } else if (pointY >= viewportRect.height) {
            pointY = viewportRect.height - 5;
        }

        // Update the point X position based on the image region
        if (pointX < x) {
            pointX = x;
        } else if (pointX > dx) {
            pointX = dx;
        }

        // Update the point Y position based on the image region
        if (pointY < y) {
            pointY = y;
        } else if (pointY > dy) {
            pointY = dy;
        }

        // Check whether the current point is in the image region
        var isPtInRegion = false;
        if ((pointX > x && pointX < dx) && (pointY > y && pointY < dy)) {
            isPtInRegion = true;
        }

        // Set the cursor
        // TODO: Set the cursor based on the tool type

        return {
            x: pointX,
            y: pointY,
            isPtInRegion: isPtInRegion,
            xOffset: x,
            yOffset: y
        };
    } catch (e) {}

    return undefined;
};
