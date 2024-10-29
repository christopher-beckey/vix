/**
 * 
 * update the image delete reasons
 */
function updateImageDeleteReasons() {
    try {
        $("#reasonForDelete").empty();

        $.ajax({
                url: dicomViewer.Metadata.ReasonsUrl(),
                cache: false,
                async: true
            })
            .done(function (data) {
                if (data == undefined || data == null) {
                    return;
                }

                var reasons = "";
                data.forEach(function (reason) {
                    reasons += "<option value='" + reason + "'>" + reason + "</option>";
                });

                $("#reasonForDelete").html(reasons);
            })
            .fail(function (data) {})
            .error(function (xhr, status) {});
    } catch (e) {}
}

/**
 * Mark Delete Image Dialog
 */
function createDeleteImageDlg() {
    var dlg = '<div id="markDeleteWindow" title="Mark Delete" style="display:none"> <div id="alert-markDelete" class="alert alert-info" role="alert" style="padding: 5px;display:none"></div>' +
        '<div id="markDeleteTableDiv" width=100%><table id="markDeleteTable" class="table" border="0" width=80%> ' +
        '<tr><td width="25%" style="padding-left:20px">Reason:</td><td width=75%><select id="reasonForDelete" style="width: 100%;color :black;resize:none" />' +
        '</td></tr><tr><td width="30%" style="padding-left:20px">Signature:</td><td width=70%>' +
        '<input type="text" id="digitalSignature" style="color :black; width:100%" placeholder="Enter digital signature" >' +
        '</td ></tr></table ></div ></div > ';
    return dlg;
}

/**
 * Delete Image Status Dialog
 */
function createDeleteImageStatusDlg() {
    var dlg = '<div id="deleteImageStatus" title="Delete Image Status" style="display:none"><div id="deleteImageStatusDiv" width=100%> ' +
        '<table id="deleteImageStatusTable" class="table" border="0" width=80%><tr> <th>S.No</th> ' +
        '<th>ImageId</th> <th>Reason</th> <th>Status</th></tr> <tbody id="tbodyDeleteImageStatus"></tbody></table></div ></div >';
    return dlg;
}

/**
 * create  Image editor dialog
 */
function createImageEditorDlg() {

    var obj = {
        Origin: "Origin",
        Type: "Type",
        Spec: "Spec/SubSpec",
        Procedure: "Procedure/Event",
        ShortDescription: "Short Description",
        ControlledImage: "Controlled Image",
        Status: "Status ",
        StatusReason: "Status Reason",
        ImageCreationDate: "Image Creation Date"
    }

    var dlg = '<div id="imageEditDialog" class="modal fade" role="dialog" style="overflow: hidden;overflow-y: hidden;display:none;">' +
        '<div class="modal-dialog" id="imageEditDialog_Modal" style = "margin-top: 100px;" >' +
        '<div class="modal-content selectModalWindow-content" id="imageEditDialog_Content"  style="">' +

        '<div class="modal-header">' +
        '<a class="close-modal-window" onclick="showOrHideImageEditor(\'hide\')"> <span class="glyphicon glyphicon-remove"></span></a > ' +
        '<h4 class="modal-title" > Image Editor</h4 >' +
        '</div > ' +
        '<div class="modal-body" style="font-size: 12px;padding:10px"> ' +

        '<div class="container" id="imageEditDialog_Container1" style="width:100%;max-height:125px;overflow:auto"> ' +
        '<div class="row" style="width=100%"> ' +

        '<div class="col-md-12"> ' +
        '<table style="overflow:auto; min-width:530px"><tbody>' +
        '<tr style="border:2px transparent"><td>Site Name</td><td id="view-site" style="padding-right: 7px;"></td>' +
        '<td>Clin Procedure Date</td><td id="view-procedure-date"></td></tr>' +
        '<tr style="border:2px transparent"><td>Capture Date</td><td id="view-capture-date" style="padding-right: 7px;"></td>' +
        '<td>Image Creation Date</td><td id="view-image-createion-date"></td></tr>' +
        '<tr style="border:2px transparent"><td>Patient Name</td><td id="view-patient-name" style="padding-right: 7px;"></td>' +
        '<td>Patient ID</td><td id="view-patient-id"></td></tr>' +
        '<tr style="border:2px transparent"><td>Image Type</td><td id="view-image-type" style="padding-right: 7px;"></td>' +
        '<td>Image Date</td><td id="view-image-date"></td></tr>' +
        '<tr style="border:2px transparent"><td>Image ID</td><td id="view-image-id" style="padding-right: 7px;"></td>' +
        '<td></td><td></td></tr>' +
        '</tboby></table>' +
        '</div>' +
        '</div >' +
        '</div > ' +

        '<div class="container" id="imageEditDialog_Container2" style="width:100%"> ' +
        '<hr style="width: 100%;margin-top: 4px;margin-bottom: 4px;">' +
        '</div> ' +

        '<div class="container" id="imageEditDialog_Container3" style="max-height:540px;overflow:auto;width:100%;padding:unset;margin:unset"> ' +
        '<div class="row" style="width:100%;padding:unset;margin:unset;">' +
        '<div class="col-md-12" style="padding:unset;margin:unset"> ' +
        '<table style="min-height:340px;min-width:450px;overflow:auto;width:100%"><tbody>';
    $.each(obj, function (key, value) {
        var lableName = value;
        var id = value.replace(/\s/g, "").replace(/[/]/g, "").toLowerCase();

        dlg += '<tr style="border:3px solid transparent">' +
            '<td style="padding-right:4px"><input type="checkbox" id="' + id + '_chk" /></td>' +
            '<td><label id="' + id + '_lbl" >' + lableName + '</label></td>' +
            '<td><label id="' + id + '_txt"/></td>';

        if (key == "ShortDescription") {
            dlg += '<td><textarea style="resize:none" cols="1" rows="1" class="form-control" id= "' + id + '_ctrl" placeholder="&lt;no change&gt;" disabled/></td>';
        } else if (key == "ImageCreationDate") {
            dlg += '<td><input class="form-control" type="text" id= "' + id + '_ctrl" placeholder="&lt;no change (mm-dd-yyyy)&gt;" disabled></td>';
        } else {
            dlg += '<td><select class="form-control" id= "' + id + '_ctrl" disabled><option value="" selected>&lt;no change&gt;</option></select></td>';
        }
        dlg += '</tr>';
    });

    dlg += '</tboby></table></div></div>' +
        '</div>' +
        '</div>' +
        '<div class="modal-footer" style="margin:unset;padding: 3px 20px 20px;text-align: right;border-top: 1px solid #e5e5e5;"> ' +
        '<button type="button" class="btn btn-primary" onclick="saveImageEdit()" accesskey="s">Save</button> ' +
        '<button type="button" class="btn btn-primary" data-dismiss="modal" accesskey="c">Cancel</button></div>' +
        '</div>' +
        '</div > ' +
        '</div > ';

    return dlg;
}

