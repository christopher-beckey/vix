using ClearCanvas.Dicom;
using ClearCanvas.Dicom.Codec;
using ClearCanvas.Dicom.IO;
using ClearCanvas.Dicom.Iod;
using ClearCanvas.Dicom.Utilities;
using ClearCanvas.ImageViewer;
using ClearCanvas.ImageViewer.Annotations.Dicom;
using ClearCanvas.ImageViewer.Graphics;
using ClearCanvas.ImageViewer.Imaging;
using ClearCanvas.ImageViewer.PresentationStates.Dicom;
using ClearCanvas.ImageViewer.StudyManagement;
using Hydra.Common;
using Hydra.Common.Extensions;
using Hydra.Dicom;
using Hydra.Entities;
using Ookii.Dialogs.WinForms;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Reflection;
using System.Text;
using System.Windows.Forms;
using TestApp;

namespace SCIP_Tool
{
    public partial class FormDicom : Form
    {
        private string InputFilePath = "";
        private string InputFolderPath = "";
        private readonly string logFilePath = "";
        private readonly StringBuilder sb = new StringBuilder();
        private static readonly int ThumbnailWidth = 120;
        private static readonly int ThumbnailHeight = 120;
        private class MyImage
        {
            public Hydra.Entities.Image Image;
            public Hydra.Entities.ImageInfo ImageInfo;
        }

        public FormDicom()
        {
            InitializeComponent();
            ResetLabelInfo();
            ButtonFileBrowse.Top = TextInputFile.Top;
            //Width = 1054;
            //Height = 532;
            CenterToScreen();
            logFilePath = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "Log", DateTime.Now.ToString("yyyyddMHHmm") + ".log");
            string logDirPath = Path.GetDirectoryName(logFilePath);
            Directory.CreateDirectory(logDirPath);
        }

        #region Form Controls

        private void ButtonClose_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void TextInputFile_TextChanged(object sender, EventArgs e)
        {
            CheckAndSetInputFile(TextInputFile.Text);
        }

        private void TextInputFolder_TextChanged(object sender, EventArgs e)
        {
            CheckAndSetInputFolder(TextInputFolder.Text);
        }

        private void ButtonScrub_Click(object sender, EventArgs e)
        {
            MessageBox.Show("For now, use the ClearCanvas Desktop application to anonymize, and tell us you want this function.");
            return;
            //I tried ClearCanvas.Ananymize, but we would need to do a lot more than it does. I also tried Evil DICOM.
            //if (string.IsNullOrWhiteSpace(InputFilePath) && string.IsNullOrWhiteSpace(InputFolderPath))
            //{
            //    UIError("Please enter a file or folder path");
            //}
            //else
            //{
            //    string outputRootFolder = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "anon");
            //    Directory.CreateDirectory(outputRootFolder);
            //    AppendText($@"See output files in {outputRootFolder}{Environment.NewLine}");
            //    if (!string.IsNullOrWhiteSpace(InputFilePath))
            //        DicomTools.Anonymize(InputFilePath, outputRootFolder);
            //    else
            //    {
            //        foreach (string filePath in Directory.EnumerateFiles(InputFolderPath))
            //        {
            //            if (!filePath.EndsWith("checksum"))
            //            {
            //                AppendText($"{Environment.NewLine}{Path.GetFileName(filePath)}{Environment.NewLine}");
            //                DicomTools.Anonymize(filePath, outputRootFolder);
            //            }
            //        }
            //    }

            //    AppendText($"Done{Environment.NewLine}");
            //    ButtonClose.Enabled = true;
            //}
        }

