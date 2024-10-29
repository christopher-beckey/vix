using System.Collections.Generic;

//using MongoDB.Bson.Serialization.Attributes;

namespace Hydra.Entities
{
    public class Series
    {
        public string Description { get; set; }
        public string SeriesInstanceUID { get; set; }
        public int SeriesNumber { get; set; }
        public int ImageCount { get; set; }
        public List<Image> Images { get; set; }
        public string Modality { get; set; }
        public string DicomDirXml { get; set; }
        public string StudyInstanceUID { get; set; }
    }
}