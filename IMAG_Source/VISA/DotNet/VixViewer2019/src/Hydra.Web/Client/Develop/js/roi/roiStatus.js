//vvvvvvvvvvv TODO VAI-919: Change var to const vvvvvvvvvv
var metaDataUrl = window.location.origin + "/vix/api/context/metadata" + window.location.search + "&_cacheBust=";
var requestUrl = window.location.origin + window.location.pathname + "/status" + window.location.search;
var exportQueueUrl = window.location.origin + "/vix/roi/status/exportqueue" + window.location.search;

var DISCLOSURE_URL_PREFIX = window.location.origin + "/vix/roi/disclosure"; //VAI-915: Set all URLs and Prefixes upfront
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

var patientTable = null;
var initalDataLength = 0;

$(document).ready(function () {
    $("#routingInfoWindow").dialog({
        autoOpen: false,
        width: 500,
        height: 70,
        modal: true,
        resizable: false,
        title: "Dicom Routing",
        buttons: {
            "OK": function () {
                $(this).dialog("close");
            }
        },
        open: function () {
            $("#routingInfoWindow").width("auto");
            $("#routingInfoWindow").height("auto");
        }
    });

    $("#downloadDisclosureWindow").dialog({
        autoOpen: false,
        width: 500,
        height: 400,
        modal: true,
        resizable: false,
        buttons: {
            "Download Disclosure Job From Server": function () {
                $(this).dialog("close");
                if ($(this).data("callback") != undefined) {
                    $(this).data("callback")();
                }
            },
            Cancel: function () {
                $(this).dialog("close");
            }
        },
        open: function () {
            $("#downloadDisclosureWindow").unbind('keypress');
            $("#downloadDisclosureWindow").keypress(function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    $(this).parent().find("button:eq(0)").trigger("click");
                }
            });

            $("#downloadDisclosureWindow").width("auto");
            $("#downloadDisclosureWindow").height("auto");

            var data = $("#downloadDisclosureWindow").data("data");
            if (data) {
                $("#downloadDisclosure").empty();
                $("#downloadDisclosure").html('<span align="left"><h6><b>Disclosure for : ' + data.patientName + '</b></h6></span><span><span align="left"><h6><b>SSN4 : ' + data.SLast4 + '</b></h6></span><br/><span>' + data.note + '</span>');
            }
        },
        close: function () {}
    });

    getPatientMetadata();
    getPatientInfoTable();

    $("input[type=radio]").change(function () {
        if (patientTable !== null) {
            patientTable.draw();
            resizeTable();
        }
    });
});


$.fn.dataTableExt.afnFiltering.push(
    function (oSettings, aData, iDataIndex) {
        var element = $("input:checked");
        if (element.length > 0) {
            return doWorkFilter(element[0].id, aData[4]);
        }
        return true;
    }
);

function isNullOrUndefined(obj) {
    if (obj === undefined || obj === null) {
        return true;
    }
    return false;
}

function resizeTable() {
    if (patientTable !== null) {
        alignTable("workFilter", 6, "13px");
        $("tbody").css('max-height', (Math.round(window.innerHeight * 0.65) + "px")); //VAI-760
        var tableElement = $("tbody");
        var tableBottomPos = tableElement.position().top + tableElement.offset().top + tableElement.outerHeight(true);
        var refreshElement = $("#refreshDiv");
        var refreshBottomPos = refreshElement.position().top;
        var topPos = refreshBottomPos - tableBottomPos + 20;
        $("#refreshDiv").css('margin-top', "-" + topPos + "px");
    }
}

$(window).resize(function (evtArgs) {
    resizeTable();
});

function getPatientMetadata() {
    $.ajax({
        type: 'GET',
        url: metaDataUrl,
        dataType: 'json',
        success: function (data) {
            if (data !== undefined && data !== null) {
                displayDemographics(data);
            }
        },
        error: function (xhr, status) {
            var description = "\nFailed to get metadata."
        }
    });
}

