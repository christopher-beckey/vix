using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public class ImageGroupMetadata : AbstractStudyItem
    {
        public ImageGroupMetadataType GroupType { get; set; }
        public string Caption { get; set; }
        public string Description { get; set; }
        public string ThumbnailUri { get; set; }
        public ImageGroupMetadata[] ImageGroups { get; set; }
        public ImageMetadata[] Images { get; set; }
        public int TotalImageCount { get; set; }
    }
}
