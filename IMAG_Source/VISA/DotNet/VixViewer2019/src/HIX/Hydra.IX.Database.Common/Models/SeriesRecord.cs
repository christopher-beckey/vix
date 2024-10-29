using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class SeriesRecord
    {
        public int Id { get; set; }
        public string GroupUid { get; set; }
        public string SeriesInstanceUid { get; set; }
        public string StudyInstanceUid { get; set; }
        public int SeriesNumber { get; set; } 
        public string SeriesXml { get; set; }
        public string DicomDirXml { get; set; }
    }
}
