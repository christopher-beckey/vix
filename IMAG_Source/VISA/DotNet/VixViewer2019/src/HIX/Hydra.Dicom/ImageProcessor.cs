using ClearCanvas.Dicom;
using ClearCanvas.Dicom.Codec;
using ClearCanvas.Dicom.IO;
using ClearCanvas.Dicom.Iod;
using ClearCanvas.Dicom.Iod.Iods;
using ClearCanvas.Dicom.Iod.Modules;
using ClearCanvas.Dicom.Utilities;
using ClearCanvas.ImageViewer;
using ClearCanvas.ImageViewer.Annotations.Dicom;
using ClearCanvas.ImageViewer.Graphics;
using ClearCanvas.ImageViewer.Imaging;
using ClearCanvas.ImageViewer.PresentationStates.Dicom;
using ClearCanvas.ImageViewer.StudyManagement;
using Hydra.Common;
using Hydra.Common.Extensions;
using Hydra.ECG;
using Hydra.Entities;
using Hydra.Log;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using ZLibNet;
using System.Threading;
using System.Threading.Tasks;
using System.Net;
using System.Management;
using System.Drawing.Imaging;



namespace Hydra.Dicom
{
    public class ImageProcessor
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private static readonly int ThumbnailWidth = 120;
        private static readonly int ThumbnailHeight = 120;
        private static int ConverterInUse = 0;

        public enum ImageEdge
        {
            Left = 0,
            Top = 1,
            Right = 2,
            Bottom = 3
        };

        public static string TempFolder { get; set; }
        public static string XslFolder { get; set; }
		public static bool Is3DEnabled { get; set; }

        public static ImageProcessResultset ProcessImage(string filePath, string alternateFilePath, Hydra.Common.FileType fileType, string targetFolder, IFileStorage fileStorage, IStudyBuilder studyBuilder)
        {
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Processing image from file.", "FilePath", filePath, "AltFilePath", alternateFilePath);

            ImageProcessResultset resultset = new ImageProcessResultset(Path.GetFileNameWithoutExtension(filePath), targetFolder);

            if (fileStorage == null)
                fileStorage = new DefaultFileStorage();

            // use alternate file path if set.
            if (!string.IsNullOrEmpty(alternateFilePath))
                filePath = alternateFilePath;

            DicomFile dicomFile = null;

            if ((fileType == FileType.Unknown) ||
                (fileType == FileType.Dicom))
            {
                dicomFile = LoadDicomFile(filePath);
                if (dicomFile == null)
                {
                    ProcessTargaImage(null, filePath, resultset, fileStorage);
                }
            }

            if (dicomFile != null)
            {
                ProcessDicomImage(dicomFile, null, filePath, resultset, fileStorage, studyBuilder);
            }
            else
            {
                if (fileType != FileType.Dicom)
                {
                    try
                    {
                        switch (fileType)
                        {
                            case FileType.Audio_Wav:

                                ProcessAudioFile(null, filePath, resultset, fileStorage);
                                break;

                            case FileType.Video_Avi:
                            case FileType.Video_Mp4:

                                ProcessVideoFile(null, filePath, fileType, resultset, fileStorage);
                                break;

                            case FileType.Image:
                            case FileType.Unknown:
                                ProcessGeneralImage(filePath, resultset, fileStorage);
                                break;

                            case FileType.Document_Pdf:
                                ProcessPdfFile(null, filePath, resultset, fileStorage);
                                break;

                            case FileType.RTF:
                                bool converted = false;
                                converted = ProcessLibreFile(null, filePath, resultset, fileStorage, FileType.RTF);
                                break;

                            case FileType.TXT:
                                bool convertedt = false;
                                convertedt = ProcessLibreFile(null, filePath, resultset, fileStorage, FileType.TXT);
                                break;

                            case FileType.Document_CDA:
                                ProcessCDAFile(null, filePath, resultset, fileStorage);
                                break;

                            default:
                                if (_Logger.IsDebugEnabled)
                                    _Logger.Debug("Parsing File type, File type unknown.", "File Type", fileType.ToString());
                                break;
                        }
                    }
                    catch (Exception ex)
                    {
                        _Logger.Error("Error processing file.", "FilePath", filePath, "Exception", ex.ToString());
                        // failed to convert uploaded file into image. reset result set
                        resultset.Clear();
                    }
                }
            }

            return resultset;
        }

        public static ImageProcessResultset ProcessImage(Stream stream, string filePath, Hydra.Common.FileType fileType, string targetFolder, IFileStorage fileStorage, IStudyBuilder studyBuilder)
        {
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Processing image from stream.", "FilePath", filePath);

            ImageProcessResultset resultset = new ImageProcessResultset(Path.GetFileNameWithoutExtension(filePath), targetFolder);

            if (fileStorage == null)
                fileStorage = new DefaultFileStorage();

            var streamWrapper = new StreamWrapper(stream);
            Func<Stream> streamDelegate = delegate () { return streamWrapper; };

            DicomFile dicomFile = null;

            if ((fileType == FileType.Unknown) ||
                (fileType == FileType.Dicom))
            {
                dicomFile = LoadDicomFile(DicomStreamOpener.Create(streamDelegate));
                if (dicomFile == null)
                {
                    ProcessTargaImage(stream, filePath, resultset, fileStorage);
                }
            }

            if (dicomFile != null)
            {
                ProcessDicomImage(dicomFile, stream, filePath, resultset, fileStorage, studyBuilder);
            }
            else
            {
                if (fileType != FileType.Dicom)
                {
                    try
                    {
                        stream.Seek(0, SeekOrigin.Begin);
                        switch (fileType)
                        {
                            case FileType.Audio_Wav:

                                ProcessAudioFile(stream, filePath, resultset, fileStorage);
                                break;

                            case FileType.Video_Avi:
                            case FileType.Video_Mp4:

                                ProcessVideoFile(stream, filePath, fileType, resultset, fileStorage);
                                break;

                            case FileType.Image:
                            case FileType.Unknown:
                                ProcessGeneralImage(stream, resultset, fileStorage);
                                break;

                            case FileType.Document_Pdf:
                                ProcessPdfFile(stream, filePath, resultset, fileStorage);
                                break;

                            case FileType.RTF:
                                bool converted = false;
                                converted = ProcessLibreFile(stream, filePath, resultset, fileStorage, FileType.RTF);
                                break;

                            case FileType.TXT:
                                bool convertedt = false;
                                convertedt = ProcessLibreFile(stream, filePath, resultset, fileStorage, FileType.TXT);
                                break;

                            case FileType.Document_CDA:
                                ProcessCDAFile(stream, filePath, resultset, fileStorage);
                                break;

                            default:
                                if (_Logger.IsDebugEnabled)
                                    _Logger.Debug("Parsing File type, File type unknown.", "File Type", fileType.ToString());
                                resultset.Clear();
                                break;
                        }
                    }
                    catch (Exception ex)
                    {
                        _Logger.Error("Error processing stream.", "FilePath", filePath, "Exception", ex.ToString());
                        // failed to convert uploaded file into image. reset result set
                        resultset.Clear();
                    }
                }
            }

            streamWrapper.CloseForReal();

            return resultset;
        }

        private static bool IsVideoFile(string filePath)
        {
            string extension = Path.GetExtension(filePath).ToLower();

            return ".avi.mp4.h264.h265.webm.mkv.mov.m4v".Contains(extension);
        }

        private static bool IsAudioFile(string filePath)
        {
            string extension = Path.GetExtension(filePath).ToLower();

            return ".mp3.wav".Contains(extension);
        }

        private static void ProcessVideoFile(Stream stream, string filePath, FileType fileType, ImageProcessResultset resultSet, IFileStorage fileStorage)
        {
            // create generic abstract
            ImagePart imagePart = resultSet.AddAbstract();
            fileStorage.WriteBitmap(imagePart.FilePath, Resource.video, System.Drawing.Imaging.ImageFormat.Jpeg);

            try
            {
                string videoFilePath;
                if (stream != null)
                {
                    // copy image to temp folder
                    videoFilePath = Path.Combine(ImageProcessor.TempFolder, Path.GetFileName(filePath));
                    using (var fileStream = File.OpenWrite(videoFilePath))
                    {
                        stream.CopyTo(fileStream);
                    }
                }
                else // unencrypted
                {
                    videoFilePath = filePath;
                }

                if (fileType == FileType.Video_Mp4)
                {
                    // copy file as mp4
                    imagePart = resultSet.AddMp4();
                    File.Copy(videoFilePath, imagePart.FilePath, true);

                    // convert to avi
                    imagePart = resultSet.AddAvi();
                    using (var outputStream = fileStorage.CreateStream(imagePart.FilePath))
                    {
                        VideoProcessor.ConvertAvi(videoFilePath, outputStream);
                    }
                }
                else if (fileType == FileType.Video_Avi)
                {
                    // copy file as avi
                    imagePart = resultSet.AddAvi();
                    File.Copy(videoFilePath, imagePart.FilePath, true);

                    // convert to mp4
                    imagePart = resultSet.AddMp4();
                    using (var outputStream = fileStorage.CreateStream(imagePart.FilePath))
                    {
                        VideoProcessor.ConvertMp4(videoFilePath, outputStream);
                    }

                    // for now turn off webm support. Files in vix cache do nto have extensions which
                    // are causing errors.
                    //imagePart = resultSet.AddWebM();
                    //using (var outputStream = fileStorage.CreateStream(imagePart.FilePath))
                    //{
                    //    VideoProcessor.ConvertWebM(videoFilePath, outputStream);
                    //}
                }
                else // neither avi nor mp4
                {
                    // convert to mp4
                    imagePart = resultSet.AddMp4();
                    using (var outputStream = fileStorage.CreateStream(imagePart.FilePath))
                    {
                        VideoProcessor.ConvertMp4(videoFilePath, outputStream);
                    }

                    // convert to avi
                    imagePart = resultSet.AddAvi();
                    using (var outputStream = fileStorage.CreateStream(imagePart.FilePath))
                    {
                        VideoProcessor.ConvertAvi(videoFilePath, outputStream);
                    }

                    // for now turn off webm support. Files in vix cache do nto have extensions which
                    // are causing errors.
                    //imagePart = resultSet.AddWebM();
                    //using (var outputStream = fileStorage.CreateStream(imagePart.FilePath))
                    //{
                    //    VideoProcessor.ConvertWebM(videoFilePath, outputStream);
                    //}
                }

                resultSet.ImageType = ImageType.Video;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error processing video file.", "FilePath", filePath, "Exception", ex.ToString());
            }
        }

