/*
    To render the patient orientation lables
*/
var dicomViewer = (function (dicomViewer) {

    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }
    var hFlipCount = false;
    var vFlipCount = false;
    var directionalMarker = {
        left: 'L',
        right: 'R',
        bottom: 'F',
        top: 'H'
    };

    function initDirectionalMarker(imageinfo) {
        if (imageinfo != undefined) {
            var markers = imageinfo.getDirectionalMarkers();
            if (markers != null) {
                // Set the default values if the markers is not available to avoid null condition.
                if (directionalMarker == null) {
                    directionalMarker = {
                        left: 'L',
                        right: 'R',
                        bottom: 'F',
                        top: 'H'
                    };
                }

                directionalMarker.left = markers.left;
                directionalMarker.right = markers.right;
                directionalMarker.bottom = markers.bottom;
                directionalMarker.top = markers.top;
            } else {
                directionalMarker = null;
            }
        }
    }

    /* Get the image orientation */
    function getDirectionalMarker() {
        return directionalMarker;
    }

    /* Rotate the patient lables to the degree given */
    function rotateDirectionalMarker(presentation) {
        var rotation = (presentation.getRotation()) / 90; // Find the number of times to rotate the patient lables
        var rotationDirection = rotation < 0 ? -1 : 1; // Find the rotation direction from current position        
        rotation = rotation * rotationDirection;
        if (directionalMarker != null) {
            for (var rotationCount = 0; rotationCount < rotation; rotationCount++) {
                if (rotationDirection == 1) // Rotate in clock wise
                {
                    var left = directionalMarker.left;
                    directionalMarker.left = directionalMarker.bottom;
                    directionalMarker.bottom = directionalMarker.right;
                    directionalMarker.right = directionalMarker.top;
                    directionalMarker.top = left;
                } else // Rotate in anti-clock wise
                {
                    var left = directionalMarker.left;
                    directionalMarker.left = directionalMarker.top;
                    directionalMarker.top = directionalMarker.right;
                    directionalMarker.right = directionalMarker.bottom;
                    directionalMarker.bottom = left;
                }
            }
            if (presentation.getHorizontalFilp() && presentation.getVerticalFilp()) {
                hFlipCount = false;
                vFlipCount = false;
            }
            if ((presentation.getHorizontalFilp() && !hFlipCount) || (presentation.getHorizontalFilp() && !vFlipCount) || (presentation.getHorizontalFilp() && vFlipCount)) {
                var left = directionalMarker.left;
                directionalMarker.left = directionalMarker.right;
                directionalMarker.right = left;
                hFlipCount = !hFlipCount;
            }
            if ((presentation.getVerticalFilp() && !vFlipCount) || (presentation.getVerticalFilp() && !hFlipCount) || (presentation.getVerticalFilp() && hFlipCount)) {
                var top = directionalMarker.top;
                directionalMarker.top = directionalMarker.bottom;
                directionalMarker.bottom = top;
                vFlipCount = !vFlipCount;
            }
        }
    }


    dicomViewer.directionalMarker = {
        initDirectionalMarker: initDirectionalMarker,
        getDirectionalMarker: getDirectionalMarker,
        rotateDirectionalMarker: rotateDirectionalMarker
    };

    return dicomViewer;
}(dicomViewer));
