//vvvvvvvvvvv TODO VAI-919: Change var to const vvvvvvvvvv
var metaDataUrl = window.location.origin + "/vix/api/context/metadata" + window.location.search + "&_cacheBust=";
var studyQueryUrl = window.location.origin + "/vix/viewer/studyquery";
var submitUrl = window.location.origin + "/vix/roi" + "/submit" + window.location.search;
var submitPromptUrl = window.location.origin + "/vix/roi/submit/prompts" + window.location.search;
//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

var patientTable = null;
var patientICN = "";
var studyDetails = {};

var submitPrompts = {
    printers: [],
    writers: [],
    agreement: "",
    downloadReasons: []
};

/**
 * Call the processStudy() method to load all the patient and study information 
 * Default the first row of the table should be hightlighed and based on the selection 
 * the above box will fill the patient information
 */

$(document).ready(function () {
    $("#alert-printOrWriter").removeClass('alert-info');
    $("#printOrWriterWindow").dialog({
        autoOpen: false,
        width: 400,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function () {
                var target = "";
                if ($('#printOrWriter > option').length > 0) {
                    target = $("#printOrWriter option:selected").val();
                    if ($("#printOrWriterWindow").data("type") == "CD") {
                        if (submitPrompts.writers) {
                            var writer = submitPrompts.writers.filter(function (o) {
                                return o.name == target;
                            })[0];
                            if (writer) {
                                target = writer.queueId;
                            }
                        }
                    }
                }

                if (target === "") {
                    $("#alert-printOrWriter").show();
                    $("#alert-printOrWriter").removeClass('alert-info').addClass('alert-danger');
                    $("#alert-printOrWriter").html('value cannot be empty');
                    return;
                }

                $(this).dialog("close");
                if ($(this).data("callback") != undefined) {
                    $(this).data("callback")($("#printOrWriterWindow").data("type"), target);
                }
            },
            Cancel: function () {
                $(this).dialog("close");
            }
        },
        open: function () {
            $("#printOrWriterWindow").unbind('keypress');
            $("#printOrWriterWindow").keypress(function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    $(this).parent().find("button:eq(0)").trigger("click");
                }
            });

            var data = $("#printOrWriterWindow").data("data");
            if (data) {
                $("#printOrWriter").empty();
                var values = "";
                data.forEach(function (item) {
                    var value = (data.isWriter ? item.name : item);
                    values += "<option value='" + value + "'>" + value + "</option>";
                });

                $("#printOrWriter").html(values);
            }
        },
        close: function () {
            $("#alert-printOrWriter").removeClass('alert-danger');
            $("#alert-printOrWriter").empty();

            if ($('#printOrWriter > option').length > 0) {
                $('#printOrWriter option:eq(0)').prop('selected', true);
            }

            $("#alert-printOrWriter").hide();
        }
    });

    $("#printOrWriterAgreementWindow").dialog({
        autoOpen: false,
        width: 500,
        height: 400,
        modal: true,
        resizable: true,
        buttons: {
            "Ok": function () {
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
            $("#printOrWriterAgreementWindow").unbind('keypress');
            $("#printOrWriterAgreementWindow").keypress(function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    $(this).parent().find("button:eq(0)").trigger("click");
                }
            });

            $("#printOrWriterAgreementWindow").width("auto");
            $("#printOrWriterAgreementWindow").height("auto");

            var data = $("#printOrWriterAgreementWindow").data("data");
            if (data) {
                $("#printOrWriterAgreement").empty();
                $("#printOrWriterAgreement").html('<span align="center"><h6><b>Agreement</b></h6></span><br/><span>' + data + '</span>');
            }
        },
        close: function () {}
    });

    showOrHideViewer(false);
    prepareStudy();
    $("#roisubmission").append(createESignatureDlg());

    $("#alert-eSignature").removeClass('alert-info');
    $("#eSignatureWindow").dialog({
        autoOpen: false,
        width: 350,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function () {
                var digitalSign = $("#digitalSignature").val();
                if (digitalSign === "") {
                    $("#alert-eSignature").show();
                    $("#alert-eSignature").removeClass('alert-info').addClass('alert-danger');
                    $("#alert-eSignature").html('value cannot be empty');
                    return;
                }

                var isVerified = verifySignature(digitalSign);
                $(this).dialog("close");
                if ($(this).data("callback") != undefined) {
                    $(this).data("callback")(isVerified);
                }
            },
            Cancel: function () {
                $(this).dialog("close");
            }
        },
        open: function () {
            $("#eSignatureWindow").unbind('keypress');
            $("#eSignatureWindow").keypress(function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    $(this).parent().find("button:eq(0)").trigger("click");
                }
            });
        },
        close: function () {
            $("#alert-eSignature").removeClass('alert-danger');
            $("#alert-eSignature").empty();
            $("#alert-eSignature").hide();
            $("#digitalSignature")[0].value = "";
        }
    });
});

