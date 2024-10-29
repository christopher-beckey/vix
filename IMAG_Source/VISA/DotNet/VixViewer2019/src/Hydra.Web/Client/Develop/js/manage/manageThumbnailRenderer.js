/**
 * Create thumbnail images
 *  */
function ThumbnailRenderer() {
    this.uid = BasicUtil.GetV4Guid();
    this.imageURL;
    this.renderWidget = document.createElement("canvas");
    this.renderWidget.width = THUMBNAIL_PANEL_WIDTH - 32;
    this.renderWidget.height = 105;
    this.renderWidget.setAttribute("id", "thumb" + this.uid);
    this.touchEvent = false;
    this.gestureEvent = false;
    this.seriesIndex;
    this.studyUid;
    this.imageUid;
};

/**
 *@param imageUid
 *@param appendTo
 *@param seriesIndex
 *@param imageCountOfSeries
 *Create the thumbnail url and send request when the requeststatus is success
 *create the div for series thumbnail and draw the thumbnail image in canvas
 */
var thumbWidth;
var thumbHeight;
ThumbnailRenderer.prototype.createThumbnail = function (thumbnailData) {
    try {
        this.studyUid = thumbnailData.studyUid;
        this.seriesIndex = thumbnailData.seriesIndex;
        this.imageUid = thumbnailData.imageUid;
        this.imageIndex = thumbnailData.imageIndex;
        this.imageCountOfSeries = thumbnailData.imageCountOfSeries;
        this.seriesCount = thumbnailData.seriesCount;
        this.imageCount = thumbnailData.imageCount;
        this.isImage = thumbnailData.isImage;
        this.selectedThumbnailId = thumbnailData.selectedThumbnailId;
        this.imageLoaded = thumbnailData.imageLoaded;
        this.cachedImage = thumbnailData.cachedImage;

        // display the place holder
        var ctx = this.renderWidget.getContext('2d');
        var img = new Image();
        document.getElementById(thumbnailData.parent).appendChild(this.renderWidget);
        if (!thumbWidth) {
            thumbWidth = document.getElementById(thumbnailData.parent).offsetWidth;
            thumbHeight = document.getElementById(thumbnailData.parent).offsetHeight;
        }

        var isDisplay = thumbnailData.isImage ? "block" : "none";
        var modality = "&nbsp";
        var instanceNumber = "";
        var totalImages = "1/" + this.imageCount;
        if (thumbnailData.isImage) {
            totalImages = "";
            instanceNumber = thumbnailData.image.caption;
        }

        var imageIndex = thumbnailData.isImage ? thumbnailData.imageIndex : "";
        var dataDivId = "imageviewer_" + replaceSpecialsValues(thumbnailData.studyUid) + "_" + (thumbnailData.seriesIndex) + "_datadiv" + imageIndex;
        if (!document.getElementById(dataDivId)) {
            var datadiv = "<div id='" + dataDivId + "' class='rows' style='width:100%'>" +
                "<div style='width:100%'><table style='width:100%'><tr style='width:100%'><td style='width:40%;padding-left:5px'><font color='#D2F4EF'>" + instanceNumber + "</font></td><td style='width:60%;padding-right:5px'><font size=2 color='#D2F4EF'>" + totalImages + "</font></td></tr></table></div></div>" + "<div class='col-xs-2' style='display:" + isDisplay + "' ><font color='#D2F4EF'>" + totalImages + "</font></div>";

            $("#" + thumbnailData.parent).append(datadiv);
        }

        //Show the series description in the thumbnail
        var seriesDescText = thumbnailData.image.description;
        var seriesDesc = dicomViewer.thumbnail.showSeriesDescription(thumbnailData);

        if (seriesDesc) {
            $("#" + thumbnailData.parent).prepend(seriesDesc);
        }

        if (thumbnailWidth == undefined) {
            thumbnailWidth = document.getElementById(thumbnailData.parent).offsetWidth;
        }
        if (thumbnailHeight == undefined) {
            thumbnailHeight = document.getElementById(thumbnailData.parent).offsetHeight;
        }

        if (thumbnailHeight && thumbnailWidth && thumbnailData.parent) {
            document.getElementById(thumbnailData.parent).style.height = thumbnailHeight + "px";
            document.getElementById(thumbnailData.parent).style.width = thumbnailWidth + "px";
        }

        var imageData = getImageData(this.imageUid);
        if (imageData != undefined && imageData != null) {
            this.draw(this.studyUid, imageData, thumbnailData.parent);
        } else {
            img.src = "../images/placeholder.png";
            img.ctx = ctx;
            img.onload = function () {
                if (this.ctx.isImageDataLoaded != true) {
                    this.ctx.drawImage(img, 0, 0, img.width, img.height, 3, 3, thumbWidth - 10, thumbHeight - 15);
                }
            }

            var workerJob = {
                studyUid: this.studyUid,
                imageUid: this.imageUid,
                appendTo: thumbnailData.parent,
                sourceImage: thumbnailData.image,
                thumbRendererObject: this,
                type: "manage",
                isProcessing: false,
            };
            doWorkerQueue(workerJob);
        }

        return;
    } catch (e) {}
}

