using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace Hydra.Dicom
{
    class PngWriter
    {
        public static void SaveToFile(byte[] pixels, int width, int height, int bitsAllocated, int samplesPerPixel, string filePath)
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

            using (FileStream stream = new FileStream(filePath, FileMode.Create))
            {
                PngBitmapEncoder encoder = new PngBitmapEncoder();
                encoder.Interlace = PngInterlaceOption.Off;
                encoder.Frames.Add(BitmapFrame.Create(image));
                encoder.Save(stream);
            }
        }
    }
}
