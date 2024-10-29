$(document).ready(function() {
    var THUMBNAIL_PANEL_MIN_WIDTH = ((screen.width*135) / 1280) < 135 ? 135 : (screen.width*135) / 1280 ;
    var THUMBNAIL_PANEL_MAX_WIDTH = 150;
    var THUMBNAIL_PANEL_WIDTH = THUMBNAIL_PANEL_MIN_WIDTH;
    if(THUMBNAIL_PANEL_WIDTH > THUMBNAIL_PANEL_MAX_WIDTH) {
        THUMBNAIL_PANEL_WIDTH = THUMBNAIL_PANEL_MAX_WIDTH;
    }
    
    playerToolBarElement = $("#playerTool");
    pdfToolBarElement = $("#pdfTool");
    tiffToolBarElement = $("#tiffNavigationTool");
//    cacheIndicatorElement = $("#cacheIndicator");
    $("#toolbar").kendoToolBar({
        items: [{
                type: "splitButton",
                text: "",
                imageUrl: "../images/brightness.png",
                id: "winL",
                title : 'WW/WC',
                click: dicomViewer.tools.doWindowLevel,
                menuButtons: [{
                    text: "Default",
                    id: "1",
                    click: dicomViewer.tools.doWindowLevel
                }, {
                    text: "Abdomen",
                    id: "2",
                    click: dicomViewer.tools.doWindowLevel
                }, {
                    text: "Bone",
                    id: "5",
                    click: dicomViewer.tools.doWindowLevel
                }, {
                    text: "Brain",
                    id: "4",
                    click: dicomViewer.tools.doWindowLevel
                }, {
                    text: "Head/Neck",
                    id: "6",
                    click: dicomViewer.tools.doWindowLevel
                },{
                    text: "Lung",
                    id: "3",
                    click: dicomViewer.tools.doWindowLevel
                },{
                    text: "Custom",
                    id: "7",
                    click: dicomViewer.tools.doWindowLevel
                } ]
            }, {
                type: "splitButton",
                imageUrl: "../images/zoom.png",
                id: "zoomButton",
                title : 'Zoom',
                click: dicomViewer.tools.doZoom,
                menuButtons: [{
                    text: "100%",
                    id: "0_zoom",
                    click: dicomViewer.tools.doZoom
                }, {
                    text: "Fit to Window",
                    id: "1_zoom",
                    click: dicomViewer.tools.doZoom
                }, {
                    text: "Fit Width to Window",
                    id: "2_zoom",
                    click: dicomViewer.tools.doZoom
                }, {
                    text: "Fit Height-to Window",
                    id: "3_zoom",
                    click: dicomViewer.tools.doZoom
                }, {
                    text: "Zoom In",
                    id: "4_zoom",
                    click: dicomViewer.tools.doZoom
                }, {
                    text: "Zoom Out",
                    id: "5_zoom",
                    click: dicomViewer.tools.doZoom
                }, {
                    text: "Custom",
                    id: "6_zoom", 
                    click: dicomViewer.tools.doZoom
                }]
            }, {
                type: "button",
                id: "panButton",
                title : 'Pan',
                imageUrl: "../images/pan.png",
                click: dicomViewer.tools.doPan
            }, {
                type: "button",
                text: "",
                id: "rotateButton",
                title : 'Rotate',
                imageUrl: "../images/rotate.png",
                click: dicomViewer.tools.rotate
            }, {
                type: "splitButton",
                text: "",
                imageUrl: "../images/overlay.png",
                id: "overlayButton",
                title : 'Overlay',
                menuButtons: [{
                    text: "Overlay",
                    id: "overlay",
                     click: dicomViewer.tools.doOverLay
                }, {
                    text: "Cross Reference Line",
                    id: "scoutLine",
                    click: dicomViewer.tools.doScoutLine
                }, {
                    text: "Hide Annotation/Measurement",
                    id: "showHideAnnotaionAndMesurement",
                    click: dicomViewer.tools.doShowHideAnnotationAndMeasurement
                }, {
                    text: "Hide Overlay 6000",
                    id: "showHideOverlay6000",
                    click: dicomViewer.tools.doOverLay6000
                }]
            }, {
                type: "splitButton",
                text: "",
                imageUrl: "../images/settings.png",
                id: "EcgAndtemplateButton",
                title : 'Settings',
                click: dicomViewer.tools.menuSelection,
                menuButtons: [{
                    text: "ECG Preference",
                    id: "ecgPrefrence",
                    click: dicomViewer.tools.menuSelection
                },{
                    text: "Cine Preference",
                    id: "cinePreference",
                    click: dicomViewer.tools.menuSelection
                },{
                    text: "Measurement Preference",
                    id: "MeaaurementPreference",
                    click: dicomViewer.tools.menuSelection
                },{
                    text: "Display Preference",
                    id: "hangingProtocol",
                    click: dicomViewer.tools.showHangingProtocol
                },{
                    text: "Copy Attributes Preference",
                    id: "CopyAttributesPreference",
                    click: dicomViewer.tools.showCopyAttributesPreference
                }]
            }, {
                type: "splitButton",
                text: "",
                imageUrl: "../images/studyLevel.png",
                id: "studyLevel",
                title : 'Study Layout',
                menuButtons: createStudyLayoutMenu()
            }, {
                template: "<button type='button' id='measurementsButton' class='k-button k-button-icon'><img src=../images/measuremnet.png></button>"

            },{
                type: "splitButton",
                text: "",
                imageUrl: "../images/RGB.png",
                id: "RGBButton",
                title : 'RGB Tool',
                menuButtons: [{
                        text: "",
                        imageUrl: "../images/RGBColors.png",
                        id: "0_rgbAll",
                        click: dicomViewer.tools.rgbColor
                    }, {
                        text: "",
                        imageUrl: "../images/redColor.png",
                        id: "1_rgbRed",
                        click: dicomViewer.tools.rgbColor
                    }, {
                        text: "",
                        imageUrl: "../images/greenColor.png",
                        id: "2_rgbGreen",
                        click: dicomViewer.tools.rgbColor
                    }, {
                        text: "",
                        imageUrl: "../images/blueColor.png",
                        id: "3_rgbBlue",
                        click: dicomViewer.tools.rgbColor
                    }]
            }, {
                type: "button",
                id: "linkButton",
                title : 'Link',
                imageUrl: "../images/link.png",
                click: dicomViewer.tools.linkSeries
            }, {
                type: "button",
                id: "refreshButton",
                title : 'Refresh',
                imageUrl: "../images/refresh.png",
                click: dicomViewer.tools.revert
                
            }
        ]
    });

    customizeKendoSplitButton("EcgAndtemplateButton", "settings.png");
    customizeKendoSplitButton("RGBButton", "RGB.png");
    customizeKendoSplitButton("overlayButton", "overlay.png");
    changeOverflowBackground();

    pdfToolBarElement.kendoToolBar({
        items: [{
                type: "button",
                text: "",
                id: "firstPage",
                title : 'first Page',
                imageUrl: "../images/firstPage.png",
                click: dicomViewer.openFirstPage
            },{
                type: "button",
                text: "",
                id: "previousPage",
                title : 'Previous Page',
                imageUrl: "../images/previousPage.png",
                click: dicomViewer.openPreviousPage
            },{
                template: "<input type='text' onkeypress='return event.charCode >= 48 && event.charCode <= 57' id='pageNumber' class='k-textbox' style='width: 50px; height: 27px;border-radius:1px;font-size: 15px; text-align:center;background-color: rgba(50,60,60,0.6); border:2px solid #eaefef '><label id='totalPagesLabel' style='font-size: 15px;'> Of   </label>"
            },{
                type: "button",
                text: "",
                id: "nextPage",
                title : 'Next Page',
                imageUrl: "../images/nextPage.png",
                click: dicomViewer.openNextPage
            },{
                type: "button",
                text: "",
                id: "lastPage",
                title : 'Last Page',
                imageUrl: "../images/lastPage.png",
                click: dicomViewer.openLastPage
                }
            ]
    });

    playerToolBarElement.kendoToolBar({
        items: [{
                type: "button",
                id: "previousSeries",
                title : 'Previous Series',
                text: "",
                imageUrl: "../images/previous-series.png",
                click: previousSeries
            }, {
                type: "button",
                text: "",
                id: "previousImage",
                title : 'Previous Image',
                imageUrl: "../images/previous-image.png",
                click: dicomViewer.tools.moveToPreviousImage
            }, {
                type: "splitButton",
                text: "",
                id: "playButton",
                title : 'Play',
                imageUrl: "../images/play.png",
                click: playCineImage,
                menuButtons: [{
                    text: "Forward",
                    id: "playForward",
                    click: playCineImage
                }, {
                    text: "Backward",
                    id: "playBackward",
                    click: playCineImage
                }]
            }, {
                type: "button",
                text: "",
                id: "nextImage",
                title : 'Next Image',
                imageUrl: "../images/next-image.png",
                click: dicomViewer.tools.moveToNextImage
            }, {
                type: "button",
                text: "",
                id: "nextSeries",
                title : 'Next Series',
                imageUrl: "../images/next-series.png",
                click: nextSeries
            }, {
                type: "button",
                text: "",
                id: "repeteOption",
                title : 'Repeat Series',
                imageUrl: "../images/repeat.png",
                click: playRepeat
            }, {
                template: "<input id='cineSpeedButton' style='width: 95%;'/>"
            },{
                text: "",
                template: "<button rel='Frame rate' type='button' class='btn btn-default disabled' data-container='body' data-toggle='tooltip' data-placement='top' title='' data-original-title='Frame rate' style='border-color: #343434;background-color: transparent;'><span  id='cineRateDisplay' style='font-size: x-small; color: white; display: block;;max-width: 80px;min-width: 80px;'>0 FPS</span></button>"
            }
        ]
    });

    tiffToolBarElement.kendoToolBar({
        items: [{
            type: "button",
            id: "tPreviousSeries",
            title : 'Previous Series',
            text: "",
            imageUrl: "../images/previous-series.png",
            overflow:"auto",
            click: previousSeries
        }, {
            type: "button",
            text: "",
            id: "tPreviousImage",
            title : 'Previous Image',
            overflow:"auto",
            imageUrl: "../images/previous-image.png",
            click: dicomViewer.tools.moveToPreviousImage
        }, {
            template: "<label id='totalPages' data-overflow='never' style='font-size: 13px;width: 62px;text-align: center'> Of </label>"
        },{
            type: "button",
            text: "",
            id: "tNextImage",
            title : 'Next Image',
            overflow:"auto",
            imageUrl: "../images/next-image.png",
            click: dicomViewer.tools.moveToNextImage
        }, {
            type: "button",
            text: "",
            id: "tNextSeries",
            title : 'Next Series',
            overflow:"auto",
            imageUrl: "../images/next-series.png",
            click: nextSeries
        }]
    });

    // Toolbar measurement and annotation, Handling the mouse event
     $("#toolbar_measurementAnnotation").kendoContextMenu({
         target: "#measurementsButton",
         showOn: "click",
         open: function(e) {
             if($(e.target).hasClass('k-state-disabled')) {
                 e.preventDefault();
             }
         },
         close: function() {
             hideAnimationContainer();
         }
    });

    // Toolbar measurement and annotation, Handling the touch event
     $("#toolbar_measurementAnnotation").kendoContextMenu({
         target: "#measurementsButton",
         showOn: "touchstart",
         open: function(e) {
             $("#4_measurement").click(function() {
                 // While clicking on Delete All button hiding the drop-down menu
                 hideAnimationContainer();
                 return;
             })
             if(isMobileDevice() && (e.item)[0] != undefined) {
                 hideAnimationContainer();
             }
             if($(e.target).hasClass('k-state-disabled')) {
                 e.preventDefault();
             }
         },
         close: function() {
             if(isMobileDevice()) {
                 hideAnimationContainer();
             }
         }
    });

    $(".k-dropdown").change(function() {
        var parentId = $(".k-state-border-down").context.activeElement.childNodes[1].id;
        var value = $("#" + parentId).val();
        var rowAndColume = value.split("x");
        if (parentId === "studyLevel") {
            dicomViewer.tools.changeStudyLayout(rowAndColume[0], rowAndColume[1]);
        }
    });

    myLayout = $('body').layout({
        // enable showOverflow on west-pane so popups will overlap north pane
        togglerLength_open: 0,
        togglerLength_closed: "100%",
        west__showOverflowOnHover: true,
        west__minSize: THUMBNAIL_PANEL_WIDTH,
        north__minSize: 77,
        north__maxSize: 90,
//        south__minSize: 53,
//        south__maxSize: 70,
        west__onopen: reloadViewPort,
        west__onclose:  dicomViewer.thumbnail.closeThumbnailPanel,
        west__onopen_start: function () {
          defaultViewportInThumbnailViewHiddenMode = dicomViewer.getActiveSeriesLayout().getSeriesLayoutId();
        },
        north__resizable: false,
//        south__resizable: false,
        north__spacing_open: 0,
        north__spacing_closed: 0,
//        south__spacing_open: 0,
//        south__spacing_closed: 0,
        west__spacing_open: 4
    });
//    loadSpinner();
    myLayout.sizePane("west", (isInternetExplorer() ? 145 : 137));
    var north = (WINDOWHEIGHT*70)/1024;
    myLayout.sizePane("north", north);

    $("#_viewer").hide();
    $("#MeaaurementPreferenceModal").dialog({
        autoOpen: false,
        height: 325,
        width: 350,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function() {
                var elements = document.getElementsByName("color");
                var selectedColor = dicomViewer.measurement.draw.getMeasurementColour();
                $.each(elements, function(key, value) {
                    if(value.checked === true) {
                        selectedColor = value.value;
                        return false;
                    }
                });

                dicomViewer.measurement.draw.setMeasurementColour(selectedColor);
                dicomViewer.tools.saveMeasurementPreference(selectedColor);
                $(this).dialog("close");
            },
            Cancel: function() {
                $(this).dialog("close");
            }
        },
        open: function() {
            $("#MeaaurementPreferenceModal").unbind('keypress');
            $("#MeaaurementPreferenceModal").keypress(function(e) {
              if (e.keyCode == 13) {
                $(this).parent().find("button:eq(0)").trigger("click");
              }
            });

            try
            {
                var elements = document.getElementsByName("color");
                var defaultColor = dicomViewer.measurement.draw.getMeasurementColour();
                $.each(elements, function(key, value) {
                    if(value.value === defaultColor) {
                        value.checked = true;
                        value.focus();
                        return false;
                    }
                });
            }
            catch(e)
            { }
        }
    });

    $("#dicomHeaderAttributes").dialog({
        autoOpen: false,
        height: WINDOWHEIGHT * 0.8,
        width: WINDOWWIDTH * 0.8,
        modal: true,
        resizable: false,
        buttons: {
            Close: function() {
                $(this).dialog("close");
//                dicomViewer.pauseCinePlay(0,true);
            }
        }
    });
    $("#dicomHeaderAttributes").on('dialogclose', function(event) {
//        dicomViewer.pauseCinePlay(0,true);
    });

    $("#imagingData").dialog({
        autoOpen: false,
        height: WINDOWHEIGHT * 0.8,
        width: WINDOWWIDTH * 0.8,
        modal: true,
        resizable: false,
        buttons: {
            Close: function() {
                $(this).dialog("close");
//                dicomViewer.pauseCinePlay(0,true);
            }
        }
    });
    $("#imagingData").on('dialogclose', function(event) {
//        dicomViewer.pauseCinePlay(0,true);
    });

    $("#EcgPreference").dialog({
        autoOpen: false,
        height: 310,
        width: 350,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function() {
                $(this).dialog("close");
            },
            Cancel: function() {
                $(this).dialog("close");
            }
        },
        open: function() {
            $("#EcgPreference").unbind('keypress');
            $("#EcgPreference").keypress(function(e) {
                if (e.keyCode == 13) {
                    $(this).parent().find("button:eq(0)").trigger("click");
                }
            });
        }
    });
    
    //While changing the ECG lead signal type values, updating the lead object values over the default
    $("#EcgPreference").change(function(event) {
        var seriesLayout = dicomViewer.getActiveSeriesLayout();
        var layoutDivId = seriesLayout.getSeriesLayoutId();
        seriesLayout.leadValue[event.target.id] = event.target.value;
        leadTypeObject[layoutDivId] = $.extend({}, leadTypeObject[layoutDivId], seriesLayout.leadValue);
    });

    $('div#cinePreferenceModal').on('dialogclose', function(event) {
        $("#cinePreferenceAlert").html("");
    });

    $("#viewerVersionInfoModal").dialog({
        autoOpen: false,
        height: WINDOWHEIGHT * 0.6,
        width: WINDOWWIDTH * 0.8,
        modal: true,
        resizable: false,
        buttons: {
            "Close": function() {
                $(this).dialog("close");
            }
        }
    });

    $('div#viewerVersionInfoModal').on('dialogclose', function(event) {
//        dicomViewer.pauseCinePlay(0,true);
    });

    $("#cinePreferenceModal").dialog({
        autoOpen: false,
        height: 260,
        width: 450,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function() {
                var element = document.getElementById("palyselection");
                var playType = element.options[element.selectedIndex].value;
                var framesToRepeat = document.getElementById("framesToRepeat").value;
                var timesToRepeat = document.getElementById("timesToRepeat").value;
                var idleTime = document.getElementById("idleTime").value;
                
                if (timesToRepeat != "") {
                    if(!timesToRepeat.match(/^\d+/))
                    {
                        timesToRepeat ="";
                    }
                    else
                    {
                        timesToRepeat = parseInt(timesToRepeat);
                        if(timesToRepeat > 500 || timesToRepeat < 1) timesToRepeat = "";
                    }
                }

                if (timesToRepeat === "") {
                    $("#cinePreferenceAlert").removeClass('alert-info').addClass('alert-danger');
                    $("#cinePreferenceAlert").html('Please only enter numeric characters only for number of times! (Allowed:1-500)');
                    return;
                }
                if (framesToRepeat != "") {
                    if(!framesToRepeat.match(/^\d+/))
                    {
                        framesToRepeat ="";
                    }
                    else
                    {
                        framesToRepeat = parseInt(framesToRepeat);
                        if(framesToRepeat > 500 || framesToRepeat < 1) framesToRepeat = "";
                    }
                }

                if (framesToRepeat === "") {
                    $("#cinePreferenceAlert").removeClass('alert-info').addClass('alert-danger');
                    $("#cinePreferenceAlert").html('Please only enter numeric characters only for frames to repeast!  (Allowed:1-500)');
                    return;
                }
                if (idleTime != "") {
                    if(!idleTime.match(/^\d+/))
                    {
                        idleTime ="";
                    }
                    else
                    {
                        idleTime = parseInt(idleTime);
                        if(idleTime > 500 || idleTime < 1) idleTime = "";
                    }
                }

                if (idleTime === "") {
                    $("#cinePreferenceAlert").removeClass('alert-info').addClass('alert-danger');
                    $("#cinePreferenceAlert").html('Please only enter numeric characters only for idle time! (Allowed:1-500)');
                    return;
                }
                $("#cinePreferenceAlert").html('');
                dicomViewer.configuration.cine.setCinePlayerPlayBy(playType);
                cineplayBy(playType)
                dicomViewer.configuration.cine.setFramesToRepeat(framesToRepeat);
                dicomViewer.configuration.cine.setTimesToRepeat(timesToRepeat);
                dicomViewer.configuration.cine.setIdleTime(idleTime);
                $(this).dialog("close");
            },
            Cancel: function() {
                $(this).dialog("close");
            }
        },
        open: function() {
            $("#cinePreferenceModal").unbind('keypress');
            $("#cinePreferenceModal").keypress(function(e) {
              if (e.keyCode == 13) {
                $(this).parent().find("button:eq(0)").trigger("click");
              }
            });
        }
    });

    $('div#dialog-form').on('dialogclose', function(event) {
        $("#alert").html("");
    });
    
    $("#lengthCalibrationAlert").removeClass('alert-info');
    $("#lengthCalibrationModal").dialog({
        autoOpen: false,
        height: 240,
        width: 270,
        modal: true,
        resizable: false,
        beforeClose: function(event) {
        if (event.keyCode === $.ui.keyCode.ESCAPE) {
                dicomViewer.measurement.deleteSelectedMeasurment();
            }
        },
        buttons: {
            "Ok": function() {
                var element = document.getElementById("unit");
                var strUnits = element.options[element.selectedIndex].value;
                var calibrateLength = document.getElementById("calibrateLength").value;
                var checkedValue = document.getElementById('applyToAllImages').checked;
                $("#lengthCalibrationAlert").html('');
                
                var errorMessage = validateInputLenght(calibrateLength, strUnits);
                
                if(errorMessage != null ){
                    $("#lengthCalibrationAlert").removeClass('alert-info').addClass('alert-danger');
                    $("#lengthCalibrationAlert").html(errorMessage);
                    return;
                }
                    
                calculatePixelSpacing(calibrateLength, strUnits, checkedValue);
                
                $(this).dialog("close");

                if(dicomViewer.tools.getLengthCalibrationFlag()){
                    var seriesLayout = dicomViewer.getActiveSeriesLayout();
                    var calibratedValues = getUnitMeasurementMap(seriesLayout.studyUid+"|"+seriesLayout.seriesIndex+"|"+seriesLayout.scrollData.imageIndex+"|"+seriesLayout.scrollData.frameIndex);

                    if(seriesLayout != undefined){
                        var studyUid = seriesLayout.getStudyUid();
                        var image = dicomViewer.Series.Image.getImage(studyUid, seriesLayout.seriesIndex,seriesLayout.getImageIndex());
                        var imageUid = dicomViewer.Series.Image.getImageUid(image);
                        if(imageUid != undefined){
                            var dicomHeader = dicomViewer.header.getDicomHeader(imageUid);
                            if(dicomHeader.imageInfo.measurement.pixelSpacing != null && dicomHeader.imageInfo.measurement.pixelSpacing != undefined){
                                if(dicomHeader.imageInfo.measurement.pixelSpacing.row <= 0 && calibratedValues != null){
                                    var measurementData =  dicomViewer.measurement.getMeasurements(imageUid, seriesLayout.scrollData.frameIndex);
                                    measurementData[0].measurementComplete = true;
                                    var type = {id : "0_measurement"};
                                    dicomViewer.tools.do2DMeasurement(type);
                                }
                            }
                        }
                    }
                } else {
                    dicomViewer.measurement.deleteSelectedMeasurment();
                }
            },
            "Close": function() {
                $("#lengthCalibrationAlert").removeClass('alert-info');
                $("#lengthCalibrationAlert").removeClass('alert-danger');
                $("#lengthCalibrationAlert").empty();
                $(this).dialog("close");
                dicomViewer.measurement.deleteSelectedMeasurment();
            }
        },
        open: function() {
            $("#lengthCalibrationModal").unbind('keypress');
            $("#lengthCalibrationModal").keypress(function(e) {
              if (e.keyCode == 13) {
                $(this).parent().find("button:eq(0)").trigger("click");
              }
            });
        }
    });

    $("#hpModal").dialog({
        autoOpen: false,
        height: 340,
        width: 410,
        modal: true,
        resizable: false,
        buttons: {
            "Add": function() {
                dicomViewer.tools.addHangingProtocol();
            },
            "Close": function() {
                // Enable the modality combo box 
                dicomViewer.tools.enableHPControls();
                $(this).dialog("close");
            }
        },
        open: function() {
            $("#hpModal").unbind('keypress');
            $("#hpModal").keypress(function(e) {
              if (e.keyCode == 13) {
                $(this).parent().find("button:eq(0)").trigger("click");
              }
            });
        }
    });

    $("#copyAttributesPreference").dialog({
        autoOpen: false,
        height: 260,
        width: 260,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function() {
                var copyAttributes = {
                    windowLevel: true,
                    pan: true,
                    scale: true,
                    invert: true,
                    orientation: true
                }
                copyAttributes.windowLevel = document.getElementById("copyAttributes_WindowLevel").checked;
                copyAttributes.pan = document.getElementById("copyAttributes_Pan").checked;
                copyAttributes.scale = document.getElementById("copyAttributes_Scale").checked;
                copyAttributes.invert = document.getElementById("copyAttributes_Invert").checked;
                copyAttributes.orientation = document.getElementById("copyAttributes_Orientation").checked;
                dicomViewer.configuration.cine.setCopyAttributes(copyAttributes);
                $(this).dialog("close");
            },
            "Close": function() {
                $(this).dialog("close");
            }
        },
        open: function() {
            $("#copyAttributesPreference").unbind('keypress');
            $("#copyAttributesPreference").keypress(function(e) {
                if (e.keyCode == 13) {
                    $(this).parent().find("button:eq(0)").trigger("click");
                }
            });
        }
    });

    $("#addMoreHPModal").dialog({
        autoOpen: false,
        height: 270,
        width: 320,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function() {
                var key, val = "";
                var element = document.getElementById("modalityList");
                var key = element.options[element.selectedIndex].value;
                
                var elements = ["layoutRows", "layoutColumns", "zoomModeValues","useEmbedPDFViewer"];
                for(i=0;i<elements.length;i++) {
                    var el = document.getElementById(elements[i]);
                    val += el.options[el.selectedIndex].value + ",";
                }
                
                val = val.substring(0, val.length - 1).split(",");

                if(key === "General") {
                  isEmbedPdfViewer = (val[3] == undefined) ? isEmbedPdfViewer : (val[3] == "false" ? false : true);
                }

                var tdAction = '"<td><img src="images/edit.png" height="16" size="16" alt="edit" onclick="dicomViewer.tools.editHP(this)"><img src="images/delete.png" height="16" size="16" alt="delete" onclick="dicomViewer.tools.deleteHP(this)"></td>;"'

                // Check whether the modality is already present and update the new settings. 
                var isExistingModality = false;
                $("#hpTableList").find('tr').each(function (i, el) {
                    var tdData = $(this).find('td');
                    if(tdData.length >= 4){
                        var modality = tdData.eq(0).text();
                        if(modality == key){
                            isExistingModality = true;
                            tdData.eq(1).html(val[0]);
                            tdData.eq(2).html(val[1]);
                            tdData.eq(3).html(val[2]);
                            return true;
                        }
                    }
                });

                // Add the new modality settings 
                if(!isExistingModality){
                    var tr;
                    tr = $('<tr/>');
                    tr.append("<td>" + key + "</td>");
                    tr.append("<td>" + val[0] + "</td>");
                    tr.append("<td>" + val[1] + "</td>");
                    tr.append("<td>" + val[2] + "</td>");
                    tr.append(tdAction);
                    $("#hpTableList").append(tr);
                }

                // Enable the modality combo box 
                dicomViewer.tools.enableHPControls();
                
                // Save the settings
                dicomViewer.tools.saveSettings();
                $(this).dialog("close");
            },
            "Close": function() {
                // Enable the modality combo box 
                dicomViewer.tools.enableHPControls();
                $(this).dialog("close");
            }},
        open: function() {
            $("#addMoreHPModal").unbind('keypress');
            $("#addMoreHPModal").keypress(function(e) {
              if (e.keyCode == 13) {
                $(this).parent().find("button:eq(0)").trigger("click");
              }
            });
        },
            close: function() {
                // Enable the modality combo box 
                dicomViewer.tools.enableHPControls();
            }
    });	

    var allFields = $([]).add($("#row")).add($("#column"));
    $("#dialog-form").dialog({
        autoOpen: false,
        height: 300,
        width: 250,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function() {
                var columValue = $("#column").val();
                var rowValue = $("#row").val();

                if (rowValue != "") {
                    rowValue = parseInt(rowValue);
                }

                if (rowValue === "") {
                    $("#alert").removeClass('alert-info').addClass('alert-danger');
                    $("#alert").html('Row value is empty');
                    return;
                } else if (3 < rowValue) {
                    $("#alert").removeClass('alert-info').addClass('alert-danger');
                    $("#alert").html('Row support max 3');
                    return;
                } else if (rowValue <= 0) {
                    $("#alert").removeClass('alert-info').addClass('alert-danger');
                    $("#alert").html('Row value is invalid');
                    return;
                }
                if (columValue != "") {
                    columValue = parseInt(columValue);
                }
                if (columValue === "") {
                    $("#alert").removeClass('alert-info').addClass('alert-danger');
                    $("#alert").html('Column value is empty');
                    return;
                } else if (3 < columValue) {
                    $("#alert").removeClass('alert-info').addClass('alert-danger');
                    $("#alert").html('Column support max 3');
                    return;
                } else if (columValue <= 0) {
                    $("#alert").removeClass('alert-info').addClass('alert-danger');
                    $("#alert").html('Column value is invalid');
                    return;
                }

                if (rowValue != "" && columValue != "" && rowValue < 4 && columValue < 4) {
                    dicomViewer.tools.changeSeriesLayout($("#row").val(), $("#column").val(), customSeriesLayout);
                    $(this).dialog("close");
                }
            },
            Cancel: function() {
                $(this).dialog("close");
            }
        },
        open: function() {
            $("#dialog-form").unbind('keypress');
            $("#dialog-form").keypress(function(e) {
              if (e.keyCode == 13) {
                $(this).parent().find("button:eq(0)").trigger("click");
              }
            });
        },
        close: function() {
            $("#alert").removeClass('alert-danger');
            $("#alert").removeClass('alert-info');
            $("#alert").empty();
            allFields.val("").removeClass("ui-state-error");
        }
    });

    $('#colorpicker').on('change', function() {
        dicomViewer.measurement.draw.setMeasurementColour(this.value);
    });


    //For Custom Window level get the WW and WC from the user and apply it.
    var windowLevelFields = $([]).add($("#width")).add($("#center"));
    $("#alert-WL").removeClass('alert-info');
    $("#customWindowLevel").dialog({
        autoOpen: false,
        height: 300,
        width: 250,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function() {
                var widthValue = $("#width").val();
                var centerValue = $("#center").val();

                if (centerValue === "" ||  widthValue === ""){
                    $("#alert-WL").removeClass('alert-info').addClass('alert-danger');
                    $("#alert-WL").html('value cannot be empty');
                    return;
                } 

                centerValue = parseInt(centerValue);
                widthValue = parseInt(widthValue);

                if ((32767 < centerValue) || (-32767 > centerValue)) {
                    $("#alert-WL").removeClass('alert-info').addClass('alert-danger');
                    $("#alert-WL").html('Center value must be between -32767 and 32767');
                    return;
                } 
                if ((65535< widthValue) || (1 > widthValue)) {
                    $("#alert-WL").removeClass('alert-info').addClass('alert-danger');
                    $("#alert-WL").html('Width value must be between 1 and 65535');
                    return;
                }

                // Check if the value is in the desired limits and apply the 
                if (centerValue != "" && widthValue != "" && 32768 > centerValue && -32768 < centerValue && 65536 > widthValue && 0 < widthValue) {
                    var presetValue = customWindowLevelID + "_" + centerValue + "_" + widthValue;
                    dicomViewer.tools.changePreset(presetValue);
                    $(this).dialog("close");
                }
            },
            Cancel: function() {
                $(this).dialog("close");
            }
        },
        open: function() {
            $("#customWindowLevel").unbind('keypress');
            $("#customWindowLevel").keypress(function(e) {
              if (e.keyCode == 13) {
                $(this).parent().find("button:eq(0)").trigger("click");
              }
            });
        },
        close: function() {
            $("#alert-WL").removeClass('alert-danger')
            $("#alert-WL").empty();
            windowLevelFields.val("").removeClass("ui-state-error");
        }
    });

    //For Custom zoom get the zoom% from user and apply it.
    var zoomFields = $([]).add($("#zoomValue"));
    $("#alert-zoom").removeClass('alert-info');
    $("#zoom-form").dialog({
        autoOpen: false,
        height: 300,
        width: 250,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function() {
                var zoomValue = $("#zoomValue").val();

                if (zoomValue === "") {
                    $("#alert-zoom").removeClass('alert-info').addClass('alert-danger');
                    $("#alert-zoom").html('Zoom value is empty');
                    return;
                } 
                zoomValue = parseInt(zoomValue);

                if ((5 > zoomValue) || (800 < zoomValue)) {
                    $("#alert-zoom").removeClass('alert-info').addClass('alert-danger');
                    $("#alert-zoom").html('Zoom value must be between 5 and 800');
                    return;
                } 
                if (zoomValue <= 0) {
                    $("#alert-zoom").removeClass('alert-info').addClass('alert-danger');
                    $("#alert-zoom").html('Zoom value is invalid');
                    return;
                }

                if (zoomValue != "" && zoomValue > 4 && zoomValue < 801) {
                    var zoomData = customZoomlID + "-" + zoomValue;
                    dicomViewer.tools.setZoomLevel(zoomData);
                    
                    //For changing the background color for the custom zoom button of tool bar as well as context menu
                    $("#"+customZoomlID).parent().css("background","#868696");
                    $("#"+customZoomlID+"ContextMenu").css("background","#868696");
                    
                    $(this).dialog("close");
                }
            },
            Cancel: function() {
                $(this).dialog("close");
            }
        },
        open: function() {
            $("#zoom-form").unbind('keypress');
            $("#zoom-form").keypress(function(e) {
              if (e.keyCode == 13) {
                $(this).parent().find("button:eq(0)").trigger("click");
              }
            });
        },
        close: function() {
            $("#alert-zoom").removeClass('alert-danger')
            $("#alert-zoom").empty();
            zoomFields.val("").removeClass("ui-state-error");
        }
    });

    //For save the presentation state in edit mode
    var SavePFields = $([]).add($("#presentationName"));
    $("#alert-edit-PState").removeClass('alert-info');
    $("#edit-PState").dialog({
        autoOpen: false,
        width: 325,
        modal: true,
        resizable: false,
        buttons: {
            "Ok": function() {
                dicomViewer.measurement.updateActivePStateDescription($("#editPStateDescription").val());
                $(this).dialog("close");
            },
            Cancel: function() {
                $(this).dialog("close");
            }
        },
        open: function() {
            $("#edit-PState").unbind('keypress');
            $("#edit-PState").keypress(function(e) {
              if (e.keyCode == 13) {
                $(this).parent().find("button:eq(0)").trigger("click");
              }
            });
        },
        close: function() {
            $("#alert-edit-PState").removeClass('alert-danger')
            document.getElementById("alert-edit-PState").style.display="none";
            $("#alert-edit-PState").empty();
            SavePFields.val("").removeClass("ui-state-error");
        }
    });

    $.fn.center = function (viewPortId) {
        this.css("position","absolute");
        var topOffset = $("#"+viewPortId).offset().top
        var leftOffset = $("#"+viewPortId).offset().left
        var viewportHeight = ($("#"+viewPortId).height())-40;
        var viewportWidth = (($("#"+viewPortId).width())-300);
        this.css("top", ((viewportHeight)/2+topOffset)+"px");
        this.css("left", ((viewportWidth)/2+leftOffset)+"px");
      return this;
    }

    $("#contextMenuThumbnailPanel").kendoContextMenu({
            target: "#imageThumbnail_View",
            open: function(e) {
                if(showStudyCacheIndicator) {
                    $(".cacheindicator").text("Hide Cache Indicator");
                } else {
                    $(".cacheindicator").text("Show Cache Indicator");
                }
                $("#contextMenuThumbnailPanel").width(130);
            }
        });

    $("#contextMenu").kendoContextMenu({
        target: "#viewport_View",
        open: function(e) {
            var layoutId = dicomViewer.getActiveSeriesLayout().getSeriesLayoutId();
            var visibility = "visible";
            if(dicomViewer.scroll.isCineRunning(layoutId)) {
                e.preventDefault();
                visibility = "hidden";
            }
            // To get the context edit measurement menu for mobile devices
            var tool = dicomViewer.mouseTools.getActiveTool();
            tool.hanleMouseUp(e);
            document.getElementById("contextMenu").style.visibility = visibility;
            $("#contextMenu").width(120);
            $("#zoomInSR").hide();
            $("#zoomOutSR").hide();
            var layoutID;
            var currentLayoutID = e.event;
            if(e.event === undefined ||currentLayoutID === "" || currentLayoutID === undefined)
                layoutID = layoutId;
            else {
                layoutID = e.event.target.parentElement.id;
                selectedViewerId = layoutID;
            }
            
            if(layoutID === undefined || layoutID === "") {
                e.preventDefault();
                return;
            }
            
            var currentSeriesId = layoutID.replace("ImageLevel0x0", "");
            currentSeriesId = currentSeriesId.replace("ImageLevel1x1", "");
            currentSeriesId = currentSeriesId.replace("ImageLevel1x0", "");
            currentSeriesId = currentSeriesId.replace("ImageLevel0x1", "");
            currentSeriesId = currentSeriesId.replace("imageEcgDiv", "");
            currentSeriesId = currentSeriesId.replace("id", "");
            currentSeriesId = currentSeriesId.replace("SRimageviewer", "imageviewer");
            currentSeriesId = currentSeriesId.replace("imagePdfDiv","");

            dicomViewer.changeSelection(currentSeriesId);
            var seriesLayout = dicomViewer.viewports.getViewport(currentSeriesId);
            var seriesIndex = seriesLayout.getSeriesIndex();
            var imageIndex = seriesLayout.getImageIndex();
            
            var layout = dicomViewer.getActiveSeriesLayout();
            disableOrEnableRGBTools();
            $("#context-volume").hide();
            if (layout.imageType === undefined || layout.imageType === null) {
                e.preventDefault();
            }

            $("#context-edit").hide();
            $("#context-delete").hide();
            $("#context-deleteAll").hide();
            if (layout.imageType === IMAGETYPE_RADECG) {
                showOrHideEcgMenue(true);
                showOrHideDicomMenu(false);
            //} else if (layout.imageType === IMAGETYPE_BLOB || layout.imageType === IMAGETYPE_RADPDF) {
            //    e.preventDefault();
            } else if( !isEmbedPdfViewer && (layout.imageType === IMAGETYPE_PDF || layout.imageType === IMAGETYPE_RADPDF) ) {
                showOrHideDicomMenu(false)
                showOrHideEcgMenue(false);
                $("#context-zoom").show();
            } else if (isBlob(layout.imageType) || 
                       (layout.imageType === IMAGETYPE_CDA)) {
                e.preventDefault();
            } else if (layout.imageType === IMAGETYPE_RADSR) {
                showOrHideDicomMenu(false)
                showOrHideEcgMenue(false);
                $("#zoomInSR").show();
                $("#zoomOutSR").show();
            } else {
                showOrHideEcgMenue(false);
                dicomViewer.link.updateLinkMenu();
                var dataToEdit = dicomViewer.measurement.getDataToDelete();

                if (layout.imageType === IMAGETYPE_JPEG && (dataToEdit.keyId === "" || !dicomViewer.tools.isShowAnnotationandMeasurement())) {
                    showOrHideDicomMenu(false);
                    showOrHideEcgMenue(false);
                    dicomViewer.tools.doDefault();
                    $("#context-pan").show();
                    $("#context-zoom").show();
                    $("#context-annotation").show();
                    enableOrDisableAnnotationTools(true);
                }
                else if (dataToEdit.keyId === "" || !dicomViewer.tools.isShowAnnotationandMeasurement()) {
                    if(seriesIndex !== undefined && imageIndex !== undefined) {
                        dicomViewer.tools.doDefault();
                        var modality = dicomViewer.Series.getModality(layout.studyUid, layout.seriesIndex);
                        showOrHideDicomMenu(true, modality);
                    } else {
                        showOrHideDicomMenu(false);
                    }
                } else {
                    showOrHideDicomMenu(false);
                    if (dataToEdit.isEditable) {
                        $("#context-edit").show();
                        $("#context-delete").show();
                        $("#context-deleteAll").show();
                        //For hiding the context print option while editing
                        $("#context-print").hide();
                        $("#printButton").addClass("k-state-disabled");//VAI-307
                    } else {
                        document.getElementById("contextMenu").style.visibility = "hidden";
                    }
                }
            }
        }
    });

    updateToolTip($("#winL_wrapper"),"WW/WC");
    updateToolTip($("#zoomButton_wrapper"), "Zoom");
    updateToolTip($("#AutoWinLButton"),"Auto Window/Level");
    updateToolTip($("#invertButton"),"Invert");
    updateToolTip($("#panButton"),"Pan");
    updateToolTip($("#rotateButton"),"Rotate");
    updateToolTip($("#flipVButton"),"Flip Horizontal");
    updateToolTip($("#flipHButton"),"Flip Vertical");
    updateToolTip($("#dicomheaderButton_wrapper"),"View Image Info");
    updateToolTip($("#overlayButton_wrapper"),"Overlay");
    updateToolTip($("#EcgAndtemplateButton_wrapper"),"Settings");
    updateToolTip($("#studyLevel_wrapper"),"Study Layout");
    updateToolTip($("#measurementsButton"),"Measurements/Annotations");
    updateToolTip($("#RGBButton_wrapper"),"RGB Tool");
    updateToolTip($("#refreshButton"),"Refresh");
    updateToolTip($("#previousSeries"),"Previous Series");
    updateToolTip($("#previousImage"),"Previous Image");
    updateToolTip($("#playButton_wrapper"),"Play");
    updateToolTip($("#nextImage"),"Next Image");
    updateToolTip($("#nextSeries"),"Next Series");
    updateToolTip($("#repeteOption"), "Repeat Study");
    updateToolTip($("#nextPage"),"Next Page");
    updateToolTip($("#previousPage"),"Previous page");
    updateToolTip($("#lastPage"),"Last Page");
    updateToolTip($("#firstPage"), "Fisrt Page");
    updateToolTip($("#linkButton"), "Link");
    updateToolTip($(".k-overflow-anchor.k-button"), "More Options");
});

