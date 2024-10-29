using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA
{
    public class PatientStudyQueryJob
    {
        public StudyQuery StudyQuery { get; set; }
        public string SiteNumber { get; set; }
        public StudyItem[] Studies { get; set; }
    }
}
