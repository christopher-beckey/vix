using System.Collections.Generic;

namespace Hydra.Entities
{
    public class Blob
    {
        public string ImageUid { get; set; }
        public string RefImageUid { get; set; }
        public string ImageType { get; set; }
        public string FileName { get; set; }
        public string Description { get; set; }
        public List<string> Tags { get; set; }
        public string StudyId { get; set; }
        public string StudyDescription { get; set; }
        public string StudyDateTime { get; set; }
        public string PatientDescription { get; set; }
        public string CacheLocator { get; set; }
    }
}