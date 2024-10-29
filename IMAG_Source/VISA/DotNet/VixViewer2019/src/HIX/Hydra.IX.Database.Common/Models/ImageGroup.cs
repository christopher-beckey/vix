using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class ImageGroup : ITaggable
    {
        public int Id { get; set; }
        public string GroupUid { get; set; }
        public string ParentGroupUid { get; set; }
        public string RootGroupUid { get; set; }
        public string StudyGroupUid { get; set; }
        public DateTime DateCreated { get; set; }
        public DateTime? DateAccessed { get; set; }
        public int FolderNumber { get; set; }
        public string RelativePath { get; set; }
        public int ImageStoreId { get; set; }
        public string Xml { get; set; }
        public string Name { get; set; }
        public bool? IsTagged { get; set; }
        public bool? IsDeleted { get; set; }
        public string RefUid
        {
            get
            {
                return GroupUid;
            }
        }
    }
}
