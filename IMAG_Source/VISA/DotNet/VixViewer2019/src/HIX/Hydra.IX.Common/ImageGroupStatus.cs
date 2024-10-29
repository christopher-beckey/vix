namespace Hydra.IX.Common
{
    public class ImageGroupStatus
    {
        public string GroupUid { get; set; }
        public int ImageCount { get; set; }
        public int ImagesUploaded { get; set; }
        public int ImagesProcessed { get; set; }
        public int ImagesFailed { get; set; }
        public int ImagesUploadFailed { get; set; }
    }
}