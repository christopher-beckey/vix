function ToolList() {
    this.currentTool = TOOLNAME_WINDOWLEVEL;
    this.toolList = new Array();
    this.init();
};

ToolList.prototype.init = function () {
    this.toolList["panTool"] = new Pan();
    this.toolList[TOOLNAME_WINDOWLEVEL] = new WindowLevel();
    this.toolList[TOOLNAME_ZOOM] = new ZoomTool();
    this.toolList[TOOLNAME_WINDOWLEVEL_ROI] = new WindowLevelROI();
};

ToolList.prototype.getActiveTool = function () {
    return this.toolList[this.currentTool];
};

ToolList.prototype.getActiveToolName = function () {
    return this.currentTool;
};

ToolList.prototype.getWindowLevelObject = function () {
    return this.toolList[TOOLNAME_WINDOWLEVEL];
};

ToolList.prototype.getPanToolObject = function () {
    return this.toolList["panTool"];
};

ToolList.prototype.getZoomToolObject = function () {
    return this.toolList[TOOLNAME_ZOOM];
};

ToolList.prototype.getWindowLevelROIObject = function () {
    return this.toolList[TOOLNAME_WINDOWLEVEL_ROI];
};