/**
 *@param parentElementId
 *@param imageSrc
 *To Customize the Kendo toolbar button
 */
function customizeKendoSplitButton(parentElementId, imageSrc) {
    $("#" + parentElementId).hide();
    var childElement = $("#" + parentElementId + "_wrapper");
    var measurementElement = document.getElementById(parentElementId + "_wrapper");
    var lastChild = measurementElement.children[1];
    var lastChildStyle = lastChild.style;
    lastChildStyle.borderRadius = "4px";
    lastChild.innerHTML = "<img src='../images/" + imageSrc + "'>";
    lastChild.classList.add("k-button-icon");
    lastChild.lastChild.classList.add("k-image");
}

/**
 * Update the toolbar arrow button on selecting the viewport based on modality.
 * @param {Type} parentElement - selector parent element id
 * @param {Boolean} flag - True to disable; False to enable
 */
function updateKendoArrowButton(parentElement, flag) {
    var buttonId = parentElement[0].id;
    var arrowButtonElements = $(".k-split-button-arrow");
    $.each(arrowButtonElements, function(index, value) {
        if(buttonId === value.parentNode.id) {
            if(flag) {
                arrowButtonElements[index].classList.add("k-state-disabled");
            } else {
                arrowButtonElements[index].classList.remove("k-state-disabled");
            }
            return false;
        }
    });
}

