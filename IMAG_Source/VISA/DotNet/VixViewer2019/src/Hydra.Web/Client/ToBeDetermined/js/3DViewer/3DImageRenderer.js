var angleDefaults = [0, 90, 180, 270];
var orientationDefaults = [
    {
        rotate: 0,
        mirror: 0,
        rotateLeft: 1,
        rotateRight: 3,
        flipHorz: 4,
        flipVert: 6,
        left: 0,
        right: 1,
        top: 2,
        bottom: 3
    }, // 0 --> Rotate 0

    {
        rotate: 3,
        mirror: 0,
        rotateLeft: 2,
        rotateRight: 0,
        flipHorz: 7,
        flipVert: 5,
        left: 2,
        right: 3,
        top: 1,
        bottom: 0
    }, // 1 --> Rotate 270
    {
        rotate: 2,
        mirror: 0,
        rotateLeft: 3,
        rotateRight: 1,
        flipHorz: 6,
        flipVert: 4,
        left: 1,
        right: 0,
        top: 3,
        bottom: 2
    }, // 2 --> Rotate 180
    {
        rotate: 1,
        mirror: 0,
        rotateLeft: 0,
        rotateRight: 2,
        flipHorz: 5,
        flipVert: 7,
        left: 3,
        right: 2,
        top: 0,
        bottom: 1
    }, // 3 --> Rotate 90

    {
        rotate: 0,
        mirror: 1,
        rotateLeft: 5,
        rotateRight: 7,
        flipHorz: 0,
        flipVert: 2,
        left: 1,
        right: 0,
        top: 2,
        bottom: 3
    }, // 4 -> Rotate 0 + Horizontal Flip
    {
        rotate: 3,
        mirror: 1,
        rotateLeft: 6,
        rotateRight: 4,
        flipHorz: 3,
        flipVert: 1,
        left: 2,
        right: 3,
        top: 0,
        bottom: 1
    }, // 5 -> Rotate 270 + Vertical Flip
    {
        rotate: 2,
        mirror: 1,
        rotateLeft: 7,
        rotateRight: 5,
        flipHorz: 2,
        flipVert: 0,
        left: 0,
        right: 1,
        top: 3,
        bottom: 2
    }, // 6 -> Rotate 180 + Horizontal Flip
    {
        rotate: 1,
        mirror: 1,
        rotateLeft: 4,
        rotateRight: 6,
        flipHorz: 1,
        flipVert: 3,
        left: 3,
        right: 2,
        top: 1,
        bottom: 0
    }]; // 7 -> Rotate 90 + Vertical Flip
var previousLayoutSelection = "";

// Secure Random Function
function cryptoRandom_3D() {
    var RandArray = new Uint32Array(2);
    (window.crypto || window.msCrypto).getRandomValues(RandArray);
    return (RandArray[0] / (0xffffffff + 1));
}

//Function to generate a guid
function S4() {
    return (((1 + cryptoRandom_3D()) * 0x10000) | 0).toString(16).substring(1);
}
function guid() {
    return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4()
            + S4() + S4());
}
function ImageRenderer(appendTo,seriesLevelDivId) {

    this.imagePromise;
    this.uid = guid();
    this.anUIDs;
    this.invertFlag = false;
    this.zoomFlag = false;
    this.tScaleValue = 1;
    this.isPresetDefault = false;

    //scale value use to display the zoom precentage in overylay
    //this.scaleValue changes in renderImage, doZoom, refresh and revert methods
    this.scaleValue;

    this.seriesLevelDivId = seriesLevelDivId;
    this.parentElement = appendTo;
    this.renderWidget = document.createElement("canvas");
    this.renderWidget.setAttribute("id", this.uid);

    this.renderWidgetLayer = document.createElement("canvas");
    this.renderWidgetLayer.style.zIndex = "10";
    this.renderWidgetLayer.style.position = "absolute";

    this.overlayCanvas = document.createElement("canvas");
    this.overlayCanvas.style.zIndex = "2";
    this.overlayCanvas.style.position = "absolute";

    var appendToElement = $('#' + appendTo);
    var appendToOuterWidth = appendToElement.outerWidth();
    var appendToOuterHeight = appendToElement.outerHeight();

    var wPadding = appendToOuterWidth - appendToElement.width();
    var hPadding = appendToOuterHeight - appendToElement.height();

    this.viewportWidth = appendToOuterWidth;
    this.viewportHeight = appendToOuterHeight;

    this.renderWidget.width = this.viewportWidth - wPadding - 5;
    this.renderWidget.height = this.viewportHeight - hPadding - 5;
    this.renderWidgetLayer.width = this.viewportWidth - wPadding;
    this.renderWidgetLayer.height = this.viewportHeight - hPadding;
    this.overlayCanvas.width = this.viewportWidth - 5;
    this.overlayCanvas.height = this.viewportHeight - 5;

    this.renderWidget.style.margin = 5 + 'px';

    appendToElement.append(this.renderWidget);
    appendToElement.append(this.renderWidgetLayer);
    appendToElement.append(this.overlayCanvas);

    this.renderWidget.style.zIndex = "1";
    this.renderWidget.style.position = "absolute";
    this.touchEvent = false;
    this.gestureEvent = false;
    this.seriesIndex = -1;
    this.imageIndex = -1;
    this.imageUid = "";
    this.selfReference = this;
    this.presentationState = undefined;
    this.headerInfo = undefined;
    //Set default as window width
    this.ecgScalepreset = 2;
    this.tempEcgScale = 0;
    //Added for Zoom Feature
    var ctx = this.renderWidget.getContext('2d');
    this.imageCanvas = document.createElement("canvas");
    this.imageCanvas.canvasId = this.parentElement;
    trackTransforms(ctx);
    this.renderWidgetCtx = ctx;
    this.validDoubleClick = false;

    var addMouseHandler = function handleMouseEvent(imageRenderer) {
        var self = imageRenderer;
        var lastClickTimeStamp;
        var isStackNavigation = false;
        var lastMousePosition =
            {
                ptX : undefined,
                ptY : undefined,
                imageIndex : undefined,
                frameIndex : undefined,
                useStartPosition : false
            }

        this.handleEvent = function(evt) {
            if(self.seriesLevelDivId !== dicomViewer.getActiveSeriesLayout().getSeriesLayoutId()) return;
            displayCompressinToolTip(evt,self);
            var tool = dicomViewer.mouseTools.getActiveTool();
            if (tool) {
                tool.setActiveImageRenderer(self);
                if (evt.type === "mouseup" && (evt.which === 3 || (evt.which === 1 &&  dicomViewer.mouseTools.getToolName() === TOOLNAME_WINDOWLEVEL_ROI))) {
                    tool.hanleMouseUp(evt);
                }
                else if (evt.type === "mousedown" && (evt.which === 1 || dicomViewer.mouseTools.getToolName() === TOOLNAME_WINDOWLEVEL_ROI)) {
                    //Calculating the time difference in the two consecutive clicks to determine whether it is double-click event or not
                    if(lastClickTimeStamp == null) {
                        lastClickTimeStamp = 200;
                    }
                    var diff;
                    if(lastClickTimeStamp != evt.timeStamp) {
                        diff = evt.timeStamp - lastClickTimeStamp;
                    }
                    //If the two clicks time difference is less than 300ms then considering it as double-click event
                    if(diff > 300) {
                        tool.hanleMouseDown(evt);
                    } else {
                        tool.hanleMouseMove(evt, true);
                        tool.hanleMouseDown(evt);
                    }
                    lastClickTimeStamp = evt.timeStamp;
                } else if (evt.type === "mousedown"  && evt.which === 2) {
                    lastMousePosition.ptX = undefined;
                    lastMousePosition.ptY = undefined;
                    lastMousePosition.useStartPosition = false;
                } else if (evt.type === "mouseup"  && evt.which === 1) {
                    tool.hanleMouseUp(evt);
                } else if (evt.type === "mouseup"  && evt.which === 2) {
                    if (isStackNavigation) {
                        isStackNavigation = false;
                        dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getDefaultTool());
                        $('#viewport_View').css('cursor', 'default');
                    } else {
                        dicomViewer.scroll.toggleCineRunning();
                    }
                } else if (evt.type === "mouseover") {
                    tool.hanleMouseOver(evt);
                } else if (evt.type === "mousemove" && dicomViewer.mouseTools.getToolName() === TOOLNAME_WINDOWLEVEL_ROI) {
                    tool.hanleMouseMove(evt);
                } else if (evt.type === "mouseout") {
                    tool.hanleMouseOut(evt);
                } else if (evt.type === "mousemove" && evt.buttons === 4) {
                    if (lastMousePosition.ptX === undefined || lastMousePosition.ptY === undefined) {
                        lastMousePosition.ptX = evt.clientX;
                        lastMousePosition.ptY = evt.clientY;
                        lastMousePosition.useStartPosition = false;
                    } else {
                        var navigatePos = getNavigation(lastMousePosition, evt);
                        if (navigatePos !== undefined) {
                            isStackNavigation = true;
                            $('#viewport_View').css('cursor','url(images/navigate.cur), auto');
                            dicomViewer.scroll.moveToNextOrPreviousImage(!navigatePos.moveToNext, undefined, navigatePos, lastMousePosition.useStartPosition);
                            if (lastMousePosition.useStartPosition === false) {
                                var seriesLayout = dicomViewer.getActiveSeriesLayout();
                                var imageAndFrameIndex = dicomViewer.scroll.getCurrentImageAndFrameIndex(!navigatePos.moveToNext, seriesLayout);
                                lastMousePosition.imageIndex = imageAndFrameIndex[0];
                                lastMousePosition.frameIndex = imageAndFrameIndex[1];
                                lastMousePosition.useStartPosition = true;
                            }
                        } else {
                            lastMousePosition.ptX = undefined;
                            lastMousePosition.ptY = undefined;
                            lastMousePosition.frameIndex = undefined;
                            lastMousePosition.imageIndex = undefined;
                            lastMousePosition.useStartPosition = false;
                            isStackNavigation = false;
                        }
                    }
                } else if (evt.type === "mousemove" && (evt.buttons === 1 && 
                                                        (dicomViewer.mouseTools.getToolName() === "Zoom"|| 
                                                         dicomViewer.mouseTools.getToolName() === "WindowLevel" || 
                                                         dicomViewer.mouseTools.getToolName() === "pointMeasurement" || 
                                                         dicomViewer.mouseTools.getToolName() === "Pan" || 
                                                         dicomViewer.mouseTools.getToolName() === "lineMeasurement" || 
                                                         dicomViewer.mouseTools.getToolName() === "angleMeasurement" || 
                                                         dicomViewer.mouseTools.getToolName() === 'rectangleMeasurement' || 
                                                         dicomViewer.mouseTools.getToolName() === 'ellipseMeasurement' || 
                                                         dicomViewer.mouseTools.getToolName() === 'mitralMeanGradientMeasurement' ||
                                                         dicomViewer.mouseTools.getToolName() === TOOLNAME_DEFAULTTOOL ||
                                                        dicomViewer.mouseTools.getToolName() === TOOLNAME_SHARPENTOOL))) {
                    tool.hanleMouseMove(evt);
                } else if (evt.type === "mousemove" && evt.buttons === 0 && 
                           (dicomViewer.mouseTools.getToolName() === 'traceMeasurement' ||
                            dicomViewer.mouseTools.getToolName() === 'volumeMeasurement' || 
                            dicomViewer.mouseTools.getToolName() === 'lineMeasurement' || 
                            dicomViewer.mouseTools.getToolName() === 'mitralMeanGradientMeasurement'||
                            dicomViewer.mouseTools.getToolName() === 'angleMeasurement' || 
                            dicomViewer.mouseTools.getToolName() === 'rectangleMeasurement')) {
                    tool.hanleMouseMove(evt);
                } else if (evt.type === "dblclick" && evt.which === 1) {
                    isCineEnabled(true);
                    evt.preventDefault();
                    dicomViewer.mouseTools.setPreviousTool(dicomViewer.mouseTools.getActiveTool());
                    tool.hanleDoubleClick(evt);
                    doubleClick();
                    self.doClickDefaultTool();

                } /*else if (evt.type === "mousewheel" && dicomViewer.mouseTools.getToolName() === 'Zoom') {
					dicomViewer.tools.updateZoomLevelSettings(-1);
					tool.hanleMouseWheel(evt);
				}*/ else if (evt.type === "DOMMouseScroll" && dicomViewer.mouseTools.getToolName() == 'zoom') {
                    tool.hanleMouseWheel(evt);
                } else if (evt.type === "touchmove") {
                    if (this.touchEvent && !this.gestureEvent) {
                        if(evt.touches.length == 1) {
                            //For the mobile devices, if the selected tool is zoom then on moving one finger over the selected viewport it will pan the image
                            if(dicomViewer.mouseTools.getToolName() == 'Zoom') {
                                dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getPanTool());
                            }

                            evt.preventDefault();
                            tool.hanleMouseMove(evt);
                        } else if(evt.touches.length == 2) {
                            //For two touces automatically it will zoom even without selecting the zoom tool from the toolbar
                            dicomViewer.mouseTools.setActiveTool(dicomViewer.mouseTools.getZoomTool());
                            tool.setActiveImageRenderer(self);
                            tool.hanleMouseMove(evt);
                        }
                    }
                } else if (evt.type === "touchstart") {
                    this.touchEvent = true;
                    if (evt.touches.length === 1) {
                        tool.hanleMouseDown(evt);
                        //Calculating the time difference in the two consecutive clicks to determine whether it is double-click gesture or not
                        if(lastClickTimeStamp != evt.timeStamp) {
                            var diff = evt.timeStamp - lastClickTimeStamp;
                        }
                        //If the two clicks time difference is less than 200ms then considering it as double-click gesture
                        if(diff < 200) {
                            this.validDoubleClick = true;
                        }
                        lastClickTimeStamp = evt.timeStamp;
                    } else if(evt.touches.length === 2) {
                        firstTouchPos = evt.touches[0].clientX;
                        secondTouchPos = evt.touches[1].clientX;
                        diffTwoTouches = evt.touches[1].clientX - evt.touches[0].clientX;
                        tool.setActiveImageRenderer(self);
                        tool.hanleMouseDown(evt);
                    }
                } else if (evt.type === "touchend") {
                    if(this.validDoubleClick) {
                        isCineEnabled(true);
                        evt.preventDefault();
                        tool.hanleDoubleClick();
                        doubleClick();
                        this.validDoubleClick = false;
                    } else {
                        evt.preventDefault();
                        tool.hanleMouseUp(evt);
                        this.touchEvent=false;
                    }
                }
            }
        };
        var imageRenderAddEventListener = imageRenderer.renderWidgetLayer;
        var handleEventObj = this.handleEvent;
        imageRenderAddEventListener.addEventListener("mouseup", handleEventObj);
        imageRenderAddEventListener.addEventListener("mousemove", handleEventObj);
        imageRenderAddEventListener.addEventListener("mouseover", handleEventObj);
        imageRenderAddEventListener.addEventListener("mouseout", handleEventObj);
        imageRenderAddEventListener.addEventListener("mousedown", handleEventObj);
        imageRenderAddEventListener.addEventListener("dblclick", handleEventObj);
        imageRenderAddEventListener.addEventListener("touchstart", handleEventObj);
        imageRenderAddEventListener.addEventListener("touchmove", handleEventObj);
        imageRenderAddEventListener.addEventListener("touchend", handleEventObj);
        imageRenderAddEventListener.addEventListener('DOMMouseScroll',handleEventObj);
        imageRenderAddEventListener.addEventListener('mousewheel',handleEventObj);
    };
    addMouseHandler(this);
};

