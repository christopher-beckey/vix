//vvvvvvvvvvv TODO VAI-919: Change var to const vvvvvvvvvv
var userInfoUrl = window.location.origin + "/vix/viewer/user/details" + window.location.search + "&_cacheBust=";
var qaReportsUrl = window.location.origin + "/vix/viewer/qa/reports";
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

var height = 0;
var width = 0;
var uHeight = 0;
$(document).ready(function () {
    resizeFrames();

    $("#runReport")[0].searchQuery = {
        captureUserId: 0,
        fromDate: 0,
        toDate: 0
    };

    $('#fromDate').datepicker({
        autoHide: true,
        zIndex: 2048,
        format: "yyyy/mm/dd",
        autoPick: true
    });

    $('#toDate').datepicker({
        autoHide: true,
        zIndex: 2048,
        format: "yyyy/mm/dd",
        autoPick: true
    });

    bindEvents();
    updateLoginUserInfo();
});

/**
 * Update the login user information
 */
function updateLoginUserInfo() {
    $.ajax({
        type: 'GET',
        url: userInfoUrl,
        dataType: 'json',
        success: function (data) {
            if (data) {
                var userName = (data.name) ? data.name : "";
                $("#user-info")[0].innerHTML = "Report requests for user : " + userName;
                $("#runReport")[0].searchQuery.captureUserId = data.id;
            }
        },
        error: function (xhr, status) {
            var description = "\nFailed to get user info."
        }
    });
}

/**
 * Get the date range text
 * @param {Type} dateRange - Specifies the date range
 */
function getDateRangeText(dateRange) {
    if (dateRange.fromDate === dateRange.throughDate) {
        return "Range : Today";
    } else {
        var fromDate = new Date(dateRange.fromDate);
        var throughDate = new Date(dateRange.throughDate);

        if (fromDate.getTime() > throughDate.getTime()) {
            return "Invalid date range"
        }

        var dateDiff = throughDate - fromDate;
        var years = Math.floor(dateDiff / 31536000000);
        var months = Math.floor((dateDiff % 31536000000) / 2628000000);
        var days = Math.floor(((dateDiff % 31536000000) % 2628000000) / 86400000);

        var range = "Range : ";
        if (years > 0) {
            range += (years + " year(s) ");
        }

        if (months > 0) {
            range += (months + " month(s) ");
        }

        if (days > 0) {
            range += (days + " day(s)");
        }

        return range;
    }
}

function runQAReport() {
    try {
        $("#qaImageReportStatistics").html('');
        $('#qaImageReporttblBody').html('');
        $("#qaUserReport").hide();
        $("#qaViewReport")[0].disabled = true;

        var searchQuery = $("#runReport")[0].searchQuery;
        if (!searchQuery) {
            // TODO: display error message
            return;
        }

        searchQuery.includeDeletedImages = $("#deleteImages")[0].checked;
        searchQuery.includeExistingImages = $("#existingImages")[0].checked;
        searchQuery.isGroupedByStatus = $("#groupedByStatus")[0].checked;
        searchQuery.isGroupedByUsersAndStatus = $("#groupedByUser")[0].checked;
        searchQuery.flags = "C";

        if (searchQuery.includeDeletedImages) {
            searchQuery.flags += "D";
        }

        if (searchQuery.includeExistingImages) {
            searchQuery.flags += "E";
        }

        if (searchQuery.isGroupedByStatus) {
            searchQuery.flags += "S";
        }

        if (searchQuery.isGroupedByUsersAndStatus) {
            searchQuery.flags += "U";
        }

        queueImageReports(searchQuery);
        qaReportTableAlignment();
        resizeFrames();
    } catch (e) {}
}

/**
 * Update image reports
 * @param {Type} searchParams - Specifies the search params
 */
function queueImageReports(searchFilter) {
    try {
        var flags = searchFilter.flags;
        var fromDate = searchFilter.fromDate;
        var toDate = searchFilter.toDate;

        var queueReportsUrl = qaReportsUrl + "/" + flags + "/" + fromDate + "/" + toDate + window.location.search + "&_cacheBust=" + new Date().getMilliseconds();
        $.ajax({
            url: queueReportsUrl,
            method: 'GET',
            async: true,
            cache: false,
            success: function (data) {
                updateImageReports(searchFilter);
            },
            error: function (xhr, status) {
                refreshImageReports(undefined);
            }
        });
    } catch (e) {}
}

/**
 * Update the image reports
 * @param {Type} searchFilter - Specifies the search filter
 */
