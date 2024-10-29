using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using FH = MockService.Common.FileHelper;
using GLOB = MockService.Common.Globals;

namespace MockService.Controllers
{
    public class ImportController : Controller
    {
        public ActionResult Select()
        {
            @ViewBag.RootViewerURL = GLOB.rootViewerURL;
            @ViewBag.Message = TempData["msg"];
            return View();
        }

        /// <summary>
        /// ImportStockImage()
        /// Implements XML template 
        /// </summary>
        /// <param name="ImageType"></param>
        /// <returns></returns> 
        public ActionResult ImportStockImage(string ImageType)
        {
            string sourceFile = $@"{GLOB.responseXmlFolder}{ImageType}\GetStudyMetadata.xml";
            string destFile = $"{GLOB.responseXmlFolder}GetStudyMetadata.xml";
            if (FH.CopyFile(sourceFile, destFile, out string msg))
            {
                TempData["msg"] = $"Selected {sourceFile}";
                if (!FH.CopyImageFolders(out msg))
                    TempData["msg"] = msg;
            }
            else
            {
                TempData["msg"] = $"ERROR: {msg}";
            }
            return RedirectToAction("Select", "Import");
        }
        public ActionResult ImportFile()
        {
            @ViewBag.RootViewerURL = GLOB.rootViewerURL;

            ViewBag.fileList =  Directory.GetFiles(GLOB.imageSourceFolder).ToList();
            if (ViewBag.fileList.Count == 0)
            {
                ViewBag.fileList = new List<string>(new string[] {"No image files have been uploaded."});
            }
            return View();
        }
        [HttpPost]
        public ActionResult ImportFile(HttpPostedFileBase file)
        {
            if(file==null) return View();
            try
            {
                createFolders();
                if (file.ContentLength > 0)
                {
                    string fileName = Path.GetFileName(file.FileName);
                    string fullFileName = Path.Combine(GLOB.imageSourceFolder, fileName);
                    fullFileName = Path.Combine(GLOB.imageSourceFolder, fileName);
                    if (fullFileName.ToLower().Contains(".rtf")) fullFileName = fullFileName.ToUpper() + ".pdf"; //RTF files need an extension of PDF for VixRender to work
                    file.SaveAs(fullFileName);
                }
               
                ViewBag.fileList = Directory.GetFiles(GLOB.imageSourceFolder).ToList();
                ViewBag.Message = $"{ViewBag.fileList.Count} File(s) have been successfully uploaded so far";
                return View();
            }
            catch
            {
                ViewBag.fileList = Directory.GetFiles(GLOB.imageSourceFolder).ToList();
                ViewBag.Message = "File upload failed!";
                return View();
            }
        }
        public ActionResult ToViewer( )
        {
           @ViewBag.RootViewerURL = GLOB.rootViewerURL;
           mergeTemplate();
           return View();
        }
        public ActionResult DeleteUploadedImages( )
        {
            string[] sourceFileEntries = Directory.GetFiles(GLOB.imageSourceFolder);
            foreach (string fullFileName in sourceFileEntries)
            {
                System.IO.File.Delete(fullFileName);
            }
            return RedirectToAction("ImportFile", "Import"); 
        }

        /// <summary>
        /// mergeTemplate()
        /// Builds XML template based on selections ( TODO )
        /// </summary>
        /// <param name="siteNumber, icn, subFolder"></param>
        /// <returns></returns> 
        private void mergeTemplate() 
        {
            //TODO Replace these static values with the active ones
            // for now the goal is to display the standard images without haveing to have the correct information
           mergeXMLTemplates(GLOB.defaultImageCacheFolder);
        }