/*Initiate the image render*/
ImageRenderer.prototype.init = function(anUIDs, seriesIndex, imageIndex) {
    this.seriesIndex = seriesIndex;
    this.imageIndex = imageIndex;
    this.anUIDs = anUIDs;
    var aUIDs = anUIDs.split("*");
    this.imageUid = aUIDs[0];
    var frameIndex = aUIDs[1];
    dicomViewer.renderer.setImageRenderer(this.imageUid+"_"+frameIndex,this);
};

ImageRenderer.prototype.loadImageRenderer = function(imagePromise,imagCanvasPresentation,studyUid)
{
    // Added frame index with imaage Id to get image from cache
    /*var imagePromise = dicomViewer.imageCache.getImagePromise(imageUid+frameIndex);
	if(imagePromise === undefined)
	{
		imagePromise = dicomViewer.loadAndCacheImage(imageUid,frameIndex);
	}*/


    if(imagePromise != undefined)
        this.imagePromise = imagePromise;
    this.presentationState = undefined;
    if(this.imagePromise==undefined)
    {
        this.imagePromise =dicomViewer.imageCache.getImagePromise( imagCanvasPresentation.imageUid+"_"+imagCanvasPresentation.frameNumber);
    }

    var imageCanvas = null;
    this.imagePromise.then(function(image) {
        imageCanvas = image;
    });
    dicomViewer.imageCache.setImageData(imageCanvas, this.parentElement);

    var renderer = undefined;
    if(isFullScreenEnabled){
        var sereiesLayout = dicomViewer.getActiveSeriesLayout();
        var activeSeriesLayoutId = sereiesLayout.getSeriesLayoutId();
        var activeViewport = dicomViewer.getActiveSeriesLayout();
        renderer = activeViewport.getImageRender(activeSeriesLayoutId+ "ImageLevel0x0");
    }

    if( this.presentationState == undefined ||  this.presentationState == null){
        this.presentationState = new Presentation();
        if (imageCanvas === undefined || imageCanvas === null) {
            return;
        }
        if(imageCanvas.presentation != null || imageCanvas.presentation != undefined)
        {
            imageCanvas.presentation.copy(this.presentationState );
            this.presentationState.setWindowingdata(imageCanvas.presentation.getWindowCenter(),imageCanvas.presentation.getWindowWidth());
        }
    }

    dicomViewer.renderer.removeImageRenderer(this.imageUid+"_"+imageCanvas.frameNumber);
    var presentation = this.presentationState;//imageCanvas.presentation;
    //this.presentationState = presentation;
    //image presemtation is already exist change the WW and WC based on that
    if(imagCanvasPresentation != undefined) {
        this.imagePromise = dicomViewer.imageCache.getImagePromise(imagCanvasPresentation.imageUid +"_"+ (imagCanvasPresentation.frameNumber));
        this.imageUid = imagCanvasPresentation.imageUid;
        this.anUIDs = imagCanvasPresentation.imageUid +"*"+ (imagCanvasPresentation.frameNumber);
        this.imageIndex = (imagCanvasPresentation.imageIndex == undefined) ? this.imageIndex: imagCanvasPresentation.imageIndex;
        presentation.setWindowingdata(imagCanvasPresentation.lastAppliedwindowCenter,imagCanvasPresentation.lastAppliedWindowWidth);
        presentation.setOrientation(imagCanvasPresentation.presentation.getOrientation());
        this.applyOrRevertDisplaySettings(presentation, false, false, undefined);
    }
    else {
        // Apply the display settings
        this.applyOrRevertDisplaySettings(presentation, true, false, undefined);
    }

    var dicominfo = imageCanvas.dicominfo;
    this.headerInfo = dicominfo;
    var row = dicominfo.getRows();
    var column = dicominfo.getColumns();
    presentation.currentPreset = 0;
    isRevert = true;
    if((imageCanvas.windowCenter != presentation.windowCenter ||
        imageCanvas.windowWidth != presentation.windowWidth
        || imageCanvas.invert != presentation.invert) && imagCanvasPresentation == undefined )
    {
        if(imageCanvas.invert != presentation.invert)
        {
            var invertData = !presentation.invert;
            presentation.setInvertFlag(invertData);
            imageCanvas.presentation.invert = invertData;
        }
        presentation.setWindowingdata(imageCanvas.windowCenter,imageCanvas.windowWidth);
        //dicomViewer.updateImage(this.imageCanvas,imageCanvas,presentation);
    }
    if(dicominfo.imageInfo.numberOfFrames < 2 && dicominfo.imageInfo.modality !== "US" && dicominfo.imageInfo.imageType != IMAGETYPE_JPEG) {
        imageCanvas.isWLApplied = false;
        dicomViewer.updateImage(this.imageCanvas,imageCanvas,presentation);
    }

    var ctx = this.renderWidgetCtx;
    ctx.setTransform(1, 0, 0, 1, 0, 0);
    var scaleFactor = undefined;
    if(renderer != undefined && isFullScreenEnabled){
        scaleFactor = renderer.scaleValue;
        if(scaleFactor != undefined){
            imageCanvas.presentation.zoom = scaleFactor;
            presentation.zoomLevel = renderer.presentationState.zoomLevel;
            imageCanvas.presentation.zoomLevel = renderer.presentationState.zoomLevel;
        }
    }

    if(scaleFactor == undefined){
        scaleFactor = presentation.getZoom();
    }
    var pan = presentation.getPan();
    ctx.translate( this.renderWidget.width/2,this.renderWidget.height/2);

    if (presentation.isScaleToFitMode())
    {
        scaleFactor = this.getZoomFactor(1, row, column);
        presentation.setZoom(scaleFactor);
        imageCanvas.presentation.setPresentationMode("SCALE_TO_FIT");
        this.scaleValue = scaleFactor;
        pan.x = -column/2;
        pan.y= -row/2;
    }
    else if (presentation.getPresentationMode() == "MAGNIFY")
    { //For retaining the zoom value after dbl-click
        imageCanvas.presentation.setZoom(scaleFactor);
        imageCanvas.presentation.setPresentationMode("MAGNIFY");
        this.scaleValue = scaleFactor;
        pan.x = -column/2;
        pan.y= -row/2;
    }

    this.renderImage(true);

    // Apply the zoom
    if(presentation !== undefined) {
        var zoomLevel = undefined;
        if(presentation.zoomLevel !== undefined && presentation.zoomLevel !== -1) {
            zoomLevel = presentation.zoomLevel;
        } else if(imageCanvas.presentation !== undefined && imageCanvas.presentation.zoomLevel === -1) {
            zoomLevel = "6_zoom" + "-" + (parseFloat(imageCanvas.presentation.zoom) * 100).toString();
        }

        if(zoomLevel !== undefined) {
            this.setZoomLevel(zoomLevel);
        }
    }
};

/*Refresh*/
ImageRenderer.prototype.refresh = function(imageToRender, anUIDs,presentationRefreshStatus, imageIndex, seriesIndex, isPlayStudy) {
    this.anUIDs = anUIDs;
    var aUIDs = anUIDs.split("*");
    this.imageUid= aUIDs[0];
    var frameIndex=aUIDs[1];
    this.imageCanvas = document.createElement("canvas");
    this.imageCanvas.canvasId = this.parentElement;
    var seriesLayout = dicomViewer.getActiveSeriesLayout();

    //If the current playing series index and the series index of the next image is not same then considering it change in the series and for the new series the presentation values will be different.
    if(this.seriesIndex !== seriesIndex) {
        presentationRefreshStatus = true;
    }
    this.seriesIndex = seriesIndex;
    this.imageIndex = imageIndex;
    if(imageToRender == null)
    {
        //Load image
        var imagePromise = dicomViewer.imageCache.getImagePromise(this.imageUid+"_"+frameIndex);
        if(imagePromise === undefined)
        {
            imagePromise = dicomViewer.loadAndCacheImage(this.imageUid,frameIndex,seriesIndex);
        }
        this.imagePromise = imagePromise;
    }
    else
    {
        this.imagePromise = imageToRender;
    }

    var viewPortDivId = $('#'+this.parentElement).parent().closest('div').attr('id');

    var render = this;
    this.imagePromise.done(function(image) {
        imageCanvas = image;
    });
    dicomViewer.imageCache.setImageData(imageCanvas, this.parentElement);

    //Viewer is blank(this.presentationState is undefined) while play cine and scroll images
    if( this.presentationState == undefined || this.presentationState == null){
        this.presentationState = new Presentation();
        if (imageCanvas === undefined || imageCanvas === null) {
            return;
        }
        if(imageCanvas.presentation != null || imageCanvas.presentation != undefined)
        {
            imageCanvas.presentation.copy(render.presentationState );
            this.presentationState.setWindowingdata(imageCanvas.lastAppliedwindowCenter, imageCanvas.lastAppliedWindowWidth);
            //To avoid panning the images in the viewport while play cine and scroll images
            var ctx =  this.renderWidgetCtx;
            ctx.setTransform(1, 0, 0, 1, 0, 0);
            ctx.translate(this.renderWidget.width/2,this.renderWidget.height/2);
        }
        presentation = this.presentationState;
    }


    if(viewPortDivId == seriesLayout.getSeriesLayoutId())
    {
        if(imageCanvas != null )
        {
            //seriesLayout.setImageIndex(this.imageIndex);
            //seriesLayout.setFrameIndex(imageCanvas.frameNumber);
            //imageCanvas.seriesIndex = this.seriesIndex;
            //imageCanvas.imageIndex = this.imageIndex;
            dicomViewer.setimageCanvasOfViewPort(viewPortDivId,imageCanvas, imageCanvas.presentation);
        };
    }

    var dicominfo = imageCanvas.dicominfo;
    var row = dicominfo.getRows();
    var column = dicominfo.getColumns();


    var presentation = this.presentationState;//imageCanvas.presentation;
    if(presentation != undefined)
    {
        //presentation = imageCanvas.presentation;
        //this.presentationState = presentation;
        // return;

        var scaleFactor = presentation.getZoom();
        var pan = presentation.getPan();
        if (presentation.isScaleToFitMode())
        {
            scaleFactor = Math.min(this.renderWidget.height / row, this.renderWidget.width / column);
            presentation.setZoom(scaleFactor);
            pan.x = -column/2;
            pan.y= -row/2;
        }

        //When the zoom Flag is false it ill set the defult zoom value
        if(!this.zoomFlag)
        {
            this.scaleValue = scaleFactor;
        }

        //Gets the active viewport
        var layout = dicomViewer.getActiveSeriesLayout();

        //Get all image renderer
        var imageRenders = layout.getAllImageRenders();

        //If the repeat study button is enabled and the next image belongs to next series then applying the last applied window values else for the same series applying the current presentation window level values
        if(isPlayStudy && presentationRefreshStatus) {
            this.presentationState.setWindowingdata(imageCanvas.lastAppliedwindowCenter,imageCanvas.lastAppliedWindowWidth);
        } else {
            this.presentationState.setWindowingdata(presentation.windowCenter,presentation.windowWidth);
        }        
        this.renderImage(true);
        //Falg to check if the passed image renderer is in the active viewport
        var isInActiveViewPort = false;
        var activeRenderer = null;
        for (var iKey in imageRenders)
        {
            if(activeRenderer == null)
            {
                activeRenderer = imageRenders[iKey];
            }
            if( this == imageRenders[iKey])
            {
                isInActiveViewPort = true;
            }
        }
        if(isInActiveViewPort == true)
        {
            dicomViewer.viewports.refreshViewports(this);
        }
    }
};

