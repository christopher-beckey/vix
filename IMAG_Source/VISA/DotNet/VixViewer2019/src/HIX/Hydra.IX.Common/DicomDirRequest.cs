namespace Hydra.IX.Common
{
    public class DicomDirRequest
    {
        public string[] GroupUids { get; set; }
        public bool DicomOnly { get; set; }
        public bool KeepFileNames { get; set; }
        public string AETitle { get; set; }
    }
}