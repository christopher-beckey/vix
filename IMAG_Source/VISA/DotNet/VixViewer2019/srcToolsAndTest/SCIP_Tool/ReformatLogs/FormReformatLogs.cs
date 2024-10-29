using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using System.Linq;
using System.Text;
using Ookii.Dialogs.WinForms;

namespace SCIP_Tool
{
    public partial class FormReformatLogs : Form
    {
        private string InputFolderPath = "";

        public FormReformatLogs()
        {
            InitializeComponent();
            ResetLabelInfo();
            this.lblInfo.Text = @"We will copy the folder and reformat the lines in the files so you can compare easier";
            //this.Width = 1054;
            //this.Height = 532;
            this.CenterToScreen();
        }

        #region Form Controls

        private void ButtonClose_Click(object sender, EventArgs e)
        {
            this.Close();
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
                Description = "Select folder with log files",
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

        private void ButtonReformat_Click(object sender, EventArgs e)
        {
            ButtonClose.Enabled = false;
            if (string.IsNullOrWhiteSpace(InputFolderPath))
            {
                UIError("Enter data in the folder text box.");
                return;
            }
            string OutputFolderPath = $"{InputFolderPath}-out";
            if (Directory.Exists(OutputFolderPath))
            {
                try
                {
                    Directory.Delete(OutputFolderPath);
                }
#pragma warning disable CS0168
                catch (Exception ex)
                {
                    AppendText($"Unable to remove output folder ({OutputFolderPath})");
                    return;
                }
#pragma warning restore CS0168
            }
            Directory.CreateDirectory(OutputFolderPath);
            foreach (FileInfo inFile in Directory.GetFiles(InputFolderPath, "*.*").Select(fn => new FileInfo(fn)).OrderBy(f => f.Name))
            {
                AppendText(inFile.Name);
                List<string> outLines = new List<string>();
                foreach (string inLine in File.ReadLines(inFile.FullName))
                {
                    string outLine = inLine;
                    if (inLine.Length > 0)
                    {
                        //Tomcat: [2020-12-30T12:12:43,090] DEBUG [http-nio-80-exec-10] - Site Number: null
                        //.NET:   [2020-12-30 12:12:43.3088 -06:00] [INFO] [Hydra.IX.Core.ImageWorkflow] [Group(s) marked for deletion.] {"GroupUid":"6f42eb47-8114-4f4d-aaa6-dc98125b61d0"}
                        int bracketPos1 = outLine.IndexOf(']');
                        if (bracketPos1 > 0)
                        {
                            string dateTime = outLine.Substring(0, bracketPos1);
                            if (dateTime.Length > 12)
                            {
                                if ((dateTime.Substring(11, 1) == "T") && char.IsDigit(dateTime, 10) && char.IsDigit(dateTime, 12))
                                {
                                    string remainderLine = outLine.Substring(bracketPos1 + 1, outLine.Length - bracketPos1 - 1);
                                    int bracketPos2 = remainderLine.IndexOf(']');
                                    if (bracketPos2 > 0)
                                        outLine = remainderLine.Substring(bracketPos2 + 1, remainderLine.Length - bracketPos2 - 1);
                                    else
                                        outLine = remainderLine;
                                }
                                else
                                {
                                    outLine = outLine.Substring(bracketPos1 + 1, outLine.Length - bracketPos1 - 1);
                                }
                            }
                        }
                        outLines.Add(outLine);
                    }
                }
                File.WriteAllLines(Path.Combine(OutputFolderPath, inFile.Name), outLines);
            }
            AppendText($"Done. Please see {OutputFolderPath}.");
            ButtonClose.Enabled = true;
        }

        public void AppendText(string format, params object[] args)
        {
            string text = string.Format(format, args);
            this.tbOutput.AppendText(text);
            this.tbOutput.AppendText(Environment.NewLine);
            if (format == "Done")
            {
                ButtonClose.Enabled = true;
                ButtonClose.Focus();
            }
            Application.DoEvents();
        }
    }
}
