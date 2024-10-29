using System.Collections.Generic;

namespace Hydra.IX.Common
{
    public class NewImageRequest
    {
        public string GroupUid { get; set; }
        public string RefImageUid { get; set; }
        public string Tag { get; set; }
        public List<NewImageData> ImageData { get; set; }
        public bool IsOwner { get; set; }
    }
}