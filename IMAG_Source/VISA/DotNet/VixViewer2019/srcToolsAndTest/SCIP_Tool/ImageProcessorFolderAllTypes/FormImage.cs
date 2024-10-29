using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using Ookii.Dialogs.WinForms;
using Hydra.Dicom;

namespace SCIP_Tool
{
    public partial class FormImage : Form
    {
        private const int DEFAULT_RUNS = 1;
        private const int MAX_RUNS = 1000;
        private const int MAX_PDF_PAGES_DEFAULT = 300;

        private readonly Dictionary<string, long> totals = new Dictionary<string, long>();
        private readonly Dictionary<string, long> fileCounts = new Dictionary<string, long>();

        private string InputFolderPath = "";
        private string logFilePath = "";
        private readonly StringBuilder sb = new StringBuilder();

        /// <summary>
        /// Convert a VixCache file to a VixRenderCache file
        /// </summary>
        /// <remarks>
        /// The production code goes thru a lot of hoops to get the VIX Java file into an .org (original) file in the VixRenderCache\images folder,
        /// then it calls ProcessImage. This form is bypassing all those hoops so that's why it cannot deal with the imageURN (see GetFileType).
        /// So, we can call ProcessImage here with the VixCache file, such as xxxx%2fdicom, and it still works.
        /// </remarks>
        public FormImage()
        {
            InitializeComponent();
            ResetLabelInfo();
            //TextJpegFolder.Text = @"C:\Users\OITCANSTREBC0\Desktop\DICOM\250test0";
            tbRuns.Text = "1";
            ButtonFolderBrowse.Top = TextInputFolder.Top;
            //this.Width = 1054;
            //this.Height = 532;
            this.CenterToScreen();
            totals.Add("Tiff", 0);
            totals.Add("Jpeg", 0);
            totals.Add("Dicom", 0);
            totals.Add("RTF", 0);
            totals.Add("TXT", 0);
            fileCounts.Add("Tiff", 0);
            fileCounts.Add("Jpeg", 0);
            fileCounts.Add("Dicom", 0);
            fileCounts.Add("RTF", 0);
            fileCounts.Add("TXT", 0);
        }

        #region Form Controls

        private void ButtonClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void TextFolder_TextChanged(object sender, EventArgs e)
        {
            CheckAndSetInputFolder(TextInputFolder.Text);
        }

