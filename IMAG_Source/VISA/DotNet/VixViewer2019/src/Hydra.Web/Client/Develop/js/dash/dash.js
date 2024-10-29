//vvvvvvvvvvv TODO VAI-919: Change var to const vvvvvvvvvv
//VAI-915: Set all URLs and Prefixes upfront
var LOG_URL_APP_PREFIX_PARAM = BASE_LOG_URL + "/settings?Application=";
var LOG_FILE_URL_APP_PREFIX_PARAM = BASE_LOG_URL + "/files?Application=";
var FILE_LIST_URL_APP_PREFIX_PARAM = BASE_LOG_URL + "/events?Application=";

var HEADERS_TITLE_URL = THIS_PAGE_URL + "/testdata/" + TEST_DATA;
var DASHBOARD_STATUS_URL = THIS_PAGE_URL.replace("/dash", "/status");
var ROI_STATUS_URL = BASE_URL + "/roi/status";
var SITE_URL = BASE_URL + "/viewer/site";
var SESSION_URL = BASE_URL + "/viewer/site/500/session";
var STUDY_QUERY_URL = BASE_URL + "/viewer/studyquery";
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

var lastAppliedLogLevel;
var lastAppliedRenderLogLevel;
var pageSize = 12;
var startIndex = 0;
var lastSelectedViewerFileName;
var lastSelectedRenderFileName;
var currentSelectedFileName;
var currentSelectedPageIndex = 0;
var currentSelectedTimeStamp;
var preferenceType = ["cine", "ecg", "annotation", "display", "copyattributes", "log"];

$(document).ready(function () {
    $('#dashboard-viewer-log-sidebar').on('click', function () {
        $('#sidebar').toggleClass('active');
        if ($(this)[0].className === 'navbar-btn dashboard-log-sidebarCollapse') {
            $('#dashboard-viewer-log-left-panel').hide();
            $('#dashboard-viewer-log-right-panel').show();
        } else {
            $('#dashboard-viewer-log-left-panel').show();
            $('#dashboard-viewer-log-right-panel').hide();
        }
        $(this).toggleClass('active');
    });

    $('#dashboard-render-log-sidebar').on('click', function () {
        $('#sidebar1').toggleClass('active');
        if ($(this)[0].className === 'navbar-btn dashboard-log-sidebarCollapse') {
            $('#dashboard-render-log-left-panel').hide();
            $('#dashboard-render-log-right-panel').show();
        } else {
            $('#dashboard-render-log-left-panel').show();
            $('#dashboard-render-log-right-panel').hide();
        }
        $(this).toggleClass('active');
    });

    $('#dashboard-annotation-sidebar').on('click', function () {
        $('#sidebar2').toggleClass('active');
        if ($(this)[0].className === 'navbar-btn dashboard-log-sidebarCollapse') {
            $('#dashboard-annotation-left-panel').hide();
            $('#dashboard-annotation-right-panel').show();
        } else {
            $('#dashboard-annotation-left-panel').show();
            $('#dashboard-annotation-right-panel').hide();
        }
        $(this).toggleClass('active');
    });

    if (window.location.search.indexOf('studydetails') > 0) {
        console.log("Current URL: " + window.location);
        var newURL = BASE_URL + "/" + window.location.search; //VAI-915
        var validURL = newURL.replace("/?", "/");
        console.log("My New URL: " + validURL);
        launchDetailURL(validURL);
    } else {
        console.log("Read base URL { Base url } : " + BASE_URL);
        loadHeadersTitle();
        $("#headerSelectBox").change(function () {
            applyHeaderTitle($("#headerSelectBox option:selected").val());
        });
    }

    // Tab settings
    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        var target = e.target.text;
        if (target == "Configuration") {
            displayAnnotationPreferences();
        }
    });

    $('#cineTab').on('change', function () {
        dicomViewer.systemPreferences.isDirtyCheck("cine");
    });

    $('#ecgTab').on('change', function () {
        dicomViewer.systemPreferences.isDirtyCheck("ecg");
    });

    $('#copyAttrTab').on('change', function () {
        dicomViewer.systemPreferences.isDirtyCheck("copyattributes");
    });

    $('#annotationTab').on('change', function () {
        dicomViewer.systemPreferences.isDirtyCheck("annotation");
    });

    $('#logTab').on('change', function () {
        dicomViewer.systemPreferences.isDirtyCheck("log");
    });

    $('#timepicker1').timepicker();
    $('#timepicker2').timepicker();
});

/**
 * Load dashboard home page 
 **/
function showDashboardHome() {
    hideAndShowTopMenu();
    $('#dashboard-home').show();
    $('#dashboard-topmenu-login').show();
}


/**
 * Load dashboard log page while clicking on dashboard logs image
 **/
function showDashboardLogs() {
    hideAndShowTopMenu();
    $('#dashboard-topmenu-logs-home').show();
    $('#dahsboard-topmenu-home-nav').show();
    $('#dashboard-log-home').show();
    dashboardDisplayViewerLogLevel();
    dashboardDisplayRenderLogLevel();
}

/**
 * Load dashboard viewer log page while clicking on dashboard logs image
 **/
