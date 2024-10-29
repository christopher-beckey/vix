using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public class UserDetails
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string Initials { get; set; }
        public bool CanDelete { get; set; }
        public bool CanEdit { get; set; }
        public bool CanPrint { get; set; }
        public bool IsAdmin { get; set; }
    }
}
