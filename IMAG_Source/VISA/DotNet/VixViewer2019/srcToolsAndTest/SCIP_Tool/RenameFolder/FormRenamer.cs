using System;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using Ookii.Dialogs.WinForms;
using System.Linq;

namespace SCIP_Tool
{
    public partial class FormRenamer : Form
    {
        private string StartFileNumber = "";
        private string InputFolderPath = "";

        public FormRenamer()
        {
            InitializeComponent();
            ResetLabelInfo();
            this.lblInfo.Text = @"Example: Files to rename are in folder A, and the starting file number is the first N in VixCache\N-REFERENCE-application%2fdicom or VixRenderCache\N_ABS.jpeg" + Environment.NewLine + "Recommend backing up folder A first";
            //this.Width = 1054;
            //this.Height = 532;
            this.CenterToScreen();
        }

        #region Form Controls

        private void ButtonClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void TextStartFileNumber_TextChanged(object sender, EventArgs e)
        {
            StartFileNumber = TextStartFileNumber.Text;
            ResetLabelInfo();
        }

        private void ButtonCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }
        #endregion Form Controls

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
                InputFolderPath = folderPath;
                this.TextInputFolder.Text = folderPath;
                ResetLabelInfo();
                //JpegOutputFolderPath = GetUniquePath(Path.Combine(Path.GetTempPath(), "JpegConvert"));
            }
            else
            {
                UIError($"{folderPath} does not exist");
            }
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

        private void TextInputFolder_TextChanged(object sender, EventArgs e)
        {
            CheckAndSetInputFolder(TextInputFolder.Text);
        }

        private void ButtonRename_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(StartFileNumber) || string.IsNullOrWhiteSpace(InputFolderPath))
            {
                UIError("Enter data in the folder and file number text boxes.");
                return;
            }
            //VixCache (Tomcat) example: folderPath\221302343-REFERENCE-application%2fdicom
            //VixRenderCache example: folderPath\5141_ABS.jpeg
            DirectoryInfo dir = new DirectoryInfo(InputFolderPath);
            string firstFileName = dir.GetFiles().Select(fi => fi.Name).FirstOrDefault();
            if (firstFileName.Contains("%2f"))
                RenameTomcat(firstFileName);
            else
                RenameRender(firstFileName);
            lblInfo.Text = "Done";
        }

        private void RenameTomcat(string basisFileName)
        {
            int fileNumber = 0;
            string[] parts = basisFileName.Split('-');
            try
            {
                fileNumber = Int32.Parse(StartFileNumber);
            }
            catch (FormatException ex)
            {
                UIError($"Cannot parse file name ({basisFileName}): " + ex.Message);
            }
            if (fileNumber == 0) return;
            foreach (FileInfo file in Directory.GetFiles(InputFolderPath, "*.*").Select(fn => new FileInfo(fn)).OrderBy(f => f.Name))
            {
                parts = file.Name.Split('-');
                string tempPath = Path.Combine(InputFolderPath, $"{fileNumber}-{parts[1]}-{parts[2]}");
                file.MoveTo(tempPath);
                if (file.Extension.Contains("checksum")) fileNumber++;
            }
        }

        private void RenameRender(string basisFileName)
        {
            int fileNumber = 0;
            string[] parts = basisFileName.Split('_');
            try
            {
                fileNumber = Int32.Parse(StartFileNumber);
            }
            catch (FormatException ex)
            {
                UIError("Cannot parse file name ({basisFileName}): " + ex.Message);
            }
            if (fileNumber == 0) return;
            foreach (FileInfo file in Directory.GetFiles(InputFolderPath, "*.*").Select(fn => new FileInfo(fn)).OrderBy(f => f.Name))
            {
                if (!file.Extension.Contains("_ABS.")) fileNumber++;
                parts = file.Name.Split('_');
                string tempPath = Path.Combine(InputFolderPath, $"{fileNumber}_{parts[1]}");
                file.MoveTo(tempPath);
            }
        }
    }
}