/**
 * Create image editor error dialog
 */
function createImageEditorErrorDlg() {
    var dlg = '<div id="imageEditErrorDialog" class="modal fade" role="dialog" style="overflow: hidden;overflow-y: hidden;display:none;"> ' +
        '<div class="modal-dialog"><!-- Modal content--><div class="modal-content selectModalWindow-content"> ' +
        '<div class="modal-header"><a class="close-modal-window" onclick="showOrHideImageEditErrorDialog(\'hide\')"> <span class="glyphicon glyphicon-remove"></span></a> ' +
        '<h5 class="modal-title">Image Error Message</h5></div><div class="modal-body" style="font-size: 14px;height: 64px;"> ' +
        '<div class="col-md-12">Please select an image to edit ' +
        '<button type="button" class="btn btn-primary pull-right" data-dismiss="modal" accesskey="c">Cancel</button> ' +
        '</div></div></div></div></div>';
    return dlg;
}

/**
 * Create sensitive image dialog
 */
function createSensitiveImageDlg() {
    var dlg = '<div id="sensitivePrompt" title="Mark Sensitive" class="absoluteCenter" style="display:none"> ' +
        '<table style="height:50px;width:150px"><tr valign="middle"><td style="padding-left:10px;width:100px;">Sensitive Image</td> ' +
        '<td><input type="checkbox" id="sensitiveCheckbox"></td></tr></table></div>';
    return dlg;
}

function appendCommonDlgs(parent) {
    $(parent).append(createDeleteImageDlg());
    $(parent).append(createDeleteImageStatusDlg());
    $(parent).append(createImageEditorDlg());
    $(parent).append(createImageEditorErrorDlg());
    $(parent).append(createSensitiveImageDlg());
}

/**
 * Delete image window
 */
$(document).ready(function () {
    $("#alert-markDelete").removeClass('alert-info');
    $("#markDeleteWindow").dialog({
        autoOpen: false,
        width: 350,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function () {
                var digitalSign = $("#digitalSignature").val();
                var reason = "";
                if ($('#reasonForDelete > option').length > 0) {
                    reason = $("#reasonForDelete option:selected").val();
                }

                if (digitalSign === "" || reason === "") {
                    $("#alert-markDelete").show();
                    $("#alert-markDelete").removeClass('alert-info').addClass('alert-danger');
                    $("#alert-markDelete").html('value cannot be empty');
                    return;
                }

                verifySignatureAndDeleteImages(digitalSign, reason);
                $(this).dialog("close");
            },
            Cancel: function () {
                $(this).dialog("close");
            }
        },
        open: function () {
            $("#markDeleteWindow").unbind('keypress');
            $("#markDeleteWindow").keypress(function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    $(this).parent().find("button:eq(0)").trigger("click");
                }
            });
        },
        close: function () {
            $("#alert-markDelete").removeClass('alert-danger');
            $("#alert-markDelete").empty();

            if ($('#reasonForDelete > option').length > 0) {
                $('#reasonForDelete option:eq(0)').prop('selected', true);
            }
            $("#alert-markDelete").hide();
            $("#digitalSignature")[0].value = "";
        }
    });

    $("#deleteImageStatus").dialog({
        autoOpen: false,
        width: 520,
        height: 300,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function () {
                $(this).dialog("close");
            },
        },
        close: function () {
            $("#tbodyDeleteImageStatus").empty();
            var totalCount = $("#deleteImageStatus").data("totalDeleteUrnsCount");
            var deletedCount = $("#deleteImageStatus").data("failedDeleteUrnsCount");
            if (totalCount !== deletedCount) {
                doRefresh();
            }
        }
    });

    /**
     * Mark Sensitive Dialog
     */
    $("#sensitivePrompt").dialog({
        autoOpen: false,
        width: 300,
        modal: true,
        resizable: false,
        buttons: {
            "Apply": function () {
                markControlledImages(document.getElementById("sensitiveCheckbox").checked);
                $(this).dialog("close");
            },
            Cancel: function () {
                $(this).dialog("close");
            }
        },
        open: function () {
            $("#sensitivePrompt").unbind('keypress');
            $("#sensitivePrompt").keypress(function (e) {
                if (e.keyCode == 13) {
                    $(this).parent().find("button:eq(0)").trigger("click");
                }
            });
        },
        close: function () {
            document.getElementById("sensitiveCheckbox").checked = true;
        }
    });

    $('#imageEditDialog :checkbox').change(function () {
        var id = this.id;
        id = id.replace("chk", "ctrl");
        $("#" + id)[0].disabled = !this.checked;
        if (!this.checked) {
            $("#" + id)[0].data = "";
            $("#" + id).val($("#" + id + " option:first").val())
        } else {
            updateImageEditOptions();
        }
    });

    $('#imageEditDialog select').change(function () {
        updateImageEditOptions(this.id);
    });
});

/**
 * mark the metadata controlled images
 */
function markControlledImages(markSensitive) {
    try {
        showAndHideSplashWindow("show", "Applying image(s) as sensitive", "dicomViewer");

        $.ajax({
                type: 'POST',
                url: dicomViewer.Metadata.ImageSensitiveUrl(),
                cache: false,
                data: JSON.stringify({
                    isSensitive: markSensitive,
                    imageIds: getCheckedImages().imageUrns
                })
            })
            .success(function (data) {
                showAndHideSplashWindow("success", "Successfully applied selected image(s) as sensitive in server");

                doRefresh(false);
            })
            .fail(function (data) {
                showAndHideSplashWindow("error", "Failed to apply selected image(s) as sensitive in server");
            })
            .error(function (xhr, status) {
                showAndHideSplashWindow("error", "Failed to apply selected image(s) as sensitive in server");
            });
    } catch (e) {
        showAndHideSplashWindow("error", "Error in apply selected image(s) as sensitive");
    }
}


