var dicomViewer = (function (dicomViewer) {

    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    var xRefLineStore = Object.create(null, {});

    /**
     *@param studyData
     *set the study details to parse the xref lines 
     */
    function renderXRefLines(studyData) {
        createXRefWorkerQueue(studyData);
    }

    /**
     * 
     * @param {*} sourceImageUid 
     * @param {*} targetImageUid 
     * @param {*} value 
     */
    function addRefLinesViewerCode(sourceImageUid, targetImageUid, value) {
        if (value == undefined) {
            return;
        }
        xRefLineStore[getRefLineKey(sourceImageUid, targetImageUid)] = value.x1 + ";" + value.x2 + ";"
            + value.y1 + ";" + value.y2;
    }

    /**
     * 
     * @param {*} sourceImageUid 
     * @param {*} targetImageUid 
     */
    function getRefLine(sourceImageUid, targetImageUid) {
        var xref = xRefLineStore[getRefLineKey(sourceImageUid, targetImageUid)];
        if (xref) {
            xref = xref.split(';');
            return { x1: xref[0], x2: xref[1], y1: xref[2], y2: xref[3] }
        } else {
            return undefined;
        }
    }

    /**
     * 
     * @param {*} sourceImageUid 
     * @param {*} targetImageUid 
     */
    function getRefLineKey(sourceImageUid, targetImageUid) {
        return sourceImageUid + "x" + targetImageUid;
    }

    /**
     * create xRef worker queue
     * @param {Type} study 
     */
    function createXRefWorkerQueue(study) {
        try {
            if (study === undefined || study === null) {
                return;
            }

            var images = [];
            for (var index = 0; index < study.seriesCount; index++) {
                images = images.concat(dicomViewer.Series.getAllImages(study.studyUid, index));
            }

            if (study.isXRefLineFound !== true) {
                return;
            }

            var xRefWorkerQueue = new WorkerQueue("js/dicom/imageCacheWorker.js");
            var jobIdIncrementer = 1;
            images.forEach(function (image) {
                var workerJob = {
                    sourceImage: image,
                    targetImages: images,
                    type: "xRef",
                    id: jobIdIncrementer,
                    workerQueue: xRefWorkerQueue,
                    isProcessing: false,
                    terminateWorker: (images.length == jobIdIncrementer ? true : false)
                };

                var xRefWorkerThread = new WorkerThread(workerJob);
                xRefWorkerQueue.push(function () {
                    return xRefWorkerThread.processJob(xRefWorkerQueue)
                });
                jobIdIncrementer++;
            });
        } catch (e) { }
    }

    dicomViewer.xRefLine = {
        getRefLine: getRefLine,
        renderXRefLines: renderXRefLines,
        addRefLinesViewerCode: addRefLinesViewerCode
    };

    return dicomViewer;
}(dicomViewer));