ImageRenderer.prototype.locationOnScreen= function() {
    var curleft = 0, curtop = 0;
    var obj = this.renderWidget;
    if (obj.offsetParent) {
        do {
            curleft += obj.offsetLeft;
            curtop += obj.offsetTop;
        } while (obj = obj.offsetParent);
        return { x: curleft, y: curtop };
    }
    return undefined;
};

/*Applying preset for images*/
ImageRenderer.prototype.applyPreset = function (preset) {

    var imageCanvas = null;
    this.imagePromise.then(function(image){
        imageCanvas = image;
    });
    var presentation =  this.presentationState;//imageCanvas.presentation;
    presentation.currentPreset = preset;
    switch (parseInt(preset)) {
        case 1:
            presentation.setWindowingdata(imageCanvas.windowCenter,imageCanvas.windowWidth);
            presentation.lookupObj.setInvertData(imageCanvas.invert);
            presentation.invert = imageCanvas.invert;
            this.isPresetDefault = true;
            presentation.windowLevel = 1;
            this.renderImage(false);
            break;

        case 2:
            presentation.setWindowingdata(40,350);
            presentation.windowLevel = 2;
            this.renderImage(false);
            break;

        case 3:
            presentation.setWindowingdata(-600,1500);
            presentation.windowLevel = 3;
            this.renderImage(false);
            break;

        case 4:
            presentation.setWindowingdata(40,80);
            presentation.windowLevel = 4;
            this.renderImage(false);
            break;

        case 5:
            presentation.setWindowingdata(480,2500);
            presentation.windowLevel = 5;
            this.renderImage(false);
            break;

        case 6:
            presentation.setWindowingdata(90,350);
            presentation.windowLevel = 6;
            this.renderImage(false);
            break;

        case 7:
            // for custom window level there are 3 values separated with a "_". Split that and use.
            if(preset.length > 1) {
                var value = preset.split("_");
                presentation.setWindowingdata(parseInt(value[1]),parseInt(value[2]));
                presentation.windowLevel = 7;
                this.renderImage(false);
                break;
            }
                            }

    if(presentation !== undefined) {
        imageCanvas.presentation.setPresetWindowLevelValue(presentation.windowLevel);
    }
};

/* Revert */
ImageRenderer.prototype.revert = function(anUIDs, seriesIndex) {
    //this.init(anUIDs, seriesIndex);
    isCopyAttribute = false;
    var seriesLayout = dicomViewer.getActiveSeriesLayout();
    var imageType = seriesLayout.getImageType();
    this.seriesIndex = seriesIndex;
    this.anUIDs = anUIDs;
    var aUIDs = anUIDs.split("*");
    this.imageUid = aUIDs[0];
    var frameIndex=aUIDs[1];
    var isTraceInComplete = dicomViewer.measurement.isTraceMeasurementEnd();
    var isVolumeComplete = dicomViewer.measurement.isVolumeMeasurementEnd();
    var isAngleComplete = dicomViewer.measurement.isAngleMeasurementEnd();

    //When the trace measurement is incomplete and click the reset button it ill deleted the incomplete
    //trace from the map
    if(isAngleComplete)
    {
        var angleMeasurements = dicomViewer.measurement.getAngleMeasurements(this.imageUid, frameIndex);
        if(angleMeasurements !== undefined)
        {
            delete angleMeasurements[angleMeasurements.length-1];
            dicomViewer.measurement.removeTempdata();
            dicomViewer.measurement.setAngleMeasurementEnd(false);
        }
    }
    //When the trace measurement is incomplete and click the reset button it ill deleted the incomplete
    //trace from the map
    if(isTraceInComplete)
    {
        var traceMeasurements = dicomViewer.measurement.getTraceMeasurements(this.imageUid, frameIndex);
        if(traceMeasurements !== undefined)
        {
            delete traceMeasurements[traceMeasurements.length-1];
            dicomViewer.measurement.removeTempdata();
            dicomViewer.measurement.setTraceMeasurementEnd(false);
        }
    }
    //When the volume measurement is incomplete and click the reset button it ill deleted the incomplete
    //volume from the map
    if(isVolumeComplete)
    {
        var volumeMeasurements = dicomViewer.measurement.getVolumeMeasurements(this.imageUid, frameIndex, seriesLayout.getSeriesLayoutId());
        if(volumeMeasurements !== undefined)
        {
            delete volumeMeasurements[volumeMeasurements.length-1];
            dicomViewer.measurement.setVolumeMeasurementEnd(false);
            dicomViewer.measurement.removeTempdata();
        }
    }
    var imagePromise = dicomViewer.imageCache.getImagePromise(this.imageUid+"_"+frameIndex);
    if(imagePromise === undefined)
    {
        imagePromise = dicomViewer.loadAndCacheImage(seriesLayout.getStudyUid(), this.imageUid,frameIndex,seriesIndex,imageType);
    }

    var presentation;
    var imageCanvas;
    imagePromise.then(function(image){
        imageCanvas = image;
        presentation = image.presentation;
    });

    if(presentation != undefined)
        this.scaleValue = presentation.getZoom();
    this.zoomFlag = false;
    this.applyOrRevertDisplaySettings(undefined, undefined, true, undefined);
    this.loadImageRenderer(imagePromise);
};

ImageRenderer.prototype.doStartZoomDrag =function(lastX,lastY){
    var ctx = this.renderWidgetCtx;
    var pt = ctx.transformedPoint(lastX,lastY);
    return pt;
};

/* Apply RGB values */
ImageRenderer.prototype.applyRGB =function(rgbMode){
    var imageCanvas = null;
    var render = this;
    this.imagePromise.then(function(image) {
        imageCanvas = image;
        render.presentationState.setRGBMode(rgbMode);
        dicomViewer.updateImage(render.imageCanvas,imageCanvas, render.presentationState);
        render.drawDicomImage();
    });
}

/* Zoom the image on left mouse scroll based on current mouse pointer */
ImageRenderer.prototype.doZoom =function(clicks,lastX,lastY){

    //	this.presentationState.factor = "zoom"
    var factor = 0;
    var imageCanvas = null;
    this.imagePromise.then(function(image) {
        imageCanvas = image;
    });
    if(clicks > 0) factor = parseFloat(this.scaleValue) + 0.10;
    else factor = parseFloat(this.scaleValue) - 0.10;
    if (factor > 8.0 && this.scaleValue < 8.0) {
        factor = 8.0;
    } else if (factor < 0.05 && this.scaleValue > 0.05) {
        factor = 0.05;
    }
    var tempScaleValue =  parseFloat(factor / this.scaleValue).toFixed(3) ;
    if((factor >= 0.05 || clicks > 0) && (factor <= 8.0 || clicks < 0))
    {
        var ctx = this.renderWidgetCtx;
        var canvasMidPoint = ctx.transformedPoint(this.renderWidget.width/2,this.renderWidget.height/2);
        ctx.translate(canvasMidPoint.x,canvasMidPoint.y);
        ctx.translate(0,0);
        ctx.scale(tempScaleValue,tempScaleValue);
        ctx.translate(0,0);

        var pt = ctx.transformedPoint(lastX,lastY);
        var canvasEndPoint = ctx.transformedPoint(this.renderWidget.width,this.renderWidget.height);
        var canvasMidPoint = ctx.transformedPoint(this.renderWidget.width/2,this.renderWidget.height/2);
        var canvasStartPoint = ctx.transformedPoint(0,0);

        /*if( (canvasEndPoint.x < this.renderWidget.width/2 &&
           canvasEndPoint.y < this.renderWidget.height/2) &&
           (canvasStartPoint.x > -this.renderWidget.width/2 &&
           canvasStartPoint.y > -this.renderWidget.height/2) )
        {

            ctx.translate(pt.x,pt.y);
            ctx.scale(tempScaleValue,tempScaleValue);
            ctx.translate(-pt.x,-pt.y);
        }else{
            if( (canvasEndPoint.x < this.renderWidget.width/2 &&
                canvasEndPoint.y < this.renderWidget.height/2) &&
               (canvasStartPoint.x < -this.renderWidget.width/2 ||
               canvasStartPoint.y < -this.renderWidget.height/2 ) )
            {
                ctx.translate(canvasStartPoint.x,canvasStartPoint.y);
                ctx.scale(tempScaleValue,tempScaleValue);
                ctx.translate(-canvasStartPoint.x,-canvasStartPoint.y);
            }
            else if ( (canvasEndPoint.x > this.renderWidget.width/2 ||
               canvasEndPoint.y > this.renderWidget.height/2) &&
               (canvasStartPoint.x > -this.renderWidget.width/2 &&
               canvasStartPoint.y > -this.renderWidget.height/2 ) )
            {
                ctx.translate(canvasEndPoint.x,canvasEndPoint.y);
                ctx.scale(tempScaleValue,tempScaleValue);
                ctx.translate(-canvasEndPoint.x,-canvasEndPoint.y);
            }else
            {
                ctx.translate(canvasMidPoint.x,canvasMidPoint.y);
                ctx.translate(0,0);
                ctx.scale(tempScaleValue,tempScaleValue);
                ctx.translate(0,0);
            }
        }*/
        this.zoomFlag = true;
        this.scaleValue = parseFloat(this.scaleValue * tempScaleValue).toFixed(3) ;
        //For retaining the zoom value after dbl-click
        imageCanvas.presentation.setPresentationMode("MAGNIFY");
        imageCanvas.presentation.setZoom(this.scaleValue);

        // Set the current zoom level
        imageCanvas.presentation.setZoomLevel(-1);
        if(this.presentationState !== undefined) {
            this.presentationState.zoomLevel = -1;
            this.applyOrRevertDisplaySettings(imageCanvas.presentation, undefined, undefined, true);
        }

        if(isCopyAttribute !== true) {
            this.renderImage(false);
        }
    }
};