/**
 * Update the context menu arrow button based on modality.
 * @param {Type} parentElement - selector parent element id
 * @param {Boolean} flag - True to disable; False to enable
 */
function updateContextMenuArrowButton(parentElement, flag) {
    var arrowClassList = parentElement[0].childNodes[1].classList;
    if(flag) {
        arrowClassList.remove("k-icon");
    } else {
        arrowClassList.add("k-icon");
    }
}

/**
 * Update the toolbar icon image on resizing window for more button
 * @param {Type} element - Overflow element id
 * @param {Type} currentImage - Current icon image
 * @param {Type} newImage - Updated icon image
 * @param {Boolean} isAddClass - Is disabled or enabled
 */ 
function updateImageOverflow(element, currentImage, newImage, isAddClass){
    var imageElement = element.find('img');
    var replacedSrc = imageElement.attr('src').replace(currentImage, newImage);
    imageElement.attr('src', replacedSrc);
    if (isAddClass) {
        element.hide();
    } else {
        element.show();
    }
    $(element).css("background-color", "#363636");
}

/**
 * enable or disable RGB Tool from context menu and tool bar
 */
function disableOrEnableRGBTools(){
    // Hide the RGB context menu item while hittest the measurement
    var dataToEdit = dicomViewer.measurement.getDataToDelete();
    if (dataToEdit.keyId != ""){
        $("#context-RGBTool").hide();
        return;
    }

    var photometricInterpretationValue = undefined;
    var imageUid = undefined;
    var rgbElement = $("#RGBButton_wrapper");
    var RGBButton_Overflow = $("#RGBButton_overflow");
    var rgbAll_overflow = $("#0_rgbAll_overflow");
    var rgbRed_overflow = $("#1_rgbRed_overflow");
    var rgbGreen_overflow = $("#2_rgbGreen_overflow");
    var rgbBlue_overflow = $("#3_rgbBlue_overflow");

    //Hide the RGB sub menu options in the tool bar using more button
    rgbAll_overflow.hide();
    rgbRed_overflow.hide();
    rgbGreen_overflow.hide();
    rgbBlue_overflow.hide();

    var enableRGBTool = isColorImage();

    if (enableRGBTool) {
        $("#context-RGBTool").show();
        rgbAll_overflow.show();
        rgbRed_overflow.show();
        rgbGreen_overflow.show();
        rgbBlue_overflow.show();
    }
    else{
        $("#context-RGBTool").hide();
    }
    changeToolbarIcon(rgbElement, "RGB.png", "RGB.png", !enableRGBTool);
    updateImageOverflow(RGBButton_Overflow, "RGB.png", "RGB.png", !enableRGBTool);
    updateImageOverflow(rgbAll_overflow, "RGBColors.png", "RGBColors.png", !enableRGBTool);
    updateImageOverflow(rgbRed_overflow, "redColor.png", "redColor.png", !enableRGBTool);
    updateImageOverflow(rgbGreen_overflow, "greenColor.png", "greenColor.png", !enableRGBTool);
    updateImageOverflow(rgbBlue_overflow, "blueColor.png", "blueColor.png", !enableRGBTool);
}

