using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading;
using System.Windows;
using StreamCoders;
using StreamCoders.Container;
using StreamCoders.Dash;
using StreamCoders.Decoder;
using StreamCoders.Helpers;
using StreamCoders.Network;

namespace Hydra.Dicom.Media
{
    internal class PipeLineStatistics
    {
        public long FramesDecoded;
        public long FramesDecodeErrors;
        public long FramesRead;
        public long FramesReadErrors;
        public long TotalIterations;
        public TrackStatus TrackStatus;

        public override string ToString()
        {
            return string.Format("Frames read {0}, Frames read errors {1}, Frames decoded {2}, Frames decode errors {3}, Total iterations {4}, Track Status {5}", FramesRead, FramesReadErrors, FramesDecoded, FramesDecodeErrors, TotalIterations, TrackStatus);
        }
    }

    internal enum ContainerType
    {
        Unknown,
        Avi,
        Mp4,
        Dash,
        Mkv,
        WebM,
        H264NalFile,
        TransportStream
    }

    public delegate void OnLogDelegate(object sender, string message);

    public delegate void OnVideoPictureDelegate(object sender, PictureMediaBuffer picture);

    public delegate void OnAudioSamplesDelegate(object sender, MediaBuffer<byte> samples);

    public delegate double OnGetCurrentAudioFullnessDelegate(object sender);


    // Media pipeline that has a filename as input and outputs decoded video & audio frames for playback.
    // 
    // Functional Overview
    // 
    // Setting up pipeline:
    //  * Construct with filename
    //  * Call CheckSanity for basic compatibility checking
    //  * Call Setup to set up the decoders
    //  * Set OnAudio/OnVideo events
    //  * Implement OnGetAudioFullness
    //  * Call Start
    //  
    //  Operational:
    //   * Process OnAudio/OnVideo events
    //   * Get/Set Position for seeking
    //  
    // Teardown of pipeline:
    //  * Call Stop
    //  
    //  Known Issues:
    //  * MKV with B-Frames has presentation time problems and may appear choppy
    internal class MediaPipeline
    {
        private long count;

        public event Action<string> OnError;

        public MediaPipeline(string filename, Stream stream)
        {
            this.filename = filename;
            this._Stream = stream;
        }

        /// -------------------------------------------------------------------------------------------------
        /// <summary>
        ///     Re-adjusts position of reader when the player is seeking.
        /// </summary>
        /// -------------------------------------------------------------------------------------------------
        internal double Position
        {
            set
            {
                // Block threads & reposition
                globalPauseEvent.Reset();
                Thread.Sleep(100);
                lock (reader)
                    reader.Position = value.SecondsToTimeSpanAccurate();


                // Clear pictures in prefetch
                if (videoTrack != null)
                {
                    lock (videoPrefetchQueue)
                    {
                        while (videoPrefetchQueue.Count > 0)
                        {
                            var picture = GetVideoPrefetchItem();
                            picture.Buffer.Unlock();
                        }
                    }
                }

                // Unblock & signal that we need a new seek offset
                globalPauseEvent.Set();
                seekOffsetNeeded.Reset();
            }

            get
            {
                if (isRunning == false || reader == null)
                    return 0.0;
                lock (reader)
                    return reader.Position.TotalSeconds;
            }
        }

        /// -------------------------------------------------------------------------------------------------
        /// <summary>
        ///     Returns true of the media pipeline has been started.
        /// </summary>
        /// -------------------------------------------------------------------------------------------------
        internal bool IsActive
        {
            get { return isRunning; }
        }

        /// -------------------------------------------------------------------------------------------------
        /// <summary>
        ///     Determines if container is supported.
        /// </summary>
        /// -------------------------------------------------------------------------------------------------
        public bool CheckSanity()
        {
            if (this._Stream == null)
            {
                // Check against scheme. We could fork off to RTSP or HTTP in other scenarios
                var uri = new Uri(filename);

                if (uri.Scheme != "file")
                    return false;

                if (File.Exists(filename) == false)
                    return false;
            }

            // Check valid container types
            var ext = Path.GetExtension(filename).ToUpper().Replace(".", string.Empty);
            if (ext == "AVI")
                containerType = ContainerType.Avi;
            if (ext == "MOV" || ext == "MP4" || ext == "3GP" || ext == "ISMV" || ext == "M4V")
                containerType = ContainerType.Mp4;
            if (ext == "MPD")
                containerType = ContainerType.Dash;
            if (ext == "WEBM")
                containerType = ContainerType.WebM;
            if (ext == "MKV")
                containerType = ContainerType.Mkv;
            if (ext == "H264")
                containerType = ContainerType.H264NalFile;
            if (ext == "H265")
                containerType = ContainerType.H264NalFile;
            if (ext == "TS")
                containerType = ContainerType.TransportStream;
            if (containerType == ContainerType.Unknown)
                return false;

            return true;
        }

