/**
 * 
 */
var dicomViewer = (function (dicomViewer) {

    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var overlayConfig = null;

    var measurementsConfig = null;

    var itemIdCounter = 100;

    function initOverlayConfig() {
        var url = dicomViewer.url.getOverlayTextURL();
        var req = new XMLHttpRequest();
        req.open('GET', url, false);
        req.send(null);
        if (req.status != 200) throwException(_exception.FileLoadFailed); {
            overlayConfig = JSON.parse(req.responseText);
        }
    }

    function getOverLayValuesForCofig(config, imageinfo) {
        var valueArray = [];

        for (var key in config) {
            switch (config[key]) {
                case 'Patient_Name':
                    valueArray[valueArray.length] = imageinfo.getPatientName();
                    break;

                case 'Study_Date_Time':
                    valueArray[valueArray.length] = imageinfo.getStudyDate() + ' ' + imageinfo.getStudyTime();
                    break;

                case 'Accession_Number':
                    valueArray[valueArray.length] = imageinfo.getAccessionNumber();
                    break;

                case 'Manufacturer':
                    valueArray[valueArray.length] = imageinfo.getManufacturer();
                    break;

                case 'ImageNumber':
                    valueArray[valueArray.length] = imageinfo.getInstanceNumber();
                    break;

                case 'WCWW':
                    valueArray[valueArray.length] = 'WCWW';
                    break;

                case 'Scale':
                    valueArray[valueArray.length] = 'Scale';
                    break;

                case 'Brightness':
                    valueArray[valueArray.length] = 'Brightness';
                    break;

                case 'Contrast':
                    valueArray[valueArray.length] = 'Contrast';
                    break;

                case 'Content_Date_Time':
                    if (imageinfo.getModality() == "ES") {
                        valueArray[valueArray.length] = "Content Date Time: " + getFormattedDateTime(imageinfo);
                    }
                    break;
            }
        }
        return valueArray;
    }

    function getOverlayConfig() {
        return overlayConfig;
    }

    function getMeasurementsConfig() {
        return measurementsConfig;
    }

    function createMeasurementMenuItem(item) {
        var li = $("<li />")
        li.append($("<input type=\"radio\" onclick=\"dicomViewer.tools.do2DMeasurement(" + item.type + ",'" + item.id + "','" + item.units + "')\" " +
            "id=\"measurement" + itemIdCounter + "\" " +
            "name=\"measurement\" value=\"" + itemIdCounter + "\" />"));
        li.append($("<label for=\"measurement" + itemIdCounter + "\">" + item.label + "</label>"));
        itemIdCounter++;
        return li;
    }

    function createMeasurementMenu(name) {
        var id = "context-" + name.replace(" ", "");
        var menu = $("<li class=\"dropdown-submenu\"><a href=\"#\" id = " + id + " onclick=\"\">" + name + "</a>" +
            "<ul id=\"" + itemIdCounter + "\" class=\"dropdown-menu dropdown-menu-custom\" role=\"menu\" style=\"background-color: #999;\" ></ul></li>");
        itemIdCounter++;
        return menu;
    }

    function appendMeasurements(parent, data) {

        if (data.items != null) {
            var menu = createMeasurementMenu(data.label);
            var parentMenu = menu.find("ul");
            $.each(data.items, function (index, item) {
                appendMeasurements(parentMenu, item);
            })
            //  menu.appendTo(parent);
        } else {
            var item = createMeasurementMenuItem(data);
            item.appendTo(parent);
        }
    }

    function initMeasurementsConfig() {

        var measurements = getMeasurements();
        if ((measurements == undefined) || (measurements == null) || (measurements.length == 0))
            return;

        $.each(measurements, function (index, item) {
            appendMeasurements($("#contextMenu"), item);
        })
    }

    /**
     * Fortmat the content date time format
     * @param {Type} imageinfo 
     */
    function getFormattedDateTime(imageinfo) {
        try {
            if (isReformatContentDateTime) {
                var date = imageinfo.getContentDate();
                var time = imageinfo.getContentTime();
                if (date) {
                    var year = date.substr(2, 2);
                    var month = date.substr(4, 2);
                    var day = date.substr(6, 2);
                    date = month + "-" + day + "-" + year;
                }
                if (time) {
                    var xx = time.substr(0, 2);
                    var yy = time.substr(2, 2);
                    var zz = time.substr(4, 2);
                    time = xx + ":" + yy + ":" + zz;
                }
                return date + ' @ ' + time;
            } else {
                return imageinfo.getContentDate() + ' @ ' + imageinfo.getContentTime();
            }
        } catch (e) {}

        return "";
    }

    dicomViewer.overlay = {
        initOverlayConfig: initOverlayConfig,
        initMeasurementsConfig: initMeasurementsConfig,
        getOverlayConfig: getOverlayConfig,
        getOverLayValuesForCofig: getOverLayValuesForCofig,
        getMeasurementsConfig: getMeasurementsConfig,
    }



    return dicomViewer;
}(dicomViewer));
