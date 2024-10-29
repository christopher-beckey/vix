function ViewportProgreeBar(viewportId) {
    this.framePosition = 0;
    this.cachedIndicationPoint = 0;
    this.seriesIndex;
    this.imageIndex;
    this.frameIndex;
    this.studyUid;
    this.isMultiframe = false;

    this.cachedPercentage = 0;

    this.parentElementId = viewportId;
    var viewportElement = $('#' + viewportId);
    this.imageIndicator = document.createElement("canvas");
    this.cacheIndicator = document.createElement("canvas");
    this.imageIndicator.setAttribute("id", viewportId + "_progress");

    var heightOfElement = viewportElement.height();
    var widthOfElement = viewportElement.width();

    var wPadding = viewportElement.outerWidth() - widthOfElement;
    var hPadding = viewportElement.outerHeight() - heightOfElement;

    this.viewportWidth = viewportElement.outerWidth();
    this.viewportHeight = viewportElement.outerHeight();
    this.imageIndicator.width = this.viewportWidth - wPadding - 2;
    this.imageIndicator.height = 7;

    viewportElement.append(this.imageIndicator);

    this.imageIndicator.style.zIndex = "8";
    this.imageIndicator.style.position = "absolute";
}

ViewportProgreeBar.prototype.setSeriesInfo = function (studyUid, seriesIndex, imageIndex, frameIndex) {
    this.seriesIndex = seriesIndex;
    this.imageIndex = imageIndex;
    this.frameIndex = frameIndex;
    this.studyUid = studyUid;
    this.isMultiframe = dicomViewer.thumbnail.isSeriesContainsMultiframe(this.studyUid, this.seriesIndex);

    var image = dicomViewer.Series.Image.getImage(studyUid, seriesIndex, imageIndex);
    if (image === undefined) {
        return;
    }
    var frameCount = dicomViewer.Series.Image.getImageFrameCount(image);
    if (frameCount === undefined) {
        return;
    }
    if (frameCount > 1) {
        this.updateImagePosition(frameCount, frameIndex);
    } else {
        this.updateImagePosition(dicomViewer.Series.getImageCount(studyUid, seriesIndex), imageIndex);
    }

};

ViewportProgreeBar.prototype.drawImageCacheIndicator = function () {

    try {
        if (this.seriesIndex == undefined || this.imageIndex == undefined) {
            return;
        }

        var logMessage = ("Move Cache Indicator for SeriesIndex: " + this.seriesIndex + " and ImageIndex: " + this.imageIndex);
        dumpConsoleLogs(LL_DEBUG, undefined, "drawImageCacheIndicator", logMessage);
        var image = dicomViewer.Series.Image.getImage(this.studyUid, this.seriesIndex, this.imageIndex);

        var imageCount = 0;
        var isSeriesHasMultiframe = dicomViewer.thumbnail.isSeriesContainsMultiframe(this.studyUid, this.seriesIndex);
        if (isSeriesHasMultiframe && dicomViewer.thumbnail.isImageThumbnail(image)) {
            imageCount = dicomViewer.Series.Image.getImageFrameCount(image);
            this.cacheIndicator.width = imageCount;
            this.cacheIndicator.height = 10;
            var context = this.cacheIndicator.getContext('2d');

            //Fill gray
            context.beginPath();
            context.moveTo(0, 0);
            context.lineTo(this.cacheIndicator.width, 0);
            context.lineWidth = 10;
            context.strokeStyle = '#BDBDBD';
            context.stroke();

            for (var frame = 0; frame < imageCount; frame++) {
                var imagePromise = dicomViewer.imageCache.isInCache(image.imageUid + "_" + frame);
                if (imagePromise == true) {
                    context.beginPath();
                    context.moveTo(frame, 0);
                    context.lineTo(frame + 1, 0);
                    context.lineWidth = 10;
                    context.strokeStyle = '#1C1C1C';
                    context.stroke();
                }
            }
        } else {
            imageCount = dicomViewer.Series.getImageCount(this.studyUid, this.seriesIndex);
            this.cacheIndicator.width = imageCount * 5;
            this.cacheIndicator.height = 10;
            var context = this.cacheIndicator.getContext('2d');

            //Fill gray
            context.beginPath();
            context.moveTo(0, 0);
            context.lineTo(this.cacheIndicator.width, 0);
            context.lineWidth = 10;
            context.strokeStyle = '#BDBDBD';
            context.stroke();
            for (var anImageIndex = 0; anImageIndex < imageCount; anImageIndex++) {
                var anImage = dicomViewer.Series.Image.getImage(this.studyUid, this.seriesIndex, anImageIndex);
                var hasImageInCache = dicomViewer.imageCache.isInCache(anImage.imageUid + "_0");
                if (hasImageInCache == true) {
                    context.beginPath();
                    context.moveTo(anImageIndex * 5, 0);
                    context.lineTo(anImageIndex * 5 + 5, 0);
                    context.lineWidth = 10;
                    context.strokeStyle = '#1C1C1C';
                    context.stroke();
                }
            }
        }

        var contextFinal = this.imageIndicator.getContext('2d');
        contextFinal.clearRect(0, 0, this.imageIndicator.width, this.imageIndicator.height);
        contextFinal.drawImage(this.cacheIndicator, 0, 0, this.imageIndicator.width, this.imageIndicator.height);
        contextFinal.beginPath();

        // No possible of having zero index in the image
        if (this.framePosition == 0) {
            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            var imageLayoutCount = 0;
            if (seriesLayout !== null) {
                imageLayoutCount = seriesLayout.getImageLayoutCount() - 1;
            }

            this.updateFramePosition(imageLayoutCount, imageCount);
        }

        contextFinal.rect(this.framePosition, 0, 5, 4);
        contextFinal.fillStyle = 'white';
        contextFinal.fill();
        contextFinal.lineWidth = 1;
        contextFinal.strokeStyle = 'white';
        contextFinal.stroke();
    } catch (e) {}
};

ViewportProgreeBar.prototype.updateImagePosition = function (totalCount, currentIndex) {
    this.updateFramePosition(currentIndex, totalCount);
    this.drawImageCacheIndicator();
};

ViewportProgreeBar.prototype.updateFramePosition = function (currentIndex, totalCount) {
    var percentageVal = ((currentIndex + 1) / totalCount) * 100;
    var framePosition = this.imageIndicator.width * (percentageVal / 100);
    this.framePosition = framePosition;
};