        /// -------------------------------------------------------------------------------------------------
        /// <summary>
        ///     Setup reader and decoders.
        /// </summary>
        /// -------------------------------------------------------------------------------------------------
        public bool Setup()
        {
            switch (containerType)
            {
                case ContainerType.Avi:
                    reader = new AVIReader();
                    if (this._Stream != null)
                        reader.Init(this._Stream);
                    else
                        reader.Init(filename);
                    break;
                case ContainerType.Mp4:
                    reader = new Mp4Reader();
                    if (this._Stream != null)
                        reader.Init(this._Stream);
                    else
                        reader.Init(filename);
                    break;
                case ContainerType.Dash:
                    {
                        reader = new DashReader();

                        var mpd = DashMediaPresentation.Create(new FileStream(filename, FileMode.Open, FileAccess.Read));
                        if (mpd.Parse() == false)
                        {
                            if (OnError != null)
                                OnError("Parsing of MPD failed. Check file against schema");
                            return false;
                        }

                        var description = mpd.GetMediaDescription();
                        var uriList = description.Periods[0].AdaptationSets[1].Representations[0].GetSegmentUris();
                        var iStream = new InjectableStream();
                        var fetch = new HttpBulkFetch(iStream);
                        fetch.Add(uriList);
                        fetch.Start();
                        if (reader.Init(iStream) == false)
                        {
                            if (OnError != null)
                                OnError("Error initializing reader.");
                            return false;
                        }
                    }
                    break;
                case ContainerType.WebM:
                    reader = new WebMReader();
                    if (this._Stream != null)
                        reader.Init(this._Stream);
                    else
                        reader.Init(filename);
                    break;
                case ContainerType.Mkv:
                    reader = new MatroskaReader();
                    if (this._Stream != null)
                        reader.Init(this._Stream);
                    else
                        reader.Init(filename);
                    break;
                case ContainerType.H264NalFile:
                    reader = new H264NalReader();
                    if (this._Stream != null)
                        reader.Init(this._Stream);
                    else
                        reader.Init(filename);
                    break;
                case ContainerType.TransportStream:
                    reader = new Mpeg2TsReader();
                    if (this._Stream != null)
                        reader.Init(this._Stream);
                    else
                        reader.Init(filename);
                    break;
                default:
                    return false;
            }

            if ((reader.Tracks == null) || (reader.Tracks.Count == 0))
            {
                LogMessage("Container has 0 tracks.");
                return false;
            }

            string errorDesc;
            foreach (var track in reader.Tracks)
            {
                if (track == null)
                    continue;

                if (track.MediaContentType == MediaContentType.Audio)
                {
                    audioTrack = track;
                    audioDecoder = MediaPipelineHelper.CreateAudioDecoder(track, reader, containerType, out errorDesc);

                    if (audioDecoder == null)
                    {
                        LogMessage(string.Format("Error creating audio decoder. {0}", errorDesc));
                        return false;
                    }
                }

                if (track.MediaContentType == MediaContentType.Video)
                {
                    videoTrack = track;
                    videoDecoder = MediaPipelineHelper.CreateVideoDecoder(track, reader, containerType, out errorDesc);

                    if (videoDecoder == null)
                    {
                        LogMessage(string.Format("Error creating video decoder. {0}", errorDesc));
                        return false;
                    }

                    videoDecoder.SetBufferProvider(videoRingBuffer);
                }
            }

            return true;
        }

        public void LogMessage(string message)
        {
            if (OnLog == null)
                return;

            OnLog(this, string.Format("{0}> {1}", DateTime.UtcNow, message));
        }

        public void LogVerbose(string message)
        {
            if (logVerboseMessages)
                LogMessage(message);
        }

        /// -------------------------------------------------------------------------------------------------
        /// <summary>
        ///     Starts this instance of the media pipeline.
        /// </summary>
        /// -------------------------------------------------------------------------------------------------
        public bool Start()
        {
            videoThread = new Thread(VideoThreadProc) { Name = "VideoThread", Priority = ThreadPriority.Normal };

            videoPushThread = new Thread(VideoPushThreadProc) { Name = "Video Push Thread", Priority = ThreadPriority.Normal };

            audioThread = new Thread(AudioThreadProc) { Name = "AudioThread", Priority = ThreadPriority.Normal };

            isRunning = true;
            videoThread.Start();
            videoPushThread.Start();
            audioThread.Start();
            return true;
        }

