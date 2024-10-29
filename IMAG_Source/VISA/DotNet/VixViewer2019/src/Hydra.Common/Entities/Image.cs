using System.Collections.Generic;

namespace Hydra.Entities
{
    public class Image
    {
        public string ImageId { get; set; }
        public string FilePath { get; set; }
        public string CacheLocator { get; set; }

        public int Index { get; set; }

        public Image()
        {
        }

        public string DicomStudyId { get; set; }
        public string ImageUid { get; set; }
        public string RefImageUid { get; set; }
        public string SopInstanceUid { get; set; }
        public string SeriesInstanceUid { get; set; }
        public string StudyInstanceUid { get; set; }
        public int SeriesNumber { get; set; }
        public string FileName { get; set; }
        public string Description { get; set; }
        public int NumberOfFrames { get; set; }
        public int FrameSize { get; set; }
        public int InstanceNumber { get; set; }
        public string ImageType { get; set; }
        public string Modality { get; set; }
        public ImagePlane ImagePlane { get; set; }
        public List<string> Tags { get; set; }
        public string StudyId { get; set; }
        public string StudyDescription { get; set; }
        public string StudyDateTime { get; set; }
        public string PatientDescription { get; set; }
    }
}