/* Zoom the image on left mouse drag based on current mouse pointer */
ImageRenderer.prototype.doZoomDrag =function(dragStart,lastX,lastY){
    var clicks = 0;
    var ctx = this.renderWidgetCtx;
    var pt = ctx.transformedPoint(lastX,lastY);
    var factor = 0;
    if(dragStart.y === pt.y) return; // No change on the mouse drag
    if(dragStart.y > pt.y  ){ // Drag left mouse down
        clicks = 2;
        factor = parseFloat(this.scaleValue) + 0.10;
    }
    if(dragStart.y < pt.y  ){ // Drag left mouse up
        clicks = -2;
        factor = parseFloat(this.scaleValue) - 0.10;
    }
    var tempScaleValue =  parseFloat(factor / this.scaleValue).toFixed(2) ;
    if((factor > 0.05 || clicks > 0) && (factor < 8.0 || clicks < 0))
    {
        var ctx = this.renderWidgetCtx;
        var pt = ctx.transformedPoint(lastX,lastY);
        var canvasMidPoint = ctx.transformedPoint(this.renderWidget.width/2,this.renderWidget.height/2);
        ctx.translate(canvasMidPoint.x,canvasMidPoint.y);
        ctx.translate(0,0);
        ctx.scale(tempScaleValue,tempScaleValue);
        ctx.translate(0,0);

        /* var canvasEndPoint = ctx.transformedPoint(this.renderWidget.width,this.renderWidget.height);
            var canvasMidPoint = ctx.transformedPoint(this.renderWidget.width/2,this.renderWidget.height/2);
            var canvasStartPoint = ctx.transformedPoint(0,0);

        if( (canvasEndPoint.x < this.renderWidget.width/2 &&
           canvasEndPoint.y < this.renderWidget.height/2) &&
           (canvasStartPoint.x > -this.renderWidget.width/2 &&
           canvasStartPoint.y > -this.renderWidget.height/2) )
        {
            ctx.translate(pt.x,pt.y);
            ctx.scale(tempScaleValue,tempScaleValue);
            ctx.translate(-pt.x,-pt.y);
        }else{
            if( (canvasEndPoint.x < this.renderWidget.width/2 &&
                canvasEndPoint.y < this.renderWidget.height/2) &&
               (canvasStartPoint.x < -this.renderWidget.width/2 ||
               canvasStartPoint.y < -this.renderWidget.height/2 ) )
            {
                ctx.translate(canvasStartPoint.x,canvasStartPoint.y);
                ctx.scale(tempScaleValue,tempScaleValue);
                ctx.translate(-canvasStartPoint.x,-canvasStartPoint.y);
            }
            else if ( (canvasEndPoint.x > this.renderWidget.width/2 ||
               canvasEndPoint.y > this.renderWidget.height/2) &&
               (canvasStartPoint.x > -this.renderWidget.width/2 &&
               canvasStartPoint.y > -this.renderWidget.height/2 ) )
            {
                ctx.translate(canvasEndPoint.x,canvasEndPoint.y);
                ctx.scale(tempScaleValue,tempScaleValue);
                ctx.translate(-canvasEndPoint.x,-canvasEndPoint.y);
            }else
            {
                ctx.translate(canvasMidPoint.x,canvasMidPoint.y);
                ctx.translate(0,0);
                ctx.scale(tempScaleValue,tempScaleValue);
                ctx.translate(0,0);
            }
        }*/
        this.zoomFlag = true;
        this.scaleValue = parseFloat(this.scaleValue * tempScaleValue).toFixed(2) ;
        this.renderImage(false);
    }
};

/* Pan the image on mouse drag */
ImageRenderer.prototype.doDragPan =function(dragStart,lastX,lastY){
    var ctx = this.renderWidgetCtx;
    var imageCanvas = null;
    this.imagePromise.then(function(image){
        imageCanvas = image;
    });
    var presentationState = this.presentationState;//imageCanvas.presentation;

    var canvasEndPoint = ctx.transformedPoint(this.renderWidget.width,this.renderWidget.height);
    var canvasMidPoint = ctx.transformedPoint(this.renderWidget.width/2,this.renderWidget.height/2);
    var canvasStartPoint = ctx.transformedPoint(0,0);

    var deltaX = 0;
    var deltaY = 0;


    var rows = imageCanvas.rows;
    var columns = imageCanvas.columns;
    var rowColumnRatio =  rows/columns;
    if(rowColumnRatio == 1){	
        if(dragStart.x > 1 && ((canvasStartPoint.x - dragStart.x ) + this.renderWidget.width/2 > 0)
           && ((canvasStartPoint.x - dragStart.x ) + this.renderWidget.height/2 > 0)){
            deltaX = dragStart.x;
        }
        if(dragStart.x < 1 && ((canvasEndPoint.x - dragStart.x ) - this.renderWidget.width/2 < 0)
           && ((canvasEndPoint.x - dragStart.x ) - this.renderWidget.height/2 < 0)){
            deltaX = dragStart.x;
        }
        if(dragStart.y > 1 && ((canvasStartPoint.y - dragStart.y ) + this.renderWidget.height/2 > 0)
           && ((canvasStartPoint.y - dragStart.y ) + this.renderWidget.width/2 > 0)){
            deltaY = dragStart.y;
        }
        if(dragStart.y < 1 && ((canvasEndPoint.y - dragStart.y ) - this.renderWidget.height/2 < 0)
           && ((canvasEndPoint.y - dragStart.y ) - this.renderWidget.width/2 < 0)){
            deltaY = dragStart.y;
        }	
    } else {
        if(dragStart.x > 1 && (canvasStartPoint.x + this.renderWidget.width/2 > 0)
           && ((canvasStartPoint.x * rowColumnRatio)+ this.renderWidget.height/2 > 0)){
            deltaX = dragStart.x;
        }   
        if(dragStart.x < 1 && (canvasEndPoint.x - this.renderWidget.width/2 < 0)
           && ((canvasEndPoint.x * rowColumnRatio) - this.renderWidget.height/2 < 0)){
            deltaX = dragStart.x;
        }

        rowColumnRatio =  columns/rows;
        if(dragStart.y > 1 && (canvasStartPoint.y + this.renderWidget.height/2 > 0)
           && ((canvasStartPoint.y * rowColumnRatio) + this.renderWidget.width/2 > 0)){
            deltaY = dragStart.y;
        }
        if(dragStart.y < 1 && (canvasEndPoint.y - this.renderWidget.height/2 < 0)
           && ((canvasEndPoint.y * rowColumnRatio) - this.renderWidget.width/2 < 0)){
            deltaY = dragStart.y;
        }
        if(dragStart.x > 20 || dragStart.y > 20){
            deltaX = 0;
            deltaY = 0;
        }
        if(dragStart.x < -20 || dragStart.y < -20){
            deltaX = 0;
            deltaY = 0;
        }
    }

    if(deltaX !== 0 || deltaY !==0)
    {
        ctx.translate(deltaX,deltaY);
        this.renderImage(false);
    }

};

/*Rotate*/
ImageRenderer.prototype.rotate=function(angle){
    var imageCanvas = null;
    this.imagePromise.then(function(image){
        imageCanvas = image;
    });
    var presentationState = this.presentationState;//imageCanvas.presentation;
    this.presentationState.setIsRotationChange(true);
    var angleOfRotation = angle + presentationState.getRotation();
    presentationState.setRotation(angleOfRotation);
    this.presentationState.setWindowingdata(presentationState.windowCenter,presentationState.windowWidth);
    this.renderImage(false);
    var viewPortDivId = $('#'+this.parentElement).parent().closest('div').attr('id');
    var imageCanvasValue = dicomViewer.getimageCanvasOfViewPort(viewPortDivId);
    imageCanvasValue.presentation.setRotation(angleOfRotation);
    this.presentationState.setIsRotationChange(false);

    if(this.presentationState !== undefined) {
        this.applyOrRevertDisplaySettings(imageCanvas.presentation, undefined, undefined, true);
    }
};

/* Invert */
ImageRenderer.prototype.invert = function() {
    var imageCanvas = null;
    var invertFalg;
    var render = this;
    this.imagePromise.then(function(image) {
        var invertValue = !render.presentationState.getInvertFlag();
        imageCanvas = image;
        render.presentationState.setInvertFlag( invertValue);
        dicomViewer.updateImage(render.imageCanvas,imageCanvas, render.presentationState);
        render.drawDicomImage();
    });

    this.renderImage(false);
};

ImageRenderer.prototype.applySharpen = function(sharpen) {
    var imageCanvas = null;
    var invertFalg;
    var render = this;
    this.imagePromise.then(function(image) {
        imageCanvas = image;
        render.presentationState.setSharpen(sharpen);
        dicomViewer.updateImage(render.imageCanvas,imageCanvas, render.presentationState);
        render.drawDicomImage();
    });

    this.renderImage(false);
};



ImageRenderer.prototype.showOrHideOverlay = function(overLayFlag) {
    var LayerCtx = this.overlayCanvas.getContext("2d");
    if (!overLayFlag) {
        LayerCtx.clearRect(0, 0,this.viewportWidth-5,this.viewportHeight-5);
    } else {
        this.applyOverLay();
    }
}

ImageRenderer.prototype.doHorizontalFlip = function()
{
    var imageCanvas = null;
    this.imagePromise.then(function(image){
        imageCanvas = image;
    });
    var presentationState = this.presentationState;//imageCanvas.presentation;
    presentationState.setHorizontalFilp(!presentationState.getHorizontalFilp());
    this.renderImage(false);

    if(this.presentationState !== undefined) {
        this.applyOrRevertDisplaySettings(imageCanvas.presentation, undefined, undefined, true);
    }
};

ImageRenderer.prototype.doVerticalFilp = function()
{
    var imageCanvas = null;
    this.imagePromise.then(function(image){
        imageCanvas = image;
    });
    var presentationState = this.presentationState;//imageCanvas.presentation;
    presentationState.setVerticalFilp(!presentationState.getVerticalFilp());
    this.renderImage(false);

    if(this.presentationState !== undefined) {
        this.applyOrRevertDisplaySettings(imageCanvas.presentation, undefined, undefined, true);
    }
};

ImageRenderer.prototype.setZoomLevel = function(level)
{
    var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();

    if(activeSeriesLayout.getImageType() == IMAGETYPE_RADECG) {
        var tempScaleValue = 1;
        var layoutId = activeSeriesLayout.getSeriesLayoutId();
        var imageEcgDivId = "imageEcgCanvas"+layoutId;
        var myCanvas = document.getElementById(imageEcgDivId);
        if(myCanvas == null || myCanvas == undefined) return;
        var jImageEcgDivId = "imageEcgDiv"+layoutId;
        var jImageEcgDiv = document.getElementById(jImageEcgDivId);
        var jImageEcgHidden = document.getElementById("imageEcgHidden"+layoutId);
        var jImageEcgURL = jImageEcgHidden.value;
        var context = myCanvas.getContext("2d");
        context.clearRect(0,0,myCanvas.width,myCanvas.height);
        var imageObj = new Image();
        imageObj.src = jImageEcgURL;
        var render = this;
        var value = {};
        imageObj.onload = function() {
            render.ecgScalepreset = level;
            switch(level) {
                case 0: //Set Zoom level to 100%
                    tempScaleValue = 1;
                    break;

                case 1: //Set Zoom level to Window (widht and Height)
                    tempScaleValue = Math.min((jImageEcgDiv.offsetHeight-4) / imageObj.height, jImageEcgDiv.offsetWidth / imageObj.width);
                    break;

                case 2: //Set Zoom level Window to Window width
                    tempScaleValue = jImageEcgDiv.offsetWidth / imageObj.width;
                    break;

                case 3: //Set Zoom level Window to Window height
                    tempScaleValue = jImageEcgDiv.offsetHeight / imageObj.height;
                    break;
                        }
            applyECGZoom(tempScaleValue, context, render, myCanvas, imageObj);
        }
        if(parseInt(level) == 6) {
            if(level.length > 1) {
                value = level.split("-");
                var value = level.split("-");
                tempScaleValue = (parseInt(value[1])/100);
                applyECGZoom(tempScaleValue, context, render, myCanvas, imageObj);
            }
        }
    } else if(activeSeriesLayout.getImageType() == IMAGETYPE_RADPDF) {

    }
    else {

        if(!this.imagePromise) {
            var frameIndex = activeSeriesLayout.scrollData.frameIndex;
            var imageType = activeSeriesLayout.imageType;
            imagePromise = dicomViewer.loadImageFromImageLoader(activeSeriesLayout.studyUid, this.imageUid, frameIndex, imageType);
            this.imagePromise = imagePromise;
        }

        this.imagePromise.then(function(image){
            imageCanvas = image;
        });
        var presentationState = this.presentationState;//imageCanvas.presentation;
        if(!presentationState) {
            presentationState = imageCanvas.presentation;
        }

        var dicominfo = imageCanvas.dicominfo;
        var row = dicominfo.getRows();
        var column = dicominfo.getColumns();
        var tmpScaleValue = this.scaleValue;
        var value = {};
        switch(parseInt(level)) {
            case 0: //Set Zoom level to 100%
                value[0] = "0_zoom";
                this.scaleValue = this.getZoomFactor(0, row, column);
                presentationState.fitToWindow = false;
                presentationState.zoomLevel = 0;
                break;
            case 1: //Set Zoom level to Window (widht and Height)
                this.scaleValue = this.getZoomFactor(1, row, column);
                presentationState.fitToWindow = false;
                presentationState.zoomLevel = 1;
                break;
            case 2: //Set Zoom level Window to Window width
                this.scaleValue = this.getZoomFactor(2, row, column);
                presentationState.fitToWindow = false;
                presentationState.zoomLevel = 2;
                break;
            case 3: //Set Zoom level Window to Window height
                this.scaleValue = this.getZoomFactor(3, row, column);
                presentationState.fitToWindow = false;
                presentationState.zoomLevel = 3;
                break;
            case 6: //Set Zoom level Window the custom value
                if(level.length > 1) {
                    value = level.split("-");
                    var value = level.split("-");
                    this.scaleValue = (parseInt(value[1])/100);
                    presentationState.fitToWindow = false;
                    presentationState.zoomLevel = -1;
                }
                              }
        //this.scaleValue = presentationState.getZoom();
        var ctx = this.renderWidgetCtx;
        ctx.clearRect( -this.renderWidget.width *2 ,-this.renderWidget.height*2 , this.renderWidget.width *4 ,this.renderWidget.height*4);
        var canvasMidPoint = ctx.transformedPoint(this.renderWidget.width/2,this.renderWidget.height/2);
        ctx.translate(canvasMidPoint.x,canvasMidPoint.y);
        ctx.translate(0,0);
        ctx.scale(this.scaleValue/tmpScaleValue,this.scaleValue/tmpScaleValue);
        ctx.translate(0,0);
        this.zoomFlag = true;
        //For retaining the zoom value after dbl-click
        if(value[0] == "0_zoom" || value[0] == "6_zoom") {
            imageCanvas.presentation.setPresentationMode("MAGNIFY");
            imageCanvas.presentation.setZoom(this.scaleValue);
        } else {
            imageCanvas.presentation.setPresentationMode("SCALE_TO_FIT");
            imageCanvas.presentation.setZoom(this.scaleValue);
        }

        // Set the current zoom level
        if(presentationState !== undefined) {
            imageCanvas.presentation.setZoomLevel(presentationState.zoomLevel);
            this.applyOrRevertDisplaySettings(imageCanvas.presentation, undefined, undefined, true);
        }

        if(isCopyAttribute !== true) {
            this.renderImage(false);
        }
    }
};

