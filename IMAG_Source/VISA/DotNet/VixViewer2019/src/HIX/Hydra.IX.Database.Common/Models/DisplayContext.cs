using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class DisplayContext : ITaggable
    {
        public int Id { get; set; }
        public string ContextId { get; set; }
        public string GroupUid { get; set; }
        public string Name { get; set; }
        public bool? IsTagged { get; set; }
        public bool? IsDeleted { get; set; }
        public string RefUid
        {
            get
            {
                return ContextId;
            }
        }
        public string Data { get; set; }
        public int ImageCount { get; set; }
    }
}
