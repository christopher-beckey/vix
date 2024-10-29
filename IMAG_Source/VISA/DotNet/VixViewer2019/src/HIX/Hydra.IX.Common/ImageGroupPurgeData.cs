using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Common
{
    public class ImageGroupPurgeData
    {
        public string GroupUid { get; set; }
        public string ParentGroupUid { get; set; }
        public int FolderNumber { get; set; }
        public string RelativePath { get; set; }
        public int ImageStoreId { get; set; }
        public string ContextId { get; set; }
    }
}
