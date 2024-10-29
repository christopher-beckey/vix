using NLog;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using StreamCoders.Imaging;

namespace Hydra.Dicom.Media
{
    public class VideoThumbnailExtractor
    {
        private static readonly Logger _Logger = LogManager.GetCurrentClassLogger();
        private Stream _Stream = null;
        private string _FileName = null;
        private System.Drawing.Bitmap _FirstFrame = null;
        private System.Drawing.Bitmap _RequestedFrame = null;
        private int _FrameCount = 0;
        private int _RequestedFrameIndex = 0;

        private ManualResetEvent _FrameReadyEvent = new ManualResetEvent(false);

        public VideoThumbnailExtractor(Stream stream, string fileName)
        {
            _Stream = stream;
            _FileName = fileName;
        }

        public static System.Drawing.Bitmap GetThumbnail(Stream stream, string filePath, int frameIndex)
        {
            var videoProcessor = new VideoThumbnailExtractor(stream, filePath);

            videoProcessor.ReadFrame(frameIndex);

            return videoProcessor.Thumbnail;
        }

        //public static System.Drawing.Bitmap GetThumbnail(Stream stream, string fileName)
        //{
        //    System.Drawing.Bitmap bitmap = null;

        //    try
        //    {
        //        var pipe = new MediaPipeline(fileName, stream);
        //        pipe.OnLog += pipe_OnLog;

        //        if (pipe.CheckSanity() == false)
        //        {
        //            throw new Exception("Unable to play resource.");
        //        }

        //        if (pipe.Setup() == false)
        //        {
        //            throw new Exception("Unable to set up playback.");
        //        }

        //        var frame = pipe.GetFirstFrame();
        //        if (frame == null)
        //        {
        //            throw new Exception("Unable to extract frame");
        //        }

        //        bitmap = (frame as StreamCoders.PictureMediaBuffer).Rgb24ToBitmap();

        //    }
        //    catch (Exception ex)
        //    {
        //        _Logger.Error(ex.ToString());
        //    }

        //    return bitmap;
        //}

        public void ReadFrame(int frameIndex)
        {
            try
            {
                _RequestedFrameIndex = frameIndex;
                _FrameReadyEvent.Reset();

                var pipe = new MediaPipeline(_FileName, _Stream);
                pipe.OnLog += pipe_OnLog;

                if (pipe.CheckSanity() == false)
                {
                    throw new Exception("Unable to play resource.");
                }

                if (pipe.Setup() == false)
                {
                    throw new Exception("Unable to set up playback.");
                }

                pipe.OnVideoPicture += pipe_OnVideoPicture;

                var task = Task.Factory.StartNew(() =>
                    {
                        try
                        {
                            pipe.Start();
                        }
                        catch (Exception ex)
                        {
                            _Logger.Error(ex.ToString());
                            _FrameReadyEvent.Set();
                        }
                        finally
                        {
                        }
                    });

                _FrameReadyEvent.WaitOne(10000);
                pipe.Stop();
            }
            catch (Exception ex)
            {
                _Logger.Error(ex.ToString());
            }
        }


        public System.Drawing.Bitmap Thumbnail
        {
            get
            {
                return (_FirstFrame != null) ? _FirstFrame : _RequestedFrame;
            }
        }

        void pipe_OnVideoPicture(object sender, StreamCoders.PictureMediaBuffer picture)
        {
            if (_FirstFrame == null)
                _FirstFrame = picture.Rgb24ToBitmap();

            if (_FrameCount == _RequestedFrameIndex)
            {
                _RequestedFrame = picture.Rgb24ToBitmap();
                _FrameReadyEvent.Set();
            }

            _FrameCount++;
        }

        static void pipe_OnLog(object sender, string message)
        {
            _Logger.Info(message);
        }
    }
}
