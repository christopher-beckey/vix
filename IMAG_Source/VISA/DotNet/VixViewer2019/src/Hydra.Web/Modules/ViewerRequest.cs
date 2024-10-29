using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Modules
{
    public class ViewerRequest : BaseRequest
    {
        public string StudyId { get; set; }
        public string StudyInstanceUid { get; set; }
        public string GroupUid { get; set; }
        public string ContextId { get; set; }
        public string SecurityToken { get; set; } //todo: review this code.
        public string TestData { get; set; }
        public bool IsValid
        {
            get
            {
                return !string.IsNullOrEmpty(StudyId) ||
                       !string.IsNullOrEmpty(StudyInstanceUid) ||
                       !string.IsNullOrEmpty(GroupUid) ||
                       !string.IsNullOrEmpty(ContextId) ||
                       !string.IsNullOrEmpty(SecurityToken);
            }
        }
    }
}
