$(document).ready(function () {
    var THUMBNAIL_PANEL_MIN_WIDTH = (screen.width * 140) / 1280;
    var THUMBNAIL_PANEL_MAX_WIDTH = 150;
    var THUMBNAIL_PANEL_WIDTH = THUMBNAIL_PANEL_MIN_WIDTH;
    if (THUMBNAIL_PANEL_WIDTH > THUMBNAIL_PANEL_MAX_WIDTH) {
        THUMBNAIL_PANEL_WIDTH = THUMBNAIL_PANEL_MAX_WIDTH;
    }
    var northPanelHeight = 280;

    $("#manage_toolbar").kendoToolBar({
        items: [{
            type: "button",
            id: "image_Delete",
            title: 'Image Delete',
            imageUrl: "../images/imageDelete.png",
            click: doMarkDelete
            }, {
            type: "button",
            id: "image_Controlled",
            title: 'Image Controlled',
            imageUrl: "../images/imageSensitive.png",
            click: doMarkSensitive
            }, {
            type: "button",
            id: "image_Edit",
            title: 'Image Edit',
            imageUrl: "../images/imageEdit.png",
            click: doImageEdit
            }, {
            type: "splitButton",
            id: "selectDeselect_All",
            title: 'Select/Deselect All',
            imageUrl: "../images/selectDeselectImage.png",
            menuButtons: [{
                text: "Select All Images",
                id: "selectAll_Image",
                click: dicomViewer.thumbnail.selectOrDeselectImageGroups
                }, {
                text: "Select All Series",
                id: "selectAll_Series",
                click: dicomViewer.thumbnail.selectOrDeselectImageGroups
                }, {
                text: "Select All Study",
                id: "selectAll_Study",
                click: dicomViewer.thumbnail.selectOrDeselectImageGroups
                }]
            }]
    });

    // Hide the tool bar
    $("#manage_toolbar").hide();

    setToolTip("image_Delete", "Image Delete");
    setToolTip("image_Controlled", "Image Controlled");
    setToolTip("image_Edit", "Image Edit");
    setToolTip("selectDeselect_All", "Select/Deselect All");

    myLayout = $('body').layout({
        togglerLength_open: 0,
        west__spacing_open: 5,
        north__spacing_open: 5,
        togglerLength_closed: "100%",
    });
    loadSpinner();
    myLayout.sizePane("west", "50%");
    myLayout.sizePane("north", northPanelHeight);

    $('#edit-img-creation-date').datepicker({
        autoHide: true,
        zIndex: 2048,
    });

    $('#edit-img-creation-date').val(getCurrentDate());

});

function getCurrentDate() {
    var currentDate = new Date();
    var currentMonth = currentDate.getMonth() + 1;
    var day = currentDate.getDate();
    var todayDate = currentDate.getFullYear() + '/' + (('' + currentMonth).length < 2 ? '0' : '') + currentMonth + '/' + (('' + day).length < 2 ? '0' : '') + day;
    return todayDate;
}
