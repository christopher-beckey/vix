using Hydra.Common;

namespace Hydra.IX.Common
{
    public class NewImageData
    {
        public string FileName { get; set; }
        public FileType FileType { get; set; }
        public string Description { get; set; }
        public string RequestedImageUid { get; set; }
        public string ExternalImageId { get; set; }
    }
}