        /// -------------------------------------------------------------------------------------------------
        /// <summary>
        ///     Stops this instance of the media pipeline.
        /// </summary>
        /// -------------------------------------------------------------------------------------------------
        public void Stop()
        {
            if (isRunning == false)
            {
                if (reader != null)
                {
                    reader.Dispose();
                    reader = null;
                }
                return;
            }
            isRunning = false;
            Thread.Sleep(100);
            LogMessage("Waiting for video thread to terminate.");
            videoThread.Join();
            LogMessage("Waiting for audio thread to terminate.");
            audioThread.Join();

            LogMessage("Terminating reader.");
            reader.Dispose();
            reader = null;

            LogMessage("Stop Completed.");
        }

        public MediaBuffer<byte> GetFirstFrame()
        {
            if (videoTrack != null)
            {
                ++VideoStats.TotalIterations;
                if ((VideoStats.TrackStatus = reader.GetTrackStatus(videoTrack)) != TrackStatus.StreamEnd)
                {
                    MediaBuffer<byte> videoFrame = null;
                    lock (reader)
                        videoFrame = reader.GetNextFrame(videoTrack);

                    if (videoFrame != null)
                    {
                        if (videoDecoder.Transform(videoFrame) == CodecOperationStatus.Success)
                        {
                            ++VideoStats.FramesDecoded;
                            var picture = videoDecoder.OutputQueue.Take();
                            return picture;
                        }
                    }
                }
            }

            return null;
        }

        private void VideoThreadProc()
        {
            if (videoTrack == null)
                return;

            while (isRunning && globalPauseEvent.WaitOne())
            {
                ++VideoStats.TotalIterations;
                if ((VideoStats.TrackStatus = reader.GetTrackStatus(videoTrack)) == TrackStatus.StreamEnd)
                    break;

                MediaBuffer<byte> videoFrame = null;
                lock (reader)
                    videoFrame = reader.GetNextFrame(videoTrack);

                if (videoFrame == null)
                {
                    ++VideoStats.FramesDecodeErrors;
                    Thread.Sleep(0);
                    continue;
                }

                ++VideoStats.FramesRead;

                if (globalPauseEvent.WaitOne(0) == false) continue;

                if (videoDecoder.Transform(videoFrame) == CodecOperationStatus.Success)
                {
                    while (videoDecoder.OutputQueue.Count > 0)
                    {
                        ++VideoStats.FramesDecoded;
                        var picture = videoDecoder.OutputQueue.Take();
                        // Trace.WriteLine(string.Format("Video {0} for {1}", picture.StartTime, picture.Duration));
                        AddVideoPrefetchItem(picture);
                    }
                }
                else
                {
                    ++VideoStats.FramesDecodeErrors;
                }
            }

            LogMessage("VideoThreadProc finished.");
        }

        private void AddVideoPrefetchItem(MediaBuffer<byte> picture)
        {
            while (videoPrefetchEvent.WaitOne(100) == false && isRunning)
                ;

            lock (videoPrefetchQueue)
                videoPrefetchQueue.Add(count++, picture);

            if (GetVideoPrefetchQueueCount() > videoPrefetchThreshold)
                videoPrefetchEvent.Reset();
        }

        private MediaBuffer<byte> GetVideoPrefetchItem()
        {
            lock (videoPrefetchQueue)
            {
                if (videoPrefetchQueue.Count == 0)
                    return null;

                var picture = videoPrefetchQueue.Values.ElementAt(0);
                videoPrefetchQueue.RemoveAt(0);

                if (GetVideoPrefetchQueueCount() < videoPrefetchThreshold)
                    videoPrefetchEvent.Set();

                return picture;
            }
        }

        /// -------------------------------------------------------------------------------------------------
        /// <summary>
        ///     Returns the number of frames available in the video prefetch queue.
        /// </summary>
        /// -------------------------------------------------------------------------------------------------
        public int GetVideoPrefetchQueueCount()
        {
            lock (videoPrefetchQueue)
                return videoPrefetchQueue.Count;
        }

        public Codec GetTrackCodec(MediaContentType category)
        {
            if (category == MediaContentType.Audio)
                return audioTrack.Codec;
            if (category == MediaContentType.Video)
                return videoTrack.Codec;
            return Codec.Unknown;
        }

        private void VideoPushThreadProc()
        {
            while (isRunning)
            {
                var fullness = GetVideoPrefetchQueueCount();

                while (isRunning && fullness < videoPrefetchThreshold)
                {
                    Thread.Sleep(5);
                    fullness = GetVideoPrefetchQueueCount();
                }

                var picture = GetVideoPrefetchItem();

                if (picture != null)
                    PushPicture(picture as PictureMediaBuffer);
            }

            LogMessage("VideoPushThread finished.");
        }

        private void PushPicture(PictureMediaBuffer picture)
        {
            if (OnVideoPicture != null)
                OnVideoPicture(this, picture);
        }

