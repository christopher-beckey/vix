using Hydra.Common.Extensions;
using Hydra.IX.Core.Remote;
using Hydra.IX.Database;
using Hydra.IX.Database.Common;
using Hydra.IX.Storage;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;

namespace Hydra.IX.Core
{
    public class ImageManager : IImageManager
    {
        public class JobData
        {
            public string ImageUid { get; set; }
            public string FilePath { get; set; }
        }

        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private Hydra.IX.Common.BackgroundWorker<JobData> _JobQueue = null;
        private bool _UseWorkerPool = false;
        private IHixWorkerPool _HixWorkerPool = null;

        public ImageManager()
        {
            _HixWorkerPool = new HixWorkerPool();
        }

        private void InitializeWorker(int jobId)
        {
            if (_UseWorkerPool)
            {
                _HixWorkerPool.InitializeWorker(jobId);
            }
        }

        public void Start(bool useWorkerPool, int workerPoolSize)
        {
            _UseWorkerPool = useWorkerPool;

            _JobQueue = new Hydra.IX.Common.BackgroundWorker<JobData>(workerPoolSize,
                                                                     (job, workerId, workerIndex, token) => ProcessImage(job, workerId, token),
                                                                     (workerId) => InitializeWorker(workerId));
            _JobQueue.Start(true); //wait until all workers are running.
        }

        public void Stop()
        {
            if (_JobQueue != null)
            {
                _JobQueue.Stop();
                _JobQueue = null;
            }

            if (_UseWorkerPool)
            {
                _HixWorkerPool.StopWorkers();
            }
        }

        public void QueueImage(string imageUid)
        {
            if (_JobQueue == null)
                return;

            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Image queued for processing", "ImageUid", imageUid);

            _JobQueue.QueueJob(new JobData { ImageUid = imageUid });
        }

        public void QueuePendingImages()
        {
            using (var ctx = new HixDbContextFactory().Create())
            {
                // get list of images that have been uploaded but not processed
                List<string> imageUids = ctx.Images.Where(x => (x.IsUploaded && !x.IsProcessed)).Select(x => x.ImageUid).ToList();
                foreach (var imageUid in imageUids)
                {
                    QueueImage(imageUid);
                }
            }
        }

        public void ProcessImage(JobData jobData, int jobId, CancellationToken token)
        {
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Image ready for processing", "ImageUid", jobData.ImageUid);

            if (_UseWorkerPool)
            {
                _HixWorkerPool.ProcessImage(jobData.ImageUid, jobId);
            }
            else
            {
                // handle the image in-process
                ProcessImage(jobData.ImageUid, token);
            }
        }

