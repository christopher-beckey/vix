var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var defaultCinePreference = {
        palyselection: 'Stack',
        timesToRepeat: 1,
        framesToRepeat: 2,
        idleTime: 1,
        useDefault: true
    };

    var defaultEcgPreference = {
        leadType: '3x4+3',
        firstSignal: "II",
        secondSignal: "V2",
        thirdSignal: "V5",
        signalValue: "II",
        useDefault: true
    };

    var defaultDisplayPreference = {

    };

    var displayPreference = {

    };

    var selectedHPData = undefined;

    var defaultCopyAttributesPreference = {
        windowLevel: true,
        brightnessContrast: true,
        scale: true,
        invert: true,
        orientation: true,
        pan: false,
        useDefault: true
    };

    MODALITY = [
        'US', 'CT'
    ];

    PREF_TYPE = [
        'cine', 'ecg', 'layout', 'copyattributes'
    ];

    var defaultLogPreference = {
        logLevel: "Info",
        lineLimit: "1000",
        keys: "CTRL+I",
        useDefault: true
    };

    /**
     * Update general preferences
     * @param {Type}  
     */
    function updateGeneralPreference(type, runAsAsync) {
        if (jQuery.isEmptyObject(defaultDisplayPreference)) {
            $.each(MODALITY, function (key, value) {
                setDefaultLayoutPreferencesByModality(value);
            });

            if (displayPreference === undefined || displayPreference === null) {
                displayPreference = {};
            }

            defaultDisplayPreference = {
                preference: displayPreference,
                useDefault: true
            };
            setUseDefaultClickAttribute("cine", 'cineUseDefault');
            setUseDefaultClickAttribute("ecg", 'ecgUseDefault');
            setUseDefaultClickAttribute("layout", 'displayUseDefault');
            setUseDefaultClickAttribute("copyattributes", 'cpyAttribUseDefault');
            setUseDefaultClickAttribute("log", 'logUseDefault');
        }

        $.each(PREF_TYPE, function (key, value) {
            loadGeneralPreference(value, "server", "SYSTEM", true, runAsAsync, true);
            loadGeneralPreference(value, (type == "SYSTEM" ? "config" : "server"), "USER", (type == "SYSTEM" ? false : true), runAsAsync, true);
        });
    }

    /**
     * Dynamic set click event for UseDefault with event parameters
     * @param {Type} preference 
     * @param {Type} id 
     */
    function setUseDefaultClickAttribute(preference, id) {
        $('#' + id).click({
                preference: preference,
                id: id
            },
            onUseDefaultChanged
        );
    }

    /**
     *Set the default display preference by modality
     */
    function setDefaultLayoutPreferencesByModality(modality) {
        try {
            if (displayPreference === undefined || displayPreference === null) {
                displayPreference = {};
            }

            displayPreference["" + modality + ""] = {
                modality: modality,
                rows: "1",
                columns: "1",
                zoomMode: '100%',
                useEmbedPdfViewer: "false"
            };
        } catch (e) {}
    }

    /**
     * Update the preferences
     * @param {Type} preference - Specifies the preference type
     * @param {Type} preferenceData - Specifies the preference data
     * @param {Type} type - Specifies the preference load type
     * @param {Type} fromServer - Specifies the flag to load from server
     */
    function updatePreferences(preference, preferenceData, type, fromServer) {
        try {
            if ((type == "SYSTEM" || type == "USER") && fromServer) {
                updatePreferenceLoadingStatus(preference, type, preferenceData);
            }

            switch (preference) {
                case "cine":
                    tempCinePreference[type] = $.extend({}, preferenceData);
                    break;
                case "ecg":
                    tempEcgPreference[type] = $.extend({}, preferenceData);
                    break;
                case "layout":
                    if (Array.isArray(preferenceData)) {
                        var data = {};
                        $.each(preferenceData, function (key, value) {
                            data["" + value.Modality + ""] = {
                                modality: value.Modality,
                                rows: value.Rows,
                                columns: value.Columns,
                                zoomMode: value.ZoomMode,
                                useEmbedPdfViewer: (value.isEmbedPDFViewer == undefined) ? "false" : value.isEmbedPDFViewer
                            };
                        });
                        preferenceData = {
                            preference: data,
                            useDefault: false
                        };
                    }
                    tempDisplayPreference[type] = $.extend({}, preferenceData);
                    break;
                case "copyattributes":
                    tempCopyAttribPreference[type] = $.extend({}, preferenceData);
                    break;
                case "log":
                    tempLogPreference[type] = $.extend({}, preferenceData);
                    break;
                default:
                    dumpConsoleLogs(LL_WARN, undefined, "updatePreferences", "Unsupported preference type: " + preference);
                    break;
            }

            if (fromServer) {
                setGeneralConfig(preference, 'config', type, preferenceData);
            }

            if (type == "USER" && preferenceData) {
                type = (preferenceData.useDefault ? "SYSTEM" : "USER");
                preferenceData = loadGeneralPreference(preference, 'config', type, false);
                setGeneralConfig(preference, 'control', type, preferenceData);
            }
        } catch (e) {}
    }

    /**
     * Get general preference from configuration.js
     * @param {Type} preference 
     * @param {Type} loadFrom 
     * @param {Type} type 
     * @param {Type} override 
     */
    function loadGeneralPreference(preference, loadFrom, type, override, runAsAsync, isUpdate) {
        switch (preference) {
            case "cine":
                if (loadFrom == 'server') {
                    getGeneralPreference(preference, type, defaultCinePreference, runAsAsync);
                } else if (loadFrom == 'config') {
                    var preferenceData = dicomViewer.configuration.cine.getCinePreference(type, override);
                    if (isUpdate) {
                        updatePreferences(preference, preferenceData, type, false);
                    }
                    return preferenceData;
                } else if (loadFrom == 'control') {
                    return getCinePreference();
                }
                break;
            case "ecg":
                return;
                if (loadFrom == 'server') {
                    getGeneralPreference(preference, type, defaultEcgPreference, runAsAsync);
                } else if (loadFrom == 'config') {
                    var preferenceData = dicomViewer.configuration.ecg.getEcgPreference(type, override);
                    if (isUpdate) {
                        updatePreferences(preference, preferenceData, type, false);
                    }
                    return preferenceData;
                } else if (loadFrom == 'control') {
                    return getEcgPreference();
                }
                break;
            case "layout":
                if (loadFrom == 'server') {
                    getGeneralPreference(preference, type, defaultDisplayPreference, runAsAsync);
                } else if (loadFrom == 'config') {
                    var preferenceData = dicomViewer.configuration.display.getDisplayPreference(type, override);
                    if (isUpdate) {
                        updatePreferences(preference, preferenceData, type, false);
                    }
                    return preferenceData;
                } else if (loadFrom == 'control') {
                    return getDisplayPreference();
                }
                break;
            case "copyattributes":
                if (loadFrom == 'server') {
                    getGeneralPreference(preference, type, defaultCopyAttributesPreference, runAsAsync);
                } else if (loadFrom == 'config') {
                    var preferenceData = dicomViewer.configuration.copyAttrib.getCopyAttribPreference(type, override);
                    if (isUpdate) {
                        updatePreferences(preference, preferenceData, type, false);
                    }
                    return preferenceData;
                } else if (loadFrom == 'control') {
                    return getCopyAttributesPreference();
                }
                break;
            case "log":
                if (loadFrom == 'server') {
                    getGeneralPreference(preference, type, defaultLogPreference, runAsAsync);
                } else if (loadFrom == 'config') {
                    var preferenceData = dicomViewer.configuration.log.getLogPreference(type, override);
                    if (isUpdate) {
                        updatePreferences(preference, preferenceData, type, false);
                    }
                    return preferenceData;
                } else if (loadFrom == 'control') {
                    return getLogPreference();
                }
                break;
            default:
                return null;
        }
    }

    /**
     * Update general preference in configuration.js
     * @param {Type} preference 
     * @param {Type} loadTo 
     * @param {Type} type 
     * @param {Type} data 
     */
    function setGeneralConfig(preference, loadTo, type, data) {
        switch (preference) {
            case "cine":
                if (loadTo == 'config') {
                    dicomViewer.configuration.cine.setCinePreference(data, type);
                    tempCinePreference[type] = $.extend({}, data);
                } else if (loadTo == 'control') {
                    setCinePreference(data);
                }
                break;
            case "ecg":
                return;
                if (loadTo == 'config') {
                    dicomViewer.configuration.ecg.setEcgPreference(data, type);
                    tempEcgPreference[type] = $.extend({}, data);
                } else if (loadTo == 'control') {
                    setEcgPreference(data);
                }
                break;
            case "layout":
                if (loadTo == 'config') {
                    dicomViewer.configuration.display.setDisplayPreference(data, type);
                    tempDisplayPreference[type] = $.extend({}, data);
                } else if (loadTo == 'control') {
                    setDisplayPreference(data);
                }
                break;
            case "copyattributes":
                if (loadTo == 'config') {
                    dicomViewer.configuration.copyAttrib.setCopyAttribPreference(data, type);
                    tempCopyAttribPreference[type] = $.extend({}, data);
                } else if (loadTo == 'control') {
                    setCopyAttributesPreference(data);
                }
                break;
            case "log":
                if (loadTo == 'config') {
                    dicomViewer.configuration.log.setLogPreference(data, type);
                    tempLogPreference[type] = $.extend({}, data);
                } else if (loadTo == 'control') {
                    setLogPreference(data);
                }
                break;
            default:
                return;
        }
    }

    /**
     * Get request url for specified preference
     * @param {Type} preference 
     */
    function getPrefUrl(preference, type) {
        var requestUrl = null;
        type = (type == 'USER') ? 'user' : 'SYS';
        switch (preference) {
            case "cine":
                requestUrl = dicomViewer.getCineUrl(type);
                break;
            case "ecg":
                requestUrl = dicomViewer.getEcgUrl(type);
                break;
            case "layout":
                requestUrl = dicomViewer.getSettingsUrl(type);
                break;
            case "copyattributes":
                requestUrl = dicomViewer.getCopyAttribUrl(type);
                break;
            case "log":
                requestUrl = dicomViewer.getLogConfigUrl(type);
                break;
            default:
                return null;
        }
        return requestUrl;
    }

    /**
     * Get user/global preference from viewer service
     * @param {Type} preference - Specifies the preference
     * @param {Type} type - Specifies the type
     * @param {Type} defPreferenceData - Specifies the defPreferenceData
     */
    function getGeneralPreference(preference, type, defPreferenceData, runAsAsync) {
        var preferenceData = null;
        var requestUrl = getPrefUrl(preference, type);
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "getGeneralPreference", "Start", undefined, true);
        try {

            if (isServerFailed) {
                //$("#" + preference + "UseDefaultGroup").hide();
                defPreferenceData.useDefault = false;
                preferenceData = $.extend({}, defPreferenceData);
                updatePreferences(preference, preferenceData, type, true);
            } else {
                $("#" + preference + "UseDefaultGroup").show();

                // update the preference loading status
                updatePreferenceLoadingStatus(preference, type);

                $.ajax({
                        url: requestUrl,
                        cache: false,
                        async: (runAsAsync == true ? true : false)
                    })
                    .done(function (data) {
                        if (data) {
                            preferenceData = JSON.parse(data);
                            updatePreferences(preference, preferenceData, type, true);
                            isServerFailed = false;
                        }
                        dumpConsoleLogs(LL_INFO, undefined, (runAsAsync ? "getGeneralPreference" : undefined), "Ajax request for " + preference.toUpperCase() + " preference [" + type.toUpperCase() + "]", undefined, runAsAsync);
                        dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0), runAsAsync);
                    })
                    .fail(function (data) {
                        isServerFailed = true;
                        defPreferenceData.useDefault = false;
                        preferenceData = $.extend({}, defPreferenceData);
                        updatePreferences(preference, preferenceData, type, true);
                    })
                    .error(function (xhr, status) {
                        var description = xhr.statusText + " : Failed to load the " + preference.toUpperCase() + " preference [" + type.toUpperCase() + "] from server";
                        sendViewerStatusMessage(xhr.status.toString(), description);
                        dumpConsoleLogs(LL_ERROR, undefined, (runAsAsync ? "getGeneralPreference" : undefined), description, undefined, runAsAsync);
                    });
            }
        } catch (e) {
            dumpConsoleLogs(LL_ERROR, undefined, (runAsAsync ? "getGeneralPreference" : undefined), e.message, undefined, runAsAsync);
        } finally {

        }

        return preferenceData;
    }

    /**
     * Set user preference to viewer service
     * @param {Type} preference 
     * @param {Type} data 
     */
    function setGeneralPreference(preference, data) {
        var requestUrl = getPrefUrl(preference, "USER");
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "setGeneralPreference", "Start");

        try {

            // update the preference loading status
            updatePreferenceLoadingStatus(preference, "USER", undefined, true);

            $.ajax({
                    type: 'POST',
                    url: requestUrl,
                    data: JSON.stringify(data),
                    beforeSend: function (xhr) {
                        xhr.overrideMimeType("text/plain; charset=x-user-defined");
                    }
                })
                .success(function (data) {
                    updatePreferenceLoadingStatus(preference, "USER", {}, true);
                    dumpConsoleLogs(LL_INFO, undefined, undefined, "End", (Date.now() - t0));
                })
                .fail(function (data) {
                    updatePreferenceLoadingStatus(preference, "USER", null, true);
                })
                .error(function (xhr, status) {
                    var description = xhr.statusText + " : Failed to save the general preferences to server";
                    sendViewerStatusMessage(xhr.status.toString(), description);
                    dumpConsoleLogs(LL_ERROR, undefined, undefined, description);
                });
        } catch (e) {
            dumpConsoleLogs(LL_ERROR, undefined, undefined, e.message);
        } finally {

        }
    }

    /**
     * Set cine preference to controls
     * @param {Type} preference 
     */
    function setCinePreference(data) {
        set('palyselection', data.palyselection, data.useDefault);
        set('timesToRepeat', data.timesToRepeat, data.useDefault);
        set('framesToRepeat', data.framesToRepeat, data.useDefault);
        set('idleTime', data.idleTime, data.useDefault);
        setCheck('cineUseDefault', data.useDefault);
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
            idleTime: get('idleTime'),
            useDefault: getCheck('cineUseDefault')
        };
        return preference;
    }

    /**
     * Set ecg preference to controls
     * @param {Type} preference 
     */
    function setEcgPreference(data) {
        set('ledselection', data.leadType, false);

        $('#ledselection').change();
        setCheck('ecgUseDefault', data.useDefault);
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
            signalValue: get('3x41Value'),
            useDefault: getCheck('ecgUseDefault')
        };
        return preference;
    }

    /**
     * Set display preference to controls
     * @param {Type} preference 
     */
    function setDisplayPreference(data, isClearTable) {
        var tdAction = '"<td><img src="images/edit.png" height="16" size="16" alt="edit" onclick="dicomViewer.generalPreferences.addOrEditHP(this.parentElement.parentElement.childNodes,  &quot;edit&quot;)"><img src="images/delete.png" height="16" size="16" alt="delete" onclick="dicomViewer.generalPreferences.deleteHP(this)"></td>;"'

        var tr = null;
        if (!isClearTable) {
            $("#hpTableList tbody").remove();
        }
        $.each(data.preference, function (key, value) {
            tr = $('<tr/>');
            tr.append("<td>" + value.modality + "</td>");
            tr.append("<td>" + value.rows + "</td>");
            tr.append("<td>" + value.columns + "</td>");
            tr.append("<td>" + value.zoomMode + "</td>");
            tr.append(tdAction);
            $("#hpTableList").append(tr);
        });

        if (data.preference['ECG']) {
            $('#useEmbedPdfViewer')[0].isECGPdf = data.preference['ECG'].useEmbedPdfViewer;
        }
        if (data.preference['General']) {
            $('#useEmbedPdfViewer')[0].isGeneral = data.preference['General'].useEmbedPdfViewer;
        } else {
            $('#useEmbedPdfViewer').val("true");
        }
        setCheck('displayUseDefault', data.useDefault);
        showOrHideHPControls(!data.useDefault);
    }

    /**
     * Get display preference from controls
     * 
     */
    function getDisplayPreference() {
        var displayPreference = {};
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
                displayPreference["" + tdmodality + ""] = {
                    modality: tdmodality,
                    rows: tdData.eq(1).text(),
                    columns: tdData.eq(2).text(),
                    zoomMode: tdData.eq(3).text(),
                    useEmbedPdfViewer: isUseEmbedPdfViewer
                };
            }
        });

        return {
            preference: displayPreference,
            useDefault: getCheck('displayUseDefault')
        };
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
        var data = [];
        data.preference = {};
        var modality = get('modality');
        var tdElement = isExistingModality(modality);
        data.preference[modality] = {
            modality: modality,
            rows: get('layoutRows'),
            columns: get('layoutColumns'),
            zoomMode: get('zoomModeValues'),
            useEmbedPdfViewer: get('useEmbedPdfViewer')
        };

        // Add the new modality settings 
        if (!tdElement) {
            setDisplayPreference(data, true);
        } else {
            tdElement.eq(1).html(data.preference[modality].rows);
            tdElement.eq(2).html(data.preference[modality].columns);
            tdElement.eq(3).html(data.preference[modality].zoomMode);
        }
        onApply('layout');
    }

    /**
     * Edit selected HP Protocol
     * @param {Type}  
     */
    function addOrEditHP(tdElement, action) {
        if ($('#displayUseDefault')[0].checked) {
            return;
        }

        showOrHideHPControls(false);
        showOrHideFooterControls(true);
        $('#displayUseDefault').parent().parent().hide()

        var useDefault = null;
        var modality = null;
        if (action == "edit") {
            useDefault = false;
        } else if (action == "add") {
            selectedHPData = undefined;
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

            if (modality == "General") {
                var value = $('#useEmbedPdfViewer')[0].isGeneral == undefined ? true : $('#useEmbedPdfViewer')[0].isGeneral;
                $('#useEmbedPdfViewer').val(value);
            } else if (modality == "ECG") {
                var value = $('#useEmbedPdfViewer')[0].isECGPdf == undefined ? true : $('#useEmbedPdfViewer')[0].isECGPdf;
                $('#useEmbedPdfViewer').val(value);
            }
            selectedHPData = {
                modality: tdElement[0].innerText,
                rows: tdElement[1].innerText,
                columns: tdElement[2].innerText,
                zoomMode: tdElement[3].innerText,
                useEmbedPdfViewer: $('#useEmbedPdfViewer').val()
            };
        }
        if (action != "selchange") {
            showOrHideHPTable(false);
            set('modality', modality, (action == "edit"));

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
            $('#displayUseDefault').parent().parent().show();
        } else {
            $('#listHangingProtocol').hide();
            $('#addEditHPTable').show();
            $("#modality").change(function () {
                if (this.value == "General" || this.value == "ECG") {
                    if (this.value == "General") {
                        var value = $('#useEmbedPdfViewer')[0].isGeneral == undefined ? true : $('#useEmbedPdfViewer')[0].isGeneral;
                        $('#useEmbedPdfViewer').val(value);
                    } else if (this.value == "ECG") {
                        var value = $('#useEmbedPdfViewer')[0].isECGPdf == undefined ? true : $('#useEmbedPdfViewer')[0].isECGPdf;
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
        if ($('#displayUseDefault')[0].checked) {
            return;
        }
        $(row).closest('tr').remove();

        var modality = $(row).closest('tr').find('td').eq(0).text();

        if (modality == "ECG") {
            $('#useEmbedPdfViewer')[0].isECGPdf = undefined;
        } else if (modality == "General") {
            $('#useEmbedPdfViewer')[0].isGeneral = undefined;
        }
        onApply('layout');
    }

    /**
     * Set copy attributes preference to controls
     * @param {Type} preference 
     */
    function setCopyAttributesPreference(data) {
        setCheck('windowlevel', data.windowLevel, data.useDefault);
        setCheck('brightnesscontrast', data.brightnessContrast, data.useDefault);
        setCheck('scale', data.scale, data.useDefault);
        setCheck('invert', data.invert, data.useDefault);
        setCheck('orientation', data.orientation, data.useDefault);
        setCheck('pan', data.pan, data.useDefault);
        setCheck('cpyAttribUseDefault', data.useDefault);
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
            pan: getCheck('pan'),
            useDefault: getCheck('cpyAttribUseDefault')
        };
        return preference;
    }

    /**
     * Set log preference to controls
     * @param {Type} preference 
     */
    function setLogPreference(data) {
        set('logLevelPref', data.logLevel, data.useDefault);
        set('lineLimitPref', data.lineLimit, data.useDefault);
        setLogPreferenceKey(data.keys, data.useDefault);
        setCheck('logUseDefault', data.useDefault);
    }

    /**
     * Get log preference from controls
     * 
     */
    function getLogPreference() {
        var preference = {
            logLevel: get('logLevelPref'),
            lineLimit: get('lineLimitPref'),
            keys: getLogPreferenceKey(),
            useDefault: getCheck('logUseDefault')
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
     * Parse and set the shortcut key to the control
     * @param {string}   value    shortcut key
     * @param {[[Type]]} disabled enable/disable the menu
     */
    function setLogPreferenceKey(value, disabled) {
        try {
            if (!value) {
                return;
            }

            var splitValue = value.split("+");

            value.indexOf("CTRL") > -1 ? setCheck("ctrlkeyPref", true, disabled) : setCheck("ctrlkeyPref", false, disabled);
            value.indexOf("ALT") > -1 ? setCheck("altkeyPref", true, disabled) : setCheck("altkeyPref", false, disabled);
            value.indexOf("SHIFT") > -1 ? setCheck("shiftkeyPref", true, disabled) : setCheck("shiftkeyPref", false, disabled);
            set("key3Pref", splitValue[splitValue.length - 1], disabled);
        } catch (e) {}
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
     * Set value for given element id
     * @param {Type} id 
     * @param {Type} value 
     * @param {Type} disabled
     */
    function set(id, value, disabled) {
        var element = document.getElementById(id);
        if (element) {
            element.disabled = disabled ? "disabled" : "";
            element.value = value;
        }
    }

    /**
     * Set checked state for given checkbox id
     * @param {Type} id 
     * @param {Type} value 
     * @param {Type} disabled 
     */
    function setCheck(id, value, disabled) {
        var element = document.getElementById(id);
        if (element) {
            element.disabled = disabled ? "disabled" : "";
            element.checked = value;
        }
    }

    /**
     * Apply user preference
     * @param {Type}  
     */
    function onApply(preference) {
        if (preference == "ecg") {
            var format = 4;
            var value = "threebyfourplusone";
            if ($("#ledselection")[0].value == "3x4+3") {
                value = "threebyfourplusthree";
                format = 8;
            }

            // update the preference loading status
            updatePreferenceLoadingStatus(preference, "VIEWPORT", undefined, true);
            updateEcgLeadSignal();
            dicomViewer.leadFormat(format, value);
            $('#applyPref, #resetPref').prop('disabled', true);
            updatePreferenceLoadingStatus(preference, "VIEWPORT", {}, true);
            return;
        }

        if (preference == "cine") {
            if (!isValidCinePreference()) {
                return;
            }
        }

        var data = loadGeneralPreference(preference, 'control');
        var userData = data;
        if (data.useDefault) {
            userData = loadGeneralPreference(preference, 'config', 'USER', false);
            userData.useDefault = true;
        }
        setGeneralConfig(preference, 'config', "USER", userData);
        setGeneralPreference(preference, userData);
        $('#applyPref, #resetPref').prop('disabled', true);
    }

    /**
     * On use default change event
     * @param {Type} parent 
     */
    function onUseDefaultChanged(evt) {
        var checked = $("#" + evt.data.id)[0].checked;
        setUseDefault(evt.data.preference, checked);
    }

    /**
     * Update use default property
     * @param {Type} preference 
     * @param {Type} checked 
     */
    function setUseDefault(preference, checked) {
        var type = "USER";
        var data = null;
        switch (preference) {
            case "cine":
                tempCinePreference[type].useDefault = checked;
                data = tempCinePreference;
                break;
            case "ecg":
                tempEcgPreference[type].useDefault = checked;
                data = tempEcgPreference;
                break;
            case "layout":
                tempDisplayPreference[type].useDefault = checked;
                data = tempDisplayPreference;
                showOrHideHPControls(!checked);
                break;
            case "copyattributes":
                tempCopyAttribPreference[type].useDefault = checked;
                data = tempCopyAttribPreference;
                break;
            case "log":
                tempLogPreference[type].useDefault = checked;
                data = tempLogPreference;
                break;
            default:
                return;
        }
        type = checked ? "SYSTEM" : "USER";
        setGeneralConfig(preference, 'control', type, data[type]);
    }

    /**
     * Check for change in general preference.
     * @param {Type}  activePrefTab
     */
    function sanityCheck(activePrefTab) {
        try {
            var preference = (activePrefTab.toLowerCase().replace('preferences', '').trim().replace(' ', ''));
            if (preference === "ecg") {
                if ($("#ledselection")[0].value !== $("#ledselection")[0].preLeadValue) {
                    return true;
                }

                if ($("#3x41Value")[0].value !== $("#3x41Value")[0].preLeadValue) {
                    return true;
                }

                if ($("#3x43one")[0].value !== $("#3x43one")[0].preLeadValue) {
                    return true;
                }

                if ($("#3x43two")[0].value !== $("#3x43two")[0].preLeadValue) {
                    return true;
                }

                if ($("#3x43three")[0].value !== $("#3x43three")[0].preLeadValue) {
                    return true;
                }
            } else {
                var storedData = loadGeneralPreference(preference, 'config', 'USER', false);
                var currentData = loadGeneralPreference(preference, 'control');
                if (storedData && currentData && storedData.useDefault && currentData.useDefault) {
                    return false;
                }

                return !Object.compare(currentData, storedData);
            }
        } catch (e) {}

        return false;
    }

    /**
     * User discard changes
     * @param {Type}  activePrefTab
     */
    function discardChanges(activePrefTab) {
        try {
            var preference = (activePrefTab.toLowerCase().replace('preferences', '').trim().replace(' ', ''));
            if (preference === "ecg") {
                $("#ledselection").val($("#ledselection")[0].preLeadValue);
                $("#3x41Value").val($("#3x41Value")[0].preLeadValue);
                $("#3x43one").val($("#3x43one")[0].preLeadValue);
                $("#3x43two").val($("#3x43two")[0].preLeadValue);
                $("#3x43three").val($("#3x43three")[0].preLeadValue);
                dicomViewer.changeECGLedType($("#ledselection")[0].preLeadValue);
            } else {
                var type = "USER";
                var storedData = loadGeneralPreference(preference, 'config', type, false);
                if (storedData.useDefault) {
                    type = "SYSTEM";
                    storedData = loadGeneralPreference(preference, 'config', type, false);
                }

                setGeneralConfig(preference, 'control', type, storedData);
            }
        } catch (e) {}
    }

    function resetPreference(activePrefTab) {
        try {
            var preferenceType = activePrefTab.toLowerCase().replace('preferences', '').trim().replace(' ', '')
            if (preferenceType == "annotation") {
                dicomViewer.annotationPreferences.discardChanges();
            } else if (preferenceType == "ecg") {
                $("#ledselection")[0].value = $("#ledselection")[0].preLeadValue;
                $("#3x41Value")[0].value = $("#3x41Value")[0].preLeadValue;
                $("#3x43one")[0].value = $("#3x43one")[0].preLeadValue;
                $("#3x43two")[0].value = $("#3x43two")[0].preLeadValue;
                $("#3x43three")[0].value = $("#3x43three")[0].preLeadValue;
                dicomViewer.changeECGLedType($("#ledselection")[0].value);
            } else {
                var preferenceData = loadGeneralPreference(preferenceType, "config", "USER", false);
                if (preferenceData.useDefault) {
                    preferenceData = loadGeneralPreference(preferenceType, "config", "SYSTEM", false);
                }
                setGeneralConfig(preferenceType, "control", "", preferenceData);
            }
            $('#applyPref, #resetPref').prop('disabled', true);
            if (activePrefTab == "Cine" || activePrefTab == "Annotation") {
                $("#PreferenceAlert").html("");
                $("#PreferenceAlert").hide();
            }
        } catch (e) {}
    }

    /**
     * Enable and disable the apply and reset buttons if preference changed 
     */
    function enableDisablePrefButtons() {
        try {
            var isDirty = false;
            isDirty = (activePrefTab == PREF_PAGE_ANNOTATION) ? dicomViewer.annotationPreferences.sanityCheck(true) : sanityCheck(activePrefTab);

            if (isDirty) {
                $('#applyPref, #resetPref').prop('disabled', false);
            } else {
                $('#applyPref, #resetPref').prop('disabled', true);
            }
        } catch (e) {}
    }

    /**
     * Get the HP data values
     */
    function getHPData() {
        try {
            var HPData = {
                modality: get('modality'),
                rows: get('layoutRows'),
                columns: get('layoutColumns'),
                zoomMode: get('zoomModeValues'),
                useEmbedPdfViewer: $('#useEmbedPdfViewer').val()
            };

            if (HPData.modality == "General") {
                $('#useEmbedPdfViewer')[0].isGeneral = HPData.useEmbedPdfViewer;
            } else if (HPData.modality == "ECG") {
                $('#useEmbedPdfViewer')[0].isECGPdf = HPData.useEmbedPdfViewer;
            }

            return HPData;
        } catch (e) {}
    }

    /**
     * Check is HP values are changed or not
     * @param {Type} HPData - Specifies the current HP controls values
     */
    function isHPChanged(HPData) {
        try {
            if (selectedHPData !== undefined) {
                return !Object.compare(HPData, selectedHPData);
            } else {
                return true;
            }
        } catch (e) {}
    }

    /**
     * Is dirty in HP or not
     */
    function isDirtyinHP() {
        try {
            if (isHPChanged(getHPData())) {
                $('#applyPref').prop('disabled', false);
            } else {
                $('#applyPref').prop('disabled', true);
            }
        } catch (e) {}
    }

    /**
     * Is Valid cine preference or not
     */
    function isValidCinePreference() {
        try {
            var preference = getCinePreference();
            if (preference.framesToRepeat == "" || preference.timesToRepeat == "" || preference.idleTime == "") {
                $("#PreferenceAlert").html('Value should not be empty');
                $("#PreferenceAlert").show();
                return false;
            } else if ((preference.framesToRepeat < 1) || (500 < preference.framesToRepeat) || (preference.timesToRepeat < 1) || (500 < preference.timesToRepeat) || (preference.idleTime < 1) || (500 < preference.idleTime)) {
                $("#PreferenceAlert").html('Value must be between 1 and 500');
                $("#PreferenceAlert").show();
                return false;
            } else {
                $("#PreferenceAlert").html("");
                $("#PreferenceAlert").hide();
            }

            return true;
        } catch (e) {}
    }

    dicomViewer.generalPreferences = {
        updateGeneralPreference: updateGeneralPreference,
        addOrEditHP: addOrEditHP,
        deleteHP: deleteHP,
        updateHPTable: updateHPTable,
        showOrHideHPTable: showOrHideHPTable,
        onUseDefaultChanged: onUseDefaultChanged,
        sanityCheck: sanityCheck,
        discardChanges: discardChanges,
        onApply: onApply,
        resetPreference: resetPreference,
        enableDisablePrefButtons: enableDisablePrefButtons,
        isDirtyinHP: isDirtyinHP,
        isValidCinePreference: isValidCinePreference
    };

    return dicomViewer;

}(dicomViewer));
