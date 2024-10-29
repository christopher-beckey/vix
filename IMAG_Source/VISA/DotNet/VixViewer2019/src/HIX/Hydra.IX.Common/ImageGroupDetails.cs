using System.Collections.Generic;

namespace Hydra.IX.Common
{
    public class ImageGroupDetails
    {
        public string GroupUid { get; set; }
        public List<Hydra.Entities.Study> Studies { get; set; }
        public List<Hydra.Entities.Image> Images { get; set; }
        public List<Hydra.Entities.Blob> Blobs { get; set; }
        public List<ImageGroupDetails> Children { get; set; }
        public List<string> Tags { get; set; }
    }
}