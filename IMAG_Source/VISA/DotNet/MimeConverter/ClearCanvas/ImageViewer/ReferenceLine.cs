using ClearCanvas.ImageViewer.Mathematics;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;

namespace ClearCanvas.ImageViewer
{
    public class ReferenceLine
    {
        public readonly PointF StartPoint;
        public readonly PointF EndPoint;
        public readonly string Label;

        private static float _parallelPlanesToleranceAngleRadians = -1;
        private static float _parallelPlanesToleranceAngle = 10;

        public ReferenceLine(PointF startPoint, PointF endPoint, string label)
        {
            this.StartPoint = startPoint;
            this.EndPoint = endPoint;
            this.Label = label;
        }

        public static ReferenceLine GetReferenceLine(DicomImagePlane referenceImagePlane, DicomImagePlane targetImagePlane)
        {
            // if planes are parallel within tolerance, then they do not intersect and thus no reference lines should be shown
            float parallelTolerance = ParallelPlanesToleranceAngleRadians;
            if (referenceImagePlane.IsParallelTo(targetImagePlane, parallelTolerance))
                return null;

            Vector3D intersectionPatient1, intersectionPatient2;
            if (!referenceImagePlane.GetIntersectionPoints(targetImagePlane, out intersectionPatient1, out intersectionPatient2))
                return null;

            Vector3D intersectionImagePlane1 = targetImagePlane.ConvertToImagePlane(intersectionPatient1);
            Vector3D intersectionImagePlane2 = targetImagePlane.ConvertToImagePlane(intersectionPatient2);

            //The coordinates need to be converted to pixel coordinates because right now they are in mm.
            PointF intersectionImage1 = targetImagePlane.ConvertToImage(new PointF(intersectionImagePlane1.X, intersectionImagePlane1.Y));
            PointF intersectionImage2 = targetImagePlane.ConvertToImage(new PointF(intersectionImagePlane2.X, intersectionImagePlane2.Y));
            string label = referenceImagePlane.InstanceNumber.ToString();

            return new ReferenceLine(intersectionImage1, intersectionImage2, label);
        }

        public static float ParallelPlanesToleranceAngleDegrees
        {
            get
            {
                var value = _parallelPlanesToleranceAngle;
                return value == 0F ? 100 * float.Epsilon : value;
            }
        }

        /// <summary>
        /// Gets the maximum angle difference, in radians, between two planes for synchronization tools to treat the planes as parallel.
        /// </summary>
        /// <seealso cref="ParallelPlanesToleranceAngleDegrees"/>
        public static float ParallelPlanesToleranceAngleRadians
        {
            get
            {
                if (_parallelPlanesToleranceAngleRadians < 0)
                    _parallelPlanesToleranceAngleRadians = ParallelPlanesToleranceAngleDegrees * (float)Math.PI / 180F;
                return _parallelPlanesToleranceAngleRadians;
            }
        }

    }
}
