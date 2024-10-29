using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public class ImageFile : ITaggable
    {
        public int Id { get; set; }
        public string ImageUid { get; set; }
        public string RootGroupUid { get; set; }
        public string GroupUid { get; set; }
        public string ExternalImageId { get; set; }
        public Hydra.Common.ImageType ImageType { get; set; }
        public string FileName { get; set; }
        public Hydra.Common.FileType FileType { get; set; }
        public string RelativePath { get; set; }
        public bool IsUploaded { get; set; }
        public DateTime? DateUploaded { get; set; }
        public bool IsEncrypted { get; set; }
        public bool IsProcessed { get; set; }
        public bool IsSynced { get; set; }
        public bool? IsSucceeded { get; set; }
        public bool? IsDeleted { get; set; }
        public string Status { get; set; }
        public bool? IsDicom { get; set; }
        public string SeriesInstanceUid { get; set; }
        public string StudyInstanceUid { get; set; }
        public string SopInstanceUid { get; set; }
        public int InstanceNumber { get; set; }
        public int SeriesNumber { get; set; }
        public string ImageXml { get; set; }
        public bool? IsTagged { get; set; }
        public string RefImageUid { get; set; }
        public string RefUid
        {
            get
            {
                return ImageUid;
            }
        }
        public string DicomDirXml { get; set; }
        public string DicomXml { get; set; }
        public string Description { get; set; }
        public string StudyId { get; set; }
        public string StudyDescription { get; set; }
        public string StudyDateTime { get; set; }
        public string PatientDescription { get; set; }
        public bool IsOwner { get; set; }
        public string AlternatePath { get; set; }

    }
}