/**
    * apply zoom level to ECG
    * @param scaleValue - specifies the temporary scale value.
    * @param context - specifies the 2d context
    * @param render - specifies the image render
    * @param myCanvas - specifies the canvas object
    * @param imageObj - specifies the image obj
    */
function applyECGZoom (scaleValue, context, render, myCanvas, imageObj)
{
    if(scaleValue > 1 ) scaleValue = Math.max(1,scaleValue - 0.05);
    myCanvas.width = imageObj.width * scaleValue;
    myCanvas.height = imageObj.height * scaleValue;
    scaleValue = scaleValue.toFixed(2);
    scaleValue = Math.abs(scaleValue);
    render.tScaleValue = scaleValue;
    render.tempEcgScale = scaleValue;
    context.scale(scaleValue, scaleValue);
    context.drawImage(imageObj, 0, 0);

    if (myCanvas.width !== 0 && myCanvas.height !== 0) {
        var imageData = context.getImageData(0, 0, myCanvas.width, myCanvas.height);
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        seriesLayout.setEcgCanvas(imageData);
        dicomViewer.loadCaliper();
    }
};

ImageRenderer.prototype.updateXRefLine = function( actualDC , presentation)
{
    dicomViewer.refLine.updateXRefLine(this, actualDC, presentation);
};
/*Render Image*/
ImageRenderer.prototype.renderImage = function( scaleFlag, isActiveImageLevelId)
{
    var divId = $("#"+this.parentElement).parent().closest('div').attr('id');
    if(divId != undefined){
        var viewportObject = dicomViewer.viewports.getViewport(divId);
        if(viewportObject != undefined){
            var studyUid = viewportObject.getStudyUid();
            var studyDetails = dicomViewer.getStudyDetails(studyUid);
            var studyLayoutId = getStudyLayoutId(divId);
            var studyInformationdiv = "studyInfo"+studyLayoutId;
            var renderer = undefined;
            if(isFullScreenEnabled){
                var sereiesLayout = dicomViewer.getActiveSeriesLayout();
                var activeSeriesLayoutId = sereiesLayout.getSeriesLayoutId();
                var activeViewport = dicomViewer.getActiveSeriesLayout();
                renderer = activeViewport.getImageRender(activeSeriesLayoutId+ "ImageLevel0x0");
            }
            else if(viewportObject != undefined){
                renderer =  viewportObject.getImageRender(divId+ "ImageLevel0x0");
            }
            if(studyDetails === undefined)
                return;

            if(studyDetails.procedure === null || studyDetails.procedure === undefined || studyDetails.procedure === "" ||studyDetails.procedure.length ===0){
                $("#"+studyInformationdiv).html("&nbsp");
            }else
                $("#"+studyInformationdiv).html(studyDetails.procedure);

            var studyTime = "";
            var studyId = "";
            if(studyDetails.dateTime !== null && studyDetails.dateTime !== undefined) {
                studyTime = studyDetails.dateTime.replace("T", "@");
            }

            if(studyDetails.dicomStudyId !== null && studyDetails.dicomStudyId !== undefined) {
                studyId = studyDetails.dicomStudyId;
            }

            if(studyTime !== "" || studyId !== "") {
                var studyDisplayText = (studyId !== "" ? studyId +", " + studyTime : studyTime);
                $("#studyUidDateTime"+studyLayoutId).html(studyDisplayText);    
            }
        }
        if(divId === "imageviewer_studyViewer1x1_1x1" && isFullScreenEnabled === false)
        {
            seriesIndexBackup = this.seriesIndex;
        }
    }
    var imageCanvas = null;
    if(this.imagePromise == undefined) return;
    this.imagePromise.then(function(image){
        imageCanvas = image;
    });

    if(isCopyAttribute) {
        var tempAttribute = dicomViewer.configuration.cine.getCopyAttributes();

        //WindowLevel
        if(tempAttribute.windowLevel && studyDetails.modality !== "US") {
            imageCanvas.presentation.setWindowingdata(copyAttributePresentaion.presentationState.windowCenter, copyAttributePresentaion.presentationState.windowWidth);
        }

        if(tempAttribute.invert && studyDetails.modality !== "US") {
            imageCanvas.presentation.setInvertFlag(copyAttributePresentaion.presentationState.getInvertFlag());
        }

        if(tempAttribute.scale) {
            this.setZoomLevel("6_zoom-"+parseFloat(copyAttributePresentaion.scaleValue)*100);
        }

        //Orientation
        if(tempAttribute.orientation) {
            imageCanvas.presentation.setOrientation(copyAttributePresentaion.presentationState.getOrientation());
        }
    }

    if (imageCanvas !== undefined && imageCanvas !== null) {
        var viewPortDivId = $('#'+this.parentElement).parent().closest('div').attr('id');
        var imageCanvasValue = dicomViewer.getimageCanvasOfViewPort(viewPortDivId);
        if(imageCanvasValue == undefined || imageCanvasValue == null || imageCanvasValue.imageUid != imageCanvas.imageUid )
        {
            imageCanvas.imageIndex = this.imageIndex;
            imageCanvas.seriesIndex = this.seriesIndex;
            // imageCanvas.frameNumber = 0;
            dicomViewer.setimageCanvasOfViewPort(viewPortDivId,imageCanvas);
        }
        //this.presentationState.setInvertFlag(this.presentationState.invert);
        var presentation = this.presentationState;//imageCanvas.presentation;
        var dicominfo = imageCanvas.dicominfo;
        var row = dicominfo.getRows();
        var column = dicominfo.getColumns();

        if(renderer!= undefined){
            if(renderer.presentationState !== undefined &&
               renderer.presentationState !== null) {
                if(renderer.presentationState.invert != this.presentationState.lookupObj.invert){
                    this.presentationState.setInvertFlag(renderer.presentationState.invert);
                }
            }
        }
        if (this.presentationState.getWindowCenter() === undefined || this.presentationState.getWindowWidth() === undefined) {
            var minMaxPixel = {
                min: 0,
                max: 0
            };
            presentation.setWindowingdata(dicominfo.getWindowCenter(), dicominfo.getWindowWidth());
            presentation.setWindowLevel(dicominfo, minMaxPixel, this.invert);
        }
        if (presentation.windowCenter != imageCanvas.windowCenter || presentation.windowWidth != imageCanvas.windowWidth || this.isPresetDefault)
        {
            this.isPresetDefault = false;
        }
        if((dicominfo.imageInfo.numberOfFrames > 1 && dicominfo.imageInfo.modality === "US") || dicominfo.imageInfo.imageType === IMAGETYPE_JPEG) {
            this.imageCanvas = imageCanvas.imageData;
        } else {
            dicomViewer.updateImage(this.imageCanvas,imageCanvas,this.presentationState);
        }

        this.presentationState = presentation;
        this.headerInfo = dicominfo;
        this.drawDicomImage(false, isActiveImageLevelId);
    }
}

ImageRenderer.prototype.drawDicomImage = function(refreshFlag, isActiveImageLevelId, isShowAnnotation, isAutoWindowLevel)
{
    if(isShowAnnotation == true && !dicomViewer.tools.isShowAnnotationandMeasurement()){
        dicomViewer.tools.doShowHideAnnotationAndMeasurement();
        return;
    }
    if(this.presentationState == null) return;
    var presentation = this.presentationState;
    var dicominfo = this.headerInfo;
    var actualDC = this.renderWidgetCtx;
    // clear canvas
    actualDC.clearRect(-this.renderWidget.width*6, -this.renderWidget.height*6, this.renderWidget.width *12 ,this.renderWidget.height*12);

    var scaleFactor = presentation.getZoom();
    //set the defult zoom value to this.scaleValue
    if( this.scaleValue == undefined)
    {
        this.scaleValue = scaleFactor;
    }
    var pan = presentation.getPan();
    if(presentation.fitToWindow)
    {
        if (presentation.getRotation() == 90 || presentation.getRotation() == 270)
        {
            scaleFactor = Math.min(this.renderWidget.height / column, this.renderWidget.width / row);
            presentation.setZoom(scaleFactor);
        }
        else
        {
            scaleFactor = Math.min(this.renderWidget.height / row, this.renderWidget.width / column);
            presentation.setZoom(scaleFactor);
        }
    }
    actualDC.save();

    var orientation = presentation.getOrientation();
    if(isCopyAttribute !== true) {
        if (presentation.isRotation && this.presentationState.getIsRotationChange()) {
            orientation = orientationDefaults[orientation].rotateRight;
        } else {
            if (presentation.vFlip) {
                orientation = orientationDefaults[orientation].flipVert;
            } else if (presentation.hFlip) {
                orientation = orientationDefaults[orientation].flipHorz;
            }
        }
    }

    presentation.setRotation(angleDefaults[orientationDefaults[orientation].rotate]);

    if (orientationDefaults[orientation].mirror === 1) {
        if (orientation === 4 || orientation === 6) {
            presentation.setVerticalFilp(false);
            presentation.setHorizontalFilp(true);
        } else if (orientation === 5 || orientation === 7) {
            presentation.setVerticalFilp(true);
            presentation.setHorizontalFilp(false);
        }
    } else {
        presentation.setVerticalFilp(false);
        presentation.setHorizontalFilp(false);
    }

    // Set the current orientation
    presentation.setOrientation(orientation);
    // Update the Rotate and flip information
    presentation.updateRotateAndFlip();

    var viewPortDivId = $('#'+this.parentElement).parent().closest('div').attr('id');
    var imageCanvasValue = dicomViewer.getimageCanvasOfViewPort(viewPortDivId);
    if(imageCanvasValue != undefined)
        imageCanvasValue.presentation.setOrientation(orientation);
    isRGBToolEnabled = imageCanvasValue ? imageCanvasValue.isRGBToolEnabled : false;


    // Rotate the image
    actualDC.rotate(presentation.getRotation() * Math.PI / 180);

    if (presentation.isFlipHoriRequired()) {
        actualDC.scale(-scaleFactor, scaleFactor);
    }
    else {
        actualDC.scale(scaleFactor, scaleFactor);
    }
    if(dicominfo != undefined && dicominfo.imageInfo.numberOfFrames > 1)
    {
        actualDC.drawImage(this.imageCanvas, pan.x, pan.y);
    }
    else
    {
        actualDC.drawImage(this.imageCanvas, pan.x, pan.y);
    }
    
    var aUIDs = this.anUIDs.split("*");
    var imageUid= aUIDs[0], frameIndex=aUIDs[1];
    dicomViewer.directionalMarker.initDirectionalMarker(dicominfo);
    dicomViewer.directionalMarker.rotateDirectionalMarker(presentation);

    var toolName = dicomViewer.mouseTools.getToolName();

    if(dicomViewer.tools.isShowAnnotationandMeasurement() || isShowAnnotation == true || isAutoWindowLevel == true) {
        if ((toolName == 'lineMeasurement') || (toolName == 'pointMeasurement') || 
            (toolName == 'traceMeasurement') || (toolName == 'volumeMeasurement') || 
            (toolName == 'mitralMeanGradientMeasurement') || (toolName == 'angleMeasurement') ||
            (toolName == 'ellipseMeasurement') ||
            (toolName == 'rectangleMeasurement'))
            dicomViewer.draw.usRegion.drawUSRegions(actualDC, dicominfo, presentation);
        if (isActiveImageLevelId === undefined || isActiveImageLevelId == true) {
            dicomViewer.measurement.draw.drawMeasurements(imageUid,frameIndex,actualDC,presentation,this);
        }
    }

    // Reset the flip values so that next time flip or rotation will work as expected.
    presentation.setHorizontalFilp(false);
    presentation.setVerticalFilp(false);

    // Refresh flag false is for draw lines and point measurement.
    // So we need not to require refresh all the viewports to draw a line in single viewport.
    if(refreshFlag === undefined || refreshFlag )
    {
        //Gets the active viewport
        var layout = dicomViewer.getActiveSeriesLayout();

        //Get all image renderer
        var imageRenders = layout.getAllImageRenders();
        var iKey;
        //Falg to check if the passed image renderer is in the active viewport
        var isInActiveViewPort = false;

        for (var iKey in imageRenders)
        {
            if( this == imageRenders[iKey])
            {
                isInActiveViewPort = true;
            }
        }
        if(isInActiveViewPort == false)
        {
            this.updateXRefLine( actualDC, presentation);
        }
    }


    actualDC.restore();
    // Adding basic header info on image

    if (dicomViewer.tools.isOverlayVisible() /*&& dicominfo.imageInfo.imageType != IMAGETYPE_JPEG*/){
        this.applyOverLay();
    } else {
        var LayerCtx = this.overlayCanvas.getContext("2d");
        LayerCtx.clearRect(0, 0,this.viewportWidth-5,this.viewportHeight-5);
    }

    actualDC.save();

    var parentDivId = $('#'+this.parentElement).parent().closest('div').attr('id');
    if(parentDivId)
    {
        var spinner = dicomViewer.progress.getSpinner(parentDivId);
        if (spinner !== undefined) {
            spinner.stop();
            if(dicominfo && dicominfo.imageInfo) {
                dicominfo.imageInfo.isColor ? disableOrEnableRGBTools() : "";

                if (dicominfo != undefined && (dicominfo.imageInfo.modality === "US" || dicominfo.imageInfo.modality === "XA") && dicominfo.imageInfo.numberOfFrames > 1 && dicomViewer.tools.firstTimeImageLoad() ) {
                    if(!dicomViewer.scroll.isCineRunning(parentDivId)) {
                        dicomViewer.scroll.toggleCineRunning();
                        $('#viewport_View').css('cursor', 'default');
                    }
                }
            }
        }
    }
};

