namespace Hydra.Common.Extensions
{
    public static class ImageTypeExtensions
    {
        public static string AsString(this ImageType imageType)
        {
            switch (imageType)
            {
                case ImageType.Jpeg: return "jpeg";
                case ImageType.Pdf: return "pdf";
                case ImageType.Rad: return "rad";
                case ImageType.RadECG: return "radecg";
                case ImageType.RadEcho: return "radecho";
                case ImageType.RadPdf: return "radpdf";
                case ImageType.RadSR: return "radsr";
                case ImageType.Audio: return "audio";
                case ImageType.Video: return "video";
                //case ImageType.Blob: return "blob";
                case ImageType.Tiff: return "tiff";
                case ImageType.CDA: return "cda";
                case ImageType.Unknown: return "unknown";
            }

            return null;
        }
    }
}