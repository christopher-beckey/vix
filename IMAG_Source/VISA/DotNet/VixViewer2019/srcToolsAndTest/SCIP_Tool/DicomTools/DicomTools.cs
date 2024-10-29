using Dicom;
using Dicom.Media;
using System;
using System.Collections.Generic;
using System.IO;

namespace SCIP_Tool
{
    public static class DicomTools
    {
        //public static bool AnyGrayPixelData(GrayscalePixelData pd)
        //{
        //    bool result = false;
        //    foreach (byte b in pd)
        //    {
        //        if ((b != 0) && (b !=255))
        //        {
        //            result = true;
        //            break;
        //        }
        //    }
        //    return result;
        //}

        //public static byte[] ExtractBitmap(string filename)
        //{
        //    return ExtractBitmap(new VSDMImageSop(filename));
        //}


        //public static byte[] ExtractBitmap(DicomFile file)
        //{
        //    return ExtractBitmap(new VSDMImageSop(file));
        //}

        //private static byte[] ExtractBitmap(ImageSop sop)
        //{
        //    byte[] b = null;

        //    try
        //    {
        //        Bitmap bitmap = null;
        //        MemoryStream ms = new MemoryStream();
        //        IEnumerable<IPresentationImage> images = PresentationImageFactory.Create(sop);

        //        // This loop is only needed if we want to get all images....
        //        foreach (IPresentationImage image in images)
        //        {
        //            ISpatialTransformProvider spatial = image as ISpatialTransformProvider;
        //            spatial.SpatialTransform.Scale = 2;

        //            bitmap = image.DrawToBitmap(512, 512);
        //            bitmap.Save(ms, ImageFormat.Png);
        //            break; // Take just the first image ...
        //        }
        //        // Dispose objects
        //        bitmap.Dispose();
        //        bitmap = null;
        //        b = ms.ToArray();
        //        ms.Dispose();
        //        ms = null;
        //    }
        //    catch (Exception ex)
        //    {
        //        b = null;
        //    }

        //    return b;
        //}

        #region FO_DICOM

        //NOTE: There is a bug in FO-DICOM that rescales the window's fonts or something, but it only happens in Visual Studio, so I'm not going to worry about it now
        //https://stackoverflow.com/questions/49688458/when-i-use-fo-dicom-to-update-a-dicom-tag-the-c-sharp-form-changes-size

        public static List<string> FoDicomInspect(string dicomFilePath)
        {
            List<string> results = new List<string>();
            try
            {
                //TODO: AutoValidate
                var file = DicomFile.Open(dicomFilePath);
                if (file.FileMetaInfo.ImplementationClassUID != null)
                    results.Add($"ImplementationClassUID: {file.FileMetaInfo.ImplementationClassUID}");
                if (file.FileMetaInfo.ImplementationVersionName != null)
                    results.Add($"ImplementationVersionName: {file.FileMetaInfo.ImplementationVersionName}");
                if (file.FileMetaInfo.InternalTransferSyntax != null)
                    results.Add($"InternalTransferSyntax: {file.FileMetaInfo.InternalTransferSyntax}");
                if (file.FileMetaInfo.MediaStorageSOPClassUID != null)
                    results.Add($"ImplementationClassUID: {file.FileMetaInfo.MediaStorageSOPClassUID}");
                if (file.FileMetaInfo.MediaStorageSOPInstanceUID != null)
                    results.Add($"ImplementationClassUID: {file.FileMetaInfo.MediaStorageSOPInstanceUID}");
                if (file.FileMetaInfo.PrivateInformation != null)
                    results.Add($"PrivateInformation: {file.FileMetaInfo.PrivateInformation}");
                if (file.FileMetaInfo.PrivateInformationCreatorUID != null)
                    results.Add($"ImplementationClassUID: {file.FileMetaInfo.PrivateInformationCreatorUID}");
                if (file.FileMetaInfo.ReceivingApplicationEntityTitle != null)
                    results.Add($"ImplementationClassUID: {file.FileMetaInfo.ReceivingApplicationEntityTitle}");
                if (file.FileMetaInfo.SendingApplicationEntityTitle != null)
                    results.Add($"ImplementationClassUID: {file.FileMetaInfo.SendingApplicationEntityTitle}");
                if (file.FileMetaInfo.SourceApplicationEntityTitle != null)
                    results.Add($"ImplementationClassUID: {file.FileMetaInfo.SourceApplicationEntityTitle}");
                if (file.FileMetaInfo.Version != null)
                    results.Add($"ImplementationClassUID: {file.FileMetaInfo.Version}");
                foreach (var tag in file.Dataset)
                {
                    results.Add($"{tag} '{file.Dataset.GetValueOrDefault(tag.Tag, 0, "")}'");
                }
            }
            catch(Exception ex)
            {
                results.Add(ex.ToString());
            }
            return results;
        }

        public static List<string> ReadDicomDirFile(string filePath)
        {
            List<string> results = new List<string>();
            try
            {
                DicomDirectory dicomDirectory = DicomDirectory.Open(filePath); //There is no close

                foreach (var patientRecord in dicomDirectory.RootDirectoryRecordCollection)
                {
                    results.Add($"Patient: {patientRecord.GetString(DicomTag.PatientName)} ({patientRecord.GetString(DicomTag.PatientID)})");

                    foreach (var studyRecord in patientRecord.LowerLevelDirectoryRecordCollection)
                    {
                        results.Add($"\tStudy: {studyRecord.GetString(DicomTag.StudyInstanceUID)}");

                        foreach (var seriesRecord in studyRecord.LowerLevelDirectoryRecordCollection)
                        {
                            results.Add($"\t\tSeries: {seriesRecord.GetString(DicomTag.SeriesInstanceUID)}");

                            foreach (var imageRecord in seriesRecord.LowerLevelDirectoryRecordCollection)
                            {
                                results.Add($"\t\t\tImage: {imageRecord.GetString(DicomTag.ReferencedSOPInstanceUIDInFile)} [{imageRecord.GetString(Dicom.DicomTag.ReferencedFileID)}]");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                results.Add(ex.ToString());
            }
            return results;
        }

        public static string WriteDicomFiles(string folderPath)
        {
            string result = null;
            try
            {
                if (!Directory.Exists(folderPath))
                    result = $"ERROR: {folderPath} does not exist.";
                else
                {
                    var dicomDirPath = Path.Combine(folderPath, "DICOMDIR");
                    var dirInfo = new DirectoryInfo(folderPath);

                    var dicomDir = new DicomDirectory();
                    int numFiles = 0;
                    foreach (var file in dirInfo.GetFiles("*.*", SearchOption.AllDirectories))
                    {
                        numFiles++;
                        var dicomFile = Dicom.DicomFile.Open(file.FullName);
                        dicomDir.AddFile(dicomFile, String.Format(@"000001\{0}", file.Name));
                    }

                    dicomDir.Save(dicomDirPath);
                    result = $"{dicomDirPath}: {numFiles} files";
                }
            }
            catch (Exception ex)
            {
                result = ex.ToString();
            }
            return result;
        }
        #endregion FO_DICOM
    }
}
