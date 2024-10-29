var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var SCROLLBAR_PADDING = 40;
    var VERTICAL_PADDING = 5;

    /**
     * create the PDF view
     * @param {Type} url - Specifies the Url
     * @param {Type} divId - parent viewport id
     */
    function createPDF(url, divId) {
        try {
            // Create the DIV to hold the pdf canvas
            var pdfDataElement = "<div id='pdfData_" + divId + "'><div style='background:white;'></div></div>";
            $("#" + divId).html(pdfDataElement);
            $("#" + divId).height($("#" + divId).height());
            $("#" + divId).width($("#" + divId).width());
            $("#" + divId).css("overflow", "auto");
            $("#" + divId).css("background", "black");
            var imagePdfDivId = "imagePdfDiv" + divId;
            var jImagePdfDiv = "<div id='" + imagePdfDivId + "' align='center' style='background:black;float: left;' ></div>";
            $("#" + divId).append(jImagePdfDiv);
            document.getElementById(imagePdfDivId).addEventListener(/Firefox/i.test(navigator.userAgent) ? "DOMMouseScroll" : "mousewheel", onMouseWheel);

            // Create the pdf canvas
            var pdfCanvas = document.createElement("canvas");
            pdfCanvas.setAttribute("id", "imagePdfCanvas" + divId);
            pdfCanvas.setAttribute("width", $("#" + divId).width());
            pdfCanvas.setAttribute("height", $("#" + divId).height());
            pdfCanvas.style.background = "black";

            // Append the canvas
            var heigtOfPdfImage = $("#" + divId).height() - $("#pdfData_" + divId).height();
            $("#" + imagePdfDivId).height(heigtOfPdfImage);
            $("#" + imagePdfDivId).width($("#" + divId).width());
            $("#" + imagePdfDivId).append(pdfCanvas);

            // Bind the page number key press
            $("#pageNumber").unbind("keypress");
            $("#pageNumber").bind("keypress", {}, pageNumberKeyPressEvent);

            // Load the pdf
            PDFJS.disableStream = false;
            PDFJS.getDocument(url).then(function (pdfData) {
                var renderer = getRenderer(divId);
                if (renderer !== null && renderer !== undefined) {
                    renderer.pdfData = {
                        imageData: pdfData,
                        pageCount: pdfData.numPages,
                        currentPageNumber: 0,
                        viewportId: divId,
                        PState: new Presentation()
                    };
                    var activeSeries = dicomViewer.getActiveSeriesLayout();
                    var displaySettings = dicomViewer.getStudyDetails(activeSeries.studyUid).displaySettings;
                    var zoomLevel = displaySettings.ZoomLevel;
                    renderer.pdfData.PState.zoomLevel = zoomLevel;
                    dicomViewer.tools.resetZoomTool();
                    var id = zoomLevel + "_zoom";
                    $("#" + id + "ContextMenu").css("background", "#868696");
                    $("#" + id).parent().css("background", "#868696");

                    if (divId == activeSeries.seriesLayoutId) {
                        activeSeriesPDFData = renderer.pdfData;
                        isPDFActiveSeries = true;
                    }

                    // Open the first page
                    navigatePage(1, undefined, renderer);
                    if (isPDFActiveSeries == true) {
                        enableorDisableNavigations(activeSeriesPDFData);
                    }
                } else {
                    dumpConsoleLogs(LL_ERROR, undefined, "createPDF", "Invalid PDF Renderer");
                }
            });
        } catch (e) {}
    }

    /**
     * Open the page
     * @param {Type} renderer - Specifies the renderer object
     */
    function openPage(renderer) {
        try {
            if (renderer === null || renderer === undefined) {
                // Invalid renderer
                return;
            }

            var pdfData = renderer.pdfData;
            if (pdfData === null || pdfData === undefined) {
                // Invalid pdf object
                return;
            }

            var imageData = pdfData.imageData;
            if (imageData === null || imageData === undefined) {
                // Invalid pdf image data object
                return;
            }

            // Render page
            imageData.getPage(pdfData.currentPageNumber).then(function (page) {
                var actualViewport = page.getViewport(1);
                var pageElement = document.getElementById("imagePdfDiv" + pdfData.viewportId);
                var pdfCanvas = document.getElementById("imagePdfCanvas" + pdfData.viewportId);
                var pdfCanvasContext = pdfCanvas.getContext('2d');

                var hPadding = SCROLLBAR_PADDING;
                var vPadding = VERTICAL_PADDING;
                var pageWidthScale = (pageElement.clientWidth - hPadding) / actualViewport.width;
                var pageHeightScale = (pageElement.clientHeight - vPadding) / actualViewport.height;

                var zoomFactor = 1;
                switch (pdfData.PState.zoomLevel) {
                    case 0:
                        zoomFactor = 1;
                        break;

                    case 1:
                        zoomFactor = Math.min(pageWidthScale, pageHeightScale);
                        break;

                    case 2:
                        zoomFactor = pageWidthScale;
                        break;

                    case 3:
                        zoomFactor = pageHeightScale;
                        break;

                    case 4:
                        zoomFactor = pdfData.PState.zoom;
                        break;

                    default:
                        zoomFactor = Math.min(pageWidthScale, pageHeightScale);
                        break;
                }

                var viewport = page.getViewport(zoomFactor, pdfData.PState.rotation, pdfData.PState.hFlip, pdfData.PState.vFlip);
                pdfData.PState.zoom = zoomFactor;
                pdfCanvas.height = viewport.height;
                pdfCanvas.width = viewport.width;

                var renderContext = {
                    canvasContext: pdfCanvasContext,
                    viewport: viewport
                };
                page.render(renderContext);
            })
        } catch (e) {}
    }

    /**
     * Update the page
     * @param {Type} pageNavigation - Specifies the page navigation id 
     * @param {Type} customPageNumber - Specifies the custom page number
     * @param {Type} renderer - Specifies the renderer object
     */
    function navigatePage(pageNavigation, customPageNumber, renderer) {
        try {
            if (renderer === null || renderer === undefined) {
                renderer = getRenderer();
                if (renderer === null || renderer === undefined) {
                    // Invalid renderer
                    return;
                }
            }

            var pdfData = renderer.pdfData;
            if (pdfData === null || pdfData === undefined) {
                // Invalid pdf object
                return;
            }

            var pageNumber = 0;
            var currentPageNumber = 0;
            var numOfPages = pdfData.pageCount;
            var currentPageNumber = pdfData.currentPageNumber;
            switch (pageNavigation) {
                case 1:
                    {
                        // First Page
                        pageNumber = 1;
                        break;
                    }

                case 2:
                    {
                        // Next Page
                        pageNumber = Math.min(numOfPages, currentPageNumber + 1);
                        break;
                    }

                case 3:
                    {
                        // Previous Page
                        pageNumber = Math.max(1, currentPageNumber - 1);
                        break;
                    }

                case 4:
                    {
                        // Last Page
                        pageNumber = numOfPages;
                        break;
                    }

                case 5:
                    {
                        // custom Page
                        pageNumber = (customPageNumber < 1 ? 1 : (customPageNumber > numOfPages ? numOfPages : customPageNumber));
                        break;
                    }

                default:
                    {
                        // First Page
                        pageNumber = 1;
                        break;
                    }
            }

            if (pdfData.currentPageNumber == pageNumber) {
                enableorDisableNavigations(pdfData);
                return;
            }

            // Open the page
            pdfData.currentPageNumber = pageNumber;
            openPage(renderer);
            enableorDisableNavigations(pdfData);
        } catch (e) {}
    }

    /**
     * set the pdf zoom
     * @param {Type} zoomMode  - Specifies the zoom mode
     * @param {Type} zoomfactor - Specifies the zoom factor
     */
    function setPdfZoom(zoomMode, zoomfactor) {
        try {
            var renderer = getRenderer();
            if (renderer === null || renderer === undefined) {
                // Invalid renderer
                return;
            }

            var pdfData = renderer.pdfData;
            if (pdfData === null || pdfData === undefined) {
                // Invalid pdf object
                return;
            }

            // Update the zoom mode and zoom factor
            pdfData.PState.zoomLevel = zoomMode;
            if (zoomfactor != undefined) {
                pdfData.PState.zoomLevel = 4;
                pdfData.PState.zoom = zoomfactor;
            }

            // Refresh the page 
            openPage(renderer);
        } catch (e) {}
    }

    /**
     * Get the renderer
     */
    function getRenderer(divId) {
        try {
            var seriesLayout = null;
            if (divId !== undefined) {
                seriesLayout = dicomViewer.viewports.getViewport(divId);
            } else {
                seriesLayout = dicomViewer.getActiveSeriesLayout();
            }

            if (seriesLayout !== undefined && seriesLayout !== null) {
                return seriesLayout.getImageRender("pdfData");
            }
        } catch (e) {}

        return undefined;
    }

    /**
     * Binthe key press event
     * @param {Type} e - Spectifies the key press event
     */
    function pageNumberKeyPressEvent(e) {
        var code = (e.keyCode ? e.keyCode : e.which);
        if (code == 13) { //Enter keycode
            e.preventDefault();
            navigatePage(5, parseInt(e.currentTarget.value));
        }
    };

    /**
     * Enable and Disable the PDF tools
     * @param {Type} divId - Spcifies the pdf properties
     */
    function enableorDisableNavigations(pdfData) {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (seriesLayout == undefined || seriesLayout == null) {
            return;
        }

        var image = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, seriesLayout.scrollData.imageIndex);
        if (image.imageType == IMAGETYPE_PDF || image.imageType == IMAGETYPE_TIFF || image.imageType == IMAGETYPE_RADPDF) {
            document.getElementById("pageNumber").value = pdfData.currentPageNumber;
            document.getElementById("totalPagesLabel").textContent = "of " + pdfData.pageCount;
            pdfData.currentPageNumber >= pdfData.pageCount ? $("#nextPage").addClass("k-state-disabled") : $("#nextPage").removeClass("k-state-disabled");
            pdfData.currentPageNumber <= 1 ? $("#previousPage").addClass("k-state-disabled") : $("#previousPage").removeClass("k-state-disabled");
            pdfData.currentPageNumber == 1 ? $("#firstPage").addClass("k-state-disabled") : $("#firstPage").removeClass("k-state-disabled");
            pdfData.currentPageNumber == pdfData.pageCount ? $("#lastPage").addClass("k-state-disabled") : $("#lastPage").removeClass("k-state-disabled");
            if (pdfData.pageCount == 1) {
                pdfFiledSetElement.hide();
                pdfToolBarElement.hide();
            } else {
                pdfFiledSetElement.show();
                pdfToolBarElement.show();
            }
        }
    }

    /**
     * Update the navigation control
     * @param {Type} divId - Specifies the seriesLayoutId
     */
    function updatePaging(divId) {
        var renderer = null;
        if (renderer === null) {
            renderer = getRenderer(divId);
            if (renderer === null || renderer === undefined) {
                // Invalid renderer
                return;
            }
        }

        var pdfData = renderer.pdfData;
        if (pdfData === null || pdfData === undefined) {
            // Invalid pdf object
            return;
        }

        enableorDisableNavigations(pdfData);
    }

    /**
     * Open the first page
     */
    function openFirstPage() {
        navigatePage(1);
    }

    /**
     * Open the next page
     */
    function openNextPage() {
        navigatePage(2);
    }

    /**
     * Open the previous page
     */
    function openPreviousPage() {
        navigatePage(3);
    }

    /**
     * Open the last page
     */
    function openLastPage() {
        navigatePage(4);
    }

    /**
     * Rotate the PDF 
     */
    function rotate() {
        var renderer = getRenderer();
        if (renderer === null || renderer === undefined) {
            // Invalid renderer
            return;
        }

        var pdfData = renderer.pdfData;
        if (pdfData === null || pdfData === undefined) {
            // Invalid pdf object
            return;
        }
        pdfData.PState.rotation = (pdfData.PState.rotation + 90) < 360 ? pdfData.PState.rotation + 90 : 0;
        openPage(renderer);
    }

    /**
     * Flip the PDF
     * @param {Type} isHFlip - Boolean - it specifies the Horizontal or Vertical flip
     */
    function flip(isHFlip) {

        var renderer = getRenderer();
        if (renderer === null || renderer === undefined) {
            // Invalid renderer
            return;
        }
        var pdfData = renderer.pdfData;
        if (pdfData === null || pdfData === undefined) {
            // Invalid pdf object
            return;
        }
        isHFlip ? pdfData.PState.hFlip = !pdfData.PState.hFlip : pdfData.PState.vFlip = !pdfData.PState.vFlip;
        openPage(renderer);
    }

    /**
     * Revert the applied changes
     */
    function revert() {
        var renderer = getRenderer();
        if (renderer === null || renderer === undefined) {
            // Invalid renderer
            return;
        }

        var pdfData = renderer.pdfData;
        if (pdfData === null || pdfData === undefined) {
            // Invalid pdf object
            return;
        }
        pdfData.currentPageNumber = 0;
        pdfData.PState = undefined;
        pdfData.PState = new Presentation();
        navigatePage(1, undefined, renderer);
    }

    dicomViewer.createPDF = createPDF;
    dicomViewer.openFirstPage = openFirstPage;
    dicomViewer.openNextPage = openNextPage;
    dicomViewer.openPreviousPage = openPreviousPage;
    dicomViewer.openLastPage = openLastPage;
    dicomViewer.setPdfZoom = setPdfZoom;
    dicomViewer.updatePaging = updatePaging;
    dicomViewer.rotate = rotate;
    dicomViewer.flip = flip;
    dicomViewer.revert = revert;

    return dicomViewer;
}(dicomViewer));
