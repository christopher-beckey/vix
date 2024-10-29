using PdfSharp.Drawing;
using PdfSharp.Pdf;
using PdfSharp.Pdf.IO;
using System;
using System.Collections.Generic;
using System.IO;
using Hydra.Log;
using System.Drawing.Imaging;
using System.Drawing;

namespace Hydra.Dicom
{
    /// <summary>
    /// This class not only handles TIFFs, but also handles some PDF-related methods (since we convert TIFF to PDF besides JPEG)
    /// </summary>
    public static class TiffProcessor
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        /// <summary>
        /// Process all the remaining pages
        /// </summary>
        public const int AllPages = -1;

        /// <summary>
        /// Combines a list of PDF files into the destination pdf file (VAI-1284)
        /// </summary>
        public static int CombinePdfFiles(string destPdf, List<string> pdfFiles)
        {
            try
            {
                int pCount = 0;
                if(File.Exists(destPdf))
                    File.Delete(destPdf);

                PdfDocument outputDocument = new PdfDocument();
                foreach (string file in pdfFiles)
                {
                    PdfDocument inputDocument = PdfReader.Open(file, PdfDocumentOpenMode.Import);
                    int count = inputDocument.PageCount;
                    for (int idx = 0; idx < count; idx++)
                    {
                        PdfPage page = inputDocument.Pages[idx];
                        outputDocument.AddPage(page);
                        pCount++;
                    }
                }
                outputDocument.Save(destPdf);
                return (pCount);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error appending PdfFiles", "Exception", ex.ToString());
            }
            return (0);
        }

