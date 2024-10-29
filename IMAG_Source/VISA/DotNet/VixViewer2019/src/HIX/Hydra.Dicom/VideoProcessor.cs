using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    class VideoProcessor
    {
        private const string _ProcessLockName = "Hydra.Dicom.Processor";
        internal static void ConvertAvi(string videoFilePath, Stream outputStream)
        {
            using (new Hydra.Common.ProcessLock(_ProcessLockName))
            {
                var ffMpegConverter = new NReco.VideoConverter.FFMpegConverter();
                ffMpegConverter.ConvertMedia(videoFilePath, outputStream, NReco.VideoConverter.Format.avi);
            }
        }

        internal static void ConvertMp4(string videoFilePath, Stream outputStream)
        {
            using (new Hydra.Common.ProcessLock(_ProcessLockName))
            {
                var ffMpegConverter = new NReco.VideoConverter.FFMpegConverter();
                var settings = new NReco.VideoConverter.ConvertSettings
                {
                    CustomOutputArgs = " -acodec copy -vcodec libx264 -pix_fmt yuv420p "
                };

                ffMpegConverter.ConvertMedia(videoFilePath, NReco.VideoConverter.Format.avi, outputStream, NReco.VideoConverter.Format.mp4, settings);
            }
        }

        internal static void ConvertWebM(string videoFilePath, Stream outputStream)
        {
            var ffMpegConverter = new NReco.VideoConverter.FFMpegConverter();
            ffMpegConverter.ConvertMedia(videoFilePath, outputStream, NReco.VideoConverter.Format.webm);
        }
    }
}