function updateImageReports(searchFilter) {
    try {
        var imageReportsUrl = qaReportsUrl + "/" + searchFilter.captureUserId + window.location.search + "&_cacheBust=" + new Date().getMilliseconds();
        $.ajax({
            url: imageReportsUrl,
            method: 'GET',
            async: true,
            cache: false,
            success: function (data) {
                refreshImageReports(data, searchFilter);
            },
            error: function (xhr, status) {
                refreshImageReports(undefined);
            }
        });
    } catch (e) {}
}

function appendImageReportTblBody(reviewReportInc, reportType, status, fromDate, toDate, startedAt, endedAt) {

    $("#qaImageReporttblBody").innerHTML = "";
    var table = document.getElementById("qaImageReporttblBody");
    var row = table.insertRow(-1);
    row.id = "qaImageReport-" + reviewReportInc;
    row.onclick = function () {
        hightLightRow(this);
    };
    var cell1 = row.insertCell();
    var cell2 = row.insertCell();
    var cell3 = row.insertCell();
    var cell4 = row.insertCell();
    var cell5 = row.insertCell();
    var cell6 = row.insertCell();

    cell1.style = "width:20%";
    cell1.textContent = reportType;

    cell2.style = "width:10%";
    cell2.textContent = status;

    cell3.style = "width:10%";
    cell3.textContent = fromDate;

    cell4.style = "width:10%";
    cell4.textContent = toDate;

    cell5.style = "width:10%";
    cell5.textContent = startedAt;

    cell6.style = "width:10%";
    cell6.textContent = endedAt;
}

/**
 * Refresh the image reports
 * @param {Type} xmlData - Specifies the xml data
 */
function refreshImageReports(xmlData, searchFilter) {
    try {
        if (xmlData) {
            var reviewReports = getJsonData(xmlData);
            if (reviewReports) {
                var qaReviewReports = reviewReports.qaReviewReports;
                if (qaReviewReports && qaReviewReports.qaReviewReport) {
                    var reviewReportInc = 1;
                    var reports = "";

                    if (!qaReviewReports.qaReviewReport.length) {
                        var report = qaReviewReports.qaReviewReport;
                        qaReviewReports.qaReviewReport = [report];
                    }
                    qaReviewReports.qaReviewReport.forEach(function (reportValue) {
                        var reportType = "TBD";
                        var status = "TBD";
                        var fromDate = getReportDateTime(reportValue.fromDate);
                        var toDate = getReportDateTime(reportValue.throughDate);
                        var startedAt = getReportDateTime(reportValue.reportStartDateTime);
                        var endedAt = getReportDateTime(reportValue.reportCompletedDateTime);
                        reports += "<tr id=qaImageReport-" + reviewReportInc + " onclick='hightLightRow(this)'><td style='width: 20%'>" + reportType + "</td><td style='width: 10%'>" + status + "</td><td style='width: 10%'>" + fromDate + "</td><td style='width: 10%'>" + toDate + "</td><td style='width: 10%'>" + startedAt + "</td><td style='width: 10%'>" + endedAt + "</td></tr>";

                        reportValue.rptFromDate = getReportDateTime(reportValue.fromDate, true).trim();
                        reportValue.rptToDate = getReportDateTime(reportValue.throughDate, true).trim();
                        reviewReportInc++;
                        appendImageReportTblBody(reviewReportInc, reportType, status, fromDate, toDate, startedAt, endedAt);
                        $("#qaImageReport-" + reviewReportInc)[0].qaReportData = {
                            filter: searchFilter,
                            qaReviewReport: reportValue
                        };
                    });
                    alignTable();
                }
            }
        }
    } catch (e) {}
}

/**
 * Get the report date time
 * @param {Type} value - Specifies the date time value
 */
function getReportDateTime(value, skipDelimiter) {
    try {
        if (typeof value !== 'string') {
            return "";
        }

        if (value) {
            var dateTime = value.split('.');
            var date = dateTime[0];
            var time = dateTime[1];

            dateTime = "";
            if (date && date.length == 7) {
                var defaultYear = 19;
                var defaultYearPrefix = 2;
                defaultYear += (parseInt(date.substr(0, 1)) - defaultYearPrefix);
                if (!skipDelimiter) {
                    dateTime = date.substr(3, 2) + "/" + date.substr(5, 2) + "/" + defaultYear + date.substr(1, 2);
                } else {
                    dateTime = defaultYear + date.substr(1, 2) + date.substr(3, 2) + date.substr(5, 2);
                }
            } else if (date) {
                dateTime += date;
            }

            dateTime += " ";
            if (time && time.length >= 6) {
                dateTime += time.substr(0, 2) + ":" + time.substr(2, 2) + ":" + time.substr(4, 2);
            } else if (time) {
                dateTime += time
            }

            return dateTime;
        }
    } catch (e) {}

    return value;
}