        public void ProcessImage(string imageUid, CancellationToken token)
        {
            var codeClock = Hydra.Common.CodeClock.Start();
            string filePath = null;
            string alternateFilePath = null;
            
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Processing image...", "ImageUid", imageUid);

                using (var ctx = new HixDbContextFactory().Create())
                {
                    // get image
                    ImageFile imageFile = ctx.Images.Where(x => (x.ImageUid == imageUid)).FirstOrDefault();
                    if (imageFile == null)
                        throw new Exception("Image uid is not valid");

                    // get image group
                    ImageGroup imageGroup = ctx.ImageGroups.Where(x => (x.GroupUid == imageFile.GroupUid)).FirstOrDefault();
                    if (imageGroup == null)
                        throw new Exception("Image group Uid not valid");

                    try
                    {
                        string cachefolder = StorageManager.Instance.GetCacheFolder(imageGroup);
                        if (!Directory.Exists(cachefolder))
                            Directory.CreateDirectory(cachefolder);

                        Dicom.ImageProcessResultset resultset = null;
                        var fileStorage = StorageManager.Instance.GetFileStorage();
                        var studyBuilder = new StudyBuilder(imageGroup, imageFile.StudyId, HixService.Instance.ServiceMode == HixServiceMode.Worker);

                        if (imageFile.IsEncrypted)
                        {
                            using (var memoryStream = StorageManager.Instance.GetImageStream(imageFile, imageGroup, out filePath))
                            {
                                resultset = Dicom.ImageProcessor.ProcessImage(memoryStream, filePath, imageFile.FileType, cachefolder, fileStorage, studyBuilder);
                            }
                        }
                        else
                        {
                            filePath = StorageManager.Instance.GetImagePath(imageFile, imageGroup);
                            alternateFilePath = imageFile.AlternatePath;

                            resultset = Dicom.ImageProcessor.ProcessImage(filePath, alternateFilePath, imageFile.FileType, cachefolder, fileStorage, studyBuilder);
                        }

                        if (resultset != null)
                        {
                            imageFile.IsSucceeded = true;
                            imageFile.IsProcessed = true;
                            imageFile.IsDicom = resultset.ImageType.IsDicom();

                            if (resultset.Image != null)
                            {
                                // renderable image 
                                imageFile.ImageType = resultset.ImageType;
                                //VAI-788: set SeriesInstanceUid to the bad one if it needs cleanup
                                if (resultset.NeedsUnsupportedTypeCleanUp)
                                {
                                    imageFile.SeriesInstanceUid = StudyBuilder.BadSeriesId;
                                }
                                else
                                {
                                    imageFile.SeriesInstanceUid = resultset.Image.SeriesInstanceUid;
                                }
                                imageFile.StudyInstanceUid = resultset.Image.StudyInstanceUid;
                                imageFile.InstanceNumber = resultset.Image.InstanceNumber;
                                imageFile.SeriesNumber = resultset.Image.SeriesNumber;

                                resultset.Image.ImageUid = imageFile.ImageUid;
                                resultset.Image.FileName = imageFile.FileName;
                                if (string.IsNullOrEmpty(resultset.Image.Description))
                                    resultset.Image.Description = imageFile.Description;

                                resultset.Image.StudyId = imageFile.StudyId;
                                resultset.Image.StudyDescription = imageFile.StudyDescription;
                                resultset.Image.StudyDateTime = imageFile.StudyDateTime;
                                resultset.Image.PatientDescription = imageFile.PatientDescription;

                                var serializer = new Nancy.Json.JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
                                imageFile.ImageXml = serializer.Serialize(resultset.Image);
                                imageFile.DicomDirXml = resultset.DicomDirXml;
                                imageFile.DicomXml = HipaaUtil.EncryptText(resultset.DicomXml);
                            }
                            else
                            {
                                //imageFile.ImageType = Hydra.Common.ImageType.Blob;
                                imageFile.ImageType = resultset.ImageType;

                                // assume the file is a blob
                                var blob = new Hydra.Entities.Blob
                                {
                                    FileName = imageFile.FileName,
                                    ImageType = imageFile.ImageType.AsString(),
                                    ImageUid = imageFile.ImageUid,
                                    Description = imageFile.Description,
                                    StudyId = imageFile.StudyId,
                                    StudyDescription = imageFile.StudyDescription,
                                    StudyDateTime = imageFile.StudyDateTime,
                                    PatientDescription = imageFile.PatientDescription
                                };

                                var serializer = new Nancy.Json.JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
                                imageFile.ImageXml = serializer.Serialize(blob);
                            }

                            ctx.Entry(imageFile).State = System.Data.Entity.EntityState.Modified;

                            var dataFieldArray = new DataFieldArray("Type", "Transform", "FilePath");

                            foreach (var imagePart in resultset.ImageParts)
                            {
                                var imagePartRecord = new ImagePart
                                {
                                    GroupUid = imageGroup.GroupUid,
                                    ImageUid = imageUid,
                                    Frame = imagePart.Frame,
                                    OverlayIndex = imagePart.OverlayIndex,
                                    Type = (int)imagePart.Type,
                                    Transform = (int)imagePart.Transform,
                                    AbsolutePath = imagePart.FilePath,
                                    IsStatic = imagePart.IsStatic,
                                    DateCreated = DateTime.UtcNow,
                                    IsEncrypted = StorageManager.Instance.CacheImageStore.IsEncrypted
                                };

                                ctx.ImageParts.Add(imagePartRecord);

                                dataFieldArray.AddItem(imagePart.Type.ToString(), imagePart.Transform.ToString(), imagePart.FilePath);
                                //if (_Logger.IsInfoEnabled)
                                //    _Logger.Info("Image part created for image", "ImageUid", imageFile.ImageUid, "Type", imagePart.Type.ToString(), "Transform", imagePart.Transform.ToString(), "FilePath", imagePart.FilePath);
                            }

                            // add 3D volumeframe records
                            //if (resultset.VolumeFrames != null)
                            //{
                            //    foreach (var volumeFrame in resultset.VolumeFrames)
                            //    {
                            //        var volumeFrameRecord = new Hydra.IX.Database.Common.VolumeFrame
                            //        {
                            //            GroupUid = imageGroup.GroupUid,
                            //            ImageUid = imageUid,
                            //            Frame = volumeFrame.Frame,
                            //            FrameCount = volumeFrame.FrameCount,
                            //            SeriesInstanceUid = volumeFrame.SeriesInstanceUid,
                            //            StudyInstanceUid = volumeFrame.StudyInstanceUid,
                            //            BitsPerPixel = volumeFrame.BitsPerPixel,
                            //            HighBit = volumeFrame.HighBit,
                            //            RelevantBits = volumeFrame.RelevantBits,
                            //            DimensionX = volumeFrame.DimensionX,
                            //            DimensionY = volumeFrame.DimensionY,
                            //            OrientationM11 = volumeFrame.OrientationM11,
                            //            OrientationM21 = volumeFrame.OrientationM21,
                            //            OrientationM31 = volumeFrame.OrientationM31,
                            //            OrientationM12 = volumeFrame.OrientationM12,
                            //            OrientationM22 = volumeFrame.OrientationM22,
                            //            OrientationM32 = volumeFrame.OrientationM32,
                            //            OrientationM13 = volumeFrame.OrientationM13,
                            //            OrientationM23 = volumeFrame.OrientationM23,
                            //            OrientationM33 = volumeFrame.OrientationM33,
                            //            SpacingX = volumeFrame.SpacingX,
                            //            SpacingY = volumeFrame.SpacingY,
                            //            SpacingZ = volumeFrame.SpacingZ,
                            //            IsSigned = volumeFrame.IsSigned,
                            //            PixelPaddingValue = volumeFrame.PixelPaddingValue,
                            //            WindowWidth = volumeFrame.WindowWidth,
                            //            WindowCenter = volumeFrame.WindowCenter,
                            //            RescaleIntercept = volumeFrame.RescaleIntercept,
                            //            RescaleSlope = volumeFrame.RescaleSlope,
                            //            FilePath = volumeFrame.FilePath
                            //        };

                            //        ctx.VolumeFrames.Add(volumeFrameRecord);
                            //    }
                            //}

                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("Completed converting image", "ImageUid", imageFile.ImageUid, "ImageType", imageFile.ImageType.ToString(), "ImageParts", dataFieldArray);

                            ctx.SaveChanges();

                            //VAI 788 - Clean up database for image type not supported by the viewer so StudyInstanceUID matches and SeriesNumber is greater 
                            if (IsLastInstance(ctx, imageGroup.GroupUid))
                            {
                                CleanUpStudy(ctx, imageGroup.GroupUid);
                            }                      
                        }
                    }
                    catch (Exception ex)
                    {
                        _Logger.Error("Error processing image.", "ImageUid", imageUid, 
                                      "FilePath", filePath, "AlternateFilePath", alternateFilePath,
                                      "Exception", ex.ToString(), "Time", codeClock.ElapsedMilliseconds);

                        imageFile.IsSucceeded = false;
                        imageFile.Status = ex.Message;
                        imageFile.IsProcessed = true;
                        ctx.Entry(imageFile).State = System.Data.Entity.EntityState.Modified;
                        ctx.SaveChanges();
                    }
                    finally
                    {
                        // clear image group details
                        imageGroup.Xml = null;
                        ctx.Entry(imageGroup).State = System.Data.Entity.EntityState.Modified;
                        ctx.SaveChanges();
                    }
                }

                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Processing image complete", "ImageUid", imageUid,
                                 "FilePath", filePath, "AlternateFilePath", alternateFilePath,
                                 "Time", codeClock.ElapsedMilliseconds);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error processing image", "ImageUid", imageUid,
                              "FilePath", filePath, "AlternateFilePath", alternateFilePath,
                              "Exception", ex.ToString(), "Time", codeClock.ElapsedMilliseconds);
            }
            finally
            {
            }
        }

        //VAI-788: cleans up database for image type not supported by the viewer so StudyInstanceUID matches and SeriesNumber is greater
        private bool CleanUpStudy(IHixDbContext ctx, string ImageGroupUid)
        {
            try
            {
                var seriesRecord = ctx.SeriesRecords.Where(x => (x.GroupUid == ImageGroupUid) && (x.SeriesInstanceUid == StudyBuilder.BadSeriesId)).FirstOrDefault();                
                if (seriesRecord != null)
                {
                    var studyRecord = ctx.StudyRecords.Where(x => (x.GroupUid == ImageGroupUid) && (x.StudyInstanceUid == seriesRecord.StudyInstanceUid)).FirstOrDefault();
                    var studyParentRecord = ctx.StudyParentRecords.Where(x => (x.GroupUid == ImageGroupUid) && (x.StudyParentId == "")).FirstOrDefault();
                    var goodStudyRecord = ctx.StudyRecords.Where(x => (x.GroupUid == ImageGroupUid) && (x.StudyInstanceUid != studyRecord.StudyInstanceUid)).FirstOrDefault();
                    int maxSeriesNumber = ctx.SeriesRecords.Where(x => x.GroupUid == ImageGroupUid).Max(x => x.SeriesNumber);
                    var imageRecords = ctx.Images.Where(x => (x.GroupUid == ImageGroupUid) && (x.StudyInstanceUid == studyRecord.StudyInstanceUid));
                    var tempSeriesXml = seriesRecord.SeriesXml;

                    seriesRecord.StudyInstanceUid = goodStudyRecord.StudyInstanceUid;
                    seriesRecord.SeriesNumber = maxSeriesNumber + 1;
                    seriesRecord.SeriesXml = tempSeriesXml.Replace("\"seriesNumber\":0", "\"seriesNumber\":" + (maxSeriesNumber + 1).ToString());
                    foreach (var imageRecord in imageRecords)
                    {
                        imageRecord.StudyInstanceUid = goodStudyRecord.StudyInstanceUid;
                        imageRecord.SeriesNumber = maxSeriesNumber + 1;
                    }

                    ctx.StudyParentRecords.Remove(studyParentRecord);
                    ctx.StudyRecords.Remove(studyRecord);
                    ctx.SaveChanges();
                }               
                return true;
            }
            catch (Exception ex)
            {
                _Logger.Info("Error cleaning up study in database.", "Exception", ex.Message);
                return false;
            }
        }

        //VAI-788: determines if the last image for the study has been processed, used for clean-up
        private bool IsLastInstance(IHixDbContext ctx, string ImageGroupUid)
        {          
            int imageFilesCount = ctx.Images.Where(x => (x.GroupUid == ImageGroupUid) && (x.IsProcessed)).Count();
            DisplayContext dispCtx = ctx.DisplayContexts.Where(x => (x.GroupUid == ImageGroupUid)).FirstOrDefault();

            if (imageFilesCount == dispCtx.ImageCount) //last image for study
            {
                return true;
            }
            
            return false;
        }
    }
}