/**
 * Verify the signature and delete the marked images
 * @param {Type} signature - Specifies the digital signature
 * @param {Type} reason - Spectifies the reason to delete
 */
function verifySignatureAndDeleteImages(signature, reason) {
    try {
        showAndHideSplashWindow("show", "Verifying eSignature...", "dicomViewer");

        $.ajax({
                type: 'GET',
                url: dicomViewer.Metadata.eSignatureUrl(signature),
                cache: false,
                data: ""
            })
            .success(function (data) {
                deleteMarkImages(reason);
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
}

/**
 * Delete the marked images
 * @param {Type} reason - Spectifies the reason to delete
 */
function deleteMarkImages(reason) {
    try {
        showAndHideSplashWindow("show", "Deleting image(s) from the server", "dicomViewer");
        var UrnsCount = (getCheckedImages().imageUrns).length;
        $("#deleteImageStatus").data("totalDeleteUrnsCount", UrnsCount);
        $.ajax({
                type: 'DELETE',
                url: dicomViewer.Metadata.ImageDeleteUrl(),
                cache: false,
                data: JSON.stringify({
                    reason: reason,
                    imageIds: getCheckedImages().imageUrns
                })
            })
            .success(function (data) {
                if (data !== "" && data.length > 0) {
                    var tableappend = "";
                    $("#deleteImageStatus").data("failedDeleteUrnsCount", data.length);
                    for (var i = 0; i < data.length; i++) {
                        tableappend += "<tr><td >" + (i + 1) + "</td><td >" + data[i].imageId + "</td><td >" + data[i].message + "</td><td > Failed </td></tr>";
                    }
                    $("#tbodyDeleteImageStatus").append(tableappend);
                    $("#deleteImageStatus").dialog("open");
                } else {
                    showAndHideSplashWindow("success", "Successfully deleted the image(s) from server");
                    doRefresh(true);
                }
            })
            .fail(function (data, textStatus, errorThrown) {
                showAndHideSplashWindow("error", "Failed to delete the image(s) from server");
            })
            .error(function (xhr, status) {
                showAndHideSplashWindow("error", "Failed to delete the image(s) from server");
            });
    } catch (e) {
        showAndHideSplashWindow("error", "Error in delete image(s) from server");
    }
}

function getXmlData(obj) {
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
 * Get the image edit properties
 * @param {Type} imageIen - Specifies the image Ien
 */
function getImageEditProperties(imageIen) {
    var imageProperties = "";

    try {
        var propNames = [];
        propNames["origin_ctrl"] = "IXORIGIN";
        propNames["type_ctrl"] = "IXTYPE";
        propNames["specsubspec_ctrl"] = "IXSPEC";
        propNames["procedureevent_ctrl"] = "IXPROC";
        propNames["shortdescription_ctrl"] = "GDESC";
        propNames["status_ctrl"] = "ISTAT";
        propNames["statusreason_ctrl"] = "ISTATRSN";
        propNames["imagecreationdate_ctrl"] = "CRTNDT";
        propNames["controlledimage_ctrl"] = "SENSIMG";

        $("#imageEditDialog input:checked").each(function () {
            var ctrlId = this.id.replace('chk', 'ctrl');
            var name = propNames[ctrlId];
            var value = $('#' + ctrlId).val();
            if (value) {
                if (ctrlId == "status_ctrl") {
                    value = $('#' + ctrlId).find(":selected")[0].id;
                }

                imageProperties += getXmlData({
                    imageProperty: {
                        name: name,
                        value: value,
                        ien: imageIen
                    }
                })
            }
        });

        if (imageProperties != "") {
            imageProperties = '<imageProperties>' + imageProperties + '</imageProperties>';
        }
    } catch (e) {}

    return imageProperties;
}

/**
 * Save the edited image options
 */
function saveImageEdit() {
    var imageIen = $('#view-image-id').html();
    if (imageIen != "") {
        imageIen = imageIen.replace(":", "").trim();
        updateImageProperties(getImageEditProperties(imageIen), [imageIen]);
    }
    showOrHideImageEditor('hide');
}

/**
 *  Prompt the image edit dialog
 */
function doImageEdit(event) {
    try {
        var firstImage;
        var studyDate;
        var captureDate;
        var imageDate;
        var imageDetails = {
            siteName: "",
            imageId: ""
        }

        if (event) {
            firstImage = getFirstCheckedImage();
            if (firstImage) {
                studyDate = firstImage.study.studyDate ? firstImage.study.studyDate.replace("T", "@") : " ";
                captureDate = firstImage.image.captureDate ? firstImage.image.captureDate.replace("T", "@") : " ";
                imageDate = firstImage.image.documentDate ? firstImage.image.documentDate.replace("T", "@") : " ";
                imageDetails.siteName = firstImage.study.siteName;
                var imageUrn = (firstImage.image.imageId).split("-")[1];
                imageDetails.imageId = imageUrn;
                fetchAndUpdateImageProperties(imageUrn);
            }
        } else {
            var activeImage = $("#home-patient-info")[0].data;
            if (activeImage) {
                firstImage = getStudyDetail(activeImage.studyId);
                if (firstImage) {
                    //var studyDate = firstImage.studyDate ? firstImage.studyDate .replace("T", "@") : " ";
                    var captureDate = firstImage.captureDate ? firstImage.captureDate.replace("T", "@") : " ";
                    var imageDate = firstImage.documentDate ? firstImage.documentDate.replace("T", "@") : " ";
                    imageDetails.imageId = activeImage.imageUrn[0];
                    imageDetails.siteName = firstImage.siteName;
                }
            }
        }

        if (!firstImage) {
            // TODO: Display error message
            $('#imageEditErrorDialog').modal('show');
            return;
        }

        $("#view-site").html(" : " + imageDetails.siteName); //
        $("#view-capture-date").html(" : " + captureDate);
        $("#view-image-id").html(" : " + imageDetails.imageId); // 
        $("#view-image-date").html(" : " + imageDate);

        // updateImageEditOptions();
        // TODO: Display the first image information
        showOrHideImageEditor('show');
    } catch (e) {}
}

function getCheckedIndexes() {
    var checkedIndexes = $('#imageEditDialog input:checked');
    var indexes = "";
    if (checkedIndexes.length > 0) {
        $.each(checkedIndexes, function (key, value) {
            indexes += (value.id.replace("_chk", "") + "^");
        });
    }
    return indexes.slice(0, -1);
}

/**
 * Update the image edit options
 */
function updateImageEditOptions(skipId) {
    try {
        var indexes = getCheckedIndexes();
        if (skipId) {
            var indexTermId = $('#' + skipId).find(":selected")[0].id;
            if (skipId == "specsubspec_ctrl") {
                indexes = indexes.replace("procedureevent", "procedureevent|" + indexTermId);
            } else if (skipId == "procedureevent_ctrl") {
                indexes = indexes.replace("specsubspec", "specsubspec|" + indexTermId);
            }
        }

        $.ajax({
                url: dicomViewer.Metadata.EditOptionsUrl(indexes),
                cache: false,
                async: true
            })
            .done(function (data) {
                if (data) {
                    loadImageEditData("origin_ctrl", data.origin, skipId);
                    loadImageEditData("type_ctrl", data.type, skipId);
                    loadImageEditData("specsubspec_ctrl", data.specsubspec, skipId, (skipId == "procedureevent_ctrl"));
                    loadImageEditData("procedureevent_ctrl", data.procedureevent, skipId, (skipId == "specsubspec_ctrl"));
                    loadImageEditData("controlledimage_ctrl", data.controlledImg, skipId);
                    loadImageEditData("status_ctrl", data.status, skipId);
                    loadImageEditData("statusreason_ctrl", data.statusreason, skipId);
                }
            })
            .fail(function (data) {})
            .error(function (xhr, status) {});
    } catch (e) {}
}

function parseEditOption(type, xmlResponse) {
    var x2js = new X2JS();
    var indexterms = x2js.xml_str2json(xmlResponse);
    var indexes = [];

    if (indexterms && type != "statusreason" && xmlResponse) {
        if (!Array.isArray(indexterms.indexTermValuesType.indexTermValue)) {
            indexterms.indexTermValuesType.indexTermValue = [indexterms.indexTermValuesType.indexTermValue];
        }
        indexterms.indexTermValuesType.indexTermValue.forEach(function (value) {
            indexes.push({
                type: type,
                indexTermId: value.indexTermId,
                abbreviation: value.abbreviation,
                name: value.name
            });
        });
    } else if (type == "status") {
        var imageStatus = [
            {
                name: "Viewable",
                indexTermId: "1"
            },
            {
                name: "QA Reviewed",
                indexTermId: "2"
            },
            {
                name: "Needs Review",
                indexTermId: "11"
            }];
        imageStatus.forEach(function (status) {
            indexes.push({
                type: type,
                indexTermId: status.indexTermId,
                abbreviation: status.name,
                name: status.name
            });
        });
    } else if (type == "controlledimage") {
        var controlledimage = [
            {
                name: "Yes",
                indexTermId: "true"
            },
            {
                name: "No",
                indexTermId: "false"
            }];
        controlledimage.forEach(function (image) {
            indexes.push({
                type: type,
                indexTermId: image.indexTermId,
                abbreviation: image.name,
                name: image.name
            });
        });
    } else if (type == "statusreason" && indexterms && xmlResponse) {
        indexterms.statusReasons.statusReason.forEach(function (reason) {
            indexes.push({
                type: type,
                indexTermId: "",
                abbreviation: reason,
                name: reason
            });
        });
    }
    return indexes;
}

function loadImageEditData(id, xmlResponse, skipId, sync) {
    var indexValue = $('#' + id).find(":selected")[0].value;
    removeSelectOptions(id, skipId);

    var indexes = parseEditOption(id.split('_')[0], xmlResponse);
    if (indexes) {
        $.each(indexes, function (i, value) {
            if (id != skipId) {
                $('#' + id).append('<option id="' + value.indexTermId + '" value="' + value.name + '">' + value.name + '</option>');
            }
        });

        var indexId = $('#' + id + ' option[value="' + indexValue + '"]').index();
        $('select[id=' + id + '] option:eq(' + indexId + ')').attr('selected', 'selected');
        $("#" + id)[0].data = $('#' + id).find(":selected")[0].value;
    }
}

function setSecurityToken() {
    dicomViewer.security.setSecurityToken(BasicUtil.getUrlParameter('securityToken', "", true)); //VAI-915
}

/**
 * Set the image properties
 * @param {Type} statusFlag - Specifies the status flag
 * @param {Type} imageIEN  - Specifies the image IENs
 */
function updateImageProperties(props, imageIENs) {
    try {
        showAndHideSplashWindow("show", "Set the image properties to " + imageIENs, "home-viewer");
        $.ajax({
            url: dicomViewer.Metadata.EditSaveUrl(),
            method: 'POST',
            async: true,
            cache: false,
            data: JSON.stringify({
                props: props
            }),
            success: function (data) {
                try {
                    showAndHideSplashWindow("success", "Successfully updated the image properties");
                    var ien = $("#home-patient-info")[0] ? undefined : imageIENs[0];
                    fetchAndUpdateImageProperties(ien);
                    prepareViewerRequest(reqType.imageStatus);
                } catch (e) {}
            },
            error: function (xhr, status) {
                showAndHideSplashWindow("error", "Failed to set the image properties");
            }
        });
    } catch (e) {}
}

/**
 * Fetch and update the image properties
 */
function fetchAndUpdateImageProperties(imageUrn) {
    try {
        var activeImage = imageUrn ? (activeImage = {
            imageUrn: [imageUrn]
        }) : $("#home-patient-info")[0].data;
        if (activeImage) {
            var imageIEN = activeImage.imageUrn[0];
            showAndHideSplashWindow("show", "Fetching the image properties (" + imageIEN + ")", "home-viewer");
            var imagePropertiesUrl = dicomViewer.getQaImagePropertiesUrl(imageIEN);
            $.ajax({
                url: imagePropertiesUrl,
                method: 'GET',
                async: true,
                cache: false,
                success: function (data) {
                    refreshImageProperties(getJsonData(data), imageUrn);
                    showAndHideSplashWindow("success", "Successfully fetched the image properties");
                },
                error: function (xhr, status) {
                    refreshImageProperties(undefined);
                    showAndHideSplashWindow("error", "Failed to fetch the image properties");
                }
            });
        }
    } catch (e) {}
}

/**
 * Update the image properties
 * @param {Type} data - Specifies the image properties
 */
function refreshImageProperties(data, imageUrn) {
    try {
        clearPatientDetail(imageUrn);
        if (data) {
            var imageProperties = data.imageProperties;
            if (imageProperties && Array.isArray(imageProperties.imageProperty)) {
                var align = " : "
                imageProperties.imageProperty.forEach(function (property) {
                    var propertyValue = property.value;
                    var propertyEIValues = property.value.split('^');
                    if (propertyEIValues.length == 2) {
                        propertyValue = propertyEIValues[1];
                    }

                    var fieldValue = align + propertyValue;
                    switch (property.name) {
                        case "OBJNAME":
                            {
                                var values = propertyValue.split(' ');
                                var patientName = propertyValue;
                                var patientId = "";
                                if (values.length >= 4) {
                                    patientName = values[0].trim();
                                    patientId = values[3].trim();
                                }

                                if (!imageUrn) {
                                    $('#home-patient-name').html(align + patientName);
                                    $('#home-patient-id').html(align + patientId);
                                }

                                $("#view-patient-id").html(align + patientId);
                                break;
                            }

                        case "GDESC":
                            {
                                if (!imageUrn) {
                                    $('#home-patient-shortdesc').html(fieldValue);
                                }
                                $('#shortdescription_txt').html(fieldValue.replace(":", ""));
                                break;
                            }

                        case "IXSPEC":
                            {
                                if (!imageUrn) {
                                    $('#home-patient-specialty').html(fieldValue);
                                }
                                $('#specsubspec_txt').html(fieldValue.replace(":", ""));
                                break;
                            }

                        case "IXTYPE":
                            {
                                if (!imageUrn) {
                                    $('#home-patient-type').html(fieldValue);
                                }
                                $("#view-image-type").html(fieldValue);
                                $("#type_txt").html(fieldValue.replace(":", ""));
                                break;
                            }

                        case "ISTAT":
                            {
                                if (!imageUrn) {
                                    $('#home-patient-status').html(fieldValue);
                                }
                                $('#status_txt').html(fieldValue.replace(":", ""));
                                break;
                            }

                        case "IXPROC":
                            {
                                if (!imageUrn) {
                                    $('#home-patient-procedure').html(fieldValue);
                                }
                                $("#procedureevent_txt").html(fieldValue.replace(":", ""));
                                break;
                            }

                        case "PROCDT":
                            {
                                $("#view-procedure-date").html(fieldValue);
                                break;
                            }
                        case "CRTNDT":
                            {
                                $("#view-image-createion-date").html(fieldValue);
                                $("#imagecreationdate_txt").html(fieldValue.replace(":", ""));
                                break;
                            }
                        case "IDFN":
                            {
                                $("#view-patient-name").html(fieldValue);
                                break;
                            }

                        case "IXORIGIN":
                            {
                                $("#origin_txt").html(fieldValue.replace(":", ""));
                                break;
                            }

                        case "ISTATRSN":
                            {
                                if (!imageUrn) {
                                    $('#home-patient-reason').html(fieldValue);
                                }
                                $("#statusreason_txt").html(fieldValue.replace(":", ""));
                                break;
                            }

                        case "SENSIMG":
                            {
                                $("#controlledimage_txt").html(fieldValue.replace(":", ""));
                                break;
                            }

                        default:
                            break;
                    }
                });
            }
        }
    } catch (e) {}
}

/**
 * clear patient details
 */
function clearPatientDetail(isClear) {
    $("#origin_txt").html('');
    $("#type_txt").html('');
    $("#specsubspec_txt").html('');
    $("#procedureevent_txt").html('');
    $("#shortdescription_txt").html('');
    $("#controlledimage_txt").html('');
    $("#status_txt").html('');
    $("#statusreason_txt").html('');
    $("#imagecreationdate_txt").html('');

    $("#view-procedure-date").html(' : ');
    $("#view-image-createion-date").html(' : ');
    $("#view-patient-name").html(' : ');
    $("#view-patient-id").html(' : ');
    $("#view-image-type").html(' : ');

    if (!isClear) {
        $('#home-patient-name').html(': &lt;patient name&gt;');
        $('#home-patient-id').html(': &lt;SSN&gt;');
        $('#home-patient-shortdesc').html(': &lt;short desc&gt;');
        $('#home-patient-specialty').html(': &lt;spec/subspec&gt;');
        $('#home-patient-type').html(': &lt;type&gt;');
        $('#home-patient-status').html(': &lt;status&gt;');
        $('#home-patient-reason').html(': &lt;reason&gt;');
        $('#home-patient-procedure').html(': &lt;proc/event&gt;');

        $("#view-site").html(' : ');
        $("#view-capture-date").html(' : ');
        $("#view-image-id").html(' : ');
        $("#view-image-date").html(' : ');
    }
}

function showOrHideImageEditErrorDialog() {
    $('#imageEditErrorDialog').modal('hide');
}

function showOrHideImageEditor(option) {
    $("#imageEditDialog").modal(option);
    $("#imageEditDialog input:checked").attr("checked", false);
    $("#imageEditDialog select").attr("disabled", "disabled");
    $("#imageEditDialog textarea, #imageEditDialog input:text").val('');
    $("#imageEditDialog textarea, #imageEditDialog input:text").attr("disabled", "disabled");
    var elements = $("#imageEditDialog select");
    $.each(elements, function (key, value) {
        removeSelectOptions(value.id);
    });

    setTimeout(function () {
        updateWindowPOs();
    }, 400);
}

function removeSelectOptions(id, skipId) {
    if (id == skipId) {
        return;
    }
    var select = document.getElementById(id);
    var length = select.options.length;
    for (i = length; i >= 1; i--) {
        select.options[i] = null;
    }
}

/**
 * click event for while clicking the marksensitive
 */
function doMarkSensitive() {
    document.getElementById("sensitiveCheckbox").checked = true;
    $("#sensitivePrompt").dialog("open");
}

/**
 * click event for while clicking the markdelete
 */
function doMarkDelete() {
    $("#markDeleteWindow").dialog("open");
}

(function (root, factory) {
    if (typeof define === "function" && define.amd) {
        define([], factory);
    } else if (typeof exports === "object") {
        module.exports = factory();
    } else {
        root.X2JS = factory();
    }
}(this, function () {
    return function (config) {
        'use strict';

        var VERSION = "1.2.0";

        config = config || {};
        initConfigDefaults();
        initRequiredPolyfills();

        function initConfigDefaults() {
            if (config.escapeMode === undefined) {
                config.escapeMode = true;
            }

            config.attributePrefix = config.attributePrefix || "_";
            config.arrayAccessForm = config.arrayAccessForm || "none";
            config.emptyNodeForm = config.emptyNodeForm || "text";

            if (config.enableToStringFunc === undefined) {
                config.enableToStringFunc = true;
            }
            config.arrayAccessFormPaths = config.arrayAccessFormPaths || [];
            if (config.skipEmptyTextNodesForObj === undefined) {
                config.skipEmptyTextNodesForObj = true;
            }
            if (config.stripWhitespaces === undefined) {
                config.stripWhitespaces = true;
            }
            config.datetimeAccessFormPaths = config.datetimeAccessFormPaths || [];

            if (config.useDoubleQuotes === undefined) {
                config.useDoubleQuotes = false;
            }

            config.xmlElementsFilter = config.xmlElementsFilter || [];
            config.jsonPropertiesFilter = config.jsonPropertiesFilter || [];

            if (config.keepCData === undefined) {
                config.keepCData = false;
            }
        }

        var DOMNodeTypes = {
            ELEMENT_NODE: 1,
            TEXT_NODE: 3,
            CDATA_SECTION_NODE: 4,
            COMMENT_NODE: 8,
            DOCUMENT_NODE: 9
        };

        function initRequiredPolyfills() {}

        function getNodeLocalName(node) {
            var nodeLocalName = node.localName;
            if (nodeLocalName == null) // Yeah, this is IE!! 
                nodeLocalName = node.baseName;
            if (nodeLocalName == null || nodeLocalName == "") // =="" is IE too
                nodeLocalName = node.nodeName;
            return nodeLocalName;
        }

        function getNodePrefix(node) {
            return node.prefix;
        }

        function escapeXmlChars(str) {
            if (typeof (str) == "string")
                return str.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;').replace(/'/g, '&apos;');
            else
                return str;
        }

        function unescapeXmlChars(str) {
            return str.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&apos;/g, "'").replace(/&amp;/g, '&');
        }

        function checkInStdFiltersArrayForm(stdFiltersArrayForm, obj, name, path) {
            var idx = 0;
            for (; idx < stdFiltersArrayForm.length; idx++) {
                var filterPath = stdFiltersArrayForm[idx];
                if (typeof filterPath === "string") {
                    if (filterPath == path)
                        break;
                } else
                if (filterPath instanceof RegExp) {
                    if (filterPath.test(path))
                        break;
                } else
                if (typeof filterPath === "function") {
                    if (filterPath(obj, name, path))
                        break;
                }
            }
            return idx != stdFiltersArrayForm.length;
        }

        function toArrayAccessForm(obj, childName, path) {
            switch (config.arrayAccessForm) {
                case "property":
                    if (!(obj[childName] instanceof Array))
                        obj[childName + "_asArray"] = [obj[childName]];
                    else
                        obj[childName + "_asArray"] = obj[childName];
                    break;
                    /*case "none":
                            break;*/
            }

            if (!(obj[childName] instanceof Array) && config.arrayAccessFormPaths.length > 0) {
                if (checkInStdFiltersArrayForm(config.arrayAccessFormPaths, obj, childName, path)) {
                    obj[childName] = [obj[childName]];
                }
            }
        }

        function fromXmlDateTime(prop) {
            // Implementation based up on http://stackoverflow.com/questions/8178598/xml-datetime-to-javascript-date-object
            // Improved to support full spec and optional parts
            var bits = prop.split(/[-T:+Z]/g);

            var d = new Date(bits[0], bits[1] - 1, bits[2]);
            var secondBits = bits[5].split("\.");
            d.setHours(bits[3], bits[4], secondBits[0]);
            if (secondBits.length > 1)
                d.setMilliseconds(secondBits[1]);

            // Get supplied time zone offset in minutes
            if (bits[6] && bits[7]) {
                var offsetMinutes = bits[6] * 60 + Number(bits[7]);
                var sign = /\d\d-\d\d:\d\d$/.test(prop) ? '-' : '+';

                // Apply the sign
                offsetMinutes = 0 + (sign == '-' ? -1 * offsetMinutes : offsetMinutes);

                // Apply offset and local timezone
                d.setMinutes(d.getMinutes() - offsetMinutes - d.getTimezoneOffset())
            } else
            if (prop.indexOf("Z", prop.length - 1) !== -1) {
                d = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate(), d.getHours(), d.getMinutes(), d.getSeconds(), d.getMilliseconds()));
            }

            // d is now a local time equivalent to the supplied time
            return d;
        }

        function checkFromXmlDateTimePaths(value, childName, fullPath) {
            if (config.datetimeAccessFormPaths.length > 0) {
                var path = fullPath.split("\.#")[0];
                if (checkInStdFiltersArrayForm(config.datetimeAccessFormPaths, value, childName, path)) {
                    return fromXmlDateTime(value);
                } else
                    return value;
            } else
                return value;
        }

        function checkXmlElementsFilter(obj, childType, childName, childPath) {
            if (childType == DOMNodeTypes.ELEMENT_NODE && config.xmlElementsFilter.length > 0) {
                return checkInStdFiltersArrayForm(config.xmlElementsFilter, obj, childName, childPath);
            } else
                return true;
        }

        function parseDOMChildren(node, path) {
            if (node.nodeType == DOMNodeTypes.DOCUMENT_NODE) {
                var result = new Object;
                var nodeChildren = node.childNodes;
                // Alternative for firstElementChild which is not supported in some environments
                for (var cidx = 0; cidx < nodeChildren.length; cidx++) {
                    var child = nodeChildren.item(cidx);
                    if (child.nodeType == DOMNodeTypes.ELEMENT_NODE) {
                        var childName = getNodeLocalName(child);
                        result[childName] = parseDOMChildren(child, childName);
                    }
                }
                return result;
            } else
            if (node.nodeType == DOMNodeTypes.ELEMENT_NODE) {
                var result = new Object;
                result.__cnt = 0;

                var nodeChildren = node.childNodes;

                // Children nodes
                for (var cidx = 0; cidx < nodeChildren.length; cidx++) {
                    var child = nodeChildren.item(cidx); // nodeChildren[cidx];
                    var childName = getNodeLocalName(child);

                    if (child.nodeType != DOMNodeTypes.COMMENT_NODE) {
                        var childPath = path + "." + childName;
                        if (checkXmlElementsFilter(result, child.nodeType, childName, childPath)) {
                            result.__cnt++;
                            if (result[childName] == null) {
                                result[childName] = parseDOMChildren(child, childPath);
                                toArrayAccessForm(result, childName, childPath);
                            } else {
                                if (result[childName] != null) {
                                    if (!(result[childName] instanceof Array)) {
                                        result[childName] = [result[childName]];
                                        toArrayAccessForm(result, childName, childPath);
                                    }
                                }
                                (result[childName])[result[childName].length] = parseDOMChildren(child, childPath);
                            }
                        }
                    }
                }

                // Attributes
                for (var aidx = 0; aidx < node.attributes.length; aidx++) {
                    var attr = node.attributes.item(aidx); // [aidx];
                    result.__cnt++;
                    result[config.attributePrefix + attr.name] = attr.value;
                }

                // Node namespace prefix
                var nodePrefix = getNodePrefix(node);
                if (nodePrefix != null && nodePrefix != "") {
                    result.__cnt++;
                    result.__prefix = nodePrefix;
                }

                if (result["#text"] != null) {
                    result.__text = result["#text"];
                    if (result.__text instanceof Array) {
                        result.__text = result.__text.join("\n");
                    }
                    //if(config.escapeMode)
                    //	result.__text = unescapeXmlChars(result.__text);
                    if (config.stripWhitespaces)
                        result.__text = result.__text.trim();
                    delete result["#text"];
                    if (config.arrayAccessForm == "property")
                        delete result["#text_asArray"];
                    result.__text = checkFromXmlDateTimePaths(result.__text, childName, path + "." + childName);
                }
                if (result["#cdata-section"] != null) {
                    result.__cdata = result["#cdata-section"];
                    delete result["#cdata-section"];
                    if (config.arrayAccessForm == "property")
                        delete result["#cdata-section_asArray"];
                }

                if (result.__cnt == 0 && config.emptyNodeForm == "text") {
                    result = '';
                } else
                if (result.__cnt == 1 && result.__text != null) {
                    result = result.__text;
                } else
                if (result.__cnt == 1 && result.__cdata != null && !config.keepCData) {
                    result = result.__cdata;
                } else
                if (result.__cnt > 1 && result.__text != null && config.skipEmptyTextNodesForObj) {
                    if ((config.stripWhitespaces && result.__text == "") || (result.__text.trim() == "")) {
                        delete result.__text;
                    }
                }
                delete result.__cnt;

                if (config.enableToStringFunc && (result.__text != null || result.__cdata != null)) {
                    result.toString = function () {
                        return (this.__text != null ? this.__text : '') + (this.__cdata != null ? this.__cdata : '');
                    };
                }

                return result;
            } else
            if (node.nodeType == DOMNodeTypes.TEXT_NODE || node.nodeType == DOMNodeTypes.CDATA_SECTION_NODE) {
                return node.nodeValue;
            }
        }

        function startTag(jsonObj, element, attrList, closed) {
            var resultStr = "<" + ((jsonObj != null && jsonObj.__prefix != null) ? (jsonObj.__prefix + ":") : "") + element;
            if (attrList != null) {
                for (var aidx = 0; aidx < attrList.length; aidx++) {
                    var attrName = attrList[aidx];
                    var attrVal = jsonObj[attrName];
                    if (config.escapeMode)
                        attrVal = escapeXmlChars(attrVal);
                    resultStr += " " + attrName.substr(config.attributePrefix.length) + "=";
                    if (config.useDoubleQuotes)
                        resultStr += '"' + attrVal + '"';
                    else
                        resultStr += "'" + attrVal + "'";
                }
            }
            if (!closed)
                resultStr += ">";
            else
                resultStr += "/>";
            return resultStr;
        }

        function endTag(jsonObj, elementName) {
            return "</" + (jsonObj.__prefix != null ? (jsonObj.__prefix + ":") : "") + elementName + ">";
        }

        function endsWith(str, suffix) {
            return str.indexOf(suffix, str.length - suffix.length) !== -1;
        }

        function jsonXmlSpecialElem(jsonObj, jsonObjField) {
            if ((config.arrayAccessForm == "property" && endsWith(jsonObjField.toString(), ("_asArray"))) ||
                jsonObjField.toString().indexOf(config.attributePrefix) == 0 ||
                jsonObjField.toString().indexOf("__") == 0 ||
                (jsonObj[jsonObjField] instanceof Function))
                return true;
            else
                return false;
        }

        function jsonXmlElemCount(jsonObj) {
            var elementsCnt = 0;
            if (jsonObj instanceof Object) {
                for (var it in jsonObj) {
                    if (jsonXmlSpecialElem(jsonObj, it))
                        continue;
                    elementsCnt++;
                }
            }
            return elementsCnt;
        }

        function checkJsonObjPropertiesFilter(jsonObj, propertyName, jsonObjPath) {
            return config.jsonPropertiesFilter.length == 0 ||
                jsonObjPath == "" ||
                checkInStdFiltersArrayForm(config.jsonPropertiesFilter, jsonObj, propertyName, jsonObjPath);
        }

        function parseJSONAttributes(jsonObj) {
            var attrList = [];
            if (jsonObj instanceof Object) {
                for (var ait in jsonObj) {
                    if (ait.toString().indexOf("__") == -1 && ait.toString().indexOf(config.attributePrefix) == 0) {
                        attrList.push(ait);
                    }
                }
            }
            return attrList;
        }

        function parseJSONTextAttrs(jsonTxtObj) {
            var result = "";

            if (jsonTxtObj.__cdata != null) {
                result += "<![CDATA[" + jsonTxtObj.__cdata + "]]>";
            }

            if (jsonTxtObj.__text != null) {
                if (config.escapeMode)
                    result += escapeXmlChars(jsonTxtObj.__text);
                else
                    result += jsonTxtObj.__text;
            }
            return result;
        }

        function parseJSONTextObject(jsonTxtObj) {
            var result = "";

            if (jsonTxtObj instanceof Object) {
                result += parseJSONTextAttrs(jsonTxtObj);
            } else
            if (jsonTxtObj != null) {
                if (config.escapeMode)
                    result += escapeXmlChars(jsonTxtObj);
                else
                    result += jsonTxtObj;
            }

            return result;
        }

        function getJsonPropertyPath(jsonObjPath, jsonPropName) {
            if (jsonObjPath === "") {
                return jsonPropName;
            } else
                return jsonObjPath + "." + jsonPropName;
        }

        function parseJSONArray(jsonArrRoot, jsonArrObj, attrList, jsonObjPath) {
            var result = "";
            if (jsonArrRoot.length == 0) {
                result += startTag(jsonArrRoot, jsonArrObj, attrList, true);
            } else {
                for (var arIdx = 0; arIdx < jsonArrRoot.length; arIdx++) {
                    result += startTag(jsonArrRoot[arIdx], jsonArrObj, parseJSONAttributes(jsonArrRoot[arIdx]), false);
                    result += parseJSONObject(jsonArrRoot[arIdx], getJsonPropertyPath(jsonObjPath, jsonArrObj));
                    result += endTag(jsonArrRoot[arIdx], jsonArrObj);
                }
            }
            return result;
        }

        function parseJSONObject(jsonObj, jsonObjPath) {
            var result = "";

            var elementsCnt = jsonXmlElemCount(jsonObj);

            if (elementsCnt > 0) {
                for (var it in jsonObj) {

                    if (jsonXmlSpecialElem(jsonObj, it) || (jsonObjPath != "" && !checkJsonObjPropertiesFilter(jsonObj, it, getJsonPropertyPath(jsonObjPath, it))))
                        continue;

                    var subObj = jsonObj[it];

                    var attrList = parseJSONAttributes(subObj)

                    if (subObj == null || subObj == undefined) {
                        result += startTag(subObj, it, attrList, true);
                    } else
                    if (subObj instanceof Object) {

                        if (subObj instanceof Array) {
                            result += parseJSONArray(subObj, it, attrList, jsonObjPath);
                        } else if (subObj instanceof Date) {
                            result += startTag(subObj, it, attrList, false);
                            result += subObj.toISOString();
                            result += endTag(subObj, it);
                        } else {
                            var subObjElementsCnt = jsonXmlElemCount(subObj);
                            if (subObjElementsCnt > 0 || subObj.__text != null || subObj.__cdata != null) {
                                result += startTag(subObj, it, attrList, false);
                                result += parseJSONObject(subObj, getJsonPropertyPath(jsonObjPath, it));
                                result += endTag(subObj, it);
                            } else {
                                result += startTag(subObj, it, attrList, true);
                            }
                        }
                    } else {
                        result += startTag(subObj, it, attrList, false);
                        result += parseJSONTextObject(subObj);
                        result += endTag(subObj, it);
                    }
                }
            }
            result += parseJSONTextObject(jsonObj);

            return result;
        }

        this.parseXmlString = function (xmlDocStr) {
            var isIEParser = window.ActiveXObject || "ActiveXObject" in window;
            if (xmlDocStr === undefined) {
                return null;
            }
            var xmlDoc;
            if (window.DOMParser) {
                var parser = new window.DOMParser();
                var parsererrorNS = null;
                // IE9+ now is here
                if (!isIEParser) {
                    try {
                        parsererrorNS = parser.parseFromString("INVALID", "text/xml").getElementsByTagName("parsererror")[0].namespaceURI;
                    } catch (err) {
                        parsererrorNS = null;
                    }
                }
                try {
                    xmlDoc = parser.parseFromString(xmlDocStr, "text/xml");
                    if (parsererrorNS != null && xmlDoc.getElementsByTagNameNS(parsererrorNS, "parsererror").length > 0) {
                        //throw new Error('Error parsing XML: '+xmlDocStr);
                        xmlDoc = null;
                    }
                } catch (err) {
                    xmlDoc = null;
                }
            } else {
                // IE :(
                if (xmlDocStr.indexOf("<?") == 0) {
                    xmlDocStr = xmlDocStr.substr(xmlDocStr.indexOf("?>") + 2);
                }
                xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
                xmlDoc.async = "false";
                xmlDoc.loadXML(xmlDocStr);
            }
            return xmlDoc;
        };

        this.asArray = function (prop) {
            if (prop === undefined || prop == null)
                return [];
            else
            if (prop instanceof Array)
                return prop;
            else
                return [prop];
        };

        this.toXmlDateTime = function (dt) {
            if (dt instanceof Date)
                return dt.toISOString();
            else
            if (typeof (dt) === 'number')
                return new Date(dt).toISOString();
            else
                return null;
        };

        this.asDateTime = function (prop) {
            if (typeof (prop) == "string") {
                return fromXmlDateTime(prop);
            } else
                return prop;
        };

        this.xml2json = function (xmlDoc) {
            return parseDOMChildren(xmlDoc);
        };

        this.xml_str2json = function (xmlDocStr) {
            var xmlDoc = this.parseXmlString(xmlDocStr);
            if (xmlDoc != null)
                return this.xml2json(xmlDoc);
            else
                return null;
        };

        this.json2xml_str = function (jsonObj) {
            return parseJSONObject(jsonObj, "");
        };

        this.json2xml = function (jsonObj) {
            var xmlDocStr = this.json2xml_str(jsonObj);
            return this.parseXmlString(xmlDocStr);
        };

        this.getVersion = function () {
            return VERSION;
        };
    }
}))

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

