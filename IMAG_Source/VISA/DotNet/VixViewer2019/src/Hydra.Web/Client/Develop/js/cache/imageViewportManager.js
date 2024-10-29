/**
 * New node file
 */
var dicomViewer = (function (dicomViewer) {

    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var viewports = {};

    var viewportIds = [];

    var seriesLayoutMaxId = {};

    var backupviewports = {};

    var backupViewportsBySeriesIndex = {};

    var duplicateViewportsBySeriesIndex = {};

    var viewportImageLayouts = [];

    var currentPageImageLayouts = {};

    function addBackupViewport(viewportId, viewport) {
        backupviewports[viewportId] = viewport;
    }

    function removeBackupViewport(viewportId) {
        delete backupviewports[viewportId];
    }

    function getBackupViewport(viewportId) {
        return backupviewports[viewportId];
    }

    function addBackupViewportBySeriesIndex(viewportId, viewport) {
        backupViewportsBySeriesIndex[viewportId] = viewport;
    }

    function removeBackupViewportBySeriesIndex(viewportId) {
        delete backupViewportsBySeriesIndex[viewportId];
    }

    function removeAllBackupViewportBySeriesIndex(studyLayoutId) {
        for (var key in backupViewportsBySeriesIndex) {
            var serieslayout = backupViewportsBySeriesIndex[key];
            var index = serieslayout.seriesLayoutId.indexOf(studyLayoutId);
            if (index >= 0) {
                delete backupViewportsBySeriesIndex[key];
            }
        }
    }

    function getBackupViewportBySeriesIndex(viewportId) {
        return backupViewportsBySeriesIndex[viewportId];
    }


    function getViewport(viewportId) {
        if (viewportId === undefined) {
            throw "viewportId should not be null or undefined";
        }
        return viewports[viewportId];
    }

    function removeViewport(viewportId) {
        if (viewportId === undefined) {
            throw "viewportId should not be null or undefined";
        }
        delete viewports[viewportId];
    }

    function addViewport(viewportId, viewport) {
        if (viewportId === undefined) {
            throw "viewportId Or viewportInfo should not be null Or undefined";
        }
        if (viewport === undefined) {
            delete viewports[viewportId];
            return;
        }
        delete viewports[viewportId];
        viewports[viewportId] = viewport;
        viewportIds.push(viewportId);
    }

    function getAllViewportsId() {
        return viewportIds;
    }

    function removeAllViewports() {
        viewports = {};
        viewportIds = [];
    }

    function getViewportIds() {
        var unique = viewportIds.filter(function (itm, i, viewportIds) {
            return i == viewportIds.indexOf(itm);
        });

        return unique;
    }

    function getAllViewports() {
        return viewports;
    }

    function refreshViewports(source) {
        if (source === undefined) {
            return
        }
        var parentDiv = source.seriesLayoutId;
        if (parentDiv === undefined) {
            parentDiv = source.parentElement;
        }
        var studyDiv = getStudyLayoutId(parentDiv);
        for (var key in viewports) {
            var indexOfStudyDiv = key.indexOf(studyDiv);
            if (indexOfStudyDiv > -1) {
                var obj = viewports[key];
                //if(source.seriesLayoutId != obj.seriesLayoutId){
                obj.refreshViewports(source);
                //}
            }
        }
    }

    function addSeriesLayoutMaxId(seriesLayoutId, viewportId) {
        seriesLayoutMaxId[viewportId] = seriesLayoutId;
    }

    function getSeriesLayoutMaxId(viewportId) {
        viewportId = (viewportId === undefined || viewportId === null) ? "studyViewer1x1" : viewportId;
        return seriesLayoutMaxId[viewportId];
    }

    function removeViewportsByStudyLayout(studyLayoutId) {

        for (var key in viewports) {
            var index = key.indexOf(studyLayoutId);
            if (index >= 0) {

                delete viewports[key];
            }
        }
    }

    function backupViewableViewportsBySeriesIndex(studyLayoutId) {

        for (var key in viewports) {
            var index = key.indexOf(studyLayoutId);
            if (index >= 0) {
                var viewport = viewports[key];
                if (viewport.getSeriesIndex() !== undefined) {
                    var imageValue = dicomViewer.Series.Image.getImage(viewport.getStudyUid(), viewport.getSeriesIndex(), viewport.getImageIndex());
                    if (imageValue !== undefined) {
                        if (dicomViewer.thumbnail.isImageThumbnail(imageValue))
                            addBackupViewportBySeriesIndex(viewport.getStudyUid() + "_" + viewport.getImageIndex(), viewport);
                        else
                            addBackupViewportBySeriesIndex(viewport.getStudyUid() + "_" + viewport.getSeriesIndex(), viewport);
                    }
                }
            }
        }
    }

    function deleteAndCreateNewViewport(studyLayoutId) {
        for (var key in viewports) {
            var index = key.indexOf(studyLayoutId);
            if (index >= 0) {
                var newLayout = new SeriesLevelLayout(key);
                newLayout.imageLayoutDimension = "1x1";
                var preferenceInfo = new PreferenceInfo();
                preferenceInfo.init();
                newLayout.setPreferenceInfo(preferenceInfo);
                viewports[key] = newLayout;
                dicomViewer.setimageCanvasOfViewPort(key, undefined);
                dicomViewer.removeCineManager(key);
                newLayout.removeAllImageRenders();
                newLayout.setSeriesIndex(undefined);
                newLayout.setImageIndex(undefined);
                newLayout.setFrameIndex(undefined);
                dicomViewer.changeSelection(key);
            }
        }
    }

    function deleteViewportsByThumbnail(studyUid) {
        var tempStudyLayoutId = "";
        for (var key in viewports) {
            var viewport = viewports[key];
            var viewportStudyUid = viewport.getStudyUid();
            if (viewportStudyUid != undefined)
                viewportStudyUid = dicomViewer.replaceDotValue(viewportStudyUid);
            if (studyUid === viewportStudyUid) {
                var newLayout = new SeriesLevelLayout(key);
                newLayout.imageLayoutDimension = "1x1";
                var preferenceInfo = new PreferenceInfo();
                preferenceInfo.init();
                newLayout.setPreferenceInfo(preferenceInfo);
                viewports[key] = newLayout;
                dicomViewer.setimageCanvasOfViewPort(key, undefined);

                var studyLayoutDivId = getStudyLayoutId(key);
                if (studyLayoutDivId != tempStudyLayoutId) {
                    tempStudyLayoutId = studyLayoutDivId;
                    dicomViewer.setSeriesLayout(undefined, 1, 1, 0, null, tempStudyLayoutId);
                }

            }
            //  dicomViewer.setimageCanvasOfViewPort(key,undefined);
        }
        //}
    }
    /**
     *return true if the image is available in any of the viewport else false
     **/
    function isImageVisible(seriesIndex, imageIndex) {
        for (var viewportId in viewports) {
            var viewportObj = getViewport(viewportId);
            var viewportSeriesIndex = viewportObj.seriesIndex;
            var viewportImageIndex = viewportObj.scrollData.imageIndex;
            if (imageIndex === undefined) {
                if (seriesIndex === viewportSeriesIndex) {
                    return true;
                }
            } else {
                if (seriesIndex === viewportSeriesIndex && imageIndex === viewportImageIndex) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     *return viewport if the image is in view 
     **/
    function getViewportByImageIndex(studyUid, seriesIndex, imageIndex) {
        for (var key in viewports) {
            if (viewports[key].getStudyUid() === studyUid && viewports[key].getSeriesIndex() === seriesIndex && viewports[key].getImageIndex() === imageIndex) {
                if (isImageVisible(viewports[key].getSeriesIndex(), viewports[key].getImageIndex())) {
                    return viewports[key];
                }
            }
        }
        return undefined;
    }

    /**
     *return true if the image is available in any of the viewport else false
     **/
    function checkVewportAvailable(seriesLayoutID, studyUid) {
        var currentViewportIDS = [];
        var check = false;
        var currentStudyUid = studyUid;
        var currentStudyLayoutId = getStudyLayoutId(seriesLayoutID);
        var allviewportIDs = dicomViewer.viewports.getViewportIds();
        var viewPortCount = 0;
        var allstudyVewport = dicomViewer.viewports.getAllViewports();
        var indexCount = 0;
        for (var indexl = 0; indexl < allviewportIDs.length; indexl++) {
            var vewport = dicomViewer.viewports.getViewport(allviewportIDs[indexl]);
            if (vewport !== undefined) {
                currentViewportIDS[indexCount] = allviewportIDs[indexl];
                indexCount++;
            }
        }
        for (var index = 0; index < currentViewportIDS.length; index++) {
            var sVewport = dicomViewer.viewports.getViewport(currentViewportIDS[index])
            var viewportStudyUid = sVewport.studyUid;
            var vewportId = getStudyLayoutId(currentViewportIDS[index]);
            if (vewportId == currentStudyLayoutId && currentStudyUid == viewportStudyUid) {
                check = true;
            }
            if (viewportStudyUid == undefined || viewportStudyUid != currentStudyUid) {
                viewPortCount++;
            }
            if (viewPortCount === currentViewportIDS.length) {
                check = true;
            }
        }
        return check;
    }

    /**
     * Get the view port by index
     * @param {Type} index - specifies the index value 
     * @param {Type} studyId - specifies the study Layout Id
     */
    function getDuplicateViewportByIndex(viewportIndex, studyLayoutId) {
        try {
            if (duplicateViewportsBySeriesIndex != undefined && duplicateViewportsBySeriesIndex != null) {
                var index = Object.keys(duplicateViewportsBySeriesIndex)[viewportIndex];
                if (index.split("_")[1] == studyLayoutId) {
                    return duplicateViewportsBySeriesIndex[index];
                }
            }

            return undefined;
        } catch (e) {}

        return undefined;
    }

    /**
     * Add the duplicate view ports based on the viewport Id
     * @param {Type} viewportId - Specifies the viewport Id
     * @param {Type} viewport - Specifies the viewport object
     */
    function addDuplicateViewportsBySeriesIndex(viewportId, viewport) {
        try {
            for (var index = 0; index <= Object.keys(duplicateViewportsBySeriesIndex).length; index++) {
                if (duplicateViewportsBySeriesIndex[viewportId + "_" + index] == undefined) {
                    duplicateViewportsBySeriesIndex[viewportId + "_" + index] = viewport;
                    break;
                }
            }
        } catch (e) {}
    }

    /**
     * Remove the view port object based on the viewport Id
     * @param {Type} viewportId - Specifies the viewport Id
     */
    function removeDuplicateViewportsBySeriesIndex(viewportId) {
        try {
            for (var index = Object.keys(duplicateViewportsBySeriesIndex).length; index >= 0; index--) {
                if (duplicateViewportsBySeriesIndex[viewportId + "_" + index] != undefined) {
                    delete duplicateViewportsBySeriesIndex[viewportId + "_" + index];
                    break;
                }
            }
        } catch (e) {}
    }

    /**
     * Remove the duplicate view ports based on the study layout
     * @param {Type} studyLayoutId - specifies the study layout value
     */
    function removeDuplicateViewportsByStudyLayout(studyLayoutId) {
        try {
            for (var key in duplicateViewportsBySeriesIndex) {
                var index = key.indexOf(studyLayoutId);
                if (index >= 0) {
                    delete duplicateViewportsBySeriesIndex[key];
                }
            }
        } catch (e) {}
    }

    /**
     * Check whether the view port is already avialable or not
     * @param {Type} isMultiFrame - specifies the muliframe flag
     * @param {Type} index - specifies the series/image index
     */
    function isDuplicateViewport(isMultiFrame, index) {
        try {
            var count = 0;
            for (var key in viewports) {
                var viewport = viewports[key];
                if (isMultiFrame) {
                    if (viewport.scrollData.imageIndex == index) {
                        count++;
                    }
                } else {
                    if (viewport.seriesIndex == index) {
                        count++;
                    }
                }
            }

            if (count > 1) {
                return true;
            }

            return false;
        } catch (e) {}

        return false;
    }

    /**
     * Get the selected view port based on the layout Id
     * @param {Type} studyDiv - specifies the study DivId
     * @param {Type} rowMax - specifies the row max value
     * @param {Type} columnMax - specifies the column max value
     * @param {Type} layoutNumber - specifies the layout number
     */
    function getSelectedViewport(studyDiv, rowMax, columnMax, layoutNumber) {
        try {
            var viewportNumber = 1;
            for (var row = 1; row <= rowMax; row++) {
                for (var column = 1; column <= columnMax; column++) {
                    var viewport = viewports["imageviewer_" + studyDiv + "_" + row + "x" + column];
                    if (viewport != undefined && viewport != null) {
                        if (viewportNumber == layoutNumber) {
                            return viewport;
                        }
                    }
                    viewportNumber++;
                }
            }

            return undefined;
        } catch (e) {}

        return undefined;
    }

    /**
     * Get the view port order number based on the view port list
     * @param {Type} rowMax  - specifies the row value
     * @param {Type} columnMax - specifies the column value
     * @param {Type} layoutId - specifies the layout Id
     */
    function getViewportNumber(rowMax, columnMax, layoutId) {
        try {
            var viewportNumber = 1;
            for (var row = 1; row <= rowMax; row++) {
                for (var column = 1; column <= columnMax; column++) {
                    if ((row + "x" + column) == layoutId) {
                        return viewportNumber;
                    }
                    viewportNumber++;
                }
            }

            return 0;
        } catch (e) {}
    }

    /**
     * Get the backup for image layout dimension while navigating the page 
     * @param {Type} studyUid - specifies the studyUid
     * @param {Type} rowMax - specifies the series layout row value
     * @param {Type} columnMax - specifies the series layout column value
     */
    function getBackupImageLayouts(studyUid, rowMax, columnMax) {
        try {
            if (viewports != null && viewports != undefined) {
                for (var row = 1; row <= rowMax; row++) {
                    for (var column = 1; column <= columnMax; column++) {
                        var viewport = viewports["imageviewer_" + studyUid + "_" + row + "x" + column];
                        if (viewport != null && viewport != undefined) {
                            viewportImageLayouts.push(viewport.getImageLayoutDimension());
                            currentPageImageLayouts[viewport.seriesIndex] = viewport.getImageLayoutDimension();
                        }
                    }
                }
            }
        } catch (e) {}
    }

    /**
     * Get the viewport image layout based on the page series index 
     * @param {Type} seriesIndex - Specifies the series index
     * @param {Type} viewportIndex - Specifies the viewport index
     */
    function getViewportImageLayout(seriesIndex, viewportIndex) {
        try {
            for (var key in currentPageImageLayouts) {
                if (parseInt(key) === seriesIndex) {
                    return currentPageImageLayouts[key];
                }
            }

            return viewportImageLayouts[viewportIndex];
        } catch (e) {}
    }

    /**
     * delete the viewport image layouts
     */
    function deleteViewportImageLayouts() {
        try {
            viewportImageLayouts = [];
            for (var key in currentPageImageLayouts) {
                delete currentPageImageLayouts[key];
            }
        } catch (e) {}
    }

    dicomViewer.viewports = {
        getAllViewportsId: getAllViewportsId,
        addBackupViewport: addBackupViewport,
        getViewport: getViewport,
        addViewport: addViewport,
        removeViewport: removeViewport,
        getViewportIds: getViewportIds,
        getAllViewports: getAllViewports,
        refreshViewports: refreshViewports,
        addSeriesLayoutMaxId: addSeriesLayoutMaxId,
        getSeriesLayoutMaxId: getSeriesLayoutMaxId,
        removeAllViewports: removeAllViewports,
        removeViewportsByStudyLayout: removeViewportsByStudyLayout,
        deleteAndCreateNewViewport: deleteAndCreateNewViewport,
        deleteViewportsByThumbnail: deleteViewportsByThumbnail,
        isImageVisible: isImageVisible,
        checkVewportAvailable: checkVewportAvailable,
        getViewportByImageIndex: getViewportByImageIndex,
        getBackupViewport: getBackupViewport,
        removeBackupViewport: removeBackupViewport,
        addBackupViewportBySeriesIndex: addBackupViewportBySeriesIndex,
        removeBackupViewportBySeriesIndex: removeBackupViewportBySeriesIndex,
        removeAllBackupViewportBySeriesIndex: removeAllBackupViewportBySeriesIndex,
        getBackupViewportBySeriesIndex: getBackupViewportBySeriesIndex,
        backupViewableViewportsBySeriesIndex: backupViewableViewportsBySeriesIndex,
        getDuplicateViewportByIndex: getDuplicateViewportByIndex,
        addDuplicateViewportsBySeriesIndex: addDuplicateViewportsBySeriesIndex,
        removeDuplicateViewportsBySeriesIndex: removeDuplicateViewportsBySeriesIndex,
        removeDuplicateViewportsByStudyLayout: removeDuplicateViewportsByStudyLayout,
        isDuplicateViewport: isDuplicateViewport,
        getSelectedViewport: getSelectedViewport,
        getViewportNumber: getViewportNumber,
        getBackupImageLayouts: getBackupImageLayouts,
        getViewportImageLayout: getViewportImageLayout,
        deleteViewportImageLayouts: deleteViewportImageLayouts
    };


    return dicomViewer;
}(dicomViewer));
