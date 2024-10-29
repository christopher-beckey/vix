using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Common
{
    public class PurgeRequest
    {
        public double? MaxCacheSizeMB { get; set; }
        public int? MaxAgeDays { get; set; }
        public int? MaxEventLogAgeDays { get; set; }
        public int? ImageGroupPurgeBlockSize { get; set; }
        public int? ImagePurgeBlockSize { get; set; }
        public bool? EnableCacheCleanup { get; set; }
    }
}
