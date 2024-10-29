using ClearCanvas.Dicom.Iod;
using ClearCanvas.ImageViewer.Mathematics;
using ClearCanvas.ImageViewer.StudyManagement;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;

namespace ClearCanvas.ImageViewer
{
    public class DicomImagePlane
    {
        #region Private Fields

        private readonly ImagePlaneHelper _sourceImagePlaneHelper;

        #endregion

        public DicomImagePlane(ImagePositionPatient imagePositionPatient, ImageOrientationPatient imageOrientationPatient, PixelSpacing pixelSpacing, int rows, int columns)
        {
            _sourceImagePlaneHelper = new ImagePlaneHelper(imagePositionPatient, imageOrientationPatient, pixelSpacing, rows, columns);
        }

        #region Public Properties

        public DicomImagePlane()
        {

        }

        public string StudyInstanceUid
        {
            get;
            set;
        }

        public string SeriesInstanceUid
        {
            get;
            set;
        }

        public string SopInstanceUid
        {
            get;
            set;
        }

        public int InstanceNumber
        {
            get;
            set;
        }

        public int FrameNumber
        {
            get;
            set;
        }

        public string FrameOfReferenceUid
        {
            get;
            set;
        }

        public float Thickness
        {
            get;
            set;
        }

        public float Spacing
        {
            get;
            set;
        }

        public Vector3D Normal
        {
            get { return _sourceImagePlaneHelper.ImageNormalPatient; }
        }

        public Vector3D PositionPatientTopLeft
        {
            get { return _sourceImagePlaneHelper.ImageTopLeftPatient; }
        }

        public Vector3D PositionPatientTopRight
        {
            get { return _sourceImagePlaneHelper.ImageTopRightPatient; }
        }

        public Vector3D PositionPatientBottomLeft
        {
            get { return _sourceImagePlaneHelper.ImageBottomLeftPatient; }
        }

        public Vector3D PositionPatientBottomRight
        {
            get { return _sourceImagePlaneHelper.ImageBottomRightPatient; }
        }

        public Vector3D PositionPatientCenterOfImage
        {
            get { return _sourceImagePlaneHelper.ImageCenterPatient; }
        }

        public Vector3D PositionImagePlaneTopLeft
        {
            get { return _sourceImagePlaneHelper.TopLeftImagePlane; }
        }

        #endregion

        #region Public Methods

        //public Vector3D ConvertToPatient(PointF imagePoint)
        //{
        //    var provider = _sourceImage as IPatientCoordinateMappingProvider;
        //    if (provider != null && provider.PatientCoordinateMapping.IsValid)
        //        return provider.PatientCoordinateMapping.ConvertToPatient(imagePoint);
        //    return _sourceFrame.ImagePlaneHelper.ConvertToPatient(imagePoint);
        //}

        public Vector3D ConvertToImagePlane(Vector3D positionPatient)
        {
            return _sourceImagePlaneHelper.ConvertToImagePlane(positionPatient);
        }

        public Vector3D ConvertToImagePlane(Vector3D positionPatient, Vector3D originPatient)
        {
            return _sourceImagePlaneHelper.ConvertToImagePlane(positionPatient, originPatient);
        }

        public PointF ConvertToImage(PointF positionMillimetres)
        {
            return _sourceImagePlaneHelper.ConvertToImage2(positionMillimetres);
        }

        public bool IsInSameFrameOfReference(DicomImagePlane other)
        {
            //Frame otherFrame = other._sourceFrame;

            //if (_sourceFrame.ParentImageSop.StudyInstanceUid != otherFrame.ParentImageSop.StudyInstanceUid)
            //    return false;

            return this.FrameOfReferenceUid == other.FrameOfReferenceUid;
        }

        public bool IsParallelTo(DicomImagePlane other, float angleTolerance)
        {
            return _sourceImagePlaneHelper.IsParallelTo(other._sourceImagePlaneHelper, angleTolerance);
        }

        public bool IsOrthogonalTo(DicomImagePlane other, float angleTolerance)
        {
            return _sourceImagePlaneHelper.IsOrthogonalTo(other._sourceImagePlaneHelper, angleTolerance);
        }

        public float GetAngleBetween(DicomImagePlane other)
        {
            return _sourceImagePlaneHelper.GetAngleBetween(other._sourceImagePlaneHelper);
        }

        public bool GetIntersectionPoints(DicomImagePlane other, out Vector3D intersectionPointPatient1, out Vector3D intersectionPointPatient2)
        {
            return _sourceImagePlaneHelper.IntersectsWith(other._sourceImagePlaneHelper, out intersectionPointPatient1, out intersectionPointPatient2);
        }

        #endregion
    }
}