        private static void ProcessAudioFile(Stream stream, string filePath, ImageProcessResultset resultSet, IFileStorage fileStorage)
        {
            try
            {
                // create generic abstract
                ImagePart imagePart = resultSet.AddAbstract();
                fileStorage.WriteBitmap(imagePart.FilePath, Resource.audio, System.Drawing.Imaging.ImageFormat.Jpeg);

                // convert to mp3
                imagePart = resultSet.AddAudio();
                using (var outputStream = fileStorage.CreateStream(imagePart.FilePath))
                {
                    AudioProcessor.ProcessAudio(filePath, stream, outputStream);
                }

                resultSet.ImageType = ImageType.Audio;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error processing audio file.", "FilePath", filePath, "Exception", ex.Message);
            }
            finally
            {
            }
        }

        //private static System.Drawing.Bitmap CreateVideoAbstract(string filePath, Stream stream)
        //{
        //    return VideoThumbnailExtractor.GetThumbnail(stream, filePath, 1);
        //}

        private static void ProcessGeneralImage(object source, ImageProcessResultset resultset, IFileStorage fileStorage = null)
        {
            //VAI-107 Enhancement for multi-page TIFF files 1/7/2020
            if (source is string)
            {
                //VAI-250 Added logging
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Calling ProcessGeneralImageFile", "source", source);
                ProcessGeneralImageFile(source, resultset, fileStorage);
                return;
            }

            //VAI-250 Added logging
            if (_Logger.IsDebugEnabled)
                _Logger.Debug("Reading memory stream");

            ImagePart imagePart = null;

            using (var memoryStream = new MemoryStream())
            {
                // create image in memory
                var settings = new ImageResizer.ResizeSettings
                {
                    Mode = ImageResizer.FitMode.Stretch
                };
                ImageResizer.ImageBuilder.Current.Build(source, memoryStream, settings, false);

                // create abstract
                imagePart = resultset.AddAbstract();
                using (var stream = fileStorage.CreateStream(imagePart.FilePath))
                {
                    settings = new ImageResizer.ResizeSettings
                    {
                        MaxWidth = ThumbnailWidth,
                        MaxHeight = ThumbnailHeight,
                        Format = "JPG",
                        Mode = ImageResizer.FitMode.Stretch
                    };

                    memoryStream.Seek(0, SeekOrigin.Begin);
                    ImageResizer.ImageBuilder.Current.Build(memoryStream, stream, settings, false);
                }

                // try processing as tiff
                if (!ProcessTiffImage(source, resultset, fileStorage))
                {
                    // process as jpeg
                    imagePart = resultset.AddFrame(ImagePartTransform.Jpeg, 0);
                    using (var stream = fileStorage.CreateStream(imagePart.FilePath))
                    {
                        memoryStream.Seek(0, SeekOrigin.Begin);
                        memoryStream.CopyTo(stream);
                    }

                    // create imageinfo
                    var imageInfo = new ImageInfo
                    {
                        ImageType = ImageType.Jpeg.AsString(),
                        NumberOfFrames = 1,
                        PatientName = "NO NAME",
                    };

                    imagePart = resultset.AddImageInfo();
                    fileStorage.WriteAllText(imagePart.FilePath, JsonUtil.Serialize(imageInfo));

                    resultset.Image = new Image
                    {
                        ImageType = ImageType.Jpeg.AsString()
                    };

                    resultset.ImageType = ImageType.Jpeg;
                }
            }
        }

