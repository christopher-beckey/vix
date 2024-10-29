using System.Collections.Generic;

namespace Hydra.Entities
{
    public class Study
    {
        public string DicomStudyId { get; set; }

        public string StudyUid { get; set; }

        public string DateTime { get; set; }

        public string Procedure { get; set; }

        public string Modality { get; set; }

        public int ImageCount { get; set; }

        public Patient Patient { get; set; }

        public int SeriesCount { get; set; }

        public List<Series> Series { get; set; }

        public string DicomDirXml { get; set; }
        public string StudyId { get; set; }
    }
}