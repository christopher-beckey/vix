namespace Hydra.Common
{
    public enum ImagePartType
    {
        Abstract = 0,
        ImageInfo,
        Frame,
        Waveform,
        Header,
        Original,
        Media,
        Overlay,
        DcmPR,
        DcmHeader,
        PdfPrint
    }

    public enum ImagePartTransform
    {
        Default = 0,
        DicomData,
        Jpeg,
        Png,
        Pdf,
        Json,
        Html,
        Mp3,
        Media,
        Mp4,
        Avi,
        Webm,
        DicomHeader,
        Tiff
    }

    public class ImagePart
    {
        public int Frame { get; set; }
        public ImagePartType Type { get; set; }
        public ImagePartTransform Transform { get; set; }
        public string FilePath { get; set; }
        public bool IsStatic { get; set; }
        public int? OverlayIndex { get; set; }
    }
}