/**
 * Show or Hide the dicom tools only for dicom images on loading of the viewport.
 * Called every time on selection of the viewport for dicom images.
 * @param {Boolean} flag
 */ 
function disableOrEnableDicomTools(flag) {
	disableOrEnableRGBTools();
    $("#0_zoom").show();
    $("#1_zoom").show();
    $("#2_zoom").show();
    $("#3_zoom").show();
    $("#4_zoom").hide();
    $("#5_zoom").hide();
    $("#6_zoom").show();

    $("#colorPalet").show();
	$("#dicomImageHeader").show();
    $("#ecgPrefrence").hide();
	$("#cinePreference").show();
    $("#CopyAttributesPreference").show();
	$("#MeaaurementPreference").show();
    $("#overlay").show(); //overlay
    $("#scoutLine").show(); //cross reference line
    $("#scoutLine_overflow").show(); //cross reference line 
    $("#showHideAnnotaionAndMesurement").show(); // Show/Hide the annotations/measurements
    $("#showHideAnnotaionAndMesurement_overflow").show(); // Show/Hide the annotations/measurements
    $("#overlay_overflow").show(); //overlay

    $("#2_measurement").hide(); //Trace Measurement
    $("#tool_hounsfield").hide(); //Hounsfield 
    $("#copyAttributes_tr_WL").show();
    $("#copyAttributes_tr_Invert").show();
    
    $("#ecgPrefrence_overflow").hide();
    $("#cinePreference_overflow").show();
    $("#CopyAttributesPreference_overflow").show();
    $("#MeaaurementPreference_overflow").show();
    
    $("#1_ww_wcContextMenu").hide();
    $("#2_ww_wcContextMenu").hide();
    $("#3_ww_wcContextMenu").hide();
    $("#4_ww_wcContextMenu").hide();
    $("#5_ww_wcContextMenu").hide();
    $("#6_ww_wcContextMenu").hide();
    $("#7_ww_wcContextMenu").hide();
    
    var windowLevelElement = $("#winL_wrapper");
    var windowLevelElement_Overflow = $("#winL_overflow");
    var windowLevelButton = $("#winL");
    var zoomElement = $("#zoomButton_wrapper");
    var zoomButton = $("#zoomButton");
    var zoomElement_Overflow = $("#zoomButton_overflow");
    var AutoWindowLevelElement = $("#AutoWinLButton");
    var AutoWindowLevelElement_Overflow = $("#AutoWinLButton_overflow");
    var invertElement = $("#invertButton");
    var invertElement_Overflow = $("#invertButton_overflow");
    var panElement = $("#panButton");
    var panElement_Overflow = $("#panButton_overflow");
    var rotateElement = $("#rotateButton");
    var rotateElement_Overflow = $("#rotateButton_overflow");
    var refreshElement = $("#refreshButton");
    var refreshElement_Overflow = $("#refreshButton_overflow");
    var overLayElement = $("#overlayButton_wrapper");
    var overLayElement_Overflow = $("#overlayButton_overflow");
    var measurementElement = $("#measurementsButton");
    var flipVElement = $("#flipVButton");
    var flipVElement_Overflow = $("#flipVButton_overflow");
    var flipHElement = $("#flipHButton");
    var flipHElement_Overflow = $("#flipHButton_overflow");
    var dicomHeader = $("#dicomheaderButton_wrapper");
    var dicomHeader_Overflow = $("#dicomheaderButton_overflow");
    var settingElement = $("#EcgAndtemplateButton_wrapper");
    var contextWindowLevelElement = $("#context-ww_wc");
    if (flag) {
        //flag(true) - either the modality are in ECG, ECG+PDF and BLOB or image type is radecg
        enableOrDisableAnnotationTools(false);
        changeToolbarIcon(windowLevelElement, "brightness.png", "brightness.png", true);
        changeToolbarIcon(windowLevelButton, "brightness.png", "brightness.png", true);
        changeToolbarIcon(zoomElement, "zoom.png", "zoom.png", true);
        changeToolbarIcon(zoomButton, "zoom.png", "zoom.png", true);
        changeToolbarIcon(AutoWindowLevelElement, "images/AutoWindowLevel.png", "images/AutoWindowLevel.png", true);
        changeToolbarIcon(invertElement, "invert.png", "invert.png", true);
        changeToolbarIcon(panElement, "pan.png", "pan.png", true);
        changeToolbarIcon(rotateElement, "rotate.png", "rotate.png", true);
        changeToolbarIcon(refreshElement, "refresh.png", "refresh.png", true);
        changeToolbarIcon(overLayElement, "overlay.png", "overlay.png", true);
        changeToolbarIcon(measurementElement, "measuremnet.png", "measuremnet.png", true);
        changeToolbarIcon(flipHElement, "flip-vertical.png", "flip-vertical.png", true);
        changeToolbarIcon(flipVElement, "flip-horizontal.png", "flip-horizontal.png", true);
        updateImageOverflow(windowLevelElement_Overflow, "images/brightness.png", "images/brightness.png", true);
        updateImageOverflow(zoomElement_Overflow, "images/zoom.png", "images/zoom.png", true);
        updateImageOverflow(AutoWindowLevelElement_Overflow, "images/AutoWindowLevel.png", "images/AutoWindowLevel.png", true);
        updateImageOverflow(invertElement_Overflow, "images/invert.png", "images/invert.png", true);
        updateImageOverflow(panElement_Overflow, "images/pan.png", "images/pan.png", true);
        updateImageOverflow(rotateElement_Overflow, "images/rotate.png", "images/rotate.png", true);
        updateImageOverflow(refreshElement_Overflow, "images/refresh.png", "images/refresh.png", true);
        updateImageOverflow(overLayElement_Overflow, "images/overlay.png", "images/overlay.png", true);
        updateImageOverflow(flipHElement_Overflow, "images/flip-vertical.png", "images/flip-vertical.png", true);
        updateImageOverflow(flipVElement_Overflow, "images/flip-horizontal.png", "images/flip-horizontal.png", true);
        updateImageOverflow(dicomHeader_Overflow, "images/header.png", "images/header.png", true);
        $("#studyLevel_overflow").addClass("k-state-disabled");
        $("#showHideAnnotaionAndMesurement").hide(); // Show/Hide the annotations/measurements
        $("#showHideAnnotaionAndMesurement_overflow").hide(); // Show/Hide the annotations/measurements

        $("#colorPalet").hide();
        $("#ecgPrefrence").hide();
        $("#imageLevel4").hide();
        
        //Hide the Measurement options in the tool bar using more button
        $("#0_measurement").hide(); //2D Length
        $("#1_measurement").hide(); //2D Point
        $("#angle_measurement").hide(); //Angle Tool
        $("#6_measurement").hide(); //2D Length Calibration
        $("#4_measurement").hide(); //Delete All        
        $("#zoomButton_wrapper").addClass("k-state-disabled");
        $("#dicomImageHeader_overflow").hide(); //Dicom Header Overflow        
        $("#overlay_overflow").hide(); //Overlay Overflow        
        
    } else {
        //flag(false) - for all the modality except ECG, ECG+PDF
        enableOrDisableAnnotationTools(true);
        changeToolbarIcon(windowLevelElement, "brightness.png", "brightness.png", false);
        changeToolbarIcon(windowLevelButton, "brightness.png", "brightness.png", false);
        changeToolbarIcon(zoomElement, "zoom.png", "zoom.png", false);
        changeToolbarIcon(zoomButton, "zoom.png", "zoom.png", false);
        changeToolbarIcon(AutoWindowLevelElement, "images/AutoWindowLevel.png", "images/AutoWindowLevel.png", false);
        changeToolbarIcon(invertElement, "invert.png", "invert.png", false);
        changeToolbarIcon(panElement, "pan.png", "pan.png", false);
        changeToolbarIcon(rotateElement, "rotate.png", "rotate.png", false);
        changeToolbarIcon(refreshElement, "refresh.png", "refresh.png", false);
        changeToolbarIcon(overLayElement, "overlay.png", "overlay.png", false);
        changeToolbarIcon(measurementElement, "measuremnet.png", "measuremnet.png", false);
        $("#tool_measurements").show();
        changeToolbarIcon(flipHElement, "flip-vertical.png", "flip-vertical.png", false);
        changeToolbarIcon(flipVElement, "flip-horizontal.png", "flip-horizontal.png", false);
        changeToolbarIcon(dicomHeader,  "header.png", "header.png", false);
        changeToolbarIcon(settingElement, "settings.png", "settings.png", false);
        updateImageOverflow(windowLevelElement_Overflow, "images/brightness.png", "images/brightness.png", false);
        updateImageOverflow(zoomElement_Overflow, "images/zoom.png", "images/zoom.png", false);
        updateImageOverflow(AutoWindowLevelElement_Overflow, "images/AutoWindowLevel.png", "images/AutoWindowLevel.png", false);
        updateImageOverflow(invertElement_Overflow, "images/invert.png", "images/invert.png", false);
        updateImageOverflow(panElement_Overflow, "images/pan.png", "images/pan.png", false);
        updateImageOverflow(rotateElement_Overflow, "images/rotate.png", "images/rotate.png", false);
        updateImageOverflow(refreshElement_Overflow, "images/refresh.png", "images/refresh.png", false);
        updateImageOverflow(overLayElement_Overflow, "images/overlay.png", "images/overlay.png", false);
        updateImageOverflow(flipHElement_Overflow, "images/flip-vertical.png", "images/flip-vertical.png", false);
        updateImageOverflow(flipVElement_Overflow, "images/flip-horizontal.png", "images/flip-horizontal.png", false);
        updateImageOverflow($("#EcgAndtemplateButton_overflow"), "images/settings.png", "images/settings.png", false);
        updateImageOverflow(dicomHeader_Overflow, "images/header.png", "images/header.png", false);
        $("#studyLevel_overflow").removeClass("k-state-disabled");

        $("#zoomButton_wrapper").removeClass("k-state-disabled");
        $("#imageLevel1").show();
        $("#imageLevel2").show();
        $("#imageLevel3").show();
        $("#imageLevel4").show();
        $("#windowlevel").css("background-color", "");
        $("#preset").css("background-color", "");
        $("#pan").css("background-color", "");
        $("#AutoWinLButton").css("background-color", "");
        $("#invert").css("background-color", "");
        $("#rotate").css("background-color", "");
        $("#revert").css("background-color", "");
        $("#overlay").css("background-color", "");
        $("#2DMeasurements").css("background-color", "");
        $("#flipHorizontal").css("background-color", "");
        $("#flipVertical").css("background-color", "");
        $("#dicomheaderButton").css("background-color", "");
        $("#EcgAndtemplateButton_wrapper").css("background-color", "");
        
        //show the specific tools for the dicom images
        $("#0_measurement").show();
        $("#1_measurement").show();
        $("#angle_measurement").show();
        $("#6_measurement").show();
        dicomViewer.tools.isShowAnnotationandMeasurement() ? $("#4_measurement").show() : "" ;  //Delete All
        
        //hide trace measurement and hounsfiled for dicom images from the tool bar
        $("#2_measurement").hide();//Trace Measurement
        $("#tool_hounsfield").hide();//Hounsfield 
    }
    updateKendoArrowButton(windowLevelElement, true);
    // Get modality and disable/enable the context menu based on the modality.
    var layout = dicomViewer.getActiveSeriesLayout();
    if(layout != null && layout.seriesIndex != undefined)
    {
        var modality = dicomViewer.Series.getModality(layout.studyUid, layout.seriesIndex);
       showOrHideDicomMenu(false, modality);
    }
    changeOverflowBackground();
}

