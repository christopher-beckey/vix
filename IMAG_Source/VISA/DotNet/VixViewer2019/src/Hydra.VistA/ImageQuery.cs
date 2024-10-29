using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class ImageQuery : VistAQuery
    {
        public string ImageURN { get; set; }
        public string ImageQuality { get; set; }
        public string ContentType { get; set; }
        public string ContentTypeWithSubType { get; set; }
        public bool IsSensitive { get; set; }
        public string Reason { get; set; }

        public bool IsValid
        {
            get
            {
                return (!string.IsNullOrEmpty(ContextId) );
            }
        }
    }
}
