// Configure all the endpoints of Ingest App.
var Site_Number = "500";


$(document).ready(function () {

    $("#user-login-form").submit(function () {

        //fetching and validating the server details
        var serverInfo = fetchServerDetails();
        var status = validateServerDetails(serverInfo);
        if (!status) return;

        var CVIX_Server = serverInfo.host;
        var CVIX_Port = serverInfo.port;

        var accessCode = $('#access-code').val();
        var verifyCode = $('#verify-code').val();

        if (accessCode == null || accessCode == "") {
            alert("Access code must not be empty");
            $('#access-code').focus();
        } else if (verifyCode == null || verifyCode == "") {
            alert("Verify code must not be empty");
            $('#verifyCode').focus();
        } else {
            //window.location.href = "home.html"; //TODO : undo this 

            crenString = btoa(accessCode + ":" + verifyCode);
            var headers = {
                "Authorization": "BASIC " + crenString
            };
            $.ajax({
                url: 'http://' + CVIX_Server + ':' + CVIX_Port + '/ViewerStudyWebApp/restservices/study/user/token',
                headers: headers,
                method: 'GET',
                async: false,
                success: function (data) {
                    var xmlDOM = new DOMParser().parseFromString("<restStringType>" + data.documentElement.innerHTML + "</restStringType>", 'text/xml');
                    var jsonResult = xmlToJson(xmlDOM);
                    localStorage["auth_token"] = crenString;
                    window.location.href = "home.html";
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("Invalid user credentials.")
                }
            });
        }

        return false;
    });

    $("#logout-btn").click(function () {
        window.location.href = "login.html";
    });

    $("#site-select").change(function () {
        var selectVal = $('#site-select').find(":selected").val();
        var siteNumber = selectVal.split("|")[0];
        var IpAddress = selectVal.split("|")[1];

        // VIX_Server = IpAddress.trim();
        Site_Number = siteNumber.trim();
    })
});

/**
 * Fetches and returns the server details from /config/appConfig configu file.
 */
function fetchServerDetails() {
    var CVIX_Server = appConfig.host.trim();
    var CVIX_Port = appConfig.port.trim();

    return {
        host: CVIX_Server,
        port: CVIX_Port
    }
}

function validateServerDetails(serverInfo) {
    if (isNullOrUndefined(serverInfo.host) || isNullOrUndefined(serverInfo.port)) {
        alert("The Target server is not configured properly. Please configure the details in appConfig file");
        return false;
    } else if (serverInfo.host.trim() == "" || serverInfo.port.trim() == "") {
        alert("The Target server is not configured properly. Please configure the details in appConfig file");
        return false;
    }
    return true;
}

/**
 * This method is used to fetch all the study information based on requestUrl.The following informations are read from the user.
 */