function hightLightRow(currentRow) {
    $(currentRow).addClass('highlight').siblings().removeClass('highlight');
    $("#qaUserReport").hide();
    $("#qaViewReport")[0].disabled = false;
}

/**
 * Display the image report statistics
 * @param {Type} 
 */
function displayImageReportStatistics() {
    var currentRow = $("#qaImageReporttblBody tr.highlight")[0];
    $("#qaUserReport").show();
    updateImageReportStatistics(currentRow.qaReportData);
    resizeFrames();
}

/**
 * Update the image statistics
 * @param {Type} qaReportData - Specifies the report data
 */
function updateImageReportStatistics(qaReportData) {
    try {
        var flags = qaReportData.qaReviewReport.reportFlags;
        var fromDate = qaReportData.qaReviewReport.rptFromDate;
        var toDate = qaReportData.qaReviewReport.rptToDate;

        var queueReportsUrl = qaReportsUrl + "/" + flags + "/" + fromDate + "/" + toDate + window.location.search + "&_cacheBust=" + new Date().getMilliseconds();
        $.ajax({
            url: queueReportsUrl,
            method: 'GET',
            async: true,
            cache: false,
            success: function (data) {
                refreshReportStatistics(data, qaReportData);
            },
            error: function (xhr, status) {
                refreshReportStatistics(undefined);
            }
        });
    } catch (e) {}
}

/**
 *
 * @param {Type} xmlData - Specifies the xml data
 * @param {Type} qaReportData - Specifies the report data
 */
function refreshReportStatistics(xmlData, qaReportData) {
    var qaStatistics = [];
    var userData = [];
    try {
        $("#qaImageReportStatistics").html('');
        if (xmlData) {
            var reviewReportStatistics = getJsonData(xmlData);
            if (reviewReportStatistics && reviewReportStatistics.restStringType) {
                var reportStatistics = reviewReportStatistics.restStringType.value;
                reportStatistics = reportStatistics.split('\n');
                if (reportStatistics[0].indexOf('1^Ok') > -1) {
                    if (reportStatistics.length > 1) {
                        var qaUser = "";
                        var data = [];
                        for (var index = 2; index < reportStatistics.length; index++) {
                            data = getQAStatusData(reportStatistics[index]);
                            if (qaReportData.filter.isGroupedByUsersAndStatus) {
                                if (data.isUser) {
                                    qaUser = data.qaUser;
                                    if (userData[0,0] != "" && userData[0,0] !=undefined ) {                            
                                        qaStatistics = getQAStatisticsRowData(true,qaStatistics,userData,qaReportData,qaUser,null,false);
                                        for (var i = 0; i < userData.length; i++)
                                            delete userData[i];
                                        userData.length = 0;
                                    }
                                    userData = getQAStatisticsRowData(false, userData,data,qaReportData,qaUser,false,false);
                                    continue;
                                }
                            }

                            if (index == (reportStatistics.length - 1)) { // Appends the last row
                             qaStatistics = getQAStatisticsRowData(false, qaStatistics, data, qaReportData, qaUser, true, false);
                            } else {
                                qaStatistics = getQAStatisticsRowData(false, qaStatistics, data, qaReportData, qaUser, false, false);
                            }
                        }
                        data = getQAStatusData(reportStatistics[1]);
                        qaStatistics = getQAStatisticsRowData(false,qaStatistics, data, qaReportData, qaUser, false,true);
                        appendImageReports(qaStatistics);
                        alignTable();
                    }
                } else {
                    // TODO: Error
                }
            }
        }

        updateReportFilters(qaReportData);
    } catch (e) {}
}

/**
 * Update the report filters
 * @param {Type} qaReportData - Specifies the report data
 */
