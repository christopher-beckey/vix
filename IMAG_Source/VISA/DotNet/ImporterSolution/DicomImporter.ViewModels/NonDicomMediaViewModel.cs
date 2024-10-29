/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 05/21/2013
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Lenard Williams
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
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Windows.Threading;
    using DicomImporter.Common.Model;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Storage.Model;
    using ImagingClient.Infrastructure.StorageDataSource;
    using log4net;
    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// The Non DICOM Media View Model.
    /// </summary>
    public class NonDicomMediaViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The selected non dicom files
        /// </summary>
        private ObservableCollection<NonDicomFile> selectedNonDicomFiles;

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(NonDicomMediaViewModel));

        /// <summary>
        /// True if work is in progress
        /// </summary>
        private bool workInProgress;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="NonDicomMediaViewModel" /> class.
        /// </summary>
        public NonDicomMediaViewModel()
        {

        }
        /// <summary>
        /// Initializes a new instance of the <see cref="NonDicomMediaViewModel" /> class with an empty
        /// collection of Non-DICOM files.
        /// </summary>
        /// <param name="uiDispatcher">The ui dispatcher.</param>
        public NonDicomMediaViewModel(Dispatcher uiDispatcher)
            : this(uiDispatcher, new ObservableCollection<NonDicomFile>(), null, null)
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="NonDicomMediaViewModel"/> class with the 
        /// specified collection of non-DICOM files
        /// </summary>
        /// <param name="uiDispatcher">The UI dispatcher.</param>
        /// <param name="nonDicomFiles">The non dicom files.</param>
        /// <param name="showFilePathColumn">if set to <c>true</c> [show file path column].</param>
        /// <param name="workItem">The work item.</param>
        /// <param name="storageDataSource">The storage data source.</param>
        public NonDicomMediaViewModel(Dispatcher uiDispatcher, ObservableCollection<NonDicomFile> nonDicomFiles, ImporterWorkItem workItem, IStorageDataSource storageDataSource)
        {
            this.workInProgress = false;
            this.UIDispatcher = uiDispatcher;
            this.DialogService = new DialogService();
            this.NonDicomFiles = nonDicomFiles;
            this.WorkItem = workItem;
            this.StorageDataSource = storageDataSource;

            this.AddFileCommand = new DelegateCommand<object>(o => this.workInProgress = false,
                   o => !this.IsWorkInProgress);

            this.RemoveFileCommand = new DelegateCommand<object>(o => this.RemoveFiles(),
                   o => this.IsMultipleFilesSelected() && !this.IsWorkInProgress);

            this.ScanFileCommand = new DelegateCommand<object>(o => this.workInProgress = false, o => !this.IsWorkInProgress);

            this.ViewFileCommand = new DelegateCommand<object>(
                   o => LaunchPDFViewer(this.SelectedFiles.ElementAt(0).FilePath),
                   o => this.IsFileSelected() && !this.IsWorkInProgress);
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets a value indicating whether this instance is work in progress.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance is work in progress; otherwise, <c>false</c>.
        /// </value>
        public bool IsWorkInProgress
        {
            get
            {
                return this.workInProgress;
            }

            set
            {
                this.workInProgress = value;

                this.AddFileCommand.RaiseCanExecuteChanged();
                this.RemoveFileCommand.RaiseCanExecuteChanged();
                this.ScanFileCommand.RaiseCanExecuteChanged();
                this.ViewFileCommand.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Command to logout of the application
        /// </summary>
        public static readonly CompositeCommand NonDicomFilesUpdatedCommand = new CompositeCommand();

        /// <summary>
        /// Gets or sets the non DICOM files.
        /// </summary>
        public ObservableCollection<NonDicomFile> NonDicomFiles { get; set; }

        /// <summary>
        /// Gets or sets the selected files.
        /// </summary>
        public ObservableCollection<NonDicomFile> SelectedFiles
        {
            get
            {
                if (this.selectedNonDicomFiles == null)
                {
                    this.selectedNonDicomFiles = new ObservableCollection<NonDicomFile>();
                }

                return this.selectedNonDicomFiles;
            }
            set
            {
                if (value != null)
                {
                    this.selectedNonDicomFiles = value;
                    
                    this.RemoveFileCommand.RaiseCanExecuteChanged();
                    this.ViewFileCommand.RaiseCanExecuteChanged();
                }
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether [show non dicom media].
        /// </summary>
        public bool ShowNonDicomMedia { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether to show the file path column.
        /// </summary>
        public bool ShowFilePathColumn  { get; set; }


        #endregion
      
        #region Public Methods

        /// <summary>
        /// Adds the files.
        /// </summary>
        public void AddFiles(ObservableCollection<NonDicomFile> files)
        {
            if (IsMediaBundleStaged)
            {
                // Media has been staged. Add the new files to the list and also
                // stage them now.
                AddAndStageNewNonDicomFiles(files);
            }
            else
            {
                // Media has not yet been staged. Just add the files to the list
                AddNonDicomFiles(files);
            }
        }

        /// <summary>
        /// Adds the and stage new non dicom files.
        /// </summary>
        /// <param name="files">The files.</param>
        private void AddAndStageNewNonDicomFiles(ObservableCollection<NonDicomFile> files)
        {
            if (files != null)
            {
                NetworkLocationInfo networkLocationInfo = this.StorageDataSource.GetNetworkLocationDetails(this.WorkItemDetails.NetworkLocationIen);
                string serverAndShare = networkLocationInfo.PhysicalPath;

                NetworkConnection conn = null;
                try
                {
                    conn = NetworkConnection.GetNetworkConnection(
                        serverAndShare, new NetworkCredential(networkLocationInfo.Username, networkLocationInfo.Password));

                    foreach (NonDicomFile file in files)
                    {
                        // Since we're generating a new GUID filename when copying to the share, we 
                        // can't check for duplicates like we can for non-staged items
                        string nonDicomRootDir = Path.Combine(WorkItemDetails.MediaBundleStagingRootDirectory, "NonDicom");
                        FileInfo destNonDicomFile = StageNonDicomFile(serverAndShare, file, nonDicomRootDir);
                        file.FilePath = destNonDicomFile.FullName;

                        this.NonDicomFiles.Add(file);
                    }

                    // re-sorts the Non DICOM files
                    IOrderedEnumerable<NonDicomFile> sortedList = this.NonDicomFiles.ToList<NonDicomFile>().OrderBy(x => x.Name);
                    this.NonDicomFiles = new ObservableCollection<NonDicomFile>(sortedList);

                    this.NotifyofNonDicomFilesPropertyChange();


                }
                catch (Exception e)
                {
                    string message = "Error staging non-DICOM file: " + e.Message;
                    string caption = "Error Staging Non-DICOM File";
                    this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);

                    // Log the exception
                    Logger.Error(message, e);
                }
                finally
                {
                    if (conn != null)
                    {
                        conn.Dispose();
                    }
                }
            }
        }

        /// <summary>
        /// Adds the non dicom files.
        /// </summary>
        /// <param name="files">The files.</param>
        private void AddNonDicomFiles(ObservableCollection<NonDicomFile> files)
        {
            ObservableCollection<string> existingFiles = new ObservableCollection<string>();

            if (files != null)
            {
                foreach (NonDicomFile file in files)
                {
                    // only adds new files to prevent repeats
                    if (!IsFileAlreadyAdded(file))
                    {
                        this.NonDicomFiles.Add(file);
                    }
                    else
                    {
                        existingFiles.Add(file.FilePath);
                    }
                }

                // displays a message to the user if already existing files were attempted to be added
                if (existingFiles.Count > 0)
                {
                    string message = "The following files were not added because they already exist: " + Environment.NewLine;

                    // adds the list of files to the string.
                    foreach (string fileName in existingFiles)
                    {
                        message += fileName + Environment.NewLine;
                    }

                    this.DialogService.ShowAlertBox(System.Windows.Application.Current.MainWindow,
                                                    this.UIDispatcher, message, "File Already Exists", MessageTypes.Info);
                }

                // re-sorts the Non DICOM files
                IOrderedEnumerable<NonDicomFile> sortedList = this.NonDicomFiles.ToList<NonDicomFile>().OrderBy(x => x.Name);
                this.NonDicomFiles = new ObservableCollection<NonDicomFile>(sortedList);

                this.NotifyofNonDicomFilesPropertyChange();
            }
        }

        #endregion

        #region Delegate Commands

        /// <summary>
        /// Gets or sets the add file command.
        /// </summary>
        /// <value>
        public DelegateCommand<object> AddFileCommand { get; set; }

        /// <summary>
        /// Gets or sets the remove file command.
        /// </summary>
        public DelegateCommand<object> RemoveFileCommand { get; set; }

        /// <summary>
        /// Gets or sets the scan file command.
        /// </summary>
        public DelegateCommand<object> ScanFileCommand { get; set; }

        /// <summary>
        /// Gets or sets the scan file command.
        /// </summary>
        public DelegateCommand<object> ViewFileCommand { get; set; }
        
        #endregion

        #region Private Methods

        /// <summary>
        /// Determines whether [is file already added] [the specified file].
        /// </summary>
        /// <param name="file">The file.</param>
        /// <returns>
        ///   <c>true</c> if [is file already added] [the specified file]; otherwise, <c>false</c>.
        /// </returns>
        private bool IsFileAlreadyAdded(NonDicomFile file)
        {
            foreach (NonDicomFile alreadyAddedFile in this.NonDicomFiles)
            {
                if (file == null || file.FilePath.Equals(alreadyAddedFile.FilePath))
                {
                    return true;
                }
            }

            return false;
        }

        /// <summary>
        /// Determines whether [is file selected].
        /// </summary>
        private bool IsFileSelected()
        {
            if (this.SelectedFiles == null || this.SelectedFiles.Count != 1)
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Determines whether [is multiple files selected].
        /// </summary>
        private bool IsMultipleFilesSelected()
        {
            if (this.SelectedFiles == null || this.SelectedFiles.Count == 0)
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Notify of the non dicom files property change.
        /// </summary>
        private void NotifyofNonDicomFilesPropertyChange()
        {
            RaisePropertyChanged("NonDicomFiles");

            // used to notify view that control is embedded in of a change.
            var e = new CancelEventArgs();
            if (NonDicomFilesUpdatedCommand.CanExecute(e))
            {
                NonDicomFilesUpdatedCommand.Execute(e);
            }
        }

        /// <summary>
        /// Removes the file.
        /// </summary>
        private void RemoveFiles()
        {
            if (IsMediaBundleStaged)
            {
                RemoveAndDeleteStagedNonDicomFiles();
            }
            else
            {
                RemoveNonDicomFiles();
            }
        }

        /// <summary>
        /// Removes the and delete staged non dicom files.
        /// </summary>
        private void RemoveAndDeleteStagedNonDicomFiles()
        {
            if (this.NonDicomFiles != null)
            {
                NetworkLocationInfo networkLocationInfo = this.StorageDataSource.GetNetworkLocationDetails(this.WorkItemDetails.NetworkLocationIen);
                string serverAndShare = networkLocationInfo.PhysicalPath;

                NetworkConnection conn = null;
                try
                {
                    conn = NetworkConnection.GetNetworkConnection(
                        serverAndShare, new NetworkCredential(networkLocationInfo.Username, networkLocationInfo.Password));

                    foreach (NonDicomFile file in this.SelectedFiles)
                    {
                        File.Delete(file.FilePath);
                        this.NonDicomFiles.Remove(file);
                    }

                    this.SelectedFiles.Clear();

                }
                catch (Exception e)
                {
                    string message = "Error deleting non-DICOM file: " + e.Message;
                    string caption = "Error Deleting Non-DICOM File";
                    this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);

                    // Log the exception
                    Logger.Error(message, e);
                }
                finally
                {
                    if (conn != null)
                    {
                        conn.Dispose();
                    }
                }
            }

            this.NotifyofNonDicomFilesPropertyChange();
        }

        /// <summary>
        /// Removes the non dicom files.
        /// </summary>
        private void RemoveNonDicomFiles()
        {
            if (this.NonDicomFiles != null)
            {
                foreach (NonDicomFile file in this.SelectedFiles)
                {
                    this.NonDicomFiles.Remove(file);
                }

                this.SelectedFiles.Clear();
            }

            this.NotifyofNonDicomFilesPropertyChange();
        }

        #endregion
    }
}