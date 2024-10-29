/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */


namespace DicomImporter.ViewModels
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.IO;
    using System.Net;
    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.Model;
    using ImagingClient.Infrastructure.Storage.Model;
    using ImagingClient.Infrastructure.StorageDataSource;
    using ImagingClient.Infrastructure.Utilities;
    using ImagingClient.Infrastructure.ViewModels;
    using log4net;
    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// The dicom viewer launcher view model.
    /// </summary>
    public class DicomViewerLauncherViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The viewer exe path win 7.
        /// </summary>
        private const string ViewerExePathWin7 = @"C:\Program Files (x86)\Vista\Imaging\DCMView\MAG_DCMView.exe";

        /// <summary>
        /// The viewer exe path win xp.
        /// </summary>
        private const string ViewerExePathWinXP = @"C:\Program Files\Vista\Imaging\DCMView\MAG_DCMView.exe";

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(DicomViewerLauncherViewModel));

        /// <summary>
        /// The importer temp folder.
        /// </summary>
        private readonly string importerTempFolder =
            Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "Importer");

        /// <summary>
        /// The working directory for the viewer: Either the temp directory root if staged, or the media root
        /// if not staged.
        /// </summary>
        private string workingDirectory;

        /// <summary>
        /// The actual viewer path.
        /// </summary>
        private string actualViewerPath = string.Empty;

        /// <summary>
        /// The selected series.
        /// </summary>
        private Series selectedSeries;

        /// <summary>
        /// The selected study.
        /// </summary>
        private Study selectedStudy;
        
        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="DicomViewerLauncherViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        /// <param name="storageDataSource">
        /// The storage data source.
        /// </param>
        public DicomViewerLauncherViewModel(
            IDialogService dialogService, 
            IDicomImporterDataSource dicomImporterDataSource, 
            IStorageDataSource storageDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;
            this.StorageDataSource = storageDataSource;

            this.ProgressViewModel = new ProgressViewModel();

            this.LaunchViewerCommand = new DelegateCommand<object>(
                o => this.ShowViewerWindow(), o => this.CanLaunchViewer());
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets AnyImagesSelected.
        /// </summary>
        public string AnyImagesSelected { get; set; }

        /// <summary>
        /// Gets or sets InstanceRange.
        /// </summary>
        public string InstanceRange { get; set; }

        /// <summary>
        /// Gets or sets LaunchViewerCommand.
        /// </summary>
        public DelegateCommand<object> LaunchViewerCommand { get; set; }

        /// <summary>
        /// Gets NetworkLocationInfo.
        /// </summary>
        public NetworkLocationInfo NetworkLocationInfo
        {
            get
            {
                return this.StorageDataSource.GetNetworkLocationDetails(this.WorkItemDetails.NetworkLocationIen);
            }
        }

        /// <summary>
        /// Gets or sets Patient.
        /// </summary>
        public Patient Patient { get; set; }

        /// <summary>
        /// Gets or sets ProgressViewModel.
        /// </summary>
        public ProgressViewModel ProgressViewModel { get; set; }

        /// <summary>
        /// Gets or sets SelectedSeries.
        /// </summary>
        public Series SelectedSeries
        {
            get
            {
                return this.selectedSeries;
            }

            set
            {
                this.selectedSeries = value;
                this.InstanceRange = "1";
            }
        }

        /// <summary>
        /// Gets or sets SelectedStudy.
        /// </summary>
        public Study SelectedStudy
        {
            get
            {
                return this.selectedStudy;
            }

            set
            {
                this.selectedStudy = value;
                if ((this.SelectedStudy != null) && (this.SelectedStudy.Series != null) && (this.SelectedStudy.Series.Count > 0))
                {
                    this.SelectedSeries = this.SelectedStudy.Series[0];
                }
                this.InstanceRange = "1";
            }
        }

        /// <summary>
        /// Gets or sets ViewerProcess.
        /// </summary>
        public Process ViewerProcess { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// The cancel background work.
        /// </summary>
        public void CancelBackgroundWork()
        {
            if (this.Worker != null)
            {
                this.Worker.CancelAsync();
            }
        }

        /// <summary>
        /// The delete temp files.
        /// </summary>
        public void DeleteTempFiles()
        {
            try
            {
                // Delete the temp files
                if (Directory.Exists(this.importerTempFolder))
                {
                    Directory.Delete(this.importerTempFolder, true);
                }
            }
            catch (Exception e)
            {
                Logger.Error("Unable to delete the temporary importer directory: " + e.Message, e);
            }
        }

        /// <summary>
        /// The get selected sop instances.
        /// </summary>
        /// <returns>A collection containing the selected SOP Instances
        /// </returns>
        public List<SopInstance> GetSelectedSopInstances()
        {
            return this.InstanceRange.Contains("-") ? this.GetSopInstanceRange() : this.GetSingleSopInstance();
        }

        /// <summary>
        /// The show viewer window.
        /// </summary>
        public void ShowViewerWindow()
        {
            this.Worker = new BackgroundWorker { WorkerSupportsCancellation = true };
            this.Worker.DoWork += this.ShowViewerWindow;
            this.Worker.RunWorkerCompleted += this.ViewerWindowClosed;
            this.Worker.RunWorkerAsync();
        }

        /// <summary>
        /// The show viewer window.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public void ShowViewerWindow(object sender, DoWorkEventArgs e)
        {
            // Disable the launch button
            this.LaunchViewerCommand.RaiseCanExecuteChanged();

            // First, check to see the viewer exists on the machine
            if (!this.ViewerExists())
            {
                return;
            }

            // The viewer exists, so continue. Get the selected SOPInstance objects
            List<SopInstance> selectedInstances = this.GetSelectedSopInstances();

            if (selectedInstances != null && selectedInstances.Count > 0)
            {
                // Get the file names and relative paths for the selected instances
                List<string> fileNames = this.GetFileNameList(selectedInstances);

                // Build the list of filenames to pass to the executable
                string filePathsArgument = this.BuildFilePathsArgument(fileNames);

                // Get the length of the entire command line, so we can verify it doesn't exceed the max
                int commandLineLength = filePathsArgument.Length + this.actualViewerPath.Length;

                // File name and arguments together cannot exceed 8192 characters
                if (commandLineLength > 8192)
                {
                    string message =
                        "There are too many instances in the range you have selected. Please select a smaller range of instances to view";
                    string caption = "Too Many Instances Selected";
                    this.DialogService.ShowAlertBox(OwningWindow, this.UIDispatcher, message, caption, MessageTypes.Error);
                }
                else
                {
                    if (this.WorkItem.WorkItemDetails.IsMediaBundleStaged)
                    {
                        // The media bundle is staged. Set the working directory and
                        // and copy the files locally
                        this.SetWorkingDirectoryAndCopyFilesLocally(selectedInstances);
                    }
                    else
                    {
                        // File not staged. Just set the working directory to the local root path.
                        this.workingDirectory = WorkItemDetails.LocalSourcePath;
                    }

                    var psi = new ProcessStartInfo(this.actualViewerPath);
                    psi.UseShellExecute = false;
                    psi.Arguments = filePathsArgument;
                    psi.WorkingDirectory = this.workingDirectory;
                    this.ViewerProcess = Process.Start(psi);

                    // Subscribes to the Logout Event
                    this.eventAggregator.GetEvent<NewUserLoginEvent>().Subscribe(CloseViewerWindow);
                   
                    // Wait for the viewer to exit
                    this.ViewerProcess.WaitForExit();
                }
            }
        }

        /// <summary>
        /// Check the XP and Win 7 paths to see if the viewer is installed.
        /// </summary>
        /// <returns>
        /// Returns <c>true</c> if the viewer is found, otherwise <c>false</c>.
        /// </returns>
        public bool ViewerExists()
        {
            // Check for both the Windows XP path and the Windows path.
            if (File.Exists(ViewerExePathWinXP))
            {
                this.actualViewerPath = ViewerExePathWinXP;
            }
            else if (File.Exists(ViewerExePathWin7))
            {
                this.actualViewerPath = ViewerExePathWin7;
            }

            // If it was not found in either place, throw an error.
            bool viewerExists = !string.IsNullOrEmpty(this.actualViewerPath);
            if (!viewerExists)
            {
                string message = "Could not find the DICOM viewer at either \n  '" + ViewerExePathWinXP + "' or \n  '"
                                 + ViewerExePathWin7 + "'.";
                string caption = "DICOM Viewer Not Found";
                this.DialogService.ShowAlertBox(OwningWindow, this.UIDispatcher, message, caption, MessageTypes.Error);
            }

            return viewerExists;
        }

        /// <summary>
        /// The viewer window closed.
        /// </summary>
        /// <param name="o">
        /// The o.
        /// </param>
        /// <param name="args">
        /// The args.
        /// </param>
        public void ViewerWindowClosed(object o, RunWorkerCompletedEventArgs args)
        {
            // Null out the process
            this.ViewerProcess = null;

            // Delete temp files
            this.DeleteTempFiles();

            // Unsubscribes from the Logout Event
            this.eventAggregator.GetEvent<LogoutEvent>().Unsubscribe(CloseViewerWindow);

            // Enable the launch button
            this.LaunchViewerCommand.RaiseCanExecuteChanged();
        }

        #endregion

        #region Methods

        /// <summary>
        /// The network copy.
        /// </summary>
        /// <param name="copyInfoList">
        /// The copy info list.
        /// </param>
        /// <param name="networkLocationInfo">
        /// The network location info.
        /// </param>
        protected void NetworkCopy(List<CopyInfo> copyInfoList, NetworkLocationInfo networkLocationInfo)
        {
            string serverAndShare = networkLocationInfo.PhysicalPath;

            NetworkConnection conn = null;
            this.ProgressViewModel.IsWorkInProgress = true;

            int totalFiles = copyInfoList.Count;

            // Reset the progress bar for the file copying operation
            this.ProgressViewModel.IsIndeterminate = false;
            this.ProgressViewModel.Maximum = totalFiles + 1;
            this.ProgressViewModel.Minimum = 0;
            this.ProgressViewModel.Value = 1;
            this.ProgressViewModel.Text = "Preparing to copy files...";

            try
            {
                conn = NetworkConnection.GetNetworkConnection(
                    serverAndShare, new NetworkCredential(networkLocationInfo.Username, networkLocationInfo.Password));

                // Cancel if requested
                if (this.Worker != null && this.Worker.CancellationPending)
                {
                    return;
                }

                int currentFile = 1;

                // Copy over all the images
                foreach (CopyInfo copyInfo in copyInfoList)
                {
                    this.ProgressViewModel.Text = "Copying file " + currentFile++ + " of " + totalFiles + ": "
                                                  + copyInfo.DestinationFile;

                    var f = new FileInfo(copyInfo.DestinationFile);
                    if (f.Directory != null && !f.Directory.Exists)
                    {
                        f.Directory.Create();
                    }

                    // If the file already exists, delete it first
                    if (File.Exists(copyInfo.DestinationFile))
                    {
                        File.SetAttributes(copyInfo.DestinationFile, FileAttributes.Normal);
                        File.Delete(copyInfo.DestinationFile);
                    }

                    RetryUtility.RetryAction(() => File.Copy(copyInfo.SourceFile, copyInfo.DestinationFile));
                    File.SetAttributes(copyInfo.DestinationFile, FileAttributes.Normal);

                    // Increment the progressbar
                    this.ProgressViewModel.Value++;

                    // Cancel if requested
                    if (this.Worker != null && this.Worker.CancellationPending)
                    {
                        return;
                    }
                }
            }
            catch (Exception e)
            {
                string message = "Error copying files: " + e.Message;
                string caption = "Error Copying Files";
                this.DialogService.ShowAlertBox(OwningWindow, this.UIDispatcher, message, caption, MessageTypes.Error);

                // Log the exception
                Logger.Error(message, e);

                if (this.Worker != null)
                {
                    this.Worker.CancelAsync();
                }
            }
            finally
            {
                if (conn != null)
                {
                    conn.Dispose();
                }

                this.ProgressViewModel.IsWorkInProgress = false;
            }

            // Cancel if requested
            if (this.Worker != null && this.Worker.CancellationPending)
            {
                return;
            }
        }

        /// <summary>
        /// Returns a string containing all the file paths of the images to viewe, 
        /// to be used for the command argument.
        /// </summary>
        /// <param name="filePaths">
        /// The file paths.
        /// </param>
        /// <returns>
        /// The string containing the concatenated file paths.
        /// </returns>
        private string BuildFilePathsArgument(List<string> filePaths)
        {
            string filePathsArgument = string.Empty;

            foreach (string filePath in filePaths)
            {
                filePathsArgument += @"""" + filePath + @""" ";
            }

            return filePathsArgument;
        }

        /// <summary>
        /// Checks to see whether the viewer is allowed to be launched, in order
        /// to enable or disable the viewer button.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if the viewer can currently be launched; otherwise, <c>false</c>.
        /// </returns>
        private bool CanLaunchViewer()
        {
            // Assume we can launch the viewer.
            bool canLaunchViewer = true;

            // If background work is going on, we can't launch it
            if (this.Worker != null && this.Worker.IsBusy)
            {
                canLaunchViewer = false;
            }

            return canLaunchViewer;
        }

        /// <summary>
        /// Closes the viewer window.
        /// </summary>
        /// <param name="userDUZ">The user DUZ.</param>
        private void CloseViewerWindow(string userDUZ)
        {
            if (this.Worker != null && this.Worker.IsBusy)
            {
                this.ViewerProcess.Kill();
            }
        }

        /// <summary>
        /// The copy files locally.
        /// </summary>
        /// <param name="selectedInstances">
        /// The selected instances.
        /// </param>
        private void SetWorkingDirectoryAndCopyFilesLocally(List<SopInstance> selectedInstances)
        {
            this.workingDirectory = Path.Combine(
                this.importerTempFolder, this.WorkItem.WorkItemDetails.MediaBundleStagingRootDirectory);

            var copyInfoList = new List<CopyInfo>();
            foreach (SopInstance selectedInstance in selectedInstances)
            {
                string tempPath = PathUtilities.CombinePath(this.workingDirectory, selectedInstance.FilePath);
                copyInfoList.Add(
                    new CopyInfo { SourceFile = this.GetFullPath(selectedInstance), DestinationFile = tempPath });
            }

            // Copy all the files over
            RetryUtility.RetryAction(
                () =>
                this.NetworkCopy(
                    copyInfoList,
                    this.StorageDataSource.GetNetworkLocationDetails(this.WorkItemDetails.NetworkLocationIen)));
        }

        /// <summary>
        /// The display error.
        /// </summary>
        /// <param name="message">
        /// The message.
        /// </param>
        private void DisplayError(string message)
        {
            string caption = "Invalid Instance Range";
            this.DialogService.ShowAlertBox(OwningWindow, this.UIDispatcher, message, caption, MessageTypes.Error);
        }

        /// <summary>
        /// Gets the relative paths for the selected instances.
        /// </summary>
        /// <param name="selectedInstances">
        /// The list of instances selected for viewing.
        /// </param>
        /// <returns>
        /// A list of file paths for the selected instances
        /// </returns>
        private List<string> GetFileNameList(List<SopInstance> selectedInstances)
        {
            this.workingDirectory = WorkItemDetails.LocalSourcePath;

            var fileNames = new List<string>();

            foreach (SopInstance instance in selectedInstances)
            {
                if (instance.FilePath.StartsWith("\\"))
                {
                    fileNames.Add(instance.FilePath.Substring(1));
                }
                else
                {
                    fileNames.Add(instance.FilePath);
                }
            }

            return fileNames;
        }

        /// <summary>
        /// Returns the single instance requested by the user, or an error if the selection
        /// string is invalid.
        /// </summary>
        /// <returns>
        /// The requested SOP Instance
        /// </returns>
        private List<SopInstance> GetSingleSopInstance()
        {
            var sopInstances = new List<SopInstance>();

            int instanceNumber;

            // Get the starting value
            if (!int.TryParse(this.InstanceRange.Trim(), out instanceNumber))
            {
                this.DisplayError("Please enter an integer value for the instance number you'd like to view.");
                return null;
            }

            // Verify that the starting value is greater than 0 and less than the last instance in the series
            if (instanceNumber < 1 || instanceNumber > this.SelectedSeries.SopInstances.Count)
            {
                this.DisplayError(
                    "The selected instance value must be greater than 0 and less than or equal to the total number of images in the series.");
                return null;
            }

            // They've selected a valid instance. Add it to the list
            sopInstances.Add(this.SelectedSeries.SopInstances[instanceNumber - 1]);

            return sopInstances;
        }

        /// <summary>
        /// Attempts to get a list of SOP instances specified by the range in the request string.
        /// </summary>
        /// <returns>
        /// The selected SOP Instances if the range is valid. Otherwise, null. An error is displayed if the 
        /// range is invalid.
        /// </returns>
        private List<SopInstance> GetSopInstanceRange()
        {
            var sopInstances = new List<SopInstance>();

            // Try to parse the beginning and ending of the range.
            string[] instanceRange = this.InstanceRange.Split('-');

            if (instanceRange.Length > 2)
            {
                this.DisplayError("Please enter two integers separated by a '-' .");
                return null;
            }

            int startingInstance;
            int endingInstance;

            // Get the starting value
            if (!int.TryParse(instanceRange[0].Trim(), out startingInstance))
            {
                this.DisplayError("The starting value in the range is not an integer.");
                return null;
            }

            // Get the ending value
            if (!int.TryParse(instanceRange[1].Trim(), out endingInstance))
            {
                this.DisplayError("The ending value in the range is not an integer.");
                return null;
            }

            // Verify that the starting value is greater than 0 and less than the next to last instance in the series
            if (startingInstance < 1 || startingInstance > this.SelectedSeries.SopInstances.Count - 1)
            {
                this.DisplayError(
                    "The starting value in the range must be greater than 0 and less than the total number of images in the series.");
                return null;
            }

            // Verify that the ending value is greater than the starting value, and less than the total image count
            if (endingInstance < startingInstance || endingInstance > this.SelectedSeries.SopInstances.Count)
            {
                this.DisplayError(
                    "The ending value in the range must be greater than the starting value, and less than or equal to the total number of images in the series.");
                return null;
            }

            // Range is good... Add the instances to the selectedInstances collection
            for (int i = startingInstance - 1; i < endingInstance; i++)
            {
                sopInstances.Add(this.SelectedSeries.SopInstances[i]);
            }

            return sopInstances;
        }

        #endregion
    }
}