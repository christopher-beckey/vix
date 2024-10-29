using Hydra.Common;
using Hydra.Common.Extensions;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public sealed class ConversionResult : IDisposable
    {
        public Stream SingleFrame { get; set; }
        public Stream[] MultiFrames { get; set; }
        public Hydra.Common.ImageType ImageType { get; set; }
        public ImagePartTransform TransformType { get; set; }
        public bool IsMultiframeSupported { get; set; }

        public void CreateFrames(int frameCount)
        {
            if (frameCount > 1)
            {
                MultiFrames = new MemoryStream[frameCount];
                for (int i = 0; i < MultiFrames.Length; i++)
                    MultiFrames[i] = new MemoryStream();
            }
            else
            {
                SingleFrame = new MemoryStream();
            }
        }

        public void CreateImageParts(ImageProcessResultset resultSet, IFileStorage fileStorage)
        {
            resultSet.ImageType = ImageType;

            if (SingleFrame != null)
            {
                int? frameIndex = null;
                if (IsMultiframeSupported)
                    frameIndex = 0;
                var imagePart = resultSet.AddFrame(TransformType, frameIndex);
                using (var stream = fileStorage.CreateStream(imagePart.FilePath))
                {
                    SingleFrame.Seek(0, SeekOrigin.Begin);
                    SingleFrame.CopyTo(stream);
                }
            }
            else if (MultiFrames != null)
            {
                for (int i = 0; i < MultiFrames.Length; i++)
                {
                    var imagePart = resultSet.AddFrame(TransformType, i);
                    using (var stream = fileStorage.CreateStream(imagePart.FilePath))
                    {
                        MultiFrames[i].Seek(0, SeekOrigin.Begin);
                        MultiFrames[i].CopyTo(stream);
                    }
                }
            }

            if (ImageType == Common.ImageType.Jpeg)
            {
                // create imageinfo
                var imageInfo = new Hydra.Entities.ImageInfo
                {
                    ImageType = ImageType.Jpeg.AsString(),
                    NumberOfFrames = (SingleFrame != null)? 1 : MultiFrames.Length,
                    PatientName = "NO NAME"
                };

                var imagePart = resultSet.AddImageInfo();
                fileStorage.WriteAllText(imagePart.FilePath, JsonUtil.Serialize(imageInfo));

                resultSet.Image = new Hydra.Entities.Image
                {
                    ImageType = ImageType.Jpeg.AsString(),
                    NumberOfFrames = imageInfo.NumberOfFrames
                };
            }
        }

        public void Dispose()
        {
            try
            {
                if (SingleFrame != null)
                {
                    SingleFrame.Close();
                    SingleFrame = null;
                }

                if (MultiFrames != null)
                {
                    Array.ForEach<Stream>(MultiFrames, x =>
                        {
                            if (x != null)
                            {
                                x.Close();
                            }
                        });

                    MultiFrames = null;
                }

            }
            catch (Exception ex)
            {
            }
        }
    }
}
