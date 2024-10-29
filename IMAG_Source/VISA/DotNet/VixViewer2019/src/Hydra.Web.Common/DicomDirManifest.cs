using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web.Common
{
    public class DicomDirManifest
    {
        public class File
        {
            public string ImageUid { get; set; }
            public string DestinationFilePath { get; set; }
            public string FileName { get; set; }
        }

        public string Base64Manifest { get; set; }
        public List<DicomDirManifest.File> FileList { get; set; }
    }
}
