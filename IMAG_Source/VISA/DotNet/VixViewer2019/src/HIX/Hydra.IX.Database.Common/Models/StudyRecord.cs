using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class StudyRecord
    {
        public int Id { get; set; }
        public string GroupUid { get; set; }
        public string DicomStudyId { get; set; }
        public string StudyInstanceUid { get; set; }
        public string PatientId { get; set; }
        public string StudyXml { get; set; }
        public string DicomDirXml { get; set; }
    }
}
