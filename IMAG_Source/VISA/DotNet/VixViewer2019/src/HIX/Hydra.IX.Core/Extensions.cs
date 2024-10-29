using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Core
{
    public static class Extensions
    {
        public static bool IsText(this Hydra.Common.ImagePartTransform transformType)
        {
            switch (transformType)
            {
                case Hydra.Common.ImagePartTransform.Html:
                case Hydra.Common.ImagePartTransform.Json:
                    return true;
                default: return false;
            }
        }

        public static bool IsDicom(this Hydra.Common.ImageType imageType)
        {
            switch (imageType)
            {
                case Hydra.Common.ImageType.Rad:
                case Hydra.Common.ImageType.RadECG:
                case Hydra.Common.ImageType.RadEcho:
                case Hydra.Common.ImageType.RadPdf:
                case Hydra.Common.ImageType.RadSR:
                case Hydra.Common.ImageType.RadPR:
                    return true;
                default:
                    return false;
            }
        }

        public static bool IsBlob(this Hydra.Common.ImageType imageType)
        {
            return ((imageType == Hydra.Common.ImageType.Pdf) ||
                    (imageType == Hydra.Common.ImageType.Video) ||
                    (imageType == Hydra.Common.ImageType.Audio) ||
                    (imageType == Hydra.Common.ImageType.Tiff) ||
                    (imageType == Hydra.Common.ImageType.Unknown));
        }

        public static string DetectFileExtension(this Hydra.IX.Database.Common.ImageFile imageFile)
        {
            var fileExtension = Path.GetExtension(imageFile.FileName);
            if (string.IsNullOrEmpty(fileExtension))
            {
                switch (imageFile.FileType)
                {
                    case Hydra.Common.FileType.Dicom:
                        fileExtension = ".dcm";
                        break;

                    case Hydra.Common.FileType.Document_Pdf:
                        fileExtension = ".pdf";
                        break;

                    case Hydra.Common.FileType.Document_Word:
                        fileExtension = ".doc";
                        break;

                    case Hydra.Common.FileType.Video_Avi:
                        fileExtension = ".avi";
                        break;

                    case Hydra.Common.FileType.Video_Mp4:
                        fileExtension = ".mp4";
                        break;

                    case Hydra.Common.FileType.Audio_Mp3:
                        fileExtension = ".mp3";
                        break;

                    case Hydra.Common.FileType.Audio_Wav:
                        fileExtension = ".wav";
                        break;

                    case Hydra.Common.FileType.Document_CDA:
                        fileExtension = ".xml";
                        break;

                    case Hydra.Common.FileType.Image:
                        {
                            switch (imageFile.ImageType)
                            {
                                case Hydra.Common.ImageType.Jpeg:
                                    fileExtension = ".jpeg";
                                    break;
                            }
                        }
                        break;
                }
            }

            return fileExtension;
        }
    }
}
