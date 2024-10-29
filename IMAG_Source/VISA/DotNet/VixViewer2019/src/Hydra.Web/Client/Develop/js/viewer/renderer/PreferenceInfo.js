/**
 * Preference info class is used to maintain the preference information for ECG.
 * These preference will be maintain at SeriesLevel Layout.
 */
function PreferenceInfo() {
    "use strict";
    // Selected ECG format is used to pass the URL to get images from server.
    this.selectedEcgFormat = {};

    this.windowLevelSettings = 1;

    this.zoomLevelSetting = "1_zoom"

    // ECG Preference with default values.
    this.preferenceData = {
        gridType: 'onemm',
        gridColor: 'redGrid',
        leadFormat: 'threebyfour',
        signalThickness: 'onethickness',
        gain: 'tenmmgain'
    };
}

/**
 * Initialize the preference default values.
 */
PreferenceInfo.prototype.init = function () {
    "use strict";
    this.setGridType('onemm');
    this.setGridColor('redGrid');
    this.setLeadFormat('threebyfourplusthree');
    this.setSignalThickness('onethickness');
    this.setGain('tenmmgain');

    this.addECGParameters("GridType", "1");
    this.addECGParameters("GridColor", "0");
    this.addECGParameters("SignalThickness", "1");
    this.addECGParameters("Gain", "1");
    this.addECGParameters("DrawType", "8");
};

PreferenceInfo.prototype.setWindowLevelSettings = function (windowLevelId) {
    this.windowLevelSettings = windowLevelId;
}

PreferenceInfo.prototype.setZoomLevelSettings = function (zoomLevelSetting) {
    this.zoomLevelSetting = zoomLevelSetting;
}

PreferenceInfo.prototype.getZoomLevelSettings = function (windowLevelId) {
    return this.zoomLevelSetting;
}

PreferenceInfo.prototype.getECGParameters = function () {
    "use strict";
    return this.selectedEcgFormat;
};

PreferenceInfo.prototype.addECGParameters = function (key, value) {
    "use strict";
    this.selectedEcgFormat[key] = value;
};

PreferenceInfo.prototype.getGridType = function () {
    "use strict";
    return this.preferenceData.gridType;
};

PreferenceInfo.prototype.setGridType = function (gridType) {
    "use strict";
    this.preferenceData.gridType = gridType;
};

PreferenceInfo.prototype.getGridColor = function () {
    "use strict";
    return this.preferenceData.gridColor;
};

PreferenceInfo.prototype.setGridColor = function (gridColor) {
    "use strict";
    this.preferenceData.gridColor = gridColor;
};

PreferenceInfo.prototype.getLeadFormat = function () {
    "use strict";
    return this.preferenceData.leadFormat;
};

PreferenceInfo.prototype.setLeadFormat = function (leadFormat) {
    "use strict";
    this.preferenceData.leadFormat = leadFormat;
};

PreferenceInfo.prototype.getGain = function () {
    "use strict";
    return this.preferenceData.gain;
};

PreferenceInfo.prototype.setGain = function (gain) {
    "use strict";
    this.preferenceData.gain = gain;
};

PreferenceInfo.prototype.getSignalThickness = function () {
    "use strict";
    return this.preferenceData.signalThickness;
};

PreferenceInfo.prototype.setSignalThickness = function (signalThickness) {
    "use strict";
    this.preferenceData.signalThickness = signalThickness;
};
