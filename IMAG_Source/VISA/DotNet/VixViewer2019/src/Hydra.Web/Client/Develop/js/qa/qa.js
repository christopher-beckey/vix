var studyDetails = {};
var height = 0;
var width = 0;

var reqType = {
    imageInfo: "IMG_INFO",
    deleteImage: "IMG_D",
    indexEdit: "IMG_IE",
    needsReview: "IMG_NR",
    qaReviewed: "IMG_R",
    imageStatus: "IMG_STATUS",
    addStudy: "ADD_STUDY",
    closeStudy: "CLOSE_STUDY",
    emptyViewport: "EMPTY_VIEWPORT"
};

/**
 * Call the processStudy() method to load all the patient and study information 
 * Default the first row of the table should be hightlighed and based on the selection 
 * the above box will fill the patient information
 */
$(document).ready(function () {
    $(".search-filter").attr("disabled", "disabled");
    buttonsStyle();

    loadAndSelectDatePicker();

    var currentDate = new Date();
    var currentMonth = currentDate.getMonth() + 1;
    var day = currentDate.getDate();
    var todayDate = currentDate.getFullYear() + '/' + (('' + currentMonth).length < 2 ? '0' : '') + currentMonth + '/' + (('' + day).length < 2 ? '0' : '') + day;
    createIFrame();

    $("#startDateId").val(todayDate);
    $("#endDateId").val(todayDate);
    $("#fromDateId").val(todayDate);
    $("#toDateId").val(todayDate);

    $('select[multiple]').multiselect({
        columns: 1,
        placeholder: 'Select image status'
    });

    $('#ms-list-1').find('button').each(function () {
        this.disabled = false;
        this.classList.add('form-control');
    });

    $('#ms-list-1').find('div').each(function () {
        this.classList.add('form-control');
        this.classList.add('study-filter');
    });

    clearPatientDetail();
    bindQASessionEvents();
    bindEvents();
    applySelectedRangeDate("today");
    appendCommonDlgs("#qaViewer");
    setSecurityToken();

    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        updateIndex(e.target.name);
    });
});

function updateIndex(target) {
    if (target == "viewer") {
        $("#home-viewer")[0].style.zIndex = 99999;
        $("#home-images")[0].style.zIndex = 9999;
        $("#mangeImageBtn")[0].disabled = false;
    } else if (target == "images") {
        $("#home-viewer")[0].style.zIndex = 9999;
        $("#home-images")[0].style.zIndex = 99999;
        $("#mangeImageBtn")[0].disabled = true;
    }
}

function manageNextPreviousStudies(rows, type) {
    try {
        if (type) {
            var highlightRow = $('#home-patient-info-table > tbody > tr.highlight');
            var previousBtn = undefined;
            var nextBtn = undefined;
            switch (type) {
                case "next":
                    rows = $(highlightRow).closest('tr').next('tr');
                    previousBtn = "#previousStudyBtn";
                    nextBtn = "#nextStudyBtn";
                    break;

                case "previous":
                    rows = $(highlightRow).closest('tr').prev('tr');
                    previousBtn = "#nextStudyBtn";
                    nextBtn = "#previousStudyBtn";
                    break;
            }

            if (rows) {
                var studyId = undefined;
                if (rows && rows.length > 0) {
                    $(rows).addClass('highlight').siblings().removeClass('highlight');
                    studyId = rows[0].id;
                    $(previousBtn).attr("disabled", false);
                } else {
                    $(nextBtn).attr("disabled", true);
                }

                if (studyId) {
                    updateStudyDetail(studyId, rows);
                }
            }
        } else if (rows) {
            var noOfRows = $('#home-patient-info-table tr').length;
            if (noOfRows > 1) {
                $(rows).addClass('highlight').siblings().removeClass('highlight');
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
            } else {
                $('#nextStudyBtn').attr("disabled", true);
                $('#previousStudyBtn').attr("disabled", true);
                var highlightRow = $('#home-patient-info-table > tbody > tr.highlight');
                if (highlightRow && highlightRow.length < 1) {
                    $('#home-patient-info-table>tbody>tr').first().addClass('highlight');
                }
            }
        }
    } catch (e) {}
}

