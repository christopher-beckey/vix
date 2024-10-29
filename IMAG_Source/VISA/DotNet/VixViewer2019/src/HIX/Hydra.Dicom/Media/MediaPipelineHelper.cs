using System.Windows;
using StreamCoders;
using StreamCoders.Decoder;
using StreamCoders.Encoder;
using StreamCoders.Helpers;

namespace Hydra.Dicom.Media
{
    internal class MediaPipelineHelper
    {
        public static IAudioDecoderBase CreateAudioDecoder(TrackInfo track, IReader reader, ContainerType containerType, out string errorDesc)
        {
            IAudioDecoderBase adec = AudioDecoderFactory.CreateDecoder(track.Codec);
            errorDesc = null;

            if (adec == null)
            {
                errorDesc = (string.Format("Codec {0} not supported.", track.Codec));
                return null;
            }

            var audioConfig = DecoderConfigurationFactory.CreateAudioConfiguration(track);
            //if(track.Codec == Codec.AAC)
            //{
            //    var c = audioConfig as AacAudioDecoderConfiguration;
            //    c.Tools.SBR.Enabled = true;
            //    c.Tools.SBR.Upsample = false;
            //    //c.Tools.PS.Enabled = true;

            //}

            audioConfig = adec.Init(audioConfig);

            Precondition.Evaluate(audioConfig.InitializationStatus == CodecOperationStatus.Success, "Failed to initialize audio decoder.");

            return adec;
        }

        public static IVideoDecoderBase CreateVideoDecoder(TrackInfo track, IReader reader, ContainerType containerType, out string errorDesc)
        {
            IVideoDecoderBase vdec = VideoDecoderFactory.CreateDecoder(track.Codec);
            errorDesc = null;

            if (vdec == null)
            {
                errorDesc = (string.Format("Codec {0} not supported.", track.Codec));
                return null;
            }

            var config = DecoderConfigurationFactory.CreateVideoConfiguration(track);

            if (track.Codec == Codec.H264)
            {
                (config as H264VideoDecoderConfiguration).HardwareAccelerated = true;
                (config as H264VideoDecoderConfiguration).Encapsulation = Encapsulation.AccessUnit;
            }

            if (containerType == ContainerType.H264NalFile)
            {
                config.Encapsulation = Encapsulation.StartCodes;
            }

            Precondition.Evaluate(vdec.Init(config).InitializationStatus == CodecOperationStatus.Success, "Failed to initialize video decoder.");
            return vdec;
        }
    }
}