namespace Hydra.IX.Common
{
    public class ImageRecord
    {
        public string ImageUid { get; set; }
        public string Path { get; set; }
        public bool IsUploaded { get; set; }
        public bool IsProcessed { get; set; }
        public bool IsSynced { get; set; }
        public string Status { get; set; }
        public string FileName { get; set; }
        public string ExternalImageId { get; set; }
    }
}