using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public class ImageDeleteResponse
    {
        public bool IsSucceeded { get; set; }
        public string ImageId { get; set; }
        public string Message { get; set; }
    }
}