        private void ButtonConvert_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(InputFolderPath))
            {
                UIError("Please enter or browse to a folder containing image files");
            }
            else
            {
                Convert();
            }
        }


        private void ButtonFolderBrowse_Click(object sender, EventArgs e)
        {
            var directoryDialog = new VistaFolderBrowserDialog
            {
                Description = "Select folder with Jpeg files",
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

        private void ButtonCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
        #endregion Form Controls

        private void Convert()
        {
            ResetLabelInfo();
            totals["Tiff"] = 0;
            totals["Jpeg"] = 0;
            totals["Dicom"] = 0;
            totals["RTF"] = 0;
            totals["TXT"] = 0;
            fileCounts["Tiff"] = 0;
            fileCounts["Jpeg"] = 0;
            fileCounts["Dicom"] = 0;
            fileCounts["RTF"] = 0;
            fileCounts["TXT"] = 0;
            ResetLabelInfo();
            var runs = GetNumberOfRuns();
            logFilePath = Path.Combine(InputFolderPath, DateTime.Now.ToString("yyyyddMHHmm") + ".log");
            for (var i = 1; i <= runs; i++)
            {
                if (runs == 1) AppendText($"Output is in {InputFolderPath}.out{Environment.NewLine}");
                if (runs > 1) AppendText($"Run #{i}{Environment.NewLine}");
                ConvertFiles();
            }
            if (runs > 1)
            {
                if (totals["Tiff"] != 0) AppendText("Average JPG: {0} ms ({1} secs){2}", totals["Tiff"] / runs, totals["Tiff"] / runs / 1000, Environment.NewLine);
                if (totals["Jpeg"] != 0) AppendText("Average JPG: {0} ms ({1} secs){2}", totals["Jpeg"] / runs, totals["Jpeg"] / runs / 1000, Environment.NewLine);
                if (totals["Dicom"] != 0) AppendText("Average DICOM: {0} ms ({1} secs){2}", totals["Dicom"] / runs, totals["Dicom"] / runs / 1000, Environment.NewLine);
                if (totals["RTF"] != 0) AppendText("Average RTF: {0} ms ({1} secs){2}", totals["RTF"] / runs, totals["RTF"] / runs / 1000, Environment.NewLine);
                if (totals["TXT"] != 0) AppendText("Average TXT: {0} ms ({1} secs){2}", totals["TXT"] / runs, totals["TXT"] / runs / 1000, Environment.NewLine);
            }
            else
            {
                if (totals["Tiff"] != 0) AppendText("Average TIFF to JPG: {0} ms ({1} secs){2}", totals["Tiff"] / fileCounts["Tiff"], totals["Tiff"] / fileCounts["Tiff"] / 1000, Environment.NewLine);
                if (totals["Jpeg"] != 0) AppendText("Average JPG: {0} ms ({1} secs){2}", totals["Jpeg"] / fileCounts["Jpeg"], totals["Jpeg"] / fileCounts["Jpeg"] / 1000, Environment.NewLine);
                if (totals["Dicom"] != 0) AppendText("Average DICOM: {0} ms ({1} secs){2}", totals["Dicom"] / fileCounts["Dicom"], totals["Dicom"] / fileCounts["Dicom"] / 1000, Environment.NewLine);
                if (totals["RTF"] != 0) AppendText("Average RTF: {0} ms ({1} secs){2}", totals["RTF"] / fileCounts["RTF"], totals["RTF"] / fileCounts["RTF"] / 1000, Environment.NewLine);
                if (totals["TXT"] != 0) AppendText("Average TXT: {0} ms ({1} secs){2}", totals["TXT"] / fileCounts["TXT"], totals["TXT"] / fileCounts["TXT"] / 1000, Environment.NewLine);
            }
            AppendText("Done{0}", Environment.NewLine);
            ButtonClose.Enabled = true;
        }

        private void ConvertFiles()
        {
            var converting = "JPEG";
            AppendText($"Input Folder: {InputFolderPath} to {converting}{Environment.NewLine}");
            var watch = new System.Diagnostics.Stopwatch();
            //******************************************** MUST SYNC GetFiles() AND GetFileType()  **************************************************
            foreach (var fileName in GetFiles(InputFolderPath))
            {
                if (fileName.Contains("-REFERENCE-text%2fdicom"))
                    continue;
                watch.Start();
                Hydra.Common.FileType fileType = Common.GetFileType(fileName);
                Hydra.Common.IFileStorage fileStorage = new Hydra.Common.DefaultFileStorage();
                Hydra.Dicom.IStudyBuilder studyBuilder = null; // new StudyBuilder(imageGroup, imageFile.StudyId, HixService.Instance.ServiceMode == HixServiceMode.Worker);
                Directory.CreateDirectory(InputFolderPath + ".out");
#pragma warning disable IDE0059 //Unnecessary assignment of a value
                ImageProcessor.TempFolder = Path.GetTempPath();
                //******************************************** THIS RUNS THE ACTUAL PRODUCTION CODE  **************************************************
                ImageProcessResultset resultset = ImageProcessor.ProcessImage(Path.Combine(InputFolderPath, fileName), "", fileType, InputFolderPath + ".out", fileStorage, studyBuilder);
#pragma warning restore IDE0059
                watch.Stop();
                AppendText("{0}: {1} ms ({2} secs){3}", fileName, watch.ElapsedMilliseconds, watch.ElapsedMilliseconds / 1000, Environment.NewLine);
                if ((fileName.Substring(fileName.Length - 4) == "tiff") || (fileName.Substring(fileName.Length - 3) == "tif"))
                {
                    totals["Tiff"] += watch.ElapsedMilliseconds;
                    fileCounts["Tiff"] += 1;
                }
                else if (fileName.Substring(fileName.Length - 4) == "jpeg")
                {
                    totals["Jpeg"] += watch.ElapsedMilliseconds;
                    fileCounts["Jpeg"] += 1;
                }
                else
                {
                    totals["Dicom"] += watch.ElapsedMilliseconds;
                    fileCounts["Dicom"] += 1;
                }
            }
        }

        private static IEnumerable<string> GetFiles(string inputFolderPath)
        {
            //Doesn't work on my Windows 10 64-bit with .Net 4.5
            //var ext = new List<string> { "tif", "Jpeg" };
            //var myFiles = Directory
            //    .EnumerateFiles(inputFolderPath, "*.*", SearchOption.AllDirectories)
            //    .Where(s => ext.Contains(Path.GetExtension(s).ToLowerInvariant()));

            //We read in Tomcat VixCache files that do not have a Windows extension, but whose file names end with %2fTYPE
            var myFiles = Directory.GetFiles(inputFolderPath, "*.*", SearchOption.AllDirectories)
            .Where(s => s.EndsWith(".org", StringComparison.Ordinal) ||
                     s.EndsWith("%2fdicom", StringComparison.Ordinal) ||
                     s.EndsWith("%2fj2k", StringComparison.Ordinal) ||
                     s.EndsWith("%2fjpeg", StringComparison.Ordinal) ||
                     s.EndsWith("%2fpdf", StringComparison.Ordinal) ||
                     s.EndsWith("%2frtf", StringComparison.Ordinal) ||
                     s.EndsWith("%2ftif", StringComparison.Ordinal) ||
                     s.EndsWith("%2ftiff", StringComparison.Ordinal) ||
                     s.EndsWith("%2fx", StringComparison.Ordinal));
            return myFiles;
        }

        public void AppendText(string format, params object[] args)
        {
            sb.AppendFormat(format, args);
            LogTheLine(string.Format(format, args));
            this.tbOutput.Text = sb.ToString();
            if (format == "Done")
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

        private bool AtLeastOneImageFile(string folderPath)
        {
            var myFiles = GetFiles(folderPath);
            return (myFiles.Count() > 0);
        }

        private void ResetLabelInfo()
        {
            this.lblInfo.Text = "";
            this.lblInfo.ForeColor = Color.Black;
        }

        private void UIError(string msg)
        {
            this.lblInfo.Text = msg;
            this.lblInfo.ForeColor = Color.Red;
        }

        private void CheckAndSetInputFolder(string folderPath)
        {
            if (Directory.Exists(folderPath))
            {
                if (AtLeastOneImageFile(folderPath))
                {
                    InputFolderPath = folderPath;
                    this.TextInputFolder.Text = folderPath;
                    ResetLabelInfo();
                    //JpegOutputFolderPath = GetUniquePath(Path.Combine(Path.GetTempPath(), "JpegConvert"));
                }
                else
                {
                    UIError($"There are no image files in {folderPath}.  Are you sure your files end in %2fTYPE (such as %2fdicom)?");
                }
            }
            else
            {
                UIError($"{folderPath} does not exist");
            }
        }

        private int GetNumberOfRuns()
        {
            var result = DEFAULT_RUNS;
            try
            {
                int num = System.Convert.ToInt32(tbRuns.Text);
                if (num > MAX_RUNS) tbRuns.Text = MAX_RUNS.ToString();
                result = num;
            }
            catch (Exception e)
            {
                tbRuns.Text = DEFAULT_RUNS.ToString();
                LogTheLine(e.ToString());
            }
            return result;
        }
    }
}