/**
 * Update the toolbar icon image for the tool bar
 * @param {Type} element - element id
 * @param {Type} currentImage - Current icon image
 * @param {Type} newImage - Updated icon image
 * @param {Boolean} isAddClass - Is disabled or enabled
 */ 
function changeToolbarIcon(element, currentImage, newImage, isAddClass) {
    var imageElement = element.find('img');
    var replacedSrc = imageElement.attr('src').replace(currentImage, newImage);
    imageElement.attr('src', replacedSrc);
    if (isAddClass) {
        element.addClass("k-state-disabled");
    } else {
        element.removeClass("k-state-disabled");
    }
}
/**
 * Enable disable the toolbar icon image for the tool bar
 */ 
function UpdateToolbarIcon(state) {
    changeToolbarIcon($("#invertButton"), "invert.png", "invert.png", state);
    changeToolbarIcon($("#invertButton_overflow"), "invert.png", "invert.png", state);
    changeToolbarIcon($("#winL_wrapper"), "brightness.png", "brightness.png", state);
    changeToolbarIcon($("#winL"), "brightness.png", "brightness.png", state);
}

/**
 *Update the Tool tip with the respective given text for each element
 *@param element
 *@param text
 *@param positionValue

 */
function updateToolTip(element, text, positionValue){
    if(useKendoTooltip){
        element.kendoTooltip({
            showAfter: 100,
            content: text,
            autoHide:"true",
            position:'top',
             animation: {
              close: {
                duration: 1
              }
            }
        }).on('mouseover', function(e){
            if(e.currentTarget !== undefined && e.currentTarget !== null){
                $('#'+e.currentTarget.id).kendoTooltip('show');
            }
        }).on('mouseout', function(e){
            if(e.currentTarget !== undefined && e.currentTarget !== null){
                $('#'+e.currentTarget.id).kendoTooltip('hide');
            }
        });
    } else {
        element.attr("title", text);
    }
}

