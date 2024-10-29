namespace SCIP_Tool //TODO - temp Hydra.Entities
{
    public class ImageInfo
    {
        public string ImageType { get; set; }
        public ushort BitsAllocated { get; set; }
        public ushort BitsStored { get; set; }
        public ushort HighBit { get; set; }
        public ushort ImageHeight { get; set; }
        public ushort ImageWidth { get; set; }
        public int FrameSize { get; set; }
        public int NumberOfFrames { get; set; }
        public string PhotometricInterpretation { get; set; }
        public ushort PixelRepresentation { get; set; }
        public ushort PlanarConfiguration { get; set; }
        public ushort SamplesPerPixel { get; set; }
        public bool IsPlanar { get; set; }
        public bool IsSigned { get; set; }
        public bool IsColor { get; set; }
        public int MinPixelValue { get; set; }
        public int MaxPixelValue { get; set; }
        public decimal DecimalRescaleIntercept { get; set; }
        public decimal DecimalRescaleSlope { get; set; }
        public double WindowWidth { get; set; }
        public double WindowCenter { get; set; }
        public string PatientName { get; set; }
        public string StudyDate { get; set; }
        public string StudyTime { get; set; }
        public string SeriesTime { get; set; }
        public string Modality { get; set; }
        public string AccessionNumber { get; set; }
        public string Manufacturer { get; set; }
        public string InstanceNumber { get; set; }
        public bool IsCompressed { get; set; }
        //TODO - temp public DirectionalMarkers DirectionalMarkers { get; set; }
        //TODO - temp public Measurement Measurement { get; set; }
        public double CineRate { get; set; }
        public string ContentDate { get; set; }
        public string ContentTime { get; set; }
        //TODO - temp public Overlay[] Overlays { get; set; }
    }
}