/**
 *@param dataURL
 *Using the dataURL(contaions the url path of thumbnail image) display thumbnail image
 */
ThumbnailRenderer.prototype.draw = function (studyUid, dataURL, thumbnailId) {
    if ($("#" + thumbnailId)[0].renderer.imageLoaded && this.isImage) {
        return;
    }
    var context = this.renderWidget.getContext("2d");
    var imageCount = dicomViewer.Series.getImageCount(studyUid, this.seriesIndex);
    //For shifting the thumbnail image at the center (movement along x-axis)
    var widthMultiplier = ($("#" + thumbnailId).width()) / 100;
    // load image from data url
    var imageObj = new Image();
    imageObj.onload = function (eve) {
        context.clearRect(0, 0, context.canvas.width, context.canvas.height);
        context.translate(50 * widthMultiplier, 50);
        var scale = Math.min(100 / this.width, 100 / this.height);
        context.scale(scale, scale);
        context.drawImage(this, -this.width / 2, -this.height / 2);
        context.fillStyle = "yellow";
        context.font = "bold 8pt Helvetica";
        context.isImageDataLoaded = true;
        var lastDivId = $("#manage_ImageThumbnail_View div").last().parent().parent().attr('id');
        $("#" + thumbnailId)[0].renderer.imageLoaded = true;
    };
    imageObj.src = dataURL;
};

ThumbnailRenderer.prototype.getStudyUid = function () {
    return this.studyUid;
}

function toggleThumbnailLayout(ev) {
    try {
        if (ev.currentTarget.id !== undefined && ev.currentTarget.id !== null) {
            var thumbnailRenderer = $("#" + ev.currentTarget.id)[0].renderer;
            var studyUid = thumbnailRenderer.getStudyUid();
            dicomViewer.thumbnail.createImageThumbnail(studyUid, thumbnailRenderer.seriesIndex);
        }
    } catch (e) {}
}

function loadSeries(ev) {
    if (ev && !ev.shiftKey) {
        if (!$("#" + ev.currentTarget.id).hasClass("selected-thumbnail-view")) {
            dicomViewer.thumbnail.selectSeries(ev.currentTarget.id);
        }
    }
}

function loadImage(ev) {
    if (ev && !ev.shiftKey) {
        if (!$("#" + ev.currentTarget.id).hasClass("selected-image-thumbnail-view")) {
            dicomViewer.thumbnail.selectImage(ev.currentTarget.id);
        }
    }
}

/**
 * Show or hide the image thumbnail context menu based on the target id
 */
function showThumbnailContextMenu(event) {
    // TODO : In Future
}

/**
 * Image manage viewer context menu
 */
var isShowContextMenu = false;
$(document).ready(function () {
    if (isShowContextMenu) {
        $("#imageThumbnailContextMenu").kendoContextMenu({
            target: "#manage_viewer",
            open: function (e) {
                if (e.event.target.id !== "manage_viewer") {
                    $("#context-MarkDelete").show();
                    $("#context-MarkSensitive").show();
                } else {
                    $("#context-MarkDelete").hide();
                    $("#context-MarkSensitive").hide();
                }
                $('.k-animation-container').css({
                    'width': '',
                    position: 'relative'
                });
            }
        });
    }
});

/**
 * Thumbnail check event fot study,series and image level
 * @param {Type} ev 
 */
function thumbnailCheckEvent(e, ev) {
    try {
        if (ev.id !== undefined && ev.id !== null) {
            var fields = ev.id.split('_');
            if (fields.length == undefined || fields.length == 0) {
                return;
            }

            if (fields.length == 3) {
                var thumbnailId = fields[0] + "_" + fields[1] + "_0_thumb";
                var thumbnailRenderer = $("#" + thumbnailId)[0].renderer;
                selectedThumbnailRender = thumbnailRenderer;
                dicomViewer.thumbnail.checkStudy(thumbnailRenderer.getStudyUid(), ev.checked);
                dicomViewer.thumbnail.enableOrDisableImageOptions();
            } else if (fields.length == 5) {
                var thumbnailId = fields[0] + "_" + fields[1] + "_" + fields[2] + "_" + fields[3];
                var thumbnailRenderer = $("#" + thumbnailId)[0].renderer;
                selectedThumbnailRender = thumbnailRenderer;
                var studyUid = thumbnailRenderer.getStudyUid();
                dicomViewer.thumbnail.checkSeriesOrImages(thumbnailId, (fields[3] === "thumb" ? true : false), e);
                dicomViewer.thumbnail.enableOrDisableImageOptions();
            }
        }

        disabledEventPropagation(ev);
    } catch (e) {}
}

/*
 * Handling the event within the target so that it will not propagated up
 * @param {Type} event
 */
function disabledEventPropagation(event) {
    if (event.stopPropagation) {
        event.stopPropagation();
    } else if (window.event) {
        window.event.cancelBubble = true;
    }
}
