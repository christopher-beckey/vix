namespace Hydra.Entities
{
    public class PixelSpacing
    {
        public double Row { get; set; }

        public double Column { get; set; }

        public PixelSpacing()
        {
        }

        public bool IsNull
        {
            get { return ((Row == 0) || (Column == 0)); }
        }

        public PixelSpacingCalibrationType CalibrationType
        {
            get;
            set;
        }

        /// <summary>
        /// Enumerated values indicating the type of calibration represented by pixel spacing, if any.
        /// </summary>
        public enum PixelSpacingCalibrationType
        {
            /// <summary>
            /// Indicates that the pixel spacing is not calibrated.
            /// </summary>
            None,

            /// <summary>
            /// Indicates that the pixel spacing has been calibrated manually by the user.
            /// </summary>
            Manual,

            /// <summary>
            /// Indicates that the pixel spacing has been calibrated in some unspecified manner.
            /// </summary>
            Unknown,

            /// <summary>
            /// Indicates that the pixel spacing represents the actual spacing in the patient for the cross-sectional image.
            /// </summary>
            CrossSectionalSpacing,

            /// <summary>
            /// Indicates that the pixel spacing represents the spacing at the detector plane for the projection image.
            /// </summary>
            Detector,

            /// <summary>
            /// Indicates that the pixel spacing has been calibrated for assumed or known
            /// geometric magnification effects at some unspecified depth within the patient for the projection image.
            /// </summary>
            Geometry,

            /// <summary>
            /// Indicates that the pixel spacing has been calibrated by measurement of an
            /// object (fiducial) of known size in the projection image.
            /// </summary>
            Fiducial,

            /// <summary>
            /// Indicates that the pixel spacing has been calibrated against the estimated
            /// radiographic magnification factor provided in the projection image.
            /// </summary>
            Magnified
        }
    }
}