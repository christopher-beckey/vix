using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class ImageTagMap
    {
        public int Id { get; set; }
        public string ImageUid { get; set; }
        public int ImageTagId { get; set; }
    }
}
