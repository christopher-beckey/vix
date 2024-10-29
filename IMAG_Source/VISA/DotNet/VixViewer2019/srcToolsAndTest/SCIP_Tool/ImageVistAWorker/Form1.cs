using Hydra.IX.Common;
using Hydra.Log;
using Hydra.VistA;
using Ookii.Dialogs.WinForms;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Drawing;
using System.IO;
using System.Security.Principal;
using System.Windows.Forms;

using STCMN = SCIP_Tool.Common;

namespace ImageVistAWorker
{
    public partial class Form1 : Form
    {
        private string inputFolderPath;
        private string vixViewerConfigPath;
        //TODO private IDuplexTypedMessageSender<int, VistAWorkerData> mySender;

        public Form1()
        {
            InitializeComponent();
            ResetLabelInfo();
            this.StartPosition = FormStartPosition.CenterScreen;
            inputFolderPath = txtInputFolder.Text;
            vixViewerConfigPath = txtVixViewerConfigFile.Text;
        }

        private static bool IsElevated
        {
            get
            {
                return new WindowsPrincipal(WindowsIdentity.GetCurrent()).IsInRole(WindowsBuiltInRole.Administrator);
            }
        }

        private void btnFolderBrowse_Click(object sender, EventArgs e)
        {
            var directoryDialog = new VistaFolderBrowserDialog();
            directoryDialog.Description = "Select folder";
            directoryDialog.UseDescriptionForTitle = true;
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
                inputFolderPath = folderPath;
                this.txtInputFolder.Text = folderPath;
            }
            else
            {
                UIError($"{folderPath} does not exist");
            }
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void btnRun_Click(object sender, EventArgs e)
        {
            if (!IsElevated)
            {
                MessageBox.Show("You must run elevated for this function.");
                return;
            }

            //calls Hydra.VistA.VistAWorker.ProcessDisplayContext(VistAWorkerData data);

            //TODO
            //IMessagingSystemFactory aNamedPipeMessaging = new NamedPipeMessagingSystemFactory();
            //IDuplexOutputChannel anOutputChannel = aNamedPipeMessaging.CreateDuplexOutputChannel(txtNamedPipe.Text);

            //IDuplexTypedMessagesFactory aTypedMessagesFactory = new DuplexTypedMessagesFactory();
            //mySender = aTypedMessagesFactory.CreateDuplexTypedMessageSender<int, VistAWorkerData>();

            //mySender.ResponseReceived += OnResponseReceived;
            //mySender.AttachDuplexOutputChannel(anOutputChannel);

            // Create the message


            //From VistAWorker's Main in Program.cs - start
            VistAConfigurationSection.Initialize(vixViewerConfigPath);
            string logDirectory = Path.Combine(Environment.CurrentDirectory, "Log");
            string logLevel = "Debug";
            LogManager.Configuration = new LogConfiguration
            {
                LogFolder = logDirectory,
                LogFilePrefix = string.Format("Worker-0"),
                LogLevel = logLevel
            };
            MessageBox.Show("Run the VIX Viewer and Render Services as Admin if they are not yet started.");

            //string processGuid = "blahProcessGuid";
            //string uri = "blahUri";
            ILogger _Logger = LogManager.GetCurrentClassLogger();
            _Logger.Info("VistA Worker - Here we go!");
            //From VistAWorker's Main in Program.cs - end

            VistAWorker vistaWorker = new VistAWorker();
            VistAWorkerData vistAWorkerData = new VistAWorkerData();

            //vistAWorkerData.ImageRecords = AddDisplayObjects(imageGroupRecord.GroupUid, displayObjectGroup.Items);

            vistaWorker.Connect();
            //ImageGroupRecord imageGroupRecord = (new ImageGroupRecord
            //{
            //    GroupUid = "blahGroupUid",
            //    ParentGroupUid = "blahParentGroupUid",
            //    Name = "blahName",
            //    Children = null, //List<ImageGroupRecord>
            //    Images = AddDisplayObjects() //List<ImageRecord>
            //});
            IEnumerable<ImageRecord> imageRecords = AddDisplayObjects();
            VistAWorkerData vistaWorkerData = new VistAWorkerData {
                VixBaseUrl = "blahVixBaseUrl",
                VixFlavor = VixFlavor.Vix,
                ContextId = $"folder:{txtInputFolder.Text}",
                ImageRecords = imageRecords,
                SecurityToken = "blahSecurityToken",
                TransactionUid = "blahTransactionUid"
            };
            vistaWorker.ProcessDisplayContext(vistaWorkerData);

            // Send the message to the service.
            //            mySender.SendRequestMessage(vistAWorkerData);
        }

