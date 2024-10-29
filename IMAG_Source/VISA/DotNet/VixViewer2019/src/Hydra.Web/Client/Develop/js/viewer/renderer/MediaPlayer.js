var dicomViewer = (function (dicomViewer) {

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    function loadPlayer(url, divId, format) {

        $("#" + divId).empty();
        var player = "<video width='" + $("#" + divId).width() + "'";

        var type;
        if (format === "mp3") {
            player = player + ' poster="images/mp3.png"';
            type = "audio/mp3";
        } else if (format === "mp4") {
            type = "video/mp4";
        } else if (format === "webm") {
            type = "video/webm";
        } else if (format === "avi") {
            type = "video/avi";
        }

        player = player + "height='" + $("#" + divId).height() + "'controls>" +
            "<source src=" + url + " type=" + type + ">" +
            "</video>";
        $("#" + divId).append(player);

    }

    function loadVideoPlayer(urls, divId) {

        $("#" + divId).empty();
        var player = "<video width='" + $("#" + divId).width() + "'" + " height='" + $("#" + divId).height() + "' controls>";

        var urlLen = urls.length;
        for (i = 0; i < urlLen; i++) {
            player = player + "<source src=" + urls[i].url + " type=" + urls[i].type + ">";
        }

        player = player + "</video>";
        $("#" + divId).append(player);
    }

    dicomViewer.loadPlayer = loadPlayer;
    dicomViewer.loadVideoPlayer = loadVideoPlayer;

    return dicomViewer;
}(dicomViewer));