function updateReportFilters(qaReportData) {
    try {
        // Report flag
        var reportFlags = "";
        if (qaReportData.qaReviewReport.reportFlags.indexOf('D') > -1) {
            reportFlags += "<label>Include deleted images</label>";
        }

        if (qaReportData.qaReviewReport.reportFlags.indexOf('E') > -1) {
            reportFlags += "<br><label>Include existing images</label>";
        }

        if (qaReportData.qaReviewReport.reportFlags.indexOf('S') > -1) {
            reportFlags += "<br><label>Return image counts grouped by status</label>";
        } else if (qaReportData.qaReviewReport.reportFlags.indexOf('U') > -1) {
            reportFlags += "<br><label>Return image counts grouped by users and status</label>";
        }

        $("#imageReportFlags").html('');
        $("#imageReportFlags").html(reportFlags);

        var fromDate = getReportDateTime(qaReportData.qaReviewReport.fromDate);
        var toDate = getReportDateTime(qaReportData.qaReviewReport.throughDate);
        var startedAt = getReportDateTime(qaReportData.qaReviewReport.reportStartDateTime);

        // Report started at
        $("#imageReportStartedAt").html('');
         document.getElementById('imageReportStartedAt').innerText = 'This Report Was Started At: ' + startedAt;

        // Report date range
        var dateRange = "For Date Range: " + fromDate + " thru " + toDate;
        document.getElementById('imageReportDateRange').innerText = dateRange;

        // Report range
        $("#imageReportRange").html('<label >' + getDateRangeText({
            fromDate: fromDate,
            throughDate: toDate
        }) + '</label>');
    } catch (e) {}
}

/**
 * Get the statistics row data VAI-1316
 * @param {Type} data - Specifies the row data
 * @param {Type} qaReportData - Specifies the filter data
 * @param {Type} qaUser - Specifies the user
 * @param {Type} isLastRow - flag to know the last row
 */
function appendImageReports(data, qaReportData, qaUser, isLastRow) {
    var i = 0;
    for (i = 0; i < data.length; i++) {
        appendImageReportStatTbl(data[i])
    }
}

/** VAI-1316 Get the statistics row data
 * @param {Type} data - Specifies the row data 
 */
function appendImageReportStatTbl(data) {
    try {
        var qaUser= data[0];
        var qaStatus = data[1];
        var qaEntries = data[2];
        var qaPages = data[3];
        var qaIsLastRow = data[4];
        var qaPercent = data[5];
        var qaIsGroupedByStatus = data[6];
        var qaIsGroupedByUsersAndStatus = data[7];
        var qaIsUser = data[8];

        var user = qaUser;
        var isBold = false;

        if (qaIsGroupedByStatus || qaIsLastRow) {
            qaStatus = "";
        } else if (qaIsGroupedByUsersAndStatus) {
            if (qaIsUser) {
                user = qaUser;
                qaStatus = "";
                isBold = true;
            } else if (qaUser !== undefined) {
                user = qaUser;
            }
        }
        var table = document.getElementById("qaImageReportStatistics");
        var row1 = table.insertRow(-1);
        if (qaIsUser) {
            row1.style.backgroundColor = "#7b7b7e";
            row1.style.width = "100%";
            row1.style.fontWeight = "bold";
        } else if(qaIsLastRow) {
            row1.style.backgroundColor = "#343434";
            row1.style.width = "100%";
            row1.style.fontWeight = "bold";
        } else {
            row1.style.backgroundColor = "#343434";
            row1.style.width = "100%";
            if (isBold) row1.style.fontWeight = "bold";
            else row1.style.fontWeight = "normal";
        }

        var cell1 = row1.insertCell();
        var cell2 = row1.insertCell();
        var cell3 = row1.insertCell();
        var cell4 = row1.insertCell();
        var cell5 = row1.insertCell();

        cell1.textContent = user;
        cell1.style.width = "20%";

        cell2.textContent = qaStatus;
        cell2.style.width = "20%";

        cell3.textContent = qaEntries;
        cell3.style.width = "20%";

        cell4.textContent = qaPages;
        cell4.style.width = "20%";

        cell5.textContent = qaPercent;
        cell5.style.width = "20%";
    } catch (e) { }
    return;
}

/**
 * Get the statistics row data  (VAI-1316)
 * @param {Type} source - Specifies the source array to append to
 * @param {Type} data - Specifies the row data
 * @param {Type} qaReportData - Specifies the filter data
 * @param {Type} qaUser - Specifies the user
 * @param {Type} isLastRow - flag to know the last row
 */
