using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public class ImageMetadata
    {
        public string ImageId { get; set; }
        public string ThumbnailUri { get; set; }
        public string ImageUri { get; set; }
        public string Caption { get; set; }
        public string Description { get; set; }
        public string CaptureDate { get; set; }
        public string DocumentDate { get; set; }
        public string ImageType { get; set; }
        public bool IsSensitive { get; set; }
        public Hydra.Common.FileType FileType { get; set; }
        public string ImageStatus { get; set; }
        public string ImageViewStatus { get; set; }
    }
}
