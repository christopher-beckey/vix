using System.Collections.Generic;

namespace Hydra.IX.Common
{
    public class NewImageDataGroup
    {
        public string StudyId { get; set; }
        public string StudyDescription { get; set; }
        public string StudyDateTime { get; set; }
        public string PatientDescription { get; set; }
        public List<NewImageData> ImageData { get; set; }
        public bool IsOwner { get; set; }
    }
}