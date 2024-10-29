using Hydra.Common.Exceptions;
using Hydra.IX.Common;
using Hydra.IX.Database.Common;
using Nancy.Json;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Hydra.IX.Core
{
    public class DicomDirBuilder
    {
        public static DicomDirResponse CreateDicomDir(IHixDbContextFactory ctxFactory, DicomDirRequest request)
        {
            var response = new DicomDirResponse
            {
                FileList = new List<DicomDirFile>()
            };

            using (var ctx = ctxFactory.Create())
            {
                var dicomDirBuilder = new Hydra.Dicom.DicomDirBuilder(request.AETitle);

                int groupIndex = 1;
                foreach (var groupUid in request.GroupUids)
                {
                    // group must exist
                    ImageGroup imageGroup = ctx.ImageGroups.FirstOrDefault(x => (x.GroupUid == groupUid));
                    if (imageGroup == null)
                        throw new BadRequestException("Image group {0} does not exist", groupUid);

                    int imageIndex = 1;
                    string studyPath = string.Format("STUDY{0:D2}", groupIndex++);

                    // get all patients
                    IQueryable<StudyParentRecord> studyParentRecords = ctx.StudyParentRecords.Where(x => x.GroupUid == groupUid);
                    foreach (var studyParentRecord in studyParentRecords)
                    {
                        object patientItem = dicomDirBuilder.AddPatient(studyParentRecord.StudyParentId, HipaaUtil.DescryptText(studyParentRecord.DicomDirXml));

                        // get all studies for the patient
                        IQueryable<StudyRecord> studyRecords = ctx.StudyRecords.Where(x => (x.GroupUid == groupUid) && (x.PatientId == studyParentRecord.StudyParentId));
                        foreach (var studyRecord in studyRecords)
                        {
                            var studyItem = dicomDirBuilder.AddStudy(patientItem, studyRecord.StudyInstanceUid, studyRecord.DicomDirXml);

                            // get all series 
                            IQueryable<SeriesRecord> seriesRecords = ctx.SeriesRecords.Where(x => (x.GroupUid == groupUid) && (x.StudyInstanceUid == studyRecord.StudyInstanceUid)).OrderBy(x => x.SeriesNumber);
                            foreach (var seriesRecord in seriesRecords)
                            {
                                //string seriesPath = string.Format("{0}//SE{1:D2}", studyPath, seriesIndex);
                                var seriesItem = dicomDirBuilder.AddSeries(studyItem, seriesRecord.SeriesInstanceUid, seriesRecord.DicomDirXml);
                                object previousDirectoryItem = null;

                                // get all dicom images images
                                IQueryable<ImageFile> imageFiles = ctx.Images.Where(x => (x.GroupUid == groupUid) &&
                                                                                         (x.SeriesInstanceUid == seriesRecord.SeriesInstanceUid) &&
                                                                                         (x.IsDicom.HasValue && x.IsDicom.Value));
                                foreach (var imageFile in imageFiles)
                                {
                                    var fileName = request.KeepFileNames ? imageFile.FileName : string.Format("IM{0:D6}.DCM", imageIndex++);
                                    var filePath = string.Format(@"{0}/{1}", studyPath, fileName);

                                    previousDirectoryItem = dicomDirBuilder.AddImage(seriesItem, previousDirectoryItem, filePath, imageFile.DicomDirXml);

                                    response.FileList.Add(new DicomDirFile
                                        {
                                            DestinationFilePath = filePath,
                                            ImageUid = imageFile.ImageUid,
                                            FileName = imageFile.FileName
                                        });
                                }
                            }
                        }
                    }

                    // get all non-dicom images
                    if (!request.DicomOnly)
                    {
                        int fileIndex = 1;
                        IQueryable<ImageFile> imageFiles = ctx.Images.Where(x => (x.GroupUid == groupUid) &&
                                                                                        (x.IsSucceeded.HasValue && x.IsSucceeded.Value) &&
                                                                                        (!x.IsDicom.HasValue || !x.IsDicom.Value));
                        foreach (var imageFile in imageFiles)
                        {
                            var fileName = request.KeepFileNames ? imageFile.FileName : string.Format("FILE{0:D4}{1}", fileIndex++, imageFile.DetectFileExtension());
                            var filePath = string.Format(@"{0}/{1}", studyPath, fileName);

                            response.FileList.Add(new DicomDirFile
                            {
                                DestinationFilePath = filePath,
                                ImageUid = imageFile.ImageUid,
                                FileName = imageFile.FileName
                            });
                        }
                    }
                }

                if (dicomDirBuilder.IsValid())
                {
                    using (var stream = new MemoryStream())
                    {
                        dicomDirBuilder.Save(stream);
                        stream.Seek(0, SeekOrigin.Begin);

                        response.Base64Manifest = Convert.ToBase64String(stream.ToArray());
                    }
                }
            }

            return response;
        }
    }
}
