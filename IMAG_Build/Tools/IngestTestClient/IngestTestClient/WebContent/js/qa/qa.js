 var qaSearchParamUrl = window.location.origin + "/vix/viewer/qa/search/params" + window.location.search;
 var qaSearchUrl = window.location.origin + "/vix/viewer/qa/search";
 var qaCaptureUsersUrl = window.location.origin + "/vix/viewer/qa/search/captureusers";
 var qaImageFiltersUrl = window.location.origin + "/vix/viewer/qa/search/imagefilters";
 var qaImageFilterDetailsUrl = window.location.origin + "/vix/viewer/qa/search/imagefilterdetails";
 var qaImagePropertiesUrl = window.location.origin + "/vix/viewer/qa/review/imageproperties";
 var qaStudyQueryUrl = window.location.origin + "/vix/viewer/studyquery";
 var qaReportsUrl = window.location.origin + "/vix/viewer/qa/reports";

 var studyDetails = {};
 var height = 0;
 var width = 0;

 /**
  * Call the processStudy() method to load all the patient and study information 
  * Default the first row of the table should be hightlighed and based on the selection 
  * the above box will fill the patient information
  */
 $(document).ready(function () {
     $(".study-filter").attr("disabled","disabled");
     height = $(window).height();
     height -= $('.text-on-pannel').height();
     height -= $("#panel-body-height")[0].offsetTop;

     width = $(window).width() - $('#panel-body-height')[0].clientWidth;
     width -= $("#panel-body-height")[0].offsetLeft;

     $('#panel-body-height').css("height", height);
     $('#home-patient-table-id').css("height", height - ($(".table-bordered")[0].offsetTop + $(".table-bordered").height()));
     $('#nav-tab-width-id').css("width", width);

     loadAndSelectDatePicker();

     var currentDate = new Date();
     var currentMonth = currentDate.getMonth() + 1;
     var day = currentDate.getDate();
     var todayDate = currentDate.getFullYear() + '/' + (('' + currentMonth).length < 2 ? '0' : '') + currentMonth + '/' + (('' + day).length < 2 ? '0' : '') + day;

     $("#startDateId").val(todayDate);
     $("#endDateId").val(todayDate);
     $("#fromDateId").val(todayDate);
     $("#toDateId").val(todayDate);

     bindEvents();
     applySelectedRangeDate("today");
 });

 /**
  * Based on selection of the table body row
  * the row will be highlighted
  */
 /* $('#home-patient-info-table').on('click', 'tbody tr', function(event) 
  {
      $(this).addClass('highlight').siblings().removeClass('highlight');
      var groupIEN =$(this).find('td:first').text();
      clearPatientDetail();
      getPatientDetail(groupIEN);
  }); */

 function enableNextAndPrvBtn(rows) {
     if (!isNullOrUndefined(rows)) {
         var preRow = $(rows).closest('tr').prev('tr');
         var nextRow = $(rows).closest('tr').next('tr');
         if (preRow.length <= 0 && nextRow.length > 0) {
             $('#nextStudyBtn').attr("disabled", false);
             $('#previousStudyBtn').attr("disabled", true);
         } else if (nextRow.length <= 0 && preRow.length > 0) {
             $('#previousStudyBtn').attr("disabled", false);
             $('#nextStudyBtn').attr("disabled", true);
         } else {
             $('#nextStudyBtn').attr("disabled", false);
             $('#previousStudyBtn').attr("disabled", false);
         }
     }
 }

/**
 * Display the viewer
 * @param {Type} studyId - Specifies the study id
 * @param {Type} clickedRow - Flag to click the row
 */ 
function displayViewer(studyId, clickedRow) {
     manageStudy();
     updateStudyDetail(studyId);
     enableNextAndPrvBtn(clickedRow);
}

/**
 * Display the image manager
 * @param {Type} studyId - Specifies the study id
 * @param {Type} clickedRow - Flag to click the row
 */ 
function displayImageManager(studyId, clickedRow) {
    manageImage();
    updateStudyDetail(studyId);
    enableNextAndPrvBtn(clickedRow);
}

/**
 * Display the report
 * @param {Type} studyId - Specifies the study id
 * @param {Type} clickedRow - Flag to click the row
 */ 
function displayReport(studyId, clickedRow) {
    manageReport();
    updateStudyDetail(studyId);
    enableNextAndPrvBtn(clickedRow);
}

/**
 * Highlight the row
 */ 
function highlightRow() {
     $('#home-patient-info-table').on('click', 'tbody tr', function (event) {
         $(this).addClass('highlight').siblings().removeClass('highlight');
     });
 }

 /**
  * Getting study information 
  * by passing studyId
  */
 function getStudyDetail(studyId) {
     if (studyDetails !== null && studyDetails !== undefined) {
         return studyDetails[studyId];
     }
 }

/**
 * clear patient details
 */ 
 function clearPatientDetail() {
     $('#home-patient-name').html('');
     $('#home-patient-id').html('');
     $('#home-patient-shortdesc').html('');
     $('#home-patient-specialty').html('');
     $('#home-patient-type').html('');
     $('#home-patient-status').html('');
     $('#home-patient-procedure').html('');
 }