function displayDemographics(data) {
    var patientName = changeNullToEmpty(data.patient.fullName.replace("^", ","));
    var patientAge = changeNullToEmpty(data.patient.age);
    var patientSex = changeNullToEmpty(data.patient.sex);
    var patientICN = changeNullToEmpty(data.patient.iCN);
    var patientDispalyString = "";
    if (patientICN !== "" || patientSex !== "" || patientAge !== "") {
        if (patientSex == "" && patientAge == "") {
            patientDispalyString = patientICN;
        } else {
            patientDispalyString = patientICN + ", " + patientSex + " " + patientAge;
        }
    }
    var patientName = data.patient.fullName.replace("^", ",");
    $("#pName").html("&nbsp<font color='#E8E8E8' size='2'>" + patientName + "</font>");
    $("#dob").html("&nbsp<font color='#E8E8E8' size='1.7'>" + patientDispalyString + "</font>");
    $("#pName").attr("title", patientName + " " + patientDispalyString);
    $("#dob").attr("title", patientName + " " + patientDispalyString);
}

function changeNullToEmpty(value) {
    if (value == undefined || value == null) {
        return "";
    }

    return value;
}

var dicomRouting = [];

function getDicomRoutingInfo(exportQueue) {
    var dicomRoutingInfo;
    if (dicomRouting) {
        $.each(dicomRouting, function (key, value) {
            if (value.queueId == exportQueue) {
                dicomRoutingInfo = value.name + ", " + value.location;
                return false;
            }
        });
    }
    return dicomRoutingInfo;
}

function getDicomRoutingRequest() {
    $.ajax({
        type: 'GET',
        url: exportQueueUrl,
        dataType: 'json',
        async: false,
        success: function (data) {
            if (data) {
                var x2js = new X2JS();
                var writers = x2js.xml_str2json(data);
                if (writers) {
                    if (!Array.isArray(writers.rOIDicomExportQueueTypes.roiDicomExportQueueType)) {
                        writers.rOIDicomExportQueueTypes.roiDicomExportQueueType = [writers.rOIDicomExportQueueTypes.roiDicomExportQueueType];
                    }
                    if (writers.rOIDicomExportQueueTypes.roiDicomExportQueueType !== undefined) {
                        writers.rOIDicomExportQueueTypes.roiDicomExportQueueType.forEach(function (value) {
                            dicomRouting.push({
                                name: value.name,
                                queueId: value.queueId,
                                location: value.location
                            });
                        });
                    }
                }
            }
        },
        error: function (xhr, status) {
            var description = "\nFailed to get ROI dicom routing info."
        }
    });
}

function getPatientInfoTable() {
    getDicomRoutingRequest();
    $.ajax({
        type: 'GET',
        url: requestUrl,
        dataType: 'json',
        success: function (data) {
            if (data == undefined || data == null) {
                data = []; //testROIStatus();
            }
            //Display all the patient information in dataTable
            initalDataLength = data.length;
            if (initalDataLength > 0) {
                for (var i = 0; i < data.length; i++) {
                    var dicomRouting = (isNullOrUndefined(data[i].exportQueue) || data[i].exportQueue == "") ? "" : getDicomRoutingInfo(data[i].exportQueue);
                    //VAI-1316
                    var table = document.getElementById("patientInfo");
                    var row = table.insertRow(-1);
                    row.id = data[i].resultUri;
                    row.onclick = function () { // VAI-1316
                        getROIStatusInfo(row)
                    };
                    var cell1 = row.insertCell();
                    var cell2 = row.insertCell();
                    var cell3 = row.insertCell();
                    var cell4 = row.insertCell();
                    var cell5 = row.insertCell();
                    var cell6 = row.insertCell();

                    isNullOrUndefined(data[i].patientName) ? cell1.textContent = "" : cell1.textContent = data[i].patientName;
                    isNullOrUndefined(data[i].sLast4) ? cell2.textContent = "" : cell2.textContent = data[i].sLast4;
                    isNullOrUndefined(data[i].patientId) ? cell3.textContent = "" : cell3.textContent = data[i].patientId;
                    isNullOrUndefined(data[i].status) ? cell4.textContent = "" : cell4.textContent = data[i].status;
                    isNullOrUndefined(data[i].lastUpdated) ? cell5.textContent = "" : cell5.textContent = data[i].lastUpdated;
                    cell6.textContent = dicomRouting;
                }
            }

            // Display data in the dataTable
            patientTable = $('#patientInfoTable').DataTable({
                "bDestroy": true,
                "bAutoWidth": false,
                "bFilter": true,
                "bSort": true,
                "aaSorting": [[0]],
                "aoColumns": [
                    {
                        "sWidth": '10%',
                        "bSortable": false
                    },
                    {
                        "sWidth": '10%',
                        "bSortable": false
                    },
                    {
                        "sWidth": '10%',
                        "bSortable": false
                    },
                    {
                        "sWidth": '10%',
                        "bSortable": false
                    },
                    {
                        "sWidth": '10%',
                        "bSortable": true
                    },
                    {
                        "sWidth": '10%',
                        "bSortable": false
                    }
                ]
            });

            $('#container').css('display', 'block');
            patientTable.columns.adjust().draw();
            $('#patientInformation').show();
            if (data.length <= 10) {
                $('.dataTables_paginate').hide();
                $("#patientInfoTable_length").hide();
            }
            resizeTable();

            $('select.form-control.input-sm').change(function () {
                resizeTable();
            });

            $('#patientInfoTable_filter').on('input', function () {
                resizeTable();
            });

            $('#patientInfoTable').on('page.dt', function () {
                setTimeout(function () {
                    resizeTable();
                }, 200);
            });

            $('#patientInfoTable').on('order.dt', function () {
                resizeTable();
            });
        },
        error: function (xhr, status) {
            var description = "\nFailed to get ROI status."
        }
    });
}

