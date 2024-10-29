/*
Call the loadstudy method while loading the body (onload) of the loader page
After loading the image, it calls the setSeriesLayout inside the cache\imageViewport.js
From that it calls the setImageLevelLayout method
There we check the image type (ECG|| PDF || RAD || RADECHO) if the type is ECG it calls the loadEcg method inside the EcgRender.js
*/
var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var urlPram;
    var selectedEcgFormat = {};
    var verticalCaliperValue = undefined;
    var verContxtValue = undefined
    var isEcgPrefornecCreated = false;
    var ecgPreferenceValue = {};
    var ecgCacheDetails = {};
    var ecgPreferenceType = {};
    var isToUseSavedValue = true;
    var configuredLeadType = "3x4+1";

    function loadEcg(urlParameters, divId, menuUrl, flag, requestHeaders) {
        var savedPreferenceValue = getECGPreferenceValue(urlParameters.ImageUid);
        var savedPreferenceType = getECGPreferenceType(urlParameters.ImageUid);

        if (savedPreferenceValue != undefined && savedPreferenceType != undefined && isToUseSavedValue) {
            menuUrl = dicomViewer.getEcgMenuUrl(urlPram.ImageUid, getLeadValue());

            updatePreference("GridType", savedPreferenceValue["gridType"], savedPreferenceType["GridType"]);
            updatePreference("GridColor", savedPreferenceValue["gridColor"], savedPreferenceType["GridColor"]);
            updatePreference("SignalThickness", savedPreferenceValue["signalThickness"], savedPreferenceType["SignalThickness"]);
            updatePreference("Gain", savedPreferenceValue["gain"], savedPreferenceType["Gain"]);
            updatePreference("LeadFormat", savedPreferenceValue["leadFormat"], savedPreferenceType["DrawType"]);

            flag = true;
        }

        $("#ecgPreference").prop("disabled", false);
        urlPram = dicomViewer.getEcgInformationUrl(urlParameters.ImageUid);
        var url = dicomViewer.url.getDicomImageURL(urlParameters);

        var request;
        if (window.XMLHttpRequest) { // If the browser if IE7+[or]Firefox[or]Chrome[or]Opera[or]Safari
            request = new XMLHttpRequest();
        } else { //If browser is IE6, IE5
            request = new ActiveXObject("Microsoft.XMLHTTP");
        }
        request.onreadystatechange = function () {
            if (request.readyState == 4 && request.status == 200) {
                if (!flag) {
                    // Get the ECG preference
                    var activeSeriesLayout = dicomViewer.viewports.getViewport(divId);
                    if (activeSeriesLayout !== undefined && activeSeriesLayout !== null) {
                        var imageRender = activeSeriesLayout.getImageRender("ecgData");
                        if (activeSeriesLayout !== undefined && imageRender !== undefined) {
                            imageRender.applyOrRevertDisplaySettings();
                            var preferenceInfo = activeSeriesLayout.preferenceInfo;

                            // Selected ECG Preference selection
                            if (preferenceInfo !== undefined && preferenceInfo.selectedEcgFormat !== undefined) {
                                gridType = preferenceInfo.selectedEcgFormat.GridType;
                                gridColor = preferenceInfo.selectedEcgFormat.GridColor;
                                signalThickness = preferenceInfo.selectedEcgFormat.SignalThickness;
                                gain = preferenceInfo.selectedEcgFormat.Gain;
                                drawType = preferenceInfo.selectedEcgFormat.DrawType;
                            }

                            // ECG Preference selection
                            if (preferenceInfo !== undefined && preferenceInfo.preferenceData !== undefined) {
                                gridColorSelection = preferenceInfo.preferenceData.gridColor;
                            }
                        }
                    }

                    urlParameters = dicomViewer.getEcgWaveformUrl(urlParameters.ImageUid,
                        drawType, gridType, gridColor, signalThickness, gain);
                    // Set default values to the ECG URL parameters
                    var seriesLayout = dicomViewer.getActiveSeriesLayout();
                    if (seriesLayout != null || seriesLayout != undefined) {
                        seriesLayout.preferenceInfo.addECGParameters("GridType", gridType);
                        seriesLayout.preferenceInfo.addECGParameters("GridColor", gridColor);
                        seriesLayout.preferenceInfo.addECGParameters("SignalThickness", signalThickness);
                        seriesLayout.preferenceInfo.addECGParameters("Gain", gain);
                        seriesLayout.preferenceInfo.addECGParameters("DrawType", drawType);
                        //Drag and Drop or click the Ecg thumbnal after chnaging the grid color to gray
                        //If we dont set grid color to red(white claiper in red grid)the claiper will display white
                        seriesLayout.preferenceInfo.setGridColor(gridColorSelection);
                    }
                    url = dicomViewer.url.getDicomImageURL(urlParameters);
                } else {
                    menuUrl.Transform = "Png";
                    url = dicomViewer.url.getDicomImageURL(menuUrl);
                    var parameteres = "";
                    // Load the ECG parameter values using existing selected preference information
                    var seriesLayout = dicomViewer.getActiveSeriesLayout();
                    var selectedECGFormat = seriesLayout.preferenceInfo.getECGParameters();
                    for (var key in selectedECGFormat) {
                        parameteres = parameteres + "&" + key + "=" + selectedECGFormat[key];
                    }
                    url = url + parameteres;
                }

                var jsonData = JSON.parse(request.responseText);

                //if(isEcgPrefornecCreated === false)
                {
                    var leadTyptes = jsonData.LeadTypes;
                    var lengthOfLeadTypes = leadTyptes.length;
                    var isRevert = $("#3x41Value") ? ($("#3x41Value")[0] ? $("#3x41Value")[0].isRevert : false) : false;
                    var valueOne = "";
                    var valueTwo = "";
                    var valueThree = "";

                    //VAI-1316
                    var initDropdowns = false;
                    var selectParent = document.getElementById("3x41");
                    if (selectParent.childElementCount == 0) {
                        initDropdowns = true;
                        var dropdown = document.createElement("select");
                        dropdown.id = "3x41Value";
                        dropdown.classList.add('prefBtn');
                        selectParent.appendChild(dropdown);

                        var dropdown1 = document.createElement("select");
                        dropdown1.id = "3x43one";
                        dropdown1.classList.add('prefBtn');
                        var selectParent1 = document.getElementById("3x43_1");
                        selectParent1.appendChild(dropdown1);

                        var dropdown2 = document.createElement("select");
                        dropdown2.id = "3x43two";
                        dropdown2.classList.add('prefBtn');
                        var selectParent2 = document.getElementById("3x43_2");
                        selectParent2.appendChild(dropdown2);

                        var dropdown3 = document.createElement("select");
                        dropdown3.id = "3x43three";
                        dropdown3.classList.add('prefBtn');
                        var selectParent3 = document.getElementById("3x43_3");
                        selectParent3.appendChild(dropdown3);
                    }
                 

                    for (var index = 0; index < lengthOfLeadTypes; index++) {
                        var value = leadTyptes[index];
                        if (index === 1)
                            valueOne = value;
                        else if (index === 7)
                            valueTwo = value;
                        else if (index === 10)
                            valueThree = value;

                        //VAI-1316
                        if (initDropdowns) {
                            var option = document.createElement("option");
                            option.value = value;
                            option.text = value;
                            dropdown.appendChild(option);
                            dropdown1.appendChild(option.cloneNode(true));
                            dropdown2.appendChild(option.cloneNode(true));
                            dropdown3.appendChild(option.cloneNode(true));
                        }
                    }
                    $("#3x41Value").css('color', '#525252');
                    $("#3x43one").css('color', '#525252');
                    $("#3x43two").css('color', '#525252');
                    $("#3x43three").css('color', '#525252');
                    isEcgPrefornecCreated = true;

                    if (leadTypeObject[divId] && !isRevert) {
                        $.each(leadTypeObject[divId], function (key, value) {
                            $("#" + key).val(value);
                            $("#" + key)[0].preLeadValue = value;
                        });

                        if (url.indexOf("ExtraLead") == -1) {
                            var format = 4;
                            if ($("#ledselection")[0].value == "3x4+3") {
                                format = 8;
                            }
                            var extraLeads = getLeadValue(format);
                            url += "&ExtraLeads=" + extraLeads;
                        }
                    } else {
                        $("#3x41Value").val(valueOne);
                        $("#3x43one").val(valueOne);
                        $("#3x43two").val(valueTwo);
                        $("#3x43three").val(valueThree);
                        $("#ledselection").val("3x4+3");
                        changeECGLedType("3x4+3");

                        // Update the previous lead values
                        $("#3x41Value")[0].preLeadValue = valueOne;
                        $("#3x43one")[0].preLeadValue = valueOne;
                        $("#3x43two")[0].preLeadValue = valueTwo;
                        $("#3x43three")[0].preLeadValue = valueThree;
                        $("#ledselection")[0].preLeadValue = "3x4+3";
                    }

                    if (isRevert) {
                        updateEcgLeadSignal();
                        $("#3x41Value")[0].isRevert = false;
                    }
                    /*var cachedImagesCount = 0; 
                    if(dicomViewer.getCacheInfo != undefined)
                        cachedImagesCount = dicomViewer.getCacheInfo.numberOfImagesCached;

                    var totalCachedcount = cachedImagesCount + ecgRenderedCount;
                    $("#cachemanager_progress").attr("title", "Number of images cached : " + totalCachedcount);
                    setECGCacheDetails(urlParameters.ImageUid, dicomViewer.getActiveSeriesLayout().seriesLayoutId); 
                    updateThumbnailCacheIndication(urlParameters.ImageUid, "green");*/
                }

                var name = changeNullToEmpty(jsonData.PatientName);
                var age = changeNullToEmpty(jsonData.PatientAge);
                var gender = changeNullToEmpty(jsonData.PatientGender);
                var patientId = changeNullToEmpty(jsonData.PatientId);
                var acquisitionDateTime = changeNullToEmpty(jsonData.AcquisitionDateTime);

                var diagnosticText = changeNullToEmpty(jsonData.DiagnosticText);
                var print = changeNullToEmpty(jsonData.PRInt);
                var prtaxes = changeNullToEmpty(jsonData.PRTAxes);
                var qrsdur = changeNullToEmpty(jsonData.QRSDur);
                var qtatc = changeNullToEmpty(jsonData.QTQTc);
                var ventrate = changeNullToEmpty(jsonData.VentRate);

                var referringPhysician = changeNullToEmpty(jsonData.ReferringPhysician);
                var confirmedPhysician = changeNullToEmpty(jsonData.ConfirmedPhysician);

                var heightOfImageViewerDiv = $("#" + divId).height();
                var widthOfImageViewerDiv = $("#" + divId).width();

                //VAI-1316
                document.getElementById(divId).innerHTML = "";
                const para1 = document.createElement('DIV');
                para1.style.fontSize = "12px";
                para1.id = 'ecgData_' + divId;

                const para2 = document.createElement('DIV');
                para2.style.background = "white";
                para2.id='ecgDataDiv_' + divId;

                var table = document.createElement("TABLE");
                var tableBody = document.createElement("tbody");

                var row1 = tableBody.insertRow(-1);
                var cell11 = row1.insertCell();
                var cell12 = row1.insertCell();
                var cell13 = row1.insertCell();
                var cell14 = row1.insertCell();
                var cell15 = row1.insertCell();
                var cell16 = row1.insertCell();

                cell11.innerHTML = "Naming:";
                cell12.innerHTML = "&nbsp"+name;
                cell13.innerHTML = "&nbsp&nbsp&nbsp&nbspVent Rate:";
                cell14.innerHTML = "&nbsp"+ventrate;
                cell15.rowSpan = "5";
                cell15.innerHTML ="&nbsp&nbsp&nbsp&nbsp";
                cell16.rowSpan = "5";
                cell16.innerHTML= diagnosticText;

                var row2 = tableBody.insertRow(-1);
                var cell21 = row2.insertCell();
                var cell22 = row2.insertCell();
                var cell23 = row2.insertCell();
                var cell24 = row2.insertCell();

                cell21.innerHTML = "Age:";
                cell22.innerHTML = "&nbsp" +age;
                cell23.innerHTML = "&nbsp&nbsp&nbsp&nbspPR Interval:";
                cell24.innerHTML = "&nbsp" +print;

                var row3 = tableBody.insertRow(-1);
                var cell31 = row3.insertCell();
                var cell32 = row3.insertCell();
                var cell33 = row3.insertCell();
                var cell34 = row3.insertCell();

                cell31.innerHTML = "Gender:";
                cell32.innerHTML = "&nbsp"+ gender;
                cell33.innerHTML = "&nbsp&nbsp&nbsp&nbspQRS Duration:";
                cell34.innerHTML = "&nbsp"+qrsdur;

                var row4 = tableBody.insertRow(-1);
                var cell41 = row4.insertCell();
                var cell42 = row4.insertCell();
                var cell43 = row4.insertCell();
                var cell44 = row4.insertCell();

                cell41.innerHTML = "Patient Id:";
                cell42.innerHTML = "&nbsp" +patientId;
                cell43.innerHTML = "&nbsp&nbsp&nbsp&nbspQT/QTc:";
                cell44.innerHTML = "&nbsp"+ qtatc;

                var row5 = tableBody.insertRow(-1);
                var cell51 = row5.insertCell();
                var cell52 = row5.insertCell();
                var cell53 = row5.insertCell();
                var cell54 = row5.insertCell();
                cell51.innerHTML = "Acquisition DateTime:";
                cell52.innerHTML = "&nbsp"+ acquisitionDateTime;
                cell53.innerHTML = "&nbsp&nbsp&nbsp&nbspP-R-T axes:";
                cell54.innerHTML = "&nbsp"+prtaxes;

                var row6 = tableBody.insertRow(-1);
                var cell61 = row6.insertCell();
                var cell62 = row6.insertCell();
                var cell63 = row6.insertCell();

                cell61.innerHTML = "";
                cell62.innerHTML = "";
                cell63.innerHTML = "Referred by:&nbsp" + referringPhysician + "&nbsp&nbspConfirmed by:&nbsp" + confirmedPhysician;

                table.appendChild(tableBody);
                para2.appendChild(table);
                para1.appendChild(para2);
                document.getElementById(divId).append(para1);

                $("#" + divId).height(heightOfImageViewerDiv);
                $("#" + divId).width(widthOfImageViewerDiv);

                var heightOfEcgDataDiv = $("#ecgData_" + divId).height();
                $("#" + divId).css("overflow", "auto");
                $("#" + divId).css("background", "white");
                var imageEcgDivId = "imageEcgDiv" + divId;
                var jImageEcgDiv = "<div id='" + imageEcgDivId + "' align='center' style='background:white;float: left;' ></div>";
                $("#" + divId).append(jImageEcgDiv);
                document.getElementById(imageEcgDivId).addEventListener(/Firefox/i.test(navigator.userAgent) ? "DOMMouseScroll" : "mousewheel", onMouseWheel);
                $('<input>').attr({
                    type: 'hidden',
                    id: 'imageEcgHidden' + divId,
                    name: 'bar'
                }).appendTo($("#" + divId));
                document.getElementById("imageEcgHidden" + divId).value = url;
                var myCanvas = document.createElement("canvas");
                myCanvas.setAttribute("id", "imageEcgCanvas" + divId);
                var context = myCanvas.getContext("2d");
                myCanvas.style.background = "white";
                // load image from data url
                var imageObj = new Image();
                imageObj.src = url;
                imageObj.isMedian = (jsonData.isMedian === undefined ? false : jsonData.isMedian);
                var heigtOfEcgImage = $("#" + divId).height() - $("#ecgData_" + divId).height();
                $("#" + imageEcgDivId).height(heigtOfEcgImage);
                $("#" + imageEcgDivId).width($("#" + divId).width());
                //myCanvas.height = $("#imageEcgDiv").height();

                imageObj.onload = function () {

                    //myCanvas.width = imageObj.width;
                    //myCanvas.height = imageObj.height;
                    if (urlParameters.ImageUid !== undefined) {
                        updateCacheIndicatorIconAndCountForECG(urlParameters.ImageUid, "green");
                    }
                    var seriesLayout = dicomViewer.viewports.getViewport(divId);
                    var imageRender = seriesLayout.getImageRender("ecgData");
                    imageRender.ecgData = {
                        imageObject: imageObj,
                        width: imageObj.width,
                        height: imageObj.height
                    };
                    var tempScaleValue = 1;
                    //if(!flag){                        

                    imageRender.isMedian = imageObj.isMedian;
                    imageRender.applyOrRevertDisplaySettings(undefined, false, false);
                    var jImageEcgDiv = document.getElementById(imageEcgDivId);
                    var level = imageRender.ecgScalepreset;

                    if (seriesLayout.ecgZoomProperty) {
                        level = seriesLayout.ecgZoomProperty.level;
                    }
                    dicomViewer.tools.updateZoomLevelSettings(level + "_zoom");
                    switch (level) {
                        case 0: //Set Zoom level to 100%
                            tempScaleValue = 1;

                            break;
                        case 1: //Set Zoom level to Window (widht and Height)
                            tempScaleValue = Math.min((jImageEcgDiv.offsetHeight - 4) / imageObj.height, jImageEcgDiv.offsetWidth / imageObj.width);

                            break;
                        case 2: //Set Zoom level Window to Window width
                            tempScaleValue = jImageEcgDiv.offsetWidth / imageObj.width;

                            break;
                        case 3: //Set Zoom level Window to Window height
                            tempScaleValue = jImageEcgDiv.offsetHeight / imageObj.height;

                            break;
                        case 6: //Set Custom Zoom level
                            tempScaleValue = seriesLayout.ecgZoomProperty.customValue / 100;
                            break;
                    }
                    if (tempScaleValue > 1) tempScaleValue = Math.max(1, tempScaleValue - 0.05);
                    myCanvas.width = imageObj.width * tempScaleValue;
                    myCanvas.height = imageObj.height * tempScaleValue;

                    tempScaleValue = tempScaleValue.toFixed(2);
                    imageRender.tempEcgScale = tempScaleValue

                    context.scale(tempScaleValue, tempScaleValue);
                    context.drawImage(imageObj, 0, 0);

                    var imageData = context.getImageData(0, 0, myCanvas.width, myCanvas.height);
                    var ecgParameters = seriesLayout.preferenceInfo.getECGParameters();
                    if (!flag && !ecgParameters) {
                        seriesLayout.preferenceInfo.addECGParameters("GridType", "1");
                        seriesLayout.preferenceInfo.addECGParameters("GridColor", "0");
                        seriesLayout.preferenceInfo.addECGParameters("SignalThickness", "1");
                        seriesLayout.preferenceInfo.addECGParameters("Gain", "1");
                        seriesLayout.preferenceInfo.addECGParameters("DrawType", "8");
                    }

                    seriesLayout.setEcgCanvas(imageData);
                    var imageUid = seriesLayout.getImageRender("ecgData").getImageUid();
                    var horizontalCaliper = dicomViewer.getHorizontalCaliper(imageUid);
                    if (horizontalCaliper != undefined) {
                        dicomViewer.redrawBothCaliper(seriesLayout);
                    }
                };

                $("#" + imageEcgDivId).append(myCanvas);
            }
        }

        request.open("GET", url, false);
        if (requestHeaders) {
            for (var key in requestHeaders) {
                request.setRequestHeader(key, requestHeaders[key]);
            }
        }
        request.send();
    }

    function loadCaliper() {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        if (!seriesLayout.isCaliperEnable) {
            dicomViewer.redrawBothCaliper(seriesLayout);
        }
    }

    function gridType(type, value) {
        urlPram.ImageUid = getActiveLayoutImageUid();
        var gridTypeUrl = dicomViewer.getEcgMenuUrl(urlPram.ImageUid, getLeadValue());
        updatePreference("GridType", value, type);
        loadECGandSavePreference(gridTypeUrl);
        /* loadEcg(urlPram, getCurrentSeriesLayoutDivID(), gainUrl, true);
        setChangedValues();*/
    }

    function gridColor(color, value) {
        urlPram.ImageUid = getActiveLayoutImageUid();
        var gridcolor = dicomViewer.getEcgMenuUrl(urlPram.ImageUid, getLeadValue());
        updatePreference("GridColor", value, color);
        loadECGandSavePreference(gridcolor);
        /* loadEcg(urlPram, getCurrentSeriesLayoutDivID(), gainUrl, true);
         setChangedValues();*/
    }

    /**
     * To get the signal type value for the selected lead type
     * @param {Boolean} format - (it can be 1,2,4,8,16)
     */
    function getLeadValue(format) {
        var leadDefault = {
            "3x41Value": "II",
            "3x43one": "II",
            "3x43two": "V2",
            "3x43three": "V5"
        };
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var layoutDivId = seriesLayout.getSeriesLayoutId();
        var leadObject = leadTypeObject[layoutDivId];
        //Updating the lead object values for the updated signal type
        leadObject = $.extend({}, leadDefault, leadObject);
        if (format == 4) {
            return leadObject["3x41Value"];
        } else if (format == 8) {
            return leadObject["3x43one"] + '|' + leadObject["3x43two"] + '|' + leadObject["3x43three"];
        } else {
            return "";
        }
        setChangedValues();
    }

    function leadFormat(format, value) {
        urlPram.ImageUid = getActiveLayoutImageUid();
        var leadFormatUrl = dicomViewer.getEcgMenuUrl(urlPram.ImageUid, getLeadValue(format));
        updatePreference("LeadFormat", value, format);
        loadECGandSavePreference(leadFormatUrl);
        /* loadEcg(urlPram, getCurrentSeriesLayoutDivID(), gainUrl, true);
         setChangedValues();*/
    }

    function gain(gain, value) {
        urlPram.ImageUid = getActiveLayoutImageUid();
        var gainUrl = dicomViewer.getEcgMenuUrl(urlPram.ImageUid, getLeadValue());
        updatePreference("Gain", value, gain);
        loadECGandSavePreference(gainUrl);
        /* loadEcg(urlPram, getCurrentSeriesLayoutDivID(), gainUrl, true);
         setChangedValues();*/
    }

    function thickness(thickness, value) {
        urlPram.ImageUid = getActiveLayoutImageUid();
        var thicknessUrl = dicomViewer.getEcgMenuUrl(urlPram.ImageUid, getLeadValue());
        updatePreference("SignalThickness", value, thickness);
        loadECGandSavePreference(thicknessUrl);
        /* loadEcg(urlPram, getCurrentSeriesLayoutDivID(), thicknessUrl, true);
         setChangedValues();*/

    }

    function loadECGandSavePreference(url) {
        isToUseSavedValue = false;
        loadEcg(urlPram, getCurrentSeriesLayoutDivID(), url, true);

        var imageUID = urlPram.ImageUid;
        var viewportTemp = dicomViewer.getActiveSeriesLayout();
        var ecgPreferenceValue = viewportTemp.preferenceInfo.preferenceData;
        var ecgpreferenceType = viewportTemp.preferenceInfo.selectedEcgFormat;

        setECGPreferenceType(imageUID, ecgpreferenceType);
        setECGPreferenceValue(imageUID, ecgPreferenceValue);

        isToUseSavedValue = true;
    }

    function getECGPreferenceValue(imageUID) {
        return ecgPreferenceValue[imageUID];
    }

    function setECGPreferenceValue(imageUID, preferenceValue) {
        ecgPreferenceValue[imageUID] = preferenceValue;
    }

    function getECGPreferenceType(imageUID) {
        return ecgPreferenceType[imageUID];
    }

    function setECGPreferenceType(imageUID, preferenceType) {
        ecgPreferenceType[imageUID] = preferenceType;
    }

    function removeSavedECGPreference() {
        for (var key in ecgPreferenceType) {
            delete ecgPreferenceType[key];
        }
        for (var key in ecgPreferenceValue) {
            delete ecgPreferenceValue[key];
        }
        dicomViewer.removeAllCaliperStatus();
    }

    function setECGCacheDetails(imageUID, divID) {
        ecgCacheDetails[imageUID] = divID;
    }

    function changeNullToEmpty(value) {
        if (value == undefined || value == null) {
            return "";
        }
        return value;
    }

    function getActiveLayoutImageUid() {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var render = seriesLayout.getImageRender("ecgData")
        return render.imageUid;
    }


    /**
     * Update the ECG preference information. This information will be maintain at Series Level.
     */
    function updatePreference(preferenceType, value, type) {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var thumbnailId = $(".selected-thumbnail-view")[0].id;
        if (!$("#" + thumbnailId)[0].ecgPreferenceValues) {
            $("#" + thumbnailId)[0].ecgPreferenceValues = {};
        }
        $("#" + thumbnailId)[0].ecgPreferenceValues[preferenceType] = value;
        switch (preferenceType) {
            case "GridType":
                $("#none").parent().css("background", "");
                $("#onemm").parent().css("background", "");
                $("#fivemm").parent().css("background", "");
                $("#" + value).parent().css("background", "#868696");

                seriesLayout.preferenceInfo.preferenceData.gridType = value;
                seriesLayout.preferenceInfo.addECGParameters("GridType", type);
                break;
            case "GridColor":
                $("#redGrid").parent().css("background", "");
                $("#greenGrid").parent().css("background", "");
                $("#blueGrid").parent().css("background", "");
                $("#blackGrid").parent().css("background", "");
                $("#greyGrid").parent().css("background", "");
                $("#" + value).parent().css("background", "#868696");

                seriesLayout.preferenceInfo.setGridColor(value);
                seriesLayout.preferenceInfo.addECGParameters("GridColor", type);
                break;
            case "LeadFormat":
                $("#threebyfour").parent().css("background", "");
                $("#threebyfourplusone").parent().css("background", "");
                $("#threebyfourplusthree").parent().css("background", "");
                $("#sixbytwo").parent().css("background", "");
                $("#twelvebyone").parent().css("background", "");
                $("#averagecomplex").parent().css("background", "");
                $("#" + value).parent().css("background", "#868696");

                seriesLayout.preferenceInfo.setLeadFormat(value);
                seriesLayout.preferenceInfo.addECGParameters("DrawType", type);
                break;
            case "Gain":
                $("#fivemmgain").parent().css("background", "");
                $("#tenmmgain").parent().css("background", "");
                $("#twentymmgain").parent().css("background", "");
                $("#fourtymmgain").parent().css("background", "");
                $("#" + value).parent().css("background", "#868696");

                seriesLayout.preferenceInfo.setGain(value);
                seriesLayout.preferenceInfo.addECGParameters("Gain", type);
                break;
            case "SignalThickness":
                $("#onethickness").parent().css("background", "");
                $("#twothickness").parent().css("background", "");
                $("#threethickness").parent().css("background", "");
                $("#" + value).parent().css("background", "#868696");

                seriesLayout.preferenceInfo.setSignalThickness(value);
                seriesLayout.preferenceInfo.addECGParameters("SignalThickness", type);
                break;
        }

        // Update the ECG preference in series level
        var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
        if (activeSeriesLayout !== undefined && activeSeriesLayout !== null) {
            var imageRender = activeSeriesLayout.getImageRender("ecgData");
            if (imageRender !== undefined && imageRender !== null) {
                if (activeSeriesLayout !== undefined) {
                    imageRender.applyOrRevertDisplaySettings(undefined, undefined, undefined, true);
                }
            }
        }
    }

    function changeNullToEmpty(value) {
        if (value == undefined || value == null) {
            return "";
        }
        return value;
    }

    /**
     * Get the corresponding Series Layout id.
     */
    function getCurrentSeriesLayoutDivID() {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();

        return seriesLayout.getSeriesLayoutId();
    }

    function updateCacheIndicatorIconAndCountForECG(imageUID, indicatorColor) {
        if (ecgCacheDetails[imageUID] == undefined) {
            ecgRenderedCount++;
            var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
            if (activeSeriesLayout !== null && activeSeriesLayout !== undefined) {
                setECGCacheDetails(imageUID, activeSeriesLayout.seriesLayoutId);
            }
        } else {
            for (var key in ecgCacheDetails) {
                if (key != imageUID) {
                    ecgRenderedCount++;
                    setECGCacheDetails(imageUID, dicomViewer.getActiveSeriesLayout().seriesLayoutId);
                } else {
                    return;
                }
            }
        }

        $("#cachemanager_progress").trigger("image_cache_updated", dicomViewer.imageCache.getCacheInfo());
        updateThumbnailCacheIndication(imageUID, indicatorColor);
    }

    /**
     * While Chnaging the ECG prefernce values from the toolbar
     * enable or disable the 3x4+3 or 3x4+1 input values
     **/
    function changeECGLedType(value) {
        if (value === "3x4+3") {
            $("#3x41Value").prop("disabled", true);
            $("#3x43one").prop("disabled", false);
            $("#3x43two").prop("disabled", false);
            $("#3x43three").prop("disabled", false);
            $('#twoDisplay').show();
            $('#oneDisplay').hide();
        } else {
            $("#3x41Value").prop("disabled", false);
            $("#3x43one").prop("disabled", true);
            $("#3x43two").prop("disabled", true);
            $("#3x43three").prop("disabled", true);
            $('#oneDisplay').show();
            $('#twoDisplay').hide();
        }
        setConfiguredLeadType(value);
    }

    /**
     * Initialize the ECG Preference with default values.
     */
    function Refresh() {
        try {
            var activeSeriesLayout = dicomViewer.getActiveSeriesLayout();
            urlPram.ImageUid = getActiveLayoutImageUid();
            updatePreference("GridType", "onemm", "1");
            updatePreference("GridColor", "redGrid", "0");
            updatePreference("LeadFormat", "threebyfourplusthree", "8");
            updatePreference("Gain", "tenmmgain", "1");
            updatePreference("SignalThickness", "onethickness", "1");
            dicomViewer.RevertCaliper();
            var refreshUrl = dicomViewer.getEcgMenuUrl(urlPram.ImageUid, getLeadValue());
            loadECGandSavePreference(refreshUrl);
            var studyDetails = dicomViewer.getStudyDetails(activeSeriesLayout.studyUid);
            var modality = studyDetails ? studyDetails.modality : studyDetails;
            var displaySettings = getDefaultDisplaySettings(modality)
            var e = {
                id: displaySettings.ZoomMode
            };
            dicomViewer.tools.doZoom(e);
        } catch (e) { }
    }

    /**
     * Clear ECG cache details 
     */
    function ClearECGCacheDetails(imageUid) {
        try {
            if (imageUid !== undefined) {
                for (var key in ecgCacheDetails) {
                    if (key === imageUid) {
                        ecgRenderedCount--;
                        delete ecgCacheDetails[imageUid];
                    }
                }
                $("#cachemanager_progress").trigger("image_cache_updated", dicomViewer.imageCache.getCacheInfo());
            }
        } catch (e) { }
    }

    function setConfiguredLeadType(leadType) {
        configuredLeadType = leadType;
    }

    function getConfiguredLeadType() {
        return configuredLeadType;
    }

    function updateECGPreferenceDropDown() {
        var leadtype = getConfiguredLeadType();
        changeECGLedType(leadtype);
    }

    dicomViewer.loadEcg = loadEcg;
    dicomViewer.gridType = gridType;
    dicomViewer.gridColor = gridColor;
    dicomViewer.leadFormat = leadFormat;
    dicomViewer.gain = gain;
    dicomViewer.thickness = thickness;
    dicomViewer.changeNullToEmpty = changeNullToEmpty;
    dicomViewer.loadCaliper = loadCaliper;
    dicomViewer.changeECGLedType = changeECGLedType;
    dicomViewer.removeSavedECGPreference = removeSavedECGPreference;
    dicomViewer.Refresh = Refresh;
    dicomViewer.ClearECGCacheDetails = ClearECGCacheDetails;
    dicomViewer.updateECGPreferenceDropDown = updateECGPreferenceDropDown;

    return dicomViewer;
}(dicomViewer));
