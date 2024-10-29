var i = 0;

function loadThumbnailFromURL(workerData) {
    var xmlhttp;
    xmlhttp = new XMLHttpRequest();
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            switch (workerData.request) {
                case 'Thumbnail':
                    postMessage(xmlhttp.responseText);
                    break;
                default:
                    self.postMessage('Unknown command: ');
            };
        } else if (xmlhttp.readyState == 4 && (xmlhttp.status == 404 || xmlhttp.status == 500)) {
            postMessage("Failure");
        }
    }
    const myUrl = "/vix/api/context/getUrlResponse"; //VAI-760
    xmlhttp.open("GET", myUrl, true);
    xmlhttp.setRequestHeader("url", workerData.url); //VAI-760: Fixed OpenRedirect error
    xmlhttp.overrideMimeType("text/plain; charset=x-user-defined");
    xmlhttp.send();
}

self.addEventListener("message", function (e) {
    // the passed-in data is available via e.data
    loadThumbnailFromURL(e.data); //for debugging, add a breakpoint, then look at e.data
}, false);