        /// <summary>      
        /// Creates a PDF file from a list of images
        /// </summary>
        /// <returns>Path to destination PDF (VAI-307)</returns>
        public static string ConvertToPdf(string imageUID, List<string> ImageFiles, string baseFolder)
        {

            if (ImageFiles.Count < 1)
            {
                _Logger.Error("No image files requested for PDF build.", "imageUID", imageUID); //VAI-1336
                return ("");
            }

            string[] strlist = ImageFiles[0].Split('\\');
            string prepend = ImageFiles[0].Substring(ImageFiles[0].IndexOf(strlist[strlist.Length - 6]), ImageFiles[0].LastIndexOf('\\') - ImageFiles[0].IndexOf(strlist[strlist.Length - 6])).Replace("\\", string.Empty);
            string destFolder = $@"{baseFolder}Viewer\files\pdffiles";
            string pdfFile =$@"{destFolder}\{prepend}_{imageUID}_PRT.pdf";



            if (File.Exists(pdfFile)) {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Using existing PDF file.", "pdfFile", pdfFile); //VAI-1336
                return (pdfFile);
            }

            if (!Directory.Exists(destFolder)) 
                Directory.CreateDirectory(destFolder);
            try
            {
                if (_Logger.IsDebugEnabled)
                    _Logger.Debug("Building PDF file.", "pdfFile", pdfFile); //VAI-1336

                using (var pdfDocument = new PdfDocument())
                {
                    pdfDocument.Options.FlateEncodeMode = PdfFlateEncodeMode.BestSpeed;
                    pdfDocument.Options.UseFlateDecoderForJpegImages = PdfUseFlateDecoderForJpegImages.Automatic;
                    pdfDocument.Options.NoCompression = false;
                    pdfDocument.Options.CompressContentStreams = true;

                    foreach (string imageFile in ImageFiles)
                    {
                        if (File.Exists(imageFile))
                        {
                            string convertedFile = imageFile;
                            using (var image = System.Drawing.Image.FromFile(imageFile))
                            {
                                XImage pdfImage=null;
                                MemoryStream ms = new MemoryStream();
                                if (image.PixelFormat == PixelFormat.Format1bppIndexed || image.PixelFormat == PixelFormat.Format4bppIndexed )
                                {
                                    ImageCodecInfo codecInfo = GetEncoderInfo("image/tiff");//Use TIFF w/CCITT G4
                                    EncoderParameters ep = new EncoderParameters(1);
                                    ep.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.SaveFlag, (long)EncoderValue.Flush);
                                    ep.Param[0] = new EncoderParameter(System.Drawing.Imaging.Encoder.Compression, (long)EncoderValue.CompressionCCITT4);
                                    image.Save(ms, codecInfo, ep);
                                    pdfImage = XImage.FromStream(ms);
                                }
                                else
                                {
                                    image.Save(ms, ImageFormat.Jpeg);
                                    pdfImage = XImage.FromStream(ms);
                                }

                                var pdfPage = new PdfPage();
                                pdfPage.Width = (pdfImage.PixelWidth * 72) / pdfImage.HorizontalResolution;
                                pdfPage.Height = (pdfImage.PixelHeight * 72) / pdfImage.VerticalResolution;
                                pdfDocument.Pages.Add(pdfPage);
                                var xgr = XGraphics.FromPdfPage(pdfPage);
                                xgr.DrawImage(pdfImage, 0, 0);
                                ms.Dispose();
                                pdfImage.Dispose();
                            }
                        }
                        if (File.Exists(pdfFile)) 
                        {                            
                            pdfDocument.Close();
                            GC.Collect();
                            if (_Logger.IsDebugEnabled)
                                _Logger.Debug("Using existing PDF file.", "pdfFile", pdfFile); //VAI-1336
                            return (pdfFile);
                        }
                    }
                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Saving PDF file.", "pdfFile", pdfFile); //VAI-1336
                    if (!File.Exists(pdfFile))
                        pdfDocument.Save(pdfFile);
                    pdfDocument.Close();

                    GC.Collect();
                    if (File.Exists(pdfFile))
                    {
                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("PDF file created.", "pdfFile", pdfFile); //VAI-1336
                        return (pdfFile);
                    }
                    else
                    {
                        string displayMessage = "Error could not save PDF. Please try again.";
                        _Logger.Error("ConvertToPdf could not save PDF.", "displayMessage", displayMessage, "pdfFile", pdfFile); //VAI-1336
                        return (displayMessage);
                    }
                }
            }
            catch (Exception ex)
            {
                string displayMessage = "Error saving PDF file. Please try again.";
                _Logger.Error("ConvertToPdf save failed.", "pdfFile", pdfFile, "displayMessage", displayMessage, "Exception", ex.ToString()); //VAI-1336
                return (displayMessage);
            }
        }
        /// <summary>
        /// Converts a list of images from source Tiff image to individual image files, filtered by page range
        /// </summary>
        /// <returns>(VAI-307)</returns>
        public static void SaveImageFileList(int startPage, int stopPage, string sourceTiffFile, List<string> fileNames)
        {
            int imageIndex = 0 ;
            if (_Logger.IsDebugEnabled)
              _Logger.Debug("SaveImageFileList.", "sourceTiffFile", sourceTiffFile, "startPage", startPage.ToString(), "stopPage", stopPage.ToString()); //VAI-1336

            using (var fs = File.OpenRead(sourceTiffFile))
            {
                using (var image = Image.FromStream(fs))
                {  
                    foreach (var imageFile in fileNames)
                    {
                        if (imageIndex >= startPage && imageIndex <= stopPage)
                        {
                            image.SelectActiveFrame(System.Drawing.Imaging.FrameDimension.Page, imageIndex);
                            bool saveFile = true;
                            bool bExists = File.Exists(imageFile); 
                            if (bExists)
                            {
                                long length = new System.IO.FileInfo(imageFile).Length;
                                if (length > 0) saveFile = false;
                            }
                            if (saveFile == true)
                            {
                                if (image.PixelFormat == PixelFormat.Format1bppIndexed || image.PixelFormat == PixelFormat.Format4bppIndexed || image.PixelFormat == PixelFormat.Format8bppIndexed)
                                {
                                    image.Save(imageFile, ImageFormat.Png);//Use png here to preserve the BPP and reduce memory requirements
                                }
                                else
                                { 
                                    Bitmap bmp = new Bitmap(image);
                                    bmp.SetResolution(image.HorizontalResolution ,image.VerticalResolution);//JPEG does save the x and y resolutions by default
                                    bmp.Save(imageFile, ImageFormat.Jpeg);
                                    bmp.Dispose();
                                }
                            }
                        }
                        imageIndex++;
                    }
                }
            }
        }
        /// <summary>
        /// Finds encoder for the given mimeType
        /// </summary>
        /// <returns>ImageCodecInfo (VAI-307)</returns>
        private static ImageCodecInfo GetEncoderInfo(String mimeType)
        {
            int j;
            ImageCodecInfo[] encoders;
            encoders = ImageCodecInfo.GetImageEncoders();
            for (j = 0; j < encoders.Length; ++j)
            {
                if (encoders[j].MimeType == mimeType)
                    return encoders[j];
            }
            return null;
        }
        /// <summary>
        /// Converts selected range of page frames from source Tiff image to individual image files.
        /// </summary>
        /// <returns>ConversionResult  (VAI-307)</returns>
        public static ConversionResult ConvertToJpeg(int startPage, int stopPage, Stream input)
        {
            if (!IsTiff(input))
                return null;
            input.Seek(0, SeekOrigin.Begin);
            using (var image = System.Drawing.Image.FromStream(input))
            {
                ConversionResult result = new ConversionResult
                {
                    ImageType = Common.ImageType.Jpeg,
                    TransformType = Common.ImagePartTransform.Jpeg,
                    IsMultiframeSupported = true
                };

                int frameCount = image.GetFrameCount(System.Drawing.Imaging.FrameDimension.Page);
                if(stopPage== AllPages)  
                    stopPage = frameCount;
                if (stopPage  > frameCount) 
                    stopPage = frameCount;

                result.CreateFrames(frameCount);

                for (int pageIndex = startPage; pageIndex < stopPage; pageIndex++)
                {
                    string tem = pageIndex.ToString();
                    image.SelectActiveFrame(System.Drawing.Imaging.FrameDimension.Page, pageIndex);
                    if (frameCount > 1)
                    {
                        if (image.PixelFormat == PixelFormat.Format1bppIndexed || image.PixelFormat == PixelFormat.Format4bppIndexed || image.PixelFormat == PixelFormat.Format8bppIndexed)
                        {
                            image.Save(result.MultiFrames[pageIndex], System.Drawing.Imaging.ImageFormat.Png);//Save as PNG to preserve the BPP and resolutions; compatable with browser
                        }
                        else
                        {
                            Bitmap bmp = new Bitmap(image);
                            bmp.SetResolution(image.HorizontalResolution, image.VerticalResolution);//JPEG does not save the x and y resolutions unless we specifically request it; resolution is used in PDF to control page size
                            bmp.Save(result.MultiFrames[pageIndex], ImageFormat.Jpeg);
                        }
                    }
                    else
                    {
                        Bitmap bmp = new Bitmap(image);
                        bmp.SetResolution(image.HorizontalResolution, image.VerticalResolution);//JPEG does not save the x and y resolutions unless we specifically request it; resolution is used in PDF to control page size
                        bmp.Save(result.SingleFrame, ImageFormat.Jpeg);
                        bmp.Dispose();
                    }
                }
                return result;
            }
        }
        private const int kTiffTagLength = 12;
        private const int kHeaderSize = 2;
        private const int kMinimumTiffSize = 8;
        private const byte kIntelMark = 0x49;
        private const byte kMotorolaMark = 0x4d;
        private const ushort kTiffMagicNumber = 42;

        /// <summary>
        /// If we have a TIFF, get its page count
        /// </summary>
        /// <param name="s">a stream</param>
        /// <returns>-1 if we do not have a TIFF, or the TIFF's page count</returns>
        public static int GetPageCount(Stream s)
        {
            if (!IsTiff(s))
                return -1;

            var result = -1;
            try
            {
                using (var image = System.Drawing.Image.FromStream(s))
                {
                    result = image.GetFrameCount(System.Drawing.Imaging.FrameDimension.Page);
                }
            }
            catch (Exception ex)
            {
                var swallow = ex.Message;
            }
            return result;
        }

        private static bool IsTiff(Stream stm)
        {
            stm.Seek(0, SeekOrigin.Begin);
            if (stm.Length < kMinimumTiffSize)
                return false;
            byte[] header = new byte[kHeaderSize];

            stm.Read(header, 0, header.Length);

            if (header[0] != header[1] || (header[0] != kIntelMark && header[0] != kMotorolaMark))
                return false;
            bool isIntel = header[0] == kIntelMark;

            ushort magicNumber = ReadShort(stm, isIntel);
            if (magicNumber != kTiffMagicNumber)
                return false;
            return true;
        }

        private static ushort ReadShort(Stream stm, bool isIntel)
        {
            byte[] b = new byte[2];
            stm.Read(b, 0, b.Length);
            return ToShort(isIntel, b[0], b[1]);
        }

        private static ushort ToShort(bool isIntel, byte b0, byte b1)
        {
            if (isIntel)
            {
                return (ushort)(((int)b1 << 8) | (int)b0);
            }
            else
            {
                return (ushort)(((int)b0 << 8) | (int)b1);
            }
        }
    }
}
