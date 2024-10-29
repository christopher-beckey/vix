//using BitMiracle.LibJpeg;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace Hydra.Dicom
{
    public static class JpegWriter
    {
        private static ImageCodecInfo GetEncoder(ImageFormat format)
        {
            ImageCodecInfo[] codecs = ImageCodecInfo.GetImageDecoders();
            foreach (ImageCodecInfo codec in codecs)
            {
                if (codec.FormatID == format.Guid)
                {
                    return codec;
                }
            }
            return null;
        }

        public static void SaveAsJpeg(Bitmap bitmap, int quality, string filePath)
        {
            //JpegImage jpegImage = JpegImage.FromBitmap(bitmap);

            //using (FileStream fileStream = new FileStream(filePath, FileMode.Create))
            //{
            //    CompressionParameters compressionParameters = new CompressionParameters
            //    {
            //        Quality = quality,
            //        SmoothingFactor = 0,
            //        SimpleProgressive = false
            //    };
            //    jpegImage.WriteJpeg(fileStream, compressionParameters);
            //}
        }

        public static void SaveAsJpeg(byte[] pixels, int width, int height, int bitsAllocated, int samplesPerPixel, string filePath)
        {
            int bytesPerPixels = (bitsAllocated + 7) / 8;
            int stride = width * bytesPerPixels * samplesPerPixel;

            System.Windows.Media.PixelFormat format;
            if ((bytesPerPixels == 1) && (samplesPerPixel == 1))
                format = PixelFormats.Gray8;
            if ((bytesPerPixels == 1) && (samplesPerPixel == 3))
                format = PixelFormats.Rgb24;
            else if (bytesPerPixels == 2)
                format = PixelFormats.Gray16;
            else
                return;

            BitmapPalette palette = BitmapPalettes.Halftone256;
            BitmapSource image = BitmapSource.Create(width, height, 96, 96, format, palette, pixels, stride);

            Bitmap bitmap;
            using (var outStream = new MemoryStream())
            {
                BitmapEncoder enc = new BmpBitmapEncoder();
                enc.Frames.Add(BitmapFrame.Create(image));
                enc.Save(outStream);
                bitmap = new Bitmap(outStream);
            }

            SaveAsJpeg(bitmap, 90, filePath);
        }


        //public static void SaveAsJpeg(Bitmap bitmap, long quality, string filePath)
        //{
        //    ImageCodecInfo jgpEncoder = GetEncoder(ImageFormat.Jpeg);
        //    System.Drawing.Imaging.Encoder encoder = System.Drawing.Imaging.Encoder.Quality;
        //    EncoderParameters encoderParameters = new EncoderParameters(1);
        //    EncoderParameter encoderParam = new EncoderParameter(encoder, quality);
        //    encoderParameters.Param[0] = encoderParam;

        //    bitmap.Save(filePath, jgpEncoder, encoderParameters);
        //}

        //public static void SaveToFile(byte[] pixels, int width, int height, int bitsAllocated, int samplesPerPixel, string filePath)
        //{
        //    int bytesPerPixels = (bitsAllocated + 7) / 8;
        //    int stride = width * bytesPerPixels * samplesPerPixel;

        //    System.Windows.Media.PixelFormat format;
        //    if ((bytesPerPixels == 1) && (samplesPerPixel == 1))
        //        format = PixelFormats.Gray8;
        //    if ((bytesPerPixels == 1) && (samplesPerPixel == 3))
        //        format = PixelFormats.Rgb24;
        //    else if (bytesPerPixels == 2)
        //        format = PixelFormats.Gray16;
        //    else
        //        return;

        //    BitmapPalette palette = BitmapPalettes.Halftone256;
        //    BitmapSource image = BitmapSource.Create(width, height, 96, 96, format, palette, pixels, stride);

        //    using (FileStream stream = new FileStream(filePath, FileMode.Create))
        //    {
        //        JpegBitmapEncoder encoder = new JpegBitmapEncoder();
        //        encoder.Frames.Add(BitmapFrame.Create(image));
        //        encoder.Save(stream);
        //    }
        //}

        public static void SaveToFile(byte[] pixels, int width, int height, int bitsAllocated, int samplesPerPixel, string filePath)
        {
            // create png image in memory first
            int bytesPerPixels = (bitsAllocated + 7) / 8;
            int stride = width * bytesPerPixels * samplesPerPixel;

            System.Windows.Media.PixelFormat format;
            if ((bytesPerPixels == 1) && (samplesPerPixel == 1))
                format = PixelFormats.Gray8;
            if ((bytesPerPixels == 1) && (samplesPerPixel == 3))
                format = PixelFormats.Rgb24;
            else if (bytesPerPixels == 2)
                format = PixelFormats.Gray16;
            else
                return;

            BitmapPalette palette = BitmapPalettes.Halftone256;
            BitmapSource image = BitmapSource.Create(width, height, 96, 96, format, palette, pixels, stride);

            using (MemoryStream stream = new MemoryStream())
            {
                PngBitmapEncoder encoder = new PngBitmapEncoder();
                encoder.Interlace = PngInterlaceOption.Off;
                encoder.Frames.Add(BitmapFrame.Create(image));
                encoder.Save(stream);

                stream.Seek(0, SeekOrigin.Begin);

                try
                {
                    var settings = new ImageResizer.ResizeSettings
                    {
                        MaxWidth = width,
                        MaxHeight = height,
                        Format = "JPG"
                    };

                    ImageResizer.ImageBuilder.Current.Build(stream, filePath, settings);
                }
                catch (Exception)
                {
                }
            }
        }

        public static void SaveToStream(byte[] pixels, int width, int height, int bitsAllocated, int samplesPerPixel, Stream outputStream)
        {
            // create png image in memory first
            int bytesPerPixels = (bitsAllocated + 7) / 8;
            int stride = width * bytesPerPixels * samplesPerPixel;

            System.Windows.Media.PixelFormat format;
            if ((bytesPerPixels == 1) && (samplesPerPixel == 1))
                format = PixelFormats.Gray8;
            else if ((bytesPerPixels == 1) && (samplesPerPixel == 3))
                format = PixelFormats.Rgb24;
            else if (bytesPerPixels == 2)
                format = PixelFormats.Gray16;
            else
                return;

            BitmapPalette palette = BitmapPalettes.Halftone256;
            BitmapSource image = BitmapSource.Create(width, height, 96, 96, format, palette, pixels, stride);

            using (MemoryStream stream = new MemoryStream())
            {
                PngBitmapEncoder encoder = new PngBitmapEncoder();
                encoder.Interlace = PngInterlaceOption.Off;
                encoder.Frames.Add(BitmapFrame.Create(image));
                encoder.Save(stream);

                stream.Seek(0, SeekOrigin.Begin);

                try
                {
                    var settings = new ImageResizer.ResizeSettings
                    {
                        MaxWidth = width,
                        MaxHeight = height,
                        Format = "JPG"
                    };

                    ImageResizer.ImageBuilder.Current.Build(stream, outputStream, settings);
                }
                catch (Exception)
                {
                }
            }
        }

        public static void ConvertToPng(object input, object output)
        {
            var settings = new ImageResizer.ResizeSettings
            {
                Format = "PNG",
                Mode = ImageResizer.FitMode.Stretch
            };

            ImageResizer.ImageBuilder.Current.Build(input, output, settings, false);
        }

        public static void ConvertToJpeg(string srcFileName, string destFileName, int imageWidth, int imageHeight)
        {
            var settings = new ImageResizer.ResizeSettings
            {
                MaxWidth = imageWidth,
                MaxHeight = imageHeight,
                Format = "JPG",
                Mode = ImageResizer.FitMode.Stretch
            };

            ImageResizer.ImageBuilder.Current.Build(srcFileName, destFileName, settings);
        }
    }
}
