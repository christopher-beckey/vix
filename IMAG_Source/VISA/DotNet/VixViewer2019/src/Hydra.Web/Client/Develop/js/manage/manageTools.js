var dicomViewer = (function (dicomViewer) {
    if (dicomViewer === undefined) {
        dicomViewer = {};
    }

    function selectAllImages() {}

    function doPan() {}

    function rotate() {}

    dicomViewer.tools = {
        selectAllImages: selectAllImages,
        doPan: doPan,
        rotate: rotate
    };

    return dicomViewer;

}(dicomViewer));
