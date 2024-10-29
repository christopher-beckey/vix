var myHub = $.connection.sessionHub;
var currentDisplayContextList = [];
var idleTime = 0;
//VAI-307 Manages the PDF request status

class PdfRequest {
    static RequestList = [[]];
    static Request = Object.freeze({
        seriesIndex: 0,
        imageUid: 1,
        status: 2,
        pdfFile: ""
    })
    static Status = Object.freeze({
        requested: 0,
        pending: 1,
        complete: 2,
        error: 3,
        notfound: 4
    });
    static arePrintAndExportReady = false;
    static processStatus = "";
    static allCompleted() {
        if (this.arePrintAndExportReady == true)
            return (true);
        if (!this.RequestList.length)
            return (false);
        if (this.RequestList.length <= 1)
            return (false);

        for (var row = 1; row < this.RequestList.length; row++) {
            if (this.RequestList[row][this.Request.status] != this.Status.complete && this.RequestList[row][this.Request.status] != this.Status.error)
                return (false);
        }
        this.arePrintAndExportReady = true;
        return (true);
    }
   static getCompletedInfo() {
        var status;
        var completed = 0;
        for (var row = 1; row < this.RequestList.length; row++) {
            if (this.RequestList[row][this.Request.status] != this.Status.complete && this.RequestList[row][this.Request.status] != this.Status.complete)
                completed++;
        }
       processStatus =  completed.toString() + "/" + this.RequestList.length.toString();
        return;
    }

    static findRequestStatus(imageUid) {
        if (this.arePrintAndExportReady == true)
            return (PdfRequest.Status.complete);

        if (!this.RequestList.length)
            return (PdfRequest.Status.notfound);
        if (this.RequestList.length < 2)
            return (PdfRequest.Status.notfound);

        for (var row = 1; row < this.RequestList.length; row++) {
            if (this.RequestList[row][this.Request.imageUid] == imageUid)
                return (this.RequestList[row][this.Request.status]); // found  
        }
        return (PdfRequest.Status.notfound);
    }
    static findRequestPdfPath(imageUid) {
        if (!this.RequestList.length)
            return (PdfRequest.Status.notfound);
        if (this.RequestList.length < 2)
            return (PdfRequest.Status.notfound);

        for (var row = 1; row < this.RequestList.length; row++) {
            if (this.RequestList[row][this.Request.imageUid] == imageUid)
                return (this.RequestList[row][this.Request.pdfFile]);
        }
        return (null);
    }

    static addRequest(seriesIndex, imageUid, status, pdfFile) {
        if (this.findRequestStatus(imageUid) != this.Status.notfound) 
            return (false);// Found. Already there so don't add
        this.RequestList.push([seriesIndex, imageUid, status, pdfFile]);
        return (true);
    }

    static updateRequestStatus(imageUid, newStatus, pdfFile) {
        if (!this.RequestList.length)
            return (false);
        if (this.RequestList.length < 2)
            return (false);
        for (var row = 1; row < this.RequestList.length; row++) {
            if (this.RequestList[row][this.Request.imageUid] == imageUid) {
                this.RequestList[row][this.Request.status] = newStatus;
                if (pdfFile) this.RequestList[row][this.Request.pdfFile] = pdfFile;
                return (true);
            }
        }
        return (false);
    }
}

//VAI-307 SignalR is used to request the TIFF to PDF file from the server
var PdfRequestHub = $.connection.PdfRequestHub, pendingOperations = {};
PdfRequestHub.client.cancelled = function (operationId) {
    pendingOperations[operationId].reject(operationId);
    $("#statusMsg").text("Print/Export:Cancelled");
    dicomViewer.measurement.showAndHideSplashWindow("show", "Print/Export:Cancelled", "dicomViewer");
};

PdfRequestHub.client.complete = function (operationId, imageUid, pdfFile) {//VAI-307
    if (pdfFile.indexOf("Error", 0) == 0) {
        dicomViewer.measurement.showAndHideSplashWindow("show", pdfFile, "dicomViewer");
        $("#statusMsg").text("Print/Export Error: Please see log");
        PdfRequest.updateRequestStatus(imageUid, PdfRequest.Status.error, "error");
        pendingOperations[operationId].resolve(operationId);
        return;
    }
    PdfRequest.updateRequestStatus(imageUid, PdfRequest.Status.complete, pdfFile);

    var PdfExportLink = document.getElementById("pdfExportImageLnk");
    PdfExportLink.href = pdfFile;
    PdfExportLink.download = "TIFF-Image";

    if (PdfRequest.allCompleted() == false) {
        var message = "Print/Export:Not Ready";
        // dicomViewer.measurement.showAndHideSplashWindow("show", message, "dicomViewer");
        $("#statusMsg").text(message);
        showPrintAndExport(false);
        return;
    }
    updatePrintExportMessage(true);
};

 
//Sometimes on marginal or slow connections we have to retry
class SignalRStatus {
    static retryCount = 0;
    static isSignalRConnected = false;