        private void ButtonInspect_Click(object sender, EventArgs e)
        {
            //Using ClearCanvas
            if (string.IsNullOrWhiteSpace(InputFilePath) && string.IsNullOrWhiteSpace(InputFolderPath))
            {
                UIError("Please enter a file or folder path");
            }
            else
            {
                //DicomTools.ExtractBitmap(TODO);

                //ImageProcessResultset resultset = ImageProcessor.ProcessImage(InputFilePath, "", fileType, InputFolderPath + ".out", fileStorage, studyBuilder);
                string outputRootFolder = Path.Combine(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location), "wip");
                Directory.CreateDirectory(outputRootFolder);
                AppendText($@"See output files, such as in VixRenderCache\Cache, in {outputRootFolder}{Environment.NewLine}");
                if (!string.IsNullOrWhiteSpace(InputFilePath))
                    ProcessTheFile(InputFilePath, outputRootFolder);
                else
                {
                    foreach (string filePath in Directory.EnumerateFiles(InputFolderPath))
                    {
                        if (!filePath.EndsWith("checksum"))
                        {
                            AppendText($"{Environment.NewLine}{Path.GetFileName(filePath)}{Environment.NewLine}");
                            ProcessTheFile(filePath, outputRootFolder);
                        }
                    }
                }

                AppendText($"Done{Environment.NewLine}");
                ButtonClose.Enabled = true;
            }
        }

        private void ButtonInspectFO_Click(object sender, EventArgs e)
        {
            //Using fo-dicom
            if (string.IsNullOrWhiteSpace(InputFilePath) && string.IsNullOrWhiteSpace(InputFolderPath))
            {
                UIError("Please enter a file or folder path");
            }
            else
            {
                if (!string.IsNullOrWhiteSpace(InputFilePath))
                {
                    List<string> info = DicomTools.FoDicomInspect(InputFilePath);
                    AppendText($"FO-DICOM Info for {Path.GetFileName(InputFilePath)}:{Environment.NewLine}");
                    foreach (string item in info)
                        AppendText($"{item}{Environment.NewLine}");
                }
                else
                {
                    foreach (string filePath in Directory.EnumerateFiles(InputFolderPath))
                    {
                        if (!filePath.EndsWith("checksum"))
                        {
                            List<string> info = DicomTools.FoDicomInspect(InputFilePath);
                            AppendText($"FO-DICOM Info for {Path.GetFileName(filePath)}:{Environment.NewLine}");
                            foreach (string item in info)
                                AppendText($"{item}{Environment.NewLine}");
                        }
                    }
                }

                AppendText($"Done{Environment.NewLine}");
                //The bug only happens when debugging in Visual Studio, so commented this out
                //https://github.com/fo-dicom/fo-dicom/issues/1595
                //UIError("FO-DICOM has a bug that changes the app's resolution. Issue logged with that team.");
                ButtonClose.Enabled = true;
            }
        }

        private void ButtonFileBrowse_Click(object sender, EventArgs e)
        {
            var fileDialog = new VistaOpenFileDialog()
            {
                Title = "Select a DICOM file"
            };
            var dialogResult = fileDialog.ShowDialog();
            if (dialogResult != System.Windows.Forms.DialogResult.OK)
            {
                UIError("No file was selected");
            }
            else
            {
                if (string.IsNullOrWhiteSpace(fileDialog.FileName))
                {
                    UIError("No file was selected");
                }
                else
                {
                    CheckAndSetInputFile(fileDialog.FileName);
                }
            }
        }

        private void ButtonCancel_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void ButtonDicomDirFromFO_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(InputFilePath))
            {
                UIError("Please enter the path to the DICOMDIR file");
            }
            else
            {
                List<string> info = DicomTools.ReadDicomDirFile(InputFilePath);
                AppendText($"FO-DICOM DICOMDIR info for {Path.GetFileName(InputFilePath)}:{Environment.NewLine}");
                foreach (string item in info)
                    AppendText($"{item}{Environment.NewLine}");
                AppendText($"Done{Environment.NewLine}");
                ButtonClose.Enabled = true;
            }
        }

        private void ButtonDicomDirToFO_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(InputFolderPath))
            {
                UIError("Please enter the folder path to the DICOM files");
            }
            else
            {
                string info = DicomTools.WriteDicomFiles(InputFolderPath);
                AppendText($"FO-DICOM files to DICOMDIR: {info}{Environment.NewLine}");
                ButtonClose.Enabled = true;
            }
        }

        private void ButtonCCView_Click(object sender, EventArgs e)
        {
            var form = new TestApp.Form1();
            form.textBoxFilePath.Text = InputFilePath;
            form.ShowDialog();
        }
        #endregion Form Controls

        private void AppendText(string format, params object[] args)
        {
            sb.AppendFormat(format, args);
            LogTheLine(string.Format(format, args));
            tbOutput.Text = sb.ToString();
            if (format.StartsWith("Done"))
                ButtonClose.Focus();
            Application.DoEvents();
        }

        private void LogTheLine(string theLine)
        {
            if (!File.Exists(logFilePath))
            {
                using (StreamWriter sw = File.CreateText(logFilePath))
                {
                    sw.WriteLine(DateTime.Now.ToString("yyyyddMHHmmss") + "\t" + theLine.TrimEnd('\r', '\n'));
                }
            }
            else
            {
                using (StreamWriter sw = File.AppendText(logFilePath))
                {
                    sw.WriteLine(DateTime.Now.ToString("yyyyddMHHmmss") + "\t" + theLine.TrimEnd('\r', '\n'));
                }
            }
        }

        private void ProcessTheFile(string filePath, string outputRootFolder)
        {
            ImageProcessResultset resultset = new ImageProcessResultset(Path.GetFileNameWithoutExtension(filePath), outputRootFolder);
            DefaultFileStorage fileStorage = new DefaultFileStorage();
            DicomFile dicomFile = new DicomFile(filePath);
            string fileName = Path.GetFileNameWithoutExtension(filePath);
            try
            {
                dicomFile.Load(DicomReadOptions.StorePixelDataReferences);
                MyImage resultset2 = ProcessDicomImage(dicomFile, Path.Combine(outputRootFolder, $"{fileName}.out"), resultset, fileStorage, null);
                AppendText($"MinPixelValue = {resultset2.ImageInfo.MinPixelValue}{Environment.NewLine}");
                AppendText($"MaxPixelValue = {resultset2.ImageInfo.MaxPixelValue}{Environment.NewLine}");
                AppendText($"WindowCenter = {resultset2.ImageInfo.WindowCenter}{Environment.NewLine}");
                AppendText($"WindowWidth = {resultset2.ImageInfo.WindowWidth}{Environment.NewLine}");

                string hasOverlay = "No";
                if (resultset2.ImageInfo.Overlays != null)
                {
                    hasOverlay = $"Yes ({resultset2.ImageInfo.Overlays.Length})";
                }
                AppendText($"Overlay(s) = {hasOverlay}{Environment.NewLine}");

                //// Load the file using ClearCanvas
                //DicomFile file = new DicomFile("00010001.dcm");
                //file.Load();
                //// Read some attributes...
                //int age = file.DataSet[DicomTags.PatientsAge].GetInt32(0, -1);
                //string name = file.DataSet[DicomTags.PatientsName].GetString(0, null);
                //DateTime? studyDate = file.DataSet[DicomTags.StudyDate].GetDateTime(0);
                //
                //// Write some attributes...
                //file.DataSet[DicomTags.PatientsAge].SetInt32(0, 27);
                //file.DataSet[DicomTags.PatientsName].SetString(0, "Anonymous");
                //file.DataSet[DicomTags.StudyDate].SetDateTime(0, DateTime.Now);
                //// Save
                //file.Save();

                AppendText($"{Environment.NewLine}Tags:{Environment.NewLine}");
                List<Hydra.Entities.DicomTag> tags = GetHeader(dicomFile);
                foreach (var t in tags)
                {
                    AppendText($"{t.Tag} {t.TagDescription} <{t.TagValue}>{Environment.NewLine}");
                }

                //DicomTools.ExtractImage(InputFilePath);
            }
            catch (Exception ex)
            {
                AppendText($"{ex.ToString()}{Environment.NewLine}");
            }
        }

        private void ResetLabelInfo()
        {
            lblInfo.Text = "";
            lblInfo.ForeColor = Color.Black;
        }

        private void UIError(string msg)
        {
            lblInfo.Text = msg;
            lblInfo.ForeColor = Color.Red;
        }

        private void CheckAndSetInputFile(string filePath)
        {
            if (File.Exists(filePath))
            {
                InputFilePath = filePath;
                TextInputFile.Text = filePath;
                InputFolderPath = "";
                TextInputFolder.Text = "";
                ResetLabelInfo();
            }
            else
            {
                UIError($"{filePath} does not exist");
            }
        }

        private void CheckAndSetInputFolder(string folderPath)
        {
            if (Directory.Exists(folderPath))
            {
                InputFolderPath = folderPath;
                TextInputFolder.Text = folderPath;
                InputFilePath = "";
                TextInputFile.Text = "";
                ResetLabelInfo();
                //JpegOutputFolderPath = GetUniquePath(Path.Combine(Path.GetTempPath(), "JpegConvert"));
            }
            else
            {
                UIError($"{folderPath} does not exist");
            }
        }

        //Copied from Hydra.Dicom\ImageProcessor.cs, then modified
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

        private static DicomFile LoadDicomFile(string filePath, out string anError)
        {
            anError = "";
            DicomFile file = null;

            try
            {
                file = new DicomFile(filePath);
                file.Load(DicomReadOptions.StorePixelDataReferences);
            }
            catch (Exception ex)
            {
                //_Logger.Error("Error loading dicom file.", "FilePath", filePath, "Exception", ex.ToString());
                anError = $"Error loading dicom file. FilePath={filePath}, Exception={ex.ToString()}{Environment.NewLine}";
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

        public static List<Hydra.Entities.DicomTag> GetHeader(Stream stream)
        {
            var streamWrapper = new StreamWrapper(stream);
            Func<Stream> streamDelegate = delegate () { return streamWrapper; };
            DicomFile dicomFile = LoadDicomFile(DicomStreamOpener.Create(streamDelegate));
            if (dicomFile == null)
                return null;

            return GetHeader(dicomFile);
        }

        //public static List<Hydra.Entities.DicomTag> GetHeader(string filePath)
        //{
        //    string myError;
        //    DicomFile dicomFile = LoadDicomFile(filePath, out myError);
        //    if (dicomFile == null)
        //    {
        //        if (!string.IsNullOrWhiteSpace(myError))
        //            AppendText(myError);
        //        return null;
        //    }

        //    return GetHeader(dicomFile);
        //}

        private MyImage ProcessDicomImage(DicomFile dicomFile, string filePath, ImageProcessResultset resultset, IFileStorage fileStorage, IStudyBuilder studyBuilder)
        {
            MyImage result = new MyImage();

            //uncomment and add a breakpoint here to ensure we can write to the file (most likely the same one you browsed to with a .out suffix)
            //fileStorage.WriteAllText(filePath, "dummy"); //to ensure we can write to the file

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
            #region NotNow
            //if (Utility.IsPdf(dicomFile))
            //{
            //    resultset.ImageType = ImageType.RadPdf;
            //    imagePart = resultset.AddFrame(ImagePartTransform.Pdf);

            //    var pdfIOD = new EncapsulatedPdfIod(dicomFile.DataSet);
            //    byte[] frame = pdfIOD.EncapsulatedDocument.EncapsulatedDocument;
            //    fileStorage.WriteAllBytes(imagePart.FilePath, frame);

            //    imagePart = resultset.AddAbstract();
            //    fileStorage.WriteBitmap(imagePart.FilePath, Resource.pdf, System.Drawing.Imaging.ImageFormat.Jpeg);
            //}
            //else if (Utility.IsECG(dicomFile))
            //{
            //    resultset.ImageType = ImageType.RadECG;

            //    ExportOptions exportOptions = new ExportOptions
            //    {
            //        SignalGain = SignalGain.Ten,
            //        DrawType = DrawType.ThreeXFourPlusThree,
            //        GridType = GridType.OneMillimeters,
            //        ImageWidth = 1200,
            //        ImageHeight = 900,
            //        GenerateHeader = true,
            //        GenerateImage = true,
            //        GridColor = GridColor.Red,
            //        SignalThickness = SignalThickness.One,
            //        IsWaterMarkRequired = string.IsNullOrEmpty(dicomFile.DataSet[DicomTags.NameOfPhysiciansReadingStudy].ToString())
            //    };

            //    ECGInfo ecgInfo = null;
            //    System.Drawing.Bitmap bitmap = null;
            //    if (dicomStream != null)
            //    {
            //        using (var tempStream = new MemoryStream())
            //        {
            //            // copy stream without losing position
            //            var pos = dicomStream.Position;
            //            dicomStream.Position = 0;
            //            dicomStream.CopyTo(tempStream);
            //            tempStream.Seek(0, SeekOrigin.Begin);
            //            dicomStream.Position = pos;

            //            bitmap = ECGExporter.ToBitmap(dicomStream, "DICOM", exportOptions, out ecgInfo);
            //        }
            //    }
            //    else
            //        bitmap = ECGExporter.ToBitmap(filePath, "DICOM", exportOptions, out ecgInfo);
            //    if (bitmap == null)
            //        throw new Exception("Failed to convert ECG to bitmap");
            //    if (ecgInfo == null)
            //        throw new Exception("Failed to write ECG info");

            //    imagePart = resultset.AddWaveform(ImagePartTransform.Png);
            //    // waveform png is generated based on ecg request. use original as image part
            //    // For now, assume the original file is encrypted if dicomStream is not null
            //    fileStorage.CopyFile(imagePart.FilePath, filePath, (dicomStream != null));

            //    imagePart = resultset.AddWaveform(ImagePartTransform.Json);
            //    fileStorage.WriteAllText(imagePart.FilePath, JsonUtil.Serialize(ecgInfo));

            //    imagePart = resultset.AddAbstract();
            //    fileStorage.WriteBitmap(imagePart.FilePath, Resource.ecg, System.Drawing.Imaging.ImageFormat.Jpeg);
            //}
            //else if (Utility.IsSR(dicomFile))
            //{
            //    resultset.ImageType = ImageType.RadSR;
            //    imagePart = resultset.AddFrame(ImagePartTransform.Html);

            //    SRDocument doc = new SRDocument(dicomFile);
            //    using (var outputStream = fileStorage.CreateStream(imagePart.FilePath))
            //    {
            //        string content = doc.WriteHTML();
            //        StreamWriter writer = new StreamWriter(outputStream);
            //        writer.Write(content);
            //        writer.Flush();
            //    }

            //    imagePart = resultset.AddAbstract();
            //    fileStorage.WriteBitmap(imagePart.FilePath, Resource.sr, System.Drawing.Imaging.ImageFormat.Jpeg);
            //}
            //else if (Utility.IsPR(dicomFile))
            //{
            //    string text = PresentationStateReader.Read(dicomFile);
            //    if (!string.IsNullOrEmpty(text))
            //    {
            //        resultset.ImageType = ImageType.RadPR;

            //        imagePart = resultset.AddDicomPR();
            //        fileStorage.WriteAllText(imagePart.FilePath, text);

            //        if (_Logger.IsDebugEnabled)
            //            _Logger.Debug("Processing PR image.", "FilePath", imagePart.FilePath);
            //    }
            //    else
            //    {
            //        _Logger.Error("Error processing PR image.");
            //    }

            //    /* Since these objects are not displayed in the thumbnail panel, no
            //     * need to create abstracts for now */

            //    return; // nothing else to process
            //}
            //else
            #endregion NotNow
            //{
                bool isUltrasoundMultiframe = (pd.NumberOfFrames > 1) && (dicomFile.DataSet[DicomTags.Modality].ToString() == "US");

                // save frames to file
                for (int i = 0; i < pd.NumberOfFrames; i++)
                {
                    byte[] frame = pd.GetFrame(i);

                    if (i == 0)
                        frameSize = frame.Length;

                    imagePart = resultset.AddFrame(ImagePartTransform.DicomData, i);
                    fileStorage.WriteAllBytes(imagePart.FilePath, frame); //VAI-134

                    ////TODO - temp code #1 to see what it looks like when we save the image as JPEG
                    //imagePart = resultset.AddFrame(ImagePartTransform.Jpeg, i);
                    //using (var stream = fileStorage.CreateStream(imagePart.FilePath.Replace(".", "-1.")))
                    //{
                    //    Hydra.Dicom.JpegWriter.SaveToStream(frame,
                    //                            pd.ImageWidth, pd.ImageHeight,
                    //                            pd.BitsAllocated, pd.SamplesPerPixel,
                    //                            stream);
                    //}

                    //TODO - why is this just an idea for multi-frames, why not single frames, too?
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
                        //TODO - temp code #2 to see what it looks like when we save the image as JPEG like thumbnail, only bigger
                        //using (IPresentationImage presentationImage = PresentationImageFactory.Create(imageSop.Frames[1]))
                        //{
                        //    using (System.Drawing.Bitmap bitmap = presentationImage.DrawToBitmap(pd.ImageWidth, pd.ImageHeight))
                        //    {
                        //        var settings = new ImageResizer.ResizeSettings
                        //        {
                        //            Format = "JPG",
                        //            Mode = ImageResizer.FitMode.Stretch
                        //        };

                        //        TODO-Both AddAbstract and AddFrame work. Hmmmmmmmmm.
                        //        imagePart = resultset.AddAbstract();
                        //        imagePart = resultset.AddFrame(ImagePartTransform.Jpeg);
                        //        using (var stream = fileStorage.CreateStream(imagePart.FilePath.Replace(".", "-2.")))
                        //        {
                        //            ImageResizer.ImageBuilder.Current.Build(bitmap, stream, settings);
                        //        }
                        //    }
                        //}
                    }
                }

            //ProcessDicomOverlays(dicomFile, pd.NumberOfFrames, resultset);
            //}

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
                MaxPixelValue = DicomPixelData.GetMaxPixelValue(pd.BitsStored, pd.IsSigned), //this is the *possible*, not the *actual* value
                MinPixelValue = DicomPixelData.GetMinPixelValue(pd.BitsStored, pd.IsSigned),  //this is the *possible*, not the *actual* value

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

            //VAI-134
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
                    pixelData.CalculateMinMaxPixelValue(out int minPixelValue, out int maxPixelValue);
                    if (minPixelValue == 0 && maxPixelValue == 0)
                    {
                        minPixelValue = imageInfo.MinPixelValue;
                        maxPixelValue = imageInfo.MaxPixelValue;
                    }

                    imageInfo.MinPixelValue = minPixelValue;
                    imageInfo.MaxPixelValue = maxPixelValue;
                }
            }

            // get date and time
            if (DateParser.Parse(dicomFile.DataSet[DicomTags.StudyDate].ToString(), out DateTime studyDate))
                imageInfo.StudyDate = studyDate.ToString("dd-MMM-yyyy");

            if (TimeParser.Parse(dicomFile.DataSet[DicomTags.StudyTime].ToString(), out DateTime studyTime))
                imageInfo.StudyTime = studyTime.ToString("HH:mm");

            if (TimeParser.Parse(dicomFile.DataSet[DicomTags.SeriesTime].ToString(), out DateTime seriesTime))
                imageInfo.SeriesTime = seriesTime.ToString("HH:mm");

            // modality
            imageInfo.Modality = dicomFile.DataSet[DicomTags.Modality].ToString();

            // patient orientation
            imageInfo.DirectionalMarkers = GetDirectionalMarkers(dicomFile.DataSet);

            // measurement info
            //TODO imageInfo.Measurement = Hydra.Dicom.MeasurementReader.Read(dicomFile.DataSet, imageInfo.ImageWidth, imageInfo.ImageHeight);

            // cine rate
            //TODO imageInfo.CineRate = GetCineRate(dicomFile.DataSet);

            //TODO ReadAsGeneralImageModuleIod(dicomFile, imageInfo);

            // finally write imageinfo
            imagePart = resultset.AddImageInfo();
            fileStorage.WriteAllText(imagePart.FilePath, JsonUtil.Serialize(imageInfo));

            // create image object
            var image = new Hydra.Entities.Image
            {
                DicomStudyId = dicomFile.DataSet[DicomTags.StudyId].ToString(),
                SopInstanceUid = dicomFile.DataSet[DicomTags.SopInstanceUid].ToString(),
                SeriesInstanceUid = dicomFile.DataSet[DicomTags.SeriesInstanceUid].ToString(),
                StudyInstanceUid = dicomFile.DataSet[DicomTags.StudyInstanceUid].ToString(),
                Description = dicomFile.DataSet[DicomTags.CodeMeaning].ToString(),
                NumberOfFrames = pd.NumberOfFrames,
                FrameSize = frameSize
            };
            int.TryParse(dicomFile.DataSet[DicomTags.InstanceNumber].ToString(), out int instanceNumber);
            image.InstanceNumber = instanceNumber;
            int.TryParse(dicomFile.DataSet[DicomTags.SeriesNumber].ToString(), out int seriesNumber);
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
                    var study = new Hydra.Entities.Study
                    {
                        StudyUid = image.StudyInstanceUid,
                        DicomStudyId = image.DicomStudyId,
                        Procedure = dicomFile.DataSet[DicomTags.StudyDescription].ToString(),
                        Modality = image.Modality,
                        StudyId = studyBuilder.StudyId
                    };

                    if (DateParser.Parse(dicomFile.DataSet[DicomTags.StudyDate].ToString(), out DateTime dtStudyDate))
                    {
                        if (TimeParser.Parse(dicomFile.DataSet[DicomTags.StudyTime].ToString(), out DateTime dtStudyTime))
                        {
                            study.DateTime = string.Format("{0:0000}-{1:00}-{2:00}T{3:00}:{4:00}:{5:00}",
                                                           dtStudyDate.Year,
                                                           dtStudyDate.Month,
                                                           dtStudyDate.Day,
                                                           dtStudyTime.Hour, dtStudyTime.Minute, dtStudyTime.Second);
                        }
                    }

                    study.Patient = new Hydra.Entities.Patient
                    {
                        ICN = dicomFile.DataSet[DicomTags.PatientId].ToString(),
                        FullName = DicomDataFormatHelper.PersonNameFormatter(new PersonName(dicomFile.DataSet[DicomTags.PatientsName].ToString())),
                        dob = DicomDataFormatHelper.DateFormat(dicomFile.DataSet[DicomTags.PatientsBirthDate].ToString()),
                        Sex = dicomFile.DataSet[DicomTags.PatientsSex].ToString(),
                        Age = dicomFile.DataSet[DicomTags.PatientsAge].ToString()
                    };
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
                    var series = new Hydra.Entities.Series
                    {
                        SeriesInstanceUID = image.SeriesInstanceUid,
                        Modality = image.Modality,
                        SeriesNumber = image.SeriesNumber,
                        Description = dicomFile.DataSet[DicomTags.SeriesDescription].ToString(),
                        DicomDirXml = DicomDirBuilder.CreateSeriesDicomDirXml(dicomFile),
                        StudyInstanceUID = image.StudyInstanceUid
                    };
                    studyBuilder.UpdateSeries(series);
                }
            }

            //TODO
            //if (Is3DEnabled)
            //{
            //    imagePart = resultset.AddDicomHeader();

            //    // first create a copy of dicomfile sans pixel data, private and unknown tags
            //    var dicomHeaderFile = new DicomFile(imagePart.FilePath,
            //                                        dicomFile.MetaInfo.Copy(),
            //                                        dicomFile.DataSet.Copy(false, false, false));


            //    dicomHeaderFile.Save();
            //}

            result.Image = image;
            result.ImageInfo = imageInfo;
            return result;
        }

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
                        //TODO
                        //if ((overlayGraphic.Graphics == null) ||
                        //    (overlayGraphic.Graphics.Count < 1))
                        //    continue;

                        if (!(overlayGraphic.Graphics[0] is GrayscaleImageGraphic grayscaleImageGraphic))
                            continue;

                        // Note: FrameNumber is 1 based, but is stored in database as 0 based.
                        var imagePart = resultset.AddOverlay(ImagePartTransform.DicomData, frame.FrameNumber - 1, overlayGraphic.Index);
                        using (var stream = fileStorage.CreateStream(imagePart.FilePath))
                        {
                            fileStorage.WriteAllBytes(imagePart.FilePath, grayscaleImageGraphic.PixelData.Raw); //VAI-134 and VAI-886
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

                    //TODO
                    //// create a separate overlay by merging all overlays. This overlay does not contain an overlay index.
                    //if (overlayMap != null)
                    //{
                    //    if (overlayMap.Count == 1)
                    //    {
                    //        // only one overlay just create a new image part with the same file
                    //        // Todo: handle probable errors in deletion.
                    //        resultset.AddMergedOverlay(ImagePartTransform.DicomData, frame.FrameNumber - 1, overlayMap.Values.FirstOrDefault());
                    //    }
                    //    else
                    //    {
                    //        // Todo: until merging code is ready, use the first overlay
                    //        resultset.AddMergedOverlay(ImagePartTransform.DicomData, frame.FrameNumber - 1, overlayMap.Values.FirstOrDefault());
                    //    }
                    //}
                }
            }
            catch (Exception)
            {
            }

            return overlayList?.ToArray();
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
                        //TODO
                        //Left = GetMarker(ImageEdge.Left, patientOrientation),
                        //Right = GetMarker(ImageEdge.Right, patientOrientation),
                        //Top = GetMarker(ImageEdge.Top, patientOrientation),
                        //Bottom = GetMarker(ImageEdge.Bottom, patientOrientation)
                    };
                }
            }

            return null;
        }

        //TODO
        //private static string GetMarker(ImageEdge imageEdge, PatientOrientation patientOrientation)
        //{
        //    bool negativeDirection = (imageEdge == ImageEdge.Left || imageEdge == ImageEdge.Top);
        //    bool rowValues = (imageEdge == ImageEdge.Left || imageEdge == ImageEdge.Right);

        //    var direction = (rowValues ? patientOrientation.Row : patientOrientation.Column) ?? PatientDirection.Empty;
        //    if (negativeDirection)
        //        direction = direction.OpposingDirection;

        //    string markerText = "";
        //    markerText += GetMarkerText(direction.Primary);
        //    markerText += GetMarkerText(direction.Secondary);

        //    return markerText;
        //}

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

        private void ButtonFolderBrowse_Click(object sender, EventArgs e)
        {
            var directoryDialog = new VistaFolderBrowserDialog
            {
                Description = "Select folder with DICOM files",
                UseDescriptionForTitle = true
            };
            var dialogResult = directoryDialog.ShowDialog();
            if (dialogResult != System.Windows.Forms.DialogResult.OK)
            {
                UIError("No folder was selected");
            }
            else
            {
                if (string.IsNullOrWhiteSpace(directoryDialog.SelectedPath))
                {
                    UIError("No folder was selected");
                }
                else
                {
                    var tempDir = directoryDialog.SelectedPath;
                    CheckAndSetInputFolder(tempDir);
                }
            }
        }
    }
}
