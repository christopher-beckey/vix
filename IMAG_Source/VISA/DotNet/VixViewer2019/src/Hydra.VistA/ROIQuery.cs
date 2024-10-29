using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class ROIQuery : VistAQuery
    {
        public StudyItem[] Studies { get; set; }
        //[JsonIgnore]
        //public string ViewerRootUrl { get; set; }

        public bool ExcludeToken { get; set; }

        public bool ShouldSerializeSecurityToken() { return false; }
        public bool ShouldSerializeExcludeToken() { return false; }
        public bool ShouldSerializeVixTimeout() { return false; }
    }
}
