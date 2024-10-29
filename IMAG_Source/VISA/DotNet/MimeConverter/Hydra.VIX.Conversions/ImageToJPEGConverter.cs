using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Drawing;
using log4net;


namespace Hydra.VIX.Conversions
{
    public class ImageToJPEGConverter
    {
        public static void convertImageToJPEG(string filepath, string inFilename, string mimeType, string outFilename)
        {
            //combine filepath and inFilename to make a input filespec (inFilename already has the extension)
            string inputFilespec = Path.Combine(filepath, inFilename);
            //combine filepath, outFilename, and "jpg" to make a output filespec
            string outFilenameWithExt = outFilename + ".jpg";
            string outputFilespec = Path.Combine(filepath, outFilenameWithExt);

            //Note: Need to use ImageResizer either directly or indirectly
            //  convert image from incoming mimetype to JPEG
            //  call JpegWriter.convertToJPEG() method
            ConvertToJpeg(inputFilespec, outputFilespec);
        }

        private static void ConvertToJpeg(string srcFileName, string destFileName)
        {
            var settings = new ImageResizer.ResizeSettings
            {
                Format = "JPG",
                Mode = ImageResizer.FitMode.Stretch
            };

            ImageResizer.ImageBuilder.Current.Build(srcFileName, destFileName, settings);
        }


    }
}
