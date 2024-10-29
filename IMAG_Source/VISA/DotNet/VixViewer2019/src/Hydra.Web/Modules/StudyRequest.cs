using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Modules
{
    public class StudyRequest : BaseRequest
    {
        public string StudyId { get; set; }
        public string StudyInstanceUid { get; set; }
        public string GroupUid { get; set; }
        public bool PreCache { get; set; }

        public bool IsValid
        {
            get
            {
                return !string.IsNullOrEmpty(StudyId) ||
                       !string.IsNullOrEmpty(StudyInstanceUid) ||
                       !string.IsNullOrEmpty(GroupUid);
            }
        }
    }
}