function testROIStatus() {
    var roiStatusList = new Array();
    for (var index = 1; index < 30; index++) {
        var dateFormat = getDateFormat(index);
        var lastUpdated = dateFormat.dd + '/' + dateFormat.mm + '/' + dateFormat.yyyy;
        var roiStatusItem = {
            patientName: "Patient" + index,
            SLast4: "000" + +index,
            patientId: +index,
            status: "PENDING",
            lastUpdated: lastUpdated,
            dicomRouting: "Path" + index
        };
        roiStatusList.push(roiStatusItem);
    }
    return roiStatusList;
}

function refreshRoiStatus() {
    getDicomRoutingRequest();
    $.ajax({
        type: 'GET',
        url: requestUrl,
        dataType: 'json',
        success: function (data) {
            if (data == undefined || data == null) {
                data = []; //testROIStatus();
            }
            //Display all the patient information in dataTAble
            var patientInformation = "";
            if (data.length > 0) {
                patientTable.clear();
                patientTable.draw();
                for (var i = 0; i < data.length; i++) {
                    var dicomRouting = (isNullOrUndefined(data[i].exportQueue) || data[i].exportQueue == "") ? "" : getDicomRoutingInfo(data[i].exportQueue);
                    patientTable.row.add(
                        [isNullOrUndefined(data[i].patientName) ? "" : data[i].patientName,
                        isNullOrUndefined(data[i].SLast4) ? "" : data[i].SLast4,
                        isNullOrUndefined(data[i].patientId) ? "" : data[i].patientId,
                        isNullOrUndefined(data[i].status) ? "" : data[i].status,
                        isNullOrUndefined(data[i].lastUpdated) ? "" : data[i].lastUpdated,
                            dicomRouting
                        ]).node().id = data[i].resultUri;
                    initalDataLength++;
                }
            }
            patientTable.draw();
            if (initalDataLength > 10) {
                $('.dataTables_paginate').show();
                $("#patientInfoTable_length").show();
            }
            resizeTable();
        },
        error: function (xhr, status) {
            var description = "\nFailed to get ROI status."
        }
    });
}

function doWorkFilter(id, dateString) {
    switch (id) {
        case "rad1":
            return showTodayWork(dateString);
            break;
        case "rad2":
            return showSevenDaysWork(dateString);
            break;
        case "rad3":
            return true;
            break;
    }
}

function getDateFormat(format) {
    var dateObj = null;
    if (format == 0) {
        dateObj = new Date();
    } else {
        var currentDate = new Date();
        dateObj = new Date(currentDate.getTime() - 1000 * 60 * 60 * 24 * format);
    }
    var dd = dateObj.getDate();
    var mm = dateObj.getMonth() + 1; //January is 0!
    var yyyy = dateObj.getFullYear();
    if (dd < 10) {
        dd = '0' + dd;
    }
    if (mm < 10) {
        mm = '0' + mm;
    }

    return {
        dd: dd,
        mm: mm,
        yyyy: yyyy
    };
}

