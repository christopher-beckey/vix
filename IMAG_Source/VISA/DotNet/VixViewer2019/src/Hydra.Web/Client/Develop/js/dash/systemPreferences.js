/*
 * Admin Preferences file
 */

var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var MT_TypeCol = [];
    var MT_EX_TypeCol = [];
    var MT_Lbl_Col = [];
    var MT_PS_TypeCol = [];
    var cinePreference = {};
    var ecgPreference = {};
    var displayPreference = {};
    var copyAttributesPreference = {};
    var annotationPreference = {};
    var logPreference = {};

    MT_PS_TypeCol = ["LENGTH", "LINE", "ARROW", "POINT", "ANGLE", "ELLIPSE", "HOUNSFIELDELLIPSE", "RECT", "HOUNSFIELDRECT", "TEXT", "TRACE", "MG", "ASPV", "ARPV", "MRPV", "ARL", "MRL", "MVALT", "FREEHAND", "PEN", "LBLANNOTATION", "LBLOVERLAY", "LBLORIENTATION", "LBLSCOUT", "LBLRULER"];

    MT_TypeCol = [
        "ANNOTATION", "MEASUREMENT", "ELLIPSE & RECTANGLE", "LABEL", "TEXT", "MITRAL & AORTIC (US)"
    ];

    MT_EX_TypeCol["ANNOTATION"] = [
        "ASTROKESTYLE", "LINE", "ARROW"
    ];

    MT_EX_TypeCol["MEASUREMENT"] = [
        "MSTROKESTYLE", "LENGTH", "ANGLE",
    ];

    MT_EX_TypeCol["ELLIPSE & RECTANGLE"] = [
        "ERSTROKESTYLE", "HOUNSFIELD"
    ];

    MT_EX_TypeCol["LABEL"] = [
        "LABEL"
    ];

    MT_EX_TypeCol["TEXT"] = [
        "TEXT"
    ];

    MT_EX_TypeCol["MITRAL & AORTIC (US)"] = [
        "MA", "MITRAL", "AORTIC"
    ];

    MT_Lbl_Col = [
        "LBLANNOTATION", "LBLOVERLAY", "LBLORIENTATION", "LBLSCOUT", "LBLRULER"
    ];

    MODALITY = [
        'US', 'CT'
    ];


    var systemMeasurementStyle = {
        lineColor: "#00FFFF",
        lineWidth: 1,
        fontName: "Arial",
        fontSize: 12,
        textColor: "#FFFF00",
        isBold: false,
        isItalic: true,
        isUnderlined: false,
        isStrikeout: false,
        isFill: false,
        fillColor: "#00FFFF",
        gaugeLength: 7,
        gaugeStyle: "Line",
        precision: 2,
        measurementUnits: "cm",
        arcRadius: 20
    };

    var defaultCinePreference = {
        palyselection: 'Stack',
        timesToRepeat: 1,
        framesToRepeat: 2,
        idleTime: 1
    };
    var defaultEcgPreference = {
        leadType: '3x4+3',
        firstSignal: "II",
        secondSignal: "V2",
        thirdSignal: "V5",
        signalValue: "II"
    };
    var defaultAnnotationPreference = {

    };
    var defaultDisplayPreference = {

    };
    var sysDisplayPreference = {

    };
    var defaultCopyAttributesPreference = {
        windowLevel: true,
        brightnessContrast: true,
        scale: true,
        invert: true,
        orientation: true,
        pan: false
    };
    var defaultLogPreference = {
        logLevel: "Info",
        lineLimit: "1000",
        keys: "CTRL+I"
    };

    $.each(MT_PS_TypeCol, function (key, value) {
        setDefaultAnnotationPreferenceByType(value, true, systemMeasurementStyle);
    });

    $.each(MODALITY, function (key, value) {
        setDefaultLayoutPreferencesByModality(value);
    });

    /**
     *Set the default annotation preference by type
     */
    function setDefaultAnnotationPreferenceByType(type, useDefault, styleCol) {
        try {
            if (defaultAnnotationPreference === undefined || defaultAnnotationPreference === null) {
                defaultAnnotationPreference = {};
            }
            var measurementStyle = {
                useDefault: useDefault,
                styleCol: styleCol
            };

            defaultAnnotationPreference["" + type + ""] = measurementStyle;
        } catch (e) {}
    }

    /**
     * Send study query request to get SecurityToken, AuthSiteNumber and SiteNumber
     * @param {Type}  
     */
    function studyQueryRequest() {

    }

    /**
     *Set the default layout preference by modality
     */
    function setDefaultLayoutPreferencesByModality(modality) {
        try {
            if (defaultDisplayPreference === undefined || defaultDisplayPreference === null) {
                defaultDisplayPreference = {};
            }
            sysDisplayPreference["" + modality + ""] = {
                modality: modality,
                rows: 1,
                columns: 1,
                zoomMode: '100%',
                useEmbedPdfViewer: "false"
            };
            defaultDisplayPreference = {
                preference: sysDisplayPreference,
                useDefault: true
            };
        } catch (e) {}
    }

    /**
     * update the system preference loading status
     * @param {Type} preference - Specifies the preference type
     * @param {Type} preferenceData - Specifies the preference data
     */
    var preferenceLoadingStatus = [];

    function updatePreferenceLoadingStatus(preference, preferenceData, isUpdate) {
        try {
            var loadingStatus = {};
            var displayText = preference + " system preferences.";
            if (!preferenceLoadingStatus[preference]) {
                loadingStatus = {
                    status: (isUpdate ? " Sending " : " Fetching ") + displayText,
                    canDisplay: true,
                    isSuccess: true,
                    preference: preference
                };
                preferenceLoadingStatus[preference] = loadingStatus;
            } else {
                loadingStatus = preferenceLoadingStatus[preference];
                loadingStatus.status = (isUpdate ? "Updated " : " Applied ") + displayText;
                loadingStatus.canDisplay = false;
                if (!preferenceData) {
                    loadingStatus.isSuccess = false;
                    loadingStatus.status = "Failed to " + (isUpdate ? "update " : "fetch ") + displayText + " Restoring to default";
                }
            }

            switch (preference) {
                case "cine":
                    showAndHideStatus("dashboard-cine-loading-status", "dashboard-cine-loading-icon", loadingStatus);
                    break;
                case "ecg":
                    showAndHideStatus("dashboard-ecg-loading-status", "dashboard-ecg-loading-icon", loadingStatus);
                    break;
                case "annotation":
                    showAndHideStatus("dashboard-annotation-loading-status", "dashboard-annotation-loading-icon", loadingStatus);
                    break;
                case "display":
                    showAndHideStatus("dashboard-display-loading-status", "dashboard-display-loading-icon", loadingStatus);
                    break;
                case "copyattributes":
                    showAndHideStatus("dashboard-copyattr-loading-status", "dashboard-copyattr-loading-icon", loadingStatus);
                    break;
                case "log":
                    showAndHideStatus("dashboard-log-loading-status", "dashboard-log-loading-icon", loadingStatus);
                    break;
                default:
                    console.log("Unsupported preference type: " + preference);
                    break;
            }
        } catch (e) {}
    }

    /**
     * Show and hide dashboard status based on following param
     */
    function showAndHideStatus(statusId, iconId, loadingStatus) {
        $('#' + iconId).show();
        $('#' + statusId).html('');
        $('#' + statusId).html(loadingStatus.status);

        if (loadingStatus.isSuccess && !loadingStatus.canDisplay) {
            $('#' + statusId).removeClass('dashboard-status-fail-style');
            $('#' + statusId).addClass('dashboard-status-success-style');
        } else if (!loadingStatus.isSuccess) {
            $('#' + statusId).removeClass('dashboard-status-success-style');
            $('#' + statusId).addClass('dashboard-status-fail-style');
        }

        if (!loadingStatus.canDisplay) {
            setTimeout(function () {
                $('#' + iconId).hide();
                if (preferenceLoadingStatus[loadingStatus.preference]) {
                    delete preferenceLoadingStatus[loadingStatus.preference];
                    $('#' + statusId).removeClass('dashboard-status-fail-style');
                    $('#' + statusId).removeClass('dashboard-status-success-style');
                }
            }, 2000);
        }
    }

    /**
     * Update the system preferences 
     * @param {Type} preference - Specifies the preference type
     * @param {Type} preferenceData - Specifies the preference data
     */
    function updateSystemPreferences(preference, preferenceData) {
        try {
            updatePreferenceLoadingStatus(preference, preferenceData);

            switch (preference) {
                case "cine":
                    if (!preferenceData) {
                        preferenceData = defaultCinePreference;
                    }
                    setCinePreference(preferenceData);
                    cinePreference = preferenceData;
                    break;
                case "ecg":
                    if (!preferenceData) {
                        preferenceData = defaultEcgPreference;
                    }
                    setEcgPreference(preferenceData);
                    ecgPreference = preferenceData;
                    break;
                case "annotation":
                    if (!preferenceData) {
                        preferenceData = defaultAnnotationPreference;
                    }
                    setAnnotationPreference(preferenceData);
                    annotationPreference = preferenceData;
                    break;
                case "display":
                    if (!preferenceData) {
                        preferenceData = defaultDisplayPreference;
                    }
                    setDisplayPreference(preferenceData.preference);
                    displayPreference = preferenceData;
                    break;
                case "copyattributes":
                    if (!preferenceData) {
                        preferenceData = defaultCopyAttributesPreference;
                    }
                    setCopyAttributesPreference(preferenceData);
                    copyAttributesPreference = preferenceData;
                    break;
                case "log":
                    if (!preferenceData) {
                        preferenceData = defaultLogPreference;
                    }
                    setLogPreference(preferenceData);
                    logPreference = preferenceData;
                    break;
                default:
                    console.log("Unsupported preference type: " + preference);
                    break;
            }
        } catch (e) {}
    }

    /**
     * Load all prefernces
     */
    function loadAllPreferences() {
        preferenceLoadingStatus = [];
        loadPreference("annotation", true);
        loadPreference("display", true);
        loadPreference("copyattributes", true);
        loadPreference("cine", true);
        loadPreference("log", true);
        //clear the Fetching message
        showAndHideStatus("dashboard-cine-loading-status", "dashboard-cine-loading-icon", "");
        showAndHideStatus("dashboard-ecg-loading-status", "dashboard-ecg-loading-icon", "");
        showAndHideStatus("dashboard-annotation-loading-status", "dashboard-annotation-loading-icon", "");
        showAndHideStatus("dashboard-display-loading-status", "dashboard-display-loading-icon", "");
        showAndHideStatus("dashboard-copyattr-loading-status", "dashboard-copyattr-loading-icon", "");
        showAndHideStatus("dashboard-log-loading-status", "dashboard-log-loading-icon", "");
    }

    /**
     * Set system preference to controls
     * @param {Type} preference 
     */
    function loadPreference(preference, runAsAsync) {
        var t0 = Date.now();
        console.log("info: loadPreference - start");

        try {
            // update the preference loading status
            updatePreferenceLoadingStatus(preference);

            $.ajax({
                url: getPrefUrl(preference),
                cache: false,
                async: (runAsAsync == true ? true : false)
            })
            .done(function (data) {
                if (data !== "") updateSystemPreferences(preference, JSON.parse(data));
            })
            .fail(function (data) {
                updateSystemPreferences(preference, null);
            })
            .error(function (xhr, status) {
                updateSystemPreferences(preference, null);
                console.log("error : " + xhr.statusText + "\nFailed to load the system preference from server");
            });
        } catch (e) {
            console.log("error: loadPreference" + e.message);
        } finally {
            console.log("info : loadPreference - end" + (Date.now() - t0));
        }
    }

    /**
     * Get request url for specified preference
     * @param {Type} preference 
     */
    function getPrefUrl(preference) {
        var requestUrl = null;
        switch (preference) {
            case "cine":
                requestUrl = getCineUrl();
                break;
            case "ecg":
                requestUrl = getEcgUrl();
                break;
            case "annotation":
                requestUrl = getMeasurementPrefUrl();
                break;
            case "display":
                requestUrl = getSettingsUrl();
                break;
            case "copyattributes":
                requestUrl = getCopyAttribUrl();
                break;
            case "log":
                requestUrl = getLogUrl();
                break;
            default:
                return null;
        }
        return requestUrl;
    }

    /**
     * Cine Url
     */
    function getCineUrl() {
        return THIS_PAGE_URL.replace("dash", "dict/SYS/cine?SecurityToken=") + SECURITY_TOKEN; //VAI-915
    }

    /**
     * Ecg Url
     */
    function getEcgUrl() {
        return THIS_PAGE_URL.replace("dash", "dict/SYS/ecg?SecurityToken=") + SECURITY_TOKEN;
    }

    /**
     * CopyAttributes Url
     */
    function getCopyAttribUrl() {
        return THIS_PAGE_URL.replace("dash", "dict/SYS/copyattributes?SecurityToken=") + SECURITY_TOKEN;
    }

    /**
     * Log Url
     */
    function getLogUrl() {
        return THIS_PAGE_URL.replace("dash", "dict/SYS/log?SecurityToken=") + SECURITY_TOKEN;
    }

    /**
     * Settings Url (Hanging Protocol)
     */
    function getSettingsUrl() {
        return THIS_PAGE_URL.replace("dash", "dict/SYS/layouts?SecurityToken=") + SECURITY_TOKEN;
    }

    /**
     * Measurement preferences Url
     */
    function getMeasurementPrefUrl() {
        return THIS_PAGE_URL.replace("dash", "dict/SYS/mpref?SecurityToken=") + SECURITY_TOKEN;
    }

    /**
     * Prase html text
     * @param {Type} id 
     */
    function parseHTMLText(id) {
        return $(id).html().split(':')[1].trim();
    }

    /**
     * Set system preference from viewer service
     * @param {Type} preference 
     * @param {Type} data 
     */
    function setSystemPreference(preference, data) {
        var requestUrl = getPrefUrl(preference);
        var t0 = Date.now();
        console.log("info: setSystemPreference - start");

        try {
            // update the preference loading status
            updatePreferenceLoadingStatus(preference, undefined, true);

            $.ajax({
                type: 'POST',
                url: requestUrl,
                data: JSON.stringify(data),
                beforeSend: function (xhr) {
                    xhr.overrideMimeType("text/plain; charset=x-user-defined");
                }
            })
            .success(function (data) {
                updatePreferenceValues(preference);
                updatePreferenceLoadingStatus(preference, {}, true);
            })
            .fail(function (data) {
                updatePreferenceLoadingStatus(preference, undefined, true);
            })
            .error(function (xhr, status) {
                var description = xhr.statusText + "\nFailed to save the system preference to server";
                console.log("error : " + description);
            });
        } catch (e) {
            console.log("error : " + e.message);
        } finally {
            console.log("info : setSystemPreference - end" + (Date.now() - t0));
        }
    }

    /**
     * Set cine preference to controls
     * @param {Type} preference 
     */
    function setCinePreference(data) {
        set('palyselection', data.palyselection);
        set('timesToRepeat', data.timesToRepeat);
        set('framesToRepeat', data.framesToRepeat);
        set('idleTime', data.idleTime);
    }

    /**
     * Get cine preference from controls
     * 
     */
    function getCinePreference() {
        var preference = {
            palyselection: get('palyselection'),
            timesToRepeat: get('timesToRepeat'),
            framesToRepeat: get('framesToRepeat'),
            idleTime: get('idleTime')
        };
        return preference;
    }

    /**
     * Set ecg preference to controls
     * @param {Type} preference 
     */
    function setEcgPreference(data) {
        set('ledselection', data.leadType);
        set('3x43one', data.firstSignal);
        set('3x43two', data.secondSignal);
        set('3x43three', data.thirdSignal);
        set('3x41Value', data.signalValue);
        $('#ledselection').change();
    }

    /**
     * Get ecg preference from controls
     * 
     */
    function getEcgPreference() {
        var preference = {
            leadType: get('ledselection'),
            firstSignal: get('3x43one'),
            secondSignal: get('3x43two'),
            thirdSignal: get('3x43three'),
            signalValue: get('3x41Value')
        };
        return preference;
    }

    /**
     * Set annotation preference to controls
     * @param {Type} preference 
     */
    function setAnnotationPreference(data) {
        setStyleFromMeasurementCol(data);
    }

    /**
     * Get annotation preference from controls
     * 
     */
    function getAnnotationPreference() {
        return getMeasurementColFromStyle();
    }

    /**
     * Set display preference to controls
     * @param {Type} preference 
     */
    function setDisplayPreference(data) {
        var tdAction = '<button type="button" class="btn btn-sm btn-primary" style="margin: 2px;width: 35px;" onclick="dicomViewer.systemPreferences.addOrEditHP(this.parentElement.parentElement.childNodes,  &quot;edit&quot;)"><span class="glyphicon glyphicon-edit"></span></button><button type="button" class="btn btn-sm btn-danger" style="width: 35px;" onclick="dicomViewer.systemPreferences.deleteHP(this)"><span class="glyphicon glyphicon-trash"></span></button>'

        var tr = null;
        $.each(data, function (key, value) {
            if (key == "useDefault") {
                return;
            }
            tr = $('<tr/>');
            tr.append("<td>" + value.modality + "</td>");
            tr.append("<td>" + value.rows + "</td>");
            tr.append("<td>" + value.columns + "</td>");
            tr.append("<td>" + value.zoomMode + "</td>");
            tr.append("<td style='padding: 0px'>" + tdAction + "</td>");
            $("#hpTableList").append(tr);

            if (key == 'ECG') {
                $('#useEmbedPdfViewer')[0].isECGPdf = value.useEmbedPdfViewer;
            } else if (key == 'General') {
                $('#useEmbedPdfViewer')[0].isGeneral = value.useEmbedPdfViewer;
            }
        });

        $('#useEmbedPdfViewer').val("true");
    }

    /**
     * Get display preference from controls
     * 
     */
    function getDisplayPreference() {
        var preference = {};

        $("#hpTableList").find('tr').each(function (i, el) {
            tdData = $(this).find('td');
            if (tdData.length >= 4) {
                var tdmodality = tdData.eq(0).text();

                var isUseEmbedPdfViewer = true;
                if (tdmodality == "General") {
                    isUseEmbedPdfViewer = $('#useEmbedPdfViewer')[0].isGeneral;
                } else if (tdmodality == "ECG") {
                    isUseEmbedPdfViewer = $('#useEmbedPdfViewer')[0].isECGPdf;
                }

                preference["" + tdmodality + ""] = {
                    modality: tdmodality,
                    rows: tdData.eq(1).text(),
                    columns: tdData.eq(2).text(),
                    zoomMode: tdData.eq(3).text(),
                    useEmbedPdfViewer: isUseEmbedPdfViewer
                };
            }
        });

        return preference;
    }

    /**
     * Set copy attributes preference to controls
     * @param {Type} preference 
     */
    function setCopyAttributesPreference(data) {
        setCheck('windowlevel', data.windowLevel);
        setCheck('brightnesscontrast', data.brightnessContrast);
        setCheck('scale', data.scale);
        setCheck('invert', data.invert);
        setCheck('orientation', data.orientation);
        setCheck('pan', data.pan);
    }

    /**
     * Set copy attributes preference to controls
     * @param {Type} preference 
     */
    function setLogPreference(data) {
        set('logLevelPref', data.logLevel);
        set('lineLimitPref', data.lineLimit);
        setLogPreferenceKey(data.keys);
    }

    /**
     * Parse and set the shortcut key to the control
     * @param {string}   value    shortcut key
     */
    function setLogPreferenceKey(value) {
        try {
            if (!value) {
                return;
            }

            var splitValue = value.split("+");

            value.indexOf("CTRL") > -1 ? setCheck("ctrlkeyPref", true) : setCheck("ctrlkeyPref", false);
            value.indexOf("ALT") > -1 ? setCheck("altkeyPref", true) : setCheck("altkeyPref", false);
            value.indexOf("SHIFT") > -1 ? setCheck("shiftkeyPref", true) : setCheck("shiftkeyPref", false);
            set("key3Pref", splitValue[splitValue.length - 1]);
        } catch (e) {}
    }

    /**
     * Get copy attributes preference from controls
     * 
     */
    function getCopyAttributesPreference() {
        var preference = {
            windowLevel: getCheck('windowlevel'),
            brightnessContrast: getCheck('brightnesscontrast'),
            scale: getCheck('scale'),
            invert: getCheck('invert'),
            orientation: getCheck('orientation'),
            pan: getCheck('pan')
        };
        return preference;
    }

    /**
     * Get copy attributes preference from controls
     * 
     */
    function getLogPreference() {
        var preference = {
            logLevel: get('logLevelPref'),
            lineLimit: get('lineLimitPref'),
            keys: getLogPreferenceKey()
        };
        return preference;
    }

    /**
     * Get and format the shortcut key from control
     * @returns {string} Shotcut key
     */
    function getLogPreferenceKey() {
        try {
            var shortCutKey = "";
            if (getCheck("ctrlkeyPref")) {
                shortCutKey = $("#ctrlkeyPref")[0].value;
                shortCutKey += "+";
            }
            if (getCheck("altkeyPref")) {
                shortCutKey += $("#altkeyPref")[0].value;
                shortCutKey += "+";
            }
            if (getCheck("shiftkeyPref")) {
                shortCutKey += $("#shiftkeyPref")[0].value;
                shortCutKey += "+";
            }
            shortCutKey += get("key3Pref");

            return shortCutKey;
        } catch (e) {
            return "";
        }
    }

    /**
     * Get value for given element id
     * @param {Type} id 
     */
    function get(id) {
        var element = document.getElementById(id);
        if (element) {
            if (element.type == "checkbox") {
                return getCheck(id);
            } else if (id.indexOf('Color') > -1) {
                return getColorSpectrum(id);
            }
            return element.value;
        }
    }

    /**
     * Get checked state for given checkbox id
     * @param {Type} id 
     */
    function getCheck(id) {
        return $("#" + id)[0].checked;
    }

    /**
     * Get color for given spectrum id
     * @param {Type} id 
     */
    function getColorSpectrum(id) {
        return $("#" + id).spectrum("get").toRgbString();
    }

    /**
     * Set value for given element id
     * @param {Type} id 
     * @param {Type} value 
     */
    function set(id, value) {
        if ((id === undefined) || (value === undefined)) return;
        var element = document.getElementById(id);
        if (element) {
            element.value = value;
        }
    }

    /**
     * Set checked state for given checkbox id
     * @param {Type} id 
     * @param {Type} value 
     */
    function setCheck(id, value) {
        var element = document.getElementById(id);
        if (element) {
            element.checked = value;
        }
    }

    /**
     * Convert measurement collection to design view structure
     * @param {Type} measurementStyleCol 
     */
    function setStyleFromMeasurementCol(measurementStyleCol) {
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
    function setMeasurementStyle(measurementStyleCol, id, subType) {
        var type = id;

        if (measurementStyleCol[id] == undefined) {
            if (id == "ASTROKESTYLE") {
                type = "LINE";
            } else if (id == "MSTROKESTYLE") {
                type = "LENGTH";
            } else if (id == "ERSTROKESTYLE") {
                type = "ELLIPSE";
            } else if (id == "HOUNSFIELD") {
                type = "HOUNSFIELDELLIPSE";
            } else if (id == "LABEL") {
                type = subType;
            } else if (id == "MA") {
                type = "MRL";
            } else if (id == "MITRAL") {
                type = "MRL";
            } else if (id == "AORTIC") {
                type = "ARL";
            } else {
                type = "LINE";
            }
        }

        if (id == "LABEL") {
            id = subType;
        }

        set(id + "lineWidth", measurementStyleCol[type].styleCol.lineWidth);
        set(id + "gaugeLength", measurementStyleCol[type].styleCol.gaugeLength);
        set(id + "gaugeStyle", measurementStyleCol[type].styleCol.gaugeStyle);
        setCheck(id + "isFill", measurementStyleCol[type].styleCol.isFill);
        set(id + "arcRadius", measurementStyleCol[type].styleCol.arcRadius);
        set(id + "fontName", measurementStyleCol[type].styleCol.fontName);
        set(id + "fontSize", measurementStyleCol[type].styleCol.fontSize);
        setCheck(id + "isBold", measurementStyleCol[type].styleCol.isBold);
        setCheck(id + "isItalic", measurementStyleCol[type].styleCol.isItalic);
        setCheck(id + "isUnderlined", measurementStyleCol[type].styleCol.isUnderlined);
        setCheck(id + "isStrikeout", measurementStyleCol[type].styleCol.isStrikeout);
        set(id + "precision", measurementStyleCol[type].styleCol.precision);
        set(id + "measureUnits", measurementStyleCol[type].styleCol.measurementUnits);
        setSpectrumColor(id + "lineColor", measurementStyleCol[type].styleCol.lineColor);
        setSpectrumColor(id + "fillColor", measurementStyleCol[type].styleCol.fillColor);
        setSpectrumColor(id + "textColor", measurementStyleCol[type].styleCol.textColor);
    }

    /**
     * Convert design view structure to measurement collection
     * @param {Type}  
     */
    function getMeasurementColFromStyle() {
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
                measurementUnits: getMeasurementStyle("measureUnits", value)
            }

            for (var propName in styleCol) {
                if (styleCol[propName] === undefined) {
                    delete styleCol[propName];
                }
            }

            measurementStyleCol[value] = {
                useDefault: true,
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
            case "lineWidth":
            case "lineColor":
            case "precision":
            case "measureUnits":
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

                }

                if (style == "precision" || style == "measureUnits") {
                    if (type == "MITRAL" || type == "AORTIC") {
                        type = "MA";
                    }
                } else if (key == "hEllipse") {
                    type = "ERSTROKESTYLE";
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
                }
                break;
            case "isFill":
            case "fillColor":
                if (type == "TEXT") {

                } else if (key == "Annotation") {
                    type = "ARROW";
                } else if (key == "Ellipse" || key == "hEllipse") {
                    type = "ERSTROKESTYLE";
                }
                break;
            case "arcRadius":
                if (type != "ANGLE" && type != "GLOBAL") {
                    return null;
                }
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
                break;
            default:
                return null;
        }
        return get(type + style);
    }

    /**
     * Get measurement category for given measurement type
     * @param {Type} type 
     */
    function getEnumMT(type) {
        if (type == "GLOBAL") {
            return type;
        }

        if (type == "TEXT" || type == "LINE" ||
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
        }
    }

    /**
     * Set color spectrum
     * @param {Type} id 
     * @param {Type} color 
     */
    function setSpectrumColor(id, color) {
        var element = document.getElementById(id);
        if (element) {
            $("#" + id).spectrum({
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
        }
    }

    /**
     * Get row of exisisting modality
     * @param {Type}  
     */
    function isExistingModality(modality) {
        // Check whether the modality is already present and update the new settings. 
        var tdElement = null;
        $("#hpTableList").find('tr').each(function (i, el) {
            tdData = $(this).find('td');
            if (tdData.length >= 4) {
                var tdmodality = tdData.eq(0).text();
                if (tdmodality == modality) {
                    tdElement = tdData;
                    return false;
                }
            }
        });
        return tdElement;
    }

    /**
     * To update HP table
     * @param {Type}  
     */
    function updateHPTable() {
        var data = {};
        var modality = get('modality');
        var tdElement = isExistingModality(modality);
        data[modality] = {
            modality: modality,
            rows: get('layoutRows'),
            columns: get('layoutColumns'),
            zoomMode: get('zoomModeValues'),
            useEmbedPdfViewer: get('useEmbedPdfViewer')
        };
        // Add the new modality settings 
        if (!tdElement) {
            setDisplayPreference(data);
        } else {
            tdElement.eq(1).html(data[modality].rows);
            tdElement.eq(2).html(data[modality].columns);
            tdElement.eq(3).html(data[modality].zoomMode);
        }

        if (modality == "General") {
            var value = $('#useEmbedPdfViewer')[0].isGeneral = data[modality].useEmbedPdfViewer;
            $('#useEmbedPdfViewer').val(value);
        } else if (modality == "ECG") {
            var value = $('#useEmbedPdfViewer')[0].isECGPdf = data[modality].useEmbedPdfViewer;
            $('#useEmbedPdfViewer').val(value);
        }

        showOrHideHPTable(true);
        onSubmit('display');
    }

    /**
     * Edit selected HP Protocol
     * @param {Type}  
     */
    function addOrEditHP(tdElement, action) {
        var useDefault = null;
        var modality = null;
        if (action == "edit") {
            useDefault = false;
        } else if (action == "add") {
            tdElement = isExistingModality('US');
            if (tdElement) {
                useDefault = false;
            } else {
                useDefault = true;
            }
        } else if (action == "selchange") {
            if (tdElement) {
                useDefault = false;
            } else {
                useDefault = true;
            }
        }

        if (useDefault) {
            modality = 'US';
            set('layoutRows', '1');
            set('layoutColumns', '1');
            set('zoomModeValues', '100%');
            $("#modality").prop('disabled', false);
        } else {
            modality = tdElement[0].innerText;
            set('layoutRows', tdElement[1].innerText);
            set('layoutColumns', tdElement[2].innerText);
            set('zoomModeValues', tdElement[3].innerText);
            $("#modality").prop('disabled', action == "edit");
        }

        if (modality == "General") {
            var value = $('#useEmbedPdfViewer')[0].isGeneral == undefined ? "true" : $('#useEmbedPdfViewer')[0].isGeneral;
            $('#useEmbedPdfViewer').val(value);
        } else if (modality == "ECG") {
            var value = $('#useEmbedPdfViewer')[0].isECGPdf == undefined ? "true" : $('#useEmbedPdfViewer')[0].isECGPdf;
            $('#useEmbedPdfViewer').val(value);
        }

        if (action != "selchange") {
            showOrHideHPTable(false);
            set('modality', modality);

            if (modality == "General" || modality == "ECG") {
                $("#useEmbedPDFViewer_Row").show();
            } else {
                $("#useEmbedPDFViewer_Row").hide();
            }
        }
    }

    /**
     * Show or Hide HP controls
     * @param {Type}  
     */
    function showOrHideHPTable(isShow) {
        if (isShow) {
            $('#listHangingProtocol').show();
            $('#addEditHPTable').hide();
        } else {
            $('#listHangingProtocol').hide();
            $('#addEditHPTable').show();
            $("#modality").change(function () {
                if (this.value == "General" || this.value == "ECG") {
                    if (this.value == "General") {
                        var value = $('#useEmbedPdfViewer')[0].isGeneral == undefined ? "true" : $('#useEmbedPdfViewer')[0].isGeneral;
                        $('#useEmbedPdfViewer').val(value);
                    } else if (this.value == "ECG") {
                        var value = $('#useEmbedPdfViewer')[0].isECGPdf == undefined ? "true" : $('#useEmbedPdfViewer')[0].isECGPdf;
                        $('#useEmbedPdfViewer').val(value);
                    }
                    $("#useEmbedPDFViewer_Row").show();
                } else {
                    $("#useEmbedPDFViewer_Row").hide();
                }
                addOrEditHP(isExistingModality(this.value), 'selchange');
            });
        }
    }

    /**
     * Delete selected HP Protocol
     * @param {Type}  
     */
    function deleteHP(row) {
        $(row).closest('tr').remove();

        var modality = $(row).closest('tr').find('td').eq(0).text();
        if (modality == "ECG") {
            $('#useEmbedPdfViewer')[0].isECGPdf = undefined;
        } else if (modality == "General") {
            $('#useEmbedPdfViewer')[0].isGeneral = undefined;
        }
        onSubmit('display');
    }

    /**
     * Submit system preference
     * @param {Type}  
     */
    function onSubmit(preference) {
        var data = null;
        switch (preference) {
            case "cine":
                data = getCinePreference();
                break;
            case "ecg":
                data = getEcgPreference();
                break;
            case "annotation":
                data = getAnnotationPreference();
                break;
            case "display":
                data = {
                    preference: getDisplayPreference()
                };
                break;
            case "copyattributes":
                data = getCopyAttributesPreference();
                break;
            case "log":
                data = getLogPreference();
                break;
            default:
                return;
        }

        if (preference != "display") {
            toggleButton(preference, true);
        }

        if (preference == "cine") {
            if (!isValidCinePreference(preference)) {
                return;
            }
        }

        if (preference == "annotation") {
            if (!isValidAnnotationPreference(preference)) {
                return;
            }
        }

        if (data) {
            data.useDefault = true;
            setSystemPreference(preference, data);
        }
    }

    /**
     * Reset system preference
     * @param {Type}  
     */
    function onReset(preference) {
        $("#PreferenceAlert").html("");
        $("#PreferenceAlert").hide();
        $("#AnnotationPreferenceAlert").html("");
        $("#AnnotationPreferenceAlert").hide();
        resetPreferenceValues(preference);
    }

    /**
     * load the system preference
     * @param {Type} preference - Specifies the preference
     * @param {Type} loadFrom - Specifies the loading type
     */
    function loadSystemPreference(preference, loadFrom) {
        try {
            var preferenceData;
            switch (preference) {
                case "cine":
                    preferenceData = loadFrom == "control" ? getCinePreference() : cinePreference;
                    preferenceData.useDefault = true;
                    break;
                case "ecg":
                    preferenceData = loadFrom == "control" ? getEcgPreference() : ecgPreference;
                    preferenceData.useDefault = true;
                    break;
                case "annotation":
                    preferenceData = loadFrom == "control" ? getAnnotationPreference() : annotationPreference;
                    preferenceData.useDefault = true;
                    break;
                case "display":
                    preferenceData = loadFrom == "control" ? {
                        preference: getDisplayPreference()
                    } : displayPreference;
                    preferenceData.useDefault = true;
                    break;
                case "copyattributes":
                    preferenceData = loadFrom == "control" ? getCopyAttributesPreference() : copyAttributesPreference;
                    preferenceData.useDefault = true;
                    break;
                case "log":
                    preferenceData = loadFrom == "control" ? getLogPreference() : logPreference;
                    preferenceData.useDefault = true;
                    break;
            }

            return preferenceData;
        } catch (e) {}
    }

    /**
     * update the preference values
     * @param {Type} preference - Specifies the preference
     */
    function updatePreferenceValues(preference) {
        try {
            switch (preference) {
                case "cine":
                    cinePreference = getCinePreference();
                    cinePreference.useDefault = true;
                    break;
                case "ecg":
                    ecgPreference = getEcgPreference();
                    ecgPreference.useDefault = true;
                    break;
                case "annotation":
                    annotationPreference = getAnnotationPreference();
                    annotationPreference.useDefault = true;
                    break;
                case "display":
                    displayPreference = {
                        preference: getDisplayPreference()
                    };
                    displayPreference.useDefault = true;
                    break;
                case "copyattributes":
                    copyAttributesPreference = getCopyAttributesPreference();
                    copyAttributesPreference.useDefault = true;
                    break;
                case "log":
                    logPreference = getLogPreference();
                    logPreference.useDefault = true;
                    break;
            }
        } catch (e) {}
    }

    /**
     * Reset the preference values
     * @param {Type} preference - Specifies the preference
     */
    function resetPreferenceValues(preference) {
        try {
            switch (preference) {
                case "cine":
                    setCinePreference(cinePreference);
                    break;
                case "ecg":
                    setEcgPreference(ecgPreference);
                    break;
                case "annotation":
                    setAnnotationPreference(annotationPreference);
                    break;
                case "display":
                    setDisplayPreference(displayPreference.preference);
                    break;
                case "copyattributes":
                    setCopyAttributesPreference(copyAttributesPreference);
                    break;
                case "log":
                    setLogPreference(logPreference);
                    break;
            }
            toggleButton(preference, true);
        } catch (e) {}
    }

    /**
     * Sanity check in current preference window
     * @param {Type} activePrefTab - Specifies the active preference tab
     */
    function sanityCheck(activePrefTab) {
        try {
            var storedData = loadSystemPreference(activePrefTab, 'config');
            var currentData = loadSystemPreference(activePrefTab, 'control');
            return !Object.compare(currentData, storedData);
        } catch (e) {}
    }

    /**
     * isDirtyCheck in preference window
     * @param {Type} activePrefTab - Specifies the active preference tab
     */
    function isDirtyCheck(activePrefTab) {
        try {
            var isDirty = false;
            isDirty = sanityCheck(activePrefTab);
            toggleButton(activePrefTab, isDirty ? false : true);
        } catch (e) {}
    }

    /**
     * Toggle the submit and reset button
     * @param {Type} preference - Specifies the preference
     * @param {Type} state - Specifies the button state
     */
    function toggleButton(preference, state) {
        try {
            $('#dashboard-' + preference + 'Tab-apply-btn').prop('disabled', state);
            $('#dashboard-' + preference + 'Tab-reset-btn').prop('disabled', state);
        } catch (e) {}
    }

    /**
     * Deep objects comparision
     */
    Object.compare = function (obj1, obj2) {
        //Loop through properties in object 1
        for (var p in obj1) {
            //Check property exists on both objects
            if (obj1.hasOwnProperty(p) !== obj2.hasOwnProperty(p)) return false;

            switch (typeof (obj1[p])) {
                //Deep compare objects
                case 'object':
                    if (!Object.compare(obj1[p], obj2[p])) return false;
                    break;
                //Compare function code
                case 'function':
                    if (typeof (obj2[p]) == 'undefined' || (p != 'compare' && obj1[p].toString() != obj2[p].toString())) return false;
                    break;
                //Compare values
                default:
                    if ((typeof obj1[p] == "string") && obj1[p].indexOf('#') > -1) {
                        obj1[p] = hexToRgb(obj1[p]);
                    }
                    if ((typeof obj2[p] == "string") && obj2[p].indexOf('#') > -1) {
                        obj2[p] = hexToRgb(obj2[p]);
                    }
                    if (obj1[p] != null && obj2[p] != null && obj1[p] != obj2[p]) return false;
            }
        }

        //Check object 2 for any extra properties
        for (var p in obj2) {
            if (typeof (obj1[p]) == 'undefined') return false;
        }
        return true;
    };

    /**
     * HEX to RGB conversion
     * @param {Type} hex 
     */
    function hexToRgb(hex) {
        // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
        var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
        hex = hex.replace(shorthandRegex, function (m, r, g, b) {
            return r + r + g + g + b + b;
        });

        var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
        return result ? "rgb(" + parseInt(result[1], 16) + ", " + parseInt(result[2], 16) + ", " + parseInt(result[3], 16) + ")" : null;
    }

    /**
     * Is valid cine preference or not
     * @param {Type} prefActiveTab - Specifies the active tab
     */
    function isValidCinePreference(prefActiveTab) {
        try {
            var preference = getCinePreference();
            if (preference.framesToRepeat == "" || preference.timesToRepeat == "" || preference.idleTime == "") {
                $("#PreferenceAlert").html('Value should not be empty');
                $("#PreferenceAlert").show();
                $('#dashboard-' + prefActiveTab + 'Tab-reset-btn').prop('disabled', false);
                return false;
            } else if ((preference.framesToRepeat < 1) || (500 < preference.framesToRepeat) || (preference.timesToRepeat < 1) || (500 < preference.timesToRepeat) || (preference.idleTime < 1) || (500 < preference.idleTime)) {
                $("#PreferenceAlert").html('Value must be between 1 and 500');
                $("#PreferenceAlert").show();
                $('#dashboard-' + prefActiveTab + 'Tab-reset-btn').prop('disabled', false);
                return false;
            } else {
                $("#PreferenceAlert").html("");
                $("#PreferenceAlert").hide();
            }

            return true;
        } catch (e) {}
    }

    /**
     * Is valid annotation preference or not
     * @param {Type} prefActiveTab - Specifies the active tab
     */
    function isValidAnnotationPreference(prefActiveTab) {
        try {
            var preference = getAnnotationPreference();
            if (preference.LINE.styleCol.gaugeLength == "" || preference.LENGTH.styleCol.gaugeLength == "" || preference.ANGLE.styleCol.arcRadius == "" || preference.HOUNSFIELDRECT.styleCol.precision == "" || preference.MRPV.styleCol.gaugeLength == "" || preference.MRPV.styleCol.precision == "" || preference.LENGTH.styleCol.precision == "") {
                $("#AnnotationPreferenceAlert").html('Value should not be empty');
                $("#AnnotationPreferenceAlert").show();
                $('#dashboard-' + prefActiveTab + 'Tab-reset-btn').prop('disabled', false);
                return false;
            } else if (preference.LINE.styleCol.gaugeLength > 20 || preference.LENGTH.styleCol.gaugeLength > 20 || preference.MRPV.styleCol.gaugeLength > 20) {
                $("#AnnotationPreferenceAlert").html('GaugeLength value must be between 0 and 20');
                $("#AnnotationPreferenceAlert").show();
                $('#dashboard-' + prefActiveTab + 'Tab-reset-btn').prop('disabled', false);
                return false;
            } else if ((preference.ANGLE.styleCol.arcRadius < 5 || preference.ANGLE.styleCol.arcRadius > 20)) {
                $("#AnnotationPreferenceAlert").html('ANGLE arcRadius value must be between 5 and 20');
                $("#AnnotationPreferenceAlert").show();
                $('#dashboard-' + prefActiveTab + 'Tab-reset-btn').prop('disabled', false);
                return false;
            } else if (preference.HOUNSFIELDRECT.styleCol.precision > 14 || preference.MRPV.styleCol.precision > 14 || preference.LENGTH.styleCol.precision > 14) {
                $("#AnnotationPreferenceAlert").html('Precision value must be between 0 and 14');
                $("#AnnotationPreferenceAlert").show();
                $('#dashboard-' + prefActiveTab + 'Tab-reset-btn').prop('disabled', false);
                return false;
            } else {
                $("#AnnotationPreferenceAlert").html("");
                $("#AnnotationPreferenceAlert").hide();
            }

            return true;
        } catch (e) {}
    }

    dicomViewer.systemPreferences = {
        addOrEditHP: addOrEditHP,
        deleteHP: deleteHP,
        updateHPTable: updateHPTable,
        showOrHideHPTable: showOrHideHPTable,
        onSubmit: onSubmit,
        onReset: onReset,
        loadAllPreferences: loadAllPreferences,
        isDirtyCheck: isDirtyCheck,
        sanityCheck: sanityCheck,
        resetPreferenceValues: resetPreferenceValues,
        isValidCinePreference: isValidCinePreference,
        isValidAnnotationPreference: isValidAnnotationPreference
    }

    return dicomViewer;
}(dicomViewer));