function loadNextStudy() {
    manageNextPreviousStudies(undefined, 'next');
}

function loadPreviousStudy() {
    manageNextPreviousStudies(undefined, 'previous');
}

/**
 * Manager viewers
 * @param {Type} type - Specifies the viewer type
 * @param {Type} studyId - Specifies the study id
 * @param {Type} clickedRow - Flag to click the row
 */
function manageViewers(type, studyId, clickedRow) {
    try {
        var href;
        switch (type) {
            case "viewer":
                href = "#home-viewer";
                break;

            case "manager":
                href = "#home-images";
                break;

            case "report":
                href = "#home-report";
                break;
        }

        var parent = clickedRow.parentElement;
        var isSameRow = false;
        if (parent && parent.parentElement.classList && parent.parentElement.classList.contains("highlight")) {
            isSameRow = true;
        }

        if (!isSameRow) {
            updateStudyDetail(studyId, clickedRow.parentElement.parentElement);
        }
        $('#home-tab-id a[href="' + href + '"]').trigger('click');
    } catch (e) {}
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

function createIFrame() {
    clearViewers();
    var frameHeight = "100%";
    var frameWidth = "100%";
    $("#home-viewer").append('<br /><iframe id="iframe-viewer" src="about:blank" width="' + frameWidth + '" height="' + frameHeight + '"/>');
    $("#home-images").append('<br /><iframe id="iframe-images" src="about:blank" width="' + frameWidth + '" height="' + frameHeight + '"/>');
    $("#home-report").append('<br /><iframe id="iframe-report" src="about:blank" width="' + frameWidth + '" height="' + frameHeight + '"/>');

    frameHeight = $(window).height() - getElementOffset($("#home-viewer iframe")[0]).top - 10;
    $("#home-viewer iframe").height(frameHeight);
    $("#home-images iframe").height(frameHeight);
    $("#home-report iframe").height(frameHeight);
    $("#viewer-data")[0].style.height = frameHeight + 57 + "px";
    var rect = $("#home-viewer")[0].getBoundingClientRect();
    $("#home-images")[0].getBoundingClientRect().top = rect.top;
    $("#home-images")[0].getBoundingClientRect().bottom = rect.bottom;
}

/**
 * Display the viewers
 * @param {Type} study - Specifies the study 
 */
function displayViewers(study) {
    $("#iframe-viewer")[0].src = study.viewerUrl;
    $("#iframe-images")[0].src = study.manageUrl;
    $("#iframe-report")[0].src = study.reportUrl;
}

$(window).resize(function () {
    resizeFrames();
    updateWindowPOs();
});

function resizeFrames() {
    var frameHeight = $(window).height() - getElementOffset($("#home-viewer iframe")[0]).top - 10;
    $("#home-viewer iframe").height(frameHeight);
    $("#home-images iframe").height(frameHeight);
    $("#home-report iframe").height(frameHeight);
    $("#viewer-data")[0].style.height = frameHeight + 57 + "px";

    var tableHeight = $(window).height() - getElementOffset($("#home-patient-table-id")[0]).top - 30;
    $("#home-patient-table-id").height(tableHeight);

    alignTable();
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

/**
 * Clear the viewers
 */
function clearViewers() {
    $("#home-viewer").html('');
    $("#home-images").html('');
    $("#home-report").html('');
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
    try {
        var searchQuery = $("#home-search-of")[0].searchQuery;
        if (!searchQuery) {
            // TODO: display error message
            return;
        }

        var filters = {
            studyFilter: {
                captureSavedBy: searchQuery.captureSavedBy,
                fromDate: searchQuery.fromDate,
                toDate: searchQuery.toDate,
                includeMuseOrders: false,
                includePatientOrders: true,
                includeEncounterOrders: true,
                filterClass: searchQuery.filterClass,
                qaStatus: searchQuery.qaStatus,
                maximumResult: searchQuery.maximumResult
            }
        };

        showAndHideSplashWindow("show", "Searching the study...", "qa_page");
        var searchUrl = dicomViewer.getQaSearchUrl(getUrlParameter("SiteNumber"));;
        $.ajax({
            url: searchUrl,
            method: 'POST',
            async: true,
            cache: false,
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
        var captureUsersUrl = dicomViewer.getQaCaptureUsersUrl(searchFilter);
        $.ajax({
            url: captureUsersUrl,
            method: 'GET',
            async: true,
            cache: false,
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
    try {
        var cuId = undefined;
        var searchId = undefined;
        var cuOptionPrefixId = undefined;
        if (isHomeCapturedUsers) {
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
                if (isHomeCapturedUsers) {
                    $(".search-filter").attr("disabled", false);
                }

                if (!Array.isArray(captureUserResults.captureUser)) {
                    captureUserResults.captureUser = [captureUserResults.captureUser];
                }

                var captureUserInc = 1;
                captureUserResults.captureUser.forEach(function (value) {
                    $(cuId)[0].innerHTML += ('<option id=' + cuOptionPrefixId + captureUserInc + '>' + value.userName + '</option>');
                    captureUserInc++;
                });

                // Hold capture user values to the corresponding <option>
                captureUserInc = 1;
                captureUserResults.captureUser.forEach(function (value) {
                    $("#" + cuOptionPrefixId + captureUserInc)[0].filters = {
                        captureUser: value,
                        isFiltersUpated: false
                    };

                    captureUserInc++;
                });

                $(searchId)[0].searchQuery = {
                    fromDate: searchFilter.fromDate,
                    toDate: searchFilter.throughDate
                };
                $(cuId).change();
            } else if (isHomeCapturedUsers) {
                $(".search-filterr").attr("disabled", "disabled");
                buttonsStyle();
            }
        }
    } catch (e) {}
}

/**
 * Click on select button open new modal window to select date range 
 */
function loadSelectModalWindow() {
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

function loadUserByStartAndEndDate() {
    try {
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
    } catch (e) {}
}

/**
 * Bind the events with controls
 */
function bindEvents() {
    try {
        // Captured users
        $("#home-captured-by").unbind('change');
        $("#home-captured-by").change(function () {
            var filters = this[this.selectedIndex].filters;
            if (filters) {
                var imageFilters = filters.imageFilters;
                if (!filters.isFiltersUpated && !imageFilters) {
                    fetchAndUpdateImageFilters(filters, (this.selectedIndex + 1));
                } else {
                    updateImageFilters(imageFilters, ("#home-cu-" + (this.selectedIndex + 1)));
                }
            }

            var searchQuery = $("#home-search-of")[0].searchQuery;
            if (searchQuery && !searchQuery.maximumResult) {
                $("#home-percentage-of").change();
            }

            if (searchQuery && !searchQuery.qaStatus) {
                $("#home-status-of").change();
            }
        });

        // Select filter
        $("#home-filter-of").unbind('change');
        $("#home-filter-of").change(function () {
            var filters = this[this.selectedIndex].filters;
            if (filters) {
                var imageFilterDetails = filters.imageFilterDetails;
                var cuFilters = undefined;
                if (filters.captureUserId) {
                    cuFilters = $(filters.captureUserId)[0].filters;
                    if (cuFilters) {
                        imageFilterDetails = cuFilters.imageFilterDetails[filters.imageFilter.filterName];
                    }
                }

                if (!filters.isFiltersDetailsUpated && !imageFilterDetails) {
                    fetchAndupdateImageFilterDetails(cuFilters, filters);
                } else {
                    updateSearchQuery(cuFilters, filters);
                }
            }
        });

        // Captured users for image report
        $("#select-user-id").unbind('change');
        $("#select-user-id").change(function () {
            var filters = this[this.selectedIndex].filters;
            if (filters) {
                var searchQuery = $("#imageReport")[0].searchQuery;
                if (searchQuery && filters.captureUser) {
                    searchQuery.captureUserId = filters.captureUser.userId;
                }
            }
        });

        // has status of
        $("#home-status-of").unbind('change');
        $("#home-status-of").change(function () {
            var searchQuery = $("#home-search-of")[0].searchQuery;
            if (searchQuery) {
                var checkedItems = [];
                $('#ms-list-1').find('li.selected input[type="checkbox"]').each(function () {
                    checkedItems.push($(this).val());
                });
                searchQuery.qaStatus = "";
                if (checkedItems.length > 0) {
                    searchQuery.qaStatus = checkedItems.join();
                }
            }
        });

        // Percen (%) return
        $("#home-percentage-of").unbind('change');
        $("#home-percentage-of").change(function () {
            var searchQuery = $("#home-search-of")[0].searchQuery;
            if (searchQuery) {
                searchQuery.maximumResult = this.value;
            }

            $("#home-max-of").val('');
        });

        // Percen (%) return
        $("#home-max-of").unbind('change');
        $("#home-max-of").change(function () {
            var searchQuery = $("#home-search-of")[0].searchQuery;
            if (searchQuery) {
                searchQuery.maximumResult = this.value;
            }

            $("#home-percentage-of").val('');
        });
        $("#home-percentage-of").change();
    } catch (e) {}
}

/**
 * Update the search query
 * @param {Type} cuFilters - Specifies the capture users
 * @param {Type} filters - Specifies the filters
 */
function updateSearchQuery(cuFilters, filters) {
    try {
        var searchQuery = $("#home-search-of")[0].searchQuery;
        if (searchQuery && cuFilters) {
            if (cuFilters.captureUser) {
                searchQuery.captureSavedBy = cuFilters.captureUser.userId;
            }

            if (filters.imageFilterDetails) {
                searchQuery.filterClass = filters.imageFilterDetails.imageFilterDetail.classIndex;
            }
        }
    } catch (e) {}
}

/**
 * Get the image filters
 * @param {Type} captureUser - Specifies the capture user
 */
function fetchAndUpdateImageFilters(filters, cuId) {
    try {
        showAndHideSplashWindow("show", "Fetching the image filters (" + filters.captureUser.userName + ")", "qa_page");
        var imageFiltersUrl = dicomViewer.getQaImageFiltersUrl(filters);
        $.ajax({
            url: imageFiltersUrl,
            method: 'GET',
            async: true,
            cache: false,
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
    } catch (e) {}
}

/**
 * Update the image filters
 * @param {Type} imageFilters - Specifies the image filters
 */
function updateImageFilters(imageFilters, captureUserId) {
    try {
        $("#home-filter-of").html('');
        if (imageFilters) {
            if (imageFilters.imageFilters && imageFilters.imageFilters.imageFilter) {

                // Create the filter array if it is single object
                if (!Array.isArray(imageFilters.imageFilters.imageFilter)) {
                    imageFilters.imageFilters.imageFilter = [imageFilters.imageFilters.imageFilter];
                }

                var defaultFilter = imageFilters.imageFilters.imageFilter[0];
                imageFilters.imageFilters.imageFilter.splice(0, 1);

                var imageFilterInc = 1;
                imageFilters.imageFilters.imageFilter.forEach(function (value) {
                    $("#home-filter-of")[0].innerHTML += ('<option id=home-of-' + imageFilterInc + '>' + value.filterName + '</option>');
                    imageFilterInc++;
                });

                // Hold image filter values to the corresponding <option>
                imageFilterInc = 1;
                imageFilters.imageFilters.imageFilter.forEach(function (value) {
                    $("#home-of-" + imageFilterInc)[0].filters = {
                        imageFilter: value,
                        isFiltersDetailsUpated: false,
                        captureUserId: captureUserId
                    };

                    imageFilterInc++;
                });

                var selectFilter = imageFilters.imageFilters.imageFilter.filter(function (o) {
                    return o.filterIEN == defaultFilter.filterIEN;
                })[0];
                if (selectFilter) {
                    $('#home-filter-of').val(selectFilter.filterName);
                }

                $('#home-filter-of').change();
            }
        }
    } catch (e) {}
}

/**
 * Get the image filter details
 * @param {Type} imageFilter - Specifies the image filter
 */
function fetchAndupdateImageFilterDetails(cuFilters, filters) {
    try {
        showAndHideSplashWindow("show", "Fetching the image filters details (" + filters.imageFilter.filterName + ")", "qa_page");
        var imageFilterDetailsUrl = dicomViewer.getQaImageFilterDetailsUrl(filters);
        $.ajax({
            url: imageFilterDetailsUrl,
            method: 'GET',
            async: true,
            cache: false,
            success: function (data) {
                filters.imageFilterDetails = getJsonData(data);
                filters.isFiltersDetailsUpated = true;
                if (cuFilters) {
                    cuFilters.imageFilterDetails[filters.imageFilter.filterName] = filters.imageFilterDetails;
                }

                updateSearchQuery(cuFilters, filters);
                showAndHideSplashWindow("success", "Successfully fetched the image filter details");
            },
            error: function (xhr, status) {
                showAndHideSplashWindow("error", "Failed to fetch the image filter details");
            }
        });
    } catch (e) {}
}

/**
 * Update the image properties
 * @param {Type} statusFlag - Specifies the status flag
 */
function updateImagePropertiesQA(statusFlag) {
    try {
        var activeImage = $("#home-patient-info")[0].data;
        if (activeImage) {
            setImageProperties(statusFlag, activeImage.imageUrn);
        } else {
            //TODo: error message
        }
    } catch (e) {}
}

/**
 * Set the image properties
 * @param {Type} statusFlag - Specifies the status flag
 * @param {Type} imageIEN  - Specifies the image IENs
 */
function setImageProperties(statusFlag, imageIENs) {
    try {
        var imageProperties = "";
        imageIENs.forEach(function (Ien) {
            imageProperties += getXmlData({
                imageProperty: {
                    name: "ISTAT",
                    value: statusFlag,
                    ien: Ien
                }
            })
        });

        if (imageProperties != "") {
            imageProperties = '<imageProperties>' + imageProperties + '</imageProperties>';
            updateImageProperties(imageProperties, imageIENs);
        }
    } catch (e) {}
}

/**
 * Update the study
 * @param {Type} studyData - Specifies the study data
 */
function updateStudy(studyData) {
    try {
        studyDetails = {};
        $('#home-patient-info-table-body').html('');
        clearPatientDetail();
        $('#nextStudyBtn').attr("disabled", true);
        $('#previousStudyBtn').attr("disabled", true);

        if (studyData) {
            var studies = getJsonData(studyData);
            if (studies) {
                var studyInc = 0;
                var studyInformation = "";
                var delimiterICN = 'icn';
                var delimiterDFN = 'dfn';
                var firstStudyId = undefined;

                if (!Array.isArray(studies.studies.study)) {
                    studies.studies.study = [studies.studies.study];
                }

                if (studies.studies.study && studies.studies.study.length > 1) {
                    $('#nextStudyBtn').attr("disabled", false);
                }

                studies.studies.study.sort(function (a, b) {
                    return b.groupIen - a.groupIen;
                });

                var lastColWidth = "37%";
                if (studies.studies.study.length > 1) {
                    lastColWidth = "32%";
                }

                studies.studies.study.forEach(function (study) {
                    var itemName = (studyInc + 1);
                    var patientName = study.patientName;
                    var imageCount = study.imageCount;
                    var groupIen = study.groupIen;
                    var studyId = study.studyId;

                    // Check whether the patient id is icn or dfn
                    study.isICN = true;
                    var index = study.patientId.indexOf(delimiterICN);
                    if (index > -1) {
                        study.patientId = study.patientId.substring((index + delimiterICN.length + 1), study.patientId.length - 1);
                    } else {
                        index = study.patientId.indexOf(delimiterDFN);
                        if (index > -1) {
                            study.patientId = study.patientId.substring((index + delimiterDFN.length + 1), study.patientId.length - 1);
                            study.isICN = false;
                        }
                    }

                    if (!firstStudyId) {
                        firstStudyId = studyId;
                    }

                    studyInformation += '<tr id=\'' + studyId + '\' ><td style="width: 22%; word-wrap: break-word;vertical-align: middle;text-align: center;">' + itemName + '</td><td style="width: 56%;word-wrap: break-word;vertical-align: middle;">' + patientName + '</td><td style="width: 18%;word-wrap: break-word;vertical-align: middle;text-align: center;">' + imageCount + '</td><td style="width:30%;word-wrap: break-word;vertical-align: middle;text-align: center;">' + groupIen + '</td><td style="width:' + lastColWidth + ';text-align: center;vertical-align: middle;"><a class="btn btn-xs icon-link-color border-color-class" title="Viewer" onclick="manageViewers(\'viewer\', \'' + studyId + '\', this)"><span class="glyphicon glyphicon-picture"></span></a> <a class="btn btn-xs icon-link-color border-color-class" title="Images" onclick="manageViewers(\'manager\', \'' + studyId + '\', this)"><span class="glyphicon glyphicon-th-list"></span></a> <a class="btn btn-xs icon-link-color border-color-class" title="Report" style="display:none" onclick="manageViewers(\'report\', \'' + studyId + '\', this)"><span class="glyphicon glyphicon-calendar"></span></a></td></tr>';

                    studyDetails[studyId] = study;
                    //updateViewerUrls(study, true);
                    studyInc++;
                });

                $('#home-patient-info-table-body').append(studyInformation);
                $('#home-patient-info-table>tbody>tr').first().addClass('highlight');
                updateStudyDetail(firstStudyId);
                loadPreviousStudy();
                resizeFrames();
            }
        }
    } catch (e) {}
}

function alignTable() {
    var tableHeader = $("#searchResultTable th");
    var tableRows = $("#home-patient-info-table-body tr");

    tableRows.each(function (key, value) {
        var tableCols = value.children;
        for (var i = 0; i < tableCols.length; i++) {
            var element = tableCols[i];
            $(element).width(tableHeader.eq(i).width());
        }
    });
}

/**
 * update study details
 * @param {Type} studyId - Specifies the id
 */
function updateStudyDetail(studyId, clickedRow) {
    try {
        clearPatientDetail();
        var study = getStudyDetail(studyId);
        if (study) {
            // Check whether the viewer url is valid or not
            if (!study.viewerUrl) {
                updateViewerUrls(study, false);
            } else {
                displayViewers(study);
            }

            manageNextPreviousStudies(clickedRow);
        }
    } catch (e) {}
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
    //VAI-582: Server sends header names lowercase
    headers["content-type"] = "application/json";

    contents["siteNumber"] = BasicUtil.getUrlParameter("SiteNumber");
    contents["securityToken"] = BasicUtil.getUrlParameter("SecurityToken");

    studies.push({
        contextId: study.studyId
    });
    contents["studies"] = studies;

    return {
        Headers: headers,
        Contents: JSON.stringify(contents)
    };
}

/**
 * Query study
 * @param {Type} study - Specifies the study
 */
function updateViewerUrls(study, isAsync) {
    try {
        if (!isAsync) {
            showAndHideSplashWindow("show", "Processing study query...", "qa_page");
        }
        var searchQuery = getStudyQuery(study);
        $.ajax({
            url: dicomViewer.getQaStudyQueryUrl(),
            data: searchQuery.Contents,
            headers: searchQuery.Headers,
            method: 'POST',
            dataType: 'json',
            async: isAsync,
            cache: false,
            success: function (data) {
                if (data && data.studies) {
                    study.viewerUrl = data.studies[0].viewerUrl + "&Invoker=QA";
                    study.manageUrl = data.studies[0].manageUrl + "&Invoker=QA";
                    study.reportUrl = data.studies[0].reportUrl + "&Invoker=QA";
                    study.contextId = data.studies[0].contextId;

                    if (!isAsync) {
                        displayViewers(study);
                    }
                }
                if (!isAsync) {
                    showAndHideSplashWindow("success", "Sucessfully processed the study query");
                }
            },
            error: function (xhr, status) {
                if (!isAsync) {
                    showAndHideSplashWindow("error", "Failed to process the study query");
                }
            }
        });
    } catch (e) {}
}

/**
 * Create the QA session events
 */
function bindQASessionEvents() {
    try {
        $.connection.sessionHub.client.QaMessage = function (data) {
            processQaRequest(data);
        }
        $.connection.hub.Url = baseSignalrURL;
        $.connection.hub.start();
    } catch (e) {}
}

/**
 * Send the QA message to server
 * @param {Type} data - Specifies the data
 */
function sendQaMessage(data) {
    try {
        if ($.connection.sessionHub) {
            $.connection.sessionHub.invoke('SendQaMessage', data);
        }
    } catch (e) {}
}

/**
 * Process the request
 * @param {Type} data - Specifies the request data
 */
function processQaRequest(data) {
    try {
        if (data && data.target == "QA") {
            var study = getStudyDetail(data.studyId);
            if (study) {
                switch (data.type) {
                    case reqType.imageInfo:
                        {
                            $("#home-patient-info")[0].data = data;
                            fetchAndUpdateImageProperties();
                            buttonsStyle(data.type);
                            break;
                        }
                    case reqType.needsReview:
                        {
                            setImageProperties('11', data.imageUrn);
                            break;
                        }
                    case reqType.qaReviewed:
                        {
                            setImageProperties('2', data.imageUrn);
                            break;
                        }
                    case reqType.deleteImage:
                        {
                            break;
                        }
                    case reqType.indexEdit:
                        {
                            doImageEdit();
                            break;
                        }
                    default:
                        break;
                }
            } else {
                switch (data.type) {
                    case reqType.closeStudy:
                        {
                            var selectedRow = $('#home-patient-info-table-body').find('tr.highlight');
                            if (selectedRow && selectedRow[0]) {
                                if (selectedRow[0].classList) {
                                    selectedRow[0].classList.remove("highlight");
                                    clearPatientDetail();
                                }
                            }
                            buttonsStyle(data.type);
                            break;
                        }
                    case reqType.emptyViewport:
                        {
                            clearPatientDetail();
                            buttonsStyle(data.type);
                            break;
                        }
                    default:
                        break;
                }
            }
        } else {
            // Invalid target request
        }
    } catch (e) {}
}

/**
 * enable and disable the imageinformation buttons
 * @param {qa request type} type 
 */
function buttonsStyle(type) {
    if (type == reqType.emptyViewport) {
        $('#needsReviewBtn').attr("disabled", true);
        $('#qaReviewedBtn').attr("disabled", true);
    } else if (type == reqType.closeStudy || type == undefined) {
        $('#previousStudyBtn').attr("disabled", true);
        $('#nextStudyBtn').attr("disabled", true);
        $('#qaReviewedBtn').attr("disabled", true);
        $('#needsReviewBtn').attr("disabled", true);
    } else {
        if ($('#qaReviewedBtn')[0].disabled) {
            $('#qaReviewedBtn').attr("disabled", false);
            $('#needsReviewBtn').attr("disabled", false);
            var selectedRow = $('#home-patient-info-table-body').find('tr.highlight');
            manageNextPreviousStudies(selectedRow[0]);
        }
    }
}

/**
 * 
 * @param {Type} type - Specifies the type of request
 * @param {Type} metaData - Specifies the study meta data
 */
function prepareViewerRequest(type, metaData) {
    try {
        var data = {
            type: type,
            target: "Viewer",
            metaData: metaData
        };

        sendQaMessage(data);
    } catch (e) {}
}

/**
 * Display the image manager
 */
function manageImage() {
    try {
        $('#home-tab-id a[href=#home-images]').trigger('click');
    } catch (e) {}
}
