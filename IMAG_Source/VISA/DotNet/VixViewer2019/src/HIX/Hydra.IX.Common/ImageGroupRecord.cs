using System.Collections.Generic;

namespace Hydra.IX.Common
{
    public class ImageGroupRecord
    {
        public string GroupUid { get; set; }
        public string ParentGroupUid { get; set; }
        public string Name { get; set; }
        public List<ImageGroupRecord> Children { get; set; }
        public List<ImageRecord> Images { get; set; }
    }
}