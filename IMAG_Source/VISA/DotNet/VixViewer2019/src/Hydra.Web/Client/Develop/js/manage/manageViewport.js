/**
 * New node file
 */

var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var studyLevelMap = [];

    /**
     * create view port
     */
    function createViewport(row, column, studyLayoutId, studyUid) {
        var height = WINDOWHEIGHT - 87;

        var viewportString = '<table id=table' + studyLayoutId + ' style="width:100%;height:' + height + 'px;">';
        for (var i = 0; i < row; i++) {
            viewportString += '<tr style="height:' + (100 / row) + '%;">';
            for (var int2 = 0; int2 < column; int2++) {
                viewportString += '<td style="width:' + (100 / column) + '%;height:' + (100 / row) + '%;padding-left:5px;">';
                viewportString += '<div id="imageviewer_' + studyLayoutId + "_" + (i + 1) + 'x' + (int2 + 1) + '"style="width:100%;height:100%;float:left;background-color:black;"  class="disableSelection" tabindex="0">';
                viewportString += '</td>';
            }

            viewportString += '</tr>';
        }

        viewportString += '</table>';
        if (studyLayoutId != undefined) {
            var studyLayoutElement = $("#" + studyLayoutId);
            var studyInformationdiv = "studyInfo" + studyLayoutId;
            var studyUidAndDateTime = "studyUidDateTime" + studyLayoutId;
            var headerwidth = (WINDOWWIDTH) - 140;
            if (headerwidth < 10) {
                headerwidth = 10;
            }

            var studyInformation = "<table id=table" + studyInformationdiv + " style='width:99%;cursor: default;display:none;/*background:rgba(152, 153, 158, 0.59);*/'>" +
                "<tr>" +
                "<td style = 'width:" + headerwidth + "px'>" +
                "<div id=" + studyInformationdiv + " style='color: white;padding-left: 5px;width: " + headerwidth + "px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis'></div>" +
                "<div id=" + studyUidAndDateTime + " style='color: white;padding-left: 5px;font-size:10px;width: " + headerwidth + "px;white-space: nowrap;overflow: hidden;text-overflow: ellipsis'></div>" +
                "</td>" +
                "<td align='right' style='width: 12px;'>" +
                "</td>" +
                "</tr>" +
                "</table>"

            studyLayoutElement.append(studyInformation);
            $(".k-item").css("border-color", "transparent");
            studyLayoutElement.append(viewportString);
            var heightOfStudyInfo = $("#table" + studyInformationdiv).outerHeight();
            var heightOfStudyLayout = studyLayoutElement.height();

            var tempHeight = heightOfStudyLayout;

            var viewHeight = (heightOfStudyLayout - heightOfStudyInfo);
            var evenRow = studyLayoutElement.parent().closest('tr').css('border-top-width');
            if (evenRow !== "0px") {
                viewHeight = (heightOfStudyLayout - heightOfStudyInfo) - 2;
            }

            $("#table" + studyLayoutId).height(viewHeight - 3);
        } else {
            $("#manage_ImageThumbnail_View").html(viewportString);
        }

        $("#table" + studyLayoutId).width(studyLayoutElement.width() - 5);
        $("#menuIL" + studyLayoutId).children().addClass("k-state-disabled");
    }

    /**
     * Create study view port
     */
    function createStudyViewport(row, column) {
        studyLevelMap = new Array();
        $("#manage_ImageThumbnail_View").empty();
        var viewportString = '<table id="viewportTable" style="width:100%;">';
        for (var i = 0; i < row; i++) {
            viewportString += '<tr>';
            for (var int2 = 0; int2 < column; int2++) {
                viewportString += '<td>';
                studyLevelMap.push('studyViewer' + (i + 1) + 'x' + (int2 + 1));
                viewportString += '<div id="studyViewer' + (i + 1) + 'x' + (int2 + 1) + '"style="width:100%;height:180px;float:left;" class="disableSelection" tabindex="0"></div>';
                viewportString += '</td>';
            }
            viewportString += '</tr>';
        }
        viewportString += '</table>';
        $("#manage_ImageThumbnail_View").html(viewportString);
        $("#viewportTable tr:nth-child(even)").css("border-top", "2px solid black");
        $("#viewportTable td:nth-child(even)").css("border-left", "2px solid black");
        $("#viewportTable tr:nth-child(odd)").css("border-top", "2px solid black");
        $("#viewportTable td:nth-child(odd)").css("border-left", "2px solid black");
    }

    /**
     * create the layout
     * @param {Type} row - Specifies the row count
     * @param {Type} column - Specifies the column count
     */
    function createLayout(row, column, selectedSeries) {

        // Create the series thumbnails
        var studyUids = dicomViewer.getListOfStudyUid(false);
        createStudyViewport(studyUids.length, column);

        for (var index = 0; index < studyUids.length; index++) {
            setSeriesLayout(studyUids[index], row, column, "studyViewer" + (index + 1) + "x1", selectedSeries);
        }
    }

    /* Load the dicom images in viewports*/
    function setSeriesLayout(studyUid, row, column, studyViewportId, selectedSeries) {
        createViewport(row, column, studyViewportId, studyUid);

        var layoutId = "imageviewer_" + studyViewportId + "_1x1";
        var viewport = new SeriesLevelLayout(layoutId);

        viewport.setStudyUid(studyUid);
        viewport.seriesLayoutId = layoutId;
        viewport.setSeriesIndex(0);
        viewport.setImageIndex(0);
        viewport.setFrameIndex(0);
        viewport.setImageLayoutDimension("1x1");

        dicomViewer.viewports.addViewport(viewport.seriesLayoutId, viewport);
        setImageLevelLayout(studyUid, row, column, layoutId, selectedSeries);
    }

    /**
     * Set the image level layout
     */
    function setImageLevelLayout(studyUid, row, column, seriesLevelDiv, selectedSeries) {
        $("#" + seriesLevelDiv).empty();
        var height = "190px";
        var imageLevelName = seriesLevelDiv + "ImageLevel";
        var thumbnailPanelDiv;
        var appendString = "<table style='width:100%;height:" + height + ";'>";
        for (var i = 0; i < row; i++) {
            appendString += "<tr style='height:" + height + ";'>";
            for (var j = 0; j < column; j++) {
                var tableDataId = imageLevelName + i + "x" + j + "id";
                appendString += "<td id=" + tableDataId + " style='width:" + ((100 / column)) + "%;height:" + height + ";'>";
                thumbnailPanelDiv = imageLevelName + i + "x" + j;
                appendString = appendString + "<div id=" + imageLevelName + i + "x" + j + " style='height:" + height + ";width:100%;'></div>";
                appendString += "</td>";
            }
            appendString += "</tr>";
        }

        appendString += "</table>";
        $("#" + seriesLevelDiv).html(appendString);

        dicomViewer.thumbnail.create(studyUid, selectedSeries, seriesLevelDiv);
    }

    dicomViewer.createLayout = createLayout;
    return dicomViewer;
}(dicomViewer));