function searchPatients() {

    //fetching and validating the server details
    var serverInfo = fetchServerDetails();
    var status = validateServerDetails(serverInfo);
    if (!status) return;

    var CVIX_Server = serverInfo.host;
    var CVIX_Port = serverInfo.port;

    var searchText = $('#patient-search-text').val();

    if (searchText == null || searchText == "") {
        alert("searchText must not be null");
        $('#patient-search-text').focus();
    } else {
        $("#ajax_loader").show();
        var requestUrl = 'http://' + CVIX_Server + ':' + CVIX_Port + '/PatientWebApp/patient/getPatientList?searchCriteria=' + searchText
        var authStr = localStorage["auth_token"];
        var headers = {
            "Authorization": "BASIC " + authStr
        };

        $.ajax({
            url: requestUrl,
            headers: headers,
            method: 'GET',
            async: true,
            success: function (data) {
                var xmlDOM = new DOMParser().parseFromString(data, 'text/xml');
                var jsonResult = xmlToJson(xmlDOM);
                var studyInformation = "";
                if (!isNullOrUndefined(jsonResult.ArrayOfPatient)) {
                    if (!isNullOrUndefined(jsonResult.ArrayOfPatient.Patient) && jsonResult.ArrayOfPatient.Patient.length > 0) {
                        $.each(jsonResult.ArrayOfPatient.Patient, function (index, dataVal) {
                            studyInformation += '<tr><td class="wrap_words">' + dataVal.PatientName + '</td><td class="wrap_words">' + dataVal.PatientIcn + '</td><td class="wrap_words">' + dataVal.Dfn +
                                '</td><td>' + dataVal.Ssn + '</td><td>' + formatDate(dataVal.Dob) + '</td><td class="wrap_words">' + dataVal.Sensitive + '</td><td>' + dataVal.VeteranStatus +
                                '</td><td>' +
                                '<input type="hidden" class="patient-hidden" value="' + dataVal.PatientName + '|' + dataVal.PatientIcn + '|' + dataVal.Dfn + '|' + dataVal.Ssn + '|' + dataVal.Dob + '|' + dataVal.Sensitive + '|' + dataVal.VeteranStatus + '|' + dataVal.PatientSex + '">' +
                                '<a class="btn btn-success btn-sm" onClick="viewPatient(\'' + dataVal.PatientIcn + '\', ' + index + ', ' + 'this)">Select Patient</a>&nbsp;' +
                                '<a class="btn btn-primary btn-sm"  onClick="fetchIndexTermsDetails(\'' + dataVal.PatientIcn + '\', \'Photo_Id\' , ' + index + ', ' + 'this)">Upload Photo Id</a>&nbsp;' +
                                '<a class="btn btn-warning btn-sm"  onClick="fetchIndexTermsDetails(\'' + dataVal.PatientIcn + '\', \'Index_Term\' , ' + index + ', ' + 'this)">Index Term</a>&nbsp;' +
                                // '<a class="btn btn-primary btn-sm"  onClick="fetchIndexTermsDetails(\'' + dataVal.PatientIcn + '\', \'Photo_Id\' , ' + index + ', ' + 'this)">Upload Image</a>&nbsp;' +
                                '</td></tr>';
                        });
                    }
                }
                $('#patientInformation').hide();
                if ( $.fn.DataTable.isDataTable( "#studyInfoTable" ) ) {
                    $('#studyInfoTable').DataTable().destroy();
                }
                $('#studyInfo').html('');
                $('#studyInfo').append(studyInformation);
                // Display data in the dataTable
                var table = $('#studyInfoTable').DataTable({
                    "bDestroy": true,
                    "bAutoWidth": false,
                    "bFilter": true,
                    "bSort": true,
                    "aaSorting": [
                        [0]
                    ],
                    "lengthMenu": [
                        [5, 10, 15, -1],
                        [5, 10, 15, "All"]
                    ],
                    "pageLength": 5,
                    "aoColumns": [{
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
                        },
                        {
                            "sWidth": '15%',
                            "bSortable": true
                        },
                        {
                            "sWidth": '25%',
                            "bSortable": false
                        }
                    ]
                });
                // $('#container').css( 'display', 'block' );
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

function viewPatient(patientICN, rindex, ele) {

    //fetching and validating the server details
    var serverInfo = fetchServerDetails();
    var status = validateServerDetails(serverInfo);
    if (!status) return;

    var CVIX_Server = serverInfo.host;
    var CVIX_Port = serverInfo.port;

    $("#view-patient-details").show();
    // $("#upload-patient-image").hide();
    $("#patientInformation").hide();

    var row = $(ele).closest("tr");
    var pName = $(row).find('td:nth-child(1)').text();
    var pICN = $(row).find('td:nth-child(2)').text();
    var pDfn = $(row).find('td:nth-child(3)').text();
    var pSsn = $(row).find('td:nth-child(4)').text();
    var pDob = $(row).find('td:nth-child(5)').text();
    var pSensi = $(row).find('td:nth-child(6)').text();
    var pVeteran = $(row).find('td:nth-child(7)').text();

    $("#view-patient-details .patient-detail-name").text(pName);
    $("#view-patient-details .patient-detail-icn").text(pICN);
    $("#view-patient-details .patient-detail-dfn").text(pDfn);
    $("#view-patient-details .patient-detail-ssn").text(pSsn);
    $("#view-patient-details .patient-detail-dob").text(pDob);
    $("#view-patient-details .patient-detail-sensitive").text(pSensi);
    $("#view-patient-details .patient-detail-veteran-status").text(pVeteran);

    //Setting the hidden field for keep track of current patient
    $("#currentPatientId").val(pICN);

    //changing the image src


    //Getting the patient image
    var authStr = localStorage["auth_token"];
    var headers = {
        "Authorization": "BASIC " + authStr
    };
    var requestUrl = 'http://' + CVIX_Server + ':' + CVIX_Port + '/ImageWebApp/photo/icn/' + Site_Number + '/' + patientICN;
    $.ajax({
        url: requestUrl,
        headers: headers,
        method: 'GET',
        processData: false,
        xhr: function () {
            var xhr = new XMLHttpRequest();
            xhr.responseType = 'blob';
            return xhr;
        },
        success: function (data) {
            var img = document.getElementsByClassName('patient-image')[0];
            var url = window.URL || window.webkitURL;
            img.src = url.createObjectURL(data);
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("No image found for the patient");
            var img = document.getElementsByClassName('patient-image')[0];
            img.src = "";
        }

    });

    //Getting the patient sensivity level
    requestUrl = 'http://' + CVIX_Server + ':' + CVIX_Port + '/PatientWebApp/restservices/patient/sensitive/check/' + Site_Number + '/' + patientICN;
    $.ajax({
        url: requestUrl,
        headers: headers,
        method: 'GET',
        async: true,
        success: function (data) {
            var xmlDOM = new DOMParser().parseFromString("<patientSensitiveValueType>" + data.documentElement.innerHTML + "</patientSensitiveValueType>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            if (!isNullOrUndefined(jsonResult.patientSensitiveValueType)) {
                if (!isNullOrUndefined(jsonResult.patientSensitiveValueType.sensitiveLevel)) {
                    $(".patient-sensitivity-level-div .sensitivity-content").text(jsonResult.patientSensitiveValueType.sensitiveLevel);
                } else {
                    $(".patient-sensitivity-level-div").hide();
                }
                if (!isNullOrUndefined(jsonResult.patientSensitiveValueType.warningMessage) && (typeof jsonResult.patientSensitiveValueType.warningMessage != "object")) {
                    $(".patient-sensitivity-warning-message-div .sensitivity-content").text(jsonResult.patientSensitiveValueType.warningMessage);
                } else {
                    $(".patient-sensitivity-warning-message-div").hide();
                }
            } else {
                $(".patient-sensitivity-err-msg").show();
                $(".patient-sensitivity").hide();
                return;
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            $(".patient-sensitivity-err-msg").show();
            $(".patient-sensitivity").hide();
        }

    });

    //Getting the patient consult for the patient
    requestUrl = 'http://' + CVIX_Server + ':' + CVIX_Port + '/ConsultWebApp/restservices/consult/consults/' + Site_Number + '/' + patientICN;
    $.ajax({
        url: requestUrl,
        headers: headers,
        method: 'GET',
        async: true,
        success: function (data) {
            console.log("Consult fetch successfully");
            var xmlDOM = new DOMParser().parseFromString("<consults>" + data.documentElement.innerHTML + "</consults>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var consultInformation = "";
            if (!isNullOrUndefined(jsonResult.consults)) {
                if (!isNullOrUndefined(jsonResult.consults.consult)) {
                    $.each(jsonResult.consults.consult, function (index, dataVal) {
                        consultInformation += '<tr><td class="wrap_words">' + dataVal.service + '</td><td class="wrap_words">' + dataVal.consultId + '</td><td class="wrap_words">' + dataVal.numberNotes +
                            '</td><td>' + ((typeof dataVal.procedure == "object") ? "-" : dataVal.procedure) + '</td><td class="wrap_words">' + dataVal.status + '</td>' +
                            '<td>' +
                            // '<a class="btn btn-primary btn-sm" data-toggle="modal" data-target="#upload-image-tiunote-div" onclick="setHiddenFieldsForNoteImageUpload(this,\''+dataVal.patientTiuNoteUrn+'\')">Upload Image</a>&nbsp;' +
                            '<button type="button" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#create-tiunote-for-pat-div" onclick="setHiddenFieldsForNoteImageUpload(this,\''+dataVal.consultId+'\')"> Add TIU Note for Consult </button>' + 
                            '</td>'+
                            '</tr>';
                    });
                } else {
                    $(".consult-err-msg").show();
                    $(".consult-div").hide();
                    return;
                }
            } else {
                $(".consult-err-msg").show();
                $(".consult-div").hide();
                return;
            }

            $(".consult-err-msg").hide();
            $('.consult-div').hide();
            if ( $.fn.DataTable.isDataTable( "#consult-table" ) ) {
                $('#consult-table').DataTable().destroy();
            }
            $('#consultInfo').html('');
            $('#consultInfo').append(consultInformation);
            // Display data in the dataTable
            var table = $('#consult-table').DataTable({
                "bDestroy": true,
                "bAutoWidth": false,
                "bFilter": true,
                "bSort": true,
                "aaSorting": [
                    [0]
                ],
                "lengthMenu": [
                    [5, 10, 15, -1],
                    [5, 10, 15, "All"]
                ],
                "pageLength": 5,
                "aoColumns": [{
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
                        "sWidth": '15%',
                        "bSortable": true
                    },
                    {
                        "sWidth": '15%',
                        "bSortable": true
                    }
                ]
            });
            table.columns.adjust().draw();
            $('.consult-div').show();
        },
        error: function (jqXHR, textStatus, errorThrown) {
            $(".consult-err-msg").show();
            $(".consult-div").hide();
        }
    });

    //Getting the TIU notes for the patient
    requestUrl = 'http://' + CVIX_Server + ':' + CVIX_Port + '/TIUWebApp/restservices/tiu/patient/notes/' + Site_Number + '/' + patientICN + '/unsigned/30/true';
    $.ajax({
        url: requestUrl,
        headers: headers,
        method: 'GET',
        async: true,
        success: function (data) {
            console.log("TIU Notes fetch successfully")
            var xmlDOM = new DOMParser().parseFromString("<notes>" + data.documentElement.innerHTML + "</notes>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var tiuInformation = "";
            if (!isNullOrUndefined(jsonResult.notes)) {
                if (!isNullOrUndefined(jsonResult.notes.note)) {
                    if (jQuery.isArray(jsonResult.notes.note)) {
                        $.each(jsonResult.notes.note, function (index, dataVal) {
                            tiuInformation += '<tr><td class="wrap_words">' + dataVal.title + '</td><td class="wrap_words">' + dataVal.authorName + '</td><td class="wrap_words">' + formatDate(dataVal.date) +
                                '</td><td>' + dataVal.hospitalLocation + '</td><td>' + dataVal.numberAssociatedImages + '</td><td class="wrap_words">' + dataVal.patientTiuNoteUrn + '</td><td>' + dataVal.signatureStatus +
                                '</td><td>' +
                                '<input type="hidden" class="patient-hidden" value="' + dataVal.patientTiuNoteUrn + '|' + dataVal.title + '|' + dataVal.authorName + '|' + dataVal.date + '|' + dataVal.hospitalLocation + '|' + dataVal.numberAssociatedImages + '|' + dataVal.signatureStatus + '">' +
                                '<a class="btn btn-primary btn-sm" onClick="fetchIndexTermsDetails(\'' + dataVal.patientTiuNoteUrn + '\', \'TIU_Note\' , ' + index + ', ' + 'this)">Upload Image</a>&nbsp;' +
                                '</td></tr>';
                        });
                    } else {
                        var dataVal = jsonResult.notes.note;
                        tiuInformation += '<tr><td class="wrap_words">' + dataVal.title + '</td><td class="wrap_words">' + dataVal.authorName + '</td><td class="wrap_words">' + formatDate(dataVal.date) +
                            '</td><td>' + dataVal.hospitalLocation + '</td><td>' + dataVal.numberAssociatedImages + '</td><td class="wrap_words">' + dataVal.patientTiuNoteUrn + '</td><td>' + dataVal.signatureStatus +
                            '</td><td>' +
                            '<input type="hidden" class="patient-hidden" value="' + dataVal.patientTiuNoteUrn + '|' + dataVal.title + '|' + dataVal.authorName + '|' + dataVal.date + '|' + dataVal.hospitalLocation + '|' + dataVal.numberAssociatedImages + '|' + dataVal.signatureStatus + '">' +
                            // '<a class="btn btn-primary btn-sm" data-toggle="modal" data-target="#upload-image-tiunote-div" onclick="setHiddenFieldsForNoteImageUpload(this,\''+dataVal.patientTiuNoteUrn+'\')">Upload Image</a>&nbsp;' +
                            '<a class="btn btn-primary btn-sm" onClick="fetchIndexTermsDetails(\'' + dataVal.patientTiuNoteUrn + '\', \'TIU_Note\' , 0 , ' + 'this)">Upload Image</a>&nbsp;' +
                            '</td></tr>';
                    }
                } else {
                    $(".tiu-notes-err-msg").show();
                    $(".tiu-notes-div").hide();
                    return;
                }
            } else {
                $(".tiu-notes-err-msg").show();
                $(".tiu-notes-div").hide();
                return;
            }

            $(".tiu-notes-err-msg").hide();
            $('.tiu-notes-div').hide();
            if ( $.fn.DataTable.isDataTable( "#tiu-notes-table" ) ) {
                $("#tiu-notes-table").DataTable().destroy();
            }
            $('#tiuInfo').html('');
            $('#tiuInfo').html(tiuInformation);
            // Display data in the dataTable
            var table = $('#tiu-notes-table').DataTable({
                "bDestroy": true,
                "bAutoWidth": false,
                "bFilter": true,
                "bSort": true,
                "aaSorting": [
                    [0]
                ],
                "lengthMenu": [
                    [5, 10, 15, -1],
                    [5, 10, 15, "All"]
                ],
                "pageLength": 5,
                "aoColumns": [{
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
                        "sWidth": '15%',
                        "bSortable": true
                    },
                    {
                        "sWidth": '15%',
                        "bSortable": true
                    },
                    {
                        "sWidth": '25%',
                        "bSortable": false
                    }
                ]
            });
            // $('#container').css( 'display', 'block' );
            table.columns.adjust().draw();
            $('.tiu-notes-div').show();
        },
        error: function (jqXHR, textStatus, errorThrown) {
            $(".tiu-notes-err-msg").show();
            $(".tiu-notes-div").hide();
        }
    });
}

function backToHomePage() {
    $("#view-patient-details").hide();
    // $("#upload-patient-image").hide();
    $("#index-term-outer-div").hide();
    $("#patientInformation").show();
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
    } catch (e) {}

    return param;
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

/** Index term related scripts : START*/

function fetchIndexTermsDetails(patientICN, targetSection, index) {

    //fetching and validating the server details
    var serverInfo = fetchServerDetails();
    var status = validateServerDetails(serverInfo);
    if (!status) return;

    var CVIX_Server = serverInfo.host;
    var CVIX_Port = serverInfo.port;

    //Showing the UI section and hiding other sections
    $("#index-term-outer-div").show();
    $("#view-patient-details").hide();
    $("#patientInformation").hide();
    $(".image-upload-form-for-indexes").attr("action", 'http://' + CVIX_Server + ':' + CVIX_Port + '/IngestWebApp/ingest');

    //Changing the target section heading
    if (targetSection == 'Photo_Id') {
        $("#index-term-outer-div").find('.target-section').text('Photo Id');
    } else if (targetSection == 'Index_Term') {
        $("#index-term-outer-div").find('.target-section').text('Index Term');
    } else if (targetSection == 'TIU_Note') {
        $("#index-term-outer-div").find('.target-section').text('TIU Note');
    }

    var patientNoteUrn = "";
    //if page is comming from TIU notes, then extracting the patient id.
    if (targetSection == 'TIU_Note') {
        patientNoteUrn = patientICN;
        patientICN = patientICN.substring(patientICN.lastIndexOf("-") + 1, patientICN.length);
    }

    //Setting the hidden fields
    $(".image-upload-form-for-indexes").find(".patientTiuNoteId").val(patientNoteUrn);
    $(".image-upload-form-for-indexes").find(".patientId").val(patientICN);
    $(".image-upload-form-for-indexes").find(".img-desc").val("ADVANCE DIRECTIVE");
    $(".image-upload-form-for-indexes").find(".proc-dropdown").html("");

    //resetting the image file field
    $('.image-upload-form-for-indexes').find("#patient-image-file-for-index-term").val("");

    var selectVal = $('#site-select-for-indexes').find(":selected").val();
    var siteNumber = selectVal.split("|")[0].trim();
    var authStr = localStorage["auth_token"];
    var headers = {
        "Authorization": "BASIC " + authStr
    };

    //Getting the origins for the site
    var requestUrl = 'http://' + CVIX_Server + ':' + CVIX_Port + '/IndexTermWebApp/restservices/indexTerms/origins/' + siteNumber;
    $(".origin-dropdown").html("");
    $.ajax({
        url: requestUrl,
        headers: headers,
        method: 'GET',
        success: function (data) {
            var xmlDOM = new DOMParser().parseFromString("<indexTermValuesType>" + data.documentElement.innerHTML + "</indexTermValuesType>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var originInformation = "";
            if (!isNullOrUndefined(jsonResult.indexTermValuesType)) {
                if (!isNullOrUndefined(jsonResult.indexTermValuesType.indexTermValue)) {
                    $.each(jsonResult.indexTermValuesType.indexTermValue, function (index, dataVal) {
                        originInformation += '<option value="' + dataVal.name + '">' + dataVal.name + '</option>';
                    });
                }
            }
            if (originInformation) {
                $(".origin-dropdown").html(originInformation);
            } else {
                $(".origin-dropdown").html("");
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception thrown while fetching the origins, " + errorThrown);
        }

    });

    //Getting the types for the site
    requestUrl = 'http://' + CVIX_Server + ':' + CVIX_Port + '/IndexTermWebApp/restservices/indexTerms/types/' + siteNumber;
    $(".doc-type-dropdown").html("");
    $.ajax({
        url: requestUrl,
        headers: headers,
        method: 'GET',
        success: function (data) {
            var xmlDOM = new DOMParser().parseFromString("<indexTermValuesType>" + data.documentElement.innerHTML + "</indexTermValuesType>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var typesInformation = "";
            if (!isNullOrUndefined(jsonResult.indexTermValuesType)) {
                if (!isNullOrUndefined(jsonResult.indexTermValuesType.indexTermValue)) {
                    $.each(jsonResult.indexTermValuesType.indexTermValue, function (index, dataVal) {
                        typesInformation += '<option value="' + dataVal.name + '">' + dataVal.name + '</option>';
                    });
                }
            }
            if (typesInformation) {
                $(".doc-type-dropdown").html(typesInformation);

                //Selecting the photo id option when loading the page for photo id
                if (targetSection == 'Photo_Id') {
                    $(".doc-type-dropdown").find("option[value = 'PHOTO ID']").attr("selected", true);
                    $(".image-upload-form-for-indexes").find(".img-desc").val("PHOTO ID")
                }
            } else {
                $(".doc-type-dropdown").html("");
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception thrown while fetching the origins, " + errorThrown);
        }

    });

    if (targetSection != 'Photo_Id') {
        //enabling the drop down
        $(".specialty-dropdown").attr("disabled", false);

        //Getting the specialty for the site
        requestUrl = 'http://' + CVIX_Server + ':' + CVIX_Port + '/IndexTermWebApp/restservices/indexTerms/specialties/' + siteNumber;
        $(".specialty-dropdown").html("");
        $.ajax({
            url: requestUrl,
            headers: headers,
            method: 'GET',
            success: function (data) {
                var xmlDOM = new DOMParser().parseFromString("<indexTermValuesType>" + data.documentElement.innerHTML + "</indexTermValuesType>", 'text/xml');
                var jsonResult = xmlToJson(xmlDOM);

                var specialtyInfo = "";
                if (!isNullOrUndefined(jsonResult.indexTermValuesType)) {
                    if (!isNullOrUndefined(jsonResult.indexTermValuesType.indexTermValue)) {
                        $.each(jsonResult.indexTermValuesType.indexTermValue, function (index, dataVal) {
                            specialtyInfo += '<option value="' + dataVal.indexTermId + '">' + dataVal.name + '</option>';
                        });
                    }
                }
                if (specialtyInfo) {
                    $(".specialty-dropdown").html(specialtyInfo);
                } else {
                    $(".specialty-dropdown").html("");
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.log("Exception thrown while fetching the origins, " + errorThrown);
            }

        });
    } else {
        $(".specialty-dropdown").html("");
        $(".specialty-dropdown").attr("disabled", true);
    }

    //For other fields
    if (targetSection == 'Photo_Id') {
        $(".proc-dropdown").html("");
        $(".proc-dropdown").attr("disabled", true);
    } else {
        $(".proc-dropdown").attr("disabled", false);
    }
}
$(document).ready(function () {

    //Uploading photo id image
    $('.image-upload-form-for-indexes').submit(function (e) {
        e.preventDefault();

        //fetching and validating the server details
        var serverInfo = fetchServerDetails();
        var status = validateServerDetails(serverInfo);
        if (!status) return;

        var CVIX_Server = serverInfo.host;
        var CVIX_Port = serverInfo.port;

        //input Validations
        if ($('.image-upload-form-for-indexes').find("#patient-image-file-for-index-term").val() == "") {
            alert("Please select the image to upload.");
            return false;
        }

        if ($('.image-upload-form-for-indexes').find("textarea[name='shortDescription']").val() == "") {
            alert("Please enter image description.");
            return false;
        }

        var dataObj = new FormData(this);
        var authStr = localStorage["auth_token"];
        var headers = {
            "Authorization": "BASIC " + authStr
        };
        $("#ajax_loader").show();
        $.ajax({
            method: 'POST',
            url: 'http://' + CVIX_Server + ':' + CVIX_Port + '/IngestWebApp/ingest',
            data: dataObj,
            headers: headers,
            cache: false,
            processData: false, // tell jQuery not to process the data
            contentType: false, // tell jQuery not to set contentType
            enctype: 'multipart/form-data',
            success: function (data) {
                $("#ajax_loader").hide();
                alert("Image uploaded successfully.");
                backToHomePage();
            },
            error: function (jqXHR, textStatus, errorThrown) {
                $("#ajax_loader").hide();
                alert("Exception while uploading the image: ");
            }
        });
        return false;
    });

    $("#site-select-for-indexes").change(function () {
        fetchIndexTermsDetails();
        $(".proc-dropdown").html("");
    });

    $(".doc-type-dropdown").change(function () {
        var selectedType = $(this).find(":selected").val();
        $(".img-desc").val(selectedType);
    });

    $(".specialty-dropdown").change(function () {
        //fetching and validating the server details
        var serverInfo = fetchServerDetails();
        var status = validateServerDetails(serverInfo);
        if (!status) return;

        var CVIX_Server = serverInfo.host;
        var CVIX_Port = serverInfo.port;

        var selectedSpecialty = $(this).find(":selected").val();
        var selectVal = $('#site-select-for-indexes').find(":selected").val();
        var siteNumber = selectVal.split("|")[0].trim();

        //Setting the specialty hidden field
        $(".image-upload-form-for-indexes").find("input[name = 'specialtyIndex']").val($(this).find(":selected").text());

        var authStr = localStorage["auth_token"];
        var headers = {
            "Authorization": "BASIC " + authStr
        };
        $(".proc-dropdown").html("");

        //Getting the types for the site
        requestUrl = 'http://' + CVIX_Server + ':' + CVIX_Port + '/IndexTermWebApp/restservices/indexTerms/procedureevents/' + siteNumber + '/' + selectedSpecialty;
        $.ajax({
            url: requestUrl,
            headers: headers,
            method: 'GET',
            success: function (data) {
                var xmlDOM = new DOMParser().parseFromString("<indexTermValuesType>" + data.documentElement.innerHTML + "</indexTermValuesType>", 'text/xml');
                var jsonResult = xmlToJson(xmlDOM);

                var procInformation = "";
                if (!isNullOrUndefined(jsonResult.indexTermValuesType)) {
                    if (!isNullOrUndefined(jsonResult.indexTermValuesType.indexTermValue)) {
                        $.each(jsonResult.indexTermValuesType.indexTermValue, function (index, dataVal) {
                            procInformation += '<option value="' + dataVal.name + '">' + dataVal.name + '</option>';
                        });
                    }
                }
                if (procInformation) {
                    $(".proc-dropdown").html(procInformation);
                } else {
                    $(".proc-dropdown").html("");
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                console.log("Exception thrown while fetching the procedure events, " + errorThrown);
                alert("Exception thrown while fetching the procedure events, " + errorThrown);
            }

        });
    });
});
/** Index term related scripts : END */

/** Tiu notes related script: START */

function fetchLocationsforSite(siteNumber) {
    //fetching and validating the server details
    var serverInfo = fetchServerDetails();
    var status = validateServerDetails(serverInfo);
    if (!status) return;

    var CVIX_Server = serverInfo.host;
    var CVIX_Port = serverInfo.port;

    //Getting the patient image
    var authStr = localStorage["auth_token"];
    var headers = {
        "Authorization": "BASIC " + authStr
    };
    var requestUrl = 'http://' + CVIX_Server + ':' + CVIX_Port + '/TIUWebApp/restservices/tiu/locations/' + siteNumber + '?searchText=t';
    $.ajax({
        url: requestUrl,
        headers: headers,
        method: 'GET',
        success: function (data) {
            var xmlDOM = new DOMParser().parseFromString("<locations>" + data.documentElement.innerHTML + "</locations>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var locationInfo = "";
            if (!isNullOrUndefined(jsonResult.locations)) {
                if (!isNullOrUndefined(jsonResult.locations.location)) {
                    $.each(jsonResult.locations.location, function (index, dataVal) {
                        locationInfo += '<option value="' + dataVal.locationId + '">' + dataVal.name + '</option>';
                    });
                }
            }
            if (locationInfo) {
                $(".location-dropdown").html(locationInfo);
                $(".location-dropdown").find("option:first-child").attr("selected", "selected");
            } else {
                $(".location-dropdown").html("");
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception while fetching the location");
            $(".location-dropdown").html("");
        }
    });
}

 function fetchTIUIds(siteNumber, searchText) {
    //fetching and validating the server details
    var serverInfo = fetchServerDetails();
    var status = validateServerDetails(serverInfo);
    if (!status) return;

    var CVIX_Server = serverInfo.host;
    var CVIX_Port = serverInfo.port;

    var authStr = localStorage["auth_token"];
    var headers = {
        "Authorization": "BASIC " + authStr
    };

     //Getting the patient consult for the patient
    requestUrl = 'http://' + CVIX_Server + ':' + CVIX_Port + '/TIUWebApp/restservices/tiu/notes/' + siteNumber+ '?searchText='+ searchText
    $.ajax({
        url: requestUrl,
        headers: headers,
        method: 'GET',
        async: true,
        success: function (data) {
            console.log("Consult fetch successfully");
            var xmlDOM = new DOMParser().parseFromString("<notes>" + data.documentElement.innerHTML + "</notes>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var tiuNotesInfo = "";
            if (!isNullOrUndefined(jsonResult.notes)) {
                if (!isNullOrUndefined(jsonResult.notes.note)) {
                    $.each(jsonResult.notes.note, function (index, dataVal) {
                        var _title = "";
                        if(typeof dataVal.title != "object"){
                            _title = dataVal.title.substring(1,dataVal.title.length-1);
                        }
                        tiuNotesInfo += '<option value="' + dataVal.noteId + '">' + dataVal.keyword +' | '+  _title + '</option>';
                    });
                }
            }

            $(".tiu-dropdown").html(tiuNotesInfo);
            $(".tiu-dropdown").find("option:first-child").attr("selected", "selected");
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception while fetching the TIU notes.");
            $(".tiu-dropdown").html("<option> </option>");
        }
    }); 
} 

/**
 * convert form data to xml
 * @param {*} form 
 */
function fromToXml(form, rootNode) {
    var elements = form.elements;
    var xmlTemplate = '<?xml version="1.0"?> <' + rootNode + '>';
    for (var i = 0; i < elements.length; i++) {
        var element = elements[i];
        if (element.tagName == "INPUT" || element.tagName == 'TEXTAREA') {
            xmlTemplate = xmlTemplate + '<' + element.name + '>' + element.value + '</' + element.name + '>';
        }
    }
    xmlTemplate = xmlTemplate + '</' + rootNode + '>';
    return xmlTemplate;
}

$(document).ready(function () {
    //When the dialog gets displayed
    $('#create-tiunote-for-pat-div').on('shown.bs.modal', function (e) {
        var patientId = $("#currentPatientId").val();

        var selectVal = $('.create-tiu-note-form .site-select-for-notes').find(":selected").val();

        var siteNumber = selectVal.split("|")[0].trim();
        fetchLocationsforSite(siteNumber);

        //Searching different text for the tiunotes based on, if the we are adding the note for patient OR for the consults.
        var searchText = "";
        if($('.create-tiu-note-form .source').val() == "CON_SOURCE"){
            searchText = "consult";
        }
        fetchTIUIds(siteNumber, searchText);

        //Setting the date field
        var myDate = new Date();
        var dateStr = myDate.getFullYear() + '-' + ('0' + (myDate.getMonth() + 1)).slice(-2) + '-' + myDate.getDate() + ' ' + myDate.getHours() + ':' + ('0' + (myDate.getMinutes())).slice(-2) + ':' + myDate.getSeconds();
        $('.create-tiu-note-form').find('.date').val(dateStr);
        $('.create-tiu-note-form .patientId').val(patientId);

        //Resetting the field in model
        $('.create-tiu-note-form').find('.noteText').val("");
    });

    $(".site-select-for-notes").change(function () {
        var selectVal = $('.create-tiu-note-form .site-select-for-notes').find(":selected").val();
        var siteNumber = selectVal.split("|")[0].trim();
        fetchLocationsforSite(siteNumber);
    });

    $('.create-tiu-note-form').submit(function (e) {
        e.preventDefault();

        //Input validation
        if ($('.create-tiu-note-form').find(".noteText").val().trim() == "") {
            alert("Please enter the Note text.");
        } else {

            var source = $('.create-tiu-note-form .source').val();
            //fetching and validating the server details
            var serverInfo = fetchServerDetails();
            var status = validateServerDetails(serverInfo);
            if (!status) return;

            var CVIX_Server = serverInfo.host;
            var CVIX_Port = serverInfo.port;

            //Setting the hidden location field while submitting the form
            var selected_opt = $(".location-dropdown").find(":selected");
            $('.create-tiu-note-form .locationId').attr('value', selected_opt.val());
            var tiu_opt = $(".tiu-dropdown").find(":selected");
            $('.create-tiu-note-form .tiuNoteId').attr('value', tiu_opt.val());

            var selectVal = $('.create-tiu-note-form .site-select-for-notes').find(":selected").val();
            var siteNumber = selectVal.split("|")[0].trim();

            // var dataObj = $(".create-tiu-note-form").serialize();
            var dataObj = fromToXml(document.getElementsByClassName("create-tiu-note-form")[0], "noteInputType");

            var authStr = localStorage["auth_token"];
            var headers = {
                "Authorization": "BASIC " + authStr
            };
            jQuery.ajax({
                method: 'POST',
                url: 'http://' + CVIX_Server + ':' + CVIX_Port + '/TIUWebApp/restservices/tiu/note',
                data: dataObj,
                headers: headers,
                contentType: "application/xml",
                success: function (data) {
                    alert("TIU note added successfully.");
                    $('#create-tiunote-for-pat-div').modal('toggle');
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("Exception while creating the tiu note: "+ jqXHR.responseXML.documentElement.firstElementChild.innerHTML);
                }
            });
        }
        return false;
    });
});

function setHiddenFieldsForNoteImageUpload(evt, consultId) {
    $(".create-tiu-note-form").find(".consultUrn").val(consultId);
    $(".create-tiu-note-form").find(".source").val("CON_SOURCE");
}

function clearHiddenFieldsForNoteImageUpload(evt){
    $(".create-tiu-note-form").find(".consultUrn").val("");
    $(".create-tiu-note-form").find(".tiuNoteId").val("");
    $(".create-tiu-note-form").find(".source").val("PAT_SOURCE");
    
}
/** Tiu notes related script: END */