        /// <summary>
        /// mergeXMLTemplates()
        /// Build the XML template based on selections
        /// </summary>
        /// <param name="outputFolder">The full path to store the "image" file(s)</param>
        /// <returns></returns> 
        private void mergeXMLTemplates(string outputFolder)
        {
            string templateFolder = $@"{GLOB.responseXmlFolder}Templates\";
            string templateBodies = string.Empty;

            if (!Directory.Exists(templateFolder)) Directory.CreateDirectory(templateFolder);

            string[] sourceFileEntries = Directory.GetFiles(GLOB.imageSourceFolder);
            if (sourceFileEntries.Length < 1)
            {
                ViewBag.Message = "Error: You need to upload some files before you can merge them.";
                return;
            }

            foreach (string fullFileName in sourceFileEntries)
            {
                string destFileName = Path.Combine(outputFolder, Path.GetFileName(fullFileName));
                System.IO.File.Copy(fullFileName, destFileName, true);
            }
            ViewBag.Message = "";

            string templateHeader = "";
            string templateFile = templateFolder + @"Header.xml";
            if (System.IO.File.Exists(templateFile))
            {
                templateHeader = System.IO.File.ReadAllText(templateFile);
            }

            string templateBody = "";
            templateFile = templateFolder + @"Body.xml";
            if (System.IO.File.Exists(templateFile))
            {
                templateBody = System.IO.File.ReadAllText(templateFile);
            }
            string templateFooter = "";
            templateFile = templateFolder + @"Footer.xml";
            if (System.IO.File.Exists(templateFile))
            {
                templateFooter = System.IO.File.ReadAllText(templateFile);
            }

            string destResponseFile = $@"{GLOB.responseXmlFolder}GetStudyMetadata.xml";
            if (System.IO.File.Exists(destResponseFile)) System.IO.File.Delete(destResponseFile);

            List<string> fileNameList = new List<string>();
            string[] fileEntries = Directory.GetFiles(GLOB.imageSourceFolder);  
            int fileCount = 0;
            foreach (string fullFileName in fileEntries)
            {
                string fileName = Path.GetFileName(fullFileName);
                string currentBody = templateBody.Replace("FILE_NAME", fileName);
                bool found = true;
                currentBody = currentBody.Replace("FILE_DESCRIPTION", fileName);

                string extension = Path.GetExtension(fileName).ToUpper();
                switch (extension)
                {
                    case ".JPG":
                        currentBody = currentBody.Replace("CONTENT_TYPE", "image/jpeg");
                        break;
                    case ".TIF":
                    case ".TIFF":
                        currentBody = currentBody.Replace("CONTENT_TYPE", "image/tiff");
                        break;
                    case ".BMP":
                        currentBody = currentBody.Replace("CONTENT_TYPE", "image/bmp");
                        break;
                    case ".PNG":
                        currentBody = currentBody.Replace("CONTENT_TYPE", "image/png");
                        break;
                    case ".DCM":
                    case "DICOM":
                      
                        currentBody = currentBody.Replace("CONTENT_TYPE", "application/dicom");
                        break;
                    case ".PDF":
                        if(!fileName.ToLower().Contains(".rtf.pdf"))currentBody = currentBody.Replace("CONTENT_TYPE", "image/pdf");//Work around for issue in Vix.Render that requires a PDF extension on RTF files
                        else currentBody = currentBody.Replace("CONTENT_TYPE", "text/rtf");
                        break;
                    case ".GIF":
                        currentBody = currentBody.Replace("CONTENT_TYPE", "image/gif");
                        break;
                    case ".RTF":                      
                        currentBody = currentBody.Replace("CONTENT_TYPE", "text/rtf");
                        break;
                    default:
                        found = false;
                        break;
                }
                if (found)
                {
                    templateBodies = templateBodies + currentBody;
                    fileCount++;
                    fileNameList.Add(fileName);
                }
            }
            System.IO.File.WriteAllText(destResponseFile, templateHeader + templateBodies + templateFooter);
            if(fileCount>0) ViewBag.fileList = fileNameList;
            ViewBag.Message = $"{ViewBag.Message} {fileCount} Image files imported from {GLOB.imageSourceFolder}";
        }
        private void createFolders() 
        {             
            if (!Directory.Exists(GLOB.imageUploadFolder))
                   Directory.CreateDirectory(GLOB.imageUploadFolder);

            if (!Directory.Exists(GLOB.defaultImageCacheFolder))
            {
                ViewBag.Status = $@"Please copy the XML\ImagesToImport\*.* to {GLOB.defaultImageCacheFolder}";
                Directory.CreateDirectory(GLOB.defaultImageCacheFolder);
            }
            else ViewBag.Status = "";
        }
    }
}