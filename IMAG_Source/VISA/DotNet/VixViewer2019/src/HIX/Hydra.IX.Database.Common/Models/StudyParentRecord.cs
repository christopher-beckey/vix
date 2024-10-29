using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class StudyParentRecord
    {
        public int Id { get; set; }
        public string GroupUid { get; set; }
        public string StudyParentId { get; set; }
        public string StudyParentXml { get; set; }
        public string DicomDirXml { get; set; }
    }
}
