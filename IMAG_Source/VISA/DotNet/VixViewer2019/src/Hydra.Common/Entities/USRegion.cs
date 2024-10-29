namespace Hydra.Entities
{
    public class USRegion
    {
        public PixelSpacing PixelSpacing { get; set; }

        public int PhysicalUnitsXDirection { get; set; }

        public int PhysicalUnitsYDirection { get; set; }

        public int RegionSpatialFormat { get; set; }

        public int RegionDataType { get; set; }

        public int RegionFlags { get; set; }

        public int RegionLocationMinX0 { get; set; }

        public int RegionLocationMinY0 { get; set; }

        public int RegionLocationMaxX1 { get; set; }

        public int RegionLocationMaxY1 { get; set; }

        public int ReferencePixelX0 { get; set; }

        public int ReferencePixelY0 { get; set; }

        public bool IsReferencePixelX0Present { get; set; }

        public bool IsReferencePixelY0Present { get; set; }

        public float ReferencePixelPhysicalValueX { get; set; }

        public float ReferencePixelPhysicalValueY { get; set; }

        public float PhysicalDeltaX { get; set; }

        public float PhysicalDeltaY { get; set; }

        public float DopplerCorrectionAngle { get; set; }

        public int PixelComponentPhysicalUnits { get; set; }
    }
}