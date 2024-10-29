var dicomViewer = (function (dicomViewer) {
    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var cinePreference = {

    };

    var ecgPreference = {

    };

    var displayPreference = {

    };

    var copyAttributesPreference = {

    };

    var logPreference = {

    };

    function getCinePreference(type, override) {
        if (cinePreference[type] !== undefined) {
            if (cinePreference[type].useDefault && override) {
                type = "SYSTEM";
            }
        }
        return cinePreference[type];
    }

    function setCinePreference(preferenceData, type) {
        if (cinePreference[type] !== undefined) {
            cinePreference[type] = preferenceData;
            if (type == "USER") {
                //updating the cine tool bar repeat study/series according to the cine preferences 
                cineplayBy(getCinePlayBy());
            }
        }
    }

    function getCinePlayBy() {
        var type = "USER";
        if (!cinePreference[type]) {
            return false;
        }
        if (cinePreference[type].useDefault) {
            type = "SYSTEM";
        }

        if (!cinePreference[type]) {
            return false;
        }
        return cinePreference[type].palyselection;
    }

    function setCinePlayBy(playBy) {
        if (cinePreference["USER"] !== undefined) {
            cinePreference["USER"].palyselection = playBy;
        }
    }

    function getFramesToRepeat() {
        var type = "USER";
        if (cinePreference[type].useDefault) {
            type = "SYSTEM";
        }
        return cinePreference[type].framesToRepeat;
    }

    function getTimesToRepeat() {
        var type = "USER";
        if (cinePreference[type].useDefault) {
            type = "SYSTEM";
        }
        return cinePreference[type].timesToRepeat;
    }

    function getIdleTime() {
        var type = "USER";
        if (cinePreference[type].useDefault) {
            type = "SYSTEM";
        }
        return cinePreference[type].idleTime;
    }

    function getEcgPreference(type, override) {
        if (ecgPreference[type].useDefault && override) {
            type = "SYSTEM";
        }
        return ecgPreference[type];
    }

    function setEcgPreference(preferenceData, type) {
        ecgPreference[type] = preferenceData;
    }

    function getDisplayPreference(type, override) {
        if (displayPreference[type].useDefault && override) {
            type = "SYSTEM";
        }
        return displayPreference[type];
    }

    function setDisplayPreference(preferenceData, type) {
        displayPreference[type] = preferenceData;
    }

    function getCopyAttribPreference(type, override) {
        if (copyAttributesPreference[type].useDefault && override) {
            type = "SYSTEM";
        }
        return copyAttributesPreference[type];
    }

    function setCopyAttribPreference(preferenceData, type) {
        copyAttributesPreference[type] = preferenceData;
    }

    function getLogPreference(type, override) {
        if (logPreference[type].useDefault && override) {
            type = "SYSTEM";
        }
        return logPreference[type];
    }

    function setLogPreference(preferenceData, type) {
        logPreference[type] = preferenceData;
        dicomViewer.logUtility.setLogPreference();
    }

    dicomViewer.configuration = {
        cine: {
            getCinePreference: getCinePreference,
            setCinePreference: setCinePreference,
            getCinePlayBy: getCinePlayBy,
            setCinePlayBy: setCinePlayBy,
            getFramesToRepeat: getFramesToRepeat,
            getTimesToRepeat: getTimesToRepeat,
            getIdleTime: getIdleTime
        },
        ecg: {
            getEcgPreference: getEcgPreference,
            setEcgPreference: setEcgPreference
        },
        display: {
            getDisplayPreference: getDisplayPreference,
            setDisplayPreference: setDisplayPreference
        },
        copyAttrib: {
            getCopyAttribPreference: getCopyAttribPreference,
            setCopyAttribPreference: setCopyAttribPreference
        },
        log: {
            getLogPreference: getLogPreference,
            setLogPreference: setLogPreference
        }
    };

    return dicomViewer;

}(dicomViewer));