function dashboardDisplayViewerLogLevel() {
    $.ajax({
        type: 'GET',
        url: LOG_URL_APP_PREFIX_PARAM + "VIEWER&SecurityToken=" + SECURITY_TOKEN,
        dataType: 'json',
        async: true,
        success: function (data) {
            console.log("Dashboard Log Level Viewer Url : " + LOG_URL_APP_PREFIX_PARAM + "VIEWER&SecurityToken=" + SECURITY_TOKEN);
            if (!isNullOrUndefined(data)) {
                $('#dashboard-viewer-select-option').val(data.logLevel);
                lastAppliedLogLevel = $("#dashboard-viewer-select-option option:selected").val();
                $('#dashboard-viewer-apply-btn').addClass('disabled');
                dashboardDisplayViewerLogFiles();
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            console.log("The ajax error occurred : " + textStatus);
        }
    });
}

/**
 * Load dashboard render log files page while clicking on dashboard logs image
 **/
function dashboardDisplayRenderLogLevel() {
    $.ajax({
        type: 'GET',
        url: LOG_URL_APP_PREFIX_PARAM + "RENDER&SecurityToken=" + SECURITY_TOKEN,
        dataType: 'json',
        async: true,
        success: function (data) {
            console.log("Dashboard Log Level render Url : " + LOG_URL_APP_PREFIX_PARAM + "RENDER&SecurityToken=" + SECURITY_TOKEN);
            if (!isNullOrUndefined(data)) {
                $('#dashboard-render-select-option').val(data.logLevel);
                lastAppliedRenderLogLevel = $("#dashboard-render-select-option option:selected").val();
                $('#dashboard-render-apply-btn').addClass('disabled');
                dashboardDisplayRenderLogFiles();
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            console.log("The ajax error occurred : " + textStatus);
        }
    });
}

/**
 * Load dashboard viewer log files page while clicking on dashboard logs image
 **/
function dashboardDisplayViewerLogFiles() {
    var d = new Date();
    var n = d.getMilliseconds();
    var viewerCacheUrl = LOG_FILE_URL_APP_PREFIX_PARAM + "VIEWER&_cacheBust=" + n + "&SecurityToken=" + SECURITY_TOKEN;
    $.ajax({
        type: 'GET',
        url: viewerCacheUrl,
        dataType: 'json',
        async: true,
        success: function (data) {
            console.log("Dashboard Log Level Viewer Url : " + viewerCacheUrl);
            if (!isNullOrUndefined(data)) {
                var fileListInformation = "";
                var sliceFileName = "";
                if (!isNullOrUndefined(data.logFileItems) && data.logFileItems.length > 0) {
                    showDashboardViewerAndRenderLogFile(data.logFileItems[0].fileName, data.application, data.logFileItems[0].timeStamp, startIndex);
                    $.each(data.logFileItems, function (index, colData) {
                        sliceFileName = JSON.stringify(colData.fileName);
                        fileListInformation += '<tr><td><a href="#" onclick="showDashboardViewerAndRenderLogFile(\'' + sliceFileName.slice(1, -1) + '\', \'' + data.application + '\', \'' + colData.timeStamp + '\', ' + startIndex + ')">' + colData.fileName + '(' + colData.timeStamp + ')</a></td><tr>';
                    });
                }
            }
            $('#dashboard-viewer-list-files').html('');
            $('#dashboard-viewer-list-files').append(fileListInformation);
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            console.log("The ajax error occurred : " + textStatus);
        }
    });
}

/**
 * Load dashboard render log files page while clicking on dashboard logs image
 **/
function dashboardDisplayRenderLogFiles() {
    var d = new Date();
    var n = d.getMilliseconds();
    var renderCachedUrl = LOG_FILE_URL_APP_PREFIX_PARAM + "RENDER&_cacheBust=" + n + "&SecurityToken=" + SECURITY_TOKEN;
    $.ajax({
        type: 'GET',
        url: renderCachedUrl,
        dataType: 'json',
        async: true,
        success: function (data) {
            console.log("Dashboard Log Level Render Url : " + renderCachedUrl);
            if (!isNullOrUndefined(data)) {
                var fileListInformation = "";
                var sliceFileName = "";
                if (!isNullOrUndefined(data.logFileItems) && data.logFileItems.length > 0) {
                    showDashboardViewerAndRenderLogFile(data.logFileItems[0].fileName, data.application, data.logFileItems[0].timeStamp, startIndex);
                    $.each(data.logFileItems, function (index, colData) {
                        sliceFileName = JSON.stringify(colData.fileName);
                        fileListInformation += '<tr><td><a href="#" onclick="showDashboardViewerAndRenderLogFile(\'' + sliceFileName.slice(1, -1) + '\', \'' + data.application + '\', \'' + colData.timeStamp + '\', ' + startIndex + ')">' + colData.fileName + '(' + colData.timeStamp + ')</a></td><tr>';
                    });
                }
            }
            $('#dashboard-render-list-files').html('');
            $('#dashboard-render-list-files').append(fileListInformation);
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            console.log("The ajax error occurred : " + textStatus);
        }
    });
}

/**
 * Load dashboard viewer and render log content based on 
 * clicking log files from left panel
 **/
function showDashboardViewerAndRenderLogFile(fileName, application, timeStamp, pageIndex) {
    currentSelectedFileName = fileName;
    currentSelectedPageIndex = pageIndex;
    currentSelectedTimeStamp = timeStamp;
    pageIndex = (pageIndex < 0 ? 0 : pageIndex);
    var d = new Date();
    var n = d.getMilliseconds();
    var viewerRenderCachedUrl = FILE_LIST_URL_APP_PREFIX_PARAM + application + "&LogFileName=" + fileName + "&PageSize=" + pageSize + "&PageIndex=" + pageIndex + "&_cacheBust=" + n + "&SecurityToken=" + SECURITY_TOKEN;

    if (application === 'RENDER') {
        $('#dashboard-render-log-header-text').html(fileName + "  ( " + timeStamp + " )");
        if (currentSelectedFileName != lastSelectedRenderFileName) {
            $('#dashboard-render-log-header-text').html('');
            $('#dashboard-render-log-header-text').html(fileName + "  ( " + timeStamp + " )");
        }
        lastSelectedRenderFileName = fileName;

        $.ajax({
            type: 'GET',
            url: viewerRenderCachedUrl,
            dataType: 'json',
            async: true,
            success: function (data) {
                console.log("Dashboard Log Level Render Url : " + FILE_LIST_URL_APP_PREFIX_PARAM + application + "&LogFileName=" + fileName + "&PageSize=" + pageSize + "&PageIndex=" + pageIndex + "&SecurityToken=" + SECURITY_TOKEN);
                if (!isNullOrUndefined(data)) {
                    var fileListInformation = "";
                    if (!isNullOrUndefined(data.logEventItems) && data.logEventItems.length > 0) {
                        $('#dashboard-render-logs-table-body').html('');
                        $.each(data.logEventItems, function (index, colData) {
                            fileListInformation += '<tr><td>' + colData.timeStamp + '</td><td>' + setLogLevelLabel(colData.level) + '</td><td>' + colData.message + '</td><td class="abbreviation">' + colData.parameters + '</td><tr>';
                        });
                    }
                    if (data.more === true) {
                        //var indexVal = parseInt(pageIndex - 1);
                        $('#dashboard-render-logs-table-pagenation').html('');
                        $('#dashboard-render-logs-table-pagenation').html('<button class="btn btn-primary btn-sm disabled" type="button" id="dashboard-render-log-previous-btn" onclick="showDashboardViewerAndRenderLogFile(\'' + fileName + '\', \'' + application + '\', \'' + timeStamp + '\',' + parseInt(pageIndex - 1) + ')">Previous</button>&nbsp;&nbsp<button class="btn btn-primary btn-sm" id="dashboard-render-log-next-btn" type="button" onclick="showDashboardViewerAndRenderLogFile(\'' + fileName + '\', \'' + application + '\', \'' + timeStamp + '\',' + parseInt(pageIndex + 1) + ')">Next</button>');

                        if (pageIndex != 0) {
                            $('#dashboard-render-log-previous-btn').removeClass('disabled');
                        }
                    } else {
                        //$('#displayRenderPagination').html('');
                        if (pageIndex == 0) {
                            $('#dashboard-render-logs-table-pagenation').html('');
                        } else {
                            $('#dashboard-render-log-previous-btn').removeClass('disabled');
                            $('#dashboard-render-log-next-btn').addClass('disabled');
                        }
                    }
                }
                $('#dashboard-render-logs-table-body').append(fileListInformation);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log("The ajax error occurred : " + textStatus);
            }
        });
    } else if (application === 'VIEWER') {
        $('#dashboard-viewer-log-header-text').html(fileName + "  ( " + timeStamp + " )");
        if (currentSelectedFileName != lastSelectedViewerFileName) {
            $('#dashboard-viewer-log-header-text').html('');
            $('#dashboard-viewer-log-header-text').html(fileName + "  ( " + timeStamp + " )");
        }
        lastSelectedViewerFileName = fileName;
        $.ajax({
            type: 'GET',
            url: viewerRenderCachedUrl,
            dataType: 'json',
            async: true,
            success: function (data) {
                console.log("Dashboard Log Level viewer Url : " + FILE_LIST_URL_APP_PREFIX_PARAM + application + "&LogFileName=" + fileName + "&PageSize=" + pageSize + "&PageIndex=" + pageIndex + "&SecurityToken=" + SECURITY_TOKEN);
                if (!isNullOrUndefined(data)) {
                    var fileListInformation = "";
                    if (!isNullOrUndefined(data.logEventItems) && data.logEventItems.length > 0) {
                        $('#dashboard-viewer-logs-table-body').html('');
                        $.each(data.logEventItems, function (index, colData) {
                            fileListInformation += '<tr><td>' + colData.timeStamp + '</td><td>' + setLogLevelLabel(colData.level) + '</td><td>' + colData.message + '</td><td class="abbreviation">' + colData.parameters + '</td><tr>';
                        });
                    }

                    if (data.more === true) {
                        $('#dashboard-viewer-logs-table-pagenation').html('');
                        $('#dashboard-viewer-logs-table-pagenation').html('<button id="dashboardPreviousLogButton" class="btn btn-primary btn-sm disabled" type="button" onclick="showDashboardViewerAndRenderLogFile(\'' + fileName + '\', \'' + application + '\', \'' + timeStamp + '\',' + parseInt(pageIndex - 1) + ')">Previous</button>&nbsp;&nbsp<button  class="btn btn-primary btn-sm" type="button" id="dashboardNextLogButton" onclick="showDashboardViewerAndRenderLogFile(\'' + fileName + '\', \'' + application + '\', \'' + timeStamp + '\',' + parseInt(pageIndex + 1) + ')">Next</button>');

                        if (pageIndex == 0) {
                            $('#dashboardPreviousLogButton').addClass('disabled');
                        } else {
                            $('#dashboardPreviousLogButton').removeClass('disabled');
                        }
                    } else {
                        if (pageIndex == 0) {
                            /*$('#displayPagination').html('');*/
                            $('#dashboardPreviousLogButton').hide();
                            $('#dashboardNextLogButton').hide();
                        } else {
                            $('#dashboardNextLogButton').addClass('disabled');
                            $('#dashboardPreviousLogButton').removeClass('disabled');
                        }
                    }
                }
                $('#dashboard-viewer-logs-table-body').append(fileListInformation);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log("The ajax error occurred : " + textStatus);
            }
        });
    }
}


function dashboardRefreshLogFile(application) {
    currentSelectedPageIndex = (currentSelectedPageIndex < 0 ? 0 : currentSelectedPageIndex);
    var d = new Date();
    var n = d.getMilliseconds();
    var viewerRenderCachedUrl = FILE_LIST_URL_APP_PREFIX_PARAM + application + "&LogFileName=" + currentSelectedFileName + "&PageSize=" + pageSize + "&PageIndex=" + currentSelectedPageIndex + "&_cacheBust=" + n + "&SecurityToken=" + SECURITY_TOKEN;
    if (application === 'RENDER') {
        $('#dashboard-render-log-header-text').html(currentSelectedFileName + "  ( " + currentSelectedTimeStamp + " )");
        if (currentSelectedFileName != lastSelectedRenderFileName) {
            $('#dashboard-render-log-header-text').html('');
            $('#dashboard-render-log-header-text').html(currentSelectedFileName + "  ( " + currentSelectedTimeStamp + " )");
        }
        lastSelectedRenderFileName = currentSelectedFileName;
        $.ajax({
            type: 'GET',
            url: viewerRenderCachedUrl,
            dataType: 'json',
            async: true,
            success: function (data) {
                console.log("Dashboard Log Level Render Url : " + FILE_LIST_URL_APP_PREFIX_PARAM + application + "&LogFileName=" + currentSelectedFileName + "&PageSize=" + pageSize + "&PageIndex=" + currentSelectedPageIndex + "&SecurityToken=" + SECURITY_TOKEN);
                if (!isNullOrUndefined(data)) {
                    var fileListInformation = "";
                    if (!isNullOrUndefined(data.logEventItems) && data.logEventItems.length > 0) {
                        $('#dashboard-render-logs-table-body').html('');
                        $.each(data.logEventItems, function (index, colData) {
                            fileListInformation += '<tr><td>' + colData.timeStamp + '</td><td>' + setLogLevelLabel(colData.level) + '</td><td>' + colData.message + '</td><td class="abbreviation">' + colData.parameters + '</td><tr>';
                        });
                    }
                    if (data.more === true) {
                        //var indexVal = parseInt(pageIndex - 1);
                        $('#dashboard-render-logs-table-pagenation').html('');
                        $('#dashboard-render-logs-table-pagenation').html('<button class="btn btn-primary btn-sm disabled" type="button" id="dashboard-render-previous-btn" onclick="showDashboardViewerAndRenderLogFile(\'' + currentSelectedFileName + '\', \'' + application + '\', \'' + currentSelectedTimeStamp + '\',' + parseInt(currentSelectedPageIndex - 1) + ')">Previous</button>&nbsp;&nbsp<button class="btn btn-primary btn-sm" id="dashboard-render-next-btn" type="button" onclick="showDashboardViewerAndRenderLogFile(\'' + currentSelectedFileName + '\', \'' + application + '\', \'' + currentSelectedTimeStamp + '\',' + parseInt(currentSelectedPageIndex + 1) + ')">Next</button>');

                        if (currentSelectedPageIndex != 0) {
                            $('#dashboard-render-previous-btn').removeClass('disabled');
                        }
                    } else {
                        //$('#displayRenderPagination').html('');
                        if (currentSelectedPageIndex == 0) {
                            $('#dashboard-render-logs-table-pagenation').html('');
                        } else {
                            $('#dashboard-render-previous-btn').removeClass('disabled');
                            $('#dashboard-render-next-btn').addClass('disabled');
                        }
                    }
                }
                $('#dashboard-render-logs-table-body').append(fileListInformation);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log("The ajax error occurred : " + textStatus);
            }
        });
    } else if (application === 'VIEWER') {
        $('#dashboard-viewer-log-header-text').html(currentSelectedFileName + "  ( " + currentSelectedTimeStamp + " )");
        if (currentSelectedFileName != lastSelectedViewerFileName) {
            $('#dashboard-viewer-log-header-text').html('');
            $('#dashboard-viewer-log-header-text').html(currentSelectedFileName + "  ( " + currentSelectedTimeStamp + " )");
        }
        lastSelectedViewerFileName = currentSelectedFileName;
        $.ajax({
            type: 'GET',
            url: viewerRenderCachedUrl,
            dataType: 'json',
            async: true,
            success: function (data) {
                console.log("Dashboard Log Level Viewer Url : " + FILE_LIST_URL_APP_PREFIX_PARAM + application + "&LogFileName=" + currentSelectedFileName + "&PageSize=" + pageSize + "&PageIndex=" + currentSelectedPageIndex + "&SecurityToken=" + SECURITY_TOKEN);
                if (!isNullOrUndefined(data)) {
                    var fileListInformation = "";
                    if (!isNullOrUndefined(data.logEventItems) && data.logEventItems.length > 0) {
                        $('#dashboard-viewer-logs-table-body').html('');
                        $.each(data.logEventItems, function (index, colData) {
                            fileListInformation += '<tr><td>' + colData.timeStamp + '</td><td>' + setLogLevelLabel(colData.level) + '</td><td>' + colData.message + '</td><td class="abbreviation">' + colData.parameters + '</td><tr>';
                        });
                    }

                    if (data.more === true) {
                        $('#dashboard-viewer-logs-table-pagenation').html('');
                        $('#dashboard-viewer-logs-table-pagenation').html('<button id="dashboard-viewer-prev-btn" class="btn btn-primary btn-sm disabled" type="button" onclick="showDashboardViewerAndRenderLogFile(\'' + currentSelectedFileName + '\', \'' + application + '\', \'' + currentSelectedTimeStamp + '\',' + parseInt(currentSelectedPageIndex - 1) + ')">Previous</button>&nbsp;&nbsp<button  class="btn btn-primary btn-sm" type="button" id="dashboard-viewer-next-btn" onclick="showDashboardViewerAndRenderLogFile(\'' + currentSelectedFileName + '\', \'' + application + '\', \'' + currentSelectedTimeStamp + '\',' + parseInt(currentSelectedPageIndex + 1) + ')">Next</button>');

                        if (currentSelectedPageIndex == 0) {
                            $('#dashboard-viewer-prev-btn').addClass('disabled');
                        } else {
                            $('#dashboard-viewer-prev-btn').removeClass('disabled');
                        }
                    } else {
                        if (currentSelectedPageIndex == 0) {
                            /*$('#displayPagination').html('');*/
                            $('#dashboard-viewer-prev-btn').hide();
                            $('#dashboard-viewer-next-btn').hide();
                        } else {
                            $('#dashboard-viewer-next-btn').addClass('disabled');
                            $('#dashboard-viewer-prev-btn').removeClass('disabled');
                        }
                    }
                }
                $('#dashboard-viewer-logs-table-body').append(fileListInformation);
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log("The ajax error occurred : " + textStatus);
            }
        });
    }
}

/**
 * set dashboard log level action by passing loglevel while clicking on apply button
 **/
function doDashboardViewerAndRenderApplyLogLevel(type) {
    if (type == "VIEWER") {
        dashboardSetLogLevel("VIEWER", $("#dashboard-viewer-select-option option:selected").val());
    } else {
        dashboardSetLogLevel("RENDER", $("#dashboard-render-select-option option:selected").val());
    }
}

/**
 * set dashboard log level action by passing loglevel while clicking on apply button
 **/
function dashboardSetLogLevel(type, loglevel) {
    $.ajax({
        type: 'POST',
        url: LOG_URL_APP_PREFIX_PARAM + type + "&LogLevel=" + loglevel + "&SecurityToken=" + SECURITY_TOKEN,
        async: true,
        cache: false,
        success: function (data) {
            console.log("Dashboard Log Level Url : " + LOG_URL_APP_PREFIX_PARAM + type + "&LogLevel=" + loglevel + "&SecurityToken=" + SECURITY_TOKEN);
            if (type == "VIEWER") {
                $('#dashboard-viewer-select-option').val(loglevel);
                lastAppliedLogLevel = loglevel;
                dashboardDisplayViewerLogFiles();
            } else {
                $('#dashboard-render-select-option').val(loglevel);
                lastAppliedRenderLogLevel = loglevel;
                dashboardDisplayRenderLogFiles();
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            console.log("The ajax error occurred : " + textStatus);
        }
    });
}

/**
 * set dashboard log level action by passing loglevel
 **/
function setLogLevelLabel(logLevel) {
    var logLevelLabel;
    if (logLevel === 'DEBUG') {
        logLevelLabel = "<span class='label label-primary'>" + logLevel + "</span";
    } else if (logLevel === 'INFO') {
        logLevelLabel = "<span class='label label-success'>" + logLevel + "</span";
    } else if (logLevel === 'WARN') {
        logLevelLabel = "<span class='label label-warning'>" + logLevel + "</span";
    } else if (logLevel === 'ERROR') {
        logLevelLabel = "<span class='label label-danger'>" + logLevel + "</span";
    } else if (logLevel === 'TRACE') {
        logLevelLabel = "<span class='label label-info'>" + logLevel + "</span";
    }
    return logLevelLabel;
}

/**
 * load dashboard viewer log with json format
 **/
$(document).on("click", "#dashboard-viewer-log-table tbody tr", function (e) {
    var param = $(this).find(".abbreviation").html();
    if (!isNullOrUndefined(param) && param !== "") {
        $("#dashboard-viewer-log-json-format").JSONView(JSON.stringify(getJson(param)));
    } else {
        console.log('The parameter contains empty string');
        $("#dashboard-viewer-log-json-format").html("The parameter contains empty string");
    }
});

/**
 * load dashboard render log with json format
 **/
$(document).on("click", "#dashboard-render-log-table tr", function (e) {
    var param = $(this).find(".abbreviation").html();
    if (!isNullOrUndefined(param) && param !== "") {
        $("#dashboard-render-log-json-format").JSONView(JSON.stringify(getJson(param)));
    } else {
        console.log('The parameter contains empty string');
        $("#dashboard-render-log-json-format").html("The parameter contains empty string");
    }
});


function removeAllLogFiles(type) {
    $("#logViewerAndRenderModal").modal();
    if (type == "VIEWER") {
        $('#btnRenderLog').hide();
        $('#btnViewerLog').show();
    } else {
        $('#btnViewerLog').hide();
        $('#btnRenderLog').show();
    }
}

function removeViewerLogFile(type) {
    if (type == "VIEWER") {
        $.ajax({
            type: 'DELETE',
            url: LOG_FILE_URL_APP_PREFIX_PARAM + type + "&SecurityToken=" + SECURITY_TOKEN,
            success: function (data) {
                $('#logViewerAndRenderModal').modal('hide');
                dashboardDisplayViewerLogFiles();
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log("The ajax error occurred : " + textStatus);
            }
        });
    } else {
        $.ajax({
            type: 'DELETE',
            url: LOG_FILE_URL_APP_PREFIX_PARAM + type + "&SecurityToken=" + SECURITY_TOKEN,
            success: function (data) {
                $('#logViewerAndRenderModal').modal('hide');
                dashboardDisplayRenderLogFiles();
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log("The ajax error occurred : " + textStatus);
            }
        });
    }
}

function clearAllLogs(type) {
    $("#clearLogViewerAndRenderModal").modal();
    if (type == "VIEWER") {
        $('#btnClearRenderLog').hide();
        $('#btnClearViewerLog').show();
    } else {
        $('#btnClearViewerLog').hide();
        $('#btnClearRenderLog').show();
    }
}

function clearViewerLogFile(type) {
    if (type == "VIEWER") {
        $.ajax({
            type: 'DELETE',
            url: LOG_FILE_URL_APP_PREFIX_PARAM + type + "&LogFileName=" + lastSelectedViewerFileName + "&SecurityToken=" + SECURITY_TOKEN,
            success: function (data) {
                $('#clearLogViewerAndRenderModal').modal('hide');
                dashboardDisplayViewerLogFiles();
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log("The ajax error occurred : " + textStatus);
            }
        });
    } else {
        $.ajax({
            type: 'DELETE',
            url: LOG_FILE_URL_APP_PREFIX_PARAM + type + "&LogFileName=" + lastSelectedRenderFileName + "&SecurityToken=" + SECURITY_TOKEN,
            success: function (data) {
                $('#clearLogViewerAndRenderModal').modal('hide');
                dashboardDisplayRenderLogFiles();
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log("The ajax error occurred : " + textStatus);
            }
        });
    }
}


/**
 * Load dashboard search page while clicking on dashboard search image
 **/
function showDashboardSearch() {
    hideAndShowTopMenu();
    $('#dashboard-topmenu-search-home').show();
    $('#dahsboard-topmenu-home-nav').show();
    $('#dashboard-search-home').show();

}

/* 
 * load all the title of the headers in select box 
 */
function loadHeadersTitle() {
    console.log("Reader header url : " + HEADERS_TITLE_URL);
    $.ajax({
        type: 'GET',
        url: HEADERS_TITLE_URL,
        dataType: 'json',
        success: function (data) {
            if (!isNullOrUndefined(data)) {
                console.log("The length of the header : " + data.items.length);
                if (!isNullOrUndefined(data.items) && data.items.length > 0) {
                    $.each(data.items, function (index, colData) {
                        $('#headerSelectBox').append('<option value="' + colData.header.name + '">' + colData.title + '</option>');
                    });
                }
                applyHeaderTitle($("#headerSelectBox option:selected").val());
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            console.log("The ajax error occurred : " + textStatus);
        }
    });
}

/** 
 *  select header title from the select box and click on apply button. The following code will do the action of apply 
 *  button and display headers and body text 
 */
function applyHeaderTitle(optionSelectedVal) {
    console.log("Selected Option Value : " + optionSelectedVal);
    var headerTitle = $('#headerSelectBox option:selected').html()
    console.log("Header title : " + headerTitle);
    $.ajax({
        type: 'GET',
        url: HEADERS_TITLE_URL,
        dataType: 'json',
        success: function (data) {
            console.log("Header title length : " + data.items.length);
            var headerVal = [];
            for (i = 0; i < data.items.length; i++) {
                var bashItems = data.items[i];
                if (headerTitle.trim() == bashItems.title) {
                    if (!bashItems.type) {
                        bashItems.type = 'STUDYQUERY';
                    }

                    $('#queryType').val(bashItems.type);
                    if (bashItems.type == 'STUDYQUERY') {
                        $('#requestUrl').val(STUDY_QUERY_URL);
                        console.log("Displaying study query url : " + STUDY_QUERY_URL);
                    } else if (bashItems.type == 'ROI') {
                        $('#requestUrl').val(ROI_STATUS_URL);
                        console.log("Displaying roi status url : " + ROI_STATUS_URL);
                    }

                    if (bashItems.header.name == optionSelectedVal && bashItems.header.items.length > 0 || bashItems.header.name != optionSelectedVal && bashItems.header.items.length > 0) {
                        for (var i = 0; i < bashItems.header.items.length; i++) {
                            headerVal.push(bashItems.header.items[i].key + ":" + bashItems.header.items[i].value);
                        }
                        $('#headerText').val(headerVal);
                    } else if (bashItems.header.name == optionSelectedVal && bashItems.header.items.length == 0) {
                        for (var index = 0; index < data.headers.length; index++) {
                            if (data.headers[index].name == optionSelectedVal) {
                                for (var i = 0; i < data.headers[index].items.length; i++) {
                                    headerVal.push(data.headers[index].items[i].key + ":" + data.headers[index].items[i].value);
                                    headerVal.push("\n");
                                }
                            }
                        }
                        $('#headerText').val(headerVal.join(' '));
                    } else {
                        console.log("There is no item available in this header");
                    }
                    $('#bodyText').val(JSON.stringify(bashItems.body, undefined, 4));
                    return;
                }
            }
        }
    });
}

/**
 * This method is used to fetch all the study information based on requestUrl.The following informations are read from the user.
 */
function fetchStudyInformation() {
    var requestUrl = $('#requestUrl').val();
    var headerTextVal = $("#headerText").val();
    var contents = $('#bodyText').val();
    var queryType = $('#queryType').val();

    if (requestUrl == null || requestUrl == "") {
        alert("Request URL must not be null");
        $('#requestUrl').focus();
    } else if (headerTextVal == null || headerTextVal == "") {
        alert("Headers must not be null");
        $('#headerText').focus();
    } else if (contents == null || contents == "") {
        alert("Body must not be null");
        $('#bodyText').focus();
    } else {
        console.log(requestUrl);
        $("#ajax_loader").show();
        var headerArr = headerTextVal.split('\n');
        var headers = {};
        $.each(headerArr, function (index, colData) {
            var head = colData.split(':');
            if (head[0] !== '') {
                headers[head[0].trim()] = head[1].trim();
            }
        });

        if (queryType == 'STUDYQUERY') {
            $.ajax({
                url: requestUrl,
                data: contents.trim(),
                headers: headers,
                method: 'POST',
                dataType: 'json',
                async: true,
                success: function (data) {
                    // fetch all the patient and study information and display it
                    if (!isNullOrUndefined(data.patientICN)) {
                        $('#patientICN').html("PatientICN : " + data.patientICN);
                    }

                    if (!isNullOrUndefined(data.patientDFN)) {
                        $('#patientDFN').html("PatientDFN : " + data.patientDFN);
                    }

                    if (!isNullOrUndefined(data.siteNumber)) {
                        $('#siteNumber').html("Site Number : " + data.siteNumber);
                    }

                    if (!isNullOrUndefined(data.authSiteNumber)) {
                        $('#authSiteNumber').html("AuthSiteNumber : " + data.authSiteNumber);
                    }

                    if (!isNullOrUndefined(data.userId)) {
                        $('#userId').html("User ID : " + data.userId);
                    }

                    if (!isNullOrUndefined(data.authSiteNumber)) {
                        $('#authSiteNumberVal').val(data.authSiteNumber);
                    }

                    if (data.studies && data.studies.length > 0 && !isNullOrUndefined(data.studies[0].securityToken)) {
                        $('#securityToken').val(data.studies[0].securityToken);
                        console.log("Total no of studies loaded : " + data.studies.length);
                    }

                    //Display all the study information in dataTAble

                    var studyInformation = "";
                    if (!isNullOrUndefined(data)) {
                        if (!isNullOrUndefined(data.studies) && data.studies.length > 0) {
                            $.each(data.studies, function (index, dataVal) {
                                studyInformation += '<tr><td class="wrap_words">' + dataVal.groupIEN + '</td><td class="wrap_words">' + dataVal.imageCount + '</td><td>' + dataVal.studyId +
                                    '</td><td class="wrap_words">' + dataVal.event + '</td><td class="wrap_words">' + formatDate(dataVal.studyDate) + '</td><td class="wrap_words">' + dataVal.procedureDescription + '</td><td class="wrap_words">' + dataVal.specialtyDescription +
                                    '</td><td>' +
                                    '<a class="btn btn-warning btn-sm" onClick="viewStudy(\'' + dataVal.viewerUrl + '\', ' + index + ')">View</a>&nbsp;' +
                                    '<a id="addToSession_' + index + '" class="btn btn-info btn-sm addToSession" onClick="addToSession(\'' + dataVal.contextId + '\', \'' + dataVal.securityToken + '\',\'' + dataVal.patientICN + '\',\'' + dataVal.patientDFN + '\',\'' + dataVal.siteNumber + '\', \'' + data.authSiteNumber + '\')" style="display: none">Add</a>&nbsp;' +
                                    '<a href="#" class="btn btn-primary btn-sm" onClick="launchManageURL(\'' + dataVal.manageUrl + '\')">Manage</a>&nbsp;' +
                                    '<a href="#" class="btn btn-success btn-sm" onClick="launchDetailsURL(\'' + dataVal.detailsUrl + '&IncludeImageDetails=true' + '\')">Details</a>&nbsp;' +
                                    '<a href="#" class="btn btn-primary btn-sm" onClick="launchReportURL(\'' + dataVal.reportUrl + '\')">Report</a>&nbsp;' +
                                    '<a class="btn btn-danger btn-sm" onClick="loadPurgeStudy(\'' + dataVal.viewerUrl + '\',\'' + dataVal.studyId + '\')">Purge</a>&nbsp;' +
                                    '</td></tr>';
                            });
                        }
                    }
                    $('#patientInformation').hide();
                    $('#studyInfoTable').DataTable().destroy();
                    $('#studyInfo').html('');
                    $('#studyInfo').append(studyInformation);
                    // Display data in the dataTable
                    var table = $('#studyInfoTable').DataTable({
                        "bDestroy": true,
                        "bAutoWidth": false,
                        "bFilter": true,
                        "bSort": true,
                        "aaSorting": [[0]],
                        "lengthMenu": [[5, 10, 15, -1], [5, 10, 15, "All"]],
                        "pageLength": 5,
                        "aoColumns": [
                            {
                                "sWidth": '1%',
                                "bSortable": true
                            },
                            {
                                "sWidth": '1%',
                                "bSortable": true
                            },
                            {
                                "sWidth": '15%',
                                "bSortable": true
                            },
                            {
                                "sWidth": '1%',
                                "bSortable": true
                            },
                            {
                                "sWidth": '5%',
                                "bSortable": true
                            },
                            {
                                "sWidth": '1%',
                                "bSortable": true
                            },
                            {
                                "sWidth": '5%',
                                "bSortable": true
                            },
                            {
                                "sWidth": '25%',
                                "bSortable": false
                            }
                        ]
                    });
                    $('#container').css('display', 'block');
                    table.columns.adjust().draw();
                    $("#ajax_loader").hide();
                    $('#sudyInformation').show();
                },
                error: function (xhr, status) {
                    $("#ajax_loader").hide();
                    alert("Connection problem with Server");
                }
            });
        } else if (queryType == 'ROI') {
            $.ajax({
                type: 'GET',
                url: requestUrl,
                headers: headers,
                dataType: 'json',
                success: function (data) {
                    console.log("Display available patient information length :" + data.length);
                    //Display all the patient information in dataTAble
                    var patientInformation = "";
                    if (!isNullOrUndefined(data) && data.length > 0) {
                        $.each(data, function (index, colData) {
                            var dicomRouting = isNullOrUndefined(colData.dicomRouting) ? "" : colData.dicomRouting;
                            patientInformation += '<tr><td>' + colData.patientName + '</td><td>' + colData.SLast4 + '</td><td>' + colData.patientId + '</td><td>' + colData.status + '</td><td>' + colData.lastUpdated + '</td><td>' + dicomRouting + '</td></tr>';
                        });
                    }
                    $('#sudyInformation').hide();
                    $('#patientInfoTable').DataTable().destroy();
                    $('#patientInfo').html('');
                    $('#patientInfo').append(patientInformation);
                    // Display data in the dataTable
                    var table = $('#patientInfoTable').DataTable({
                        "bDestroy": true,
                        "bAutoWidth": false,
                        "bFilter": true,
                        "bSort": true,
                        "aaSorting": [[0]],
                        "lengthMenu": [[5, 10, 15, -1], [5, 10, 15, "All"]],
                        "pageLength": 5,
                        "aoColumns": [
                            {
                                "sWidth": '10%',
                                "bSortable": true
                            },
                            {
                                "sWidth": '10%',
                                "bSortable": true
                            },
                            {
                                "sWidth": '10%',
                                "bSortable": true
                            },
                            {
                                "sWidth": '10%',
                                "bSortable": true
                            },
                            {
                                "sWidth": '10%',
                                "bSortable": true
                            },
                            {
                                "sWidth": '10%',
                                "bSortable": true
                            }
                        ]
                    });
                    $('#container').css('display', 'block');
                    table.columns.adjust().draw();
                    $("#ajax_loader").hide();
                    $('#patientInformation').show();
                },
                error: function (xhr, status) {
                    $("#ajax_loader").hide();
                    alert("Connection problem with Server");
                }
            });
        }
    }
}

// Load modal window for purging the study 
function loadPurgeStudy(viewerUrl, studyId) {
    $("#purgeStudyModal").modal();
    $('#purgeStudyID').html(studyId);
    $('#viewerURL').val(viewerUrl);
    $('#studyPurgeID').val(studyId);
}

// Purge action 
function purgeStudy() {
    var viewerUrl = $('#viewerURL').val();
    var studyId = $('#studyPurgeID').val();

    var purgeUrl = viewerUrl.replace("loader?", "context?");

    $.ajax({
        type: 'DELETE',
        url: addLoginPageFlag(purgeUrl),
        success: function (data) {
            $("#purgeStudyResult").text("Successfully purged the current study.");
        },
        error: function (xhr, status) {
            if (xhr.statusText.length > 0)
                $("#purgeStudyResult").text("An error occurred: " + xhr.statusText);
            else
                $("#purgeStudyResult").text("An unknown error occurred on the server.");
        },
        complete: function (data) {
            $("#purgeStudyModalPrompt").hide();
            $(".purgeStudyPrompt").hide();
            $("#purgeStudyModalResult").show();
            $(".purgeStudyDone").show();
        }
    });
}

function donePurgeStudy() {
    $("#purgeStudyModal").modal('hide');
    $("#purgeStudyModalPrompt").show();
    $(".purgeStudyPrompt").show();
    $("#purgeStudyModalResult").hide();
    $(".purgeStudyDone").hide();
    $("#purgeStudyResult").text("");
}

/**
 * launch the report url in new tab
 */
function launchReportURL(reportUrl) {
    console.log("Launch report url :" + reportUrl);
    window.open(addLoginPageFlag(reportUrl));
    return false;
}

function launchDetailsURL(detailsUrl) {
    var win = window.open(detailsUrl, '_blank');
    $.ajax({
        type: 'GET',
        url: addLoginPageFlag(detailsUrl),
        dataType: 'json',
        success: function (data) {
            console.log(detailsUrl);
            //TODO: jquery.12.4.min.js
            win.document.write('<html><head><title>' + detailsUrl + '</title><link rel="stylesheet" type="text/css" href="../style/jquery.jsonview.css"><script type="text/javascript" src="' + BASE_URL + '/js/jquery-1.1.1.js"></script><script type="text/javascript" src="' + BASE_URL + '/js/jquery.jsonview.js"></script></head><body><div id="content"></div><script>$("#content").JSONView(' + JSON.stringify(data) + ')</script>');
            win.document.write('</body></html>');
            win.focus();
        }
    });
}

function formatDate(date) {
    var d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;

    return [year, month, day].join('-');
}

/**
 * launch the manage url in new tab
 */
function launchManageURL(manageUrl) {
    var newUrl = addLoginPageFlag(manageUrl);
    console.log("Launch manage url :" + newUrl);
    window.open(newUrl);
    return false;
}

/**
 * launch the details url in new tab
 */
function launchDetailURL(detailsUrl) {
    console.log("Requested details url :" + detailsUrl);
    $('#headerID').hide();
    $('#footerID').hide();
    $('#hrID').hide();
    $('#exTab2').hide();
    $('#console-log-div').hide();
    $('#sudyInformation').hide();
    $('#patientInformation').hide();
    $.ajax({
        type: 'GET',
        url: detailsUrl,
        dataType: 'json',
        success: function (data) {
            console.log("Launch the detail url : " + JSON.stringify(data, undefined, 4));
            $('#displayDetailInformation').JSONView(data);
            $('#displayDetailInformation').show();
        }
    });

}

/** 
 * Clicking on this should call the session status endpoint that returns a list of studies currently displayed and idle time.
 * Place a Remove button next to each displayed study item. The study list can display either in a popup or as an expandable panel.
 */
function loadStatusAction() {
    var sessionId = $('#sessionId').val();
    var securityToken = $('#securityToken').val();
    console.log("Reading the input from the hidden text box as SessionId, SecurityToken  : " + sessionId + "," + securityToken);
    var statusUrl = SESSION_URL + "/" + sessionId + "/status?SecurityToken=" + securityToken;
    console.log("Fetch study information from the session following status url : " + statusUrl);

    $.ajax({
        url: statusUrl,
        method: 'GET',
        dataType: 'json',
        async: true,
        success: function (data) {
            console.log("Status to session studies contextIds length :" + data.contextIds.length);
            console.log("Status to session studies idle time :" + data.idleTime);
            $('#idleTime').html("Idle Time :" + data.idleTime);
            $('#statusTable').find('tbody').empty();
            var statusInformation = "";
            $.each(data.contextIds, function (index, colData) {
                statusInformation += '<tr><td>' + colData + '</td><td>' +
                    '<a class="btn btn-danger btn-sm" onClick="removeFromSession(\'' + colData + '\')"><i class="glyphicon glyphicon-trash"></i></button></td></tr>';
            });
            $('#statusTable').append(statusInformation);
            $("#myModal").modal();
        }
    });
}

/**
 * launch the viewer url in new tab (VAI-760)
 */
function launchViewerURL(viewerUrl) {
    var newUrl = addLoginPageFlag(viewerUrl);
    console.log("Launch viewer url :" + newUrl);
    window.open(newUrl, '_blank');
    return false;
}

/** 
 * This method is used to launch particular study 
 */
function viewStudy(viewerUrl, index) { //TODO: Why is index ignored? Should we remove it?
    var sessionId = $('#sessionId').val();
    if (sessionId == null || sessionId == "") {
        sessionId = BasicUtil.GetV4Guid();
        $('#sessionId').val(sessionId);
        $('#dispalySession').show();
    }
    return launchViewerURL(viewerUrl); //VAI-760
}

/** 
 * This method is used to add study to session 
 */
function addToSession(contextId, securityToken, patientICN, patientDFN, siteNumber, authSiteNumber) {
    var contextList = [];
    contextList.push(contextId);
    var contextIdList = JSON.stringify(contextList);
    console.log("List all the contextList : " + contextIdList);
    var sessionId = $('#sessionId').val();
    console.log("Reading the input from the hidden text box : " + sessionId);
    var newUrl = SITE_URL + "/" + authSiteNumber + "/session/" + sessionId + "/context?SiteNumber=" + siteNumber + "&SecurityToken=" + securityToken + "&AuthSiteNumber=" + authSiteNumber + "&sessionId=" + sessionId;
    var addContextUrl = addLoginPageFlag(newUrl);
    if (patientICN != 'undefined')
        addContextUrl = addContextUrl + "&PatientICN=" + patientICN;
    else
        addContextUrl = addContextUrl + "&PatientDFN=" + patientDFN;

    console.log("Add Context URL { Context URL } : " + addContextUrl);

    $.ajax({
        type: 'POST',
        url: addContextUrl,
        data: contextIdList,
        headers: {
            'Content-Type': 'application/json',
        },
        dataType: 'json',
        success: function (data) {
            console.log("successfully posted the add context Url request to server");
        }
    });
    $('#statusBtn').show();
}

/**
 * This mehod is used to remove the study from the session 
 */
function removeFromSession(contextId) {
    var contextList = [];
    contextList.push(contextId);
    var contextIdList = JSON.stringify(contextList);
    console.log("List all the contextList : " + contextIdList)
    var sessionId = $('#sessionId').val();
    var securityToken = $('#securityToken').val();
    var authSiteNumber = $('#authSiteNumberVal').val();
    console.log("Reading the input from the hidden text box as SecurityToken, SessionId, AuthSiteNumber  : " + securityToken + "," + sessionId + "," + authSiteNumber);
    var removeContextUrl = SITE_URL + "/" + authSiteNumber + "/session/" + sessionId + "/context?SecurityToken=" + securityToken;
    console.log("Remove Context url : " + removeContextUrl);

    $.ajax({
        type: 'DELETE',
        url: removeContextUrl,
        data: contextIdList,
        headers: {
            'Content-Type': 'application/json',
        },
        success: function (data) {
            console.log("successfully posted the remove context Url request to server");
        }
    });
}

function showDashboardSystemPreferences() {
    initializePages();
    hideAndShowTopMenu();
    displayAnnotationPreferences();

    $('#dashboard-topmenu-system-preference-home').show();
    $('#dahsboard-topmenu-home-nav').show();
    $('#dashboard-system-preference-home').show();
}

/**
 * Initialize the pages
 */
var isPagesInitialized = false;

function initializePages() {
    if (!isPagesInitialized) {
        // Cine preference tab
        $('#cineTab').html('');
        loadCinePreferenceWindow("Cine Preferences");

        // ECG preference Tab
        $('#ecgTab').html('');
        loadECGPreferenceWindow("ECG Preferences");

        // Annotation preference tab
        getStrokeStyle("ASTROKESTYLE");

        // Display preference tab
        $('#displayTab').html('');
        loadDisplayPreferenceWindow("Layout Preferences");

        // Copy attributes preference tab
        $('#copyAttrTab').html('');
        loadCopyAttributePreferenc("Copy Attributes Preferences");

        // Log preference tab
        $('#logTab').html('');
        loadLogAttributePreferenc("Log Attributes Preferences");
        $('#logTab').hide();

        isPagesInitialized = true;
        dicomViewer.systemPreferences.loadAllPreferences();
    }
}

function displayCinePreferences() {
    $('#cineTab').show();
    $('#annotationTab').hide();
    $('#ecgTab').hide();
    $('#displayTab').hide();
    $('#copyAttrTab').hide();
    $('#logTab').hide();

    $('#cinePrefActive').addClass('tab-active').removeClass('panel-heading');
    $('#annotaPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#ecgPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#disPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#copyPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#logPrefActive').removeClass('tab-active').addClass('panel-heading');

    $('#preferenceHeaderTitle').html('');
    $('#preferenceHeaderTitle').append("Cine Preferences");
}

function displayLogPreferences() {
    $('#cineTab').hide();
    $('#annotationTab').hide();
    $('#ecgTab').hide();
    $('#displayTab').hide();
    $('#copyAttrTab').hide();
    $('#logTab').show();

    $('#logPrefActive').addClass('tab-active').removeClass('panel-heading');
    $('#cinePrefActive').removeClass('tab-active').removeClass('panel-heading');
    $('#annotaPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#ecgPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#disPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#copyPrefActive').removeClass('tab-active').addClass('panel-heading');

    $('#preferenceHeaderTitle').html('');
    $('#preferenceHeaderTitle').append("Log Preferences");
}

function loadCinePreferenceWindow(title) {
    var cinePref = "";

    cinePref += '<div class="form-horizontal"><div class="col-md-12"><div class="form-group"><label for="cineMode" class="col-sm-3"> Cine mode</label><div class="col-sm-3"><select id="palyselection" class="form-control"><option value="Stack">Stack</option><option value="Study">Study</option></select></div></div><div class="form-group"><label for="repeatCine" class="col-sm-3">Repeat cine run</label><div class="col-sm-3"><input type="number" id="timesToRepeat" name="timesToRepeat" min="1" max="500" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class="form-control">(times)</div></div><div class="form-group"><label for="numberOfFrames" class="col-sm-3">When the number of frames in a cine loop are less than or equal to </label><div class="col-sm-3"><input type="number" id="framesToRepeat" name="framesToRepeat" min="1" max="500" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class="form-control"></div></div><div class="form-group"><label for="looping" class="col-sm-3">When looping through a study, pause single frame images for</label><div class="col-sm-3"><input type="number" id="idleTime" name="idleTime" min="1" max="500" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class="form-control">(seconds)</div></div><div class="col-md-3"> <div id="dashboard-cine-loading-icon" style="margin-left: -30px;display: none"><span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span><span id="dashboard-cine-loading-status"></span> </div></div><div class="form-group"><div class="col-md-2"><button type="button" class="btn btn-sm btn-primary" id="dashboard-cineTab-apply-btn" disabled onclick="dicomViewer.systemPreferences.onSubmit(&quot;cine&quot;)">Apply</button>&nbsp;<button type="button" class="btn btn-sm btn-default" id="dashboard-cineTab-reset-btn" disabled onclick="dicomViewer.systemPreferences.onReset(&quot;cine&quot;)">Reset</button></div><div class="col-md-2"><div id="PreferenceAlert" class="alert alert-danger" style="width:300px;display: none;font-size: 15px;" role="alert"></div></div>';


    $('#cineTab').append(cinePref);
}

function displayEcgPreferences() {
    $('#ecgTab').show();
    $('#annotationTab').hide();
    $('#cineTab').hide();
    $('#displayTab').hide();
    $('#copyAttrTab').hide();
    $('#logTab').hide();

    $('#ecgPrefActive').addClass('tab-active').removeClass('panel-heading');
    $('#cinePrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#annotaPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#disPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#copyPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#logPrefActive').removeClass('tab-active').addClass('panel-heading');

    $('#preferenceHeaderTitle').html('');
    $('#preferenceHeaderTitle').append("ECG Preferences");
}

function loadECGPreferenceWindow(title) {
    var ecgPref = "";

    ecgPref += '<div id="ecgPreferenceContent"><form class="form-horizontal" role="form"><div class="col-md-8"><div class="form-group"><label for="columns" class="col-sm-2 control-label">Lead Type</label><div class="col-sm-4"><select id="ledselection" onchange = "changeLeadType(this.value)" class="form-control"><option value="3x4+1">3x4+1</option><option value="3x4+3">3x4+3</option></select></div></div></div></form><div class="col-md-5" id="displayOne"><div class="panel panel-default"><div class="panel-heading">3x4+1</div> <div class="panel-body" id="3x41"></div></div></div><div class="col-md-5" id="displayThree" style="display: none"><div class="panel panel-default"><div class="panel-heading">3x4+3</div><div class="panel-body" style="margin-left: -30px;"><div class="col-md-12"><div class="form-group"><label for="columns" class="col-sm-5 control-label">First Signal:</div></div><div class="col-md-12"><div class="form-group"><label for="columns" class="col-sm-5 control-label">Second Signal:</label><div class="col-sm-8"><div id="3x43_2"></div></div></div></div><div class="col-md-12"><div class="form-group"><label for="columns" class="col-sm-5 control-label">Third Signal:</label><div class="col-sm-8"><div id="3x43_3"></div></div></div></div></div></div></div><div class="col-md-12"><div id="dashboard-ecg-loading-icon" style="margin-left: -30px;"><span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span><span id="dashboard-ecg-loading-status"></span></div></div><div class="form-group"><div class="col-md-2"><button type="button" class="btn btn-sm btn-primary" id="dashboard-ecgTab-apply-btn" disabled onclick="dicomViewer.systemPreferences.onSubmit(&quot;ecg&quot;)">Apply</button>&nbsp;<button type="button" class="btn btn-sm btn-default" id="dashboard-ecgTab-reset-btn" disabled onclick="dicomViewer.systemPreferences.onReset(&quot;ecg&quot;)">Reset</button></div><div class="col-md-2"></div></div>';

    $('#ecgTab').append(ecgPref);
}

function displayAnnotationPreferences() {
    $('#annotationTab').show();
    $('#cineTab').hide();
    $('#ecgTab').hide();
    $('#displayTab').hide();
    $('#copyAttrTab').hide();
    $('#logTab').hide();

    $('#annotaPrefActive').addClass('tab-active').removeClass('panel-heading');
    $('#cinePrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#ecgPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#disPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#copyPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#logPrefActive').removeClass('tab-active').addClass('panel-heading');

    $('#preferenceHeaderTitle').html('');
    $('#preferenceHeaderTitle').append("Annotation Preferences");
}

function getStrokeStyle(type) {
    var storkeLine = '<div class="panel-body"><form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="lineWidth" style="margin-top: 10px;">Line Width</label></div><div class="col-sm-2">' + getLineWidth(type) + '</div><div class="col-sm-2"> <label for="color" style="margin-top: 10px;">Color</label></div><div class="col-sm-2"> <input type="color" value="#00FFFF" id="' + type + 'lineColor" class="form-control"></div></div></form></div>';

    $('#storkeStyleID').append(storkeLine);

    getGaugeLength("LINE");
}

function getGaugeLength(type) {
    var gaugeLength = '<div class="panel-body" style="padding-top: 30px !important;">' + getFieldSetTitle("Line") + '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="gaugeStyle" style="margin-top: 10px;">Gauge Style</label></div><div class="col-sm-2"> <select id="' + type + 'gaugeStyle"  class="form-control prefBtn" style="min-width:40px"><option value="Line">Line</option><option value="Point">Point</option></select></div><div class="col-sm-2">   <label for="gaugeLength" style="margin-top: 10px;">Gauge Length</label></div><div class="col-sm-2"><input id="' + type + 'gaugeLength" type="number" min="0" max="20" onkeypress="return event.charCode >= 48 && event.charCode <= 57" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class=" form-control"/></div><div class="col-sm-2"> <label for="fill"></label></div><div class="col-sm-2"> <input type="checkbox" class="form-control" style="display: none"></div></div></form></div>';

    $('#gaugeLengthID').append(gaugeLength);

    if (type == "LINE") {
        $('#gaugeLengthID').hide();
    }

    getArrowFill("ARROW");
}

function getArrowFill(type) {
    var arrowFill = '<div class="panel-body" style="padding-top: 30px !important;">' + getFieldSetTitle("Arrow") + '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="fillColor" style="margin-top: 10px;">Fill Color</label></div><div class="col-sm-2"> <input type="color" id="' + type + 'fillColor" value="#00FFFF" name="fillColor" class="form-control"></div><div class="col-sm-2"> <label for="fill" style="margin-top: 10px;">Fill</label></div><div class="col-sm-2"> <input type="checkbox" id="' + type + 'isFill" class="form-control" style="width: 35px"></div></div></form></div>';

    $('#arrowFillID').append(arrowFill);

    getMeasurement("MSTROKESTYLE");
}

function getMeasurement(type) {
    var measurement = '<div class="panel-body"><form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="lineWidth" class="label-align">Line Width</label></div><div class="col-sm-2"> ' + getLineWidth(type) + '</div><div class="col-sm-2"> <label for="color" class="label-align">Color</label></div><div class="col-sm-2"> <input type="color" value="#00FFFF" id="' + type + 'lineColor" class="form-control"></div></div><div class="form-group"><div class="col-sm-2"> <label for="Precision" class="label-align">Precision</label></div><div class="col-sm-2"><input type="number" id="' + type + 'precision" min="0" max="14" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class="form-control"></div><div class="col-sm-2"> <label for="measurementUnits"class="label-align">Measurement Units</label></div><div class="col-sm-2"><select id="' + type + 'measureUnits" class="form-control"><option value="in">Inches</option><option value="cm">Centimeter</option><option value="mm">Millimeter</option></select></div></div></form></div>';

    $('#measurementLineID').append(measurement);

    getMeasurementGaugeLength("LENGTH");
}

function getMeasurementGaugeLength(type) {
    var measurementGaugeLength = '<div class="panel-body" style="padding-top: 30px !important;">' + getFieldSetTitle("Length") + '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="gaugeStyle" style="margin-top: 10px;">Gauge Style</label></div><div class="col-sm-2"> <select id="' + type + 'gaugeStyle"  class="form-control prefBtn" style="min-width:40px"><option value="Line">Line</option><option value="Point">Point</option></select></div><div class="col-sm-2"><label for="' + type + 'gaugeLength" style="margin-top: 10px;">Gauge Length</label></div><div class="col-sm-2"> <input id="' + type + 'gaugeLength" type="number" min="0" max="20" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class=" form-control"/></div></div></form></div>';

    $('#measurementGaugeLengthID').append(measurementGaugeLength);

    getMeasurementAngle("ANGLE");
}

function getMeasurementAngle(type) {
    var measurementAngle = '<div class="panel-body" style="padding-top: 30px !important;"> ' + getFieldSetTitle("Angle") + '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"><label for="' + type + 'arcRadius" style="margin-top: 10px;">Arc Radius</label></div><div class="col-sm-2"><input id="' + type + 'arcRadius" type="number" min="5" max="20" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class=" form-control"/></div></div></form></div>';

    $('#measurementAngleID').append(measurementAngle);

    getElipseRectLine("ERSTROKESTYLE");
}

function getElipseRectLine(type) {
    var elipseRectLine = ' <div class="panel-body"><form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="lineWidth" class="label-align">Line Width</label></div><div class="col-sm-2"> ' + getLineWidth(type) + ' </div><div class="col-sm-2"> <label for="color" class="label-align">Color</label></div><div class="col-sm-2"> <input type="color" value="#00FFFF" id="' + type + 'lineColor" class="form-control"></div></div><div class="form-group"><div class="col-sm-2"> <label for="fillColor" style="margin-top: 10px;">Fill Color</label></div><div class="col-sm-2"><input type="color" id="' + type + 'fillColor" value="#00FFFF" name="fillColor" class="form-control"></div><div class="col-sm-2"> <label for="fill" style="margin-top: 10px;">Fill</label></div><div class="col-sm-2"> <input type="checkbox" id="' + type + 'isFill" class="form-control" style="width: 35px"></div></div></form></div>';

    $('#elipseRectLineID').append(elipseRectLine);

    getHounsfield("HOUNSFIELD");
}

function getHounsfield(type) {
    var housnsfield = '<div class="panel-body" style="padding-top: 30px !important;"> ' + getFieldSetTitle("HOUNSFIELD") + '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="Precision" class="label-align">Precision</label></div><div class="col-sm-2"> <input type="number" id="' + type + 'precision" min="0" max="14" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class="form-control"></div><div class="col-sm-2"> <label for="measurementUnits"class="label-align">Measurement Units</label></div><div class="col-sm-2"> <select id="' + type + 'measureUnits" class="form-control"><option value="in">Inches</option><option value="cm">Centimeter</option><option value="mm">Millimeter</option></select></div></div></form></div>';

    $('#housnfieldID').append(housnsfield);

    getMitralLine("MA");
}

function getMitralLine(type) {
    var mitralAtro = '<div class="panel-body"><form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"><label for="gaugeStyle" style="margin-top: 10px;">Gauge Style</label></div><div class="col-sm-2"><select id="' + type + 'gaugeStyle"  class="form-control prefBtn" style="min-width:40px"><option value="Line">Line</option><option value="Point">Point</option></select></div><div class="col-sm-2"><label for="' + type + 'gaugeLength" style="margin-top: 10px;">Gauge Length</label></div><div class="col-sm-2"><input id="' + type + 'gaugeLength" type="number" min="0" max="20" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class=" form-control"/></div></div><div class="form-group"><div class="col-sm-2"><label for="Precision" class="label-align">Precision</label></div><div class="col-sm-2"><input type="number" id="' + type + 'precision" min="0" max="14" onkeypress="return event.charCode >= 48 && event.charCode <= 57" class="form-control"></div><div class="col-sm-2"><label for="measurementUnits"class="label-align">Measurement Units</label></div><div class="col-sm-2"><select id="' + type + 'measureUnits" class="form-control"><option value="in">Inches</option><option value="cm">Centimeter</option><option value="mm">Millimeter</option></select></div></div></form></div>';

    $('#mitralAorticID').append(mitralAtro);

    getMitralWidth("MITRAL");
}

function getMitralWidth(type) {
    var mWidth = '<div class="panel-body" style="padding-top: 30px !important;"> ' + getFieldSetTitle("MITRAL") + '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="lineWidth" style="margin-top: 10px;">Line Width</label></div><div class="col-sm-2"> ' + getLineWidth(type) + '</div><div class="col-sm-2"> <label for="color" style="margin-top: 10px;">Color</label></div><div class="col-sm-2"> <input type="color" value="#00FFFF" id="' + type + 'lineColor" class="form-control"></div></div></form></div>';

    $('#mitralLineID').append(mWidth);

    getAorticWidth("AORTIC");
}

function getAorticWidth(type) {
    var mAorticWidth = '<div class="panel-body" style="padding-top: 30px !important;"> ' + getFieldSetTitle("AORTIC") + '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="lineWidth" style="margin-top: 10px;">Line Width</label></div><div class="col-sm-2">' + getLineWidth(type) + '</div><div class="col-sm-2"> <label for="color" style="margin-top: 10px;">Color</label></div><div class="col-sm-2"> <input type="color" value="#00FFFF" id="' + type + 'lineColor" class="form-control"></div></div></form></div>';

    $('#mitralID').append(mAorticWidth);

    getText("TEXT");
}

function getText(type) {
    var text = '<div class="panel-body"> <form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="fontName" style="margin-top: 10px;">Font Name</label></div><div class="col-sm-2"> ' + getFontName(type) + ' </div><div class="col-sm-2"> <label for="fontSize" style="margin-top: 10px;">Font Size</label></div><div class="col-sm-2"> ' + getFontSize(type) + ' </div><div class="col-sm-2"> <label for="textColor" style="margin-top: 10px;">Font Color</label></div><div class="col-sm-2"> <input type="color" id="' + type + 'textColor" value="#00FFFF" class="form-control"></div></div><div class="form-group"><div class="col-sm-2"> <label for="' + type + 'isFill" class="label-align">Fill</label></div><div class="col-sm-2"> <input type="checkbox"  id="' + type + 'isFill" class="form-control form-input-style"></div><div class="col-sm-2"> <label for="' + type + 'fillColor" class="label-align">Fill Color</label></div><div class="col-sm-2"> <input type="color" value="#00FFFF"  id="' + type + 'fillColor" class="form-control"></div></div><div class="form-group"> ' + getFontAttr(type) + ' </div></form></div></div>';

    $('#fontText').append(text);

    getLabelAnnotation("LBLANNOTATION");
}

function getLabelAnnotation(type) {
    var lblAnnotation = '<div class="panel-body"><form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="fontName" style="margin-top: 10px;">Font Name</label></div><div class="col-sm-2"> ' + getFontName(type) + '</div><div class="col-sm-2"> <label for="fontSize" style="margin-top: 10px;">Font Size</label></div><div class="col-sm-2"> ' + getFontSize(type) + '</div> <div class="col-sm-2"> <label for="textColor" style="margin-top: 10px;">Font Color</label></div><div class="col-sm-2"> <input type="color" id="' + type + 'textColor" value="#00FFFF" class="form-control"></div></div><div class="form-group">' + getFontAttr(type) + '</div></form></div>';

    $('#labelAnnotationID').append(lblAnnotation);

    getLabelOverlay("LBLOVERLAY");
}

function getLabelOverlay(type) {
    var lblOverlay = '<div class="panel-body"><form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="fontName" style="margin-top: 10px;">Font Name</label></div><div class="col-sm-2"> ' + getFontName(type) + '</div><div class="col-sm-2"> <label for="fontSize" style="margin-top: 10px;">Font Size</label></div><div class="col-sm-2"> ' + getFontSize(type) + '</div> <div class="col-sm-2"> <label for="textColor" style="margin-top: 10px;">Font Color</label></div><div class="col-sm-2"> <input type="color" id="' + type + 'textColor" value="#00FFFF" class="form-control"></div></div><div class="form-group">' + getFontAttr(type) + '</div></form></div>';

    $('#labelOverlayID').append(lblOverlay);

    getLabelOrientation("LBLORIENTATION");
}

function getLabelOrientation(type) {
    var lblOrientation = '<div class="panel-body"><form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="fontName" style="margin-top: 10px;">Font Name</label></div><div class="col-sm-2"> ' + getFontName(type) + '</div><div class="col-sm-2"> <label for="fontSize" style="margin-top: 10px;">Font Size</label></div><div class="col-sm-2"> ' + getFontSize(type) + '</div> <div class="col-sm-2"> <label for="textColor" style="margin-top: 10px;">Font Color</label></div><div class="col-sm-2"> <input type="color" id="' + type + 'textColor" value="#00FFFF" class="form-control"></div></div><div class="form-group">' + getFontAttr(type) + '</div></form></div>';

    $('#labelOrientationID').append(lblOrientation);

    getLabelScoutRuler("LBLSCOUT");
}

function getLabelScoutRuler(type) {
    var lblScoutRule = '<div class="panel-body" style="padding-top: 30px !important;">' + getFieldSetTitle("SCOUT") + '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="lineWidth" style="margin-top: 10px;">Line Width</label></div><div class="col-sm-2">' + getLineWidth(type) + '</div><div class="col-sm-2"> <label for="color" style="margin-top: 10px;">Color</label></div><div class="col-sm-2"> <input type="color" value="#00FFFF" id="' + type + 'lineColor" class="form-control"></div></div></form></div>';

    $('#labelScoutRulerID').append(lblScoutRule);

    getLabelRuler("LBLRULER");
}

function getLabelRuler(type) {
    var lblRule = '<div class="panel-body" style="padding-top: 30px !important;">' + getFieldSetTitle("RULER") + '<form role="form" class="form-horizontal"><div class="form-group"><div class="col-sm-2"> <label for="lineWidth" style="margin-top: 10px;">Line Width</label></div><div class="col-sm-2">' + getLineWidth(type) + '</div><div class="col-sm-2"> <label for="color" style="margin-top: 10px;">Color</label></div><div class="col-sm-2"> <input type="color" value="#00FFFF" id="' + type + 'lineColor" class="form-control"></div></div></form></div>';

    $('#labelRulerID').append(lblRule);
}

function getFontName(type) {
    return '<select id="' + type + 'fontName" class="form-control"><option value="Arial">Arial</option><option value="Arial Black">Arial Black</option> <option value="Book Antiqua">Book Antiqua</option><option value="Calibri">Calibri</option><option value="Comic Sans MS">Comic Sans MS</option><option value="Courier">Courier</option><option value="Cursive">Cursive</option><option value="Fantasy">Fantasy </option><option value="Georgia">Georgia</option><option value="Garamond">Garamond</option><option value="Helvetica">Helvetica</option><option value="Impact">Impact </option><option value="Lucida Sans Unicode">Lucida Sans Unicode </option><option value="Lucida Console">Lucida Console </option><option value="Monospace">Monospace</option><option value="Palatino Linotype">Palatino Linotype</option><option value="sans-serif">Sans-serif</option><option value="Times New Roman">Times New Roman</option><option value="Tahoma">Tahoma </option><option value="Verdana">Verdana </option></select>';
}

function getFontSize(type) {
    return '<select id="' + type + 'fontSize" class="form-control"><option value="6">5</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="10">10</option><option value="11">11</option><option value="12">12</option><option value="13">13</option><option value="14">14</option><option value="16">16</option><option value="18">18</option><option value="20">20</option><option value="22">22</option><option value="24">24</option><option value="26">26</option><option value="28">28</option></select>';
}

function getFontAttr(type) {
    var display = "block";
    if (type == "LBLORIENTATION" || type == "LBLOVERLAY") {
        display = "none";
    }

    return '<div class="col-sm-2"> <label for="' + type + 'isBold" class="label-align">Bold</label></div><div class="col-sm-2"> <input type="checkbox"  id="' + type + 'isBold" class="form-control form-input-style"></div><div class="col-sm-2"> <label for="' + type + 'isItalic" class="label-align">Italic</label></div><div class="col-sm-2"><input type="checkbox"  id="' + type + 'isItalic" class="form-control form-input-style"></div></div><div class="form-group" style="display:' + display + '"><div class="col-sm-2"> <label for="' + type + 'isUnderlined" class="label-align">Underline</label></div><div class="col-sm-2"><input type="checkbox"  id="' + type + 'isUnderlined" class="form-control form-input-style"></div><div class="col-sm-2"> <label for="' + type + 'isStrikeout" class="label-align">Strikeout</label></div><div class="col-sm-2"> <input type="checkbox"  id="' + type + 'isStrikeout" class="form-control form-input-style"></div>';
}

function getLineWidth(type) {
    return '<select id="' + type + 'lineWidth" class="form-control"><option value="1">1</option><option value="2">2</option><option value="3">3</option><option value="4">4</option><option value="5">5</option><option value="6">6</option><option value="7">7</option><option value="8">8</option><option value="9">9</option><option value="10">10</option><option value="11">11</option><option value="12">12</option><option value="13">13</option><option value="14">14</option></select>';
}

function getFieldSetTitle(title) {
    return '<h5 class="text-on-pannel"><strong class="text-uppercase"> ' + title + ' </strong></h5>';
}

function displayLayoutPreferences() {
    $('#displayTab').show();
    $('#annotationTab').hide();
    $('#cineTab').hide();
    $('#ecgTab').hide();
    $('#copyAttrTab').hide();
    $('#logTab').hide();

    $('#disPrefActive').addClass('tab-active').removeClass('panel-heading');
    $('#cinePrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#ecgPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#annotaPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#copyPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#logPrefActive').removeClass('tab-active').addClass('panel-heading');

    $('#preferenceHeaderTitle').html('');
    $('#preferenceHeaderTitle').append("Layout Preferences");
}

function loadDisplayPreferenceWindow(title) {
    var hpList = "";

    hpList += '<div id="addEditHPTable" style="display: none"><form class="form-horizontal" role="form"><div class="col-md-12"><div class="form-group"><label for="modality" class="col-sm-2 control-label">Modality</label><div class="col-sm-3"><select id="modality" class="form-control"><option value="US">US</option><option value="MR">MR</option><option value="CR">CR</option><option value="XA">XA</option><option value="CT">CT</option><option value="ECG">ECG</option><option value="NM">NM</option><option value="SR">SR</option><option value="MG">MG</option><option value="DOC">DOC</option><option value="DX">DX</option><option value="OT">OT</option><option value="SC">SC</option><option value="PT">PT</option><option value="RF">RF</option><option value="ES">ES</option><option value="XC">XC</option><option value="General">General</option></select></div></div><div class="form-group"><label for="rows" class="col-sm-2 control-label">Rows</label><div class="col-sm-3"><select id="layoutRows" class="form-control"><option value="1">1</option><option value="2">2</option><option value="3">3</option></select></div></div><div class="form-group"><label for="layoutColumns" class="col-sm-2 control-label">Columns</label><div class="col-sm-3"><select id="layoutColumns" class="form-control"><option value="1">1</option><option value="2">2</option><option value="3">3</option></select></div></div><div class="form-group"><label for="zoomModeValues" class="col-sm-2 control-label">Initial Zoom</label><div class="col-sm-3"><select id="zoomModeValues" class="form-control"><option value="100%" id="0_zoom">100%</option><option value="Fit-to-window" id="1_zoom">Fit-to-window</option><option value="Fit-width-to-window" id="2_zoom">Fit-width-to-window</option><option value="Fit-height-to-window" id="3_zoom">Fit-height-to-window</option></select></div></div><div class="form-group" id ="useEmbedPDFViewer_Row" style="display: none"><label for="useEmbedPdfViewer" class="col-sm-2 control-label">Use Browser PDF Plugin</label><div class="col-sm-3"><select id="useEmbedPdfViewer" class="form-control"><option value="true" id="useEmbedPDFViewer_true">true</option><option value="false" id="useEmbedPDFViewer_false">false</option></select></div></div><div class="form-group"><div class="col-md-2"></div><div class="col-md-2"><button type="button" class="btn btn-sm btn-primary" id="dashboard-displayTab-submit-btn" onclick="dicomViewer.systemPreferences.updateHPTable()">Submit</button>&nbsp;<button type="button" class="btn btn-sm btn-default" id="dashboard-displayTab-cancel-btn" onclick="dicomViewer.systemPreferences.showOrHideHPTable(true)">Cancel</button></div><div class="col-md-2"></div>';

    $('#displayTab').append(hpList);

    hpList = '<br/><div id="listHangingProtocol"><table id="hpTableList" class="table table-bordered"><thead><tr><th>Modality</th><th>Rows</th><th>Columns</th><th>Zoom Mode</th><th align="left">Action</th></tr></thead></table><div id="dashboard-display-loading-icon" style="margin-bottom: -27px;display: none"><span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span> <span id="dashboard-display-loading-status"></span></div><button type="button" class="btn btn-sm btn-primary pull-right" onclick="dicomViewer.systemPreferences.addOrEditHP(undefined, &quot;add&quot;)">Add</button></div>';

    $('#displayTab').append(hpList);
}

function displayCopyAttributePreferences() {
    $('#copyAttrTab').show();
    $('#annotationTab').hide();
    $('#cineTab').hide();
    $('#ecgTab').hide();
    $('#displayTab').hide();
    $('#logTab').hide();

    $('#copyPrefActive').addClass('tab-active').removeClass('panel-heading');
    $('#cinePrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#ecgPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#annotaPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#disPrefActive').removeClass('tab-active').addClass('panel-heading');
    $('#logPrefActive').removeClass('tab-active').addClass('panel-heading');

    $('#preferenceHeaderTitle').html('');
    $('#preferenceHeaderTitle').append("Copy Attributes Preferences");
}

function loadCopyAttributePreferenc(title) {
    var copyAttr = "";
    var arrCopyAttr = ["Window Level", "Brightness and Contrast", "Scale", "Invert", "Orientation", "Pan"];
    var aCheckbox = "";
    for (var i = 0; i < arrCopyAttr.length; i++) {
        if (arrCopyAttr[i] == 'Pan') {
            aCheckbox += '<div class="checkbox" style="display:none"><input id="' + arrCopyAttr[i].replace(/\s|\and/g, "").toLowerCase() + '" type="checkbox" checked><label for="' + arrCopyAttr[i].replace(/\s|\and/g, "").toLowerCase() + '">' + arrCopyAttr[i] + '</label></div>';
        } else {
            aCheckbox += '<div class="checkbox"><input id="' + arrCopyAttr[i].replace(/\s|\and/g, "").toLowerCase() + '" type="checkbox" checked><label for="' + arrCopyAttr[i].replace(/\s|\and/g, "").toLowerCase() + '">' + arrCopyAttr[i] + ' </label></div>';
        }
    }
    if (aCheckbox != undefined) {
        copyAttr += '<div class="row"><div class="col-md-4"></div><div class="col-md-4">' + aCheckbox + '</div><div class="col-md-4"></div></div><div class="form-group"><div class="col-md-4"><div id="dashboard-copyattr-loading-icon" style="display: none"><span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span> <span id="dashboard-copyattr-loading-status"></span></div></div><div class="col-md-4"><button type="button" class="btn btn-sm btn-primary"  id="dashboard-copyattributesTab-apply-btn" disabled onclick="dicomViewer.systemPreferences.onSubmit(&quot;copyattributes&quot;)">Apply</button>&nbsp;<button type="button" class="btn btn-sm btn-default" id="dashboard-copyattributesTab-reset-btn" disabled onclick="dicomViewer.systemPreferences.onReset(&quot;copyattributes&quot;)">Reset</button></div><div class="col-md-4"></div>';
        $('#copyAttrTab').append(copyAttr)
    }
}

function loadLogAttributePreferenc(title) {
    var cinePref = "";

    cinePref += '<div class="form-horizontal"><div class="col-md-12"><div class="form-group"><label for="logLevel" class="col-sm-3"> Log level</label><div class="col-sm-3"><select id="logLevelPref" class="form-control"><option value="Trace">Trace</option><option value="Debug">Debug</option><option value="Info">Info</option><option value="Warn">Warn</option><option value="Error">Error</option><option value="None">None</option></select></div></div>';

    cinePref += '<div class="form-group"><label for="LineLimit" class="col-sm-3">Line limit</label><div class="col-sm-3"><input type="number" id="lineLimitPref" value="1000" name="logLineLimit" min="500" max="2000" onkeypress="return event.charCode >= 48 && event.charCode <= 57" onchange="document.getElementById(&quot;lineLimitPref&quot;).value =(this.value &lt; 500 ? 500 : (this.value &gt; 2000 ? 2000 : this.value))" class="form-control"></div></div>';

    cinePref += '<div class="form-group"><label for="ctrlkeyPref" class="col-sm-3">Shortcut key</label><div class="col-sm-3"><input type="checkbox" value="CTRL" id="ctrlkeyPref" checked><label for="ctrlkeyPref">CTRL</label></div></div>';

    cinePref += '<div class="form-group"><div class="col-sm-3"></div><div class="col-sm-3"><input type="checkbox" value="ALT" id="altkeyPref"><label for="altkeyPref">ALT</label></div></div>';

    cinePref += '<div class="form-group"><div class="col-sm-3"></div><div class="col-sm-3"><input type="checkbox" value="SHIFT" id="shiftkeyPref"><label for="shiftkeyPref">SHIFT</label></div></div>';

    cinePref += '<div class="form-group"><div class="col-sm-3"></div><div class="col-sm-3"><select id="key3Pref" class="form-control"><option value="A">A</option><option value="B">B</option><option value="C">C</option><option value="D">D</option><option value="E">E</option><option value="F">F</option><option value="G">G</option><option value="H">H</option><option selected value="I">I</option><option value="J">J</option><option value="K">K</option><option value="L">L</option><option value="M">M</option><option value="N">N</option><option value="O">O</option><option value="P">P</option><option value="Q">Q</option><option value="R">R</option><option value="S">S</option><option value="T">T</option><option value="U">U</option><option value="V">V</option><option value="W">W</option><option value="X">X</option><option value="Y">Y</option><option value="Z">Z</option></select></div></div>';

    cinePref += '<div class="form-group"><div class="col-md-4"><div id="dashboard-log-loading-icon" style="display: none"><span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span> <span id="dashboard-log-loading-status"></span></div></div><div class="col-md-4 pull-right"><button type="button" class="btn btn-sm btn-primary"  id="dashboard-logTab-apply-btn" disabled onclick="dicomViewer.systemPreferences.onSubmit(&quot;log&quot;)">Apply</button>&nbsp;<button type="button" class="btn btn-sm btn-default" id="dashboard-logTab-reset-btn" disabled onclick="dicomViewer.systemPreferences.onReset(&quot;log&quot;)">Reset</button></div><div class="col-md-4"></div></div></div></div>';

    $('#logTab').append(cinePref);
}

function displayHeaderTitle(title) {
    return '<div class="header-text-align"><h4 class="text-center">' + title + '</h4></div>';
}

function generateStorkeValue(id) {
    var strokeValue = "";
    for (var i = 1; i < 15; i++) {
        strokeValue += "<option value='" + i + "'>" + i + "</option>";
    }

    return strokeValue;
}

function changeLeadType(value) {
    if (value == "3x4+1") {
        $('#displayOne').show();
        $('#displayThree').hide();
    } else {
        $('#displayOne').hide();
        $('#displayThree').show();
    }
}


/**
 * Load dashboard cache page while clicking on dashboard cache image
 **/
function showDashboardCache() {
    hideAndShowTopMenu();
    $('#dashboard-topmenu-cache-home').show();
    $('#dahsboard-topmenu-home-nav').show();
    $('#dashboard-cache-home').show();
}

/**
 * Load dashboard status page while clicking on dashboard status image
 **/
function showDashboardStatus() {
    hideAndShowTopMenu();
    $('#dashboard-topmenu-status-home').show();
    $('#dahsboard-topmenu-home-nav').show();
    $('#dashboard-status-home').show();
    getDashboardRenderAndViewerStatus();
}

/**
 * Get dashboard render and viewer status information
 * and display it in status page 
 **/
function getDashboardRenderAndViewerStatus() {
    $.ajax({
        url: DASHBOARD_STATUS_URL,
        method: 'GET',
        dataType: 'json',
        async: true,
        success: function (data) {
            var statusViewerInformation = "";
            var statusRenderInformation = "";
            if (!isNullOrUndefined(data)) {
                $('#dashboard-status-viewer-table-body').html('');
                $('#dashboard-status-render-table-body').html('');
                $.each(data, function (index, colData) {
                    var renderStr = index.replace('rENDER', 'RENDER');
                    if (renderStr.indexOf('RENDER') !== -1) {
                        statusRenderInformation += '<tr><td>' + index.replace('rENDER.', '') + '</td><td>' + colData + '</td></tr>';
                    } else {
                        statusViewerInformation += '<tr><td>' + index.replace('vIEWER.', '') + '</td><td>' + colData + '</td></tr>';
                    }
                });
            } else {
                statusRenderInformation = 'There is no render status information available';
                statusViewerInformation = 'There is no viewer status information available';
            }
            $('#dashboard-status-viewer-table-body').append(statusViewerInformation);
            $('#dashboard-status-render-table-body').append(statusRenderInformation);
        }
    });
}

/**
 * Display dashboard menu based on hide and show action
 **/
function hideAndShowTopMenu() {
    $('#dashboard-login').hide();
    $('#dashboard-home').hide();
    $('#dashboard-log-home').hide();
    $('#dashboard-search-home').hide();
    $('#dashboard-cache-home').hide();
    $('#dashboard-system-preference-home').hide();
    $('#dashboard-topmenu-login').hide();
    $('#dashboard-status-home').hide();


    $('#dashboard-topmenu-logs-home').hide();
    $('#dahsboard-topmenu-home-nav').hide();
    $('#dashboard-topmenu-search-home').hide();
    $('#dashboard-topmenu-cache-home').hide();
    $('#dashboard-topmenu-system-preference-home').hide();
    $('#dashboard-topmenu-status-home').hide();
}

/**
 * Check the if a value is null or undefined
 **/
function isNullOrUndefined(obj) {
    if (obj === undefined || obj === null) {
        return true;
    }
    return false;
}

/**
 * Convert the xml text into json value
 **/
function xmlToJson(xml) {
    // Create the return object
    var obj = {};

    if (xml.nodeType == 1) { // element
        // do attributes
        if (xml.attributes.length > 0) {
            obj["attributes"] = {};
            for (var j = 0; j < xml.attributes.length; j++) {
                var attribute = xml.attributes.item(j);
                obj["attributes"][attribute.nodeName] = attribute.nodeValue;
            }
        }
    } else if (xml.nodeType == 3) { // text
        obj = xml.nodeValue;
    }

    // do children
    // If just one text node inside
    if (xml.hasChildNodes() && xml.childNodes.length === 1 && xml.childNodes[0].nodeType === 3) {
        obj = xml.childNodes[0].nodeValue;
    } else if (xml.hasChildNodes()) {
        for (var i = 0; i < xml.childNodes.length; i++) {
            var item = xml.childNodes.item(i);
            var nodeName = item.nodeName;
            if (nodeName != "#comment") {
                if (typeof (obj[nodeName]) == "undefined") {
                    obj[nodeName] = xmlToJson(item);
                } else {
                    if (typeof (obj[nodeName].push) == "undefined") {
                        var old = obj[nodeName];
                        obj[nodeName] = [];
                        obj[nodeName].push(old);
                    }
                    obj[nodeName].push(xmlToJson(item));
                }
            }
        }
    }

    return obj;
}

/**
 * Get the value as JSON Formate by passing the param
 **/
function getJson(param) {
    try {
        var formattedParams = {};
        var params = JSON.parse(param);
        $.each(params, function (key, value) {
            if (Object.prototype.toString.call(value) == '[object String]') {
                if (value.startsWith("[{") || value.startsWith("{")) {
                    formattedParams[key] = getJson(value);
                } else if (value.startsWith("<")) {
                    value = value.replace('<!--', '<');
                    value = value.replace('?-->', '?>');
                    value = value.replace(new RegExp('<img>', 'g'), '');

                    var xmlDoc;
                    if (window.DOMParser) {
                        var parser = new DOMParser();
                        xmlDoc = parser.parseFromString(value, "text/xml");
                        xmlContent = new XMLSerializer().serializeToString(xmlDoc);
                    } else {
                        xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
                        xmlDoc.async = false;
                        xmlDoc.loadXML(value);
                    }

                    formattedParams[key] = getJson(JSON.stringify(xmlToJson(xmlDoc)));
                } else {
                    formattedParams[key] = value;
                }
            } else if (Object.prototype.toString.call(value) == '[object Object]') {
                formattedParams[key] = getJson(JSON.stringify(value));
            } else if (Object.prototype.toString.call(value) == '[object Array]') {
                value.forEach(function (item, index) {
                    if (Object.prototype.toString.call(item) == '[object Object]') {
                        value[index] = getJson(JSON.stringify(item));
                    }
                });
                formattedParams[key] = value;
            } else {
                formattedParams[key] = value;
            }
        });

        return formattedParams;
    } catch (e) { }

    return param;
}

/**
 * Is dirty check
 * @param {Type} currentActiveTab - Specifies the current preference tab
 */
function isDirty(currentActiveTab) {
    try {
        var previousActiveTab = $(".tab-active")[0].id;
        if (previousActiveTab !== "disPrefActive") {
            if (dicomViewer.systemPreferences.sanityCheck(getActiveTabPreference())) {
                $("#preferenceSaveModal").val(currentActiveTab);
                $('#preferenceSaveModal').modal();
            } else {
                selectPreferences(currentActiveTab);
            }
        } else {
            selectPreferences(currentActiveTab);
        }
    } catch (e) { }
}

/**
 * Get the active tab preference
 * @param {Type}  
 */
function getActiveTabPreference() {
    try {
        var activePrefTab = $(".tab-active")[0].id;
        var preference;
        switch (activePrefTab) {
            case "cinePrefActive":
                preference = "cine";
                break;
            case "ecgPrefActive":
                preference = "ecg";
                break;
            case "annotaPrefActive":
                preference = "annotation";
                break;
            case "disPrefActive":
                preference = "display";
                break;
            case "copyPrefActive":
                preference = "copyattributes";
                break;
            case "logPrefActive":
                preference = "log";
                break;
        }

        return preference;
    } catch (e) { }
}

/**
 * Apply the changes
 * @param {Type}  
 */
function applyChanges() {
    var activePrefTab = getActiveTabPreference();
    if (activePrefTab == "cine") {
        if (!dicomViewer.systemPreferences.isValidCinePreference(activePrefTab)) {
            dicomViewer.systemPreferences.resetPreferenceValues(activePrefTab);
            $("#preferenceSaveModal").modal('hide');
            selectPreferences($("#preferenceSaveModal").val());
            return;
        }
    } else if (activePrefTab == "annotation") {
        if (!dicomViewer.systemPreferences.isValidAnnotationPreference(activePrefTab)) {
            dicomViewer.systemPreferences.resetPreferenceValues(activePrefTab);
            $("#preferenceSaveModal").modal('hide');
            selectPreferences($("#preferenceSaveModal").val());
            return;
        }
    }
    dicomViewer.systemPreferences.onSubmit(activePrefTab);
    $("#preferenceSaveModal").modal('hide');
    selectPreferences($("#preferenceSaveModal").val());
}

/**
 * Revert the changes
 * @param {Type}  
 */
function revertChanges() {
    dicomViewer.systemPreferences.resetPreferenceValues(getActiveTabPreference());
    selectPreferences($("#preferenceSaveModal").val());
}

/**
 * Select the preferences
 * @param {Type} activePrefTab - Specifies the active preference tab
 */
function selectPreferences(activePrefTab) {
    try {
        switch (activePrefTab) {
            case "cinePrefActive":
                displayCinePreferences();
                break;
            case "ecgPrefActive":
                displayEcgPreferences();
                break;
            case "annotaPrefActive":
                displayAnnotationPreferences();
                break;
            case "disPrefActive":
                displayLayoutPreferences();
                break;
            case "copyPrefActive":
                displayCopyAttributePreferences();
                break;
            case "logPrefActive":
                displayLogPreferences();
                break;
        }
    } catch (e) { }
}

/**
 * Display the preferences
 * @param {Type} activePrefTab - Specifies the active preference tab
 */
function displayPreferences(activePrefTab) {
    try {
        $("#PreferenceAlert").html("");
        $("#PreferenceAlert").hide();
        $("#AnnotationPreferenceAlert").html("");
        $("#AnnotationPreferenceAlert").hide();
        var aPreferenceType = getActiveTabPreference();
        if ($.inArray(aPreferenceType, preferenceType) != -1) {
            isDirty(activePrefTab);
        } else {
            selectPreferences(activePrefTab);
        }
    } catch (e) { }
}

//VAI-915: URL parameter to use on session timeout when we are running internally (such as from the Dash) and not from an external program (like the JLV)
function addLoginPageFlag(url) {
    var newUrl = url.endsWith("/") ? url.substring(0, url.length - 1) : url;
    return (newUrl.indexOf("?") >= 0 ? newUrl + "&lp=1" : newUrl + "?lp=1");
}