//Update the imag edit window position when resize and open the edit dialog
function updateWindowPOs() {
    try {
        var display = $("#imageEditDialog")[0].style.display;

        if (display !== "block") {
            return;
        }
        var id = document.getElementsByTagName("BODY")[0].id;
        var viewerRect = $("#" + id)[0].getBoundingClientRect();
        var dlgContentRect = $("#imageEditDialog_Content")[0].getBoundingClientRect();
        var dlg = $("#imageEditDialog_Modal")[0];
        var defaultHeight = 580;
        var marginTop = viewerRect.height - dlgContentRect.height;
        var HFHeight = 125;

        if (dlgContentRect.height > viewerRect.height || defaultHeight > viewerRect.height) {
            defaultHeight = (viewerRect.height - 20);
        }
        var container1 = defaultHeight - HFHeight;
        container1 = container1 / 4;
        var container3 = container1 * 3;
        marginTop = marginTop > 0 ? marginTop / 2 : 0;

        dlg.style.marginTop = marginTop + "px";
        dlg.style.height = defaultHeight + "px";
        $("#imageEditDialog_Content")[0].style.height = defaultHeight + "px";
        $("#imageEditDialog_Container1")[0].style.height = container1 + "px";
        $("#imageEditDialog_Container3")[0].style.height = container3 + "px";
    } catch (e) {}
}
