namespace Hydra.IX.Common
{
    public class ImagePartRequest
    {
        public string ImageUid { get; set; }
        public string GroupUid { get; set; }
        public int FrameNumber { get; set; }
        public int? OverlayIndex { get; set; }
        public Hydra.Common.ImagePartType Type { get; set; }
        public Hydra.Common.ImagePartTransform Transform { get; set; }
        public Hydra.Common.ECGParams ECGParams { get; set; }
        public string CacheLocator { get; set; }
        public bool ExcludeImageInfo { get; set; }
    }
}