/**
 * Display the viewers
 * @param {Type} study - Specifies the study 
 */ 
function displayViewers(study) {
    clearViewers();

    var frameHeight = height - ($(".tab-content")[0].offsetTop + $("#panel-body-height")[0].offsetTop);
    var frameWidth = $(".tab-content").width();

    $("#home-viewer").append('<br /><iframe src="' + study.viewerUrl + '" width="' + frameWidth + '" height="' + frameHeight + '"/>');
    $("#home-images").append('<br /><iframe src="' + study.manageUrl + '" width="' + frameWidth + '" height="' + frameHeight + '"/>');
    $("#home-report").append('<br /><iframe src="' + study.reportUrl + '" width="' + frameWidth + '" height="' + frameHeight + '"/>');
}

/**
 * Clear the viewers
 */
function clearViewers() {
    $("#home-viewer").html('');
    $("#home-images").html('');
    $("#home-report").html('');
}

function manageStudy() {
     $('#home-tab-id a[href="#home-viewer"]').trigger('click');
}

function manageImage() {
     $('#home-tab-id a[href="#home-images"]').trigger('click');
}

function manageReport() {
     $('#home-tab-id a[href="#home-report"]').trigger('click');
}

function loadNextStudy() {
     var rows = getHighlightRow();
     if (!isNullOrUndefined(rows)) {
         var nextRow = $(rows).closest('tr').next('tr');
         if (!isNullOrUndefined(nextRow) && nextRow.length > 0) {
             $(nextRow).addClass('highlight').siblings().removeClass('highlight');
             updateStudyDetail(nextRow[0].id);
             $('#previousStudyBtn').attr("disabled", false);
         } else {
             $('#nextStudyBtn').attr("disabled", true);
         }
     }
}

function loadPreviousStudy() {
     var rows = getHighlightRow();
     if (!isNullOrUndefined(rows)) {
         var preRow = $(rows).closest('tr').prev('tr');
         if (!isNullOrUndefined(preRow) && preRow.length > 0) {
             $(preRow).addClass('highlight').siblings().removeClass('highlight');
             updateStudyDetail(preRow[0].id);
             $('#nextStudyBtn').attr("disabled", false);
         } else {
             $('#previousStudyBtn').attr("disabled", true);
         }
     }
}

function getHighlightRow() {
     return $('#home-patient-info-table > tbody > tr.highlight');
}

function isNullOrUndefined(obj) {
     if (obj === undefined || obj === null) {
         return true;
     }
     return false;
}

/**
 * Search study
 */ 
function doSearch() {
     try
     {
         var searchQuery = $("#home-search-of")[0].searchQuery;
         if(!searchQuery) {
             // TODO: display error message
             return;
         }

         var filters =
         {
             studyFilter: {
                 captureSavedBy: searchQuery.captureSavedBy,
                 fromDate: searchQuery.fromDate,
                 toDate: searchQuery.toDate,
                 includeMuseOrders: false,
                 includePatientOrders: true,
                 includeEncounterOrders: true,
                 filterClass: searchQuery.filterClass
             }
         };

         showAndHideSplashWindow("show", "Searching the study...", "qa_page");
         var searchUrl = qaSearchUrl + "/" + getUrlParameter("SiteNumber") + window.location.search;
         $.ajax({
             url: searchUrl,
             method: 'POST',
             async: true,
             data: getXml(filters),
             success: function (data) {
                 showAndHideSplashWindow("success", "Sucessfully searched the study", "qa_page");
                 updateStudy(data);
             },
             error: function (xhr, status) {
                 showAndHideSplashWindow("success", "Failed to search the study", "qa_page");
                 updateStudy(undefined);
             }
         });
     } catch (e) {}
 }

/**
 * Update the capture users
 * @param {Type} searchFilter - Specifies the search filter
 * @param {Type} isHomeCapturedUsers - Specifies the flag to home uers
 */ 
function updateCaptureUsers(searchFilter, isHomeCapturedUsers) {
    try {
        var captureUsersUrl = qaCaptureUsersUrl + "/" + searchFilter.fromDate + "/" + searchFilter.throughDate + window.location.search;
        $.ajax({
            url: captureUsersUrl,
            method: 'GET',
            async: true,
            success: function (data) {
                refreshCaptureUsers(data, searchFilter, isHomeCapturedUsers);
            },
            error: function (xhr, status) {
                console.log(xhr.statusText + "\nFailed to get the capture users.");
                refreshCaptureUsers(undefined, searchFilter, isHomeCapturedUsers);
            }
        });
    } catch (e) {}
}

/**
 * Refresh the capture users
 * @param {Type} xmlData - Specifies the xml data
 * @param {Type} searchFilter - Specifies the search filter
 * @param {Type} isHomeCapturedUsers - Specifies the flag to home uers
 */ 
