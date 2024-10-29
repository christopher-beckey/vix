/**
 * show and hide the spalash window
 * @param {Type} messageType - Type of message
 * @param {Type} message - message content
 * @param {Type} studyViewer - study viewer viewportID
 */
function showAndHideSplashWindow(messageType, message, parentId) {
    try {
        if (messageType == "show") {
            $("#splash-imageDiv").show();
            $("#splash-content")[0].style.display = "flex";
            $("#splash-imageDiv")[0].style.display = "flex";
            $("#splash-content")[0].innerHTML = "";
            $("#splash-window").show().center(parentId);

            var image = "data:image/gif;base64,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";

            $("#splash-imageDiv")[0].innerHTML = "<img src = " + image + ">";
            $("#splash-content")[0].innerHTML = message;
        } else if (messageType == "success") {
            setTimeout(function () {
                $("#splash-imageDiv").hide();
                $("#splash-content")[0].innerHTML = "" + message + "";
            }, 1000)
        } else {
            setTimeout(function () {
                $("#splash-imageDiv").hide();
                $("#splash-content")[0].innerHTML = "" + message + "";
            }, 1000)
        }
    } catch (e) {}
    setTimeout(function () {
        $("#splash-window").fadeOut(1000);
    }, 1500)
}

$(document).ready(function () {
    var div = document.createElement("div");
    div.id = "splash-window";
    div.setAttribute('class', 'absoluteCenter');
    document.body.appendChild(div);

    $('#splash-window').css({
        position: 'absolute',
        top: '0%',
        left: '0%',
        width: '400px',
        height: '70px',
        background: 'black',
        opacity: '1',
        zIndex: 1001,
        display: 'none',
        border: '2px solid white'
    });

    var element = "<table style='width:100%'><tr>";
    element += "<td style='width:14%'><div class='col-xs-2 splash' id='splash-imageDiv' style='display:flex; width:14%; z-index:1003'></div></td>";
    element += "<td style='width:86%'><div class='col-xs-10 splash' id='splash-content' style='display:flex; width:86%; z-index:1002'></div></td>";
    element += "</tr></table>"
    $("#splash-window").append(element);

    $('.splash').css({
        position: 'absolute',
        height: '66px',
        background: 'black',
        color: 'white',
        fontSize: '13px',
        fontFamily: 'sans-serif',
        justifyContent: 'center',
        alignContent: 'center',
        alignItems: 'center'
    });
});

$.fn.center = function (parentId) {
    this.css("position", "absolute");
    var topOffset = $("#" + parentId).offset().top
    var leftOffset = $("#" + parentId).offset().left
    var viewportHeight = ($("#" + parentId).height()) - 40;
    var viewportWidth = (($("#" + parentId).width()) - 300);
    this.css("top", ((viewportHeight) / 2 + topOffset) + "px");
    this.css("left", ((viewportWidth) / 2 + leftOffset) + "px");
    return this;
}
