using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Common
{
    public class VolumeFrame
    {
        public string GroupUid { get; set; }
        public string ImageUid { get; set; }
        public int Frame { get; set; }
        public int FrameCount { get; set; }
        public string SeriesInstanceUid { get; set; }
        public string StudyInstanceUid { get; set; }
        public int BitsPerPixel { get; set; }
        public int HighBit { get; set; }
        public int RelevantBits { get; set; }
        public float DimensionX { get; set; }
        public float DimensionY { get; set; }
        public float OrientationM11 { get; set; }
        public float OrientationM21 { get; set; }
        public float OrientationM31 { get; set; }
        public float OrientationM12 { get; set; }
        public float OrientationM22 { get; set; }
        public float OrientationM32 { get; set; }
        public float OrientationM13 { get; set; }
        public float OrientationM23 { get; set; }
        public float OrientationM33 { get; set; }
        public float SpacingX { get; set; }
        public float SpacingY { get; set; }
        public float SpacingZ { get; set; }
        public bool IsSigned { get; set; }
        public int PixelPaddingValue { get; set; }
        public float WindowWidth { get; set; }
        public float WindowCenter { get; set; }
        public float RescaleIntercept { get; set; }
        public float RescaleSlope { get; set; }
        public string FilePath { get; set; }
    }
}
