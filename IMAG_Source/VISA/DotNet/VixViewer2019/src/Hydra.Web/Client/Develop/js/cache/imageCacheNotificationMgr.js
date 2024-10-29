var dicomViewer = (function (dicomViewer) {

    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var cacheIndicators = {};
    /**
     *@param indicator
     *get the indictor object from the argument and save indicator inside the
     *cacheIndicators object
     *cacheIndicators object contains key as viewport Id and value as indicator
     */
    function addCacheIndicator(indicator) {
        if (indicator === undefined) {
            throw "addCacheIndicator : indicator is undefined";
        }
        cacheIndicators[indicator.parentElementId] = indicator
    }

    /**
     *@param seriesIndex
     *Iterate the cacheIndicators object based on the argument(seriesIndex)
     *and the series index present in the indicator return the indicator object
     */
    function getCacheIndicator(seriesIndex, imageIndex) {
        var key;
        var progressbar;
        //Key is viewport div id
        for (key in cacheIndicators) {
            if (cacheIndicators.hasOwnProperty(key)) {
                var indicator = cacheIndicators[key];
                if ((indicator.seriesIndex == seriesIndex && !indicator.isMultiframe) ||
                    (indicator.seriesIndex == seriesIndex && indicator.imageIndex == imageIndex && indicator.isMultiframe)) {
                    return indicator;
                } else {
                    if (indicator.seriesIndex == seriesIndex) {
                        progressbar = indicator;
                    }
                }
            }
        }
        return progressbar;
    }
    /**
     *This trigger is used to update the progress bar based on the caching
     *using the current caching index and total count we are calculating
     *the percentage and updating in the progress bar using progress.drawImageCacheIndicator()
     */
    $(document).on("update", function (e, totalCount, currentIndex, progress) {
        var percentageVal = (currentIndex / totalCount) * 100;
        progress.cachedPercentage = percentageVal;
        var position = progress.imageIndicator.width * (percentageVal / 100);
        progress.cachedIndicationPoint = position;
        progress.drawImageCacheIndicator();
    });

    dicomViewer.cacheIndicator = {
        addCacheIndicator: addCacheIndicator,
        getCacheIndicator: getCacheIndicator,
    };

    return dicomViewer;
}(dicomViewer));