function getQAStatisticsRowData(reformat, source, data, qaReportData, qaUser, isLastRow, isTotal) {
    var results = [[]];
    var user = "";
    var status = "";
    var entries = "";
    var pages = "";
    var qaPercent = "";
    var isGroupedByStatus = false;
    var isGroupedByUsersAndStatus = false;
    var isUser = false; 

    if (reformat) {
        user = data[0][0];
        status = data[0][1];
        entries = data[0][2];
        pages = data[0][3];
        isLastRow= data[0][4];
        qaPercent = data[0][5];
        isGroupedByStatus = data[0][6];
        isGroupedByUsersAndStatus = data[0][7];
        isUser = data[0][8];
        qaUser = user;
    } else {
        if (data.displayValueInFirstColumn)
            status = data.displayValueInFirstColumn;
        if (data.totalImageEntries)
            entries = data.totalImageEntries;
        if (data.totalImagePages)
            pages = data.totalImagePages;
        if (data.qaPercent)
            qaPercent = data.qaPercent;
        if (data.isUser)
            isUser = data.isUser;
        if (qaReportData.filter.isGroupedByStatus)
            isGroupedByStatus = qaReportData.filter.isGroupedByStatus;
        if (qaReportData.filter.isGroupedByUsersAndStatus)
            isGroupedByUsersAndStatus = qaReportData.filter.isGroupedByUsersAndStatus;
    }

    if (isGroupedByStatus || isLastRow) {
        user = status; // Moves the text "Viewable" from status col to user col
        status = "";
    } else if (isGroupedByUsersAndStatus) {
        if (isUser) {
            user = qaUser;
        } else if (qaUser !== undefined) {
            user = qaUser;
        }
        if (isTotal) {
            user = status;// Moves the text "Totals" from status col to user col
            status = "";
        }
    }
    results[0, 0] = user;
    results[0, 1] = status;
    results[0, 2] = entries;
    results[0, 3] = pages;
    results[0, 4] = isLastRow;
    results[0, 5] = qaPercent;
    results[0, 6] = isGroupedByStatus;
    results[0, 7] = isGroupedByUsersAndStatus;
    results[0, 8] = isUser;

    source.push(results);
    return source;
}

/**
 * Get the qa status data
 * @param {Type} qaData - Specifies the qa data
 */
function getQAStatusData(qaData) {
    try {
        var qaStatisticsData = qaData.split('^');
        return {
            sortByQAStatus: qaStatisticsData[0],
            noOfGroup: qaStatisticsData[1],
            noOfChildInGroup: qaStatisticsData[2],
            userDuz: qaStatisticsData[3],
            displayValueInFirstColumn: qaStatisticsData[4],
            totalImageEntries: qaStatisticsData[5],
            totalImagePages: qaStatisticsData[6],
            qaPercent: (qaStatisticsData.length > 7 ? qaStatisticsData[7] : ""),
            isUser: (qaStatisticsData[0] == "U" ? true : false),
            qaUser: qaStatisticsData[4],
        };
    } catch (e) {}

    return undefined;
}

/**
 * Get the json data from xml data
 * @param {Type} xmlData - Specifies the xml data
 */
function getJsonData(xmlData) {
    try {
        if (xmlData) {
            var xmlDoc;
            if (window.DOMParser) {
                var parser = new DOMParser();
                xmlDoc = parser.parseFromString(xmlData, "text/xml");
                xmlContent = new XMLSerializer().serializeToString(xmlDoc);
            } else {
                xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
                xmlDoc.async = false;
                xmlDoc.loadXML(xmlData);
            }

            return xmlToJson(xmlDoc);
        }
    } catch (e) {}

    return undefined;
}