    static SetSignalrStarted(isComplete) {
        this.isSignalRConnected = isComplete;
    }
    static GetSignalrStarted() {
        return (this.isSignalRConnected);
    }
}


function getPdfFile(imageUid) {

    if ( SignalRStatus.retryCount++ < 20) {
        if ($("#statusMsg").text() != "Print/Export:Ready") {
            if (SignalRStatus.GetSignalrStarted() == false) { // indicates if SignalRis has been initialized
                setTimeout(function () { getPdfFile(imageUid); }, 5000); // slower connection need extra time
            } else {
                try {                   
                    PdfRequestHub.server.requestPdfFile(imageUid);
                } catch (err) {
                    //This happens when the SignalR connection is slow or in the process of initializing. It is OK
                    SignalRStatus.SetSignalrStarted(false);
                    setTimeout(function () { getPdfFile(imageUid); }, 5000); // slower connection need extra time
                }
            }
        }
    }
}

//VAI-307 Tell the server side to execute its doOperation via SignalR call to requestPdfFile on server
function requestPdfFile(seriesIndex, imageUid) {
    if (!canPrint && !canExport) {
       	// No message when the user does not have the print/export rights
	    // $("#statusMsg").text("Print/Export:Disabled");
        return;
    }

    if ($("#statusMsg").text() == "Print/Export:Ready")
        return;

    if (PdfRequest.addRequest(seriesIndex, imageUid, PdfRequest.Status.requested, "") == false) { //Already on the request list
        if (SignalRStatus.GetSignalrStarted() == false) {          
            setTimeout(function () { getPdfFile(imageUid); }, 5000);
        }
        return;
    }   
    if ($("#statusMsg").text() != "Print/Export:Not Ready") {
       $("#statusMsg").text("Print/Export:Not Ready");
        //var message = "Preparing Tiff for Print/Export"; //This is where we could put user updates if needed
        //dicomViewer.measurement.showAndHideSplashWindow("show", message, "dicomViewer"); 
    } 
    try {       
        PdfRequestHub.server.requestPdfFile(imageUid);
        SignalRStatus.retryCount = 0;  
    }
    catch (err) {
        //This happens when the SignalR connection is slow or in the process of initializing. It is OK
        SignalRStatus.SetSignalrStarted(false);
        setTimeout(function () { getPdfFile(imageUid); }, 5000); // slower connections need extra time
    }
}
//VAI-307 end

// add new display context to the viewer
myHub.client.addDisplayContext = function (sessionId, displayContextList) {

    if (!isCurrentSession(sessionId)) return;

    var i;
    var displayContexts = [];
    var firstLoadedContext = undefined;
    for (i = 0; i < displayContextList.length; i++) {
        var contextId = displayContextList[i];
        contextId = decodeURIComponent(contextId).trim();
        var selectedContextId = currentDisplayContextList.filter(function (existingContextId) {
            return (existingContextId.trim().toLowerCase() === contextId.toLowerCase());
        })[0];

        // Check whether the context id is already loaded or not
        if (selectedContextId !== undefined) {
            if (firstLoadedContext === undefined) {
                firstLoadedContext = selectedContextId;
            }

            continue;
        }

        // Add the context id in the current session
        if (addContextId(contextId) == true) {
            displayContexts.push(contextId);
        }
    }

    // Display the context 
    if (displayContexts.length > 0) {
        AppendStudy(displayContexts);
    } else if (firstLoadedContext !== undefined) {
        ActivateStudy(firstLoadedContext);
    }
};

myHub.client.removeDisplayContext = function (sessionId, displayContextList) {

    if (!isCurrentSession(sessionId)) return;


    var i;
    for (i = 0; i < displayContextList.length; i++) {
        var contextId = displayContextList[i];
        contextId = decodeURIComponent(contextId).trim();
        var selectedContextId = currentDisplayContextList.filter(function (existingContextId) {
            return (existingContextId.trim().toLowerCase() === contextId.toLowerCase());
        })[0];

        // Check whether the context id is already loaded or not
        if (selectedContextId === undefined) {
            continue;
        }

        // Remove the context id
        removeStudyByContextID(selectedContextId);
        removeContextId(selectedContextId);
        if (currentDisplayContextList.length == 0) {
            showOrClearSession(false);
        }
    }
};

myHub.client.getDisplayContext = function (sessionId) {

    if (!isCurrentSession(sessionId)) return null;

    return currentDisplayContextList;
};

