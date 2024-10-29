/**
 * Annotation Preferences file
 */

var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    /**
     * Create dynamic container element
     * @param {Type} id 
     */
    function createDynamicPrefContainer(id) {
        var container = document.createElement("div");
        container.setAttribute('id', id);
        return container;
    }

    /**
     * Create dynamic preference list
     * @param {Type} parent 
     */
    function createDynamicPrefList(parent) {
        var div = document.createElement("div");
        var ul = document.createElement("ul");
        ul.setAttribute('class', "nav nav-tabs nav-stacked");
        ul.setAttribute('id', parent);

        $.each(MT_TypeCol, function (key, value) {
            var li = document.createElement("li");
            var text = value;
            value = value.toLowerCase().replace(/\s|\(|\)|\&/g, "");
            li.setAttribute('id', value + "li");
            li.appendChild(createDynamicAnchor(text, value));
            ul.appendChild(li);
        });
        ul.firstElementChild.setAttribute('class', "active");
        div.appendChild(ul);
        return div;
    }

    /**
     * Create dynamic anchor element
     * @param {Type} text 
     * @param {Type} type 
     */
    function createDynamicAnchor(text, type) {
        var anchor = document.createElement("a");
        anchor.text = text;
        anchor.setAttribute('data-toggle', "tab");
        anchor.setAttribute('id', type + "pref");
        anchor.setAttribute('href', "#" + type + "href");
        anchor.setAttribute('class', "a-link");

        anchor.appendChild(createDynamicDropDown(type));
        // get old onclick attribute
        var onclick = anchor.getAttribute("onclick");
        // if onclick is not a function, it's not IE7, so use setAttribute
        if (typeof (onclick) != "function") {
            anchor.setAttribute('onclick', ' dicomViewer.annotationPreferences.appendSelPrefDiv(' + type + 'li, true);' + onclick); // for FF,IE8,Chrome
            // if onclick is a function, use the IE7 method and call onclick() in the anonymous function
        } else {
            anchor.onclick = function () {
                dicomViewer.annotationPreferences.appendSelPrefDiv(type + "li", true);
                onclick();
            }; // for IE7
        }
        return anchor;
    }

    /**
     * Create dynamic drop down
     * @param {Type} type 
     */
    function createDynamicDropDown(type) {
        var dropDownAnchor = document.createElement("a");
        dropDownAnchor.setAttribute('id', type + "dd");
        dropDownAnchor.setAttribute('class', "pull-right");
        dropDownAnchor.setAttribute('class', "pull-right");
        dropDownAnchor.style.margin = "-5px";
        var dropDownImg = document.createElement("img");
        dropDownImg.setAttribute('src', "images/down-add.png");
        dropDownImg.setAttribute('width', '15px');
        dropDownAnchor.appendChild(dropDownImg);
        return dropDownAnchor;
    }

    /**
     * Append controls to selected preference div element
     * @param {Type} parent 
     * @param {Type} isShow 
     */
    function appendSelPrefDiv(parent, isShow) {
        var type = parent.id.substring(0, parent.id.length - 2);
        var dropDownImg = (document.getElementById(type + "dd")).firstElementChild;
        var element = document.getElementById("prefHref");

        if (dropDownImg.getAttribute('src') == "images/down-add.png") {
            if (element == undefined || element == null) {
                element = document.createElement("div");
                element.setAttribute('id', "prefHref");
                element.setAttribute('class', "ahref-border");
                element.style.height = "180px";
            } else {
                removeAnnotationPreferenceSettings(element);
            }
            showOrHideAllAnnotationAttributes(false);
            var measurementControl = getMeasurementControlsByType(type, isShow);
            if (measurementControl !== null && measurementControl !== undefined) {
                measurementControl.style.margin = "20px";
                measurementControl.style.display = "block";
                element.appendChild(measurementControl);
            }
            element.style.display = isShow ? "block" : "none";
            if (element.firstChild !== undefined && element.firstChild !== null) {
                if (element.firstChild.id == "labelDiv") {
                    highlightLabelTabItem();
                }
            }
            parent.appendChild(element);
            if (!isShow) {
                return;
            }
            $.each(MT_TypeCol, function (key, value) {
                value = value.toLowerCase().replace(/\s|\(|\)|\&/g, "");
                var Img = (document.getElementById(value + "dd")).firstElementChild;
                Img.setAttribute('src', "images/down-add.png");
            });
            dropDownImg.setAttribute('src', "images/up-minus.png");
        } else {
            if (element !== undefined && element !== null) {
                element.style.display = "none";
            }
            dropDownImg.setAttribute('src', "images/down-add.png");
        }
    }

    /**
     * Get measurement controls for selected measurement type
     * @param {Type} type 
     * @param {Type} isShow 
     */
    function getMeasurementControlsByType(type, isShow) {
        var param = null;
        switch (type) {
            case "annotation":
                param = {
                    id: "aDiv",
                    type: "ANNOTATION"
                }
                break;
            case "measurement":
                param = {
                    id: "mDiv",
                    type: "MEASUREMENT"
                }
                break;
            case "ellipserectangle":
                param = {
                    id: "hDiv",
                    type: "ELLIPSE & RECTANGLE"
                }
                break;
            case "label":
            case "text":
                param = {
                    id: type + "Div",
                    type: type.toUpperCase()
                }
                break;
            case "mitralaorticus":
                param = {
                    id: "miDiv",
                    type: "MITRAL & AORTIC (US)"
                }
                break;
            default:
                return null;
                break;
        }
        return getMeasurementControl(param, isShow);
    }

    /**
     * Get measurement control for given paramater
     * @param {Type} param 
     * @param {Type} isShow 
     */
    function getMeasurementControl(param, isShow) {
        var element = createFiledSets(param);
        setTimeout(function () {
            appendCustomAttribures(param, isShow);
        }, 0);
        return element;
    }

    /**
     * Create fieldset elements to hold controls
     * @param {Type} param 
     */
    function createFiledSets(param) {
        var element = document.getElementById(param.id);
        if (element == undefined || element == null) {
            element = document.createElement("div");
            element.setAttribute('id', param.id);
            $.each(MT_EX_TypeCol[param.type], function (key, value) {
                if (value == "LABEL") {
                    appendLabelPrefTabs(element);
                    setTimeout(function () {
                        appendLabelFieldSet(value);
                    }, 0);
                } else {
                    var fieldset = document.createElement("fieldset");
                    fieldset.setAttribute('id', value + "fieldSet");
                    var legend = document.createElement("legend");
                    var isEmpty = false;
                    if (isEmptyLegend(value)) {
                        isEmpty = true;
                    }
                    legend.style.width = isEmpty ? "0px" : "35px";
                    legend.innerHTML = isEmpty ? "" : value;
                    fieldset.appendChild(legend);
                    fieldset.appendChild(getUseDefaultCheckBox(value));
                    element.appendChild(fieldset);
                }
                var breakElement = document.createElement("br");
                element.appendChild(breakElement);
            });
        } else {
            $.each(MT_EX_TypeCol[param.type], function (key, value) {
                if (value != "LABEL") {
                    document.getElementById(value + "chk").style.display = "block";
                }
            });
        }

        $("#LINEfieldSet").hide();
        element.style.display = "block";
        return element;
    }

    /**
     * Append tabs for each label categories
     * @param {Type} parent 
     */
    function appendLabelPrefTabs(parent) {
        var child = document.getElementById("lblTypeMenu");
        setChildToParent(parent, child, "0px");
        child.style.marginTop = "-10px";
    }

    /**
     * Append fieldset for label categories
     * @param {Type} parent 
     */
    function appendLabelFieldSet(value) {
        $.each(MT_Lbl_Col, function (key, value_) {
            var id = value_;
            var tab = null;
            var innerHTML = "";
            var width = "0px";
            if (value_ == "LBLSCOUT" || value_ == "LBLRULER") {
                width = "40px";
                innerHTML = (value_ == "LBLSCOUT") ? "SCOUT" : "RULER";
                tab = document.getElementById("LBLSRTab");
            } else {
                tab = document.getElementById(id + "Tab");
            }
            var fieldset = document.createElement("fieldset");
            fieldset.setAttribute('id', id + "fieldSet");
            var legend = document.createElement("legend");
            legend.style.width = width;
            legend.innerHTML = innerHTML;
            fieldset.appendChild(legend);
            fieldset.appendChild(getUseDefaultCheckBox(id));
            tab.appendChild(fieldset);
            if (value_ == "LBLSCOUT") {
                var breakElement = document.createElement("br");
                tab.appendChild(breakElement);
            }

        });
    }

    /**
     * Check for common control elements
     * @param {Type} value 
     */
    function isEmptyLegend(value) {
        return value == "ASTROKESTYLE" ||
            value == "MSTROKESTYLE" ||
            value == "ERSTROKESTYLE" ||
            value == "LABEL" ||
            value == "TEXT" ||
            value == "MA";
    }

    /**
     * Create checkbox element for given measurement type
     * @param {Type} type 
     */
    function getUseDefaultCheckBox(type) {
        var chkBoxDiv = document.getElementById(type + "chkUseDefault");
        if (chkBoxDiv == undefined || chkBoxDiv == null) {
            chkBoxDiv = document.createElement("div");
            chkBoxDiv.setAttribute('id', type + "chkUseDefault");
            chkBoxDiv.setAttribute('class', "pull-right");
            chkBoxDiv.style.marginTop = "-20px";
            chkBoxDiv.style.marginRight = "25px";

            var table = document.createElement("table");
            var tr = document.createElement("tr");

            var td1 = document.createElement("td");
            var label = document.createElement("label");
            label.innerHTML = "Use Default : ";
            label.style.margin = "5px";
            td1.appendChild(label);

            var td2 = document.createElement("td");
            var chkBox = document.createElement("input");
            chkBox.setAttribute('id', type + "chk");
            chkBox.setAttribute('type', "checkbox");
            chkBox.setAttribute('checked', true);
            chkBox.style.width = "15px";
            chkBox.style.height = "15px";
            chkBox.style.marginTop = "5px";
            chkBox.setAttribute("class", "useDefault-chk");

            // get old onclick attribute
            var onclick = chkBox.getAttribute("onclick");
            // if onclick is not a function, it's not IE7, so use setAttribute
            if (typeof (onclick) != "function") {
                chkBox.setAttribute('onclick', ' dicomViewer.annotationPreferences.onUseDefaultChanged(' + type + 'chk);' + onclick); // for FF,IE8,Chrome
                // if onclick is a function, use the IE7 method and call onclick() in the anonymous function
            } else {
                chkBox.onclick = function () {
                    dicomViewer.annotationPreferences.onUseDefaultChanged(type + "chk");
                    onclick();
                }; // for IE7
            }

            td2.appendChild(chkBox);

            tr.appendChild(td1);
            tr.appendChild(td2);
            table.appendChild(tr);
            chkBoxDiv.appendChild(table);
        }
        chkBoxDiv.style.display = "block";
        return chkBoxDiv;
    }

    /**
     * Append custom attributes for given measurement type
     * @param {Type} param 
     * @param {Type} isShow 
     */
    function appendCustomAttribures(param, isShow) {
        $.each(MT_EX_TypeCol[param.type], function (key, value) {
            var id = getDivId(value);
            var element = document.getElementById(id);
            if (value == "LABEL") {
                $.each(MT_Lbl_Col, function (key, value_) {
                    if (value_ == "LBLSCOUT" || value_ == "LBLRULER") {
                        appendLineAttributes(element, key, value_);
                    } else {
                        appendFontAttributes(element, value_);
                        showOrHideAttribSettings(value);
                    }
                });
            }
            if (value == "TEXT") {
                appendFontAttributes(element, value);
                showOrHideAttribSettings(value);
            } else {
                if (value.indexOf("STROKESTYLE") > -1 || value == "MITRAL" || value == "AORTIC") {
                    appendLineAttributes(element, key, value);
                }
                if (!isEmptyLegend(value) || value == "MSTROKESTYLE" || value == "ERSTROKESTYLE" || value == "MA") {
                    appendAnnotationAttributes(element, key, value);
                }
                $("#prefHref").height(document.getElementById(id).style.height);
            }
        });

        if (isShow) {
            showMeasurementStyle(true);
        }
    }

    /**
     * Append font attributes controls for Text and Label measurement type
     * @param {Type} element 
     * @param {Type} type 
     */
    function appendFontAttributes(element, type) {
        var parent = document.getElementById(type + "fieldSet");
        var child = document.getElementById(type + "fontAttribT");
        if (child == undefined || child == null) {
            child = document.createElement("div");
            child.setAttribute('id', type + "fontAttribT");
            child.innerHTML = getFontAttributes(type);
            setChildToParent(parent, child, "0px");
            child.style.marginTop = "-10px";
        }
    }

    /**
     * Append line attributes controls for all measurement types
     * @param {Type} element 
     * @param {Type} key 
     * @param {Type} type 
     */
    function appendLineAttributes(element, key, type) {
        var child = document.getElementById(type + "lineAttribT");
        var parent = document.getElementById(type + "fieldSet");
        if (child == undefined || child == null) {
            child = document.createElement("div");
            child.setAttribute('id', type + "lineAttribT");
            child.innerHTML = getStrokeLineAttributes(type);
            setChildToParent(parent, child, "0px");
            child.style.marginTop = "-20px";
        }
    }

    /**
     * returns the current series modality
     */
    function currentModality() {
        var series = dicomViewer.Series.getSeries(dicomViewer.getActiveSeriesLayout().studyUid, dicomViewer.getActiveSeriesLayout().seriesIndex);
        return series.modality;
    }

    /**
     * Append annotation attributes for selected element and measurement type
     * @param {Type} element 
     * @param {Type} key 
     * @param {Type} type 
     */
    function appendAnnotationAttributes(element, key, type) {
        var child = document.getElementById(type + "annotAttribT");
        var parent = document.getElementById(type + "fieldSet");
        var innerHTML = "";
        var modality = currentModality();
        if (child == undefined || child == null) {
            child = document.createElement("div");
            child.setAttribute('id', type + "annotAttribT");
            $("#" + parent.id).show();
            var marginTop = "-20px";
            if (type == "LINE" || type == "LENGTH") {
                innerHTML = getGaugeLengthAttributes(type);
                //marginTop = "0px";
            } else if (type == "ARROW") {
                innerHTML = getFillAttributes(type);
            } else if (type == "ANGLE") {
                innerHTML = getAngleAttributes(type);
            } else if (type == "MSTROKESTYLE") {
                innerHTML = getMeasurementAttributes(type);
                marginTop = "0px";
            } else if (type == "ERSTROKESTYLE") {
                innerHTML = getFillAttributes(type);
                marginTop = "0px";
            } else if (type == "ANNOTATION") {
                innerHTML = getFillAttributes(type);
                //marginTop = "0px";
            } else if (type == "HOUNSFIELD") {
                if (modality != "CT") {
                    $("#" + parent.id).hide();
                } else {
                    innerHTML = getMeasurementAttributes(type);
                }
            } else if (type == "MA") {
                if (modality != "US") {
                    $("#" + parent.id).hide();
                } else {
                    innerHTML = getMAAttributes(type);
                }
            } else {
                child = null;
                return;
            }

            child.innerHTML = innerHTML;
            setChildToParent(parent, child, "0px");
            child.style.marginTop = marginTop;
        }
    }

    /**
     * Create font attributes controls
     * @param {Type} type 
     */
    function getFontAttributes(type) {
        var display = "block";
        if (type == "LBLOVERLAY" || type == "LBLORIENTATION") {
            display = "none";
        }

        return '<form role="form" class="form-horizontal"><div class="form-group" style="margin-top: 14px;"><div class="col-sm-2"> <label for="fontName" style="margin-top: 10px; width: 100px;">Font Name</label></div><div class="col-sm-4"> <select id="' + type + 'fontName" class="form-control prefBtn" style="min-width:40px"><option value="Arial">Arial</option><option value="Arial Black">Arial Black</option><option value="Book Antiqua">Book Antiqua</option><option value="Calibri">Calibri</option><option value="Comic Sans MS">Comic Sans MS</option><option value="Courier">Courier</option><option value="Cursive">Cursive</option><option value="Fantasy">Fantasy </option><option value="Georgia">Georgia</option><option value="Garamond">Garamond</option><option value="Helvetica">Helvetica</option><option value="Impact">Impact </option><option value="Lucida Sans Unicode">Lucida Sans Unicode </option><option value="Lucida Console">Lucida Console </option><option value="Monospace">Monospace</option><option value="Palatino Linotype">Palatino Linotype</option><option value="sans-serif">Sans-serif</option><option value="Times New Roman">Times New Roman</option><option value="Tahoma">Tahoma </option><option value="Verdana">Verdana </option></select></div><div class="col-sm-2"> <label for="fontSize" style="margin-top: 10px;">Font Size</label></div><div class="col-sm-4" style="min-width:40px;margin-left:-10px" > <select id="' + type + 'fontSize" class="form-control prefBtn"> <option value="6">5</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="10">10</option><option value="11">11</option><option value="12">12</option><option value="13">13</option><option value="14">14</option><option value="16">16</option><option value="18">18</option><option value="20">20</option><option value="22">22</option><option value="24">24</option><option value="26">26</option><option value="28">28</option></select></div></div><div class="form-group"><div class="col-sm-2"> <label for="bold" style="margin-top: 10px; width: 100px;">Bold</label></div><div class="col-sm-2"> <input id="' + type + 'isBold" type="checkbox" class="form-control prefBtn"></div><div class="col-sm-2"> <label for="italic" style="margin-top: 10px; width: 100px;">Italic</label></div><div class="col-sm-2"> <input id="' + type + 'isItalic" type="checkbox" class="form-control prefBtn"></div></div><div style="display:' + display + '" class="form-group"><div class="col-sm-2"> <label for="underline" style="margin-top: 10px; width: 100px;">Underline</label></div><div class="col-sm-2"> <input id="' + type + 'isUnderlined" type="checkbox" class="form-control prefBtn"></div> <div class="col-sm-2"> <label for="strikeout" style="margin-top: 10px; width: 100px;">Strikeout</label></div><div class="col-sm-2"> <input id="' + type + 'isStrikeout" type="checkbox" class="form-control prefBtn"></div></div><div class="form-group"  id="' + type + 'fontFillT" style="display:none"><div class="col-sm-2"> <label for="fill" style="margin-top: 10px; width: 100px;">Fill</label></div><div class="col-sm-2"> <input id="' + type + 'isFill" type="checkbox" class="form-control prefBtn"></div><div class="col-sm-2"> <label for="fillColor" style="margin-top: 10px; width: 100px;">Fill Color</label></div><div class="col-sm-3"> <input type="color" id="' + type + 'fillColor"  value="#00FFFF"></div></div><div class="form-group"> <div class="col-sm-2"> <label id="' + type + 'lblFontColor" for="fontColor" style="margin-top: 10px;">Font Color</label></div><div class="col-sm-3" id="' + type + 'selFontColor"> <input type="color" id="' + type + 'fontColor" value="#00FFFF"></div></div></form>';
    }

    /**
     * Create line attributes controls for stroke and fill styles
     * @param {Type} type 
     */
    function getStrokeLineAttributes(type) {
        return '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="lineWidth" style="margin-top: 10px;">Line Width</label></div><div class="col-sm-3"> <select id="' + type + 'lineWidth" class="form-control prefBtn" style="min-width:40px"><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="10">10</option><option value="11">11</option><option value="12">12</option><option value="13">13</option><option value="14">14</option></select></div><div class="col-sm-2"> <label for="color" style="margin-top: 10px;">Color</label></div><div class="col-sm-3"> <input type="color" value="#00FFFF" id="' + type + 'lineColor" class="form-control"></div></div></form>';
    }

    /**
     * Create fill attributes controls
     * @param {Type} type 
     */
    function getFillAttributes(type) {
        return '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="lineWidth" style="margin-top: 10px;">Fill Color</label></div><div class="col-sm-3"> <input id="' + type + 'fillColor" type="color"  value="#00FFFF" class="form-control"></div><div class="col-sm-2"> <label for="fill" style="margin-top: 10px;">Fill</label></div><div class="col-sm-2"> <input id="' + type + 'isFill" type="checkbox" class="form-control"></div></div></form>';
    }

    /**
     * Create gauge length attribute controls
     * @param {Type} type 
     */
    function getGaugeLengthAttributes(type) {
        return '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="gaugeStyle" style="margin-top: 10px;">Gauge Style</label></div><div class="col-sm-3"> <select id="' + type + 'gaugeStyle"  class="form-control prefBtn" style="min-width:40px"><option value="Line">Line</option><option value="Point">Point</option></select></div><div class="col-sm-2"> <label for="gaugeLength" style="margin-top: 10px;">Gauge Length</label></div><div class="col-sm-3"> <input id="' + type + 'gaugeLen" min="0" max="20" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class="form-control prefBtn spinner" style="min-width:40px"></div></div></form>';
    }

    /**
     * Create controls for measurement attributes
     * @param {Type} type 
     */
    function getMeasurementAttributes(type) {
        return '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="precision" style="margin-top: 10px;">Precision</label></div><div class="col-sm-3"> <input id="' + type + 'precision" min="0" max="14" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class="form-control prefBtn spinner" style="min-width:40px"></div><div class="col-sm-2"> <label for="measurementUnits" style="margin-top: 10px;">Measurement Units</label></div><div class="col-sm-3"> <select id="' + type + 'measureUnits"  class="form-control prefBtn spinner" style="min-width:40px"><option value="in">Inches</option><option value="cm">Centimeter</option><option value="mm">Millimeter</option></select></div></div></form>';
    }

    /**
     * Create controls for mitral and aortic attributes
     * @param {Type} type 
     */
    function getMAAttributes(type) {
        return '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="precision" style="margin-top: 10px;">Precision</label></div><div class="col-sm-3"> <input id="' + type + 'precision" min="0" max="14" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class="form-control prefBtn spinner" style="min-width:40px"></div><div class="col-sm-2"> <label for="measurementUnits" style="margin-top: 10px;">Measurement Units</label></div><div class="col-sm-3" style="min-width:40px"> <select id="' + type + 'measureUnits"  class="form-control prefBtn"><option value="in">Inches</option><option value="cm">Centimeter</option><option value="mm">Millimeter</option></select></div></div><div class="form-group"><div class="col-sm-2"> <label for="gaugeStyle" style="margin-top: 10px;">Gauge Style</label></div><div class="col-sm-3"> <select id="' + type + 'gaugeStyle"  class="form-control prefBtn" style="min-width:40px"><option value="Line">Line</option><option value="Point">Point</option></select></div><div class="col-sm-2"> <label for="gaugeLength" style="margin-top: 10px;">Gauge Length</label></div><div class="col-sm-3"> <input id="' + type + 'gaugeLen" min="0" max="20" class="form-control prefBtn spinner" onkeypress="return event.charCode >= 48 && event.charCode <= 57" style="min-width:40px"></div></div></div></form>';
    }

    /**
     * Create controls for angle attributes
     * @param {Type} type 
     */
    function getAngleAttributes(type) {
        return '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="arcRadius" style="margin-top: 10px; width: 100px;">Arc Radius</label></div><div class="col-sm-3"> <input id="' + type + 'arcRadius" min="5" max="20" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class="form-control prefBtn spinner style="min-width:40px""></div></div></form>';
    }

    /**
     * Get div element id for selected measurement type
     * @param {Type} type 
     */
    function getDivId(type) {
        switch (type) {

            case "ASTROKESTYLE":
            case "LINE":
            case "ARROW":
                return "aDiv";

            case "MSTROKESTYLE":
            case "LENGTH":
            case "ANGLE":
                return "mDiv";

            case "ERSTROKESTYLE":
            case "ANNOTATION":
            case "HOUNSFIELD":
                return "hDiv";

            case "LABEL":
                return "labelDiv";

            case "TEXT":
                return "textDiv";

            case "MA":
            case "MITRAL":
            case "AORTIC":
                return "miDiv";

            default:
                return null;
        }
    }

    /**
     * Show or Hide fill attributes controls for Text and Label
     * @param {Type} type 
     */
    function showOrHideAttribSettings(type) {
        switch (type) {
            case "LABEL":
                $("#" + type + "fontFillT").hide();
                break;

            case "TEXT":
                $("#" + type + "fontFillT").show();
                break;

            default:
                break;
        }
    }

    /**
     * Set color spectrum to line, text and fill options
     * @param {Type} lineColor 
     * @param {Type} textColor 
     * @param {Type} fillColor 
     */
    function setColorSpectrum(lineColor, textColor, fillColor) {
        setPrefColorSpectrum("#lineColor", lineColor, true);
        setPrefColorSpectrum("#fontColor", textColor, true);
        setPrefColorSpectrum("input[name*='fillColor']", fillColor, true);
    }

    /**
     * Check whether the updating measurement is of type Text
     * @param {Type}  
     */
    function isMeasurementText() {
        return $("#fontFillT")[0].style.display == "block"
    }

    /**
     * Create dynamic annotation attributes to global measurement preference dialog
     * @param {Type} measurementType
     */
    function createAnnotationAttribSettings(measureType) {
        switch (measureType) {
            case "GLOBAL":
                showOrHideAllAnnotationAttributes(true);
                break;

            case "PEN":
                setNoAttributesMsg();
                break;

            case "POINT":
            case "ASPV":
            case "ARPV":
            case "MRPV":
                showOrHideFontColor(true);
                setNoAttributesMsg();
                break;

            case "TEXT":
                showOrHideFontColor(true);
                $("#fontFillT").show();
                showOrHideFill(true);
                break;

            case "LENGTH":
            case "LINE":
            case "ARROW":
            case "ARL":
            case "MRL":
            case "MVALT":
                measureType = measureType == "LINE" ? "2DLine" : measureType;
                measureType = measureType == "ARROW" ? "Arrow" : measureType;
                showOrHideLineAttrib(measureType);
                break;

            case "ANGLE":
                $("#arcRadius")[0].disabled = "";
                showOrHidePrecision(true);
                showOrHideFontColor(true);
                break;

            case "ELLISPE":
            case "HOUNSFIELDELLIPSE":
            case "RECT":
            case "HOUNSFIELDRECT":
            case "FREEHAND":
                showOrHideFill(true);
                if (measureType == "HOUNSFIELDELLIPSE" || measureType == "HOUNSFIELDRECT") {
                    showOrHidePrecision(true);
                    showOrHideMeasureUnits(true);
                    showOrHideFontColor(true);
                } else {
                    showOrHidePrecision(false);
                    showOrHideMeasureUnits(false);
                    showOrHideFontColor(false);
                }
                break;

            case "TRACE":
            case "MG":
                showOrHideFontColor(true);
                showOrHideFill(true);
                break;

            default:
                return;
        }
    }

    /**
     * Set attributes not applicable message
     * @param {Type}  
     */
    function setNoAttributesMsg() {
        var fieldsetAttrib = $("#fieldsetAttrib")[0];
        removeAnnotationPreferenceSettings(fieldsetAttrib);

        // Append no attributes message
        var parent = $("#fieldsetAttrib")[0];
        var child = $("#noAttribT")[0];
        var margin = "50px";
        setChildToParent(parent, child, margin);
    }

    /**
     * Remove dynamic attributes from global measurement preference dialog
     * @param {Type} 
     */
    function removeAnnotationPreferenceSettings(parent, isAppend) {
        var dicomViewer = $("#dicomViewer")[0];
        $.each(parent.childNodes, function (key, value) {
            if (value.tagName === "DIV") {
                value.style.display = "none";
                if (isAppend !== false) {
                    dicomViewer.appendChild(value);
                }
            }
        });
    }

    /**
     * Set parent to child.
     */
    function setChildToParent(parent, child, margin) {
        parent.appendChild(child);
        child.style.margin = margin;
        child.style.display = "block";
    }

    /**
     * Add annotation attributes to annotation preference dialog
     * @param {Type} measurement
     */
    function addAnnotationAttributes(measurement) {

        showOrHideAllAnnotationAttributes();

        document.getElementById("fontAttributesLegend").innerHTML = "Font Attributes";
        $("#fontAttributesLegend").width(85);
        $("#annotAttributesbr").show();
        $("#fontAttributes").height(160);

        // Line Annotation Attributes
        if (measurement.measureType == "line") {
            if (measurement.measurementSubType == "2DLine" ||
                measurement.measurementSubType == "Arrow") {
                showOrHideLineAttrib(measurement.measurementSubType);
            } else {
                showOrHideLineAttrib(measurement.measureType);
            }
            return;
        }

        // Angle Annotation Attributes
        if (measurement.measureType == "angle") {
            $("#arcRadius")[0].disabled = "";
            showOrHidePrecision(true);
            showOrHideFontColor(true);
            return;
        }

        // Rectangle, Ellispe and Freehand Annotation Attributes
        if (measurement.measureType == "rectangle" || measurement.measureType == "ellipse" ||
            measurement.measurementSubType == "freehand") {
            showOrHideFill(true);
            // Text Annotation Attributes
            if (measurement.measurementSubType == "text") {
                document.getElementById("fontAttributesLegend").innerHTML = "Annotation Attributes";
                $("#fontAttributesLegend").width(120);
                $("#fontAttributes").height(190);
                $("#annotAttributesbr").hide();
                $("#fontFillT").show();
                showOrHideFontColor(true);
            } else {
                if (measurement.measurementSubType == "hounsfield") {
                    showOrHidePrecision(true);
                    showOrHideMeasureUnits(true);
                    showOrHideFontColor(true);
                } else {
                    showOrHidePrecision(false);
                    showOrHideMeasureUnits(false);
                    showOrHideFontColor(false);
                }
            }
            return;
        }

        if (measurement.measureType == "point") {
            showOrHideFontColor(true);
            return;
        }

        // Mitral and Trace Annotation Attributes
        if (measurement.measureType == "trace" || measurement.measureType == "mitralGradient") {
            showOrHideFill(true);
            showOrHideFontColor(true);
        }
    }

    /**
     * Show or Hide all Annotation Attributes
     * @param {Type}  isShow
     */
    function showOrHideAllAnnotationAttributes(isShow) {
        if (isShow) {
            showOrHideFontColor(true);
            showOrHideFill(true);
            showOrHidePrecision(true);
            showOrHideGaugeLength(true);
            showOrHideMeasureUnits(true);

            $("#arcRadius")[0].disabled = "";
            $("#fontFillT").show();
        } else {
            showOrHideFontColor(false);
            showOrHideFill(false);
            showOrHidePrecision(false);
            showOrHideGaugeLength(false);
            showOrHideMeasureUnits(false);

            $("#arcRadius")[0].disabled = "disabled";
            $("#fontFillT").hide();
        }
    }

    /**
     * Show or Hide font color selection
     * @param {Type}  isShow
     */
    function showOrHideFontColor(isShow) {
        if (isShow) {
            $("#lblFontColor").show();
            $("#selFontColor").show();
        } else {
            $("#lblFontColor").hide();
            $("#selFontColor").hide();
        }
    }

    /**
     * Show or Hide fill selection
     * @param {Type}  isShow
     */
    function showOrHideFill(isShow) {
        if (isShow) {
            $("input[name*='isFill']")[0].disabled = "";
            $("input[name*='isFill']")[1].disabled = "";
            $("input[name*='fillColor']")[0].disabled = "";
            $("input[name*='fillColor']")[1].disabled = "";
        } else {
            $("input[name*='isFill']")[0].disabled = "disabled";
            $("input[name*='isFill']")[1].disabled = "disabled";
            $("input[name*='fillColor']")[0].disabled = "disabled";
            $("input[name*='fillColor']")[1].disabled = "disabled";
        }
    }

    /**
     * Show or Hide Line Attributes
     * @param {Type} type 
     */
    function showOrHideLineAttrib(type) {
        if (type == "2DLine" || type == "Arrow") {
            showOrHideGaugeLength(false);
            showOrHidePrecision(false);
            showOrHideMeasureUnits(false);
            showOrHideFontColor(false);

            if (type == "Arrow") {
                showOrHideFill(true);
            } else if (type != "2DLine") {
                showOrHideGaugeLength(true);
            }
        } else {
            showOrHideGaugeLength(true);
            showOrHidePrecision(true);
            showOrHideMeasureUnits(true);
            showOrHideFontColor(true);
        }
    }

    /**
     * Show or Hide Gauge length
     * @param {Type}  isShow
     */
    function showOrHideGaugeLength(isShow) {
        if (isShow) {
            $("#gaugeLen")[0].disabled = "";
            $("#gaugeStyle")[0].disabled = "";
        } else {
            $("#gaugeLen")[0].disabled = "disabled";
            $("#gaugeStyle")[0].disabled = "disabled";
        }
    }

    /**
     * Show or Hide Precision
     * @param {Type}  isShow
     */
    function showOrHidePrecision(isShow) {
        if (isShow) {
            $("#precision")[0].disabled = "";
        } else {
            $("#precision")[0].disabled = "disabled";
        }
    }

    /**
     * Show or Hide Measurement Units
     * @param {Type}  isShow
     */
    function showOrHideMeasureUnits(isShow) {
        if (isShow) {
            $("#measureUnits")[0].disabled = "";
        } else {
            $("#measureUnits")[0].disabled = "disabled";
        }
    }

    /**
     * Append tabs for each measurement categories
     * @param {Type} parent 
     */
    function createAnnotationPrefTabs() {
        removeAnnotationPreferenceSettings($("#annotationPreferenceTable")[0]);

        var element = document.getElementById("prefRow");
        if (element == undefined || element == null) {
            element = document.createElement("div");
            element.setAttribute('id', "prefRow");
            element.setAttribute('class', "row");

            var prefCont = createDynamicPrefContainer("prefContainer");
            prefCont.appendChild(createDynamicPrefList("prefUl"));
            element.appendChild(prefCont);
        }
        element.style.display = "block";
        var parent = $("#annotationPreferenceTable");
        parent[0].appendChild(element);
    }

    /**
     * Create settings for unique measurement preference
     * @param {Type} measureData
     */
    function createUniqueMeasurementPref() {
        var parent,
            child = null;
        var margin = "-20px -10px";

        //Unique line attributes
        parent = $("#lineAttributes")[0];
        child = $("#lineAttribT")[0];
        setChildToParent(parent, child, margin);

        //Unique font attributes
        parent = $("#fontAttributes")[0];
        child = $("#fontAttribT")[0];
        setChildToParent(parent, child, margin);

        //Unique annotation attributes
        parent = $("#annotAttributes")[0];
        child = $("#annotAttribT")[0];
        setChildToParent(parent, child, margin);
    }

    /**
     * Show or hide font attributes
     * @param {Type} measureData
     */
    function showOrHideAnnotationAttributes(measureData) {

        if (measureData.measurementSubType == "pen") {
            $("#fontAttributes").hide();
            $("#fontAttributesbr").hide();
            $("#annotAttributes").hide();
            $("#annotAttributesbr").hide();
            $("#MeasurementPropertiesModal").height(60);
            return;
        }
        if (measureData.measurementSubType == "2DLine" ||
            measureData.measurementSubType == "Arrow" ||
            measureData.measurementSubType == "rectangle" ||
            measureData.measurementSubType == "ellipse" ||
            measureData.measurementSubType == "freehand") {
            $("#fontAttributes").hide();
            $("#fontAttributesbr").hide();

            $("#annotAttributes").show();
            $("#MeasurementPropertiesModal").height(250);
        } else {
            $("#fontAttributes").show();
            $("#fontAttributesbr").show();

            if (measureData.measurementSubType == "text" || measureData.measureType == "point") {
                $("#annotAttributes").hide();
                $("#MeasurementPropertiesModal").height(260);
            } else {
                $("#annotAttributes").show();
                $("#MeasurementPropertiesModal").height(420);
            }
        }

        addAnnotationAttributes(measureData);
    }

    /**
     * Set the global or unique measurement style for selected measurement type
     * @param {Type}  isGlobal
     * @param {Type}  uniqueMeasurementStyle
     * @param {Type}  isCustomEllipse
     */
    function showMeasurementStyle(isGlobal, uniqueMeasurementStyle, isCustomEllipse) {

        if (isGlobal) {
            var modality = currentModality();
            if (isEmptyObject(tempMeasurementStyleCol)) {
                var uStyleCol = dicomViewer.measurement.draw.getUserMeasurementCol();
                var measurementStyleCol = JSON.parse(JSON.stringify(uStyleCol));
                getStyleFromCol(measurementStyleCol);

                $.each(MT_TypeCol, function (key, value) {
                    $.each(MT_EX_TypeCol[value], function (key, value) {
                        var type = value;
                        var disabled = false;
                        if (value == "LABEL") {
                            $.each(MT_Lbl_Col, function (key, value_) {
                                type = value_;
                                disabled = false;
                                setPrefValues(value_, type, disabled, modality);
                            });
                        } else {
                            if ((value == "MA" || value == "MITRAL" || value == "AORTIC") && modality != "US") {
                                return;
                            }
                            setPrefValues(value, type, disabled, modality);
                        }
                    });
                });
            }
        } else {
            var measurementStyle = null;
            measurementStyle = uniqueMeasurementStyle;

            if (isCustomEllipse != undefined) {
                $("input[name*='isFill']")[1].disabled = isCustomEllipse ? "disabled" : "";
                $("input[name*='fillColor']")[1].disabled = isCustomEllipse ? "disabled" : "";
            }

            if (measurementStyle !== undefined && measurementStyle !== null) {
                setColorSpectrum(measurementStyle.lineColor, measurementStyle.textColor, measurementStyle.fillColor);

                $("#lineWidth")[0].value = measurementStyle.lineWidth;
                $("#fontName")[0].value = measurementStyle.fontName;
                $("#fontSize")[0].value = measurementStyle.fontSize;
                $("#isBold")[0].checked = measurementStyle.isBold;
                $("#isItalic")[0].checked = measurementStyle.isItalic;
                $("#isUnderlined")[0].checked = measurementStyle.isUnderlined;
                $("#isStrikeout")[0].checked = measurementStyle.isStrikeout;
                $("input[name*='isFill']")[0].checked = measurementStyle.isFill;
                $("input[name*='isFill']")[1].checked = measurementStyle.isFill;
                $("#gaugeLen")[0].value = measurementStyle.gaugeLength;
                $("#gaugeStyle")[0].value = measurementStyle.gaugeStyle;
                $("#precision")[0].value = measurementStyle.precision;
                $("#measureUnits")[0].value = measurementStyle.measurementUnits;
                $("#arcRadius")[0].value = measurementStyle.arcRadius;
            }
        }
    }

    function setPrefValues(value, type, disabled, modality) {
        $("#" + value + "chk")[0].checked = tempMeasurementStyleCol[type].useDefault;
        if (tempMeasurementStyleCol[value].useDefault) {
            type = "sys" + type;
            disabled = "disabled";
        }
        if (value == "LBLSCOUT" || value == "LBLRULER") {
            $("#" + value + "lineWidth")[0].disabled = disabled;
            $("#" + value + "lineColor")[0].disabled = disabled;
            $("#" + value + "lineWidth")[0].value = tempMeasurementStyleCol[type].lineWidth;
            setPrefColorSpectrum("#" + value + "lineColor", tempMeasurementStyleCol[type].lineColor);
        } else if (value == "TEXT" || value.indexOf("LBL") > -1) {
            $("#" + value + "fontColor")[0].disabled = disabled;
            $("#" + value + "fontName")[0].disabled = disabled;
            $("#" + value + "fontSize")[0].disabled = disabled;
            $("#" + value + "isBold")[0].disabled = disabled;
            $("#" + value + "isItalic")[0].disabled = disabled;
            $("#" + value + "isUnderlined")[0].disabled = disabled;
            $("#" + value + "isStrikeout")[0].disabled = disabled;
            $("#" + value + "isFill")[0].disabled = disabled;

            setPrefColorSpectrum("#" + value + "fontColor", tempMeasurementStyleCol[type].textColor);
            $("#" + value + "fontName")[0].value = tempMeasurementStyleCol[type].fontName;
            $("#" + value + "fontSize")[0].value = tempMeasurementStyleCol[type].fontSize;
            $("#" + value + "isBold")[0].checked = tempMeasurementStyleCol[type].isBold;
            $("#" + value + "isItalic")[0].checked = tempMeasurementStyleCol[type].isItalic;
            $("#" + value + "isUnderlined")[0].checked = tempMeasurementStyleCol[type].isUnderlined;
            $("#" + value + "isStrikeout")[0].checked = tempMeasurementStyleCol[type].isStrikeout;
            $("#" + value + "isFill")[0].checked = tempMeasurementStyleCol[type].isFill;
        }

        if (value.indexOf("STROKESTYLE") > -1 || value == "MITRAL" || value == "AORTIC") {
            $("#" + value + "lineWidth")[0].disabled = disabled;
            $("#" + value + "lineColor")[0].disabled = disabled;
            $("#" + value + "lineWidth")[0].value = tempMeasurementStyleCol[type].lineWidth;
            setPrefColorSpectrum("#" + value + "lineColor", tempMeasurementStyleCol[type].lineColor);
        }
        if (value == "LINE" || value == "LENGTH" || value == "MA") {
            $("#" + value + "gaugeLen")[0].disabled = disabled;
            $("#" + value + "gaugeStyle")[0].disabled = disabled;
            enableOrDisableSpinner(("#" + value + "gaugeLen"), (disabled == "disabled") ? "disable" : "enable");
            $("#" + value + "gaugeLen")[0].value = tempMeasurementStyleCol[type].gaugeLength;
            $("#" + value + "gaugeStyle")[0].value = tempMeasurementStyleCol[type].gaugeStyle;
        }
        if (value == "ARROW" || value == "ERSTROKESTYLE" || value == "TEXT") {
            $("#" + value + "isFill")[0].disabled = disabled;
            $("#" + value + "fillColor")[0].disabled = disabled;
            $("#" + value + "isFill")[0].checked = tempMeasurementStyleCol[type].isFill;
            setPrefColorSpectrum("#" + value + "fillColor", tempMeasurementStyleCol[type].fillColor);
        }
        if (value == "ANGLE") {
            $("#" + value + "arcRadius")[0].disabled = disabled;
            $("#" + value + "arcRadius")[0].value = tempMeasurementStyleCol[type].arcRadius;
            enableOrDisableSpinner(("#" + value + "arcRadius"), (disabled == "disabled") ? "disable" : "enable");
        }
        if (value == "MSTROKESTYLE" || (value == "HOUNSFIELD" && modality == "CT") || value == "MA") {
            $("#" + value + "precision")[0].disabled = disabled;
            enableOrDisableSpinner(("#" + value + "precision"), (disabled == "disabled") ? "disable" : "enable");
            $("#" + value + "measureUnits")[0].disabled = disabled;
            $("#" + value + "precision")[0].value = tempMeasurementStyleCol[type].precision;
            $("#" + value + "measureUnits")[0].value = tempMeasurementStyleCol[type].measurementUnits;
        }
    }

    function enableOrDisableSpinner(id, disabled) {
        var spinner = $(id).spinner();
        spinner.spinner(disabled);
    }

    /**
     * Convert measurement collection to design view structure
     * @param {Type} measurementStyleCol 
     */
    function getStyleFromCol(measurementStyleCol) {
        $.each(MT_TypeCol, function (key, value) {
            $.each(MT_EX_TypeCol[value], function (key, value) {
                if (value == "LABEL") {
                    $.each(MT_Lbl_Col, function (key, value_) {
                        setMeasurementStyle(measurementStyleCol, value, value_);
                    });
                } else {
                    setMeasurementStyle(measurementStyleCol, value);
                }
            });
        });
    }

    /**
     * Set measurement style to controls for given measurement type
     * @param {Type} measurementStyleCol 
     * @param {Type} value 
     */
    function setMeasurementStyle(measurementStyleCol, value, subType) {
        var type = value;
        var useDefault = false;
        if (measurementStyleCol[value] == undefined) {
            if (value == "ASTROKESTYLE") {
                type = "LINE";
                useDefault = measurementStyleCol["PEN"].useDefault;
            } else if (value == "MSTROKESTYLE") {
                type = "LENGTH";
                useDefault = measurementStyleCol["POINT"].useDefault;
            } else if (value == "ERSTROKESTYLE") {
                type = "ELLIPSE";
                useDefault = measurementStyleCol["ELLIPSE"].useDefault;
            } else if (value == "HOUNSFIELD") {
                type = "HOUNSFIELDELLIPSE";
                useDefault = measurementStyleCol["HOUNSFIELDELLIPSE"].useDefault;
            } else if (value == "LABEL") {
                type = subType;
                useDefault = measurementStyleCol[subType].useDefault;
            } else if (value == "MA") {
                type = "MRL";
                useDefault = measurementStyleCol["MG"].useDefault;
            } else if (value == "MITRAL") {
                type = "MRL";
                useDefault = measurementStyleCol["MRL"].useDefault;
            } else if (value == "AORTIC") {
                type = "ARL";
                useDefault = measurementStyleCol["ARL"].useDefault;
            } else {
                type = "LINE";
            }
        } else {
            useDefault = measurementStyleCol[type].useDefault;
        }

        if (value == "LABEL") {
            value = subType;
        }

        tempMeasurementStyleCol[value] = getStyleData(measurementStyleCol, type, useDefault);

        value = "sys" + value;
        type = "sys" + type;

        tempMeasurementStyleCol[value] = getStyleData(measurementStyleCol, type, useDefault);
    }

    /**
     * Get measurement style data for given type
     * @param {Type} measurementStyleCol 
     * @param {Type} type 
     */
    function getStyleData(measurementStyleCol, type, useDefault) {
        return {
            useDefault: useDefault,
            lineWidth: measurementStyleCol[type].styleCol.lineWidth,
            lineColor: measurementStyleCol[type].styleCol.lineColor,
            gaugeLength: measurementStyleCol[type].styleCol.gaugeLength,
            gaugeStyle: measurementStyleCol[type].styleCol.gaugeStyle,
            isFill: measurementStyleCol[type].styleCol.isFill,
            fillColor: measurementStyleCol[type].styleCol.fillColor,
            arcRadius: measurementStyleCol[type].styleCol.arcRadius,
            textColor: measurementStyleCol[type].styleCol.textColor,
            fontName: measurementStyleCol[type].styleCol.fontName,
            fontSize: measurementStyleCol[type].styleCol.fontSize,
            isBold: measurementStyleCol[type].styleCol.isBold,
            isItalic: measurementStyleCol[type].styleCol.isItalic,
            isUnderlined: measurementStyleCol[type].styleCol.isUnderlined,
            isStrikeout: measurementStyleCol[type].styleCol.isStrikeout,
            precision: measurementStyleCol[type].styleCol.precision,
            measurementUnits: measurementStyleCol[type].styleCol.measurementUnits
        };
    }

    /**
     * Convert design view structure to measurement collection
     * @param {Type}  
     */
    function getColFromStyle() {
        var measurementStyleCol = {};
        $.each(MT_PS_TypeCol, function (key, value) {
            var styleCol = {
                lineWidth: getMeasurementStyle("lineWidth", value),
                lineColor: getMeasurementStyle("lineColor", value),
                gaugeLength: getMeasurementStyle("gaugeLength", value),
                gaugeStyle: getMeasurementStyle("gaugeStyle", value),
                isFill: getMeasurementStyle("isFill", value),
                fillColor: getMeasurementStyle("fillColor", value),
                arcRadius: getMeasurementStyle("arcRadius", value),
                textColor: getMeasurementStyle("textColor", value),
                fontName: getMeasurementStyle("fontName", value),
                fontSize: getMeasurementStyle("fontSize", value),
                isBold: getMeasurementStyle("isBold", value),
                isItalic: getMeasurementStyle("isItalic", value),
                isUnderlined: getMeasurementStyle("isUnderlined", value),
                isStrikeout: getMeasurementStyle("isStrikeout", value),
                precision: getMeasurementStyle("precision", value),
                measurementUnits: getMeasurementStyle("measurementUnits", value)
            }

            measurementStyleCol[value] = {
                useDefault: getMeasurementStyle("useDefault", value),
                styleCol: styleCol
            };
        });
        return measurementStyleCol;
    }

    /**
     * Get measurement style from controls for given measurement type
     * @param {Type} style 
     * @param {Type} type 
     */
    function getMeasurementStyle(style, type) {
        var key = getEnumMT(type);
        switch (style) {
            case "useDefault":
                if (type == "PEN" || type == "FREEHAND") {
                    type = "ASTROKESTYLE";
                } else if (type == "POINT") {
                    type = "MSTROKESTYLE";
                } else if (key == "Ellipse") {
                    type = "ERSTROKESTYLE";
                } else if (type == "MG") {
                    type = "MA";
                } else if (type == "LINE") {

                } else if (type == "ARROW") {

                } else if (type == "LENGTH") {

                } else if (type == "ANGLE") {

                } else if (key == "hEllipse") {
                    type = "HOUNSFIELD";
                } else if (type == "TEXT") {

                } else if (key == "Mitral") {
                    type = "MITRAL";
                } else if (key == "Aortic") {
                    type = "AORTIC";
                } else if (tempMeasurementStyleCol[type] == undefined) {
                    return false;
                }
                return tempMeasurementStyleCol[type].useDefault;
                break;
            case "lineWidth":
            case "lineColor":
            case "precision":
            case "measurementUnits":
                if (key == "Annotation") {
                    type = "ASTROKESTYLE";
                } else if (key == "Measurement") {
                    type = "MSTROKESTYLE";
                } else if (key == "Ellipse") {
                    type = "ERSTROKESTYLE";
                } else if (key == "hEllipse") {
                    type = "HOUNSFIELD";
                } else if (key == "Mitral") {
                    type = "MITRAL";
                } else if (key == "Aortic") {
                    type = "AORTIC";
                } else if (type.indexOf('LBL') > -1) {

                } else if (key != "GLOBAL") {
                    return null;
                }
                if (style == "lineWidth") {
                    if (key == "hEllipse") {
                        type = "ERSTROKESTYLE";
                    }
                    return tempMeasurementStyleCol[type].lineWidth;
                } else if (style == "lineColor") {
                    if (key == "hEllipse") {
                        type = "ERSTROKESTYLE";
                    }
                    return tempMeasurementStyleCol[type].lineColor;
                } else if (style == "precision") {
                    if (type == "MITRAL" || type == "AORTIC") {
                        type = "MA";
                    }
                    return tempMeasurementStyleCol[type].precision;
                } else if (style == "measurementUnits") {
                    if (type == "MITRAL" || type == "AORTIC") {
                        type = "MA";
                    }
                    return tempMeasurementStyleCol[type].measurementUnits;
                }
                break;
            case "gaugeStyle":
            case "gaugeLength":
                if (key == "Annotation") {
                    type = "LINE";
                } else if (key == "Measurement") {
                    type = "LENGTH";
                } else if (key == "Mitral" || key == "Aortic") {
                    type = "MA";
                } else if (key != "GLOBAL") {
                    return null;
                }
                if (style == "gaugeStyle") {
                    return tempMeasurementStyleCol[type].gaugeStyle;
                } else if (style == "gaugeLength") {
                    return tempMeasurementStyleCol[type].gaugeLength;
                }
                break;
            case "isFill":
            case "fillColor":
                if (type == "TEXT") {

                } else if (key == "Annotation") {
                    type = "ARROW";
                } else if (key == "Ellipse" || key == "hEllipse") {
                    type = "ERSTROKESTYLE";
                } else if (key != "GLOBAL") {
                    return null;
                }
                if (style == "isFill") {
                    return tempMeasurementStyleCol[type].isFill;
                }
                return tempMeasurementStyleCol[type].fillColor;
                break;
            case "arcRadius":
                if (type != "ANGLE" && type != "GLOBAL") {
                    return null;
                }
                return tempMeasurementStyleCol["ANGLE"].arcRadius;
                break;
            case "textColor":
            case "fontName":
            case "fontSize":
            case "isBold":
            case "isItalic":
            case "isUnderlined":
            case "isStrikeout":
                if (type.indexOf('LBL') > -1) {

                } else if (type != "TEXT" && type != "GLOBAL") {
                    type = "LBLANNOTATION";
                }
                if (style == "textColor") {
                    return tempMeasurementStyleCol[type].textColor;
                } else if (style == "fontName") {
                    return tempMeasurementStyleCol[type].fontName;
                } else if (style == "fontSize") {
                    return tempMeasurementStyleCol[type].fontSize;
                } else if (style == "isBold") {
                    return tempMeasurementStyleCol[type].isBold;
                } else if (style == "isItalic") {
                    return tempMeasurementStyleCol[type].isItalic;
                } else if (style == "isUnderlined") {
                    return tempMeasurementStyleCol[type].isUnderlined;
                } else if (style == "isStrikeout") {
                    return tempMeasurementStyleCol[type].isStrikeout;
                }
                break;
            default:
                return null;
        }
    }

    /**
     * Get measurement category for given measurement type
     * @param {Type} type 
     */
    function getEnumMT(type) {
        if (type == "GLOBAL") {
            return type;
        }

        if (type == "LINE" ||
            type == "ARROW" || type == "FREEHAND" || type == "PEN") {
            return "Annotation";
        } else if (type == "LENGTH" || type == "POINT" || type == "ANGLE" || type == "TRACE") {
            return "Measurement";
        } else if (type == "ELLIPSE" || type == "RECT") {
            return "Ellipse";
        } else if (type == "HOUNSFIELDELLIPSE" || type == "HOUNSFIELDRECT") {
            return "hEllipse";
        } else if (type == "MG" || type == "MRPV" || type == "MRL" || type == "MVALT") {
            return "Mitral";
        } else if (type == "ASPV" || type == "ARPV" || type == "ARL") {
            return "Aortic";
        } else if (type == "TEXT") {
            return type;
        }
    }

    /**
     * Set color spectrum value for given input id
     * @param {Type} id 
     * @param {Type} color 
     */
    function setPrefColorSpectrum(id, color, isUnique) {
        $(id).spectrum({
            color: color,
            showAlpha: true,
            showPaletteOnly: true,
            togglePaletteOnly: true,
            togglePaletteMoreText: 'more',
            togglePaletteLessText: 'less',
            palette: [
                    ["#000", "#444", "#666", "#999", "#ccc", "#eee", "#f3f3f3", "#fff"],
                    ["#f00", "#f90", "#ff0", "#0f0", "#0ff", "#00f", "#90f", "#f0f"],
                    ["#f4cccc", "#fce5cd", "#fff2cc", "#d9ead3", "#d0e0e3", "#cfe2f3", "#d9d2e9", "#ead1dc"],
                    ["#ea9999", "#f9cb9c", "#ffe599", "#b6d7a8", "#a2c4c9", "#9fc5e8", "#b4a7d6", "#d5a6bd"],
                    ["#e06666", "#f6b26b", "#ffd966", "#93c47d", "#76a5af", "#6fa8dc", "#8e7cc3", "#c27ba0"],
                    ["#c00", "#e69138", "#f1c232", "#6aa84f", "#45818e", "#3d85c6", "#674ea7", "#a64d79"],
                    ["#900", "#b45f06", "#bf9000", "#38761d", "#134f5c", "#0b5394", "#351c75", "#741b47"],
                    ["#600", "#783f04", "#7f6000", "#274e13", "#0c343d", "#073763", "#20124d", "#4c1130"]
                ]
        });
        setTimeout(function () {
            setColorSpectrumCss(isUnique);
        }, 0);
    }

    /**
     * Set css for color spectrum
     * @param {Type} parent 
     */
    function setColorSpectrumCss(isUnique) {
        var isIE = isInternetExplorer();
        if (isUnique) {
            $(".sp-replacer").css({
                margin: 0,
                overflow: 'hidden',
                padding: '1px 2px 1px 1px',
                display: 'inline-block',
                background: '#eee',
                color: '#333',
                width: 'auto'
            });
            $(".sp-disabled").css({
                cursor: 'not-allowed',
                borderColor: 'silver',
                color: 'silver',
                backgroundColor: 'grey',
            });
            $(".sp-preview").css({
                position: 'relative',
                width: '25px',
                height: '20px',
                border: 'solid 1px #222',
                marginRight: '5px',
                zIndex: '0',
            });

            $(".sp-dd").css({
                padding: '2px 0',
                height: '16px',
                lineHeight: '16px',
                fontSize: '10px',
                marginTop: '0px'
            });
        } else {
            $(".sp-replacer").css({
                margin: 0,
                overflow: 'hidden',
                padding: '1px 2px 1px 1px',
                display: 'inline-block',
                background: '#eee',
                color: '#333',
                width: (isIE ? '100%' : '-webkit-fill-available')
            });
            $(".sp-disabled").css({
                cursor: 'not-allowed',
                borderColor: 'silver',
                color: 'silver',
                backgroundColor: 'grey',
            });
            $(".sp-preview").css({
                position: 'relative',
                width: '25px',
                height: '25px',
                border: 'solid 1px #222',
                marginRight: '10px',
                zIndex: '0',
                width: (isIE ? '90%' : '-webkit-fill-available')
            });

            $(".sp-dd").css({
                padding: '2px 0',
                height: '16px',
                lineHeight: '16px',
                fontSize: '10px',
                marginTop: '-20px'
            });
        }
    }

    /**
     * Updates measurementment style property from controls
     * @param {Type}  
     */
    function updateMeasurementStyle(isGlobal, skipConvert) {
        if (isGlobal) {
            var modality = currentModality();
            $.each(MT_TypeCol, function (key, value) {
                $.each(MT_EX_TypeCol[value], function (key, value) {
                    if (value == "LABEL") {
                        $.each(MT_Lbl_Col, function (key, value_) {
                            getPrefValues(value_);
                        });
                    } else {
                        if ((value == "MA" || value == "MITRAL" || value == "AORTIC") && modality != "US") {
                            return;
                        }
                        getPrefValues(value);
                    }
                });
            });
            if (skipConvert) {
                return tempMeasurementStyleCol;
            }
            return getColFromStyle();
        } else {
            var measurementStyle = null;
            var index = 1;
            if (isMeasurementText()) {
                index = 0;
            }
            measurementStyle = {
                lineWidth: parseFloat($("#lineWidth")[0].value),
                lineColor: $("#lineColor").spectrum("get").toRgbString(),
                textColor: $("#fontColor").spectrum("get").toRgbString(),
                fillColor: $("div[class*='sp-preview-inner']")[index + 2].style.backgroundColor,
                fontName: $("#fontName")[0].value,
                fontSize: parseInt($("#fontSize")[0].value),
                isBold: $("#isBold")[0].checked,
                isItalic: $("#isItalic")[0].checked,
                isUnderlined: $("#isUnderlined")[0].checked,
                isStrikeout: $("#isStrikeout")[0].checked,
                isFill: $("input[name*='isFill']")[index].checked,
                gaugeLength: $("#gaugeLen")[0].value,
                gaugeStyle: $("#gaugeStyle")[0].value,
                precision: $("#precision")[0].value,
                measurementUnits: $("#measureUnits")[0].value,
                arcRadius: $("#arcRadius")[0].value
            };
            return measurementStyle;
        }
    }

    function getPrefValues(value) {
        tempMeasurementStyleCol[value].useDefault = $("#" + value + "chk")[0].checked;
        if (tempMeasurementStyleCol[value].useDefault) {
            return true;
        }

        if (value == "LBLSCOUT" || value == "LBLRULER") {
            tempMeasurementStyleCol[value].lineWidth = $("#" + value + "lineWidth")[0].value;
            tempMeasurementStyleCol[value].lineColor = $("#" + value + "lineColor").spectrum("get").toRgbString();
        } else if (value == "TEXT" || value.indexOf("LBL") > -1) {
            tempMeasurementStyleCol[value].textColor = $("#" + value + "fontColor").spectrum("get").toRgbString();
            tempMeasurementStyleCol[value].fontName = $("#" + value + "fontName")[0].value;
            tempMeasurementStyleCol[value].fontSize = $("#" + value + "fontSize")[0].value;
            tempMeasurementStyleCol[value].isBold = $("#" + value + "isBold")[0].checked;
            tempMeasurementStyleCol[value].isItalic = $("#" + value + "isItalic")[0].checked;
            tempMeasurementStyleCol[value].isUnderlined = $("#" + value + "isUnderlined")[0].checked;
            tempMeasurementStyleCol[value].isStrikeout = $("#" + value + "isStrikeout")[0].checked;
            tempMeasurementStyleCol[value].isFill = $("#" + value + "isFill")[0].checked;
        }

        if (value.indexOf("STROKESTYLE") > -1 || value == "MITRAL" || value == "AORTIC") {
            tempMeasurementStyleCol[value].lineWidth = $("#" + value + "lineWidth")[0].value;
            tempMeasurementStyleCol[value].lineColor = $("#" + value + "lineColor").spectrum("get").toRgbString();
        }
        if (value == "LINE" || value == "LENGTH" || value == "MA") {
            tempMeasurementStyleCol[value].gaugeLength = $("#" + value + "gaugeLen")[0].value;
            tempMeasurementStyleCol[value].gaugeStyle = $("#" + value + "gaugeStyle")[0].value;
        }
        if (value == "ARROW" || value == "ERSTROKESTYLE" || value == "TEXT") {
            tempMeasurementStyleCol[value].isFill = $("#" + value + "isFill")[0].checked;
            tempMeasurementStyleCol[value].fillColor = $("#" + value + "fillColor").spectrum("get").toRgbString();
        }
        if (value == "ANGLE") {
            tempMeasurementStyleCol[value].arcRadius = $("#" + value + "arcRadius")[0].value;
        }
        if (value == "MSTROKESTYLE" || (value == "HOUNSFIELD" && currentModality() == "CT") || value == "MA") {
            tempMeasurementStyleCol[value].precision = $("#" + value + "precision")[0].value;
            tempMeasurementStyleCol[value].measurementUnits = $("#" + value + "measureUnits")[0].value;
        }
    }

    /**
     * On use default change event
     * @param {Type} parent 
     */
    function onUseDefaultChanged(parent) {
        var type = parent.id.substring(0, parent.id.length - 3);
        var modality = currentModality();
        $("#" + parent.id)[0].useDefaultNew = parent.checked;
        if ($("#" + parent.id)[0].useDefault == undefined) {
            $("#" + parent.id)[0].useDefault = !parent.checked;
        }
        tempMeasurementStyleCol[type].useDefault = parent.checked;
        setPrefValues(type, type, false, modality);
    }

    /**
     * Remove settings for unique measurement preference
     * @param {Type} measureData
     */
    function removeUniqueMeasurementPref() {
        //Unique line attributes
        var parent = $("#lineAttributes")[0];
        removeAnnotationPreferenceSettings(parent);

        //Unique font attributes
        parent = $("#fontAttributes")[0];
        removeAnnotationPreferenceSettings(parent);

        //Unique line annotation attributes
        parent = $("#annotAttributes")[0];
        removeAnnotationPreferenceSettings(parent);
    }

    /**
     * Updates user/global annotation preference
     * @param {Type}  
     */
    function updateAnnotationPreference(type, runAsAsync) {
        loadAnnotationPreference("SYSTEM", runAsAsync);
        if (type != "SYSTEM") {
            loadAnnotationPreference("USER", runAsAsync);
        }
    }

    /**
     * update the preferences
     * @param {Type} preferenceData - Specifies the preference data
     * @param {Type} type - Specifies the preference load type
     */
    function updatePreferences(preferenceData, type) {
        try {
            updatePreferenceLoadingStatus("annotation", type, preferenceData);

            if (preferenceData) {
                var style = JSON.parse(preferenceData);
                var defalutStyle = {};
                if (style) {
                    if (jQuery.isArray(style)) {
                        var measurementStyle = {
                            lineColor: (style.lineColor ? style.lineColor : defalutStyle.lineColor),
                            lineWidth: (style.lineWidth ? style.lineWidth : defalutStyle.lineWidth),
                            textColor: (style.textColor ? style.textColor : defalutStyle.textColor),
                            fontName: (style.fontName ? style.fontName : defalutStyle.fontName),
                            fontSize: (style.fontSize ? style.fontSize : defalutStyle.fontSize),
                            isBold: (style.isBold ? style.isBold : defalutStyle.isBold),
                            isItalic: (style.isItalic ? style.isItalic : defalutStyle.isItalic),
                            isUnderlined: (style.isUnderlined ? style.isUnderlined : defalutStyle.isUnderlined),
                            isStrikeout: (style.isStrikeout ? style.isStrikeout : defalutStyle.isStrikeout),
                            isFill: (style.isFill ? style.isFill : defalutStyle.isFill),
                            fillColor: (style.fillColor ? style.fillColor : defalutStyle.fillColor),
                            gaugeLength: (style.gaugeLength ? style.gaugeLength : defalutStyle.gaugeLength),
                            gaugeStyle: (style.gaugeStyle ? style.gaugeStyle : defalutStyle.gaugeStyle),
                            precision: (style.precision ? style.precision : defalutStyle.precision),
                            measurementUnits: (style.measurementUnits ? style.measurementUnits : defalutStyle.measurementUnits),
                            arcRadius: (style.arcRadius ? style.arcRadius : defalutStyle.arcRadius)
                        };
                        dicomViewer.measurement.setDefaultStyleCol(measurementStyle, type);
                    } else {
                        $.each(style, function (key, value) {
                            key = (type == "SYSTEM") ? ("sys" + key) : key;
                            dicomViewer.measurement.draw.setUserMeasurementStyleByType(key, value.useDefault, value.styleCol);
                        });
                    }
                } else {
                    var defalutStyle = dicomViewer.measurement.draw.getUserMeasurementStyleByType();
                    dicomViewer.measurement.setDefaultStyleCol(measurementStyle, type);
                }
            } else {
                var defalutStyle = dicomViewer.measurement.draw.getUserMeasurementStyleByType();
                dicomViewer.measurement.setDefaultStyleCol(defalutStyle, type, isServerFailed);
            }
        } catch (e) {}
    }

    /**
     * Get annoation preference from viewer service for given type
     * @param {Type}  
     */
    function loadAnnotationPreference(type, runAsAsync) {
        var requestUrl = getPrefUrl(type);
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "loadAnnotationPreference", "Start", undefined, true);

        try {
            // update the preference loading status
            updatePreferenceLoadingStatus("annotation", type);

            $.ajax({
                    url: requestUrl,
                    cache: false,
                    async: (runAsAsync == true ? true : false)
                })
                .done(function (data) {
                    isServerFailed = false;
                    updatePreferences(data, type);
                    dumpConsoleLogs(LL_INFO, undefined, (runAsAsync ? "loadAnnotationPreference" : undefined), "Ajax request for ANNOTATION preference [" + type.toUpperCase() + "]", undefined, true);
                    dumpConsoleLogs(LL_INFO, undefined, (runAsAsync ? "loadAnnotationPreference" : undefined), "End", (Date.now() - t0), runAsAsync);
                })
                .fail(function (data) {
                    isServerFailed = true;
                    updatePreferences(undefined, type);
                })
                .error(function (xhr, status) {
                    var description = xhr.statusText + " : Failed to load the ANNOTATION preference [" + type.toUpperCase() + "] from server";
                    sendViewerStatusMessage(xhr.status.toString(), description);
                    dumpConsoleLogs(LL_ERROR, undefined, (runAsAsync ? "loadAnnotationPreference" : undefined), description, undefined, runAsAsync);
                });
        } catch (e) {
            dumpConsoleLogs(LL_ERROR, undefined, (runAsAsync ? "loadAnnotationPreference" : undefined), e.message, undefined, runAsAsync);
        } finally {

        }
    }

    /**
     * Set user annotation preference to viewer service
     * @param {Type} preference 
     * @param {Type} data 
     */
    function setAnnotationPreference(data) {
        var requestUrl = getPrefUrl("USER");
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "setAnnotationPreference ", "Start");

        try {

            // update the preference loading status
            updatePreferenceLoadingStatus("annotation", "USER", undefined, true);

            $.ajax({
                    type: 'POST',
                    url: requestUrl,
                    data: JSON.stringify(data),
                    beforeSend: function (xhr) {
                        xhr.overrideMimeType("text/plain; charset=x-user-defined");
                    }
                })
                .success(function (data) {
                    updatePreferenceLoadingStatus("annotation", "USER", {}, true);
                    dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
                })
                .fail(function (data) {
                    updatePreferenceLoadingStatus("annotation", "USER", null, true);
                })
                .error(function (xhr, status) {
                    var description = xhr.statusText + " : Failed to save the annotation preferences to server";
                    sendViewerStatusMessage(xhr.status.toString(), description);
                    dumpConsoleLogs(LL_ERROR, undefined, undefined, description);
                });
        } catch (e) {
            dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
        } finally {

        }
    }

    /**
     * Get request url for specified type
     * @param {Type} preference 
     */
    function getPrefUrl(type) {
        var requestUrl = null;
        switch (type) {
            case "USER":
                requestUrl = dicomViewer.getMeasurementPrefUrl('user');
                break;
            case "SYSTEM":
                requestUrl = dicomViewer.getMeasurementPrefUrl('SYS');
                break;
            default:
                return null;
        }
        return requestUrl;
    }

    /**
     * Check for change in annotation preference.
     * @param {Type}  
     */
    function sanityCheck(isOnchange) {
        if (jQuery.isEmptyObject(tempMeasurementStyleCol)) {
            return false;
        }

        var uStyleCol = dicomViewer.measurement.draw.getUserMeasurementCol();
        var measurementStyleCol = JSON.parse(JSON.stringify(uStyleCol));
        getStyleFromCol(measurementStyleCol);
        var storedData = $.extend(true, {}, tempMeasurementStyleCol);
        var currentData = $.extend(true, {}, updateMeasurementStyle(true, true));
        if (isOnchange) {
            tempMeasurementStyleCol = $.extend(true, {}, storedData);
        }
        return !Object.compare(currentData, storedData);
    }

    /**
     * User discard changes
     * @param {Type}  
     */
    function discardChanges() {
        tempMeasurementStyleCol = {};
        showMeasurementStyle(true);
    }

    /**
     * Highlight the selected label tab item
     * @param {Type}  
     */
    function highlightLabelTabItem() {
        try {
            var tabAria = "_tab_item-0";
            var tabIndex = 0;
            $($("#lblTypeMenu").find(".resp-tabs-container")[0].children).each(function () {
                if ($("#" + this.id).css('display') == "block") {
                    tabAria = "_tab_item-" + tabIndex;
                }
                if (this.id !== "") {
                    tabIndex++;
                }
            })

            $("#lblTypeMenu").find("[aria-controls=" + tabAria + "]").addClass('resp-tab-active').css({
                'background-color': "#999",
                'border-color': "#c1c1c1"
            });
        } catch (e) {}
    }

    /**
     * validatePreference()
     * @param {Boolean} isProperty [[set True is select it Properties context menu otherwise undefined ]]
     */
    function validatePreference(isProperty) {
        try {
            var preferences = {};
            if (isProperty) {
                preferences.LINEgaugeLen = "gaugeLen";
                preferences.LENGTHgaugeLen = "gaugeLen";
                preferences.ANGLEarcRadius = "arcRadius";
                preferences.MSTROKESTYLEprecision = "precision";
                preferences.HOUNSFIELDprecision = "precision";
                preferences.MAgaugeLen = "gaugeLen";
                preferences.MAprecision = "precision";
                preferences.id = "PropertyAlert";
            } else {
                preferences.LINEgaugeLen = "LINEgaugeLen";
                preferences.LENGTHgaugeLen = "LENGTHgaugeLen";
                preferences.ANGLEarcRadius = "ANGLEarcRadius";
                preferences.MSTROKESTYLEprecision = "MSTROKESTYLEprecision";
                preferences.HOUNSFIELDprecision = "HOUNSFIELDprecision";
                preferences.MAgaugeLen = "MAgaugeLen";
                preferences.MAprecision = "MAprecision";
                preferences.id = "PreferenceAlert";
            }

            var preference = {
                LINEgaugeLen: document.getElementById(preferences.LINEgaugeLen),
                LENGTHgaugeLen: document.getElementById(preferences.LENGTHgaugeLen),
                ANGLEarcRadius: document.getElementById(preferences.ANGLEarcRadius),
                MSTROKESTYLEprecision: document.getElementById(preferences.MSTROKESTYLEprecision),
                HOUNSFIELDprecision: (currentModality() == "CT" ? document.getElementById(preferences.HOUNSFIELDprecision) : undefined),
                MAgaugeLen: (currentModality() == "US" ? document.getElementById(preferences.MAgaugeLen) : undefined),
                MAprecision: (currentModality() == "US" ? document.getElementById(preferences.MAprecision) : undefined),
            };

            var message = isValidAnnotationPreference(preference);
            if (!message) {
                $("#" + preferences.id).html("");
                $("#" + preferences.id).hide();
                return true;
            }

            $("#" + preferences.id).html(message);
            $("#" + preferences.id).show();

        } catch (e) {}
    }

    /**
     * Is valid annotation preference or not
     */
    function isValidAnnotationPreference(preference) {
        try {
            var errorMessage = false;

            if ((preference.LINEgaugeLen.value == "" && !preference.LINEgaugeLen.disabled) ||
                (preference.LENGTHgaugeLen.value == "" && !preference.LENGTHgaugeLen.disabled) ||
                (preference.ANGLEarcRadius.value == "" && !preference.ANGLEarcRadius.disabled) ||
                (currentModality() == "CT" && preference.HOUNSFIELDprecision.value == "" && !preference.HOUNSFIELDprecision.disabled) ||
                (currentModality() == "US" && preference.MAgaugeLen.value == "" && !preference.MAgaugeLen.disabled) ||
                (preference.MSTROKESTYLEprecision.value == "" && !preference.MSTROKESTYLEprecision.disabled) ||
                (currentModality() == "US" && preference.MAprecision.value == "" && !preference.MAprecision.disabled)) {
                errorMessage = 'Value should not be empty';
            } else if ((preference.LINEgaugeLen.value > 20 && !preference.LINEgaugeLen.disabled) ||
                (preference.LENGTHgaugeLen.value > 20 && !preference.LENGTHgaugeLen.disabled) ||
                (currentModality() == "US" && preference.MAgaugeLen.value > 20 && !preference.MAgaugeLen.disabled)) {
                errorMessage = 'GaugeLength value must be between 0 and 20';
            } else if ((preference.ANGLEarcRadius.value < 5 || preference.ANGLEarcRadius.value > 20) && !preference.ANGLEarcRadius.disabled) {
                errorMessage = 'ANGLE arcRadius value must be between 5 and 20';
            } else if ((currentModality() == "CT" && preference.HOUNSFIELDprecision.value > 14 && !preference.HOUNSFIELDprecision.disabled) ||
                (preference.MSTROKESTYLEprecision.value > 14 && !preference.MSTROKESTYLEprecision.disabled) ||
                (currentModality() == "US" && preference.MAprecision.value > 14 && !preference.MAprecision.disabled)) {
                errorMessage = 'Precision value must be between 0 and 14';
            }
            return errorMessage;
        } catch (e) {}
    }

    dicomViewer.annotationPreferences = {
        createAnnotationPrefTabs: createAnnotationPrefTabs,
        createUniqueMeasurementPref: createUniqueMeasurementPref,
        showOrHideAnnotationAttributes: showOrHideAnnotationAttributes,
        showMeasurementStyle: showMeasurementStyle,
        updateMeasurementStyle: updateMeasurementStyle,
        removeUniqueMeasurementPref: removeUniqueMeasurementPref,
        appendSelPrefDiv: appendSelPrefDiv,
        onUseDefaultChanged: onUseDefaultChanged,
        updateAnnotationPreference: updateAnnotationPreference,
        sanityCheck: sanityCheck,
        discardChanges: discardChanges,
        setAnnotationPreference: setAnnotationPreference,
        validatePreference: validatePreference
    }

    return dicomViewer;
}(dicomViewer));