$(window).resize(function (evtArgs) {
    resizeTable();
});

function prepareStudy() {
    updateSpinner('roisubmission', "Prepare Study...");
    processMetaData();
    processPrompts();
    processStudy();
}

function resizeTable(isFirstTime) {
    if (patientTable !== null) {
        alignTable("patientInformation", 4, "33px", isFirstTime ? 0 : 4);
        $("tbody").css('max-height', (Math.round($(window).height() * 0.75) + "px"));
        var tableElement = $("tbody");
        var tableBottomPos = tableElement.position().top + tableElement.offset().top + tableElement.outerHeight(true);
        var submitElement = $("#submitDiv");
        var submitBottomPos = submitElement.position().top;
        var topPos = submitBottomPos - tableBottomPos - 40;
        $("#submitDiv").css('margin-top', "-" + topPos + "px");
    }
}

function processMetaData() {
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

function processPrompts() {
    $.ajax({
        type: 'GET',
        url: submitPromptUrl,
        dataType: 'json',
        success: function (data) {
            if (data !== undefined && data !== null) {
                submitPrompts = data;
                processWriters();
            }
        },
        error: function (xhr, status) {}
    });
}

function processWriters() {
    try {
        if (submitPrompts.writers) {
            var x2js = new X2JS();
            var writers = x2js.xml_str2json(submitPrompts.writers);
            if (writers) {
                submitPrompts.writers = [];
                submitPrompts.writers.isWriter = true;

                if (writers.rOIDicomExportQueueTypes && writers.rOIDicomExportQueueTypes.roiDicomExportQueueType) {

                    if (writers.rOIDicomExportQueueTypes.roiDicomExportQueueType.constructor === Array)
                        writers.rOIDicomExportQueueTypes.roiDicomExportQueueType.forEach(function (value) {
                            submitPrompts.writers.push({
                                name: value.name,
                                queueId: value.queueId
                            });
                        });
                    else
                        submitPrompts.writers.push({
                            name: writers.rOIDicomExportQueueTypes.roiDicomExportQueueType.name,
                            queueId: writers.rOIDicomExportQueueTypes.roiDicomExportQueueType.queueId
                        });
                }
            }
        } else {
            submitPrompts.writers = [];
            submitPrompts.writers.isWriter = true;
        }
    } catch (e) {}
}

function displayDemographics(data) {
    var patientName = changeNullToEmpty(data.patient.fullName.replace("^", ","));
    var patientAge = changeNullToEmpty(data.patient.age);
    var patientSex = changeNullToEmpty(data.patient.sex);
    patientICN = changeNullToEmpty(data.patient.iCN);
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

function getCurrentPatientStudyQuery() {
    var headers = {};
    var contents = {};
    var patientICN = BasicUtil.getUrlParameter("PatientICN");
    if (patientICN) {
        contents["patientICN"] = patientICN;
    } else {
        var patientDFN = BasicUtil.getUrlParameter("PatientDFN");
        if (patientDFN) {
            contents["patientDFN"] = patientDFN;
        }
    }

    //VAI-582: Server sends header names lowercase
    headers["content-type"] = "application/json";

    contents["siteNumber"] = BasicUtil.getUrlParameter("SiteNumber");
    contents["securityToken"] = BasicUtil.getUrlParameter("SecurityToken");

    return {
        Headers: headers,
        Contents: JSON.stringify(contents)
    };
}

function processStudy() {
    $("#btnSelectAll")[0].status = {};
    var searchQuery = getCurrentPatientStudyQuery();
    $.ajax({
        url: studyQueryUrl,
        data: searchQuery.Contents,
        headers: searchQuery.Headers,
        method: 'POST',
        dataType: 'json',
        async: true,
        success: function (data) {
            //Display all the patient information in dataTAble
            showOrHideViewer(true, true);
            var patientInformation = "";
            if (data.studies.length > 0) {
                for (var i = 0; i < data.studies.length; i++) {
                    patientInformation += '<tr><td>' + data.studies[i].procedureDescription + '</td><td>' + data.studies[i].studyDate + '</td><td>' + data.studies[i].origin + '</td><td style="width:50px">' + '<input id="study' + data.studies[i].groupIEN + '" type="checkbox"></input>&nbsp;' + '</td></tr>';
                    studyDetails[data.studies[i].groupIEN] = {
                        groupIEN: data.studies[i].groupIEN,
                        studyId: data.studies[i].studyId,
                        procedure: data.studies[i].procedureDescription,
                        specialty: data.studies[i].specialtyDescription,
                        detailsUrl: data.studies[i].detailsUrl + "&IncludeImageDetails=true"
                    };
                }
            }

            // Display data in the dataTable
            $('#patientInfo').append(patientInformation);
            patientTable = $('#patientInfoTable').DataTable({
                "bDestroy": true,
                "bAutoWidth": false,
                "bFilter": true,
                "bSort": true,
                "aaSorting": [[1]],
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
            resizeTable(true);

            $('select.form-control.input-sm').change(function () {
                resizeTable();
                EnableDisableSelection();
            });

            $('#patientInfoTable_filter').on('input', function () {
                resizeTable();
            });

            $('#patientInfoTable').on('page.dt', function () {
                setTimeout(function () {
                    resizeTable();
                }, 200);
                setTimeout(function () {
                    EnableDisableSelection();
                }, 100);
            });

            $('#patientInfoTable').on('order.dt', function () {
                resizeTable();
            });

            $('#patientInfoTable tbody').on('click', 'input', function () {
                toggleSelection();
            });
        },
        error: function (xhr, status) {
            showOrHideViewer(true, true);
        }
    });
}

function submitRoiPrintOrCD(type) {
    var isDicom = getSlectedStudies(true).isDicom;
    var promptvalues = getPromptValues(type);
    $('#printOrWriterWindow').dialog('option', 'title', promptvalues.title);
    $('#printOrWriterWindow').dialog('option', 'width', promptvalues.width);
    $("#printOrWriterWindow").data("type", type);
    $("#printOrWriterWindow").data("data", promptvalues.data);
    $('#printOrWriterWindow').data("callback", function (type, target) {
        if (type === "Print" || type === "CD") {
            $("#printOrWriterWindow").data("submitData", {
                type: type,
                target: target,
                downloadReason: ""
            });
            showESignature(type, target);
        } else {
            var submitData = $("#printOrWriterWindow").data("submitData");
            if (submitData) {
                submitData.downloadReason = target;
                submitRoiRequest(submitData);
                $("#printOrWriterWindow").data("submitData", undefined);
            }
        }
    });
    if (isDicom) {
        $("#printOrWriterWindow").dialog("open");
    } else {
        if ($("#printOrWriterWindow").data("callback") != undefined) {
            $("#printOrWriterWindow").data("callback")($("#printOrWriterWindow").data("type"), "");
        }
    }
}

function showAgreement(type, target) {
    var promptvalues = getPromptValues("Agreement");
    $('#printOrWriterAgreementWindow').dialog('option', 'title', promptvalues.title);
    $('#printOrWriterAgreementWindow').dialog('option', 'width', promptvalues.width);
    $("#printOrWriterAgreementWindow").data("data", promptvalues.data);
    $('#printOrWriterAgreementWindow').data("callback", function () {
        submitRoiPrintOrCD("DownloadReasons");
    });
    $("#printOrWriterAgreementWindow").dialog("open");
}

function getPromptValues(type) {
    try {
        var data = [];
        var title = "";
        var width = 250;

        switch (type) {
            case "Print":
                title = "Select Printer";
                data = ["Printer 1", "Printer 2", "Printer 3", "Printer 4", "Printer 5"]; //submitPrompts.printers;
                break;

            case "CD":
                title = "Select CD Writer";
                data = submitPrompts.writers;
                break;

            case "DownloadReasons":
                title = "Physician Agreement for Downloaded Images";
                data = submitPrompts.downloadReasons
                width = 400;
                break;

            case "Agreement":
                title = "Physician Agreement for Downloaded Images";
                data = submitPrompts.agreement;
                width = 400;
                break;
        }

        return {
            data: data,
            title: title,
            width: width
        };
    } catch (e) {}

    return {
        data: [],
        title: "",
        width: 250
    };
}

function createDummySubmitPrompts() {
    submitPrompts.printers = ["Printer 1", "Printer 2", "Printer 3", "Printer 4", "Printer 5"];
    submitPrompts.writers = ["Writer 1", "Writer 2", "Writer 3", "Writer 4", "Writer 5"];
    submitPrompts.downloadReasons = ["Reason 1", "Reason 2", "Reason 3", "Reason 4", "Reason 5"];
    submitPrompts.agreement = "Agreement Line1\nAgreement Line 2\nAgreement Line 3\nAgreement Line 4\nAgreement Line 5\nAgreement Line6\nAgreement Line 7\nAgreement Line 8\nAgreement Line 9\nAgreement Line 10";
}

function submitRoiRequest(submitData) {
    try {
        var selStudies = getSlectedStudies();
        var submitRequestData = {
            type: submitData.type,
            target: submitData.target,
            downloadReason: submitData.downloadReason,
            studies: selStudies
        };
        var xhttp;
        if (window.XMLHttpRequest) {
            xhttp = new XMLHttpRequest();
        } else {
            // code for IE6, IE5
            xhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }

        xhttp.onreadystatechange = function () {
            if (xhttp.readyState == 4 && xhttp.status == 200) {
                //Success
            }
        };
        xhttp.open("POST", submitUrl, true);
        //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
        xhttp.setRequestHeader("content-type", "application/json");
        xhttp.send(JSON.stringify(submitRequestData));
    } catch (e) {}
}

function toggleSelection() {
    var selection = $('input:checked');
    if (selection.length == 0) {
        $("#btnSelectAll")[0].textContent = "Select All";
    } else {
        $("#btnSelectAll")[0].textContent = "Deselect All";
    }
    EnableDisableSelection($("#btnSelectAll")[0].textContent);
}

function EnableDisableSelection(textContent) {
    if (!textContent) {
        var checkBoxvalue = $("input[type=checkbox]:checked", "#patientInfoTable ");
        var textContent = checkBoxvalue.length > 0 ? "Deselect All" : "Select All"
        $("#btnSelectAll")[0].textContent = textContent;
    }
    if (textContent !== "Select All") {
        $("#btnRoiPrint").removeAttr("disabled");
        $("#btnRoiCD").removeAttr("disabled");
    } else {
        $("#btnRoiPrint").attr("disabled", true);
        $("#btnRoiCD").attr("disabled", true);
    }
}

function selectOrDeselectAll() {
    if ($("#btnSelectAll")[0].textContent === "Select All") {
        $('input').prop('checked', true);
    } else {
        $('input').prop('checked', false);
    }

    toggleSelection();
    var currentPageSelection = $("#patientInfoTable_paginate .active a").text();
    var obj = $("#btnSelectAll")[0].status;
    obj[currentPageSelection] = $("#btnSelectAll")[0].textContent;
}

function getSlectedStudies(checkDicom) {
    var selection = $('input:checked');
    var slectedStudies = [];
    var isDicom = false;
    if (selection.length > 0) {
        for (var index = 0; index < selection.length; index++) {
            var inputId = selection[index].id;
            var groupIEN = inputId.substring(5, inputId.length);
            slectedStudies.push({
                groupIEN: groupIEN
            });
            if (checkDicom && !isDicom) {
                isDicom = checkIfDicom(groupIEN);
            }
        }
        slectedStudies.isDicom = isDicom;
    }
    return slectedStudies;
}

function checkIfDicom(groupIEN) {
    var isDicom = false;
    if (studyDetails) {
        var detailsUrl = studyDetails[groupIEN].detailsUrl;
        try {
            $.ajax({
                url: detailsUrl,
                method: 'GET',
                async: false,
                success: function (data) {
                    if (data && data.studies) {
                        data.studies.forEach(function (study) {
                            study.series.forEach(function (series) {
                                series.images.forEach(function (image) {
                                    if (image.imageType == "DICOM" || image.imageType == "TGA") {
                                        isDicom = true;
                                    }
                                });
                            });
                        });
                    }
                },
                error: function (xhr, status) {

                }
            });
        } catch (e) {

        }
    }
    return isDicom;
}

function updateSpinner(spinnerId, text) {
    try {
        var spinner = undefined;
        var existingSpinner = dicomViewer.progress.getSpinner(spinnerId);
        if (existingSpinner !== undefined) {
            if (existingSpinner.el) {
                var existingSpinnerDiv = $("#" + spinnerId + "_spinner");
                if (existingSpinnerDiv.length === 1) {
                    existingSpinnerDiv.css("white-space", "pre");
                    existingSpinnerDiv.html(text);
                    return;
                }
            }

            existingSpinner.stop();
            existingSpinner = undefined;
        }

        spinner = dicomViewer.progress.updateSpinnerInnerText(spinnerId, text);
        dicomViewer.progress.putSpinner(spinnerId, spinner);
    } catch (e) {}
}

function showOrHideViewer(isShow, stopSpinner) {
    try {
        if (isShow) {
            $("#patientInformation").show();
        } else {
            $("#patientInformation").hide();
        }

        if (stopSpinner) {
            var spinner = dicomViewer.progress.getSpinner('roisubmission');
            if (spinner !== undefined) {
                spinner.stop();
                spinner = undefined;
            }
        }
    } catch (e) {}
}

function showESignature(type, target) {
    $('#eSignatureWindow').data("callback", function (isVerified) {
        if (isVerified) {
            setTimeout(function () {
                showAgreement(type, target);
            }, 500);
        }
    });
    $("#eSignatureWindow").dialog("open");
}

function createESignatureDlg() {
    var dlg = '<div id="eSignatureWindow" title="eSignature" style="display:none"> <div id="alert-eSignature" class="alert alert-info" role="alert" style="padding: 5px;display:none"></div>' +
        '<div id="eSignatureTableDiv" width=100%><table id="eSignatureTable" class="table" border="0" width=80%> ' +
        '<tr><td style="padding-left:20px">Electronic signature is required to enable Print and Copy functions:</td></tr>' +
        '<tr><td style="padding-left:20px;">Signature:</td><td>' +
        '<input type="password" id="digitalSignature" style="color :black;" placeholder="Enter digital signature" >' +
        '</td ></tr></table ></div ></div > ';
    return dlg;
}

function verifySignature(signature) {
    try {
        var isVerified = false;
        showAndHideSplashWindow("show", "Verifying eSignature...", "roisubmission");

        var signatureUrl = (window.location.origin + "/vix/viewer/site/" + getUrlParameter("SiteNumber") + "/esignature/" + signature + "/verify?SecurityToken=" + getUrlParameter("SecurityToken") + "&AuthSiteNumber=" + getUrlParameter("AuthSiteNumber") + "&SiteNumber=" + getUrlParameter("SiteNumber"));

        $.ajax({
                type: 'GET',
                url: signatureUrl,
                async: false,
                data: ""
            })
            .success(function (data) {
                isVerified = true;
            })
            .fail(function (data, textStatus, errorThrown) {
                showAndHideSplashWindow("error", "Failed to verify the eSignature");
            })
            .error(function (xhr, status) {
                showAndHideSplashWindow("error", "Failed to verify the eSignature");
            });
    } catch (e) {
        showAndHideSplashWindow("error", "Failed to verify the eSignature");
    }
    return isVerified;
}