ImageRenderer.prototype.applyOverLay = function()
{
    var LayerCtx = this.overlayCanvas.getContext("2d");
    LayerCtx.clearRect(0, 0, this.viewportWidth-5, this.viewportHeight-5);
    var imageCanvas = null;
    if(this.imagePromise === undefined){
        return;
    }
    var render = this;
    this.imagePromise.done(function(image){
        imageCanvas = image;

        var displayFrameNumber = 0 ;
        var totalNumberofFrame = 1;
        var presentation = render.presentationState;//imageCanvas.presentation;
        if(presentation  != null)
        {
            dicominfo = render.headerInfo;
            if(dicominfo != null && dicominfo != undefined) {
                if(dicominfo.imageInfo.numberOfFrames > 1)
                {
                    displayFrameNumber = eval(imageCanvas.frameNumber)+1;
                    totalNumberofFrame = dicominfo.imageInfo.numberOfFrames;
                }

                if (dicomViewer.tools.isOverlayVisible())
                {
                    var overlayConfig = null;

                    if(dicominfo.imageInfo.imageType !== IMAGETYPE_JPEG)
                    {
                        overlayConfig = dicomViewer.overlay.getOverlayConfig();
                        var bottomLeftOverLayConfig = dicomViewer.overlay.getOverLayValuesForCofig(overlayConfig.bottomleft,dicominfo);
                    }
                    else
                    {
                        overlayConfig = ["Scale"];
                        var bottomLeftOverLayConfig = dicomViewer.overlay.getOverLayValuesForCofig(overlayConfig,dicominfo);
                    }

                    var topLefOverLayConfig = dicomViewer.overlay.getOverLayValuesForCofig(overlayConfig.topleft,dicominfo);
                    var topRightOverLayConfig = dicomViewer.overlay.getOverLayValuesForCofig(overlayConfig.topRight,dicominfo);
                    //var bottomLeftOverLayConfig = dicomViewer.overlay.getOverLayValuesForCofig(overlayConfig.bottomleft,dicominfo);
                    var bottomRigthOverLayConfig = dicomViewer.overlay.getOverLayValuesForCofig(overlayConfig.bottomRight,dicominfo);

                    LayerCtx.fillStyle = "yellow";
                    LayerCtx.font = "11pt Helvetica";

                    var windowLevelTxt = "WW: " + Math.round(presentation.getWindowWidth()) + ", WC: " + Math.round(presentation.getWindowCenter());
                    //getting the scale value and convert to zoom precentage
                    var scaleText = "Zoom: "+Math.round(render.scaleValue*100)+"%";
                    //"Zoom: "+(presentation.getZoom().toFixed(2))*100+"%";
                    var seriesDesc = dicomViewer.Series.getSeriesDescription(dicomViewer.getActiveSeriesLayout().getStudyUid(), render.seriesIndex );
                    generatDicomOverlay(topLefOverLayConfig,"topLeft",LayerCtx,windowLevelTxt,scaleText);
                    generatDicomOverlay(bottomLeftOverLayConfig, "bottomLeft",LayerCtx, windowLevelTxt,scaleText, render.viewportHeight-5,"",displayFrameNumber,totalNumberofFrame,seriesDesc);
                    generatDicomOverlay(topRightOverLayConfig,"topRight",LayerCtx, windowLevelTxt,scaleText,"",render.viewportWidth-5);
                    generatDicomOverlay(bottomRigthOverLayConfig, "bottomRight",LayerCtx, windowLevelTxt,scaleText, render.viewportHeight-5, render.viewportWidth-5);
                    LayerCtx.fillStyle = "black";

                    //if the image is comprepressed call the displayOverLayWarning method
                    if(dicominfo.imageInfo.isCompressed || dicominfo.imageInfo.imageType === IMAGETYPE_RADECHO){
                        displayOverLayWarning(LayerCtx, render.overlayCanvas.width, render.overlayCanvas.height);
                    }

                    applyDirectionalmarker(LayerCtx,dicominfo,render.viewportHeight, render.viewportWidth);
                    displayRGBChannelToolTip(render);
                }
            }

        }
    });
}

function applyDirectionalmarker(LayerCtx,dicominfo,height, width)
{
    var directionalMarker = dicomViewer.directionalMarker.getDirectionalMarker();
    if(directionalMarker != null)
    {
        LayerCtx.fillStyle = "yellow";
        LayerCtx.font = "11pt Helvetica";
        LayerCtx.fillText(directionalMarker.left,20, height/2);
        LayerCtx.fillText(directionalMarker.right, width-LayerCtx.measureText(directionalMarker.right).width*2, height/2);
        LayerCtx.fillText(directionalMarker.top, width/2,20);
        LayerCtx.fillText(directionalMarker.bottom, width/2,height - 20);
        LayerCtx.fillStyle = "black";
    }
}

/**
	*Display Red, Blue or Green channel is applied
	*/
function displayRGBChannelToolTip(imageRender)
{
    //var seriesLayout = dicomViewer.getActiveSeriesLayout();
    //var imageLevelId = $("#" + seriesLayout.getSeriesLayoutId() + " div").attr('id');
    //var imageRender  = seriesLayout.getImageRender(imageLevelId);
    if(imageRender !== undefined && dicomViewer.tools.isOverlayVisible())
    {
        var message = "";
        var fillStyle = "black"
        var dicominfo = imageRender.headerInfo;

        // Enable/Disable RGB tool
        var enableRGBTool = false;
        if(dicominfo !== undefined) {
            var imageInfo = dicominfo.imageInfo;
            if(imageInfo.isColor && isRGBToolEnabled) {
                enableRGBTool = true;
            }
        }

        if(dicominfo !== undefined && enableRGBTool && imageRender.presentationState.getRGBMode() !== undefined)
        {
            if(imageRender.presentationState.getRGBMode() === 1)
            {
                message = "Red Channel";
                fillStyle = "Red";
                dicomViewer.tools.rgbColor(1, true);
            }
            else if(imageRender.presentationState.getRGBMode() === 2)
            {
                message = "Green Channel";
                fillStyle = "Green";
                dicomViewer.tools.rgbColor(2, true);
            }
            else if(imageRender.presentationState.getRGBMode() === 3)
            {
                message = "Blue Channel";
                fillStyle = "Blue";
                dicomViewer.tools.rgbColor(3, true);
            } else {
                dicomViewer.tools.resetRGBMenu();
            }
        }
        if(message !== "")
        {
            var LayerCtx = imageRender.overlayCanvas.getContext("2d");
            LayerCtx.clearRect(imageRender.overlayCanvas.width -LayerCtx.measureText(message).width-55, imageRender.overlayCanvas.height-60,LayerCtx.measureText(message).width+1, 60);
            LayerCtx.fillStyle = fillStyle;
            LayerCtx.font = "11pt Helvetica";
            LayerCtx.fillText(message,imageRender.overlayCanvas.width -LayerCtx.measureText(message).width, imageRender.overlayCanvas.height-60);
            LayerCtx.fillStyle = "black";
        }
    }
}

function generatDicomOverlay(OverLayConfigObject, location, LayerCtx, windowLevelTxt,scaleText, height, width , displayFrameNumber, totalNumberofFrame, seriesDesc)
{
    var postionIndex = 0;
    var postionIncrement = 1;
    for (var i=0; i<OverLayConfigObject.length; i++) {
        if(location == "topLeft")
        {
            var valueOfDicomTag = OverLayConfigObject[i];
            if((valueOfDicomTag  != undefined ) && valueOfDicomTag != "")
            {
                var postion = (postionIncrement)*2;
                displayOverlayLeftSide(valueOfDicomTag,10,postion*10,LayerCtx,windowLevelTxt,scaleText);
                postionIncrement++;
            }
        }
        else if(location == "bottomLeft")
        {
            var valueOfDicomTag = OverLayConfigObject[OverLayConfigObject.length-(i+1)];
            if(valueOfDicomTag  != undefined && valueOfDicomTag != "")
            {
                postionIndex=postionIndex+1;
                postion	= (postionIndex)*10;
                displayOverlayLeftSide(valueOfDicomTag, 10, height-(postion), LayerCtx, windowLevelTxt,scaleText);
                postionIndex++;
            }
            //when the for loop is in last time and the total number of frame is greater than 1 it ill execute the code for diplaying frames count in viewport
            if(i == OverLayConfigObject.length-1 && totalNumberofFrame != 1)
            {
                postionIndex=postionIndex+1;
                postion	= (postionIndex)*10;
                displayOverlayLeftSide("Fr :"+(displayFrameNumber)+"/"+totalNumberofFrame,10, height-(postion),LayerCtx,windowLevelTxt,scaleText);
                postionIndex++;
            }
            if(i == OverLayConfigObject.length-1)
            {
                if( seriesDesc != undefined && seriesDesc != ""){
                    postionIndex = postionIndex+1;
                    postion	= (postionIndex)*10;
                    displayOverlayLeftSide(seriesDesc, 10, height-(postion), LayerCtx, windowLevelTxt, scaleText);
                    postionIndex++;
                }
            }
        }
        else if(location == "topRight")
        {
            var valueOfDicomTag = OverLayConfigObject[i];
            if(valueOfDicomTag  != undefined && valueOfDicomTag != "" )
            {
                var postion = (postionIncrement)*2;
                displayOverlayRightSide(valueOfDicomTag, width ,postion*10, LayerCtx, windowLevelTxt,scaleText);
                postionIncrement++;
            }
        }
        else if(location == "bottomRight")
        {
            var valueOfDicomTag = OverLayConfigObject[OverLayConfigObject.length-(i+1)];
            if(valueOfDicomTag  != undefined && valueOfDicomTag != "" )
            {
                postionIndex=postionIndex+1;
                postion	= (postionIndex)*10;
                displayOverlayRightSide(valueOfDicomTag, width,height-(postion), LayerCtx, windowLevelTxt,scaleText);
                postionIndex++;
            }
        }
    }
}

