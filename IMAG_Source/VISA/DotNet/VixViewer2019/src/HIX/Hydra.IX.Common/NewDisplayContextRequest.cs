using System.Collections.Generic;

namespace Hydra.IX.Common
{
    public class NewDisplayContextRequest
    {
        public string ContextId { get; set; }
        public string Name { get; set; }
        public string Data { get; set; }
        public List<NewImageDataGroup> ImageDataGroupList { get; set; }
        public string ParentGroupUid { get; set; }
        public string Tag { get; set; }
        public string RequestedImageGroupUid { get; set; }
    }
}