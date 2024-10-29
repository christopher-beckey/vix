using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public enum ContextStatusCode
    {
        Error = -1,
        Cached = 0,
        Caching,
        Processing
    }

    public class DisplayContextStatus
    {
        public int TotalImageCount { get; set; }
        public int ImagesUploaded { get; set; }
        public int ImagesProcessed { get; set; }
        public int ImagesFailed { get; set; }
        public int ImagesUploadFailed { get; set; }
        public ContextStatusCode StatusCode { get; set; }
    }
}