function showTodayWork(date) {
    var currentDate = getDateFormat(0);
    var today = currentDate.mm + '/' + currentDate.dd + '/' + currentDate.yyyy;

    return (date.indexOf(today) > -1);
}

function showSevenDaysWork(date) {
    if (!date) {
        return false;
    }
    try {
        var dateInt = date.split("/");
        var currentDate = new Date();
        var currentTime = currentDate.getTime();
        var lastWeekDate = new Date(currentTime - 1000 * 60 * 60 * 24 * 7);
        var lastWeekTime = lastWeekDate.getTime();

        var dateObj = new Date();
        dateObj.setDate(dateInt[1]);
        dateObj.setMonth(dateInt[0] - 1);
        dateObj.setFullYear(dateInt[2].slice(0, 4));

        var time = dateInt[2].slice(5).split(":");
        dateObj.setHours(time[0]);
        dateObj.setMinutes(time[1]);
        dateObj.setSeconds(time[2]);
        var dateObjTime = dateObj.getTime();

        return dateObjTime > lastWeekTime && dateObjTime <= currentTime;
    } catch (e) {

    }
}

function getROIStatusInfo(row) {
    if (row && row.children) {
        if (row.children[3].textContent == "ROI_COMPLETE") {
            showDownloadDisclosure(row);
        } else if (row.children[3].textContent == "EXPORT_QUEUE") {
            showDicomRoutingInfo(row);
        }
    }
}

function showDownloadDisclosure(row) {
    var disclosure = {
        patientName: row.children[0].textContent,
        ssn4: row.children[1].textContent,
        note: "You must have 'write' permission to copy a file from the server to the local folder"
    }
    $("#downloadDisclosureWindow").data("data", disclosure);
    $('#downloadDisclosureWindow').data("callback", function () {
        downloadZipRequest(row);
    });
    $("#downloadDisclosureWindow").dialog("open");
}

function downloadZipRequest(row) {
    try {
        var param = {
            patientId: getDisClosureParameter("patientId", row),
            guid: getDisClosureParameter("guid", row)
        }
        var downloadUrl = DISCLOSURE_URL_PREFIX + "/" + param.patientId + "/" + param.guid + window.location.search; //VAI-915

        var xhttp;
        if (window.XMLHttpRequest) {
            xhttp = new XMLHttpRequest();
        } else {
            // code for IE6, IE5
            xhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }

        xhttp.onload = function () {
            // Only handle status code 200
            if (xhttp.status === 200) {
                var filename = param.guid + ".zip";
                if (window.navigator && window.navigator.msSaveBlob) { // IE 10+
                    window.navigator.msSaveOrOpenBlob(new Blob([xhttp.response], {
                        type: "application/zip"
                    }), filename);
                    return;
                }

                var blob = new Blob([xhttp.response], {
                    type: 'application/zip'
                });
                var link = document.createElement('a');
                link.href = window.URL.createObjectURL(blob);
                link.download = filename;

                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }
        };

        xhttp.open("GET", downloadUrl, true);
        xhttp.responseType = "blob";
        xhttp.send();
    } catch (e) {}
}

function toggleSelection() {

}

function getDisClosureParameter(sParam, row) {
    row.id = row.id.replace("?", "");
    var sURLVariables = row.id.split('&');
    for (var i = 0; i < sURLVariables.length; i++) {
        // use indexof instead of split. since some security tokens have trailing '=' characters
        var eq = sURLVariables[i].indexOf("=");
        var key = eq > -1 ? sURLVariables[i].substr(0, eq) : sURLVariables[i];
        var val = eq > -1 ? sURLVariables[i].substr(eq + 1) : "";

        if (key == sParam) {
            return val;
        }
    }
}

function showDicomRoutingInfo(row) {
    if (row.children[5].textContent) {
        $("#routingInfoWindow").dialog("open");
        $("#routingInfoWindow").html("The ROI request contains only radiology study(ies) which have been routed to " + row.children[5].textContent);
    }
}
