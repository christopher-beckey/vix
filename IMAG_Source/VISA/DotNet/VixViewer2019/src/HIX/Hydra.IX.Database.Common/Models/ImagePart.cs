using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class ImagePart
    {
        public int Id { get; set; }
        public string GroupUid { get; set; }
        public string ImageUid { get; set; }
        public DateTime DateCreated { get; set; }
        public int Frame { get; set; }
        public int Type { get; set; }
        public int Transform { get; set; }
        public string AbsolutePath { get; set; }
        public bool IsStatic { get; set; }
        public bool IsEncrypted { get; set; }
        public int? OverlayIndex { get; set; }
    }
}
