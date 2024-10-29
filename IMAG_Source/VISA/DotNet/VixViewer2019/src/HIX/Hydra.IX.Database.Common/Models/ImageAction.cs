using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class ImageAction
    {
        public int Id { get; set; }
        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }
        public string ImageUid { get; set; }
        public string FileName { get; set; }
        public string Path { get; set; }
        public string Action { get; set; }
        public string Status { get; set; }
    }
}