/**
 * Show/Hide the tool bar icon when cine is running or stopped
 * @param {Boolean} flag - True (Cine is running) or False(Cine is stopped)
 */ 
function showOrHideInCineRunning(modality, flag) {
    var measurementElement = $("#measurementsButton");
    var zoomElement = $("#zoomButton_wrapper");
    var zoomButton = $("#zoomButton");
    var autoWinLevelButton = $("#AutoWinLButton");
    //var invertElement = $("#invertButton");
    var panElement = $("#panButton");
    var rotateElement = $("#rotateButton");
    var refreshElement = $("#refreshButton");
    var flipVElement = $("#flipHButton");
    var flipHElement = $("#flipVButton");
    
    var zoomElement_Overflow = $("#zoomButton_overflow");
    var autoWinLevel_Overflow = $("#AutoWinLButton_overflow");
    //var invertElement_Overflow = $("#invertButton_overflow");
    var panElement_Overflow = $("#panButton_overflow");
    var rotateElement_Overflow = $("#rotateButton_overflow");
    var refreshElement_Overflow = $("#refreshButton_overflow");
    var flipVElement_Overflow = $("#flipVButton_overflow");
    var flipHElement_Overflow = $("#flipHButton_overflow");
    var dicomHeader_Overflow = $("#dicomheaderButton_overflow");

    //Hide the Measurement options in the tool bar using more button if Cine is in running mode
    $("#0_measurement").hide(); //2D Length
    $("#angle_measurement").hide(); //Angle Tool
    $("#1_measurement").hide(); //2D Point
    $("#2_measurement").hide(); //Trace Measurement
    $("#6_measurement").hide(); //2D Length Calibration
    $("#tool_hounsfield").hide(); //Hounsfield 
    $("#4_measurement").hide(); //Delete All
    $("#8_text_overflow").hide(); //Label text
    $("#9_line_overflow").hide(); //2D line
    $("#10_arrow_overflow").hide(); //Arrow
    $("#11_ellipse_overflow").hide(); //ellipse
    $("#12_rectangle_overflow").hide(); //rectangle
    $("#13_freehand_overflow").hide(); //free hand
    
    if (flag) {
        //flag(true) - cine is in running mode
        enableOrDisableAnnotationTools(false);
        changeToolbarIcon(measurementElement, "measuremnet.png", "measuremnet.png", true);
        changeToolbarIcon(zoomElement, "zoom.png", "zoom.png", true);
        changeToolbarIcon(zoomButton, "zoom.png", "zoom.png", true);
        changeToolbarIcon(autoWinLevelButton, "images/AutoWindowLevel.png", "images/AutoWindowLevel.png", true);
        //changeToolbarIcon(invertElement, "invert.png", "invert.png", true);
        changeToolbarIcon(panElement, "pan.png", "pan.png", true);
        changeToolbarIcon(rotateElement, "rotate.png", "rotate.png", true);
        changeToolbarIcon(refreshElement, "refresh.png", "refresh.png", true);
        changeToolbarIcon(flipHElement, "flip-horizontal.png", "flip-horizontal.png", true);
        changeToolbarIcon(flipVElement, "flip-vertical.png", "flip-vertical.png", true);
        updateImageOverflow(zoomElement_Overflow, "images/zoom.png", "images/zoom.png", true);
        updateImageOverflow(autoWinLevel_Overflow, "images/AutoWindowLevel.png", "images/AutoWindowLevel.png", true);
        //updateImageOverflow(invertElement_Overflow, "images/invert.png", "images/invert.png", true);
        updateImageOverflow(panElement_Overflow, "images/pan.png", "images/pan.png", true);
        updateImageOverflow(rotateElement_Overflow, "images/rotate.png", "images/rotate.png", true);
        updateImageOverflow(refreshElement_Overflow, "images/refresh.png", "images/refresh.png", true);
        updateImageOverflow(flipHElement_Overflow, "images/flip-vertical.png", "images/flip-vertical.png", true);
        updateImageOverflow(flipVElement_Overflow, "images/flip-horizontal.png", "images/flip-horizontal.png", true);
        updateImageOverflow(dicomHeader_Overflow, "images/header.png", "images/header.png", true);
        $("#studyLevel_overflow").addClass("k-state-disabled");
        $("#showHideAnnotaionAndMesurement").hide(); // Show/Hide the annotations/measurements
        $("#showHideAnnotaionAndMesurement_overflow").hide(); // Show/Hide the annotations/measurements

    }else {
        enableOrDisableAnnotationTools(true);
        changeToolbarIcon(measurementElement, "measuremnet.png", "measuremnet.png", false);
        changeToolbarIcon(zoomElement, "zoom.png", "zoom.png", false);
        changeToolbarIcon(zoomButton, "zoom.png", "zoom.png", false);
        changeToolbarIcon(autoWinLevelButton, "images/AutoWindowLevel.png", "images/AutoWindowLevel.png", false);
        //changeToolbarIcon(invertElement, "invert.png", "invert.png", false);
        changeToolbarIcon(panElement, "pan.png", "pan.png", false);
        changeToolbarIcon(rotateElement, "rotate.png", "rotate.png", false);
        changeToolbarIcon(refreshElement, "refresh.png", "refresh.png", false);
        changeToolbarIcon(flipHElement, "flip-horizontal.png", "flip-horizontal.png", false);
        changeToolbarIcon(flipVElement, "flip-vertical.png", "flip-vertical.png", false);
        updateImageOverflow(zoomElement_Overflow, "images/zoom.png", "images/zoom.png", false);
        updateImageOverflow(autoWinLevel_Overflow, "images/AutoWindowLevel.png", "images/AutoWindowLevel.png", false);
        //updateImageOverflow(invertElement_Overflow, "images/invert.png", "images/invert.png", false);
        updateImageOverflow(panElement_Overflow, "images/pan.png", "images/pan.png", false);
        updateImageOverflow(rotateElement_Overflow, "images/rotate.png", "images/rotate.png", false);
        updateImageOverflow(refreshElement_Overflow, "images/refresh.png", "images/refresh.png", false);
        updateImageOverflow(flipHElement_Overflow, "images/flip-vertical.png", "images/flip-vertical.png", false);
        updateImageOverflow(flipVElement_Overflow, "images/flip-horizontal.png", "images/flip-horizontal.png", false);
        updateImageOverflow(dicomHeader_Overflow, "images/header.png", "images/header.png", false);
        $("#studyLevel_overflow").removeClass("k-state-disabled");
        $("#showHideAnnotaionAndMesurement").show(); // Show/Hide the annotations/measurements
        $("#showHideAnnotaionAndMesurement_overflow").show(); // Show/Hide the annotations/measurements

        //Show the Measurement options in the tool bar using more button if cine is stopped on the basis of modality
        if(modality == "US") {
            $("#0_measurement, #angle_measurement, #1_measurement, #2_measurement, #4_measurement").show();
            changeToolbarIcon($("#AutoWinLButton"), "images/AutoWindowLevel.png", "images/AutoWindowLevel.png", true);
        } else if(modality == "CT") {
            $("#0_measurement, #angle_measurement, #1_measurement, #6_measurement, #tool_hounsfield, #4_measurement").show();
            } else if(modality == "CR") {
                $("#0_measurement, #angle_measurement, #1_measurement, #6_measurement, #4_measurement").show();
                } else if(modality == "MR" || modality == "XA" || modality == "NM") {
                    $("#0_measurement, #angle_measurement, #1_measurement, #6_measurement, #4_measurement").show();
                    }
    }
    changeOverflowBackground();
}

/**
 * To disable as well as hide all the tool from the viewer
 * @param {Boolean} flag
 */ 
function disableOrEnableSRTools(flag) {
    var windowLevelElement_Overflow = $("#winL_overflow");
    var zoomElement_Overflow = $("#zoomButton_overflow");
    var invertElement_Overflow = $("#invertButton_overflow");
    var panElement_Overflow = $("#panButton_overflow");
    var rotateElement_Overflow = $("#rotateButton_overflow");
    var refreshElement_Overflow = $("#refreshButton_overflow");
    var overLayElement_Overflow = $("#overlayButton_overflow");
    var flipVElement_Overflow = $("#flipVButton_overflow");
    var flipHElement_Overflow = $("#flipHButton_overflow");
    var dicomHeader_Overflow = $("#dicomheaderButton_overflow");
    $("#0_zoom").hide();
    $("#1_zoom").hide();
    $("#2_zoom").hide();
    $("#3_zoom").hide();
    $("#4_zoom").show();
    $("#5_zoom").show();
    $("#6_zoom").show();
    $("#colorPalet").hide();
    
    $("#overlay").hide(); //overlay
    $("#scoutLine").hide(); //cross reference line
    $("#overlay_overflow").hide(); //overlay
    $("#scoutLine_overflow").hide(); //cross reference line
    $("#showHideAnnotaionAndMesurement").hide(); // Show/Hide the annotations/measurements
    $("#showHideAnnotaionAndMesurement_overflow").hide(); // Show/Hide the annotations/measurements
    $("#ecgPrefrence").hide();
    $("#cinePreference").hide();
    $("#CopyAttributesPreference").hide();
    $("#MeaaurementPreference").hide();

    //Hide the Measurement options in the tool bar using more button
    $("#0_measurement").hide(); //2D Length
    $("#angle_measurement").hide(); //Angle Tool
    $("#1_measurement").hide(); //2D Point
    $("#2_measurement").hide(); //Trace Measurement
    $("#6_measurement").hide(); //2D Length Calibration
    $("#tool_hounsfield").hide(); //Hounsfield 
    $("#4_measurement").hide(); //Delete All
    
    $("#ecgPrefrence_overflow").hide();
    $("#cinePreference_overflow").hide();
    $("#CopyAttributesPreference_overflow").hide();
    $("#MeaaurementPreference_overflow").hide();
    enableOrDisableAnnotationTools(false);

    $("#winL_wrapper").addClass("k-state-disabled");
    $("#dicomImageHeader").removeClass("k-state-disabled");
    changeToolbarIcon($("#winL"), "brightness.png", "brightness.png", true);
    changeToolbarIcon($("#zoomButton_wrapper"), "zoom.png", "zoom.png", false);
    changeToolbarIcon($("#AutoWinLButton"), "images/AutoWindowLevel.png", "images/AutoWindowLevel.png", true);
    changeToolbarIcon($("#invertButton"), "invert.png", "invert.png", true);
    changeToolbarIcon($("#panButton"), "pan.png", "pan.png", true);
    changeToolbarIcon($("#rotateButton"), "rotate.png", "rotate.png", true);
    changeToolbarIcon($("#refreshButton"), "refresh.png", "refresh.png", true);
    changeToolbarIcon($("#overlayButton_wrapper"), "overlay.png", "overlay.png", true);
    changeToolbarIcon($("#measurementsButton"), "measuremnet.png", "measuremnet.png", true);
    changeToolbarIcon($("#flipHButton"), "flip-vertical.png", "flip-vertical.png", true);
    changeToolbarIcon($("#flipVButton"), "flip-horizontal.png", "flip-horizontal.png", true);
    changeToolbarIcon($("#EcgAndtemplateButton_wrapper"), "settings.png", "settings.png", false);
    changeToolbarIcon($("#dicomheaderButton_wrapper"), "header.png", "header.png", true);
    updateImageOverflow(windowLevelElement_Overflow, "images/brightness.png", "images/brightness.png", true);
    updateImageOverflow(zoomElement_Overflow, "images/zoom.png", "images/zoom.png", false);
    updateImageOverflow(invertElement_Overflow, "images/invert.png", "images/invert.png", true);
    updateImageOverflow(panElement_Overflow, "images/pan.png", "images/pan.png", true);
    updateImageOverflow(rotateElement_Overflow, "images/rotate.png", "images/rotate.png", true);
    updateImageOverflow(refreshElement_Overflow, "images/refresh.png", "images/refresh.png", true);
    updateImageOverflow(overLayElement_Overflow, "images/overlay.png", "images/overlay.png", true);
    updateImageOverflow(flipHElement_Overflow, "images/flip-vertical.png", "images/flip-vertical.png", true);
    updateImageOverflow(flipVElement_Overflow, "images/flip-horizontal.png", "images/flip-horizontal.png", true);
    updateImageOverflow($("#EcgAndtemplateButton_overflow"), "images/settings.png", "images/settings.png", false);
    updateImageOverflow(dicomHeader_Overflow, "images/header.png", "images/header.png", true);
    $("#studyLevel_overflow").addClass("k-state-disabled");
}

