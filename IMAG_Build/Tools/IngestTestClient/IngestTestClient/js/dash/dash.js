$(document).ready(function () {
    $("#user-login-form").submit(function () {
        var siteServers = $('#siteServers').val();
        var siteServer = $('#login-site-select').val();
        var accessCode = $('#access-code').val();
        var verifyCode = $('#verify-code').val();
        var locationStartWith = $('#locationStartWith').val();
        var titleStartWith = $('#titleStartWith').val();
        var tiuStatus = $('#tiuStatus').val();
        var authorDuz = $('#authorDuz').val();
        var localAV = $('#localAV').val();
        //var localSecToken = $('#localSecToken').val();

        if (siteServer == null || siteServer == "") {
            alert("site not be empty");
            $('#login-site-select').focus();
        } else if (accessCode == null || accessCode == "") {
            alert("Access code must not be empty");
            $('#access-code').focus();
        } else if (verifyCode == null || verifyCode == "") {
            alert("Verify code must not be empty");
            $('#verifyCode').focus();
        } else {
            var loginServer = siteServer.split("|");
            var authenticate_user_url = "http://" + loginServer[1] + ":" + loginServer[2] + "/ViewerStudyWebApp/restservices/study/user/token";
            var crenString = btoa(accessCode + ":" + verifyCode);
            var headers = {
                "Authorization": "Basic " + crenString
            };
            $.ajax({
                url: authenticate_user_url,
                headers: headers,
                method: 'GET',
                async: false,
                success: function (data) {
                    var val = data.documentElement.innerHTML;
                    var loginSecToken = val.split('</value>')[0].split('<value>')[1];
                    window.location.href = "home.html?auth=" + crenString + "&servers=" + encodeURIComponent(siteServers) +
						"&selected=" + siteServer + "&secToken=" + encodeURIComponent(loginSecToken);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert("Invalid user credentials." + authenticate_user_url)
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
        var siteConfig = selectVal.split("|");

        $('#locationStartWith').val(siteConfig[3]);
        $('#titleStartWith').val(siteConfig[4]);
        $('#tiuStatus').val(siteConfig[5]);
        $('#authorDuz').val(siteConfig[6]);
        $('#localAV').val(btoa(siteConfig[7]));

        var currentPatient = $("#currentPatientId").val();
        if (!isNullOrUndefined(currentPatient) && (currentPatient != "")) {
            $('#site-select').val(selectVal).change();
            $('#site-select-for-indexes').val(selectVal).change();
            $('#site-select-for-notes').val(selectVal).change();
        } else {
            $('#site-select-for-indexes').val(selectVal);
            $('#site-select-for-notes').val(selectVal);
        }

        $('#create-tiunote-div').hide();
        $('#index-term-outer-div').hide();
    });
});

function loadSites() {
    //load site specific configuration
    var testClientConiguration_url = "c:/testclientconfig/testClientConfiguration.config";

    $.ajax({
        url: testClientConiguration_url,
        method: 'GET',
        dataType: 'xml',
        success: function (data) {
            var result = data.documentElement.innerHTML;
            var xmlDOM = new DOMParser().parseFromString("<configurations>" + result + "</configurations>", "text/xml");
            var jsonResult = xmlToJson(xmlDOM);

            var configurationInformation = "";
            if (!isNullOrUndefined(jsonResult.configurations)) {
                var vixHost = jsonResult.configurations.vixHost;
                var vixPort = jsonResult.configurations.vixPort;
                var testSites = {};
                $.each(jsonResult.configurations.testClientSite, function (index, dataVal) {
                    testSites[dataVal.site] = dataVal.tiuLocationSearchText + "|" +
						dataVal.tiuTitleSearchText + "|" +
						dataVal.tiuStatus + "|" +
						dataVal.tiuAuthorDuz + "|" +
						dataVal.localAccessVerify;
                });
                $("#login-site-select").html("");
                var requestUrl = "http://" + vixHost + ":" + vixPort + "/VistaWebSvcs/restservices/siteservice/sites";
                console.log(requestUrl);

                $.ajax({
                    url: requestUrl,
                    method: 'GET',
                    async: false,
                    success: function (data) {
                        var transformedInnerHTML = data.documentElement.innerHTML;
                        transformedInnerHTML = transformedInnerHTML.replace(/<\/visn>/g, "");
                        transformedInnerHTML = transformedInnerHTML.replace(/<visn>/g, "");
                        transformedInnerHTML = transformedInnerHTML.replace(/<\/sites>/g, "");
                        transformedInnerHTML = transformedInnerHTML.replace(/<sites>/g, "");
                        transformedInnerHTML = transformedInnerHTML.replace(/<\/connections>/g, " --> ");
                        transformedInnerHTML = transformedInnerHTML.replace(/<connections>/g, " <!-- ");
                        var xmlDOM = new DOMParser().parseFromString("<sites>" + transformedInnerHTML + "</sites>", 'text/xml');
                        var jsonResult = xmlToJson(xmlDOM);

                        var sites = [];
                        var idx = 0;
                        if (!isNullOrUndefined(jsonResult.sites)) {
                            if (!isNullOrUndefined(jsonResult.sites.site)) {
                                $.each(jsonResult.sites.site, function (index, dataVal) {
                                    if (!isNullOrUndefined(dataVal.siteNumber) && (dataVal.siteNumber != "200")) {
                                        var testSiteConfig = testSites[dataVal.siteNumber];
                                        loadSiteConnection(vixHost, vixPort, dataVal.siteNumber, dataVal.siteName, testSiteConfig);
                                    }
                                });
                            }
                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        console.log("Exception while fetching the Sites");
                    }
                });
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception thrown while fetching testclient configuration, " + errorThrown);
        }
    });
}


function loadSiteConnection(vixHost, vixPort, siteNumber, siteName, testClientConfig) {
    var server = null;
    var requestUrl = "http://" + vixHost + ":" + vixPort + "/VistaWebSvcs/restservices/siteservice/sites/" + siteNumber;
    console.log(requestUrl);
    $.ajax({
        url: requestUrl,
        method: 'GET',
        async: false,
        success: function (data) {
            var transformedInnerHTML = data.documentElement.innerHTML;
            transformedInnerHTML = transformedInnerHTML.replace(/<\/site>/g, "");
            transformedInnerHTML = transformedInnerHTML.replace(/<site>/g, "");
            transformedInnerHTML = transformedInnerHTML.replace(/<\/connections>/g, "");
            transformedInnerHTML = transformedInnerHTML.replace(/<connections>/g, "");
            transformedInnerHTML = transformedInnerHTML.replace(/<\/siteAbbr>/g, " --> ");
            transformedInnerHTML = transformedInnerHTML.replace(/<siteAbbr>/g, " <!-- ");
            transformedInnerHTML = transformedInnerHTML.replace(/<\/siteName>/g, " --> ");
            transformedInnerHTML = transformedInnerHTML.replace(/<siteName>/g, " <!-- ");
            transformedInnerHTML = transformedInnerHTML.replace(/<\/siteNumber>/g, " --> ");
            transformedInnerHTML = transformedInnerHTML.replace(/<siteNumber>/g, " <!-- ");
            transformedInnerHTML = transformedInnerHTML.replace(/<\/sitePatientLookupable>/g, " --> ");
            transformedInnerHTML = transformedInnerHTML.replace(/<sitePatientLookupable>/g, " <!-- ");
            transformedInnerHTML = transformedInnerHTML.replace(/<\/siteUserAuthenticatable>/g, " --> ");
            transformedInnerHTML = transformedInnerHTML.replace(/<siteUserAuthenticatable>/g, " <!-- ");
            transformedInnerHTML = transformedInnerHTML.replace(/<\/visnNumber>/g, " --> ");
            transformedInnerHTML = transformedInnerHTML.replace(/<visnNumber>/g, " <!-- ");

            var xmlDOM = new DOMParser().parseFromString('<connections>' + transformedInnerHTML + '</connections>', 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);
            if (!isNullOrUndefined(jsonResult.connections)) {
                if (!isNullOrUndefined(jsonResult.connections.connection)) {
                    $.each(jsonResult.connections.connection, function (index, dataVal) {
                        if (dataVal.protocol == "VIX") {
                            server = dataVal.server;
                            var siteInfo = '<option value="' + siteNumber + '|' + dataVal.server + "|" + dataVal.port + "|" + testClientConfig + '">' + siteName + ' - ' + siteNumber + '</option>';
                            $("#login-site-select").append(siteInfo);
                            var siteServers = $("#siteServers").val() + siteInfo;
                            $("#siteServers").val(siteServers);
                        }
                    });
                }
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception while fetching the Sites");
        }
    });
}

function loadCred() {
    var authSearch = window.location.search;
    var cred = authSearch.split('&');
    var auth = cred[0];
    var servers = cred[1];
    var loginServer = cred[2];
    var loginToken = cred[3];

    var av = auth.split('=');
    $('#credToken').val(av[1]);

    var loginSecToken = loginToken.split('=');
    $('#loginSecToken').val(decodeURIComponent(loginSecToken[1]));

    var sites = servers.split('=');
    $('#siteServers').val(decodeURIComponent(sites[1]));

    var loginSiteServer = loginServer.split('=');
    $('#loginSiteServer').val(loginSiteServer[1]);

    var loginServer = $('#loginSiteServer').val().split("|");
    $('#site-select').html($('#siteServers').val());
    $('#site-select-for-indexes').html($('#siteServers').val());
    $('#site-select-for-notes').html($('#siteServers').val());

    if (!loginServer[0].startsWith("2001")) {
        $('#site-select').val(loginSiteServer).change();
        $('#site-select-for-indexes').val(loginSiteServer).change();
        $('#site-select-for-notes').val(loginSiteServer).change();
    }

    loadLocalSecToken();
}

function loadLocalSecToken() {
    var selectedVal = $('#site-select').val();

    var siteConfig = selectedVal.split("|");
    $('#locationStartWith').val(siteConfig[3]);
    $('#titleStartWith').val(siteConfig[4]);
    $('#tiuStatus').val(siteConfig[5]);
    $('#authorDuz').val(siteConfig[6]);
    if (!isNullOrUndefined(siteConfig[7]) || (siteConfig[7] == "")) {
        $('#localAV').val(btoa(siteConfig[7]));

        var authenticate_user_url = "http://" + siteConfig[1] + ":" + siteConfig[2] + "/ViewerStudyWebApp/restservices/study/user/token";
        console.log(authenticate_user_url);
        var crenString = $('#localAV').val();

        var headers = {
            "Authorization": "Basic " + crenString
        };

        $.ajax({
            url: authenticate_user_url,
            headers: headers,
            method: 'GET',
            async: false,
            success: function (data) {
                var val = data.documentElement.innerHTML;
                var localSecToken = val.split('</value>')[0].split('<value>')[1];
                $('#localSecToken').val(localSecToken);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert("Invalid user credentials." + authenticate_user_url)
            }
        });
    }
}

/**
 * This method is used to fetch all the study information based on requestUrl.The following informations are read from the user.
 */
function searchPatients() {
    //document.getElementById("upload-image-on-tiu-div").addEventListener("load", initUpload());

    console.log("function called");
    var searchText = $('#patient-search-text').val();

    if (searchText == null || searchText == "") {
        alert("searchText must not be null");
        $('#patient-search-text').focus();
    } else {
        $("#ajax_loader").show();
        loadLocalSecToken();

        var selectVal = $('#site-select').find(":selected").val();
        var host = selectVal.split("|");
        var siteNumber = host[0];
        var hostServer = host[1];
        var hostPort = host[2];

        //var authToken = $('#localSecToken').val();
        //var requestUrl = "http://" + hostServer + ":" + hostPort + "/PatientWebApp/token/restservices/patient/getPatientList?searchCriteria=" + searchText +
        //	"&securityToken=" + authToken;

        var loginServer = $('#loginSiteServer').val().split("|");
        var requestUrl = "http://" + loginServer[1] + ":" + loginServer[2] + "/PatientWebApp/token/restservices/patient/patientList/" + siteNumber +
			"?searchCriteria=" + searchText + "&securityToken=" + $('#loginSecToken').val();
        console.log(requestUrl);

        $.ajax({
            url: requestUrl,
            method: 'GET',
            async: false,
            success: function (data) {
                var transformedData = data.replace("<ArrayOfPatient>", "<ArrayOfPatient><Patient />");
                var xmlDOM = new DOMParser().parseFromString(transformedData, 'text/xml');
                var jsonResult = xmlToJson(xmlDOM);
                var studyInformation = "";
                if (!isNullOrUndefined(jsonResult.ArrayOfPatient)) {
                    if (!isNullOrUndefined(jsonResult.ArrayOfPatient.Patient) && jsonResult.ArrayOfPatient.Patient.length > 0) {
                        $.each(jsonResult.ArrayOfPatient.Patient, function (index, dataVal) {
                            if (!isNullOrUndefined(dataVal.PatientIcn)) {
                                studyInformation += '<tr><td class="wrap_words">' + dataVal.PatientName + '</td><td class="wrap_words">' + dataVal.PatientIcn + '</td><td class="wrap_words">' + dataVal.Dfn +
                                    '</td><td>' + dataVal.Ssn + '</td><td>' + formatDate(dataVal.Dob) + '</td><td class="wrap_words">' + dataVal.Sensitive + '</td><td>' + dataVal.VeteranStatus +
                                    '</td><td>' +
                                    '<input type="hidden" class="patient-hidden" value="' + dataVal.PatientName + '|' + dataVal.PatientIcn + '|' + dataVal.Dfn + '|' + dataVal.Ssn + '|' + dataVal.Dob + '|' + dataVal.Sensitive + '|' + dataVal.VeteranStatus + '|' + dataVal.PatientSex + '">' +
                                    '<a class="btn btn-success btn-sm" onClick="viewPatient(\'' + dataVal.PatientIcn + '\', ' + index + ', ' + 'this)">Select Patient</a>&nbsp;' +
                                    '<a class="btn btn-primary btn-sm"  onClick="uploadImage(\'' + dataVal.PatientIcn + '\', ' + index + ', ' + 'this)">Upload Image</a>&nbsp;' +
                                    '<a class="btn btn-warning btn-sm"  onClick="fetchIndexTermsDetails(\'' + dataVal.PatientIcn + '\', \'Index_Term\' , ' + index + ', ' + 'this)">Index Term</a>&nbsp;' +
                                    '</td></tr>';
                            }
                        });
                    }
                }
                $('#sudyInformation').hide();
                // $('#patientInfoTable').DataTable().destroy();
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
                $('#sudyInformation').show();
            },
            error: function (xhr, status) {
                $("#ajax_loader").hide();
                alert("Connection problem with Server");
            }
        });
    }
}

function viewPatient(patientICN, rindex, ele) {

    $("#view-patient-details").show();
    $("#upload-patient-image").hide();
    $("#sudyInformation").hide();

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

    //Getting the patient image
    var selectVal = $('#site-select').find(":selected").val();
    var host = selectVal.split("|");
    var siteNumber = host[0];
    var hostServer = host[1];
    var hostPort = host[2];

    var loginServer = $('#loginSiteServer').val().split("|");

    var requestUrl = "http://" + loginServer[1] + ":" + loginServer[2] + "/ImageWebApp/token/photo/remote/" + siteNumber + "/" + patientICN +
		"?securityToken=" + $('#loginSecToken').val();

    console.log(requestUrl);

    $.ajax({
        url: requestUrl,
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

    //Getting the patient consult for the patient
    requestUrl = "http://" + loginServer[1] + ":" + loginServer[2] + "/ConsultWebApp/token/restservices/consult/consults/" + siteNumber + "/" + patientICN +
			"?securityToken=" + $('#loginSecToken').val();
    console.log(requestUrl);

    $.ajax({
        url: requestUrl,
        method: 'GET',
        async: true,
        success: function (data) {
            console.log("Consult fetch successfully");
            var consults = data.documentElement.innerHTML + "<consult />";
            var xmlDOM = new DOMParser().parseFromString("<consults>" + consults + "</consults>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var consultInformation = "";
            if (!isNullOrUndefined(jsonResult.consults)) {
                if (!isNullOrUndefined(jsonResult.consults.consult)) {
                    $.each(jsonResult.consults.consult, function (index, dataVal) {
                        if (!isNullOrUndefined(dataVal.consultUrn)) {
                            consultInformation += '<tr><td class="wrap_words">' + dataVal.service +
								'</td><td class="wrap_words">' + dataVal.consultUrn +
								'</td><td class="wrap_words">' + dataVal.numberNotes +
								'</td><td>' + ((typeof dataVal.procedure == "object") ? "-" : dataVal.procedure) +
								'</td><td class="wrap_words">' + dataVal.status + '</td>' +
								'</tr>';
                        }
                    });
                }
                else {
                    $(".consult-err-msg").show();
                    $(".consult-div").hide();
                    return;
                }
            }
            else {
                $(".consult-err-msg").show();
                $(".consult-div").hide();
                return;
            }

            $(".consult-err-msg").hide();
            $('.consult-div').hide();
            if ($.fn.DataTable.isDataTable("#consult-table")) {
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
    loadTIUNotes(siteNumber, patientICN);

}

function loadTIUNotes(siteNumber, patientICN) {
    var loginServer = $('#loginSiteServer').val().split("|");
    var tiuStatus = $('#tiuStatus').val();
    var authorDuz = $('#authorDuz').val();
    var authToken = $('#loginSecToken').val();

    requestUrl = "http://" + loginServer[1] + ":" + loginServer[2] + "/TIUWebApp/token/restservices/tiu/patient/notes/" + siteNumber + "/" + patientICN + "/" + tiuStatus + "/30/true?authorDuz=" + authorDuz + "&securityToken=" + authToken;
    console.log(requestUrl);

    $.ajax({
        url: requestUrl,
        method: 'GET',
        async: true,
        success: function (data) {
            console.log("TIU Notes fetch successfully");
            var notes = data.documentElement.innerHTML + "<note />";
            var xmlDOM = new DOMParser().parseFromString("<notes>" + notes + "</notes>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var tiuInformation = "";
            if (!isNullOrUndefined(jsonResult.notes)) {
                if (!isNullOrUndefined(jsonResult.notes.note)) {
                    $.each(jsonResult.notes.note, function (index, dataVal) {
                        if (!isNullOrUndefined(dataVal.title)) {
                            tiuInformation += '<tr><td class="wrap_words">' + dataVal.title + '</td><td class="wrap_words">' + dataVal.authorName + '</td><td class="wrap_words">' + formatDate(dataVal.date) +
								'</td><td>' + dataVal.hospitalLocation + '</td><td>' + dataVal.numberAssociatedImages + '</td><td class="wrap_words">' + dataVal.patientTIUNoteUrn + '</td><td>' + dataVal.signatureStatus +
								'</td><td>' +
								'<input type="hidden" class="patient-hidden" value="' + dataVal.patientTIUNoteUrn + '|' + dataVal.title + '|' + dataVal.authorName + '|' + dataVal.date + '|' + dataVal.hospitalLocation + '|' + dataVal.numberAssociatedImages + '|' + dataVal.signatureStatus + '">' +
								'<a class="btn btn-primary btn-sm" data-toggle="modal" data-target="#upload-image-tiunote-div" onclick="setHiddenFieldsForNoteImageUpload(this,\'' + dataVal.patientTIUNoteUrn + '\')">Upload Image</a>&nbsp;' +
								'</td></tr>';
                        }
                    });
                }
                else {
                    $(".tiu-notes-err-msg").show();
                    $(".tiu-notes-div").hide();
                    return;
                }
            }
            else {
                $(".tiu-notes-err-msg").show();
                $(".tiu-notes-div").hide();
                return;
            }

            $(".tiu-notes-err-msg").hide();
            $('.tiu-notes-div').hide();
            if ($.fn.DataTable.isDataTable("#tiu-notes-table")) {
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

function uploadImageForTIU(patientTiuNoteUrn, index) {

}

function uploadImage(patientICN, rindex, ele) {
    $("#upload-patient-image").show();
    $("#view-patient-details").hide();
    $("#sudyInformation").hide();
    $(".image-upload-form").find("#patientId").val(patientICN);

    //Getting the capture image configuration
    $(".captureImageConfiguration-dropdown").html("");
    var captureImageConfiguration_url = "CaptureImageConfiguration.config";

    $.ajax({
        url: captureImageConfiguration_url,
        method: 'GET',
        dataType: 'xml',
        success: function (data) {
            var transformedInnerHTML = data.documentElement.innerHTML;
            transformedInnerHTML = transformedInnerHTML.replace("</configurations>", "");
            transformedInnerHTML = transformedInnerHTML.replace("<configurations>", "");
            transformedInnerHTML = transformedInnerHTML.replace("<dirty>false</dirty>", "");
            transformedInnerHTML = transformedInnerHTML.replace("<dirty>true</dirty>", "");
            transformedInnerHTML = transformedInnerHTML.replace("<sslPort>443</sslPort>", "");

            var xmlDOM = new DOMParser().parseFromString("<configurations>" + transformedInnerHTML + "</configurations>", "text/xml");
            var jsonResult = xmlToJson(xmlDOM);

            var configurationInformation = "";
            if (!isNullOrUndefined(jsonResult.configurations)) {
                if (!isNullOrUndefined(jsonResult.configurations["gov.va.med.imaging.capture.CaptureConfiguration"])) {
                    $.each(jsonResult.configurations["gov.va.med.imaging.capture.CaptureConfiguration"], function (index, dataVal) {
                        if (!isNullOrUndefined(dataVal.name)) {
                            var configurationVal = "";
                            if (!isNullOrUndefined(dataVal.group)) {
                                configurationVal += dataVal.group;
                            } else {
                                configurationVal += "false";
                            }
                            if (!isNullOrUndefined(dataVal.typeIndex)) {
                                configurationVal += "|" + dataVal.typeIndex.value;
                            } else {
                                configurationVal += "|";
                            }
                            if (!isNullOrUndefined(dataVal.specialtyIndex)) {
                                configurationVal += "|" + dataVal.specialtyIndex.value;
                            } else {
                                configurationVal += "|";
                            }
                            if (!isNullOrUndefined(dataVal.procedureEventIndex)) {
                                configurationVal += "|" + dataVal.procedureEventIndex.value;
                            } else {
                                configurationVal += "|";
                            }
                            if (!isNullOrUndefined(dataVal.shortDescription)) {
                                configurationVal += "|" + dataVal.shortDescription.value;
                            } else {
                                configurationVal += "|";
                            }
                            if (!isNullOrUndefined(dataVal.procedure)) {
                                configurationVal += "|" + dataVal.procedure.value;
                            } else {
                                configurationVal += "|";
                            }
                            if (!isNullOrUndefined(dataVal.originIndex)) {
                                configurationVal += "|" + dataVal.originIndex.value;
                            } else {
                                configurationVal += "|";
                            }
                            if (!isNullOrUndefined(dataVal.createNote)) {
                                if (!isNullOrUndefined(dataVal.createNote.noteText)) {
                                    configurationVal += "|" + dataVal.createNote.noteText.value;
                                } else {
                                    configurationVal += "|";
                                }
                                if (!isNullOrUndefined(dataVal.createNote.tiuNoteUrn)) {
                                    configurationVal += "|urn:tiu:" + dataVal.createNote.tiuNoteUrn.originatingSiteId + "-" + dataVal.createNote.tiuNoteUrn.itemId;
                                } else {
                                    configurationVal += "|";
                                }
                                if (!isNullOrUndefined(dataVal.createNote.locationUrn)) {
                                    configurationVal += "|urn:tiu:" + dataVal.createNote.locationUrn.originatingSiteId + "-" + dataVal.createNote.locationUrn.itemId;
                                } else {
                                    configurationVal += "|";
                                }
                            } else {
                                configurationVal += "|||";
                            }
                            configurationInformation += '<option value="' + configurationVal + '">' + dataVal.name + '</option>';
                        }
                    });
                }
            }
            if (configurationInformation) {
                $(".captureImageConfiguration-dropdown").html(configurationInformation);
                $(".captureImageConfiguration-dropdown").trigger("change");
            } else {
                $(".captureImageConfiguration-dropdown").html("");
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception thrown while fetching the capture image configuration, " + errorThrown);
        }

    });
}


function backToHomePage() {
    $("#view-patient-details").hide();
    $("#upload-patient-image").hide();
    $("#index-term-outer-div").hide();
    $("#sudyInformation").show();
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
    //if (xml.hasChildNodes() && xml.childNodes.length === 1 && xml.childNodes[0].nodeType === 3) {
    if (xml.hasChildNodes() && xml.childNodes.length === 1 && xml.childNodes[0].nodeType === 3 && !obj["@attributes"]) {
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
    $("#currentPatientId").val(patientICN);
    $("#firstImage").val("true");
    $("#studyUrn").val("");

    //Showing the UI section and hiding other sections
    $("#index-term-outer-div").show();
    $("#upload-patient-image").hide();
    $("#view-patient-details").hide();
    $("#sudyInformation").hide();

    var loginServer = $('#loginSiteServer').val().split("|");

    var selectVal = $('#site-select-for-indexes').find(":selected").val();
    var host = selectVal.split("|");
    var hostServer = host[1];
    var hostPort = host[2];

    $(".image-upload-form-for-indexes").attr("action", 'http://' + hostServer + ':' + hostPort + '/IngestWebApp/token/ingest');

    //Changing the target section heading
    if (targetSection == 'Photo_Id') {
        $("#index-term-outer-div").find('.target-section').text('Photo Id');
    }
    else if (targetSection == 'Index_Term') {
        $("#index-term-outer-div").find('.target-section').text('Intex Term');
    }
    else {
        $("#index-term-outer-div").find('.target-section').text('TIU Note');
    }

    $(".image-upload-form-for-indexes").find("#patientId").val(patientICN);
    $(".image-upload-form-for-indexes").find(".img-desc").val("ADVANCE DIRECTIVE");
    $(".image-upload-form-for-indexes").find(".proc-dropdown").html("");

    var selectVal = $('#site-select-for-indexes').find(":selected").val();
    var siteNumber = selectVal.split("|")[0].trim();

    //Getting the origins for the site
    var loginServer = $('#loginSiteServer').val().split("|");
    var requestUrl = "http://" + loginServer[1] + ":" + loginServer[2] + "/IndexTermWebApp/token/restservices/indexTerms/origins/" + siteNumber +
		"?securityToken=" + $('#loginSecToken').val();
    console.log(requestUrl);
    $(".origin-dropdown").html("");

    $.ajax({
        url: requestUrl,
        method: 'GET',
        success: function (data) {
            var indexTerms = data.documentElement.innerHTML + "<indexTerm />";
            var xmlDOM = new DOMParser().parseFromString("<indexTermValuesType>" + indexTerms + "</indexTermValuesType>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var originInformation = "";
            if (!isNullOrUndefined(jsonResult.indexTermValuesType)) {
                if (!isNullOrUndefined(jsonResult.indexTermValuesType.indexTerm)) {
                    $.each(jsonResult.indexTermValuesType.indexTerm, function (index, dataVal) {
                        if (!isNullOrUndefined(dataVal.name)) {
                            originInformation += '<option value="' + dataVal.name + '">' + dataVal.name + '</option>';
                        }
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
    requestUrl = "http://" + loginServer[1] + ":" + loginServer[2] + "/IndexTermWebApp/token/restservices/indexTerms/types/" + siteNumber +
		"?securityToken=" + $('#loginSecToken').val();
    console.log(requestUrl);
    $(".doc-type-dropdown").html("");
    $.ajax({
        url: requestUrl,
        method: 'GET',
        success: function (data) {
            var indexTerms = data.documentElement.innerHTML + "<indexTerm />";
            var xmlDOM = new DOMParser().parseFromString("<indexTermValuesType>" + indexTerms + "</indexTermValuesType>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var typesInformation = "";
            if (!isNullOrUndefined(jsonResult.indexTermValuesType)) {
                if (!isNullOrUndefined(jsonResult.indexTermValuesType.indexTerm)) {
                    $.each(jsonResult.indexTermValuesType.indexTerm, function (index, dataVal) {
                        if (!isNullOrUndefined(dataVal.name)) {
                            typesInformation += '<option value="' + dataVal.name + '">' + dataVal.name + '</option>';
                        }
                    });
                }
            }
            if (typesInformation) {
                $(".doc-type-dropdown").html(typesInformation);
            } else {
                $(".doc-type-dropdown").html("");
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception thrown while fetching the origins, " + errorThrown);
        }

    });

    //Getting the specialty for the site
    requestUrl = "http://" + loginServer[1] + ":" + loginServer[2] + "/IndexTermWebApp/token/restservices/indexTerms/specialties/" + siteNumber +
			"?securityToken=" + $('#loginSecToken').val();
    console.log(requestUrl);
    $(".specialty-dropdown").html("");
    $.ajax({
        url: requestUrl,
        method: 'GET',
        success: function (data) {
            var indexTerms = data.documentElement.innerHTML + "<indexTerm />";
            var xmlDOM = new DOMParser().parseFromString("<indexTermValuesType>" + indexTerms + "</indexTermValuesType>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var specialtyInfo = "";
            if (!isNullOrUndefined(jsonResult.indexTermValuesType)) {
                if (!isNullOrUndefined(jsonResult.indexTermValuesType.indexTerm)) {
                    $.each(jsonResult.indexTermValuesType.indexTerm, function (index, dataVal) {
                        if (!isNullOrUndefined(dataVal.name)) {
                            specialtyInfo += '<option value="' + dataVal.indexTermUrn + '">' + dataVal.name + '</option>';
                        }
                    });
                }
            }
            if (specialtyInfo) {
                $(".specialty-dropdown").html(specialtyInfo);
                $(".specialty-dropdown").trigger("change");
            } else {
                $(".specialty-dropdown").html("");
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception thrown while fetching the origins, " + errorThrown);
        }

    });

    fetchLocationsforSite(".index-term-location-dropdown", siteNumber);
    fetchTiuTitlesforSite(".index-term-tiu-title-dropdown", siteNumber);
    fetchConsultforSite(".index-term-consult-dropdown", siteNumber);
}

$(document).ready(function () {

    //Uploading photo id image
    $('.image-upload-form').submit(function (e) {
        e.preventDefault();

        //input Validations
        if ($('.image-upload-form').find(".patient-image-file").val() == '') {
            alert("Please select the file to upload.");
            return false;
        }

        var dataObj = new FormData(this)
        var authToken = "";
        var loginServer = $('#loginSiteServer').val().split("|");
        var selectVal = $('#site-select').find(":selected").val();
        var host = selectVal.split("|");
        var hostServer = host[1];
        var hostPort = host[2];

        var upload_image_url = 'http://' + hostServer + ':' + hostPort + '/IngestWebApp/token/ingest?securityToken=' + $('#localSecToken').val();

        $("#ajax_loader").show();
        $.ajax({
            method: 'POST',
            url: upload_image_url,
            data: dataObj,
            cache: false,
            processData: false,  // tell jQuery not to process the data
            contentType: false,  // tell jQuery not to set contentType
            enctype: 'multipart/form-data',
            success: function (data) {
                $("#ajax_loader").hide();
                alert("Image uploaded successfully");
            },
            error: function (jqXHR, textStatus, errorThrown) {
                $("#ajax_loader").hide();
                alert("Exception while uploading the image: ");
            }
        });
        return false;
    });

    //Uploading photo id image
    $('.image-upload-form-for-indexes').submit(function (e) {
        e.preventDefault();

        //input Validations
        if ($('.image-upload-form-for-indexes').find("#patient-image-file").val() == "") {
            alert("Please select the image to upload.");
            return false;
        }

        if ($('.image-upload-form-for-indexes').find("textarea[name='shortDescription']").val() == "") {
            alert("Please enter image description.");
            return false;
        }

        var groupImage = $('#Group-Image-for-indexes').prop('checked');
        var firstImage = $("#firstImage").val();


        if (firstImage == "true") {
            $('#createGroup').val(groupImage);
        } else {
            $('#createGroup').val("false");
        }

        $(".image-upload-form-for-indexes").find(".createGroup").val($('#createGroup').val());

        var groupUrn = $('#studyUrn').val();
        if (!isNullOrUndefined(groupUrn) && (groupUrn != "")) {
            groupUrnArray = groupUrn.split("-");
            var studyUrn = groupUrnArray[0].replace("vaimage", "vastudy") + "-" +
				groupUrnArray[2] + "-" +
				groupUrnArray[3];
            $(".image-upload-form-for-indexes").find(".studyUrn").val(studyUrn);
        }

        var dataObj = new FormData(this)
        $("#ajax_loader").show();

        var loginServer = $('#loginSiteServer').val().split("|");
        var selectVal = $('#site-select-for-indexes').find(":selected").val();
        var host = selectVal.split("|");
        var hostServer = host[1];
        var hostPort = host[2];
        var authToken = $('#localAV').val();

        var upload_image_url = 'http://' + hostServer + ':' + hostPort + '/IngestWebApp/token/ingest?securityToken=' + $("#localSecToken").val();

        $.ajax({
            method: 'POST',
            url: upload_image_url,
            data: dataObj,
            cache: false,
            processData: false,  // tell jQuery not to process the data
            contentType: false,  // tell jQuery not to set contentType
            enctype: 'multipart/form-data',
            success: function (data) {
                $("#ajax_loader").hide();
                alert("Index term added successfully.");
                $("#firstImage").val("false");
                $("#studyUrn").val(data);

                $(".image-upload-form-for-indexes").find(".tiuNoteLocationUrn").val("");
                $(".image-upload-form-for-indexes").find(".tiuNoteTitleUrn").val("");
                $(".image-upload-form-for-indexes").find(".consultUrn").val("");

                var groupImage = $('#Group-Image-for-indexes').prop('checked');
                if (!groupImage) {
                    $(".btn-back-from-indexes").click();
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                $("#ajax_loader").hide();
                alert("Exception while uploading the image: ");
            }
        });
        return false;
    });

    $("#site-select-for-indexes").change(function () {
        fetchIndexTermsDetails($("#currentPatientId").val(), 'Index_Term');
        $(".proc-dropdown").html("");
    });

    $(".doc-type-dropdown").change(function () {
        var selectedType = $(this).find(":selected").val();
        $(".img-desc").val(selectedType);
    });

    $(".specialty-dropdown").change(function () {
        var selectVal = $('#site-select-for-indexes').find(":selected").val();
        var siteNumber = selectVal.split("|")[0].trim();

        //Setting the specialty hidden field
        $(".image-upload-form-for-indexes").find("input[name = 'specialtyIndex']").val($(this).find(":selected").text());
        $(".proc-dropdown").html("");

        //Getting the types for the site
        var selectedSpecialty = $(this).find(":selected").val();
        var loginServer = $('#loginSiteServer').val().split("|");

        var requestUrl = "http://" + loginServer[1] + ":" + loginServer[2] + "/IndexTermWebApp/token/restservices/indexTerms/procedureevents/" + siteNumber +
			"/" + selectedSpecialty + "?securityToken=" + $('#loginSecToken').val();
        console.log(requestUrl);

        $.ajax({
            url: requestUrl,
            method: 'GET',
            success: function (data) {
                var indexTerms = data.documentElement.innerHTML + "<indexTerm />";
                var xmlDOM = new DOMParser().parseFromString("<indexTermValuesType>" + indexTerms + "</indexTermValuesType>", 'text/xml');
                var jsonResult = xmlToJson(xmlDOM);

                var procInformation = "";
                if (!isNullOrUndefined(jsonResult.indexTermValuesType)) {
                    if (!isNullOrUndefined(jsonResult.indexTermValuesType.indexTerm)) {
                        $.each(jsonResult.indexTermValuesType.indexTerm, function (index, dataVal) {
                            if (!isNullOrUndefined(dataVal.name)) {
                                procInformation += '<option value="' + dataVal.name + '">' + dataVal.name + '</option>';
                            }
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

    $(".index-term-location-dropdown").change(function () {
        var selectedLocation = $(this).find(":selected").val();
        $(".image-upload-form-for-indexes").find(".tiuNoteLocationUrn").val(selectedLocation);
    });

    $(".index-term-tiu-title-dropdown").change(function () {
        var selectedTitle = $(this).find(":selected").val();
        $(".image-upload-form-for-indexes").find(".tiuNoteTitleUrn").val(selectedTitle);
    });

    $(".index-term-consult-dropdown").change(function () {
        var selectedConsult = $(this).find(":selected").val();
        var consultId = selectedConsult.split("-")[1];
        if (!isNullOrUndefined(consultId)) {
            consultId = "Consult# " + consultId;
        }
        $(".image-upload-form-for-indexes").find(".consultUrn").val(consultId);
    });

    $(".captureImageConfiguration-dropdown").change(function () {
        var selectVal = $(this).find(":selected").val();
        var info = selectVal.split("|");
        if (info.length > 9) {
            $(".image-upload-form").find("#createGroup").val(info[0]);
            $(".image-upload-form").find("#typeIndex").val(info[1]);
            $(".image-upload-form").find("#specialtyIndex").val(info[2]);
            $(".image-upload-form").find("#procedureEventIndex").val(info[3]);
            $(".image-upload-form").find("#shortDescription").val(info[4]);
            $(".image-upload-form").find("#procedure").val(info[5]);
            $(".image-upload-form").find("#originIndex").val(info[6]);
            $(".image-upload-form").find("#tiuNoteText").val(info[7]);
            $(".image-upload-form").find("#tiuNoteTitleUrn").val(info[8]);
            $(".image-upload-form").find("#tiuNoteLocationUrn").val(info[9]);
        }
    });


});
/** Index term related scripts : END */

/** Tiu notes related script: START */

function fetchLocationsforSite(dropdown, siteNumber) {
    var loginServer = $('#loginSiteServer').val().split("|");
    var searchText = $('#locationStartWith').val();

    var requestUrl = "http://" + loginServer[1] + ":" + loginServer[2] + "/TIUWebApp/token/restservices/tiu/locations/" + siteNumber +
		"?searchText=" + searchText + "&securityToken=" + $('#loginSecToken').val();

    console.log(requestUrl);

    $.ajax({
        url: requestUrl,
        method: 'GET',
        success: function (data) {
            var locations = data.documentElement.innerHTML + "<location />";
            var xmlDOM = new DOMParser().parseFromString("<locations>" + locations + "</locations>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var locationInfo = '<option value=""></option>';
            if (!isNullOrUndefined(jsonResult.locations)) {
                if (!isNullOrUndefined(jsonResult.locations.location)) {
                    $.each(jsonResult.locations.location, function (index, dataVal) {
                        if (!isNullOrUndefined(dataVal.tiuNoteLocationUrn)) {
                            locationInfo += '<option value="' + dataVal.tiuNoteLocationUrn + '">' + dataVal.name + '</option>';
                        }
                    });
                }
            }
            if (locationInfo) {
                $(dropdown).html(locationInfo);
                $(dropdown).trigger("change");
            } else {
                $(dropdown).html("");
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception while fetching the location");
        }
    });
}


function fetchTiuTitlesforSite(dropdown, siteNumber) {
    var loginServer = $('#loginSiteServer').val().split("|");
    var searchText = $('#titleStartWith').val();

    var requestUrl = "http://" + loginServer[1] + ":" + loginServer[2] + "/TIUWebApp/token/restservices/tiu/notes/titles/" + siteNumber + "?searchText=" + searchText +
			"&securityToken=" + $('#loginSecToken').val();
    console.log(requestUrl);

    $(dropdown).html("");
    $.ajax({
        url: requestUrl,
        method: 'GET',
        success: function (data) {
            var notes = data.documentElement.innerHTML + "<note />";
            var xmlDOM = new DOMParser().parseFromString("<notes>" + notes + "</notes>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);
            var titleInfo = '<option value=""></option>';

            if (!isNullOrUndefined(jsonResult.notes)) {
                if (!isNullOrUndefined(jsonResult.notes.note)) {
                    $.each(jsonResult.notes.note, function (index, dataVal) {
                        if (!isNullOrUndefined(dataVal.tiuNoteTitleUrn)) {
                            titleInfo += '<option value="' + dataVal.tiuNoteTitleUrn + '">' + dataVal.title + '</option>';
                        }
                    });
                }
            }
            if (titleInfo) {
                $(dropdown).html(titleInfo);
            } else {
                $(dropdown).html("");
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception while fetching the note titles");
            return;
        }
    });

    var requestUrl = "http://" + loginServer[1] + ":" + loginServer[2] + "/TIUWebApp/token/restservices/tiu/notes/titles/" + siteNumber + "?searchText=CONSULT" +
			"&securityToken=" + $('#loginSecToken').val();
    console.log(requestUrl);
    $.ajax({
        url: requestUrl,
        method: 'GET',
        success: function (data) {
            var notes = data.documentElement.innerHTML + "<note />";
            var xmlDOM = new DOMParser().parseFromString("<notes>" + notes + "</notes>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);
            var titleInfo = '';

            if (!isNullOrUndefined(jsonResult.notes)) {
                if (!isNullOrUndefined(jsonResult.notes.note)) {
                    $.each(jsonResult.notes.note, function (index, dataVal) {
                        if (!isNullOrUndefined(dataVal.tiuNoteTitleUrn)) {
                            titleInfo += '<option value="' + dataVal.tiuNoteTitleUrn + '">' + dataVal.title + '</option>';
                        }
                    });
                }
            }
            if (titleInfo) {
                $(dropdown).append(titleInfo);
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception while fetching the note titles");
            return;
        }
    });
    $(dropdown).trigger("change");
}

function fetchConsultforSite(dropdown, siteNumber) {
    //Getting the patient consult for the patient
    var loginServer = $('#loginSiteServer').val().split("|");
    requestUrl = "http://" + loginServer[1] + ":" + loginServer[2] + "/ConsultWebApp/token/restservices/consult/consults/" + siteNumber + "/" +
		$("#currentPatientId").val() + "?securityToken=" + $('#loginSecToken').val();
    console.log(requestUrl);

    $.ajax({
        url: requestUrl,
        method: 'GET',
        success: function (data) {
            var consults = data.documentElement.innerHTML + "<consult />";
            var xmlDOM = new DOMParser().parseFromString("<consults>" + consults + "</consults>", 'text/xml');
            var jsonResult = xmlToJson(xmlDOM);

            var consultInformation = '<option value=""></option>';
            if (!isNullOrUndefined(jsonResult.consults)) {
                if (!isNullOrUndefined(jsonResult.consults.consult)) {
                    $.each(jsonResult.consults.consult, function (index, dataVal) {
                        if (!isNullOrUndefined(dataVal.consultUrn)) {
                            consultInformation += '<option value="' + dataVal.consultUrn + '">' + dataVal.consultUrn + " [" + dataVal.service + '] </option>';
                        }
                    });
                }
            }
            if (consultInformation) {
                $(dropdown).html(consultInformation);
                $(dropdown).trigger("change");
            } else {
                $(dropdown).html("");
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log("Exception while fetching Consult");
        }
    });
}

$(document).ready(function () {

    $('#create-tiunote-div').on('shown.bs.modal', function (e) {
        var selectVal = $('.create-tiu-note-form .site-select-for-notes').find(":selected").val();
        var siteNumber = selectVal.split("|")[0].trim();
        fetchLocationsforSite(".location-dropdown", siteNumber);
        fetchTiuTitlesforSite(".tiu-title-dropdown", siteNumber);
        fetchConsultforSite(".consult-dropdown", siteNumber);

        var d = new Date();
        var month = d.getMonth() + 1;
        var day = d.getDate();

        var formattedDate = d.getFullYear() + "-" +
			('0' + month).slice(-2) + "-" +
			('0' + day).slice(-2) + " " +
			('0' + d.getHours()).slice(-2) + ":" +
			('0' + d.getMinutes()).slice(-2) + ":00";

        $('.create-tiu-note-form').find('.date').val(formattedDate);
        $('.create-tiu-note-form .patientId').val($("#currentPatientId").val())
        $(".create-tiu-note-form").find("#consultUrn").val("");
    });

    $(".site-select-for-notes").change(function () {
        var selectVal = $('.create-tiu-note-form .site-select-for-notes').find(":selected").val();
        var siteNumber = selectVal.split("|")[0].trim();
        fetchLocationsforSite(".location-dropdown", siteNumber);
        fetchTiuTitlesforSite(".tiu-title-dropdown", siteNumber);
        fetchConsultforSite(".consult-dropdown", siteNumber);
    });

    $(".location-dropdown").change(function () {
        var selectedLocation = $(this).find(":selected").val();
        $(".create-tiu-note-form").find(".tiuNoteLocationUrn").val(selectedLocation);
    });

    $(".tiu-title-dropdown").change(function () {
        var selectedTitle = $(this).find(":selected").val();
        $(".create-tiu-note-form").find(".tiuNoteTitleUrn").val(selectedTitle);
    });

    $(".consult-dropdown").change(function () {
        var selectedConsult = $(this).find(":selected").val();
        var consultId = selectedConsult.split("-")[1];
        $(".create-tiu-note-form").find(".consultUrn").val(consultId);
    });

    $('.create-tiu-note-form').submit(function (e) {
        e.preventDefault();

        var selectVal = $('.create-tiu-note-form .site-select-for-notes').find(":selected").val();
        var siteNumber = selectVal.split("|")[0].trim();

        var tiuDate = $(".create-tiu-note-form").find(".date").val();
        var patientId = $(".create-tiu-note-form").find(".patientId").val();
        var locationId = $(".create-tiu-note-form .location-dropdown").find(":selected").val();
        var title = $(".create-tiu-note-form .tiu-title-dropdown").find(":selected").val();
        var consultUrn = $(".create-tiu-note-form .consult-dropdown").find(":selected").val();
        var noteText = $(".create-tiu-note-form").find("textarea[name='noteText']").val();

        var noteInput = "<noteInput>" +
			"<tiuNoteTitleUrn>" + title + "</tiuNoteTitleUrn>" +
			"<patientId>" + patientId + "</patientId>" +
			"<tiuNoteLocationUrn>" + locationId + "</tiuNoteLocationUrn>" +
			"<date>" + tiuDate + "</date>" +
			"<noteText>" + noteText + "</noteText>" +
			"<consultUrn>" + consultUrn + "</consultUrn>" +
			"</noteInput>";

        //$("#ajax_loader").show();
        var loginServer = $('#loginSiteServer').val().split("|");
        var selectVal = $('#site-select-for-notes').find(":selected").val();
        var host = selectVal.split("|");
        var hostServer = host[1];
        var hostPort = host[2];

        var create_tiu_note_url = 'http://' + hostServer + ':' + hostPort + '/TIUWebApp/token/restservices/tiu/note' +
			"?securityToken=" + $('#localSecToken').val();

        console.log(create_tiu_note_url);

        $.ajax({
            method: 'POST',
            url: create_tiu_note_url,
            dataType: "xml",
            contentType: "application/xml",
            data: noteInput,
            success: function (data) {
                //$("#ajax_loader").hide();
                alert("TIU note added successfully.");
                loadTIUNotes(siteNumber, patientId);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                //$("#ajax_loader").hide();
                alert("Exception while creating the tiu note. " + errorThrown);
            }
        });
        //return false;
    });

    $('.image-upload-for-note-form').submit(function (e) {
        e.preventDefault();
        var selectVal = $('#site-select-for-notes').find(":selected").val();
        var siteNumber = selectVal.split("|")[0].trim();

        var groupImage = $('#Group-Image').prop('checked');
        var firstImage = $("#firstImage").val();

        if (firstImage == "true") {
            $('#createGroup').val(groupImage);
        } else {
            $('#createGroup').val("false");
        }

        $(".image-upload-for-note-form").find(".createGroup").val($('#createGroup').val());

        var groupUrn = $('#studyUrn').val();
        if (!isNullOrUndefined(groupUrn) && (groupUrn != "")) {
            groupUrnArray = groupUrn.split("-");
            var studyUrn = groupUrnArray[0].replace("vaimage", "vastudy") + "-" +
				groupUrnArray[2] + "-" +
				groupUrnArray[3];
            $(".image-upload-for-note-form").find(".studyUrn").val(studyUrn);
        }

        var dataObj = new FormData(this)
        $("#ajax_loader").show();

        var loginServer = $('#loginSiteServer').val().split("|");
        var selectVal = $('#site-select').find(":selected").val();
        var host = selectVal.split("|");
        var hostServer = host[1];
        var hostPort = host[2];

        var upload_image_url = 'http://' + hostServer + ':' + hostPort + '/IngestWebApp/token/ingest?securityToken=' + $('#localSecToken').val();;
        console.log(upload_image_url);

        $.ajax({
            method: 'POST',
            url: upload_image_url,
            data: dataObj,
            cache: false,
            processData: false,  // tell jQuery not to process the data
            contentType: false,  // tell jQuery not to set contentType
            enctype: 'multipart/form-data',
            success: function (data) {
                $("#ajax_loader").hide();
                alert("Image uploaded successfully.");
                $("#firstImage").val("false");
                $("#studyUrn").val(data);
                var groupImage = $('#Group-Image').prop('checked');
                if (!groupImage) {
                    $(".close").click();
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                $("#ajax_loader").hide();
                alert("Exception while uploading the image: ");
            }
        });
    });
});

function setHiddenFieldsForNoteImageUpload(evt, patientNoteId) {
    $(".image-upload-for-note-form").find(".patientIdForNote").val($("#currentPatientId").val());
    $(".image-upload-for-note-form").find(".patientTiuNoteUrn").val(patientNoteId);
    $(".image-upload-for-note-form").find(".createGroup").val("false");
    $(".image-upload-for-note-form").find(".studyUrn").val("");

    $("#firstImage").val("true");
    $("#studyUrn").val("");
}

/** Tiu notes related script: END */