function refreshCaptureUsers(xmlData, searchFilter, isHomeCapturedUsers) {
    try
    {
        var cuId = undefined;
        var searchId = undefined;
        var cuOptionPrefixId = undefined;
        if(isHomeCapturedUsers) {
            $("#home-captured-by").html('');
            $('#home-date-range').html('');
            $('#home-date-range').val(searchFilter.searchOption);

            cuId = "#home-captured-by";
            searchId = "#home-search-of";
            cuOptionPrefixId = "home-cu-";
        } else {
            $('#select-user-id').html('');
            cuId = "#select-user-id";
            searchId = "#imageReport";
            cuOptionPrefixId = "ir-cu-";
        }

        var captureUsers = getJsonData(xmlData);
        if (captureUsers) {
            var captureUserResults = captureUsers.captureUserResults;
            if (captureUserResults && captureUserResults.captureUser) {

                // Enable/ Disable the home controls
                if(isHomeCapturedUsers) {
                    $(".study-filter").attr("disabled", false);
                    $('#previousStudyBtn').attr("disabled", true);
                }

                var captureUserInc = 1;
                captureUserResults.captureUser.forEach(function (value) {
                    $(cuId)[0].innerHTML += ('<option id=' + cuOptionPrefixId + captureUserInc +'>' + value.userName + '</option>');
                    captureUserInc++;
                });

                // Hold capture user values to the corresponding <option>
                captureUserInc = 1;
                captureUserResults.captureUser.forEach(function (value) {
                    $("#" + cuOptionPrefixId + captureUserInc)[0].filters =
                    {
                        captureUser: value ,
                        isFiltersUpated: false
                    };

                    captureUserInc++;
                });

                $(searchId)[0].searchQuery = {fromDate: searchFilter.fromDate, toDate: searchFilter.throughDate};
                $(cuId).change();
            } else if(isHomeCapturedUsers) {
                $(".study-filter").attr("disabled", "disabled");
            }
        }
    }
    catch (e)
    { }
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

 /**
  * Click on select button open new modal window to select date range 
  */
function loadSelectModalWindow(){
     $("#selectRangeModalWindow").modal('show');
}

 function padZero(number, length) {
     var str = '' + number;
     while (str.length < length) {
         str = '0' + str;
     }

     return str;
 }

 /**
  * Select range based on today, yesterday, last 2 days, last 3 days, last full week, current week, select date range
  */
 function applySelectedRangeDate(searchOption) {
     try {
         closeModalWin();
         var today = new Date();
         var dateRange = {
             fromDate: 0,
             throughDate: 0,
             searchOption: ""
         };

         switch (searchOption) {
             case "today":
                 {
                     dateRange.fromDate = today.getFullYear().toString() +
                     padZero(today.getMonth() + 1, 2).toString() +
                     padZero(today.getDate(), 2).toString();
                     dateRange.throughDate = dateRange.fromDate;
                     dateRange.searchOption = "Today";
                     break;
                 }

             case "yesterday":
                 {
                     var yesterday = new Date(today);
                     yesterday.setDate(today.getDate() - 1);

                     dateRange.fromDate = yesterday.getFullYear().toString() +
                     padZero(yesterday.getMonth() + 1, 2).toString() +
                     padZero(yesterday.getDate(), 2).toString();
                     dateRange.throughDate = dateRange.fromDate;
                     dateRange.searchOption = "Yesterday";
                     break;
                 }

             case "last2days":
                 {
                     var last2days = new Date(today);
                     last2days.setDate(today.getDate() - 2);

                     dateRange.fromDate = last2days.getFullYear().toString() +
                     padZero(last2days.getMonth() + 1, 2).toString() +
                     padZero(last2days.getDate(), 2).toString();

                     last2days.setDate(last2days.getDate() + 1);
                     dateRange.throughDate = last2days.getFullYear().toString() +
                     padZero(last2days.getMonth() + 1, 2).toString() +
                     padZero(last2days.getDate(), 2).toString();
                     dateRange.searchOption = "Last 2 days";
                     break;
                 }

             case "last3days":
                 {
                     var last3days = new Date(today);
                     last3days.setDate(today.getDate() - 3);

                     dateRange.fromDate = last3days.getFullYear().toString() +
                     padZero(last3days.getMonth() + 1, 2).toString() +
                     padZero(last3days.getDate(), 2).toString();

                     last3days.setDate(last3days.getDate() + 2);
                     dateRange.throughDate = last3days.getFullYear().toString() +
                     padZero(last3days.getMonth() + 1, 2).toString() +
                     padZero(last3days.getDate(), 2).toString();
                     dateRange.searchOption = "Last 3 days";
                     break;
                 }

             case "lastfullweek":
                 {
                     var lastfullWeek = new Date(today);
                     lastfullWeek.setDate(today.getDate() - (today.getDay() + 7));

                     dateRange.fromDate = lastfullWeek.getFullYear().toString() +
                     padZero(lastfullWeek.getMonth() + 1, 2).toString() +
                     padZero(lastfullWeek.getDate(), 2).toString();

                     lastfullWeek.setDate(lastfullWeek.getDate() + 6);
                     dateRange.throughDate = lastfullWeek.getFullYear().toString() +
                     padZero(lastfullWeek.getMonth() + 1, 2).toString() +
                     padZero(lastfullWeek.getDate(), 2).toString();
                     dateRange.searchOption = "Last full week";
                     break;
                 }

             case "currentweek":
                 {
                     var currentWeek = new Date(today);
                     currentWeek.setDate(today.getDate() - today.getDay());

                     dateRange.fromDate = currentWeek.getFullYear().toString() +
                     padZero(currentWeek.getMonth() + 1, 2).toString() +
                     padZero(currentWeek.getDate(), 2).toString();

                     dateRange.throughDate = today.getFullYear().toString() +
                     padZero(today.getMonth() + 1, 2).toString() +
                     padZero(today.getDate(), 2).toString();
                     dateRange.searchOption = "Current week";
                     break;
                 }

             case "selectdaterange":
                 {
                     var startDate = $("#startDateId").val();
                     var endDate = $("#endDateId").val();
                     if (!isNullOrUndefined(startDate) && !isNullOrUndefined(endDate)) {
                         dateRange.fromDate = startDate.replace(new RegExp('/', 'g'), '');;
                         dateRange.throughDate = endDate.replace(new RegExp('/', 'g'), '');;
                         dateRange.searchOption = "Date range";
                         break;
                     } else {
                         alert("Please select start and end date !!!");
                     }

                 }

             default:
                 break;
         }

         updateCaptureUsers(dateRange, true);
     } catch (e) {

     }
 }

 /**
  * Load date picker while click on start and end date text box
  * Click calender icon to load date picker
  */
 function loadAndSelectDatePicker() {
     $('#startDateId').datepicker({
         autoHide: true,
         zIndex: 2048,
     });

     $('#endDateId').datepicker({
         autoHide: true,
         zIndex: 2048,
     });
     
     $('#fromDateId').datepicker({
          autoHide: true,
          zIndex: 2048,
     });

      $('#toDateId').datepicker({
          autoHide: true,
          zIndex: 2048,
     });

     /* $('.input-group-addon').datepicker({
          autoHide: true,
          zIndex: 2048,
     });

      $('.input-group-addon').datepicker({
          autoHide: true,
          zIndex: 2048,
     });*/
 }

 /**
  * Close the modal window after clicking cancel button or else click on close icon
  */
 function closeModalWin() {
     $("#selectRangeModalWindow").modal('hide');
 }

/**
 * Display the image reports
 */
function displayImageReports(){
    $("#imageReportWindow").modal('show');
}

/**
 * Update image reports
 * @param {Type} searchParams - Specifies the search params
 */ 
function queueImageReports(searchFilter) {
    try
    {
        var flags = searchFilter.flags;
        var fromDate = searchFilter.fromDate;
        var toDate = searchFilter.toDate;

        var queueReportsUrl = qaReportsUrl + "/" + flags + "/" + fromDate + "/" + toDate + window.location.search;
        $.ajax({
            url: queueReportsUrl,
            method: 'GET',
            async: true,
            success: function (data) {
                updateImageReports(searchFilter);
            },
            error: function (xhr, status) {
                refreshImageReports(undefined);
            }
        });
    }
    catch (e)
    { }
}

/**
 * Update the image reports
 * @param {Type} searchFilter - Specifies the search filter
 */ 
function updateImageReports(searchFilter) {
    try
    {
        var imageReportsUrl = qaReportsUrl + "/" + searchFilter.captureUserId + window.location.search;
        $.ajax({
            url: imageReportsUrl,
            method: 'GET',
            async: true,
            success: function (data) {
                refreshImageReports(data, searchFilter);
            },
            error: function (xhr, status) {
                refreshImageReports(undefined);
            }
        });
    }
    catch (e)
    { }
}

/**
 * Refresh the image reports
 * @param {Type} xmlData - Specifies the xml data
 */ 
function refreshImageReports(xmlData, searchFilter) {
    try
    {
        $("#user-report-tbody").html('');
        if(xmlData) {
            var reviewReports = getJsonData(xmlData);
            if(reviewReports) {
                var qaReviewReports = reviewReports.qaReviewReports;
                if (qaReviewReports && qaReviewReports.qaReviewReport) {
                    var reviewReportInc = 1;
                    var reports = "";
                    qaReviewReports.qaReviewReport.forEach(function (reportValue) {
                        var reportType = "TBD";
                        var status = "TBD";
                        var fromDate = reportValue.fromDate;
                        var toDate = reportValue.throughDate;
                        var startedAt = reportValue.reportStartDateTime;
                        var endedAt = reportValue.reportCompletedDateTime;

                        reports += "<tr id=user-report-" + reviewReportInc + " ondblclick='displayImageReportStatistics(this)'><td style='width: 20%'>"+ reportType +"</td><td style='width: 10%'>"+ status +"</td><td style='width: 10%'>"+ fromDate +"</td><td style='width: 10%'>" + toDate + "</td><td style='width: 10%'>"+ startedAt +"</td><td style='width: 10%'>"+ endedAt +"</td></tr>";
                        
                        reviewReportInc++;
                    });
                    $("#user-report-tbody").append(reports);

                    // Hold the reports
                    reviewReportInc = 1;
                    qaReviewReports.qaReviewReport.forEach(function (reportValue) {
                        $("#user-report-" + reviewReportInc)[0].qaReportData = 
                        {
                            filter : searchFilter,
                            qaReviewReport: reportValue
                        };

                        reviewReportInc++;
                    });
                }
            }
        }
    }
    catch(e)
    { }
}

/**
 * Hide the image reports window
 */
function hideImageReports(){
    $("#imageReportWindow").modal('hide');
}

/**
 * Display the image report statistics
 * @param {Type} currentRow - Selected row
 */ 
function displayImageReportStatistics(currentRow) {
    $(currentRow).addClass('highlight').siblings().removeClass('highlight');
    updateImageReportStatistics(currentRow.qaReportData);
}

/**
 * Update the image statistics
 * @param {Type} qaReportData - Specifies the report data
 */ 
function updateImageReportStatistics(qaReportData) {
    try
    {
        var flags = qaReportData.filter.flags;
        var fromDate = qaReportData.filter.fromDate;
        var toDate = qaReportData.filter.toDate;

        var queueReportsUrl = qaReportsUrl + "/" + flags + "/" + fromDate + "/" + toDate + window.location.search;
        $.ajax({
            url: queueReportsUrl,
            method: 'GET',
            async: true,
            success: function (data) {
                refreshReportStatistics(data, qaReportData);
            },
            error: function (xhr, status) {
                refreshReportStatistics(undefined);
            }
        });
    }
    catch (e)
    { }
}

/**
 *
 * @param {Type} xmlData - Specifies the xml data
 * @param {Type} qaReportData - Specifies the report data
 */
function refreshReportStatistics(xmlData, qaReportData) {
    try
    {
        $("#imageReportStatistics").html('');
        if(xmlData) {
            var reviewReportStatistics = getJsonData(xmlData);
            if(reviewReportStatistics && reviewReportStatistics.restStringType) {
                alert(reviewReportStatistics.restStringType.value);

                var reportStatistics = reviewReportStatistics.restStringType.value;
                reportStatistics = reportStatistics.split('\n');
                if(reportStatistics[0].indexOf('1^Ok') > -1) {
                    if(reportStatistics.length > 1) {
                        var reportStatistics = "";
                        var totalStatistics = reportStatistics[1];
                        for(var index = 2; index < reportStatistics.length; index++) {
                            // TODO: 
                        }
                    }
                } else {
                    // TODO: Error
                }
            }

            /*currentUserInformation += "<tr><td style='width: 15%'>User "+ i +"</td><td style='width: 10%'>Viewable "+ i +"</td><td style='width: 10%'>3</td><td style='width: 10%'>10</td><td style='width: 10%'></td></tr>";*/
        }

        $("#imageReportStatisticWindow").modal('show');
    }
    catch (e)
    { }
}

/**
 * Hide the image report statistics
 */ 
function hideimageReportStatistics(){
    $("#imageReportStatisticWindow").modal('hide');
}

function loadUserByStartAndEndDate() {
    try
    {
        var dateRange = {
            fromDate: 0,
            throughDate: 0,
            searchOption: ""
        };

        var startDate = $("#fromDateId").val();
        var endDate = $("#toDateId").val();
        if (!isNullOrUndefined(startDate) && !isNullOrUndefined(endDate)) {
            dateRange.fromDate = startDate.replace(new RegExp('/', 'g'), '');;
            dateRange.throughDate = endDate.replace(new RegExp('/', 'g'), '');;
            dateRange.searchOption = "Date range";
            updateCaptureUsers(dateRange, false);
        } else {
            alert("Please select start and end date !!!");
        }
    }
    catch(e)
    { }
}

/**
 * Run the report
 */
function runReport() {
    try
    {
        var searchQuery = $("#imageReport")[0].searchQuery;
        if(!searchQuery) {
            // TODO: display error message
            return;
        }

        searchQuery.includeDeletedImages = $("#deleteImages")[0].checked;
        searchQuery.includeExistingImages = $("#existingImages")[0].checked;
        searchQuery.isGroupedByStudies = $("#groupedByStudies")[0].checked;
        searchQuery.isGroupedByUsersAndStatus = $("#groupedByUser")[0].checked;
        searchQuery.flags = "C";

        if(searchQuery.includeDeletedImages) {
            searchQuery.flags += "D";
        }

        if(searchQuery.includeExistingImages) {
            searchQuery.flags += "E";
        }

        if(searchQuery.isGroupedByStudies) {
            searchQuery.flags += "S";
        }

        if(searchQuery.isGroupedByUsersAndStatus) {
            searchQuery.flags += "U";
        }

        queueImageReports(searchQuery);
    }
    catch(e)
    { }
}

function exportReportToCSV(){
   var html = document.querySelector('#exportReportTable').outerHTML;
	export_table_to_csv(html, "QAReviewReportStatistic.csv");
}

function download_csv(csv, filename) {
    var csvFile;
    var downloadLink;

    // CSV FILE
    csvFile = new Blob([csv], {type: "text/csv"});

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

function export_table_to_csv(html, filename) {
	var csv = [];
	var rows = document.querySelectorAll("#exportReportTable tr");
	
    for (var i = 0; i < rows.length; i++) {
		var row = [], cols = rows[i].querySelectorAll("td, th");
		
        for (var j = 0; j < cols.length; j++) 
            row.push(cols[j].innerText);
        
		csv.push(row.join(","));		
	}

    // Download CSV
    download_csv(csv.join("\n"), filename);
}

/**
 * Bind the events with controls
 */ 
function bindEvents() {
    try
    {
        // Captured users
        $("#home-captured-by").unbind('change');
        $("#home-captured-by").change(function() {
            var filters = this[this.selectedIndex].filters;
            if(filters) {
                var imageFilters = filters.imageFilters;
                if(!filters.isFiltersUpated && !imageFilters) {
                    fetchAndUpdateImageFilters(filters, (this.selectedIndex + 1));
                } else {
                    updateImageFilters(imageFilters, ("#home-cu-" + (this.selectedIndex + 1)));
                }
            }
        });

        // Select filter
        $("#home-filter-of").unbind('change');
        $("#home-filter-of").change(function() {
            var filters = this[this.selectedIndex].filters;
            if(filters) {
                var imageFilterDetails = filters.imageFilterDetails;
                var cuFilters = undefined;
                if(filters.captureUserId) {
                    cuFilters = $(filters.captureUserId)[0].filters;
                    if(cuFilters) {
                        imageFilterDetails = cuFilters.imageFilterDetails[filters.imageFilter.filterName];
                    }
                }

                if(!filters.isFiltersDetailsUpated && !imageFilterDetails) {
                    fetchAndupdateImageFilterDetails(cuFilters, filters);
                } else {
                    updateSearchQuery(cuFilters, filters);
                }
            }
        });

        // Captured users for image report
        $("#select-user-id").unbind('change');
        $("#select-user-id").change(function() {
            var filters = this[this.selectedIndex].filters;
            if(filters) {
                var searchQuery = $("#imageReport")[0].searchQuery;
                if(searchQuery && filters.captureUser) {
                    searchQuery.captureUserId = filters.captureUser.userId;
                }
            }
        });
    }
    catch(e)
    { }
}

/**
 * Update the search query
 * @param {Type} cuFilters - Specifies the capture users
 * @param {Type} filters - Specifies the filters
 */ 
function updateSearchQuery(cuFilters, filters) {
    try
    {
        var searchQuery = $("#home-search-of")[0].searchQuery;
        if(searchQuery && cuFilters) {
            if(cuFilters.captureUser) {
                searchQuery.captureSavedBy = cuFilters.captureUser.userId;
            }

            if(filters.imageFilterDetails) {
                searchQuery.filterClass = filters.imageFilterDetails.imageFilterDetail.classIndex;
            }
        }
    }
    catch(e)
    { }
}

/**
 * Get the image filters
 * @param {Type} captureUser - Specifies the capture user
 */ 
function fetchAndUpdateImageFilters(filters, cuId) {
    try
    {
        showAndHideSplashWindow("show", "Fetching the image filters ("+filters.captureUser.userName+")", "qa_page");
        var imageFiltersUrl = qaImageFiltersUrl + "/" + filters.captureUser.userId + "/" + window.location.search;
        $.ajax({
            url: imageFiltersUrl,
            method: 'GET',
            async: true,
            success: function (data) {
                filters.imageFilters = getJsonData(data);
                filters.isFiltersUpated = true;
                filters.imageFilterDetails = {};

                updateImageFilters(filters.imageFilters, ("#home-cu-" + cuId));
                showAndHideSplashWindow("success", "Successfully fetched the image filters");
            },
            error: function (xhr, status) {
                showAndHideSplashWindow("error", "Failed to fetch the image filters");
            }
        });
    }
    catch (e)
    { }
}

/**
 * Update the image filters
 * @param {Type} imageFilters - Specifies the image filters
 */ 
function updateImageFilters(imageFilters, captureUserId) {
    try
    {
        $("#home-filter-of").html('');
        if(imageFilters) {
            if (imageFilters.imageFilters && imageFilters.imageFilters.imageFilter) {
                var imageFilterInc = 1;
                imageFilters.imageFilters.imageFilter.forEach(function (value) {
                    $("#home-filter-of")[0].innerHTML += ('<option id=home-of-'+ imageFilterInc +'>' + value.filterName + '</option>');
                    imageFilterInc++;
                });

                // Hold image filter values to the corresponding <option>
                imageFilterInc = 1;
                imageFilters.imageFilters.imageFilter.forEach(function (value) {
                    $("#home-of-"+ imageFilterInc)[0].filters =
                    {
                        imageFilter: value,
                        isFiltersDetailsUpated: false,
                        captureUserId: captureUserId
                    };

                    imageFilterInc++;
                });

                $('#home-filter-of').change();
            }
        }
    }
    catch (e)
    { }
}

/**
 * Get the image filter details
 * @param {Type} imageFilter - Specifies the image filter
 */ 
function fetchAndupdateImageFilterDetails(cuFilters, filters) {
    try
    {
        showAndHideSplashWindow("show", "Fetching the image filters details ("+filters.imageFilter.filterName+")", "qa_page");
        var imageFilterDetailsUrl = qaImageFilterDetailsUrl + "/" + filters.imageFilter.filterIEN + "/" + window.location.search;
        $.ajax({
            url: imageFilterDetailsUrl,
            method: 'GET',
            async: true,
            success: function (data) {
                filters.imageFilterDetails = getJsonData(data);
                filters.isFiltersDetailsUpated = true;
                if(cuFilters) {
                    cuFilters.imageFilterDetails[filters.imageFilter.filterName] = filters.imageFilterDetails;
                }

                updateSearchQuery(cuFilters, filters);
                showAndHideSplashWindow("success", "Successfully fetched the image filter details");
            },
            error: function (xhr, status) {
                showAndHideSplashWindow("error", "Failed to fetch the image filter details");
            }
        });
    }
    catch (e)
    { }
}

/**
 * Get the json data from xml data
 * @param {Type} xmlData - Specifies the xml data
 */ 
function getJsonData(xmlData) {
    try
    {
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
    }
    catch(e)
    { }

    return undefined;
}

/**
 * Update the image properties
 * @param {Type} statusFlag - Specifies the status flag
 */ 
function updateImageProperties(statusFlag) {
    try
    {
        var row = getHighlightRow();
        if (!isNullOrUndefined(row) && row.length > 0) {
            var studyId = row[0].id;
            var imageId = studyId.split('-')[1];
            setImageProperties(statusFlag, imageId);
        } else {
            //TODo: error message
        }
    }
    catch(e)
    { }
}

/**
 * Set the image properties
 * @param {Type} statusFlag - Specifies the status flag
 * @param {Type} imageIEN  - Specifies the image IEN
 */ 
function setImageProperties(statusFlag, imageIEN) {
    try
    {
        showAndHideSplashWindow("show", "Set the image properties to "+ imageIEN, "qa_page");
        var imagePropertiesUrl = qaImagePropertiesUrl + "/" + imageIEN + window.location.search;
        $.ajax({
            url: imagePropertiesUrl,
            method: 'POST',
            async: true,
            data: statusFlag,
            success: function (data) {
                showAndHideSplashWindow("success", "Successfully set the image properties");
            },
            error: function (xhr, status) {
                showAndHideSplashWindow("error", "Failed to set the image properties");
            }
        });
    }
    catch (e)
    { }
}

/**
 * Get the url parameters
 * @param {Type} sParam - Specifies the param name
 */ 
function getUrlParameter(sParam) {
    try {
        sParam = sParam.toLowerCase();
        var sPageURL = decodeURIComponent(window.location.search).substring(1);
        var sURLVariables = sPageURL.split('&');
        for (var i = 0; i < sURLVariables.length; i++) {
            var eq = sURLVariables[i].indexOf("="); 
            var key = eq > -1 ? sURLVariables[i].substr(0, eq) : sURLVariables[i];
            var val = eq > -1 ? sURLVariables[i].substr(eq + 1) : "";

            if (key.toLowerCase() == sParam) {
                return val;
            }
        }
    }
    catch (e) {

    } finally {

    }
}

/**
 * Get the xml string
 * @param {Type} obj - Specifies the object to convert xml format
 */ 
function getXml(obj) {
    var xml = '';

    for (var prop in obj) {
        if (!obj.hasOwnProperty(prop)) {
            continue;
        }

        if (obj[prop] == undefined) {
            continue;
        }

        xml += "<" + prop + ">";
        if (typeof obj[prop] == "object") {
            xml += getXml(new Object(obj[prop]));
        } else {
            xml += obj[prop];
        }

        xml += "</" + prop + ">";
    }

    return xml;
}

/**
 * Update the study
 * @param {Type} studyData - Specifies the study data
 */ 
function updateStudy(studyData) {
    try
    {
        studyDetails = {};
        $('#home-patient-info-table-body').html('');
        clearPatientDetail();
        clearViewers();

        if(studyData) {
            var studies = getJsonData(studyData);
            if(studies) {
                var studyInc = 0;
                var studyInformation = "";
                var delimiterICN = 'icn';
                var delimiterDFN = 'dfn';
                var firstStudyId = undefined;
                studies.studies.study.forEach(function(study) {
                    var itemName = "Note #" + (studyInc + 1);
                    var patientName = study.patientName;
                    var imageCount = study.imageCount;
                    var imageId = study.firstImageId.split('-')[1];
                    var studyId = study.studyId;

                    // Check whether the patient id is icn or dfn
                    study.isICN = true;
                    var index = study.patientId.indexOf(delimiterICN);
                    if(index > -1) {
                        study.patientId = study.patientId.substring((index + delimiterICN.length + 1), study.patientId.length - 1);
                    } else {
                        index = study.patientId.indexOf(delimiterDFN);
                        if(index > -1) {
                            study.patientId = study.patientId.substring((index + delimiterDFN.length + 1), study.patientId.length - 1);
                            study.isICN = false;
                        }
                    }

                    if(!firstStudyId) {
                        firstStudyId = studyId;
                    }

                    studyInformation += '<tr id=\''+studyId+'\' onclick="displaySelectedStudy(this)"><td style="width: 22%; word-wrap: break-word;vertical-align: middle;">' + itemName + '</td><td style="width: 56%;word-wrap: break-word;vertical-align: middle;">' + patientName + '</td><td style="width: 18%;word-wrap: break-word;vertical-align: middle;">' + imageCount + '</td><td style="width:30%;word-wrap: break-word;vertical-align: middle;">' + imageId + '</td><td style="width:37%;text-align: center;vertical-align: middle;"><a class="btn btn-xs icon-link-color border-color-class" title="Viewer" onclick="displayViewer(\'' + studyId + '\', this)"><span class="glyphicon glyphicon-picture"></span></a> <a class="btn btn-xs icon-link-color border-color-class" title="Images" onclick="displayImageManager(\'' + studyId + '\', this)"><span class="glyphicon glyphicon-th-list"></span></a> <a class="btn btn-xs icon-link-color border-color-class" title="Report" onclick="displayReport(\'' + studyId + '\', this)"><span class="glyphicon glyphicon-calendar"></span></a></td></tr>';

                    studyDetails[studyId] = study;
                    //updateViewerUrls(study, true);
                    studyInc++;
                });

                $('#home-patient-info-table-body').append(studyInformation);
                $('#home-patient-info-table>tbody>tr').first().addClass('highlight');
                updateStudyDetail(firstStudyId);
                loadPreviousStudy();
            }
        }
    }
    catch(e)
    { }
}

/**
 * update study details
 * @param {Type} studyId - Specifies the id
 */ 
function updateStudyDetail(studyId) {
    try
    {
        clearPatientDetail();
        var study = getStudyDetail(studyId);
        if(study) {
            var align = " : "
            $('#home-patient-name').html(align + study.patientName);
            $('#home-patient-id').html(align + study.patientId);
            $('#home-patient-shortdesc').html(align + study.description);
            $('#home-patient-specialty').html(align + study.specialtyDescription);
            $('#home-patient-type').html(align + study.type);
            $('#home-patient-status').html(align + "N/A");
            $('#home-patient-procedure').html(align + study.event);

            // Check whether the viewer url is valid or not
            if(!study.viewerUrl) {
                updateViewerUrls(study, false);
            } else {
                displayViewers(study);
            }

            highlightRow();
        }
    }
    catch(e)
    { }
}

/**
 * Get study query
 * @param {Type} study - Specifies the study
 */ 
function getStudyQuery(study) {
    var headers = {};
    var contents = {};
    var studies = [];
    if (study.isICN) {
        contents["patientICN"] = study.patientId;
    } else {
        contents["patientDFN"] = study.patientId;
    }

    headers["Content-Type"] = "application/json";
    contents["siteNumber"] = getUrlParameter("SiteNumber");
    contents["securityToken"] = getUrlParameter("SecurityToken");

    studies.push({contextId: study.studyId });
    contents["studies"] = studies;

    return {Headers : headers, Contents : JSON.stringify(contents)};
}

/**
 * Query study
 * @param {Type} study - Specifies the study
 */ 
function updateViewerUrls(study, isAsync) {
    try
    {
        if(!isAsync) {
            showAndHideSplashWindow("show", "Processing study query...", "qa_page");
        }
        var searchQuery = getStudyQuery(study);
        $.ajax({
            url: qaStudyQueryUrl,
            data: searchQuery.Contents,
            headers: searchQuery.Headers,
            method: 'POST',
            dataType: 'json',
            async: isAsync,
            success: function(data) {
                if(data && data.studies) {
                    study.viewerUrl = data.studies[0].viewerUrl;
                    study.manageUrl = data.studies[0].manageUrl;
                    study.reportUrl = data.studies[0].reportUrl;

                    if(!isAsync) {
                        displayViewers(study);
                    }
                }
                if(!isAsync) {
                    showAndHideSplashWindow("success", "Sucessfully processed the study query");
                }
            },
            error: function(xhr, status) {
                if(!isAsync) {
                    showAndHideSplashWindow("error", "Failed to process the study query");
                }
            }
        });
    }
    catch(e)
    { }
}

/**
 * 
 * @param {Type} row - Specifies the selected row
 */ 
function displaySelectedStudy(row) {
    try
    {
        if(row) {
            enableNextAndPrvBtn(row);
            updateStudyDetail(row.id);
        }
    }
    catch(e)
    { }
}