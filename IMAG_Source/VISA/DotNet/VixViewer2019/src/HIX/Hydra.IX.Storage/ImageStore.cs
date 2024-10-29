using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Storage
{
    public class ImageStore
    {
        public int Id { get; set; }
        public int FolderLevels { get; set; }
        public bool IsEncrypted { get; set; }
        public bool IsEnabled { get; set; }
        public Hydra.IX.Common.ImageStoreType Type { get; set; }
        public int SourceId { get; set; }
        public int SearchOrder { get; set; }
        public string Path { get; set; }
        public bool IsLocal { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string Domain { get; set; }
        [NotMapped]
        public bool IsConnected { get; set; }
        public int DiskFullThreshold { get; set; }
        public bool AutoCreate { get; set; }
    }
}