        private void AudioThreadProc()
        {
            if (audioTrack == null)
                return;
            MediaBuffer<byte> aMb;
            while (isRunning && globalPauseEvent.WaitOne())
            {
                var needsMoreSamples = true;

                // Throttle the queuing of samples so we don't use too much memory.
                if (OnGetAudioFullness != null)
                    needsMoreSamples = OnGetAudioFullness(this) < 2.0f;

                if (needsMoreSamples == false)
                {
                    Thread.Sleep(500);
                    continue;
                }
                ++AudioStats.TotalIterations;

                // Check if there are more frames to read or if the track has ended.
                if ((AudioStats.TrackStatus = reader.GetTrackStatus(audioTrack)) == TrackStatus.StreamEnd)
                    break;

                lock (reader)
                    aMb = reader.GetNextFrame(audioTrack);

                if (seekOffsetNeeded.WaitOne(0) == false)
                {
                    seekOffset = aMb.StartTime.TotalSeconds;
                    seekOffsetNeeded.Set();
                }

                if (aMb == null)
                {
                    ++AudioStats.FramesReadErrors;
                    Thread.Sleep(0);
                    continue;
                }

                ++AudioStats.FramesRead;

                var samples = audioDecoder.Transform(aMb) == CodecOperationStatus.Success ? audioDecoder.OutputQueue.Take() : null;

                if (samples == null)
                {
                    ++AudioStats.FramesDecodeErrors;
                    LogVerbose(string.Format("Audio failed to decode {0}", aMb.StartTime));
                    continue;
                }
                ++AudioStats.FramesDecoded;
                AddAudioQueue(samples);
            }
            LogMessage("AudioThreadProc finished.");
        }

        private void AddAudioQueue(MediaBuffer<byte> samples)
        {
            if (OnAudioSamples == null)
            {
                return;
            }

            OnAudioSamples(this, samples);
        }

        /// -------------------------------------------------------------------------------------------------
        /// <summary>
        ///     Gets the audio configuration.
        /// </summary>
        /// -------------------------------------------------------------------------------------------------
        internal AudioTrackDescriptor GetAudioConfiguration()
        {
            if (audioTrack == null)
                return null;
            return audioTrack.Media as AudioTrackDescriptor;
        }

        /// -------------------------------------------------------------------------------------------------
        /// <summary>
        ///     Gets the video configuration.
        /// </summary>
        /// -------------------------------------------------------------------------------------------------
        internal VideoTrackDescriptor GetVideoConfiguration()
        {
            if (videoTrack == null)
                return null;
            return videoTrack.Media as VideoTrackDescriptor;
        }

        /// -------------------------------------------------------------------------------------------------
        /// <summary>
        ///     Gets the audio seek offset after a seek operation, which will be the StartTime of the first
        ///     audio sample read after the position in the container has changed.
        /// </summary>
        /// <returns>
        ///     If audio is absent it will be the reader position, otherwise it will be the start code of the
        ///     first audio sample read.
        /// </returns>
        /// -------------------------------------------------------------------------------------------------
        internal double GetSeekOffset()
        {
            if (audioTrack == null)
                return reader.Position.TotalSeconds;
            while (isRunning && seekOffsetNeeded.WaitOne(100) == false)
                ;

            LogMessage(string.Format("SeekOffsetNew {0}", seekOffset));
            return seekOffset;
        }

        #region Fields

        public event OnLogDelegate OnLog;
        public event OnVideoPictureDelegate OnVideoPicture;
        public event OnAudioSamplesDelegate OnAudioSamples;
        public event OnGetCurrentAudioFullnessDelegate OnGetAudioFullness;
        private readonly string filename;
        private readonly Stream _Stream;

        private const int videoPrefetchThreshold = 15;
        private ContainerType containerType = ContainerType.Unknown;
        private readonly SortedList<long, MediaBuffer<byte>> videoPrefetchQueue = new SortedList<long, MediaBuffer<byte>>();
        private Thread videoThread;
        private Thread audioThread;
        private Thread videoPushThread;

        private IReader reader;
        private TrackInfo videoTrack;
        private TrackInfo audioTrack;
        private IVideoDecoderBase videoDecoder;
        private IAudioDecoderBase audioDecoder;

        private readonly ManualResetEvent seekOffsetNeeded = new ManualResetEvent(true);
        private double seekOffset;

        private readonly LockableOffsetBufferProvider<OffsetBuffer<byte>> videoRingBuffer = new LockableOffsetBufferProvider<OffsetBuffer<byte>>();

        public PipeLineStatistics VideoStats = new PipeLineStatistics();
        public PipeLineStatistics AudioStats = new PipeLineStatistics();

        private volatile bool isRunning;
        private readonly bool logVerboseMessages = false;
        private readonly ManualResetEvent globalPauseEvent = new ManualResetEvent(true);
        private readonly ManualResetEvent videoPrefetchEvent = new ManualResetEvent(true);

        #endregion
    }
}