function xmlToJson(xml) {
    var obj = {};
    if (xml.nodeType == 1) {
        if (xml.attributes.length > 0) {
            obj["attributes"] = {};
            for (var j = 0; j < xml.attributes.length; j++) {
                var attribute = xml.attributes.item(j);
                obj["attributes"][attribute.nodeName] = attribute.nodeValue;
            }
        }
    } else if (xml.nodeType == 3) {
        obj = xml.nodeValue;
    }

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

function exportReportToCSV() {
    var html = document.querySelector('#exportReportTable').outerHTML;
    export_table_to_csv(html, "QAReviewReportStatistic.csv");
}

function export_table_to_csv(html, filename) {
    var csv = [];
    var header = document.querySelectorAll("#qaImageReportStatisticsTH th")
    var rows = document.querySelectorAll("#exportReportTable tr");
    var row = [];

    for (var i = 0; i < header.length; i++) {
        row.push((header[i].innerText).replace(",", "-"));
    }

    csv.push(row.join(","));

    for (var i = 0; i < rows.length; i++) {
        row = [];
        cols = rows[i].querySelectorAll("td, th");

        for (var j = 0; j < cols.length; j++)
            row.push((cols[j].innerText).replace(",", "-"));

        csv.push(row.join(","));
    }

    // Download CSV
    download_csv(csv.join("\n"), filename);
}

function download_csv(csv, filename) {
    var csvFile;
    var downloadLink;

    if (window.navigator.msSaveBlob) { // IE 10+
        //alert('IE' + csv);
        window.navigator.msSaveOrOpenBlob(new Blob([csv], {
            type: "text/plain;charset=utf-8;"
        }), filename);
        return;
    }

    // CSV FILE
    csvFile = new Blob([csv], {
        type: "text/csv"
    });

    // Download link
    downloadLink = document.createElement("a");

    // File name
    downloadLink.download = filename;

    // We have to create a link to the file
    downloadLink.href = window.URL.createObjectURL(csvFile);

    // Make sure that the link is not displayed
    downloadLink.style.display = "none";

    // Add the link to your DOM
    document.body.appendChild(downloadLink);

    // Lanzamos
    downloadLink.click();
}

function qaReportTableAlignment() {
    // Change the selector if needed
    var $table = $('table.scroll'),
        $bodyCells = $table.find('tbody tr:first').children(),
        colWidth;

    // Adjust the width of thead cells when window resizes
    $(window).resize(function () {
        alignTable();
    }).resize(); // Trigger resize handler
}

/**
 * Bind events
 */
function bindEvents() {
    try {
        // Captured users
        $('#fromDate').unbind('change');
        $('#fromDate').change(function () {
            updateDateRange();
        });

        // Select filter
        $("#toDate").unbind('change');
        $("#toDate").change(function () {
            updateDateRange();
        });
        $("#toDate").change();
    } catch (e) {}
}

/**
 * Update the date range
 */
function updateDateRange(dateRange) {
    try {
        var dateRange = {
            fromDate: $("#fromDate").val(),
            throughDate: $("#toDate").val()
        };

        $("#runReport")[0].searchQuery.fromDate = dateRange.fromDate.replace(new RegExp('/', 'g'), '');
        $("#runReport")[0].searchQuery.toDate = dateRange.throughDate.replace(new RegExp('/', 'g'), '');
        $("#applyDateRange")[0].innerHTML = getDateRangeText(dateRange);
    } catch (e) {}
}

$(window).resize(function () {
    resizeFrames();
});

function resizeFrames() {
    var panelHeight = $(window).height() - getElementOffset($(".col-xs-12")[0]).top - 20;
    $(".col-xs-12").height(panelHeight);

    panelHeight = ($(window).height() * 0.5) - getElementOffset($("#reportRequestTable")[0]).top - 20;
    $("#reportRequestTable").height(panelHeight);

    setTimeout(function () {
        var tableBottom = $("#reportRequestTable").css("bottom");
        $("#selectedReportInfo").css("top", (tableBottom - 100) + "px");

        var panelHeight = $(window).height() - getElementOffset($(".panel-header-top")[0]).top - 16;
        $(".panel-header-top").height(panelHeight);

        var tableRect = $("#qaImageReportStatisticsTH")[0].getBoundingClientRect();
        var panelRect = $("#qaUserReportPanelBody")[0].getBoundingClientRect();
        if ($("#qaImageReportStatisticsTH")[0]) {
            var tableHeight = "100px";
            if (tableRect && panelRect) {
                tableHeight = Math.abs(tableRect.bottom - panelRect.bottom) + "px";
            }
            document.getElementById("qaImageReportTable").style.height = tableHeight;
        }
    }, 100);
}

function getElementOffset(el) {
    var top = 0;
    var left = 0;
    if (el) {
        var element = el;

        // Loop through the DOM tree
        // and add it's parent's offset to get page offset
        do {
            top += element.offsetTop || 0;
            left += element.offsetLeft || 0;
            element = element.offsetParent;
        } while (element);
    }

    return {
        top: top,
        left: left
    };
}

function alignTable() {
    var tableHeader = $("#reportRequestTable th");
    var tableRows = $("#qaImageReporttblBody tr");

    tableRows.each(function (key, value) {
        var tableCols = value.children;
        for (var i = 0; i < tableCols.length; i++) {
            var element = tableCols[i];
            $(element).width(tableHeader.eq(i).width());
        }
    });

    tableHeader = $(".panel-header-top th");
    tableRows = $("#qaImageReportStatistics tr");

    tableRows.each(function (key, value) {
        var tableCols = value.children;
        for (var i = 0; i < tableCols.length; i++) {
            var element = tableCols[i];
            $(element).width(tableHeader.eq(i).width());
        }
    });
}
