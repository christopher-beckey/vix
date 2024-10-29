using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using log4net;

namespace Hydra.VIX.Conversions
{
    public class VideoToAVIConverter
    {
        public static Boolean convertVideoToAVI(string filepath, string inFilename, string mimeType, string outFilename)
        {
            //combine filepath and inFilename to make a input filespec (inFilename already has the extension)
            string inputFilespec = Path.Combine(filepath, inFilename);
            //combine filepath, outFilename, and "avi" to make a output filespec
            string outFilenameWithExt = outFilename + ".avi";
            string outputFilespec = Path.Combine(filepath, outFilenameWithExt);
            Boolean isConverted = false;
            string customOutputArgs = null;
            //Note: Need to use NReco.VideoConverter either directly or indirectly
            //  convert video from incoming mimetype to AVI
            switch (mimeType)
            {
                case "video/quicktime":
                    customOutputArgs = " -acodec copy -vcodec libx264 -pix_fmt yuv420p ";
                    ConvertToAVI(inputFilespec, NReco.VideoConverter.Format.mov, outputFilespec, customOutputArgs);
                    isConverted = true;
                    break;
                case "video/mp4":
                    customOutputArgs = " -acodec copy -vcodec libx264 -pix_fmt yuv420p ";
                    ConvertToAVI(inputFilespec, NReco.VideoConverter.Format.mp4, outputFilespec, customOutputArgs);
                    isConverted = true;
                    break;
                case "image/gif":
                    customOutputArgs = " -r 25 -acodec copy -vcodec rawvideo -pix_fmt yuv420p ";
                    ConvertToAVI(inputFilespec, NReco.VideoConverter.Format.gif, outputFilespec, customOutputArgs);
                    isConverted = true;
                    break;
                default:    
                    isConverted = false;
                    break;
            }
            return isConverted;
        }

        static void ConvertToAVI
            (string inputFilespec, string inFormat, string outputFilespec, string customOutputArgs)
        {
            var ffMpegConverter = new NReco.VideoConverter.FFMpegConverter();
            var settings = new NReco.VideoConverter.ConvertSettings
            {
                CustomOutputArgs = customOutputArgs
                //CustomOutputArgs = " -acodec copy -vcodec libx264 -pix_fmt yuv420p "
            };

            using (var outputStream = File.OpenWrite(outputFilespec))
            {
                ffMpegConverter.ConvertMedia(inputFilespec, inFormat, outputStream, NReco.VideoConverter.Format.avi, settings);
                outputStream.Flush();
                outputStream.Close();
            }

        }
    }
}