function displayOverlayLeftSide(valueOfDicomTag, width, height, LayerCtx,windowLevelTxt,scaleText)
{
    if (valueOfDicomTag === "WCWW")
    {
        LayerCtx.fillText(windowLevelTxt, width, height);
    }
    else if(valueOfDicomTag === "Scale")
    {
        LayerCtx.fillText(scaleText, width, height);
    }
    else
    {
        LayerCtx.fillText(valueOfDicomTag, width, height);
    }
}

function displayOverlayRightSide(valueOfDicomTag, renderWidth, postion, LayerCtx, windowLevelTxt,scaleText)
{
    if(valueOfDicomTag === "WCWW")
    {
        LayerCtx.fillText(windowLevelTxt,(renderWidth- LayerCtx.measureText(windowLevelTxt).width),postion);
    }
    else if(valueOfDicomTag === "Scale")
    {
        LayerCtx.fillText(scaleText,(renderWidth- LayerCtx.measureText(scaleText).width),postion);
    }
    else
    {
        LayerCtx.fillText(valueOfDicomTag,  renderWidth- LayerCtx.measureText(valueOfDicomTag).width,postion);
    }
}
/**
	*Display warning icon for compressed images
	*/
var warningImageData  = undefined;
function displayOverLayWarning(context, width, height)
{
    if(warningImageData === undefined){
        var img = new Image();
        img.src = "images/alert.bmp";
        img.onload = function(){
            context.drawImage(img,width-50,height-40);
            warningImageData = context.getImageData(width-50,height-50, width, height);
        }
    }else{
        context.putImageData(warningImageData,width-50,height-50);
    }
}
/**
	*Display warning icon for compressed images
	*/
function displayCompressinToolTip(evt,imageRender)
{
    //var seriesLayout = dicomViewer.getActiveSeriesLayout();
    //var imageLevelId = $("#" + seriesLayout.getSeriesLayoutId() + " div").attr('id');
    //var imageRender  = seriesLayout.getImageRender(imageLevelId);
    if(imageRender !== undefined && dicomViewer.tools.isOverlayVisible())
    {
        var message = "";
        var dicominfo = imageRender.headerInfo;
        if(dicominfo !== undefined && dicominfo.imageInfo.isCompressed)
        {
            if(dicominfo.imageInfo.imageType === IMAGETYPE_RADECHO)
                message = "Jpeg compressed image";
            else if(dicominfo.imageInfo.compressionMethod !== undefined && dicominfo.imageInfo.compressionMethod !== "")
                message = dicominfo.imageInfo.compressionMethod;
        }
        if(message !== "")
        {
            var widget = imageRender.getRenderWidget();
            var	lastX = evt.offsetX || (evt.pageX - widget.offsetLeft);
            var	lastY = evt.offsetY || (evt.pageY - widget.offsetTop);

            if(lastX > (imageRender.overlayCanvas.width -50) && lastY > (imageRender.overlayCanvas.height - 50) &&
               lastX < (imageRender.overlayCanvas.width -5) && lastY < (imageRender.overlayCanvas.height - 5))
            {

                var LayerCtx = imageRender.overlayCanvas.getContext("2d");
                LayerCtx.clearRect(imageRender.overlayCanvas.width -LayerCtx.measureText(message).width-55, imageRender.overlayCanvas.height-20,LayerCtx.measureText(message).width+1, 20);
                LayerCtx.fillStyle = "white";
                LayerCtx.font = "11pt Helvetica";
                LayerCtx.fillText(message,imageRender.overlayCanvas.width -LayerCtx.measureText(message).width-55, imageRender.overlayCanvas.height-5);
                LayerCtx.fillStyle = "black";
            }else
            {
                var LayerCtx = imageRender.overlayCanvas.getContext("2d");
                LayerCtx.clearRect(imageRender.overlayCanvas.width -LayerCtx.measureText(message).width-55, imageRender.overlayCanvas.height-20,LayerCtx.measureText(message).width+1, 20);

            }
        }
    }
}

/**
*Double click over the viewport makes it fullscreen(i.e. 1x1 Study Layout) and vice versa.
*/
function doubleClick() {
    var toolName = dicomViewer.mouseTools.getToolName();
    if (toolName !== 'traceMeasurement' && toolName !== 'volumeMeasurement' && 
        toolName !== 'mitralMeanGradientMeasurement' && toolName !== 'pointMeasurement' && 
        toolName !== 'lineMeasurement' && toolName !== 'angleMeasurement' && 
        toolName !== 'ellipseMeasurement' && toolName !== 'rectangleMeasurement') {
        var sereiesLayout = dicomViewer.getActiveSeriesLayout();
        var activeSeriesLayoutId = sereiesLayout.getSeriesLayoutId();
        var currentSeriesLayoutIds = dicomViewer.getCurrentSeriesLayoutIds();
        var maxSeriesLayoutId = dicomViewer.viewports.getSeriesLayoutMaxId();
        var activeViewport = dicomViewer.getActiveSeriesLayout();
        var studyDivId = getStudyLayoutId(currentSeriesLayoutIds);
        var layoutDivId = "imageviewer_"+studyDivId+"_"+"1x1";
        if (maxSeriesLayoutId !== layoutDivId && studyLayoutValue === "1x1") {
            if (currentSeriesLayoutIds === layoutDivId) {
                isFullScreenEnabled = false;
                maxSeriesLayoutId = maxSeriesLayoutId.replace("imageviewer_"+studyDivId+"_", '');
                var row = maxSeriesLayoutId.charAt(0);
                var columm = maxSeriesLayoutId.charAt(maxSeriesLayoutId.length - 1);
                var imageAndSeriesIndex = activeViewport.seriesIndex;

                // Set the rearranged series positions
                var isSeriesReArranged = false;
                if(dicomViewer.scroll.isCineRunning(sereiesLayout.getSeriesLayoutId())) {
                    imageAndSeriesIndex = dicomViewer.tools.getOrSetReArrangedSeriesPositions(parseInt(row), parseInt(columm), true);
                    isSeriesReArranged = true;
                }
                dicomViewer.setSeriesLayout(activeViewport.getStudyUid(),row, columm, imageAndSeriesIndex, false, getStudyLayoutId(activeSeriesLayoutId));
                dicomViewer.setReArrangedSeriesPositions(undefined);
                var backserieslayout = dicomViewer.getActiveSeriesLayout();
                if(backserieslayout != undefined && backserieslayout !=null){
                    if(dicomViewer.scroll.isCineRunning(backserieslayout.getSeriesLayoutId())){
                        updatePlayIcon("play.png","stop.png");
                    }
                }
            } else {
                previousLayoutSelection = activeSeriesLayoutId;
                isFullScreenEnabled = true;
                dicomViewer.setSeriesLayout(activeViewport.getStudyUid(),1, 1, activeViewport.seriesIndex, true, getStudyLayoutId(activeSeriesLayoutId));
            }
        } else {
            if(studyLayoutValue !== "1x1" && !isFullScreenEnabled){
                previousLayoutSelection = activeSeriesLayoutId;
                isFullScreenEnabled = true;
                dicomViewer.setStudyLayout(1, 1, activeViewport.getStudyUid(), activeViewport.seriesIndex, true);
            } else if(isFullScreenEnabled) {
                isFullScreenEnabled = false;
                var splitedRowAndColumn = studyLayoutValue.split("x");
                var studyRow = splitedRowAndColumn[0];
                var studyColumn = splitedRowAndColumn[1];
                var obj = {
                    id: studyLayoutValue
                };
                var tempLayOutmap = layoutMap;
                dicomViewer.tools.changeStudyLayoutFromTool(obj, isFullScreenEnabled, false);
                layoutMap = tempLayOutmap;
                for (var i = 1; i <= studyRow; i++) {
                    for (var j = 1; j <= studyColumn; j++) {
                        var studyDiv = "studyViewer" + i + "x" + j;
                        var rowCalValue = layoutMap[studyDiv];
                        if (rowCalValue == undefined) {
                            rowCalValue = "1x1";
                        }
                        var rcArray = rowCalValue.split("x");
                        dicomViewer.tools.chanageWhileDrag(rcArray[0], rcArray[1], studyDiv);

                        // shown the view port close icon
                        var layoutId = "imageviewer_"+ studyDiv+ "_1x1";
                        var viewport = dicomViewer.viewports.getViewport(layoutId);
                        if(viewport != null &&  viewport != undefined) {
                            if(viewport.studyUid != undefined) {
                                document.getElementById(studyDiv + '_close').style.visibility = "visible";
                            }
                        }
                    }
                }
                dicomViewer.playRepeatCineManager();
                dicomViewer.changeSelection(previousLayoutSelection);
            }
        }
    }
    //If there is any measurement/annotation tool selected then on double-click completing the shape
    if(toolName === "mitralMeanGradientMeasurement" || toolName === "traceMeasurement" || 
       toolName === "lineMeasurement" || toolName === "pointMeasurement" || 
       toolName === "ellipseMeasurement" || toolName === "rectangleMeasurement" || 
       toolName === "angleMeasurement") {
        var tool = dicomViewer.mouseTools.getActiveTool();
        tool.hanleDoubleClick();
    }
    isCineEnabled(false);
};

ImageRenderer.prototype.getPresentation = function() {
    return this.presentationState;
};
ImageRenderer.prototype.getRenderWidget = function() {
    return this.renderWidget;
};

ImageRenderer.prototype.getZoomLevel = function() {
    return this.tScaleValue;
}

/*Update the series index while DnD*/
ImageRenderer.prototype.updateSeriesIndex =function()
{
    seriesIndex = this.seriesIndex;	//updating the series index
};

/*Returns the series index*/
ImageRenderer.prototype.getSeriesIndex =function()
{
    return this.seriesIndex;
};

/*Returns the image Id*/
ImageRenderer.prototype.getImageUid =function()
{
    return this.imageUid;
};


/*Returns the current imageLocator*/
ImageRenderer.prototype.getCurrentUIDs = function()
{
    return this.anUIDs;
};


/**
 * Apply or revert display settings
 * @param {Type} presentation - Specifies the current presentation
 * @param {Type} isDefaultPresentation - Specifies the flag for default presentation
 * @param {Type} revert - Specifies the flag for revert the display settings
 * @param {Type} save - Specifies the flag for save the display settings
 */ 
