using Hydra.Common;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public class ImageProcessResultset
    {
        public string FileName { get; private set; }
        public string TargetFolder { get; private set; }
        public ImageType ImageType { get; set; }
        public List<ImagePart> ImageParts { get; set; }
        //public List<VolumeFrame> VolumeFrames { get; set; }
        public Hydra.Entities.Image Image { get; set; }
        public string DicomDirXml { get; set; }
        public string DicomXml { get; set; }
        public bool NeedsUnsupportedTypeCleanUp { get; set; }

        public ImageProcessResultset(string fileName, string targetFolder)
        {
            FileName = fileName;
            TargetFolder = targetFolder;
            ImageParts = new List<ImagePart>();
            NeedsUnsupportedTypeCleanUp = false;
        }

        public ImagePart AddAbstract()
        {
            return AddImagePart(ImagePartType.Abstract, ImagePartTransform.Jpeg);
        }

        public ImagePart AddJsonHeader()
        {
            return AddImagePart(ImagePartType.Header, ImagePartTransform.Json);
        }

        public ImagePart AddDicomHeader()
        {
            return AddImagePart(ImagePartType.DcmHeader, ImagePartTransform.DicomHeader);
        }

        public ImagePart AddImageInfo()
        {
            return AddImagePart(ImagePartType.ImageInfo, ImagePartTransform.Json);
        }

        public ImagePart AddWaveform(ImagePartTransform transform)
        {
            Debug.Assert((transform == ImagePartTransform.Json) || 
                         (transform == ImagePartTransform.Png));

            return AddImagePart(ImagePartType.Waveform, transform, (transform == ImagePartTransform.Json));
        }

        public ImagePart AddFrame(ImagePartTransform transform, int? frame = null)
        {
            return AddImagePart(ImagePartType.Frame, transform, true, frame);
        }

        public ImagePart AddOverlay(ImagePartTransform transform, int frame, int overlayIndex)
        {
            return AddImagePart(ImagePartType.Overlay, transform, true, frame, overlayIndex);
        }

        public ImagePart AddMergedOverlay(ImagePartTransform transform, int frame, string requestedFilePath)
        {
            return AddImagePart(ImagePartType.Overlay, transform, true, frame, null, requestedFilePath);
        }

        public ImagePart AddAudio()
        {
            return AddImagePart(ImagePartType.Media, ImagePartTransform.Mp3);
        }

        public ImagePart AddMp4()
        {
            return AddImagePart(ImagePartType.Media, ImagePartTransform.Mp4);
        }

        public ImagePart AddAvi()
        {
            return AddImagePart(ImagePartType.Media, ImagePartTransform.Avi);
        }

        public ImagePart AddWebM()
        {
            return AddImagePart(ImagePartType.Media, ImagePartTransform.Webm);
        }

        public ImagePart AddDicomPR()
        {
            return AddImagePart(ImagePartType.DcmPR, ImagePartTransform.Json);
        }

        private string GetImagePartName(ImagePartType type)
        {
            string part = null;
            switch (type)
            {
                case ImagePartType.Abstract: part = "ABS"; break;
                case ImagePartType.ImageInfo: part = "INF"; break;
                case ImagePartType.Header: part = "HDR"; break;
                case ImagePartType.Waveform: part = "ECG"; break;
                case ImagePartType.Frame: part = "F"; break;
                case ImagePartType.Media: part = "AV"; break;
                case ImagePartType.Overlay: part = "O"; break;
                case ImagePartType.DcmPR: part = "PR"; break;
                case ImagePartType.DcmHeader: part = "HDR"; break;
            }

            return part;
        }

        private string GetTransformExtension(ImagePartTransform transform, bool isStatic)
        {
            string extension = null;

            if (isStatic)
                switch (transform)
                {
                    case ImagePartTransform.DicomData: extension = ".pix"; break;
                    case ImagePartTransform.Html: extension = ".html"; break;
                    case ImagePartTransform.Jpeg: extension = ".jpeg"; break;
                    case ImagePartTransform.Png: extension = ".png"; break;
                    case ImagePartTransform.Json: extension = ".json"; break;
                    case ImagePartTransform.Pdf: extension = ".pdf"; break;
                    case ImagePartTransform.Mp3: extension = ".mp3"; break;
                    case ImagePartTransform.Mp4: extension = ".mp4"; break;
                    case ImagePartTransform.Avi: extension = ".avi"; break;
                    case ImagePartTransform.Webm: extension = ".webm"; break;
                    case ImagePartTransform.DicomHeader: extension = ".dcm"; break;
                    case ImagePartTransform.Tiff: extension = ".jpeg"; break; //VAI-307 Tiff is displayed as jpeg
                }
            else
                extension = ".org";

            return extension;
        }

        private ImagePart AddImagePart(ImagePartType type, ImagePartTransform transform = ImagePartTransform.Default, bool isStatic = true, int? frame = null, int? overlayIndex = null, string requestedFilePath = null)
        {
            if (requestedFilePath == null)
            {
                // format file name
                StringBuilder stringBuilder = new StringBuilder();
                stringBuilder.Append(FileName);
                stringBuilder.Append("_");

                if (type == ImagePartType.Overlay)
                {
                    // overlay needs frame number as well
                    if (!frame.HasValue || !overlayIndex.HasValue)
                        throw new ArgumentNullException("Invalid frame or overlay index.");

                    stringBuilder.Append(GetImagePartName(ImagePartType.Frame));
                    stringBuilder.Append(frame.Value);
                    stringBuilder.Append("_");
                    stringBuilder.Append(GetImagePartName(ImagePartType.Overlay));
                    stringBuilder.Append(overlayIndex.Value);
                }
                else
                {
                    stringBuilder.Append(GetImagePartName(type));
                    if (frame.HasValue)
                        stringBuilder.Append(frame.Value);
                }

                stringBuilder.Append(GetTransformExtension(transform, isStatic));

                requestedFilePath = stringBuilder.ToString();
            }

            ImagePart imagePart = new ImagePart
            {
                Type = type,
                Transform = transform,
                FilePath = Path.Combine(TargetFolder, requestedFilePath),
                Frame = frame.HasValue? frame.Value : -1,
                OverlayIndex = overlayIndex,
                IsStatic = isStatic
            };

            ImageParts.Add(imagePart);

            return imagePart;
        }

        public void Clear()
        {
            Image = null;
            ImageParts.Clear();
            ImageType = Common.ImageType.Unknown;
        }
    }
}