function disableToolbarForUsImages() {
    $("#ecgPreference").css("background-color", "black");
    disableOrEnableDicomTools(false);
    $("#winL_wrapper").addClass("k-state-disabled");
    changeToolbarIcon($("#winL"), "brightness.png", "brightness.png", true);
    changeToolbarIcon($("#AutoWinLButton"), "images/AutoWindowLevel.png", "images/AutoWindowLevel.png", true);
    changeToolbarIcon($("#invertButton"), "invert.png", "invert.png", true);
    updateImageOverflow($("#winL_overflow"), "images/brightness.png", "images/brightness.png", true);
    updateImageOverflow($("#invertButton_overflow"), "images/invert.png", "images/invert.png", true);
    
    $("#0_measurement").show();
    $("#1_measurement").show();
    $("#2_measurement").show();
	$("#6_measurement").hide();
    $("#context-windowlevel").hide();
    $("#copyAttributes_tr_WL").hide();
    $("#copyAttributes_tr_Invert").hide();
}

function disableOrEnableToolbarForCTImages() {
    $("#ecgPreference").prop("disabled",true);
    $("#ecgPreference").css("background-color","black");
    
	disableOrEnableDicomTools(false);
    
    var windowLevelElement = $("#winL_wrapper");
    var contextWindowLevelElement = $("#context-ww_wc");
    
    //Show the disabled measurement options in the tool bar using more button
    $("#0_measurement").show(); //2D Length
    $("#angle_measurement").show(); //Angle Tool
    $("#1_measurement").show(); //2D Point
    $("#6_measurement").show(); //2D Length Calibration
    $("#tool_hounsfield").show(); //Hounsfield ellipse
    dicomViewer.tools.isShowAnnotationandMeasurement() ? $("#4_measurement").show() : "" ;
    
    //Show the disabled window level preset options in the context menu
    $("#1_ww_wcContextMenu").show();
    $("#2_ww_wcContextMenu").show();
    $("#3_ww_wcContextMenu").show();
    $("#4_ww_wcContextMenu").show();
    $("#5_ww_wcContextMenu").show();
    $("#6_ww_wcContextMenu").show();
    $("#7_ww_wcContextMenu").show();
    
    updateKendoArrowButton(windowLevelElement, false);
    $("#context-windowlevel").hide();
}

function disbaleToolForECGPDF() {
    var flipVElement = $("#flipVButton");
    var flipHElement = $("#flipHButton");
    var flipVElement_Overflow = $("#flipVButton_overflow");
    var flipHElement_Overflow = $("#flipHButton_overflow");
    var dicomheaderElement = $("#dicomheaderButton_wrapper");
    $("#zoomButton_wrapper").addClass("k-state-disabled");
    changeToolbarIcon(flipHElement, "flip-vertical.png", "flip-vertical.png", true);
    changeToolbarIcon(flipVElement, "flip-horizontal.png", "flip-horizontal.png", true);
    changeToolbarIcon(dicomheaderElement, "header.png", "header.png", false); //enable the Dicom Header button icon for PDF
    updateImageOverflow($("#EcgAndtemplateButton_overflow"), "images/settings.png", "images/settings.png", true);
    updateImageOverflow($("#dicomheaderButton_overflow"), "images/header.png", "images/header.png", false);
    updateImageOverflow(flipHElement_Overflow, "images/flip-vertical.png", "images/flip-vertical.png", true);
    updateImageOverflow(flipVElement_Overflow, "images/flip-horizontal.png", "images/flip-horizontal.png", true);
    updateImageOverflow(dicomheaderElement, "images/header.png", "images/header.png", true);
    $("#studyLevel_overflow").addClass("k-state-disabled");
    
    $("#ecgPrefrence").hide();
	$("#cinePreference").hide();
    $("#CopyAttributesPreference").hide();
	$("#MeaaurementPreference").hide();
    $("#ecgPrefrence_overflow").hide();
	$("#cinePreference_overflow").hide();
    $("#CopyAttributesPreference_overflow").hide();
	$("#MeaaurementPreference_overflow").hide();
}

function disableToolBarForNonDicom(){
    disableToolbarForUsImages();
    enableOrDisableAnnotationTools(true);
    $("#dicomImageHeader").addClass("k-state-disabled"); //disable the Dicom Header for Non-Dicom images
    changeToolbarIcon($("#overlayButton_wrapper"), "overlay.png", "overlay.png", true);
    changeToolbarIcon($("#measurementsButton"), "measuremnet.png", "measuremnet.png", false);
    $("#tool_measurements").hide();
    $("#showHideAnnotaionAndMesurement").show(); // Show/Hide the annotations/measurements
    $("#showHideAnnotaionAndMesurement_overflow").show(); // Show/Hide the annotations/measurements
	//changeToolbarIcon($("#EcgAndtemplateButton_wrapper"), "settings.png", "settings.png", true);
    //updateImageOverflow($("#EcgAndtemplateButton_overflow"), "images/settings.png", "images/settings.png", true);
    updateImageOverflow($("#overlayButton_overflow"), "images/overlay.png", "images/overlay.png", true);
    $("#dicomImageHeader").hide();
	$("#ecgPrefrence").hide();
	$("#cinePreference").hide();
    $("#CopyAttributesPreference").hide();
	$("#MeaaurementPreference").show();
    
    $("#0_measurement").hide(); //2D Length
    $("#1_measurement").hide(); //2D Point
    $("#2_measurement").hide(); //Trace Measurement
    $("#angle_measurement").hide(); //Angle Tool
    $("#6_measurement").hide(); //2D Length Calibration
    $("#tool_hounsfield").hide(); //Hounsfield ellipse
    dicomViewer.tools.isShowAnnotationandMeasurement() ? $("#4_measurement").show() : "" ;
    
    $("#ecgPrefrence_overflow").hide();
	$("#cinePreference_overflow").hide();
    $("#CopyAttributesPreference_overflow").hide();
	$("#MeaaurementPreference_overflow").show();
        
	enableToolsForNonDicom();
}

function disableToolForBlob(){
    disableOrEnableDicomTools(true);
	var dicomHeader = $("#dicomheaderButton_wrapper");
	var dicomHeader_Overflow = $("#dicomheaderButton_overflow");
    $("#zoomButton_wrapper").addClass("k-state-disabled");
    
    changeToolbarIcon($("#EcgAndtemplateButton_wrapper"), "settings.png", "settings.png", false);
    updateImageOverflow($("#EcgAndtemplateButton_overflow"), "images/settings.png", "images/settings.png", false);
    changeToolbarIcon(dicomHeader,  "header.png", "header.png", false);
	updateImageOverflow(dicomHeader_Overflow, "images/header.png", "images/header.png", false);
    
	$("#dicomImageHeader").hide();
	$("#ecgPrefrence").hide();
	$("#cinePreference").hide();
    $("#CopyAttributesPreference").hide();
	$("#MeaaurementPreference").hide();
    $("#ecgPrefrence_overflow").hide();
	$("#cinePreference_overflow").hide();
    $("#CopyAttributesPreference_overflow").hide();
	$("#MeaaurementPreference_overflow").hide();
}

function enableOrDisableToolsForECG(){
	var dicomHeader = $("#dicomheaderButton_wrapper");
	var dicomHeader_Overflow = $("#dicomheaderButton_overflow");
	var settingElement = $("#EcgAndtemplateButton_wrapper");
	var settingElement_overflow = $("#EcgAndtemplateButton_overflow");
    var zoomButtonWrapper = $("#zoomButton_wrapper");
    var refreshElement = $("#refreshButton");
    var refreshElement_Overflow = $("#refreshButton_overflow");
    
	changeToolbarIcon(dicomHeader,  "header.png", "header.png", false);
	changeToolbarIcon(settingElement, "settings.png", "settings.png", false);
    changeToolbarIcon(zoomButtonWrapper, "zoom.png", "zoom.png", false);
    changeToolbarIcon(refreshElement, "refresh.png", "refresh.png", false);
	updateImageOverflow(dicomHeader_Overflow, "images/header.png", "images/header.png", false);
	updateImageOverflow(settingElement_overflow, "images/settings.png", "images/settings.png", false);
    updateImageOverflow(refreshElement_Overflow, "images/refresh.png", "images/refresh.png", false);
    
	$("#ecgPrefrence").show();
    $("#ecgPrefrence_overflow").show();
	$("#cinePreference").hide();
    $("#CopyAttributesPreference").hide();
	$("#MeaaurementPreference").hide();
    $("#cinePreference_overflow").hide();
    $("#MeaaurementPreference_overflow").hide();
    $("#CopyAttributesPreference_overflow").hide();
    $("#revert").css("background-color", "");
    $("#context-windowlevel").hide();
}

//To disable all the tool from the viewer
function disableAllToolbarIcons(){
	disableOrEnableSRTools();
	disableOrEnableRGBTools();
    dicomViewer.link.updateLinkMenu();
    var zoomElement = $("#zoomButton_wrapper");
    var zoomButton = $("#zoomButton");
    var zoomElement_Overflow = $("#zoomButton_overflow");
    changeToolbarIcon(zoomElement, "zoom.png", "zoom.png", true);
    changeToolbarIcon(zoomButton, "zoom.png", "zoom.png", true);
    updateImageOverflow(zoomElement_Overflow, "images/zoom.png", "images/zoom.png", true);
    $('#viewport_View').css('cursor', 'default');
    changeOverflowBackground();
}