/**
 * Send the viewer status to Hix server
 * @param {Type} errorCode - Specifies the error code
 * @param {Type} descritpion  - Specifies the error description
 */
function sendViewerStatusMessage(errorCode, descritpion) {
    try {
        if (myHub === null || myHub === undefined) {
            return;
        }

        myHub
            .invoke('SendViewerMessage', errorCode, descritpion)
            .done(function () {

            })
            .fail(function (error) {
                dumpConsoleLogs(LL_ERROR, undefined, "sendViewerStatusMessage", 'Invocation of sendViewerStatusMessage failed. Error: ' + error);
            });
    } catch (e) {}
}

/**
 * Send the message to Qa page
 * @param {Type} data - Specifies the data
 */
function sendQaMessage(data) {
    try {
        if (myHub) {
            myHub.invoke('SendQaMessage', data)
                .done(function () {})
                .fail(function (error) {
                    dumpConsoleLogs(LL_ERROR, undefined, "SendQaMessage", 'Invocation of SendQaMessage failed. Error: ' + error);
                });
        }
    } catch (e) {}
}

$(document).ready(function () {
    //Increment the idle time counter every minute.
    var idleInterval = setInterval(timerIncrement, 60000); // 1 minute

    //Zero the idle timer on mouse movement.
    $(this).mousemove(function (e) {
        idleTime = 0;
    });
    $(this).keypress(function (e) {
        idleTime = 0;
    });
});

function timerIncrement() {
    idleTime = idleTime + 1;
    /*if (idleTime > 0) { // 1 minutes

    }*/
}

/**
 * To get idle timeout status
 */
myHub.client.getSessionIdleTime = function (taskId, sessionId) {
    try {
        if (myHub === null || myHub === undefined) {
            return;
        }

        if (!isCurrentSession(sessionId)) {
            setSessionIdleTime(taskId, false, 0);
            return;
        }

        setSessionIdleTime(taskId, true, idleTime * 60);
    } catch (e) {}
};

/**
 * Send the viewer idle timeout status to Hix server
 */
function setSessionIdleTime(taskId, isValidSession, idleTime) {
    myHub
        .invoke('setSessionIdleTime', taskId, isValidSession, idleTime, currentDisplayContextList)
        .done(function () {

        }).fail(function (error) {
            dumpConsoleLogs(LL_ERROR, undefined, "setSessionIdleTime", 'Invocation of setSessionIdleTime failed. Error: ' + error);
        });
}

/**
 * Remove the context Id 
 * @param {Type} contextId - Specifies the display context id
 */
function removeContextId(contextId) {
    try {
        if (contextId === null ||
            contextId === undefined ||
            currentDisplayContextList === null ||
            currentDisplayContextList === undefined ||
            currentDisplayContextList.length == 0) {
            return;
        }

        contextId = decodeURIComponent(contextId).trim();

        for (i = 0; i < currentDisplayContextList.length; i++) {
            if (currentDisplayContextList[i].trim().toLowerCase() === contextId.toLowerCase()) {
                currentDisplayContextList.splice(i, 1);
                PostRemoveContext(contextId);
                return;
            }
        }
    } catch (e) {}
}

/**
 * Add the context id
 * @param {Type} contextId  - Specifies the display context id
 */
function addContextId(contextId) {
    try {
        if (contextId === null ||
            contextId === undefined) {
            return false;
        }

        contextId = decodeURIComponent(contextId).trim();

        // check if context id already exists (case insensitive)
        for (i = 0; i < currentDisplayContextList.length; i++) {
            if (currentDisplayContextList[i].trim().toLowerCase() === contextId.toLowerCase())
                return false;
        }

        // add to list in original format trimmed
        currentDisplayContextList.push(contextId);
        return true;
    } catch (e) {}

    return false;
}

/**
 * post the remove context url to server
 */
function PostRemoveContext(contextId) {
    try {
        var t0 = Date.now();
        dumpConsoleLogs(LL_INFO, undefined, "PostRemoveContext ", "Start", undefined, true);

        var removeContextUrl = dicomViewer.url.getRemoveContextUrl(getSessionId());
        var contextList = [];
        contextList.push(contextId);
        var contextIdList = JSON.stringify(contextList);
        $.ajax({
                type: 'DELETE',
                url: removeContextUrl,
                data: contextIdList
            })
            .success(function (data) {
                dumpConsoleLogs(LL_INFO, undefined, "PostRemoveContext ", "End", (Date.now() - t0), true);
            })
            .fail(function (e) {})
    } catch (e) {
        dumpConsoleLogs(LL_ERROR, undefined, "PostRemoveContext", e.message, undefined, true);
    } finally {}
}
