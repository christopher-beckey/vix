/**
 * This module deals with linking series within a study
 */

var dicomViewer = (function (dicomViewer) {
    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var linkGroup = [];
    var activeStudyUid = null;
    var activeViewportId = null;
    var isLinkToolActive = false;

    function linkSeries() {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var studyUid = seriesLayout.getStudyUid();

        if (isLinkToolActive) {
            if (activeStudyUid == studyUid && activeViewportId !== seriesLayout.getSeriesLayoutId()) {
                var seriesGroup = [];
                var isStudyExists = false;
                $.each(linkGroup, function (key, value) {
                    if (value.studyUid == activeStudyUid) {
                        seriesGroup = linkGroup[key].linkedSeries;
                        isStudyExists = true;
                        return false;
                    }
                });
                seriesGroup.push({
                    sourceViewportId: activeViewportId,
                    targetViewportId: seriesLayout.getSeriesLayoutId()
                });

                if (!isStudyExists) {
                    linkGroup.push({
                        studyUid: activeStudyUid,
                        linkedSeries: seriesGroup
                    });
                }

                isLinkToolActive = false;
            } else {
                resetActiveLinkData();
            }
        } else {
            setActiveLinkData(seriesLayout);
        }
    }

    function unLinkSeries(seriesId) {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var studyUid = seriesLayout.getStudyUid();

        var isLinked = false;
        var arrIndex = null;

        $.each(linkGroup, function (key, value) {
            if (value.studyUid == studyUid) {
                $.each(value.linkedSeries, function (key, value_) {
                    if (value_.sourceViewportId === seriesLayout.getSeriesLayoutId() ||
                        value_.targetViewportId === seriesLayout.getSeriesLayoutId()) {
                        isLinked = true;
                    }

                    if (isLinked) {
                        arrIndex = key;
                        return false;
                    }
                });

                if (isLinked) {
                    value.linkedSeries.splice(arrIndex, 1);
                    return true;
                }
            }
        });
    }

    function isLinkEnabled() {
        try {
            var seriesLayout = dicomViewer.getActiveSeriesLayout();
            if (seriesLayout === undefined || seriesLayout === null || seriesLayout.seriesIndex === undefined) {
                return false;
            }

            var studyUid = seriesLayout.getStudyUid();
            var studyDetials = dicomViewer.getStudyDetails(studyUid);
            var numberOfSeries = dicomViewer.Study.getSeriesCount(studyUid);
            var isCheck = false;

            // Show or hide the link menu
            if (dicomViewer.Study.getSeriesCount(seriesLayout.getStudyUid()) > 1) {
                isCheck = true;
            } else {
                var numberOfImages = dicomViewer.Series.getImageCount(seriesLayout.getStudyUid(), 0);
                if (numberOfImages > 1 && dicomViewer.thumbnail.isSeriesContainsMultiframe(seriesLayout.getStudyUid(), 0)) {
                    isCheck = true;
                } else {
                    isCheck = false;
                }
            }

            if (isCheck == true && dicomViewer.thumbnail.isSeriesContainsMultiframe(seriesLayout.getStudyUid(), 0)) {
                var image = dicomViewer.Series.Image.getImage(studyUid, seriesLayout.seriesIndex, seriesLayout.scrollData.imageIndex);
                if (image && image.numberOfFrames <= 1 && !isSeriesLinked()) {
                    isCheck = false;
                }
            }

            dicomViewer.EnableDisableReferenceLineMenu(seriesLayout);
            if (studyDetials !== null && studyDetials !== undefined) {
                if (seriesLayout.imageType === IMAGETYPE_RADECG || seriesLayout.imageType === IMAGETYPE_RADPDF || isCheck == false) {
                    return false;
                }
                if (studyDetials.isDicom) {
                    return true;
                }
            }
        } catch (e) {}

        return false;
    }

    function updateLinkMenu() {
        var cursor = document.getElementById('viewport_View').style.cursor;
        if (cursor != 'url("images/link.cur"), auto' && cursor != 'url(images/link.cur), auto') {
            resetActiveLinkData();
        }

        $("#linkButton_overflow").css("background-color", "#363636");

        if (isLinkEnabled()) {
            $(".linkSeries").show();
            $("#linkButton").removeClass("k-state-disabled");
            $("#linkButton_overflow").show();
            $(".linkSeries").text(isSeriesLinked() ? "UnLink Viewport" : "Link Viewport");
            $("#context-link").show();
            $("#context-link-menu").show();
        } else {
            $(".linkSeries").hide();
            $("#linkButton").addClass("k-state-disabled");
            $("#linkButton_overflow").hide();
            $("#context-link").hide();
            $("#context-link-menu").hide();
        }
    }

    function setActiveLinkData(seriesLayout) {
        activeStudyUid = seriesLayout.getStudyUid();
        activeViewportId = seriesLayout.getSeriesLayoutId();
        isLinkToolActive = true;
    }

    function getLinkToolActive() {
        return isLinkToolActive;
    }

    function isSeriesLinked(sourceViewport) {
        var seriesLayout = undefined;
        if (sourceViewport !== undefined) {
            seriesLayout = sourceViewport;
        } else {
            seriesLayout = dicomViewer.getActiveSeriesLayout();
        }

        var studyUid = seriesLayout.getStudyUid();
        var isLinked = false;

        $.each(linkGroup, function (key, value) {
            if (value.studyUid == studyUid) {
                value.linkedSeries.some(function (seriesGroup) {
                    if (seriesGroup.sourceViewportId === seriesLayout.getSeriesLayoutId() ||
                        seriesGroup.targetViewportId === seriesLayout.getSeriesLayoutId()) {
                        isLinked = true;
                    }

                    if (isLinked) {
                        return true;
                    }
                });
            }
        });

        return isLinked;
    }

    function resetActiveLinkData() {
        activeStudyUid = null;
        activeViewportId = null;
        isLinkToolActive = false;
    }

    /**
     * Perform the link operation
     * @param {Type} sourceViewport - Specifies the source view port
     * @param {Type} moveToNext - Flag to navigate forward or backward
     */
    function doLink(sourceViewport, moveToNext, direction, cineMode) {
        try {
            if (sourceViewport === undefined || sourceViewport === null) {
                return;
            }

            if (isSeriesLinked(sourceViewport) !== true) {
                return;
            }

            var targetViewportId = getTargetViewport(sourceViewport);

            var viewport = dicomViewer.viewports.getViewport(targetViewportId);
            if (viewport === undefined || viewport === null) {
                return;
            }

            if (cineMode != undefined) {
                if (cineMode) {
                    dicomViewer.scroll.runCineImage(direction, viewport);
                } else {
                    dicomViewer.scroll.stopCineImage(direction, viewport);
                }
            } else {
                dicomViewer.scroll.moveToNextOrPreviousImage(moveToNext, viewport);
            }
        } catch (e) {}
    }

    /**
     * To get the target viewport id, linked with the source viewport
     * @param {Type} sourceViewport - Specifies the source viewport
     */
    function getTargetViewport(sourceViewport) {
        var targetViewportId = undefined;
        $.each(linkGroup, function (key, value) {
            if (value.studyUid === sourceViewport.getStudyUid()) {
                value.linkedSeries.some(function (seriesGroup) {
                    if (seriesGroup.sourceViewportId === sourceViewport.getSeriesLayoutId()) {
                        targetViewportId = seriesGroup.targetViewportId;
                    } else if (seriesGroup.targetViewportId === sourceViewport.getSeriesLayoutId()) {
                        targetViewportId = seriesGroup.sourceViewportId;
                    }

                    if (targetViewportId !== undefined) {
                        return true;
                    }
                });
            }
        });
        return targetViewportId;
    }

    dicomViewer.link = {
        linkSeries: linkSeries,
        unLinkSeries: unLinkSeries,
        updateLinkMenu: updateLinkMenu,
        getLinkToolActive: getLinkToolActive,
        isSeriesLinked: isSeriesLinked,
        resetActiveLinkData: resetActiveLinkData,
        doLink: doLink,
        getTargetViewport: getTargetViewport
    }

    return dicomViewer;
}(dicomViewer));