ImageRenderer.prototype.applyOrRevertDisplaySettings = function(presentation, isDefaultPresentation, revert, save) {
    try
    {
        // Default presentation values.
        if(isDefaultPresentation === true) {
            presentation.orientation = 0;
            presentation.isRotation = false;
            presentation.rotation = 0;
            presentation.hFlip = false;
            presentation.vFlip = false;
            presentation.zoom = 1;
            presentation.presentationMode = "SCALE_TO_FIT";
            presentation.zoomLevel = 1;
            presentation.rgbMode = 0;
        }

        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        if(activeSeriesLayout !== undefined && activeSeriesLayout.studyUid !== undefined) {
            var seriesOrImage = dicomViewer.Series.Image.getImage(activeSeriesLayout.studyUid, this.seriesIndex, this.imageIndex);
            if(seriesOrImage === undefined || 
               seriesOrImage.isImageThumbnail === undefined || 
               seriesOrImage.isImageThumbnail === false ) {
                seriesOrImage = dicomViewer.Series.getSeries(activeSeriesLayout.studyUid, this.seriesIndex);
            }

            if(seriesOrImage !== undefined && seriesOrImage.displaySettings !== undefined) {
                var displaySettings = seriesOrImage.displaySettings;
                if(seriesOrImage.isDisplaySettingsApplied === false) {
                    seriesOrImage.isDisplaySettingsApplied = true;
                    if(displaySettings.IsECG === true) {
                        this.ecgScalepreset = displaySettings.ZoomLevel;
                    } else if(presentation !== undefined) {
                        presentation.presentationMode = "SCALE_TO_FIT";
                        presentation.zoomLevel = displaySettings.ZoomLevel;
                        displaySettings.presentation = jQuery.extend(true, {}, presentation);
                    }
                } else if(seriesOrImage.isDisplaySettingsApplied === true && revert === true) {
                    seriesOrImage.isDisplaySettingsApplied = false;
                } else if(seriesOrImage.isDisplaySettingsApplied === true && presentation !== undefined) {
                    presentation.presentationMode = "SCALE_TO_FIT";
                    if(seriesOrImage.isImageThumbnail === true) {
                        if(save === true) {
                            displaySettings.presentation = jQuery.extend(true, {}, presentation);
                        } else {
                            var restorePresentation = displaySettings.presentation;
                            if(restorePresentation !== undefined) {
                                var imageCanvas = null;
                                this.imagePromise.then(function(image) {
                                    imageCanvas = image;
                                });

                                // Apply the restore presentation in image canvas presentation
                                imageCanvas.presentation.zoom = restorePresentation.zoom;
                                imageCanvas.presentation.zoomLevel = restorePresentation.zoomLevel;
                                imageCanvas.presentation.rotation = restorePresentation.rotation;
                                imageCanvas.presentation.isRotation = restorePresentation.isRotation;
                                imageCanvas.presentation.orientation = restorePresentation.orientation;
                                imageCanvas.presentation.isFlipHorizontalRequired = restorePresentation.isFlipHorizontalRequired;
                                imageCanvas.presentation.vFlip = restorePresentation.vFlip;
                                imageCanvas.presentation.hFlip = restorePresentation.hFlip;                                

                                // Apply the restore presentation in current presentation
                                presentation.zoom = restorePresentation.zoom;
                                presentation.zoomLevel = restorePresentation.zoomLevel;
                                presentation.rotation = restorePresentation.rotation;
                                presentation.isRotation = restorePresentation.isRotation;
                                presentation.orientation = restorePresentation.orientation;
                                presentation.isFlipHorizontalRequired = restorePresentation.isFlipHorizontalRequired;
                                presentation.vFlip = restorePresentation.vFlip;
                                presentation.hFlip = restorePresentation.hFlip;
                            }
                        }
                    }
                } else if(seriesOrImage.isDisplaySettingsApplied === true && displaySettings.IsECG === true) {
                    var preferenceInfo = activeSeriesLayout.preferenceInfo;
                    if(save === true && preferenceInfo !== undefined) {
                        displaySettings.EcgPreference = jQuery.extend(true, {}, preferenceInfo.preferenceData);
                        displaySettings.SelectedEcgPreference = jQuery.extend(true, {}, preferenceInfo.selectedEcgFormat);
                        displaySettings.isCaliperEnable = activeSeriesLayout.isCaliperEnable;
                    } else if(preferenceInfo !== undefined) {
                        if(displaySettings.EcgPreference !== undefined && displaySettings.SelectedEcgPreference !== undefined) {
                            preferenceInfo.selectedEcgFormat = jQuery.extend(true, {}, displaySettings.SelectedEcgPreference);
                            preferenceInfo.preferenceData = jQuery.extend(true, {}, displaySettings.EcgPreference);
                            activeSeriesLayout.isCaliperEnable = displaySettings.isCaliperEnable;
                        }
                    }
                } else {
                    //Already applied the display settings 
                }
            }
        }
    }
    catch(e)
    { }
}

/**
 * Get the zoom factor
 * @param {Type} level - Specifies the zoom level
 * @param {Type} row - Specifies the image width
 * @param {Type} column - Specifies the image height
 */ 
ImageRenderer.prototype.getZoomFactor = function(level, row, column) {
    try
    {
        var zoomFactor = undefined;
        var minZoomValue = 5; //(in percentage)
        switch(level)
                {
            case 0: //Set Zoom level to 100%
                zoomFactor = 1;
                break;

            case 1: //Set Zoom level to Window (widht and Height)
                zoomFactor = Math.min(this.renderWidget.height / row, this.renderWidget.width / column);
                break;

            case 2: //Set Zoom level Window to Window width
                zoomFactor = (this.renderWidget.width / column);
                break;

            case 3: //Set Zoom level Window to Window height
                zoomFactor = (this.renderWidget.height / row) ;
                break;

            default: //Set Zoom level to Window (widht and Height)
                zoomFactor = Math.min(this.renderWidget.height / row, this.renderWidget.width / column);
                break;
        }

        if(zoomFactor*100 - 5 < 0) {
            zoomFactor = minZoomValue/100;
        }
        return zoomFactor;
    }
    catch(e)
    { }
}

/* Change the default cursor tool based on the modality while mouse drag */
ImageRenderer.prototype.doClickDefaultTool =function(){

    // set the defualt cursor for the loaded/selected view port modality
    var seriesLayout = dicomViewer.getActiveSeriesLayout();
    var modality = dicomViewer.Series.getModality(seriesLayout.getStudyUid(), seriesLayout.getSeriesIndex());
    dicomViewer.setDefaultCursorType(modality, seriesLayout);
};

/**
 * Print the Zoom level applied image
 * printOption - 1->At Current Zoom
 * printOption - 2->at 100%
 */ 
ImageRenderer.prototype.preparePrint = function(printOption)
{
    try
    {
        var printCanvas = document.createElement("canvas");
        var previousScaleValue = this.scaleValue;
        this.scaleValue = 1;
        if(printOption == 1) {
            this.scaleValue = previousScaleValue;
        }

        printCanvas.width = this.imageCanvas.width * parseFloat(this.scaleValue);
        printCanvas.height = this.imageCanvas.height * parseFloat(this.scaleValue);
        var printContext = printCanvas.getContext('2d');

        printContext.clearRect(0,0,printCanvas.width,printCanvas.height);
        printContext.save();
        printContext.translate(printCanvas.width/2,printCanvas.height/2);
        printContext.rotate(this.presentationState.getRotation() * Math.PI/180);

        //Apply the scale based on the image flip
        if(this.presentationState.isFlipHorizontalRequired) {
            printContext.scale(-this.scaleValue, this.scaleValue);
        } else {
            printContext.scale(this.scaleValue, this.scaleValue);
        }

        //Draw image
        printContext.drawImage(this.imageCanvas, -this.imageCanvas.width/2, -this.imageCanvas.height/2);

        this.isPrint = true;
        var aUIDs = this.anUIDs.split("*");
        var imageUid= aUIDs[0];
        var frameIndex=aUIDs[1];
        this.scaleValue = ((parseFloat(this.scaleValue) <= 1.5 )) ? parseFloat(this.scaleValue) : 1.5;
        //Draw the measurements
        if(dicomViewer.tools.isShowAnnotationandMeasurement()) {
            dicomViewer.measurement.draw.drawMeasurements(imageUid, frameIndex, printContext, this.presentationState, this);
        }
        printContext.restore();
        this.scaleValue = previousScaleValue;
        this.isPrint = undefined;

        return printCanvas.toDataURL('image/jpeg', 1.0);
    }
    catch(e)
    { }
};

//Adds ctx.getTransform() - returns an SVGMatrix
//Adds ctx.transformedPoint(x,y) - returns an SVGPoint
function trackTransforms(ctx){
    var svg = document.createElementNS("http://www.w3.org/2000/svg",'svg');
    var xform = svg.createSVGMatrix();
    ctx.getTransform = function(){
        return xform;
    };

    var savedTransforms = [];
    var save = ctx.save;
    ctx.save = function(){
        savedTransforms.push(xform.translate(0,0));
        return save.call(ctx);
    };
    var restore = ctx.restore;
    ctx.restore = function(){
        xform = savedTransforms.pop();
        return restore.call(ctx);
    };

    var scale = ctx.scale;
    ctx.scale = function(sx,sy){
        sx = parseFloat(sx);
        sy = parseFloat(sy);
        xform = xform.scaleNonUniform(sx,sy);
        xform.a = parseFloat(xform.a);
        xform.b = parseFloat(xform.b);
        xform.c = parseFloat(xform.c);
        xform.d = parseFloat(xform.d);
        xform.e = parseFloat(xform.e);
        xform.f = parseFloat(xform.f);
        return scale.call(ctx,sx,sy);
    };
    var rotate = ctx.rotate;
    ctx.rotate = function(radians){
        xform = xform.rotate(radians*180/Math.PI);
        xform.a = parseFloat(xform.a);
        xform.b = parseFloat(xform.b);
        xform.c = parseFloat(xform.c);
        xform.d = parseFloat(xform.d);
        xform.e = parseFloat(xform.e);
        xform.f = parseFloat(xform.f);
        return rotate.call(ctx,radians);
    };
    var translate = ctx.translate;
    ctx.translate = function(dx,dy){
        dx = parseFloat(dx);
        dy = parseFloat(dy);
        xform = xform.translate(dx,dy);
        xform.a = parseFloat(xform.a);
        xform.b = parseFloat(xform.b);
        xform.c = parseFloat(xform.c);
        xform.d = parseFloat(xform.d);
        xform.e = parseFloat(xform.e);
        xform.f = parseFloat(xform.f);
        return translate.call(ctx,dx,dy);
    };
    var transform = ctx.transform;
    ctx.transform = function(a,b,c,d,e,f){
        var m2 = svg.createSVGMatrix();
        a = parseFloat(a);
        b = parseFloat(b);
        c = parseFloat(c);
        d = parseFloat(d);
        e = parseFloat(e);
        f = parseFloat(f);
        m2.a=a; m2.b=b; m2.c=c; m2.d=d; m2.e=e; m2.f=f;
        xform = xform.multiply(m2);
        xform.a = parseFloat(xform.a);
        xform.b = parseFloat(xform.b);
        xform.c = parseFloat(xform.c);
        xform.d = parseFloat(xform.d);
        xform.e = parseFloat(xform.e);
        xform.f = parseFloat(xform.f);
        return transform.call(ctx,a,b,c,d,e,f);
    };
    var setTransform = ctx.setTransform;
    ctx.setTransform = function(a,b,c,d,e,f){
        xform.a = parseFloat(a);
        xform.b = parseFloat(b);
        xform.c = parseFloat(c);
        xform.d = parseFloat(d);
        xform.e = parseFloat(e);
        xform.f = parseFloat(f);
        return setTransform.call(ctx,a,b,c,d,e,f);
    };
    var pt  = svg.createSVGPoint();
    ctx.transformedPoint = function(x,y){
        x = parseFloat(x);
        y = parseFloat(y);
        pt.x=x; pt.y=y;
        return pt.matrixTransform(xform.inverse());
    };
    var pt  = svg.createSVGPoint();
    ctx.mousePoint = function(x,y){
        x = parseFloat(x);
        y = parseFloat(y);
        pt.x=x; pt.y=y;
        return pt.matrixTransform(xform);
    };
}

function getNavigation(lastMousePosition, e)
{
    var xDiff = lastMousePosition.ptX - e.clientX;
    var yDiff = lastMousePosition.ptY - e.clientY;

    if (Math.abs(xDiff) > Math.abs(yDiff)) {
        if (xDiff > 0) {
            return { moveToNext : true, xDiff : xDiff,  yDiff : undefined, frameIndex : lastMousePosition.frameIndex, imageIndex : lastMousePosition.imageIndex};
        } else {
            return { moveToNext : false, xDiff : Math.abs(xDiff),  yDiff : undefined, frameIndex : lastMousePosition.frameIndex, imageIndex : lastMousePosition.imageIndex};
        }
    } else {
        if (yDiff > 0) {
            return { moveToNext : true, xDiff : undefined,  yDiff : yDiff, frameIndex : lastMousePosition.frameIndex, imageIndex : lastMousePosition.imageIndex};
        } else {
            return { moveToNext : false, xDiff : undefined,  yDiff : Math.abs(yDiff), frameIndex : lastMousePosition.frameIndex, imageIndex : lastMousePosition.imageIndex};
        }
    }
    return undefined;
}

/**
 * Prepare the print for ECG modality
 * printOption - Specifies the print option
 */ 
ImageRenderer.prototype.PrepareECGPrint = function(printOption) {
    try
    {
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        var ScaleValue = 1;
        if(printOption == 1) {
            ScaleValue = parseFloat(this.tempEcgScale);
        }

        var layoutId = activeSeriesLayout.getSeriesLayoutId();
        var imageEcgDivId = "imageEcgCanvas"+layoutId;
        var originalCanvas = document.getElementById(imageEcgDivId);
        var printCanvas = document.createElement("canvas");

        printCanvas.width = this.ecgData.width * ScaleValue;
        printCanvas.height = this.ecgData.height * ScaleValue;
        var printContext = printCanvas.getContext('2d');

        printContext.clearRect(0,0,printCanvas.width,printCanvas.height);
        printContext.fillStyle = 'white';
        printContext.fillRect(0, 0, printCanvas.width, printCanvas.height);
        printContext.save();
        printContext.scale(ScaleValue, ScaleValue);
        printContext.drawImage(this.ecgData.imageObject, 0, 0);
        if(dicomViewer.isShowcaliper(this.imageUid)) {
            dicomViewer.printCaliper(printContext, this.imageUid);
        }

        printContext.restore();
        return printCanvas.toDataURL('image/jpeg', 1.0);
    }
    catch(e)
    { }
}