var dicomViewer = (function (dicomViewer) {

    "use strict";

    if (dicomViewer === undefined) {
        dicomViewer = {};
    }
    var TOLERANCE = 0.0005; // about e-7.6	//for comparison in float and double calculation 

    var imageCosX;
    var imageCosY;
    var imageCosZ;

    var scoutCosX;
    var scoutCosY;
    var scoutCosZ;

    var imageRowLength;
    var imageColumnLength;

    var pAngle;

    function isScoutAndAxialParallel() {
        var mParallel = false;
        //Use dot product to find the angle between two vectors.	
        //Theoretically to get the cosine_theta we need to do Dot(Vector_imgNml, Vector_scoutNml)/(|Vector_imgNrm| x |Vector_scoutNrm|)
        //but since we use direction cosines to represent those vectors, the vector's length is always 1
        var cosine_theta = parseFloat((imageCosX * scoutCosX + imageCosY * scoutCosY + imageCosZ * scoutCosZ));

        //if (Parallel) {
        if (Math.abs(cosine_theta) >= 0.97) {
            mParallel = true;
        } else {
            mParallel = false;
        }
        // }

        pAngle = cosine_theta;
        return mParallel;
    }

    function checkVector(CosX, CosY, CosZ) {
        if (Math.abs(CosX * CosX + CosY * CosY + CosZ * CosZ) < (1 - TOLERANCE)) {
            return (false);
        } else {
            return (true);
        }
    }

    function normalizeImage(imageRowCos, imageColCos) {
        imageCosX = parseFloat(imageRowCos.y * imageColCos.z - imageRowCos.z * imageColCos.y);
        imageCosY = parseFloat(imageRowCos.z * imageColCos.x - imageRowCos.x * imageColCos.z);
        imageCosZ = parseFloat(imageRowCos.x * imageColCos.y - imageRowCos.y * imageColCos.x);

        return (checkVector(imageCosX, imageCosY, imageCosZ));
    }

    function normalizeScout(scoutRowCos, scoutColCos) {
        scoutCosX = parseFloat(scoutRowCos.y * scoutColCos.z - scoutRowCos.z * scoutColCos.y);
        scoutCosY = parseFloat(scoutRowCos.z * scoutColCos.x - scoutRowCos.x * scoutColCos.z);
        scoutCosZ = parseFloat(scoutRowCos.x * scoutColCos.y - scoutRowCos.y * scoutColCos.x);

        return (checkVector(scoutCosX, scoutCosY, scoutCosZ));
    }

    function setImgDimensions(imageInfo, imageSpacing) {
        imageRowLength = imageInfo.columns * imageSpacing.x;
        imageColumnLength = imageInfo.rows * imageSpacing.y;
    }

    function calculateAxisPoints(scoutRowCos, scoutColCos, imageRowCos, imageColCos, scoutValue, scoutSpacing, imageValue) {
        // the four points in 3d space that defines the corners of the bounding box
        var posX = [];
        var posY = [];
        var posZ = [];
        var rowPixel = [];
        var colPixel = [];
        var i;

        // upper center
        posX[0] = parseFloat(imageValue.x + imageRowCos.x * imageRowLength / 2);
        posY[0] = parseFloat(imageValue.y + imageRowCos.y * imageRowLength / 2);
        posZ[0] = parseFloat(imageValue.z + imageRowCos.z * imageRowLength / 2);

        // right hand center

        posX[1] = parseFloat(imageValue.x + imageRowCos.x * imageRowLength + imageColCos.x * imageColumnLength / 2);
        posY[1] = parseFloat(imageValue.y + imageRowCos.y * imageRowLength + imageColCos.y * imageColumnLength / 2);
        posZ[1] = parseFloat(imageValue.z + imageRowCos.z * imageRowLength + imageColCos.z * imageColumnLength / 2);

        // Buttom center

        posX[2] = parseFloat(posX[0] + imageColCos.x * imageColumnLength);
        posY[2] = parseFloat(posY[0] + imageColCos.y * imageColumnLength);
        posZ[2] = parseFloat(posZ[0] + imageColCos.z * imageColumnLength);

        // left hand center

        posX[3] = parseFloat(imageValue.x + imageColCos.x * imageColumnLength / 2);
        posY[3] = parseFloat(imageValue.y + imageColCos.y * imageColumnLength / 2);
        posZ[3] = parseFloat(imageValue.z + imageColCos.z * imageColumnLength / 2);

        // Go through all four corners

        for (i = 0; i < 4; i++) {
            // we want to view the source slice from the "point of view" of
            // the target localizer, i.e. a parallel projection of the source
            // onto the target

            // do this by imaging that the target localizer is a view port
            // into a relocated and rotated co-ordinate space, where the
            // viewport has a row vector of +X, col vector of +Y and normal +Z,
            // then the X and Y values of the projected target correspond to
            // row and col offsets in mm from the TLHC of the localizer image !

            // move everything to origin of target
            posX[i] = parseFloat(posX[i] - scoutValue.x);
            posY[i] = parseFloat(posY[i] - scoutValue.y);
            posZ[i] = parseFloat(posZ[i] - scoutValue.z);

            // declare local variables.  The code uses the same variables outside to send in values
            // and retrieve the results !
            var x = parseFloat(scoutRowCos.x * posX[i] + scoutRowCos.y * posY[i] + scoutRowCos.z * posZ[i]);
            var y = parseFloat(scoutColCos.x * posX[i] + scoutColCos.y * posY[i] + scoutColCos.z * posZ[i]);
            var z = parseFloat(scoutCosX * posX[i] + scoutCosY * posY[i] + scoutCosZ * posZ[i]);

            posX[i] = x;
            posY[i] = y;
            posZ[i] = z;

            // at this point the position contains the location on the scout image. calculate the pixel position
            // dicom coordinates are center of pixel 1\1
            colPixel[i] = parseInt((posX[i] / scoutSpacing.x) + 0.5);
            rowPixel[i] = parseInt((posY[i] / scoutSpacing.y) + 0.5);
        }
        return {
            pixelColumn: colPixel,
            pixelRow: rowPixel
        }
    }

    function projectSlice(scoutPosition, scoutOrientation, scoutPixelSpacing, scoutRows, scoutColumns, imagePosition, imageOrientation, imagePixelSpacing, imageRows, imageColumns, a_parallel, a_pAngle) {
        var scoutValue = {
            x: scoutPosition[0],
            y: scoutPosition[1],
            z: scoutPosition[2]
        };

        var scoutRowCos = {
            x: scoutOrientation[0],
            y: scoutOrientation[1],
            z: scoutOrientation[2]
        };

        var scoutColCos = {
            x: scoutOrientation[3],
            y: scoutOrientation[4],
            z: scoutOrientation[5]
        };

        var scoutSpacing = {
            x: parseFloat(scoutPixelSpacing[1]),
            y: parseFloat(scoutPixelSpacing[0])
        };

        var scout = {
            rows: scoutRows,
            columns: scoutColumns
        };

        var imageValue = {
            x: imagePosition[0],
            y: imagePosition[1],
            z: imagePosition[2]
        };

        var imageRowCos = {
            x: imageOrientation[0],
            y: imageOrientation[1],
            z: imageOrientation[2]
        };

        var imageColCos = {
            x: imageOrientation[3],
            y: imageOrientation[4],
            z: imageOrientation[5]
        };

        var imageSpacing = {
            x: parseFloat(imagePixelSpacing[0]),
            y: parseFloat(imagePixelSpacing[1])
        };

        var imageInfo = {
            rows: imageRows,
            columns: imageColumns
        };

        normalizeImage(imageRowCos, imageColCos);
        normalizeScout(scoutRowCos, scoutColCos);
        isScoutAndAxialParallel();

        if (!normalizeScout(scoutRowCos, scoutColCos) || !normalizeImage(imageRowCos, imageColCos)) {
            return false;
        }

        setImgDimensions(imageInfo, imageSpacing);

        if (a_parallel) {
            normalizeImage(imageRowCos, imageColCos);
            normalizeScout(scoutRowCos, scoutColCos);
            isScoutAndAxialParallel();
        }

        return calculateAxisPoints(scoutRowCos, scoutColCos, imageRowCos, imageColCos, scoutValue, scoutSpacing, imageValue);
    }

    /**
     *@param sourceImagePlane
     *@param targetImagePlane
     *Calculate the projection data
     */
    function calculateProjectSlice(sourceImagePlane, targetImagePlane) {

        if (sourceImagePlane != null && targetImagePlane != null) {
            var sourceOrientation = [];
            var sourcePixelSpacing = [];
            var sourcePosition = [];
            var sourceRows = 0;
            var sourceColumns = 0;

            var targetPosition = [];
            var targetOrientation = [];
            var targetPixelSpacing = [];
            var targetRows = 0;
            var targetColumns = 0;
            var pAngle = 0.0;
            var isParallel = false;

            var topX;
            var topY;
            var bottomX;
            var bottomY;
            var leftX;
            var leftY;
            var rightX;
            var rightY;
            var dLength0;
            var dLength1;
            var line = {
                x1: 0,
                x2: 0,
                y1: 0,
                y2: 0
            };

            var bParallel = false;
            var bIntersect = false;

            //Parse the target image planes.

            //Target Image Position
            targetPosition[0] = targetImagePlane.posX;
            targetPosition[1] = targetImagePlane.posY;
            targetPosition[2] = targetImagePlane.posZ;

            //Target Image Orientation
            targetOrientation[0] = targetImagePlane.rowX;
            targetOrientation[1] = targetImagePlane.rowY;
            targetOrientation[2] = targetImagePlane.rowZ;
            targetOrientation[3] = targetImagePlane.colX;
            targetOrientation[4] = targetImagePlane.colY;
            targetOrientation[5] = targetImagePlane.colZ;

            //Target Image Pixel Space
            targetPixelSpacing[0] = targetImagePlane.pixX;
            targetPixelSpacing[1] = targetImagePlane.pixY;

            //Target Image Dimension
            targetRows = targetImagePlane.rows;
            targetColumns = targetImagePlane.cols;

            //Parse the source image planes.

            //Target Image Position
            sourcePosition[0] = sourceImagePlane.posX;
            sourcePosition[1] = sourceImagePlane.posY;
            sourcePosition[2] = sourceImagePlane.posZ;

            //Target Image Orientation
            sourceOrientation[0] = sourceImagePlane.rowX;
            sourceOrientation[1] = sourceImagePlane.rowY;
            sourceOrientation[2] = sourceImagePlane.rowZ;
            sourceOrientation[3] = sourceImagePlane.colX;
            sourceOrientation[4] = sourceImagePlane.colY;
            sourceOrientation[5] = sourceImagePlane.colZ;

            //Target Image Pixel Space
            sourcePixelSpacing[0] = sourceImagePlane.pixX;
            sourcePixelSpacing[1] = sourceImagePlane.pixY;

            //Target Image Dimension
            sourceRows = sourceImagePlane.rows;
            sourceColumns = sourceImagePlane.cols;

            var pixels = projectSlice(targetPosition, targetOrientation, targetPixelSpacing, targetRows, targetColumns, sourcePosition, sourceOrientation, sourcePixelSpacing, sourceRows, sourceColumns, isParallel, pAngle);

            topX = pixels.pixelColumn[0];
            topY = pixels.pixelRow[0];
            rightX = pixels.pixelColumn[1];
            rightY = pixels.pixelRow[1];
            bottomX = pixels.pixelColumn[2];
            bottomY = pixels.pixelRow[2];
            leftX = pixels.pixelColumn[3];
            leftY = pixels.pixelRow[3];

            /* Find the lengths of the axes */
            dLength0 = Math.sqrt(parseInt(Math.pow(parseFloat(topX) - bottomX, 2) +
                Math.pow(parseFloat(topY) - bottomY, 2)));

            dLength1 = Math.sqrt(parseInt(Math.pow(parseFloat(leftX) - rightX, 2) +
                Math.pow(parseFloat(leftY) - rightY, 2)));

            if (isScoutAndAxialParallel() === true)
                return undefined;

            /* Find the greater of them and return the coods */
            if (dLength0 >= dLength1) {
                line.x1 = topX;
                line.x2 = bottomX;

                line.y1 = topY;
                line.y2 = bottomY;
            } else {
                line.x1 = leftX;
                line.x2 = rightX;

                line.y1 = leftY;
                line.y2 = rightY;
            }

            return line;
        }
    }

    dicomViewer.xRefLineViewer = {
        calculateProjectSlice: calculateProjectSlice,
    };

    return dicomViewer;
}(dicomViewer));