        //VAI-107 Enhancement for multi-page TIFF files 1/7/2020
        private static void ProcessGeneralImageFile(object source, ImageProcessResultset resultset, IFileStorage fileStorage = null)
        {
            ImagePart imagePart = null;

            using (var fs = new FileStream(source.ToString(), FileMode.Open, FileAccess.Read))
            {
      
                // create abstract
                imagePart = resultset.AddAbstract();
                using (var stream = fileStorage.CreateStream(imagePart.FilePath))
                {
                    var settings = new ImageResizer.ResizeSettings
                    {
                        MaxWidth = ThumbnailWidth,
                        MaxHeight = ThumbnailHeight,
                        Format = "JPG",
                        Mode = ImageResizer.FitMode.Stretch
                    };

                    fs.Seek(0, SeekOrigin.Begin);               
                    using (var img = System.Drawing.Image.FromStream(fs))
                    {
                        ImageResizer.ImageBuilder.Current.Build(img, stream, settings, false);
                    }
                }

                // try processing as tiff
                if (!ProcessTiffImage(source, resultset, fileStorage))
                {
                    // was not tiff, process as jpeg
                    resultset.ImageType = ImageType.Jpeg;//VAI-307
                    imagePart = resultset.AddFrame(ImagePartTransform.Jpeg, 0);
                    using (var stream = fileStorage.CreateStream(imagePart.FilePath))
                    {
                        fs.Seek(0, SeekOrigin.Begin);
                        fs.CopyTo(stream);
                    }

                    // create imageinfo
                    var imageInfo = new ImageInfo
                    {
                        ImageType = ImageType.Jpeg.AsString(),
                        NumberOfFrames = 1,
                        PatientName = "NO NAME",
                    };

                    imagePart = resultset.AddImageInfo();
                    fileStorage.WriteAllText(imagePart.FilePath, JsonUtil.Serialize(imageInfo));

                    resultset.Image = new Image
                    {
                        ImageType = ImageType.Jpeg.AsString()
                    };

                    resultset.ImageType = ImageType.Jpeg;
                }
            }
        }
        private static int GetTiffImagePageCount(object source)
        {
            var result = -1;

            try
            {
                if (source is string)
                {
                    using (var fs = File.OpenRead(source as string))
                    {
                        result = TiffProcessor.GetPageCount(fs);
                    }
                }
                else if (source is Stream)
                {
                    result = TiffProcessor.GetPageCount(source as Stream);
                }
            }
            catch (Exception ex)
            {
                var swallow = ex.Message;
            }

            return result;
        }
        /// <summary>
        /// Converts selected source Tiff image to individual image files for display.
        /// </summary>
        /// <returns>true / false (VAI-307)</returns>
        private static bool ProcessTiffImage(object source, ImageProcessResultset resultSet, IFileStorage fileStorage)
        {
            int initialLoadCount = 10; //Number of pages for the initial load
            ConversionResult result = null;
            if (_Logger.IsDebugEnabled)
            {
                if (source is string) _Logger.Debug("ProcessTiffImage", "source", source);
                else  _Logger.Debug("ProcessTiffImage", "source","stream");
            }

            int tiffPages = GetTiffImagePageCount(source);
            if (tiffPages < initialLoadCount) initialLoadCount = tiffPages;
            try
            {
                if (source is string)
                {
                    using (var fs = File.OpenRead(source as string))
                    {
                        result = TiffProcessor.ConvertToJpeg(0, initialLoadCount, fs);// only do initial view pages
                    }
                }
                else if (source is Stream)
                {
                    result = TiffProcessor.ConvertToJpeg(0, TiffProcessor.AllPages, source as Stream);// do all the pages
                }
                else
                    throw new ArgumentException("Invalid input type.");

                if (result == null)
                    return false;

                result.CreateImageParts(resultSet, fileStorage);
                resultSet.ImageType = ImageType.Tiff;

                if (source is string)
                {
                    var fileNames = new List<string>();
                    for (var activeResult = 0; activeResult < resultSet.ImageParts.Count; activeResult++)
                    {
                        if (!resultSet.ImageParts[activeResult].FilePath.Contains("_ABS.jpeg") && resultSet.ImageParts[activeResult].FilePath.Contains(".jpeg") && (resultSet.ImageParts[activeResult] != null))
                        {
                            fileNames.Add(resultSet.ImageParts[activeResult].FilePath);
                        }
                    }

                    if (tiffPages > initialLoadCount)
                    {
                        float availableMemory = 0.0F;
                        try
                        {
                            GC.Collect();
                            availableMemory = new Microsoft.VisualBasic.Devices.ComputerInfo().AvailablePhysicalMemory / 1000000;//faster than PerformanceCounter
                        }
                        catch (Exception)
                        {
                            availableMemory = 0.0F;
                        }
                        int Jobs = 1;
                        if(availableMemory>8000) 
                            Jobs=Convert.ToInt32(availableMemory) / 4000;
                        if (Jobs < 1) Jobs = 1;
                        else if (Jobs > 4) Jobs = 4;
                        int batchSize = tiffPages / Jobs;
                        batchSize = (tiffPages - initialLoadCount) / Jobs - 1;

                        for (int i = 0; i < Jobs; i++)
                        {
                            int firstPage = initialLoadCount + (i * batchSize);
                            int lastPage = firstPage + batchSize -1;
                            if (i == Jobs - 1)
                                lastPage = tiffPages;
                            Task.Factory.StartNew(() => TiffProcessor.SaveImageFileList(firstPage, lastPage, source as string, fileNames));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                string displayMessage = "Error Processing Tiff Image";
                _Logger.Error("ProcessTiffImage  failed.", displayMessage, " Exception", ex.ToString());
                return false;
            }
            finally
            {
                if (source is Stream)
                    (source as Stream).Seek(0, SeekOrigin.Begin);

                if (result != null)
                    result.Dispose();
            }

            return true;
        }

        /// <summary>
        /// Convert an RTF or TXT file to PDF.
        /// </summary>
        /// <param name="stream"></param>
        /// <param name="filePath">The file *name* of the original (.org) file</param>
        /// <param name="resultSet"></param>
        /// <param name="fileStorage"></param>
        /// <returns>Introduced in P269 for VAI-267 / INC11419682</returns>
        public static bool ProcessLibreFile(Stream stream, string filePath, ImageProcessResultset resultSet, IFileStorage fileStorage, FileType FType)
        {
            string inDir = Path.Combine(ImageProcessor.TempFolder, "rtfIn");
            string outDir = Path.Combine(ImageProcessor.TempFolder, "rtfOut");
            //Create temp in file name
            string InPath = Path.Combine(inDir, Path.GetFileName(filePath));
            //Create temp out file name
            string OutPath = Path.Combine(outDir, Path.GetFileName(filePath).Replace(".org", ".pdf"));
            OutPath = OutPath.Replace(".rtf", ".pdf"); //MockService
            OutPath = OutPath.Replace(".txt", ".pdf"); //MockService
            OutPath = OutPath.Replace("%2frtf", ".pdf"); //VixCache
            OutPath = OutPath.Replace("%2fx", ".pdf"); //VixCache

            try
            {
                if (!Directory.Exists(inDir))
                {
                    Directory.CreateDirectory(inDir);
                }
                if (!Directory.Exists(outDir))
                {
                    Directory.CreateDirectory(outDir);
                }

                // create thumbnail
                ImagePart imagePart = resultSet.AddAbstract();
                System.Drawing.Bitmap resource = (FType == FileType.RTF) ? Resource.rtf : Resource.txt; //VAI-267, VAI-579, and VAI-996
                fileStorage.WriteBitmap(imagePart.FilePath, resource, System.Drawing.Imaging.ImageFormat.Jpeg);

                //Cleanup conversion area - before processing
                if (File.Exists(InPath))
                {
                    File.Delete(InPath);
                }
                if (File.Exists(OutPath))
                {
                    File.Delete(OutPath);
                }

                // copy input file to conversion directory / temp folder
                if (stream != null)
                {
                    using (var fileStream = File.OpenWrite(InPath))
                    {
                        stream.CopyTo(fileStream);
                    }
                }
                else
                {
                    File.Copy(filePath, InPath);
                }

                int ms = Globals.Config.ExternalProcessTimeoutMillisecondsSized(filePath);
                //VAI-903: Re-use generic method
                string stdout = ProcessUtil.RunExternalProcess("", @"C:\Program Files\LibreOffice\program\soffice.exe", "--headless --nofirststartwizard --convert-to pdf " + InPath + " --outdir " + outDir, out string stderr, ms);
                if (!string.IsNullOrEmpty(stderr))
                {
                    _Logger.Error("LibreOffice failed.", "stderr", stderr);
                     return false;
                }

                // use original image to create copy
                imagePart = resultSet.AddFrame(ImagePartTransform.Pdf);

                using (var outputStream = fileStorage.CreateStream(imagePart.FilePath))
                {
                    using (var fileStream = File.Open(OutPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                    {
                        fileStream.CopyTo(outputStream);
                    }
                }

                resultSet.ImageType = ImageType.Pdf;

                //Cleanup conversion area - after processing
                if (File.Exists(InPath))
                {
                    File.Delete(InPath);
                }
                if (File.Exists(OutPath))
                {
                    File.Delete(OutPath);
                }
            }
            catch (Exception e)
            {
                _Logger.Error("Error processing LibreOffice.", "InPath", InPath, "OutPath", OutPath, "Exception", e.ToString());
                return false;
            }

            return true;
        }

        private static void ProcessPdfFile(Stream stream, string filePath, ImageProcessResultset resultSet, IFileStorage fileStorage)
        {
            try
            {
                // create generic abstract
                ImagePart imagePart = resultSet.AddAbstract();
                fileStorage.WriteBitmap(imagePart.FilePath, Resource.pdf, System.Drawing.Imaging.ImageFormat.Jpeg);

                string pdfFilePath = null;
                if (stream != null)
                {
                    // copy image to temp folder
                    pdfFilePath = Path.Combine(ImageProcessor.TempFolder, Path.GetFileName(filePath));
                    using (var fileStream = File.OpenWrite(pdfFilePath))
                    {
                        stream.CopyTo(fileStream);
                    }
                }
                else // unencrypted
                {
                    pdfFilePath = filePath;
                }

                // use original image to create copy
                imagePart = resultSet.AddFrame(ImagePartTransform.Pdf);

                if (!string.IsNullOrEmpty(pdfFilePath))
                {
                    using (var outputStream = fileStorage.CreateStream(imagePart.FilePath))
                    {
                        using (var fileStream = File.Open(pdfFilePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                        {
                            fileStream.CopyTo(outputStream);
                        }
                    }
                }
                else
                {
                    throw new NotImplementedException();
                }


                resultSet.ImageType = ImageType.Pdf;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error processing pdf file.", "FilePath", filePath, "Exception", ex.Message);
            }
            finally
            {
            }
        }

        private static void ProcessCDAFile(Stream stream, string filePath, ImageProcessResultset resultSet, IFileStorage fileStorage)
        {
            try
            {
                // create generic abstract
                ImagePart imagePart = resultSet.AddAbstract();
                fileStorage.WriteBitmap(imagePart.FilePath, Resource.xml, System.Drawing.Imaging.ImageFormat.Jpeg);

                string cdaFilePath = null;
                if (stream != null)
                {
                    // copy image to temp folder
                    cdaFilePath = Path.Combine(ImageProcessor.TempFolder, Path.GetFileName(filePath));
                    using (var fileStream = File.OpenWrite(cdaFilePath))
                    {
                        stream.CopyTo(fileStream);
                    }
                }
                else // unencrypted
                {
                    cdaFilePath = filePath;
                }

                // imageinfo is needed as SR uses it.
                var imageInfo = new ImageInfo
                {
                    ImageType = ImageType.CDA.AsString(),
                    NumberOfFrames = 1,
                    Modality = "CDA"
                };
                imagePart = resultSet.AddImageInfo();
                fileStorage.WriteAllText(imagePart.FilePath, JsonUtil.Serialize(imageInfo));

                resultSet.ImageType = ImageType.CDA;

                // use original image to create copy
                imagePart = resultSet.AddFrame(ImagePartTransform.Html);

                if (!string.IsNullOrEmpty(cdaFilePath))
                {
                    using (var outputStream = fileStorage.CreateStream(imagePart.FilePath))
                    {
                        XmlProcessor.ConvertToHtml(cdaFilePath, ImageProcessor.XslFolder, outputStream);
                    }
                }
                else
                {
                    throw new NotImplementedException();
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error processing pdf file.", "FilePath", filePath, "Exception", ex.Message);
            }
            finally
            {
            }
        }

        private static void ProcessTargaImage(Stream stream, string filePath, ImageProcessResultset resultSet, IFileStorage fileStorage)
        {
            try
            {
                if (stream != null)
                {
                    using (var fileStream = File.OpenWrite(filePath))
                    {
                        stream.CopyTo(fileStream);
                    }
                }

                using (TargaImage targaImage = new TargaImage(filePath))
                {
                    if (targaImage != null)
                    {
                        ImagePart imagePart = null;
                        // save abstract jpeg
                        imagePart = resultSet.AddAbstract();
                        var settings = new ImageResizer.ResizeSettings
                        {
                            MaxWidth = ThumbnailWidth,
                            MaxHeight = ThumbnailHeight,
                            Format = "JPG",
                            Mode = ImageResizer.FitMode.Stretch
                        };
                        System.Drawing.Bitmap targabmpImage = new System.Drawing.Bitmap(targaImage.Image);
                        ImageResizer.ImageBuilder.Current.Build(targabmpImage, imagePart.FilePath, settings);

                        // save jpeg frame
                        using (MemoryStream memoryStream = new MemoryStream())
                        {
                            targabmpImage = new System.Drawing.Bitmap(targaImage.Image);
                            imagePart = resultSet.AddFrame(ImagePartTransform.Jpeg, 0);
                            targabmpImage.Save(memoryStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                            using (var jpegStream = fileStorage.CreateStream(imagePart.FilePath))
                            {
                                memoryStream.Seek(0, SeekOrigin.Begin);
                                memoryStream.CopyTo(jpegStream);
                            }
                        }

                        // create imageinfo
                        var imageInfo = new ImageInfo
                        {
                            ImageType = ImageType.Jpeg.AsString(),
                            NumberOfFrames = 1,
                            PatientName = "NO NAME",
                        };

                        imagePart = resultSet.AddImageInfo();
                        fileStorage.WriteAllText(imagePart.FilePath, JsonUtil.Serialize(imageInfo));

                        resultSet.Image = new Image
                        {
                            ImageType = ImageType.Jpeg.AsString()
                        };

                        resultSet.ImageType = ImageType.Jpeg;
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error processing targa file.", "FilePath", filePath, "Exception", ex.ToString());
            }
        }

        private static DicomFile LoadDicomFile(string filePath)
        {
            DicomFile file = null;

            try
            {
                file = new DicomFile(filePath);
                file.Load(DicomReadOptions.StorePixelDataReferences);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error loading dicom file.", "FilePath", filePath, "Exception", ex.ToString());
                file = null;
            }

            return file;
        }

        private static DicomFile LoadDicomFile(Stream stream)
        {
            DicomFile file = null;

            try
            {
                file = new DicomFile();
                file.Load(stream, null, DicomReadOptions.StorePixelDataReferences);
            }
            catch (Exception)
            {
                file = null;
            }

            return file;
        }

        private static DicomFile LoadDicomFile(DicomStreamOpener streamOpener)
        {
            DicomFile file = null;

            try
            {
                file = new DicomFile();
                file.Load(streamOpener, null, DicomReadOptions.StorePixelDataReferences);
            }
            catch (Exception)
            {
                file = null;
            }

            return file;
        }

        private static List<Hydra.Entities.DicomTag> GetHeader(DicomFile dicomFile)
        {
            if (dicomFile.DataSet == null)
                return null;

            List<Hydra.Entities.DicomTag> tags = new List<Hydra.Entities.DicomTag>();
            foreach (DicomAttribute item in dicomFile.DataSet)
            {
                // ignore private
                if (item.Tag.IsPrivate)
                    continue;

                //these tags are not usually stored in the xml or json.
                var isBinary = item.Tag.VR == DicomVr.OBvr || item.Tag.VR == DicomVr.OWvr || item.Tag.VR == DicomVr.OFvr;
                string tagValue = (isBinary || item.Tag.VR == DicomVr.UNvr) ?
                                        "[...]" : item.ToString();

                tags.Add(new Hydra.Entities.DicomTag
                {
                    Tag = string.Format("({0:x4},{1:x4})", item.Tag.Group, item.Tag.Element),
                    TagDescription = item.Tag.Name,
                    VrType = item.Tag.VR.Name,
                    TagValue = tagValue
                });
            }

            return tags;
        }

        public static List<Hydra.Entities.DicomTag> GetHeader(Stream stream)
        {
            var streamWrapper = new StreamWrapper(stream);
            Func<Stream> streamDelegate = delegate () { return streamWrapper; };
            DicomFile dicomFile = LoadDicomFile(DicomStreamOpener.Create(streamDelegate));
            if (dicomFile == null)
                return null;

            return GetHeader(dicomFile);
        }

        public static List<Hydra.Entities.DicomTag> GetHeader(string filePath)
        {
            DicomFile dicomFile = LoadDicomFile(filePath);
            if (dicomFile == null)
                return null;

            return GetHeader(dicomFile);
        }

        //VAI-358 YBR_FULL DICOM
        /// <summary>
        /// Copies 24BPP bitmap data to array and returns number of bytes copied
        /// </summary>
        /// <param name="sourceBitmap"></param>
        /// <param name="destBytes"></param>
        ///  
        /// <returns></returns>
        private static int bitmapToArray(System.Drawing.Bitmap sourceBitmap, Byte[] destBytes)
        {
            int idx = 0;
            try
            {
                for (int i = 0; i < destBytes.Length; i++)
                    destBytes[i] = 0x00;
                if (sourceBitmap.PixelFormat != PixelFormat.Format24bppRgb)
                {
                    _Logger.Error("ERROR bitmapToArray() requires a 24bppRgb Bitmap. Bitmap is " + sourceBitmap.PixelFormat.ToString());
                    return (0);
                }

                      for (int row = 0; row < sourceBitmap.Height; row++)
                {
                    for (int col = 0; col < sourceBitmap.Width; col++)
                    {
                        System.Drawing.Color c = sourceBitmap.GetPixel(col,row );
                        destBytes[idx++] = c.R;
                        destBytes[idx++] = c.G;
                        destBytes[idx++] = c.B;
                    }
                }
     
            }
            catch (Exception ex)
            {
                _Logger.Error("ERROR bitmapToArray() exception " + ex.Message );
                return (0);
            }
            return (idx);
        }
        private static void ProcessDicomImage(DicomFile dicomFile, Stream dicomStream, string filePath, ImageProcessResultset resultset, IFileStorage fileStorage, IStudyBuilder studyBuilder)
        {
            ImagePart imagePart = null;
            Overlay[] overlays = null;

            // read pixel data
            int frameSize = 0;
            DicomPixelData pd = DicomPixelData.CreateFrom(dicomFile);
            if (pd is DicomCompressedPixelData)
            {
                IDicomCodec codec = DicomCodecRegistry.GetCodec(pd.TransferSyntax);
                if (codec == null)
                {
                    throw new DicomCodecException("No registered codec for: " + pd.TransferSyntax.Name);
                }

                DicomUncompressedPixelData upd = new DicomUncompressedPixelData(pd as DicomCompressedPixelData);
                DicomCodecParameters parameters = DicomCodecRegistry.GetCodecParameters(pd.TransferSyntax, null);
                codec.Decode(pd as DicomCompressedPixelData, upd, parameters);
                if (upd == null || upd.NumberOfFrames == 0)
                {
                    throw new DicomCodecException("Failed to decode for: " + pd.TransferSyntax.Name);
                }

                pd = upd;
            }

            if (pd is DicomUncompressedPixelData)
            {
                // convert palette color to rgb if necessary
                DicomUncompressedPixelData upd = pd as DicomUncompressedPixelData;
                if (upd.HasPaletteColorLut)
                    upd.ConvertPaletteColorToRgb();
            }

            if (Utility.IsPdf(dicomFile))
            {
                resultset.ImageType = ImageType.RadPdf;
                imagePart = resultset.AddFrame(ImagePartTransform.Pdf);

                var pdfIOD = new EncapsulatedPdfIod(dicomFile.DataSet);
                byte[] frame = pdfIOD.EncapsulatedDocument.EncapsulatedDocument;
                fileStorage.WriteAllBytes(imagePart.FilePath, frame);

                imagePart = resultset.AddAbstract();
                fileStorage.WriteBitmap(imagePart.FilePath, Resource.pdf, System.Drawing.Imaging.ImageFormat.Jpeg);
            }
            else if (Utility.IsECG(dicomFile))
            {
                resultset.ImageType = ImageType.RadECG;

                ExportOptions exportOptions = new ExportOptions
                {
                    SignalGain = SignalGain.Ten,
                    DrawType = DrawType.ThreeXFourPlusThree,
                    GridType = GridType.OneMillimeters,
                    ImageWidth = 1200,
                    ImageHeight = 900,
                    GenerateHeader = true,
                    GenerateImage = true,
                    GridColor = GridColor.Red,
                    SignalThickness = SignalThickness.One,
                    IsWaterMarkRequired = string.IsNullOrEmpty(dicomFile.DataSet[DicomTags.NameOfPhysiciansReadingStudy].ToString())
                };

                ECGInfo ecgInfo = null;
                System.Drawing.Bitmap bitmap = null;
                if (dicomStream != null)
                {
                    using (var tempStream = new MemoryStream())
                    {
                        // copy stream without losing position
                        var pos = dicomStream.Position;
                        dicomStream.Position = 0;
                        dicomStream.CopyTo(tempStream);
                        tempStream.Seek(0, SeekOrigin.Begin);
                        dicomStream.Position = pos;

                        bitmap = ECGExporter.ToBitmap(dicomStream, "DICOM", exportOptions, out ecgInfo);
                    }
                }
                else
                    bitmap = ECGExporter.ToBitmap(filePath, "DICOM", exportOptions, out ecgInfo);
                if (bitmap == null)
                    throw new Exception("Failed to convert ECG to bitmap");
                if (ecgInfo == null)
                    throw new Exception("Failed to write ECG info");

                imagePart = resultset.AddWaveform(ImagePartTransform.Png);
                // waveform png is generated based on ecg request. use original as image part
                // For now, assume the original file is encrypted if dicomStream is not null
                fileStorage.CopyFile(imagePart.FilePath, filePath, (dicomStream != null));

                imagePart = resultset.AddWaveform(ImagePartTransform.Json);
                fileStorage.WriteAllText(imagePart.FilePath, JsonUtil.Serialize(ecgInfo));

                imagePart = resultset.AddAbstract();
                fileStorage.WriteBitmap(imagePart.FilePath, Resource.ecg, System.Drawing.Imaging.ImageFormat.Jpeg);
            }
            else if (Utility.IsSR(dicomFile))
            {
                resultset.ImageType = ImageType.RadSR;
                imagePart = resultset.AddFrame(ImagePartTransform.Html);

                SRDocument doc = new SRDocument(dicomFile);
                using (var outputStream = fileStorage.CreateStream(imagePart.FilePath))
                {
                    string content = doc.WriteHTML();
                    StreamWriter writer = new StreamWriter(outputStream);
                    writer.Write(content);
                    writer.Flush();
                }

                imagePart = resultset.AddAbstract();
                fileStorage.WriteBitmap(imagePart.FilePath, Resource.sr, System.Drawing.Imaging.ImageFormat.Jpeg);
            }
            else if (Utility.IsPR(dicomFile))
            {
                string text = PresentationStateReader.Read(dicomFile);
                if (!string.IsNullOrEmpty(text))
                {
                    resultset.ImageType = ImageType.RadPR;

                    imagePart = resultset.AddDicomPR();
                    fileStorage.WriteAllText(imagePart.FilePath, text);

                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Processing PR image.", "FilePath", imagePart.FilePath);
                }
                else
                {
                    _Logger.Error("Error processing PR image.");
                }

                /* Since these objects are not displayed in the thumbnail panel, no
                 * need to create abstracts for now */

                return; // nothing else to process
            }
            else
            {
                bool isUltrasoundMultiframe = (pd.NumberOfFrames > 1) && (dicomFile.DataSet[DicomTags.Modality].ToString() == "US");

                // save frames to file
                for (int i = 0; i < pd.NumberOfFrames; i++)
                {
                    byte[] frame = pd.GetFrame(i);

                    if (i == 0)
                        frameSize = frame.Length;

                    imagePart = resultset.AddFrame(ImagePartTransform.DicomData, i);

                    //VAI-358 YBR_FULL DICOM 24BPP
                    if (pd.PhotometricInterpretation.ToUpper() == "YBR_FULL" && pd.SamplesPerPixel == 3 && pd.BitsStored == 8)
                    {
                        using (LocalSopDataSource dicomDataSource = new LocalSopDataSource(dicomFile))
                        {
                            using (ImageSop imageSop = new ImageSop(dicomDataSource))
                            {
                                overlays = ProcessDicomOverlays(imageSop, resultset, fileStorage);
                                using (IPresentationImage presentationImage = PresentationImageFactory.Create(imageSop.Frames[i+1]))
                                {
                                    byte[] destBytes = new byte[frame.Length];
                                    System.Drawing.Bitmap bitmap = new System.Drawing.Bitmap(pd.ImageWidth, pd.ImageHeight, System.Drawing.Imaging.PixelFormat.Format24bppRgb);
                                    presentationImage.DrawToBitmap(bitmap);
                                    int byteCount = bitmapToArray(bitmap, destBytes);
                                    if (byteCount != frame.Length)
                                        _Logger.Error("Error in bitmapToArray, unexpected byte count:" + byteCount.ToString() + " expected:" + frame.Length.ToString() + " bytes");
                                    else frame = destBytes;
                                    bitmap.Dispose();
                                }
                            }
                        }
                    }
                    fileStorage.WriteAllBytes(imagePart.FilePath, ZLibCompressor.Compress(frame));

                    // create jpeg versions for US multiframes only
                    if (isUltrasoundMultiframe)
                    {
                        imagePart = resultset.AddFrame(ImagePartTransform.Jpeg, i);
                        using (var stream = fileStorage.CreateStream(imagePart.FilePath))
                        {
                            JpegWriter.SaveToStream(frame,
                                                    pd.ImageWidth, pd.ImageHeight,
                                                    pd.BitsAllocated, pd.SamplesPerPixel,
                                                    stream);
                        }
                    }
                }

                resultset.ImageType = isUltrasoundMultiframe ? ImageType.RadEcho : ImageType.Rad;

                using (LocalSopDataSource dicomDataSource = new LocalSopDataSource(dicomFile))
                {
                    using (ImageSop imageSop = new ImageSop(dicomDataSource))
                    {
                        // process dicom overlays
                        overlays = ProcessDicomOverlays(imageSop, resultset, fileStorage);

                        // generate thumbnail
                        using (IPresentationImage presentationImage = PresentationImageFactory.Create(imageSop.Frames[1]))
                        {
                            using (System.Drawing.Bitmap bitmap = presentationImage.DrawToBitmap(ThumbnailWidth, ThumbnailHeight))
                            {
                                var settings = new ImageResizer.ResizeSettings
                                {
                                    Format = "JPG",
                                    Mode = ImageResizer.FitMode.Stretch
                                };

                                imagePart = resultset.AddAbstract();
                                using (var stream = fileStorage.CreateStream(imagePart.FilePath))
                                {
                                    ImageResizer.ImageBuilder.Current.Build(bitmap, stream, settings);
                                }
                            }
                        }
                    }
                }

                //ProcessDicomOverlays(dicomFile, pd.NumberOfFrames, resultset);
            }

            // dump header
            List<Hydra.Entities.DicomTag> tags = GetHeader(dicomFile);
            if (tags != null)
            {
                resultset.DicomXml = JsonUtil.Serialize(tags);
                imagePart = resultset.AddJsonHeader();
                fileStorage.WriteAllText(imagePart.FilePath, resultset.DicomXml);
            }

            // create pixel data info file
            var imageInfo = new ImageInfo
            {
                ImageType = resultset.ImageType.AsString(),
                BitsAllocated = pd.BitsAllocated,
                BitsStored = pd.BitsStored,
                HighBit = pd.HighBit,
                SamplesPerPixel = pd.SamplesPerPixel,
                DecimalRescaleIntercept = pd.DecimalRescaleIntercept,
                DecimalRescaleSlope = pd.DecimalRescaleSlope,
                ImageHeight = pd.ImageHeight,
                ImageWidth = pd.ImageWidth,
                FrameSize = frameSize,
                NumberOfFrames = pd.NumberOfFrames,
                PhotometricInterpretation = pd.PhotometricInterpretation,
                PixelRepresentation = pd.PixelRepresentation,
                PlanarConfiguration = pd.PlanarConfiguration,
                IsPlanar = pd.IsPlanar,
                IsSigned = pd.IsSigned,
                IsColor = PhotometricInterpretation.FromCodeString(pd.PhotometricInterpretation).IsColor,
                MaxPixelValue = DicomPixelData.GetMaxPixelValue(pd.BitsStored, pd.IsSigned),
                MinPixelValue = DicomPixelData.GetMinPixelValue(pd.BitsStored, pd.IsSigned),

                PatientName = new PersonName(dicomFile.DataSet[DicomTags.PatientsName].ToString()).FormattedName,
                Manufacturer = dicomFile.DataSet[DicomTags.Manufacturer].ToString(),
                AccessionNumber = dicomFile.DataSet[DicomTags.AccessionNumber].ToString(),
                InstanceNumber = dicomFile.DataSet[DicomTags.InstanceNumber].ToString(),
                ContentDate = dicomFile.DataSet[DicomTags.ContentDate].ToString(),
                ContentTime = dicomFile.DataSet[DicomTags.ContentTime].ToString(),

                Overlays = overlays
            };

            // get window information
            if ((pd.LinearVoiLuts != null) && (pd.LinearVoiLuts.Count > 0))
            {
                imageInfo.WindowWidth = pd.LinearVoiLuts[0].Width;
                imageInfo.WindowCenter = pd.LinearVoiLuts[0].Center;
            }
            else
            {
                // default window/level
                if (!imageInfo.IsColor && resultset.ImageType == ImageType.Rad)
                {
                    GrayscalePixelData pixelData = new GrayscalePixelData(imageInfo.ImageWidth,
                                                                          imageInfo.ImageHeight,
                                                                          imageInfo.BitsAllocated,
                                                                          imageInfo.BitsStored,
                                                                          imageInfo.HighBit,
                                                                          imageInfo.IsSigned,
                                                                          pd.GetFrame(0));
                    if (pixelData != null)
                    {
                        int minPixelValue = 0;
                        int maxPixelValue = 0;
                        pixelData.CalculateMinMaxPixelValue(out minPixelValue, out maxPixelValue);
                        if (minPixelValue == 0 && maxPixelValue == 0)
                        {
                            minPixelValue = imageInfo.MinPixelValue;
                            maxPixelValue = imageInfo.MaxPixelValue;
                        }

                        imageInfo.MinPixelValue = minPixelValue;
                        imageInfo.MaxPixelValue = maxPixelValue;
                    }
                }

                imageInfo.WindowWidth = (int)(imageInfo.MaxPixelValue - imageInfo.MinPixelValue);
                imageInfo.WindowCenter = (int)(imageInfo.WindowWidth / 2.0);

                imageInfo.WindowWidth = (int)(imageInfo.WindowWidth * (double)imageInfo.DecimalRescaleSlope);
                imageInfo.WindowCenter = (int)((imageInfo.WindowCenter * (double)imageInfo.DecimalRescaleSlope) + (double)imageInfo.DecimalRescaleIntercept);
            }

            // get date and time
            DateTime studyDate;
            if (DateParser.Parse(dicomFile.DataSet[DicomTags.StudyDate].ToString(), out studyDate))
                imageInfo.StudyDate = studyDate.ToString("dd-MMM-yyyy");

            DateTime studyTime;
            if (TimeParser.Parse(dicomFile.DataSet[DicomTags.StudyTime].ToString(), out studyTime))
                imageInfo.StudyTime = studyTime.ToString("HH:mm");

            DateTime seriesTime;
            if (TimeParser.Parse(dicomFile.DataSet[DicomTags.SeriesTime].ToString(), out seriesTime))
                imageInfo.SeriesTime = seriesTime.ToString("HH:mm");

            // modality
            imageInfo.Modality = dicomFile.DataSet[DicomTags.Modality].ToString();

            // patient orientation
            imageInfo.DirectionalMarkers = GetDirectionalMarkers(dicomFile.DataSet);

            // measurement info
            imageInfo.Measurement = MeasurementReader.Read(dicomFile.DataSet, imageInfo.ImageWidth, imageInfo.ImageHeight);

            // cine rate
            imageInfo.CineRate = GetCineRate(dicomFile.DataSet);

            ReadAsGeneralImageModuleIod(dicomFile, imageInfo);

            // finally write imageinfo
            imagePart = resultset.AddImageInfo();
            fileStorage.WriteAllText(imagePart.FilePath, JsonUtil.Serialize(imageInfo));

            // create image object
            var image = new Image();
            image.DicomStudyId = dicomFile.DataSet[DicomTags.StudyId].ToString();
            image.SopInstanceUid = dicomFile.DataSet[DicomTags.SopInstanceUid].ToString();
            image.SeriesInstanceUid = dicomFile.DataSet[DicomTags.SeriesInstanceUid].ToString();
            image.StudyInstanceUid = dicomFile.DataSet[DicomTags.StudyInstanceUid].ToString();
            image.Description = dicomFile.DataSet[DicomTags.CodeMeaning].ToString();
            image.NumberOfFrames = pd.NumberOfFrames;
            image.FrameSize = frameSize;
            int instanceNumber = 0;
            int.TryParse(dicomFile.DataSet[DicomTags.InstanceNumber].ToString(), out instanceNumber);
            image.InstanceNumber = instanceNumber;
            int seriesNumber = 0;
            int.TryParse(dicomFile.DataSet[DicomTags.SeriesNumber].ToString(), out seriesNumber);
            image.SeriesNumber = seriesNumber;
            image.Modality = imageInfo.Modality;
            image.ImageType = Utility.GetImageType(dicomFile.DataSet[DicomTags.SopClassUid].ToString(), image.Modality, image.NumberOfFrames);
            image.ImagePlane = ImageProcessor.GetImagePlane(dicomFile);
            resultset.Image = image;

            // create image dicomdir record
            resultset.DicomDirXml = DicomDirBuilder.CreateDicomDirXml(dicomFile, image.SopInstanceUid);

            if (studyBuilder != null)
            {
                if (studyBuilder.CreateStudy(image.StudyInstanceUid))
                {
                    var study = new Entities.Study();
                    study.StudyUid = image.StudyInstanceUid;
                    study.DicomStudyId = image.DicomStudyId;
                    study.Procedure = dicomFile.DataSet[DicomTags.StudyDescription].ToString();
                    study.Modality = image.Modality;
                    study.StudyId = studyBuilder.StudyId;

                    DateTime dtStudyDate;
                    if (DateParser.Parse(dicomFile.DataSet[DicomTags.StudyDate].ToString(), out dtStudyDate))
                    {
                        DateTime dtStudyTime;
                        if (TimeParser.Parse(dicomFile.DataSet[DicomTags.StudyTime].ToString(), out dtStudyTime))
                        {
                            study.DateTime = string.Format("{0:0000}-{1:00}-{2:00}T{3:00}:{4:00}:{5:00}",
                                                           dtStudyDate.Year,
                                                           dtStudyDate.Month,
                                                           dtStudyDate.Day,
                                                           dtStudyTime.Hour, dtStudyTime.Minute, dtStudyTime.Second);
                        }
                    }

                    study.Patient = new Hydra.Entities.Patient();
                    study.Patient.ICN = dicomFile.DataSet[DicomTags.PatientId].ToString();
                    study.Patient.FullName = DicomDataFormatHelper.PersonNameFormatter(new PersonName(dicomFile.DataSet[DicomTags.PatientsName].ToString()));
                    study.Patient.dob = DicomDataFormatHelper.DateFormat(dicomFile.DataSet[DicomTags.PatientsBirthDate].ToString());
                    study.Patient.Sex = dicomFile.DataSet[DicomTags.PatientsSex].ToString();
                    study.Patient.Age = dicomFile.DataSet[DicomTags.PatientsAge].ToString();
                    study.DicomDirXml = DicomDirBuilder.CreateStudyDicomDirXml(dicomFile);
                    studyBuilder.UpdateStudy(study);

                    if (studyBuilder.CreatePatient(study.Patient.ICN))
                    {
                        study.Patient.DicomDirXml = DicomDirBuilder.CreatePatientDicomDirXml(dicomFile);
                        studyBuilder.UpdatePatient(study.Patient);
                    }
                }

                if (studyBuilder.CreateSeries(image.SeriesInstanceUid))
                {
                    var series = new Entities.Series();
                    series.SeriesInstanceUID = image.SeriesInstanceUid;
                    series.Modality = image.Modality;
                    series.SeriesNumber = image.SeriesNumber;
                    series.Description = dicomFile.DataSet[DicomTags.SeriesDescription].ToString();
                    series.DicomDirXml = DicomDirBuilder.CreateSeriesDicomDirXml(dicomFile);
                    series.StudyInstanceUID = image.StudyInstanceUid;
                    studyBuilder.UpdateSeries(series);
                }
            }

            if (Is3DEnabled)
            {
                imagePart = resultset.AddDicomHeader();

                // first create a copy of dicomfile sans pixel data, private and unknown tags
                var dicomHeaderFile = new DicomFile(imagePart.FilePath,
                                                    dicomFile.MetaInfo.Copy(),
                                                    dicomFile.DataSet.Copy(false, false, false));


                dicomHeaderFile.Save();
            }

            //VAI 788 - image type not supported contains PatientsName of Generated with MicroDicom viewer in C:\VixConfig\ImageTypeNotSupported.dcm
            string patientIDCheck = dicomFile.DataSet[DicomTags.PatientsName].ToString();
            if (patientIDCheck == "Generated with MicroDicom viewer")
            {
                resultset.NeedsUnsupportedTypeCleanUp = true;
                studyBuilder.SetBadSeriesId(image.SeriesInstanceUid);
            }
        }

        //private static void Process3DVolume(DicomFile dicomFile, DicomPixelData pd, int frame, string filePath, ImageProcessResultset resultset)
        //{
        //    var volumeFrame = new VolumeFrame();

        //    volumeFrame.SeriesInstanceUid = dicomFile.DataSet[DicomTags.SeriesInstanceUid].ToString();
        //    volumeFrame.StudyInstanceUid = dicomFile.DataSet[DicomTags.StudyInstanceUid].ToString();
        //    volumeFrame.Frame = frame;
        //    volumeFrame.FrameCount = pd.NumberOfFrames;
        //    volumeFrame.DimensionX = pd.ImageWidth;
        //    volumeFrame.DimensionY = pd.ImageHeight;
        //    volumeFrame.BitsPerPixel = pd.BitsAllocated;
        //    volumeFrame.HighBit = pd.HighBit;
        //    volumeFrame.RelevantBits = pd.BitsStored;
        //    volumeFrame.FilePath = filePath;
        //    volumeFrame.RescaleIntercept = (float) pd.DecimalRescaleIntercept;
        //    volumeFrame.RescaleSlope = (float) pd.DecimalRescaleSlope;
        //    volumeFrame.IsSigned = pd.IsSigned;
        //    //volumeFrame.SpacingX = 

        //    // get window information
        //    if ((pd.LinearVoiLuts != null) && (pd.LinearVoiLuts.Count > 0))
        //    {
        //        volumeFrame.WindowWidth = (float) pd.LinearVoiLuts[0].Width;
        //        volumeFrame.WindowCenter = (float) pd.LinearVoiLuts[0].Center;
        //    }
        //    else
        //    {
        //        // default window/level
        //        volumeFrame.WindowWidth = (int)(DicomPixelData.GetMaxPixelValue(pd.BitsStored, pd.IsSigned) - DicomPixelData.GetMinPixelValue(pd.BitsStored, pd.IsSigned));
        //        volumeFrame.WindowCenter = (int)(volumeFrame.WindowWidth / 2.0);

        //        volumeFrame.WindowWidth = (int)(volumeFrame.WindowWidth * (double)pd.DecimalRescaleSlope);
        //        volumeFrame.WindowCenter = (int)((volumeFrame.WindowWidth * (double)pd.DecimalRescaleSlope) + (double)pd.DecimalRescaleIntercept);
        //    }

        //}

        private static Overlay[] ProcessDicomOverlays(ImageSop imageSop, ImageProcessResultset resultset, IFileStorage fileStorage)
        {
            List<Overlay> overlayList = null;

            try
            {
                // todo: check if overlay groups are present
                foreach (var frame in imageSop.Frames)
                {
                    Dictionary<Overlay, string> overlayMap = null;

                    List<OverlayPlaneGraphic> overlayPlaneGraphics = DicomGraphicsFactory.CreateOverlayPlaneGraphics(frame);
                    foreach (OverlayPlaneGraphic overlayGraphic in overlayPlaneGraphics)
                    {
                        if ((overlayGraphic.Graphics == null) ||
                            (overlayGraphic.Graphics.Count < 1))
                            continue;

                        var grayscaleImageGraphic = overlayGraphic.Graphics[0] as GrayscaleImageGraphic;
                        if (grayscaleImageGraphic == null)
                            continue;

                        // Note: FrameNumber is 1 based, but is stored in database as 0 based.
                        var imagePart = resultset.AddOverlay(ImagePartTransform.DicomData, frame.FrameNumber - 1, overlayGraphic.Index);
                        using (var stream = fileStorage.CreateStream(imagePart.FilePath))
                        {
                            var pixelData = grayscaleImageGraphic.PixelData.Raw;
                            var compressedPixelData = ZLibCompressor.Compress(pixelData);
                            stream.Write(compressedPixelData, 0, compressedPixelData.Length);
                        }

                        if (overlayList == null)
                            overlayList = new List<Overlay>();

                        var overlay = new Overlay
                        {
                            OverlayIndex = overlayGraphic.Index,
                            FrameIndex = frame.FrameNumber - 1,
                            Columns = overlayGraphic.Columns,
                            Rows = overlayGraphic.Rows,
                            Label = overlayGraphic.Label,
                            Description = overlayGraphic.Description,
                            BitDepth = grayscaleImageGraphic.BitsStored
                        };
                        overlayList.Add(overlay);

                        // add to map for later processing
                        if (overlayMap == null)
                            overlayMap = new Dictionary<Overlay, string>();
                        overlayMap[overlay] = imagePart.FilePath;
                    }

                    // create a separate overlay by merging all overlays. This overlay does not contain an overlay index.
                    if (overlayMap != null)
                    {
                        if (overlayMap.Count == 1)
                        {
                            // only one overlay just create a new image part with the same file
                            // Todo: handle probable errors in deletion.
                            resultset.AddMergedOverlay(ImagePartTransform.DicomData, frame.FrameNumber - 1, overlayMap.Values.FirstOrDefault());
                        }
                        else
                        {
                            // Todo: until merging code is ready, use the first overlay
                            resultset.AddMergedOverlay(ImagePartTransform.DicomData, frame.FrameNumber - 1, overlayMap.Values.FirstOrDefault());
                        }
                    }
                }
            }
            catch (Exception)
            {
            }

            return (overlayList != null) ? overlayList.ToArray() : null;
        }

        private static double GetCineRate(DicomAttributeCollection dataSet)
        {
            double cineRate = 0.0;

            if (!dataSet[DicomTags.CineRate].TryGetFloat64(0, out cineRate))
            {
                dataSet[DicomTags.FrameDelay].TryGetFloat64(0, out cineRate);
                if (cineRate > 0.0)
                    cineRate = 1000.0 / cineRate;
                else
                {
                    dataSet[DicomTags.FrameTime].TryGetFloat64(0, out cineRate);
                    if (cineRate > 0.0)
                        cineRate = 1000.0 / cineRate;
                    else
                    {
                        dataSet[DicomTags.FrameTimeVector].TryGetFloat64(0, out cineRate);
                        if (cineRate > 0.0)
                            cineRate = 1000.0 / cineRate;
                    }
                }
            }

            return cineRate;
        }

        private static DirectionalMarkers GetDirectionalMarkers(DicomAttributeCollection dataSet)
        {
            var values = new double[6];
            if (dataSet[DicomTags.ImageOrientationPatient].TryGetFloat64(0, out values[0])
                && dataSet[DicomTags.ImageOrientationPatient].TryGetFloat64(1, out values[1])
                && dataSet[DicomTags.ImageOrientationPatient].TryGetFloat64(2, out values[2])
                && dataSet[DicomTags.ImageOrientationPatient].TryGetFloat64(3, out values[3])
                && dataSet[DicomTags.ImageOrientationPatient].TryGetFloat64(4, out values[4])
                && dataSet[DicomTags.ImageOrientationPatient].TryGetFloat64(5, out values[5]))
            {
                ImageOrientationPatient imageOrientationPatient = new ImageOrientationPatient(values[0], values[1], values[2], values[3], values[4], values[5]);

                // get patient orientation
                PatientOrientation patientOrientation = imageOrientationPatient.ToPatientOrientation();
                if (!patientOrientation.IsEmpty)
                {
                    return new DirectionalMarkers
                    {
                        Left = GetMarker(ImageEdge.Left, patientOrientation),
                        Right = GetMarker(ImageEdge.Right, patientOrientation),
                        Top = GetMarker(ImageEdge.Top, patientOrientation),
                        Bottom = GetMarker(ImageEdge.Bottom, patientOrientation)
                    };
                }
            }

            return null;
        }

        private static string GetMarker(ImageEdge imageEdge, PatientOrientation patientOrientation)
        {
            bool negativeDirection = (imageEdge == ImageEdge.Left || imageEdge == ImageEdge.Top);
            bool rowValues = (imageEdge == ImageEdge.Left || imageEdge == ImageEdge.Right);

            var direction = (rowValues ? patientOrientation.Row : patientOrientation.Column) ?? PatientDirection.Empty;
            if (negativeDirection)
                direction = direction.OpposingDirection;

            string markerText = "";
            markerText += GetMarkerText(direction.Primary);
            markerText += GetMarkerText(direction.Secondary);

            return markerText;
        }

        /// <summary>
        /// Converts an <see cref="PatientDirection"/> to a marker string.
        /// </summary>
        /// <param name="direction">the direction (patient based system)</param>
        /// <returns>marker text</returns>
        private static string GetMarkerText(PatientDirection direction)
        {
            // TODO (CR Mar 2012): Add a "short description" to PatientDirection class and return this from there.
            // Then we're not finding patient direction resources all over the place.

            if (direction == PatientDirection.QuadrupedLeft)
                return "Le";
            else if (direction == PatientDirection.QuadrupedRight)
                return "Rt";
            else if (direction == PatientDirection.QuadrupedCranial)
                return "Cr";
            else if (direction == PatientDirection.QuadrupedCaudal)
                return "Cd";
            else if (direction == PatientDirection.QuadrupedRostral)
                return "R";
            else if (direction == PatientDirection.QuadrupedDorsal)
                return "D";
            else if (direction == PatientDirection.QuadrupedVentral)
                return "V";
            else if (direction == PatientDirection.QuadrupedLateral)
                return "L";
            else if (direction == PatientDirection.QuadrupedMedial)
                return "M";
            else if (direction == PatientDirection.QuadrupedProximal)
                return "Pr";
            else if (direction == PatientDirection.QuadrupedDistal)
                return "Di";
            else if (direction == PatientDirection.QuadrupedPalmar)
                return "Pa";
            else if (direction == PatientDirection.QuadrupedPlantar)
                return "Pl";
            else if (direction == PatientDirection.Left)
                return "L";
            else if (direction == PatientDirection.Right)
                return "R";
            else if (direction == PatientDirection.Head)
                return "H";
            else if (direction == PatientDirection.Foot)
                return "F";
            else if (direction == PatientDirection.Anterior)
                return "A";
            else if (direction == PatientDirection.Posterior)
                return "P";
            return string.Empty;
        }

        public static T ParseJsonFile<T>(string fileName)
        {
            return ParseJsonText<T>(File.ReadAllText(fileName));
        }

        public static T ParseJsonText<T>(string text)
        {
            return JsonUtil.Deserialize<T>(text);
        }

        public static void ProcessWaveform(string fileName, ECGParams ecgParams, Stream stream)
        {
            using (var fileStream = File.Open(fileName, FileMode.Open, FileAccess.Read, FileShare.Read))
            {
                ProcessWaveform(fileStream, ecgParams, stream);
            }
        }

        public static void ProcessWaveform(Stream inputStream, ECGParams ecgParams, Stream stream)
        {
            ECGInfo ecgInfo = null;
            ExportOptions exportOptions = new ExportOptions
            {
                DrawType = (ECG.DrawType)ecgParams.DrawType,
                GridType = (ECG.GridType)ecgParams.GridType,
                ImageWidth = ecgParams.ImageWidth,
                ImageHeight = ecgParams.ImageHeight,
                GenerateHeader = false,
                GenerateImage = true,
                GridColor = (ECG.GridColor)ecgParams.GridColor,
                SignalThickness = (ECG.SignalThickness)ecgParams.SignalThickness,
                SignalGain = (ECG.SignalGain)ecgParams.Gain,
                IsWaterMarkRequired = IsWatermarkRequired(inputStream),
                ExtraSignals = ExtraLeads(ecgParams.ExtraLeads)
            };
            System.Drawing.Bitmap bitmap = ECGExporter.ToBitmap(inputStream, "DICOM", exportOptions, out ecgInfo);
            if (bitmap != null)
            {
                bitmap.Save(stream, System.Drawing.Imaging.ImageFormat.Png);
            }
        }

        private static bool IsWatermarkRequired(Stream inputStream)
        {
            try
            {
                // load dicom file
                DicomFile file = new DicomFile();
                file.Load(inputStream, null, DicomReadOptions.DoNotStorePixelDataInDataSet);

                string physiciansReadingStudy = file.DataSet[DicomTags.NameOfPhysiciansReadingStudy].ToString();
                if (string.IsNullOrEmpty(physiciansReadingStudy))
                {
                    return true;
                }

                string[] physicianNameFormat = physiciansReadingStudy.Split('^');
                if (physicianNameFormat == null || physicianNameFormat.Length == 0)
                {
                    return true;
                }

                return false;
            }
            catch (Exception)
            {
            }
            finally
            {
                inputStream.Seek(0, SeekOrigin.Begin);
            }

            return false;
        }

        private static bool IsWatermarkRequired(string fileName)
        {
            try
            {
                // load dicom file
                DicomFile file = new DicomFile(fileName);
                file.Load(DicomReadOptions.DoNotStorePixelDataInDataSet);

                string physiciansReadingStudy = file.DataSet[DicomTags.NameOfPhysiciansReadingStudy].ToString();
                if (string.IsNullOrEmpty(physiciansReadingStudy))
                {
                    return true;
                }

                string[] physicianNameFormat = physiciansReadingStudy.Split('^');
                if (physicianNameFormat == null || physicianNameFormat.Length == 0)
                {
                    return true;
                }

                return false;
            }
            catch (Exception)
            {
            }

            return false;
        }

        private static string[] ExtraLeads(string leadNames)
        {
            try
            {
                if (string.IsNullOrEmpty(leadNames))
                {
                    return null;
                }

                string[] extraSignals = leadNames.Split('|');
                if (extraSignals == null || extraSignals.Length == 0)
                {
                    return null;
                }

                return extraSignals;
            }
            catch (Exception)
            {
            }

            return null;
        }

        public static ImagePlane GetImagePlane(DicomFile file)
        {
            try
            {
                ImagePositionPatient imagePositionPatient = ImagePositionPatient.FromString(file.DataSet[DicomTags.ImagePositionPatient].ToString());
                if (imagePositionPatient == null)
                    return null;

                ImageOrientationPatient imageOrientationPatient = ImageOrientationPatient.FromString(file.DataSet[DicomTags.ImageOrientationPatient].ToString());
                if (imageOrientationPatient == null)
                    return null;

                ClearCanvas.Dicom.Iod.PixelSpacing pixelSpacing = ClearCanvas.Dicom.Iod.PixelSpacing.FromString(file.DataSet[DicomTags.PixelSpacing].ToString());
                if (pixelSpacing == null)
                    return null;

                int rows = Convert.ToInt32(file.DataSet[DicomTags.Rows].ToString());
                int columns = Convert.ToInt32(file.DataSet[DicomTags.Columns].ToString());

                ImagePlane imagePlane = new ImagePlane
                {
                    PosX = imagePositionPatient.X,
                    PosY = imagePositionPatient.Y,
                    PosZ = imagePositionPatient.Z,
                    RowX = imageOrientationPatient.RowX,
                    RowY = imageOrientationPatient.RowY,
                    RowZ = imageOrientationPatient.RowZ,
                    ColX = imageOrientationPatient.ColumnX,
                    ColY = imageOrientationPatient.ColumnY,
                    ColZ = imageOrientationPatient.ColumnZ,
                    PixX = pixelSpacing.Row,
                    PixY = pixelSpacing.Column,
                    Rows = rows,
                    Cols = columns
                };

                return imagePlane;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static ImagePlane GetImagePlane(Dictionary<string, object> dicomHeaderValues)
        {
            try
            {
                object value;
                if (!dicomHeaderValues.TryGetValue("00200032", out value))
                    return null;
                ImagePositionPatient imagePositionPatient = ImagePositionPatient.FromString(value as string);
                if (imagePositionPatient == null)
                    return null;

                if (!dicomHeaderValues.TryGetValue("00200037", out value))
                    return null;
                ImageOrientationPatient imageOrientationPatient = ImageOrientationPatient.FromString(value as string);
                if (imageOrientationPatient == null)
                    return null;

                if (!dicomHeaderValues.TryGetValue("00280030", out value))
                    return null;
                ClearCanvas.Dicom.Iod.PixelSpacing pixelSpacing = ClearCanvas.Dicom.Iod.PixelSpacing.FromString(value as string);
                if (pixelSpacing == null)
                    return null;

                if (!dicomHeaderValues.TryGetValue("00280010", out value))
                    return null;
                int rows = Convert.ToInt32(value);

                if (!dicomHeaderValues.TryGetValue("00280011", out value))
                    return null;
                int columns = Convert.ToInt32(value);


                ImagePlane imagePlane = new ImagePlane
                {
                    PosX = imagePositionPatient.X,
                    PosY = imagePositionPatient.Y,
                    PosZ = imagePositionPatient.Z,
                    RowX = imageOrientationPatient.RowX,
                    RowY = imageOrientationPatient.RowY,
                    RowZ = imageOrientationPatient.RowZ,
                    ColX = imageOrientationPatient.ColumnX,
                    ColY = imageOrientationPatient.ColumnY,
                    ColZ = imageOrientationPatient.ColumnZ,
                    PixX = pixelSpacing.Row,
                    PixY = pixelSpacing.Column,
                    Rows = rows,
                    Cols = columns
                };

                return imagePlane;
            }
            catch (Exception)
            {
                return null;
            }
        }

        public static ImageUpdateResultset UpdateImage(Stream stream, string filePath, IStudyBuilder studyBuilder)
        {
            var resultset = new ImageUpdateResultset();

            DicomFile dicomFile = null;

            if (stream != null)
            {
                var streamWrapper = new StreamWrapper(stream);
                Func<Stream> streamDelegate = delegate () { return streamWrapper; };
                dicomFile = LoadDicomFile(DicomStreamOpener.Create(streamDelegate));
            }
            else
            {
                dicomFile = LoadDicomFile(filePath);
            }

            // read header
            resultset.Tags = GetHeader(dicomFile);

            // create dicomdir fragment
            resultset.DicomDirXml = DicomDirBuilder.CreateDicomDirXml(dicomFile, dicomFile.DataSet[DicomTags.SopInstanceUid].ToString());

            if (studyBuilder != null)
            {
                string studyInstanceUid = dicomFile.DataSet[DicomTags.StudyInstanceUid].ToString();

                if (studyBuilder.CreateStudy(studyInstanceUid))
                {
                    var study = new Entities.Study();
                    study.StudyUid = studyInstanceUid;
                    study.DicomStudyId = dicomFile.DataSet[DicomTags.StudyId].ToString();
                    study.Procedure = dicomFile.DataSet[DicomTags.StudyDescription].ToString();
                    study.Modality = dicomFile.DataSet[DicomTags.Modality].ToString();
                    study.StudyId = studyBuilder.StudyId;

                    DateTime dtStudyDate;
                    if (DateParser.Parse(dicomFile.DataSet[DicomTags.StudyDate].ToString(), out dtStudyDate))
                    {
                        DateTime dtStudyTime;
                        if (TimeParser.Parse(dicomFile.DataSet[DicomTags.StudyTime].ToString(), out dtStudyTime))
                        {
                            study.DateTime = string.Format("{0:0000}-{1:00}-{2:00}T{3:00}:{4:00}:{5:00}",
                                                           dtStudyDate.Year,
                                                           dtStudyDate.Month,
                                                           dtStudyDate.Day,
                                                           dtStudyTime.Hour, dtStudyTime.Minute, dtStudyTime.Second);
                        }
                    }

                    study.Patient = new Hydra.Entities.Patient();
                    study.Patient.ICN = dicomFile.DataSet[DicomTags.PatientId].ToString();
                    study.Patient.FullName = DicomDataFormatHelper.PersonNameFormatter(new PersonName(dicomFile.DataSet[DicomTags.PatientsName].ToString()));
                    study.Patient.dob = DicomDataFormatHelper.DateFormat(dicomFile.DataSet[DicomTags.PatientsBirthDate].ToString());
                    study.Patient.Sex = dicomFile.DataSet[DicomTags.PatientsSex].ToString();
                    study.Patient.Age = dicomFile.DataSet[DicomTags.PatientsAge].ToString();
                    study.DicomDirXml = DicomDirBuilder.CreateStudyDicomDirXml(dicomFile);
                    studyBuilder.UpdateStudy(study);

                    if (studyBuilder.CreatePatient(study.Patient.ICN))
                    {
                        study.Patient.DicomDirXml = DicomDirBuilder.CreatePatientDicomDirXml(dicomFile);
                        studyBuilder.UpdatePatient(study.Patient);
                    }
                }

                string seriesInstanceUid = dicomFile.DataSet[DicomTags.SeriesInstanceUid].ToString();
                if (studyBuilder.CreateSeries(seriesInstanceUid))
                {
                    var series = new Entities.Series();
                    series.SeriesInstanceUID = seriesInstanceUid;
                    series.Modality = dicomFile.DataSet[DicomTags.Modality].ToString();
                    int seriesNumber = 0;
                    int.TryParse(dicomFile.DataSet[DicomTags.SeriesNumber].ToString(), out seriesNumber);
                    series.SeriesNumber = seriesNumber;
                    series.Description = dicomFile.DataSet[DicomTags.SeriesDescription].ToString();
                    series.DicomDirXml = DicomDirBuilder.CreateSeriesDicomDirXml(dicomFile);
                    series.StudyInstanceUID = studyInstanceUid;
                    studyBuilder.UpdateSeries(series);
                }
            }

            return resultset;
        }

        private static void ReadAsGeneralImageModuleIod(DicomFile dicomFile, ImageInfo imageInfo)
        {
            try
            {
                var iod = new GeneralImageModuleIod(dicomFile.DataSet);

                bool? isCompressed = iod.LossyImageCompression;
                imageInfo.IsCompressed = (isCompressed.HasValue) ? isCompressed.Value : false;
            }
            catch (Exception ex)
            {
                _Logger.Error("Error parsing as GeneralImageModuleIod", "Exception", ex.ToString());
            }
        }

    }
}