        //see VIX.Viewer.Service\VistAHydraParentContext.cs
        //private IEnumerable<ImageRecord> AddDisplayObjects(string imageGroupUid, List<DisplayObject> displayObjects)
        private IEnumerable<ImageRecord> AddDisplayObjects()
        {
            //var images = new List<NewImageData>();
            //DirectoryInfo dir = new DirectoryInfo(inputFolderPath);
            //FileInfo[] files = dir.GetFiles();
            //foreach (var imageFile in files)
            //{
            //    images.Add(new NewImageData
            //    {
            //        FileName = imageFile.Name,
            //        FileType = VixServiceUtil.DetectFileType(imageFile.Name),
            //        Description = "blah",
            //        ExternalImageId = "ImageIEN"
            //    });
            //}

            var imageRecords = new List<ImageRecord>();
            DirectoryInfo dir = new DirectoryInfo(inputFolderPath);
            FileInfo[] files = dir.GetFiles();
            foreach (var imageFile in files)
            {
                if (STCMN.GetFileType(imageFile.Name) != Hydra.Common.FileType.Unknown)
                    imageRecords.Add(new ImageRecord
                        {
                            ImageUid = imageFile.Name,
                            FileName = "file:" + imageFile.FullName,
                            IsUploaded = false
                        });
            }

            //TODO var hixConnection = HixConnectionFactory.Create();
            //TODO var newImageResponse = hixConnection.CreateImages("imageGroupUid", null, null, images, true);
            //var imageRecords = new List<ImageRecord>();
            //foreach (var newImage in newImageResponse)
            //{
            //    imageRecords.Add(new ImageRecord
            //    {
            //        ImageUid = newImage.ImageUid,
            //        FileName = newImage.FileName,
            //        IsUploaded = false
            //    });
            //}

            return imageRecords;
        }

        //private void Form1_FormClosed(object sender, FormClosedEventArgs e)
        //{
        //    mySender.DetachDuplexOutputChannel();
        //}

        //// When a result from the service is received, display it.
        //private void OnResponseReceived(object sender, TypedResponseReceivedEventArgs<int> e)
        //{
        //    if (e.ReceivingError == null)
        //    {
        //        // Display the result of the calculation.
        //        // Note: The response message does not come in the UI thread.
        //        //       Therefore, do not forget to route it if you touch UI controls.
        //        InvokeInUIThread(() => lblInfo.Text = e.ResponseMessage.ToString());
        //    }
        //}

        // Helper executing the given delegate in the UI thread.
        private void InvokeInUIThread(Action action)
        {
            // If we are not in the UI thread then we must synchronize 
            // via the invoke mechanism.
            if (InvokeRequired)
            {
                Invoke(action);
            }
            else
            {
                action();
            }
        }

        private void btnBrowseVVConfigFile_Click(object sender, EventArgs e)
        {
            var fileDialog = new VistaOpenFileDialog();
            fileDialog.InitialDirectory = "";
            fileDialog.Multiselect = false;
            fileDialog.CheckFileExists = true;
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
                    txtVixViewerConfigFile.Text = fileDialog.FileName;
                    vixViewerConfigPath = txtVixViewerConfigFile.Text;
                }
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            if (!IsElevated)
            {
                MessageBox.Show("You must run elevated for this function.");
                return;
            }
            vixViewerConfigPath = txtVixViewerConfigFile.Text;
        }
    }
}
