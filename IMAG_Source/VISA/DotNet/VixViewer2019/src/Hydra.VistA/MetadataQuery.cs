using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class MetadataQuery : VistAQuery
    {
        public string ImageUid { get; set; }
        public string ImageUrn { get; set; }

        public bool IsValid
        {
            get
            {
                return (!string.IsNullOrEmpty(ImageUid));
            }
        }
    }
}
