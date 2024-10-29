using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class ImageBackupRecord
    {
        public int Id { get; set; }
        public string ImageUid { get; set; }
        public int ImageStoreId { get; set; }
        public bool IsComplete { get; set; }
        public bool? IsSucceeded { get; set; }
        public int RetryCount { get; set; }
        public string Status { get; set; }
    }
}