//To enable the specific tools for non-dicom images
function enableToolsForNonDicom(){
    var zoomElement = $("#zoomButton_wrapper");
    var panElement = $("#panButton");
    var overLayElement = $("#overlayButton_wrapper");
    var dicomheaderElement = $("#dicomheaderButton_wrapper");
    changeToolbarIcon(zoomElement, "zoom.png", "zoom.png", false);
    changeToolbarIcon(panElement, "pan.png", "pan.png", false);
    changeToolbarIcon(dicomheaderElement, "header.png", "header.png", false);
    changeToolbarIcon(overLayElement, "overlay.png", "overlay.png", false);
    updateImageOverflow($("#zoomButton_overflow"), "images/zoom.png", "images/zoom.png", false);
    updateImageOverflow($("#panButton_overflow"), "images/pan.png", "images/pan.png", false);
    updateImageOverflow($("#overlayButton_overflow"), "images/overlay.png", "images/overlay.png", false);
    updateImageOverflow($("#dicomheaderButton_overflow"), "images/header.png", "images/header.png", false);
    $("#zoomButton_wrapper").removeClass("k-state-disabled");
    changeOverflowBackground();
}

function changeZoomCustom(id) {
	customZoomlID = id;
	$('#zoom-form').dialog('open');
}

function customWindowLevel(id){
	customWindowLevelID = id;
	$('#customWindowLevel').dialog('open');
}
// Validate the length input as per maxlength
// Return error message if length is not valid
function validateInputLenght(length, strUnits){
    var message = null ;
    var MAX_CALIB_LENGTH = 8; //Feet
    var dMaxCalibLength = 0.0;
    var unit = "";
    if (strUnits == "UNITS_MM") {
        dMaxCalibLength = MAX_CALIB_LENGTH * 12.0 * 2.54 * 10.0;
        unit ="mm";
    } else if (strUnits == "UNITS_CM") {
        dMaxCalibLength = MAX_CALIB_LENGTH * 12.0 * 2.54;
        unit ="cm";
    } else if (strUnits == "UNITS_INCHES"){
        dMaxCalibLength = MAX_CALIB_LENGTH * 12.0;
        unit ="inches";
    }
    if(!length.match(/^\d+/)){
        message = "Length is either empty or not a number";
    } else if(length <= 0){
        message = "Length must be greater than zero";
    } else if(length > dMaxCalibLength){
        message ="Length cannot be more than "+dMaxCalibLength+" "+ unit;
    }
    return message;
}

// Calculate Pixelspacing as per length input and unit selection
function calculatePixelSpacing(length, strUnits, allImages) {
    var m_fUnits = 0.0;
    if (strUnits == "UNITS_MM") {
        m_fUnits = 1.0;
    } else if (strUnits == "UNITS_CM") {
        m_fUnits = 10.0;
    } else if (strUnits == "UNITS_INCHES"){
        m_fUnits = 25.4;
    }

    var coordinate = dicomViewer.measurement.getCoordinate();
    var dx = (coordinate.start.x - coordinate.end.x);
    var dy = (coordinate.start.y - coordinate.end.y);
    var m_fCalibrateLength = Math.sqrt(dx * dx + dy * dy);
    
    var pixelSpacing = {
        column : (length * m_fUnits) / m_fCalibrateLength,
        row : (length * m_fUnits) / m_fCalibrateLength
    }
    
   var imageKey = undefined;
    var seriesLayout = dicomViewer.getActiveSeriesLayout();
    var imageRenderer = seriesLayout.getDefaultRenderer();

    var measurementUnitStudyUid;
    var measurementUnit = {
        unitType : strUnits,
        pixelSpacing : pixelSpacing
    }

    if(allImages) {
        var imageCount;
        var isMultiFrame = dicomViewer.thumbnail.isSeriesContainsMultiframe(seriesLayout.studyUid, seriesLayout.seriesIndex);
        if(isMultiFrame) {
            var image = dicomViewer.Series.Image.getImage(seriesLayout.studyUid, seriesLayout.seriesIndex, seriesLayout.scrollData.imageIndex);
            imageCount = dicomViewer.Series.Image.getImageFrameCount(image);
        }else {
            imageCount = dicomViewer.Series.getImageCount(seriesLayout.studyUid, seriesLayout.seriesIndex);
        }

        for(var i=0; i < imageCount; i++) {
            measurementUnitStudyUid = isMultiFrame ? seriesLayout.studyUid+"|"+seriesLayout.seriesIndex+"|"+seriesLayout.scrollData.imageIndex+"|"+i :
            seriesLayout.studyUid+"|"+seriesLayout.seriesIndex+"|"+i+"|"+seriesLayout.scrollData.frameIndex;  
            setUnitMeasurementMap(measurementUnitStudyUid,measurementUnit);
        }
    } else {
        measurementUnitStudyUid =getActiveCalibratedImage(); 
        setUnitMeasurementMap(measurementUnitStudyUid,measurementUnit);
    }
}

/**
 * Create the study layout menu
 */ 
function createStudyLayoutMenu()
{
    try
    {
        var menuList = [];
        for(var rows = 1; rows <= STUDY_LAYOUT_MAX_ROW; rows++) {
            for(var columns = 1; columns <= STUDY_LAYOUT_MAX_COLUMN; columns++) {
                var studyId = rows + "x" + columns;
                var menu = {};
                menu ["text"] = "Study Level " + studyId;
                menu ["click"] = dicomViewer.tools.changeStudyLayoutFromTool;
                menu ["id"] = studyId;
                menuList.push(menu);
            }
        }

        return menuList; 
    }
    catch(e)
    { }

    return null;
}

function changeOverflowBackground() {
    var repeteOption_overflow = $("#repeteOption_overflow");
    var nextSeries_overflow = $("#nextSeries_overflow");
    var nextImage_overflow = $("#nextImage_overflow");
    var playBackward_overflow = $("#playBackward_overflow");
    var previousImage_overflow = $("#previousImage_overflow");
    var previousSeries_overflow = $("#previousSeries_overflow");
    var dicomImageHeader_overflow = $("#dicomImageHeader_overflow");
    repeteOption_overflow.css("background-color", "#363636");
    nextSeries_overflow.css("background-color", "#363636");
    nextImage_overflow.css("background-color", "#363636");
    playBackward_overflow.css("background-color", "#363636");
    previousImage_overflow.css("background-color", "#363636");
    previousSeries_overflow.css("background-color", "#363636");
    dicomImageHeader_overflow.css("background-color", "#363636");
    $("#tNextSeries_overflow").css("background-color", "#363636");
    $("#tNextImage_overflow").css("background-color", "#363636");
    $("#tPreviousImage_overflow").css("background-color", "#363636");
    $("#tPreviousSeries_overflow").css("background-color", "#363636");
    $("#imagingInfo_overflow").css("background-color", "#363636");
    $("#EcgAndtemplateButton_overflow").css("background-color", "#363636");
    $("#ecgPrefrence_overflow").css("background-color", "#363636");
    $("#cinePreference_overflow").css("background-color", "#363636");
    $("#CopyAttributesPreference_overflow").css("background-color", "#363636");
    $("#MeaaurementPreference_overflow").css("background-color", "#363636");
    $("#hangingProtocol_overflow").css("background-color", "#363636");
    $("#overlay_overflow").css("background-color", "#363636");
    $("#showHideOverlay6000_overflow").css("background-color", "#363636");
    $("#scoutLine_overflow").css("background-color", "#363636");
    $("#showHideAnnotaionAndMesurement_overflow").css("background-color", "#363636");
    var studylayout = studyLayoutValue.split("x");
    if(studylayout.length == 2) {
        dicomViewer.tools.setSelectedStudyLayout(studylayout[0], studylayout[1], true);
    }
    $("#0_measurement_overflow").css("background-color", "#363636");
    $("#angle_measurement_overflow").css("background-color", "#363636");
    $("#1_measurement_overflow").css("background-color", "#363636");
    $("#2_measurement_overflow").css("background-color", "#363636");
    $("#6_measurement_overflow").css("background-color", "#363636");
    $("#7_measurement_overflow").css("background-color", "#363636");
    $("#14_measurement_overflow").css("background-color", "#363636");
    $("#4_measurement_overflow").css("background-color", "#363636");
    $("#8_text_overflow").css("background-color", "#363636"); //Label text
    $("#9_line_overflow").css("background-color", "#363636"); //2D line
    $("#10_arrow_overflow").css("background-color", "#363636"); //Arrow
    $("#11_ellipse_overflow").css("background-color", "#363636"); //ellipse
    $("#12_rectangle_overflow").css("background-color", "#363636"); //rectangle
    $("#13_freehand_overflow").css("background-color", "#363636"); //free hand
   // $("#RGBButton_overflow").css("color", "#363636");
    $("#RGBButton_overflow").css("background-color", "#363636");
    $("#1_rgbRed_overflow").css("background-color", "#363636");
    $("#2_rgbGreen_overflow").css("background-color", "#363636");
    $("#3_rgbBlue_overflow").css("background-color", "#363636");
    $("#0_rgbAll_overflow").css("background-color", "#363636");
    $("#0_zoom_overflow").css("background-color", "#363636");
    $("#1_zoom_overflow").css("background-color", "#363636");
    $("#2_zoom_overflow").css("background-color", "#363636");
    $("#3_zoom_overflow").css("background-color", "#363636");
    $("#4_zoom_overflow").css("background-color", "#363636");
    $("#5_zoom_overflow").css("background-color", "#363636");
    $("#6_zoom_overflow").css("background-color", "#363636");
    $("#playForward_overflow").css("background-color", "#363636");
    $("#studyLevel_overflow").css("background-color", "#363636");
}

/**
 * Show or hide study cache indicator
 *  
 */ 
//function showCacheIndicator() {
//    cacheIndicatorElement = $("#cacheIndicator");
//    
//    if(showStudyCacheIndicator) {
//        cacheIndicatorElement.show();
//    } else {
//        cacheIndicatorElement.hide();
//    }
//};

/**
 * enable/disable the annotation menus
 * @param {Type} isEnable - it specify to tue or false to enable/disable the menu
 */ 
function enableOrDisableAnnotationTools(isEnable) {
    var activeSeries = dicomViewer.getActiveSeriesLayout();
    var viewportToolbarId;
    if(activeSeries != null && activeSeries !=undefined) {
        viewportToolbarId = (activeSeries .seriesLayoutId).split("_")[1];
        var display = isEnable ? "block" : "none";
        if( viewportToolbarId !== undefined && viewportToolbarId !== null && 
           document.getElementById("saveAndLoad_"+viewportToolbarId) !== null &&
           document.getElementById("saveAndLoad_"+viewportToolbarId) !== undefined) {
           document.getElementById("saveAndLoad_"+viewportToolbarId).style.display=display;
        }
    }
    if(isEnable) {
        $("#8_text").show(); //Label text
        $("#9_line").show(); //2D line
        $("#10_arrow").show(); //Arrow
        $("#11_ellipse").show(); //ellipse
        $("#12_rectangle").show(); //rectangle
        $("#13_freehand").show(); //free hand
    } else {
        $("#8_text").hide(); //Label text
        $("#9_line").hide(); //2D line
        $("#10_arrow").hide(); //Arrow
        $("#11_ellipse").hide(); //ellipse
        $("#12_rectangle").hide(); //rectangle
        $("#13_freehand").hide(); //free hand
    }
}

/**
 * Hide the Measurements/Annotations drop-down (i.e. k-animation-container) while closing the drop-down
 */ 
function hideAnimationContainer() {
    var length = document.getElementsByClassName("k-animation-container").length;
    for(var x = 0; x<length; x++) {
        document.getElementsByClassName("k-animation-container")[x].style.display = "none";
    }
}

/**
 * Check whether the browser is IE
 */ 
function isInternetExplorer() {
    try
    {
        var sAgent = window.navigator.userAgent;
        if (sAgent.indexOf('MSIE') > 0) {
            return true;
        } else if (!!navigator.userAgent.match(/Trident\/7\./)) {
            return true;
        }
    }
    catch(e)
    { }

    return false;
}

/**
* set the right clicked viewport 
 */ 
var selectedViewerId =  undefined;
function getClickedViewportId() {
    return selectedViewerId;
}

