using System.Collections.Generic;

namespace Hydra.IX.Common
{
    public class DicomDirFile
    {
        public string ImageUid { get; set; }
        public string DestinationFilePath { get; set; }
        public string FileName { get; set; }
    }

    public class DicomDirResponse
    {
        public string Base64Manifest { get; set; }
        public List<DicomDirFile> FileList { get; set; }
    }
}