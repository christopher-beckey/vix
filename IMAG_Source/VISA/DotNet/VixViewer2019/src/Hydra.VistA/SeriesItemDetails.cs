using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Hydra.VistA
{
    public class SeriesItemDetails
    {
        public string Caption { get; set; }
        public string ThumbnailUrl { get; set; }
        public string pdfUrl { get; set; }//VAI-1284
        [JsonIgnore]
        public string ImageUri { get; set; }
        [JsonIgnore]
        public bool IsSensitive { get; set; }
        public int ImageCount { get; set; }
        public string ViewerUrl { get; set; }
        public ImageItemDetails[] Images { get; set; } 

    }
}
