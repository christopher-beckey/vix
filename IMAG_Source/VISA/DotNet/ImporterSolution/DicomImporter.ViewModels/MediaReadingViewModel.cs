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
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Globalization;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Text;
    using System.Windows.Threading;
    using DicomImporter.Common.Exceptions;
    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Dicom;
    using ImagingClient.Infrastructure.Model;
    using ImagingClient.Infrastructure.Storage.Model;
    using ImagingClient.Infrastructure.StorageDataSource;
    using ImagingClient.Infrastructure.User.Model;
    using ImagingClient.Infrastructure.Utilities;
    using ImagingClient.Infrastructure.ViewModels;
    using log4net;
    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// The media reading view model.
    /// </summary>
    public class MediaReadingViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(MediaReadingViewModel));

        /// <summary>
        /// The patient cache.
        /// </summary>
        private readonly Dictionary<string, Patient> patientCache = new Dictionary<string, Patient>();

        /// <summary>
        /// The series cache.
        /// </summary>
        private readonly Dictionary<string, Series> seriesCache = new Dictionary<string, Series>();

        /// <summary>
        /// The study cache.
        /// </summary>
        private readonly Dictionary<string, Study> studyCache = new Dictionary<string, Study>();

        /// <summary>
        /// The progress view model.
        /// </summary>
        private ProgressViewModel progressViewModel = new ProgressViewModel();

        /// <summary>
        /// The selected studies.
        /// </summary>
        private ObservableCollection<Study> selectedStudies;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets CancelActionCommand.
        /// </summary>
        public DelegateCommand<object> CancelActionCommand { get; set; }

        /// <summary>
        /// Gets or sets Drives.
        /// </summary>
        public ObservableCollection<string> Drives { get; set; }

        /// <summary>
        /// Gets a value indicating whether this instance is mixedor dicom media.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance is mixedor dicom media; otherwise, <c>false</c>.
        /// </value>
        public bool IsMixedorDicomMedia { get; protected set; }

        /// <summary>
        /// Gets a value indicating whether this instance is mixedor non dicom media.
        /// </summary>
        /// <value>
        /// <c>true</c> if this instance is mixedor non dicom media; otherwise, <c>false</c>.
        /// </value>
        public bool IsMixedorNonDicomMedia
        {
            get
            {
                if (this.NonDicomMediaViewModel == null)
                {
                    return false;
                }

                return this.NonDicomMediaViewModel.ShowNonDicomMedia;
            }

            protected set
            {
                if (this.NonDicomMediaViewModel == null)
                {
                    this.NonDicomMediaViewModel = new NonDicomMediaViewModel();
                }

                this.NonDicomMediaViewModel.ShowNonDicomMedia = value;
            }
        }

        /// <summary>
        /// Gets or sets LogoutCommand.
        /// </summary>
        public DelegateCommand<CancelEventArgs> NonDicomFilesChangedCommand { get; set; }

        /// <summary>
        /// Gets or sets PerformActionCommand.
        /// </summary>
        public DelegateCommand<object> PerformActionCommand { get; set; }  


        /// <summary>
        /// Gets or sets ProgressViewModel.
        /// </summary>
        public ProgressViewModel ProgressViewModel
        {
            get
            {
                return this.progressViewModel;
            }

            set
            {
                this.progressViewModel = value;
                //Property notification-OITCOPondiS
                this.RaisePropertyChanged("ProgressViewModel");
            }
        }

        /// <summary>
        /// Gets or sets NonDicomMediaViewModel.
        /// </summary>
        public NonDicomMediaViewModel NonDicomMediaViewModel { get; set; }

        /// <summary>
        /// Gets or sets SelectedStudies.
        /// </summary>
        public ObservableCollection<Study> SelectedStudies
        {
            get
            {
                return this.selectedStudies;
            }

            set
            {
                this.selectedStudies = value;
                this.PerformActionCommand.RaiseCanExecuteChanged();

                if (this.ShowStudyDetailsWindow != null)
                {
                    this.ShowStudyDetailsWindow.RaiseCanExecuteChanged();
                }
            }
        }

        /// <summary>
        /// Gets or sets ShowStudyDetailsWindow.
        /// </summary>
        public DelegateCommand<object> ShowStudyDetailsWindow { get; set; }

        /// <summary>
        /// Gets or sets StudiesOnMedia.
        /// </summary>
        public ObservableCollection<Study> StudiesOnMedia { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether StudyListBuiltSuccessfully.
        /// </summary>
        public bool StudyListBuiltSuccessfully { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// Reads a path and builds a list of DICOM studies in the path.
        /// </summary>
        /// <param name="sourceRootPath">
        /// The source root path.
        /// </param>
        /// <param name="isToBeStaged">
        /// Whether the media is to be staged.
        /// </param>
        /// <param name="originIndex">
        /// The origin index.
        /// </param>
        /// <returns>
        /// Whether the read and study list build was successful.
        /// </returns>
        public bool ReadDicomStudiesFromPath(string sourceRootPath, bool isToBeStaged, string originIndex)
        {
            Logger.Debug("Reading studies from path: " + sourceRootPath);

            this.StudiesOnMedia = new ObservableCollection<Study>();

            this.ProgressViewModel.IsIndeterminate = true;
            this.ProgressViewModel.Text = "Scanning for DICOMDIR files";

            // Initialize the work item
            this.InitializeWorkItem(sourceRootPath, isToBeStaged);

            // Get a "signature" for the media by hashing all the filenames
            var allFiles = new List<string>();
            PathUtilities.AddFiles(sourceRootPath, "*", allFiles);
            this.WorkItemDetails.MediaBundleSignature = StringUtilities.GetHashForStringArray(allFiles.ToArray());

            // First, look to see if there are any DICOMDIR files in the root or below...
            var fileList = new List<string>();
            PathUtilities.AddFiles(sourceRootPath, "DICOMDIR", fileList);
            string[] files = fileList.ToArray();

            if (files.Length != 0)
            {
                // We can try to build the list of studies the "easy way", since there are one or more 
                // DICOMDIR files available on the media. If we encounter an exception, retry using the 
                // brute force method
                try
                {
                    return this.BuildStudyListFromDicomDirs(sourceRootPath, files);
                }
                catch (Exception e)
                {
                    Logger.Error(
                        "Error building study list using DICOMDIR files. Falling back to brute force method: ", e);

                    // Attempt to do it by brute force 
                    this.StudiesOnMedia = new ObservableCollection<Study>();
                    this.WorkItemDetails.MediaHasDicomDir = false;
                    this.WorkItemDetails.MediaValidationStatusCode = DicomMediaValidationStatusCodes.InvalidDicomDir;

                    // We have to build the list of studies the "hard way".
                    this.BuildStudyListManually(sourceRootPath);

                    return true;
                }
            }
            else
            {
                this.WorkItemDetails.MediaHasDicomDir = false;
                this.WorkItemDetails.MediaValidationStatusCode = DicomMediaValidationStatusCodes.DicomDirMissing;

                // We have to build the list of studies the "hard way".
                this.BuildStudyListManually(sourceRootPath);

                return true;
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// The copy files to server.
        /// </summary>
        protected void CopyFilesToServer()
        {
            Logger.Debug("Preparing to copy files to the server.");
            NetworkLocationInfo networkLocationInfo = this.StorageDataSource.GetCurrentWriteLocation();

            string serverAndShare = networkLocationInfo.PhysicalPath.Trim();

            // If the server and share is empty or a local drive, don't stage. Instead, throw a
            // missing network location exception
            if (string.IsNullOrWhiteSpace(serverAndShare) || 
                (serverAndShare.Length > 1 && serverAndShare[1].Equals(':')))
            {
                throw new InvalidNetworkLocationException(serverAndShare);
            }

            string rootDir = ImporterServerRootDirectory + "\\" + UserContext.UserCredentials.SiteNumber + "\\"
                             + WorkItem.Subtype + "\\" + Guid.NewGuid();

            var credentials = new NetworkCredential(networkLocationInfo.Username, networkLocationInfo.Password);

            // Store off the information required to find the images later
            this.WorkItemDetails.NetworkLocationIen = networkLocationInfo.WriteLocationIEN;
            this.WorkItemDetails.MediaBundleStagingRootDirectory = rootDir;

            // Perform the file copy using a more aggressive number of retries and timeouts
            RetryUtility.RetryAction(() => this.PerformFileCopy(serverAndShare, rootDir, credentials), 3, 4000);

            // Cancel if requested
            if (this.Worker != null && this.Worker.CancellationPending)
            {
                return;
            }

            // If we made it here with no exceptions, mark the bundle as staged.
            this.WorkItemDetails.IsMediaBundleStaged = true;
        }

        /// <summary>
        /// The initialize work item.
        /// </summary>
        /// <param name="sourceRootPath">
        /// The source root path.
        /// </param>
        /// <param name="isToBeStaged">
        /// The is to be staged.
        /// </param>
        protected void InitializeWorkItem(string sourceRootPath, bool isToBeStaged, string reconcilerNotes)
        {
            this.WorkItem = new ImporterWorkItem
            {
                Type = ImporterWorkListTypes.Importer,
                Key = sourceRootPath,
                Subtype = isToBeStaged
                            ? ImporterWorkItemSubtype.StagedMedia.Code
                            : ImporterWorkItemSubtype.DirectImport.Code,
                Source = Environment.MachineName,
                Status = ImporterWorkItemStatuses.New,
                OriginalStatus = ImporterWorkItemStatuses.New,
                CreatingUser = UserContext.UserCredentials.Duz,
                UpdatingUser = UserContext.UserCredentials.Duz,
                CreatingApplication = string.Empty,
                UpdatingApplication = string.Empty,
                MediaCategory = this.MediaCategory,
                Service = this.WorkItemService.Value.Equals("None")
                            ? ""
                            : this.WorkItemService.Value,
                WorkItemDetails = new ImporterWorkItemDetails
                {
                    LocalSourcePath = sourceRootPath,
                    Studies = new ObservableCollection<Study>(),
                    ReconcilerNotes = reconcilerNotes
                }
            };
        }

        /// <summary>
        /// Sets the media category properties.
        /// </summary>
        protected void SetMediaCategoryProperties()
        {
            string mediaCategory = "";

            if (WorkItem != null && WorkItem.MediaCategory != null)
            {
                mediaCategory = this.WorkItem.MediaCategory.Category;
            }
            else
            {
                mediaCategory = this.MediaCategory.Category;
            }

            this.IsMixedorDicomMedia = false;
            this.IsMixedorNonDicomMedia = false;

            switch (mediaCategory)
            {
                case MediaCategories.DICOM:
                    this.IsMixedorDicomMedia = true;
                    this.IsMixedorNonDicomMedia = false;
                    break;

                case MediaCategories.Mixed:
                    this.IsMixedorDicomMedia = true;
                    this.IsMixedorNonDicomMedia = true;
                    break;
                case MediaCategories.NonDICOM:
                    this.IsMixedorDicomMedia = false;
                    this.IsMixedorNonDicomMedia = true;
                    break;
            }
        }

        /// <summary>
        /// The populate drive list.
        /// </summary>
        protected void PopulateDriveList()
        {
            this.Drives = new ObservableCollection<string>();
            DriveInfo[] driveList = DriveInfo.GetDrives();

            foreach (DriveInfo drive in driveList)
            {
                if (drive.DriveType == DriveType.CDRom || drive.DriveType == DriveType.Removable)
                {
                    this.Drives.Add(drive.RootDirectory.FullName);
                }
            }
        }

        /// <summary>
        /// The set origin index data for studies.
        /// </summary>
        /// <param name="studiesOnMedia">
        /// The studies on media.
        /// </param>
        /// <param name="originIndex">
        /// The origin index.
        /// </param>
        protected void SetOriginIndexDataForStudies(ObservableCollection<Study> studiesOnMedia, string originIndex)
        {
            this.WorkItem.OriginIndex = originIndex;
            foreach (Study study in studiesOnMedia)
            {
                study.OriginIndex = originIndex;
            }
        }

        /// <summary>
        /// Removes Studies, Series, or SOP instances from the object graph if the referenced files
        /// are not currently supported by Imaging.
        /// </summary>
        /// <param name="sourceRootPath">The source root path.</param>
        /// <param name="selectedStudies">The studies on media.</param>
        /// <returns>Returns <c>true</c> if any files were found to be missing; otherwise <c>false</c></returns>
        protected bool StripUnsupportedSopInstances(string sourceRootPath, ObservableCollection<Study> selectedStudies)
        {
            int totalFiles = this.GetStagingFileCount(selectedStudies);
            int unsupportedInstanceCount = 0;

            this.ProgressViewModel.IsIndeterminate = false;
            this.ProgressViewModel.Value = 0;
            this.ProgressViewModel.Maximum = totalFiles;

            for (int i = selectedStudies.Count - 1; i >= 0; i--)
            {
                Study study = selectedStudies[i];

                for (int j = study.Series.Count - 1; j >= 0; j--)
                {
                    Series series = study.Series[j];

                    for (int k = series.SopInstances.Count - 1; k >= 0; k--)
                    {
                        SopInstance instance = series.SopInstances[k];

                        this.ProgressViewModel.Value++;
                        this.ProgressViewModel.Text = "Verifying SOP class of file " + this.ProgressViewModel.Value
                                                      + ": " + instance.FilePath;

                        string fullPath = PathUtilities.CombinePath(sourceRootPath, instance.FilePath);

                        if (!UIDActionList.IsKnownSopClass(instance.SopClassUid))
                        {
                            Logger.Warn("File " + fullPath + " is of an unsupported SOP Class (" + instance.SopClassUid + ") and will not be imported");
                            this.UIDispatcher.Invoke(DispatcherPriority.Normal, (Action)(() => series.SopInstances.RemoveAt(k)));
                            unsupportedInstanceCount++;
                        }
                    }

                    if (series.SopInstances.Count == 0)
                    {
                        this.UIDispatcher.Invoke(DispatcherPriority.Normal, (Action)(() => study.Series.RemoveAt(j)));
                    }
                }

                if (study.Series.Count == 0)
                {
                    this.UIDispatcher.Invoke(DispatcherPriority.Normal, (Action)(() => selectedStudies.RemoveAt(i)));
                }
            }

            if (unsupportedInstanceCount > 0)
            {
                if (selectedStudies.Count == 0)
                {
                    string message =
                        string.Format(
                            "There are {0} DICOM objects in the selected studies, but none of them are currently supported \n"
                            + "by VistA. There is nothing available to import.\n\n",
                            totalFiles);

                    string caption = "Media Contains No Supported DICOM Objects";

                    DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);

                    return false;
                }
                else
                {
                    string message =
                        string.Format(
                            "There are {0} DICOM objects in the selected studies, but of those, {1} are not \n"
                            + "currently supported by VistA and will not be imported.\n\n"
                            + "The remaining {2} objects will be imported.\n\n"
                            + "Would you like to continue?",
                            totalFiles,
                            unsupportedInstanceCount,
                            totalFiles - unsupportedInstanceCount);

                    string caption = "Media Contains Unsupported DICOM Objects";

                    return this.DialogService.ShowYesNoBox(this.UIDispatcher, message, caption, MessageTypes.Warning);
                }
            }
            else
            {
                return true;
            }
        }

        /// <summary>
        /// Given the path to a DICOM file, returns the DICOM dataset.
        /// </summary>
        /// <param name="dicomFile">
        /// The dicom file.
        /// </param>
        /// <returns>
        /// The DICOM dataset for the specified file
        /// </returns>
        private static IDicomDataSet GetDicomDataSet(string dicomFile)
        {
            return new SparseDicomDataSet(dicomFile);
        }

        /// <summary>
        /// The add file to study.
        /// </summary>
        /// <param name="sourceRootPath">
        /// The source root path.
        /// </param>
        /// <param name="filePath">
        /// The file path.
        /// </param>
        /// <param name="dataSet">
        /// The data set.
        /// </param>
        private void AddFileToStudy(string sourceRootPath, string filePath, IDicomDataSet dataSet)
        {
            Patient patient = this.GetOrCreatePatient(dataSet);
            Study study = this.GetOrCreateStudy(patient, dataSet);
            Series series = this.GetOrCreateSeries(study, dataSet);
            this.AddSopInstanceToSeries(sourceRootPath, filePath, series, dataSet);
        }

        /// <summary>
        /// The add sop instance to series.
        /// </summary>
        /// <param name="sourceRootPath">
        /// The source root path.
        /// </param>
        /// <param name="filePath">
        /// The file path.
        /// </param>
        /// <param name="series">
        /// The series.
        /// </param>
        /// <param name="dataSet">
        /// The data set.
        /// </param>
        private void AddSopInstanceToSeries(
            string sourceRootPath, string filePath, Series series, IDicomDataSet dataSet)
        {
            string relativePath = PathUtilities.GetRelativePath(sourceRootPath, filePath);
            var sopInstance = new SopInstance
                {
                    Uid = dataSet.SopInstanceUid,
                    FilePath = relativePath,
                    SopClassUid = dataSet.SopClassUid,
                    TransferSyntaxUid = dataSet.TransferSyntaxUid,
                    ImageNumber = dataSet.ImageNumber,
                    NumberOfFrames = dataSet.NumberOfFrames
                };

            series.SopInstances.Add(sopInstance);
        }

        /// <summary>
        /// Adjusts the dicom dir file paths.
        /// </summary>
        /// <param name="study">The study.</param>
        /// <param name="pathOffset">The path offset.</param>
        private void AdjustDicomDirFilePaths(Study study, string pathOffset)
        {
            foreach (Series series in study.Series)
            {
                foreach (SopInstance instance in series.SopInstances)
                {
                    instance.FilePath = PathUtilities.CombinePath(pathOffset, instance.FilePath);
                }
            }
        }

        /// <summary>
        /// Builds the study list from dicom dirs.
        /// </summary>
        /// <param name="sourceRootPath">The source root path.</param>
        /// <param name="files">The files.</param>
        /// <returns>A boolean indicating whether the study list was built succsessfully</returns>
        private bool BuildStudyListFromDicomDirs(string sourceRootPath, string[] files)
        {
            this.ProgressViewModel.IsIndeterminate = true;

            this.WorkItemDetails.MediaHasDicomDir = true;

            foreach (string file in files)
            {
                // Update the progress message
                if (files.Length > 1)
                {
                    this.ProgressViewModel.Text = "Processing DICOMDIR file " + this.ProgressViewModel.Value + " of "
                                                  + files.Length;
                }
                else
                {
                    this.ProgressViewModel.Text = "Processing DICOMDIR file";
                }

                // Store the relative paths to the DICOMDIR files, so they can be copied over with the media
                this.WorkItemDetails.DicomDirPaths.Add(PathUtilities.GetRelativePath(sourceRootPath, file));

                ObservableCollection<Study> studiesFromDicomDir = this.DicomImporterDataSource.ReadDicomDir(file);
                string pathOffset = this.GetDicomDirPathOffset(sourceRootPath, file);
                int studyNumber = 1;
                foreach (Study study in studiesFromDicomDir)
                {
                    this.AdjustDicomDirFilePaths(study, pathOffset);
                    study.IdInMediaBundle = studyNumber++;

                    // Attach the the temporary study list to the workitem details
                    this.UIDispatcher.Invoke(
                        DispatcherPriority.Normal, (Action)(() => this.StudiesOnMedia.Add(study)));
                }

                if (this.Worker.CancellationPending)
                {
                    return false;
                }
            }

            // Now that we have read and adjusted all the files, verify that all files specified in the DICOMDIR 
            // file actually exist on the media. If any are missing, ask the user if they want to continue.
            bool continueProcessing = this.StripMissingFiles(sourceRootPath, this.StudiesOnMedia);

            if (continueProcessing)
            {
                // Now that we've stripped missing files (if any) and verified that the user wants to continue,
                // enhance the study, series, and instance metadata with actual data from DICOM headers, and clear any
                // invalid dates that may cause crashes later...
                this.ProgressViewModel.IsIndeterminate = true;
                this.ProgressViewModel.Text = "Enhancing DICOM metadata...";
                this.EnhanceMetadata(sourceRootPath);
                this.ClearInvalidStudySeriesAndBirthDates();
                return true;
            }
            else
            {
                return false;
            }
        }

        /// <summary>
        /// The build study list manually.
        /// </summary>
        /// <param name="sourceRootPath">
        /// The source root path.
        /// </param>
        private void BuildStudyListManually(string sourceRootPath)
        {
            // Get all files in this directory and its subdirectories
            var fileList = new List<string>();
            PathUtilities.AddFiles(sourceRootPath, "*", fileList);
            string[] files = fileList.ToArray();

            List<string> dicomFiles = this.GetDicomFiles(files);

            // For each DICOM file, load the header and create or add it to the study hierarchy
            this.GetStudyListFromFiles(sourceRootPath, dicomFiles);

            // Clear invalid study dates
            this.ClearInvalidStudySeriesAndBirthDates();
        }

        /// <summary>
        /// Clears invalid study dates, to prevent parsing exceptions later.
        /// If necessary, the GUI will request a valid study date from user during
        /// reconciliation
        /// </summary>
        private void ClearInvalidStudySeriesAndBirthDates()
        {
            // Check for and clear invalid study dates
            foreach (Study study in this.StudiesOnMedia)
            {
                if (!this.IsValidDicomDate(study.StudyDate))
                {
                    study.StudyDate = string.Empty;
                }

                if (!this.IsValidDicomDate(study.Patient.Dob))
                {
                    study.Patient.Dob = null;
                }

                foreach (Series series in study.Series)
                {
                    if (!this.IsValidDicomDate(series.SeriesDate))
                    {
                        series.SeriesDate = string.Empty;
                    }
                }
            }
        }

        /// <summary>
        /// Determines whether the specified date is a valid date in DICOM format.
        /// </summary>
        /// <param name="dateToTest">The date to test.</param>
        /// <returns>
        ///   <c>true</c> if [is valid dicom date] [the specified date to test]; otherwise, <c>false</c>.
        /// </returns>
        private bool IsValidDicomDate(string dateToTest)
        {
            DateTime dateTime;
            return DateTime.TryParseExact(
                dateToTest, 
                "yyyyMMdd", 
                DateTimeFormatInfo.InvariantInfo, 
                DateTimeStyles.None, 
                out dateTime);
        }

        /// <summary>
        /// Enhances the metadata.
        /// </summary>
        /// <param name="sourceRootPath">The source root path.</param>
        private void EnhanceMetadata(string sourceRootPath)
        {
            // Check for and clear invalid study dates
            foreach (Study study in this.StudiesOnMedia)
            {
                this.EnhanceStudyMetadata(sourceRootPath, study);
                this.EnhanceSeriesMetadata(sourceRootPath, study);
            }
        }

        /// <summary>
        /// Enhances the study metadata.
        /// </summary>
        /// <param name="sourceRootPath">The source root path.</param>
        /// <param name="study">The study.</param>
        private void EnhanceStudyMetadata(string sourceRootPath, Study study)
        {
            try
            {
                // Get a list of all sop instances across all series in the study
                IEnumerable<SopInstance> instances = study.Series.SelectMany(s => s.SopInstances);

                // Find the first instance where the file actually exists
                var instance =
                    (from i in instances
                     where File.Exists(PathUtilities.CombinePath(sourceRootPath, i.FilePath))
                     select i).FirstOrDefault();

                // If we found a sop instance for this study, use it to enhance the study metadata
                if (instance != null)
                {
                    string fullPath = PathUtilities.CombinePath(sourceRootPath, instance.FilePath);
                    SparseDicomDataSet dataSet = new SparseDicomDataSet(fullPath);

                    // If there were no errors loading the dataset, use it to enhance the data if possible
                    if (string.IsNullOrWhiteSpace(dataSet.ErrorMessage))
                    {
                        // If there's already a patient object, enhance it if necessary
                        if (study.Patient != null)
                        {
                            study.Patient.Dob = dataSet.PatientBirthDate;
                            study.Patient.Ssn = dataSet.PatientId;
                            study.Patient.PatientName = StringUtilities.ConvertDicomName(dataSet.PatientName);
                            study.Patient.PatientSex = dataSet.PatientSex;
                        }
                        else
                        {
                            // No patient object. Create one and attach it
                            study.Patient = this.GetOrCreatePatient(dataSet);
                        }

                        // Enhance the additional data
                        study.AccessionNumber = dataSet.AccessionNumber + string.Empty;
                        study.ReferringPhysician = StringUtilities.ConvertDicomName(dataSet.ReferringPhysician);
                        study.StudyDate = dataSet.StudyDate;
                        study.StudyTime = dataSet.StudyTime;
                        study.Description = dataSet.StudyDescription + string.Empty;
                        study.Procedure = dataSet.PerformedProcedureStepDescription;
                    }
                }
            }
            catch (Exception e)
            {
                Logger.Error("Exception enhancing study data from header: " + e);
            }
        }

        /// <summary>
        /// Enhances the series metadata.
        /// </summary>
        /// <param name="sourceRootPath">The source root path.</param>
        /// <param name="study">The study.</param>
        private void EnhanceSeriesMetadata(string sourceRootPath, Study study)
        {
            try
            {
                foreach (Series series in study.Series)
                {
                    // Get all sop instances in the series
                    IEnumerable<SopInstance> instances = series.SopInstances;

                    // Find the first instance where the file actually exists
                    var instance =
                        (from i in instances
                         where File.Exists(PathUtilities.CombinePath(sourceRootPath, i.FilePath))
                         select i).FirstOrDefault();

                    if (instance != null)
                    {
                        string fullPath = PathUtilities.CombinePath(sourceRootPath, instance.FilePath);
                        SparseDicomDataSet dataSet = new SparseDicomDataSet(fullPath);

                        // If there were no errors loading the dataset, use it to enhance the data if possible
                        if (string.IsNullOrWhiteSpace(dataSet.ErrorMessage))
                        {
                            series.Uid = dataSet.SeriesUid;
                            series.Modality = dataSet.Modality + string.Empty;
                            series.SeriesDate = dataSet.SeriesDate + string.Empty;
                            series.Facility = dataSet.Facility + string.Empty;
                            series.InstitutionAddress = dataSet.InstitutionAddress + string.Empty;
                            series.SeriesDescription = dataSet.SeriesDescription + string.Empty;
                        }
                    }

                    this.EnhanceInstanceMetadata(sourceRootPath, series);
                }
            }
            catch (Exception e)
            {
                Logger.Error("Error enhancing Series metadata", e);
            }
        }

        /// <summary>
        /// Enhances the instance metadata.
        /// </summary>
        /// <param name="sourceRootPath">The source root path.</param>
        /// <param name="series">The series.</param>
        private void EnhanceInstanceMetadata(string sourceRootPath, Series series)
        {
            // Get the list of instances where the file actually exists
            IEnumerable<SopInstance> instances = from i in series.SopInstances
                                                 where File.Exists(PathUtilities.CombinePath(sourceRootPath, i.FilePath))
                                                 select i;

            foreach (SopInstance instance in instances)
            {
                string fullPath = PathUtilities.CombinePath(sourceRootPath, instance.FilePath);
                SparseDicomDataSet dataSet = new SparseDicomDataSet(fullPath);

                // If there were no errors loading the dataset, use it to enhance the data if possible
                if (string.IsNullOrWhiteSpace(dataSet.ErrorMessage))
                {
                    instance.Uid = dataSet.SopInstanceUid;
                    instance.SopClassUid = dataSet.SopClassUid;
                    instance.TransferSyntaxUid = dataSet.TransferSyntaxUid;
                    instance.ImageNumber = dataSet.ImageNumber;
                    instance.NumberOfFrames = dataSet.NumberOfFrames;
                }
            }
        }

        /// <summary>
        /// Gets the dicom dir path offset.
        /// </summary>
        /// <param name="sourceRootPath">The source root path.</param>
        /// <param name="file">The file.</param>
        /// <returns>The offset of the DICOMDIR file from the root of the media</returns>
        private string GetDicomDirPathOffset(string sourceRootPath, string file)
        {
            string relativePath = PathUtilities.GetRelativePath(sourceRootPath, file);
            string pathOffset = relativePath.Substring(0, relativePath.Length - "DICOMDIR".Length);
            return pathOffset;
        }

        /// <summary>
        /// Gets the dicom files.
        /// </summary>
        /// <param name="files">The files.</param>
        /// <returns>
        /// Given an array of files, returns a list of those that are verified to actually
        /// be DICOM files
        /// </returns>
        private List<string> GetDicomFiles(string[] files)
        {
            this.ProgressViewModel.IsIndeterminate = false;
            this.ProgressViewModel.Minimum = 0;
            this.ProgressViewModel.Maximum = files.Length;
            this.ProgressViewModel.Value = 0;

            var dicomFiles = new List<string>();
            foreach (string file in files)
            {
                this.ProgressViewModel.Text = "Scanning for DICOM files: " + file;

                string extension = Path.GetExtension(file) ?? string.Empty;
                bool isPotentialDicomExtension = extension.Equals(".dcm", StringComparison.CurrentCultureIgnoreCase)
                                                  || string.IsNullOrEmpty(extension);
                bool isDicomDir = file.ToUpper().EndsWith("\\DICOMDIR");

                if (isPotentialDicomExtension && !isDicomDir && this.HasDicomPreamble(file))
                {
                    // This is a DICOM file...
                    dicomFiles.Add(file);
                }
            }

            return dicomFiles;
        }

        /// <summary>
        /// Gets or creates patient.
        /// </summary>
        /// <param name="dataSet">The data set.</param>
        /// <returns>The matching patient, or a new patient instance</returns>
        private Patient GetOrCreatePatient(IDicomDataSet dataSet)
        {
            Patient patient;
            string patientKey = this.GetPatientKey(dataSet);
            if (this.patientCache.ContainsKey(patientKey))
            {
                patient = this.patientCache[patientKey];
            }
            else
            {
                string patientBirthdate = (dataSet.PatientBirthDate + string.Empty).Trim();

                string dob = !patientBirthdate.Equals(string.Empty) ? patientBirthdate : null;
                patient = new Patient
                    { 
                        PatientName = dataSet.PatientName, 
                        Ssn = dataSet.PatientId, 
                        PatientSex = dataSet.PatientSex,
                        Dob = dob
                    };

                this.patientCache.Add(patientKey, patient);
            }

            return patient;
        }

        /// <summary>
        /// Gets or creates a series.
        /// </summary>
        /// <param name="study">The study.</param>
        /// <param name="dataSet">The data set.</param>
        /// <returns>The matching series, or a new series instance</returns>
        private Series GetOrCreateSeries(Study study, IDicomDataSet dataSet)
        {
            Series series;
            string seriesKey = this.GetSeriesKey(dataSet);
            if (this.seriesCache.ContainsKey(seriesKey))
            {
                series = this.seriesCache[seriesKey];
            }
            else
            {
                series = new Series
                    {
                        Uid = dataSet.SeriesUid,
                        Modality = dataSet.Modality,
                        SeriesDate = dataSet.SeriesDate,
                        Facility = dataSet.Facility,
                        InstitutionAddress = dataSet.InstitutionAddress,
                        SeriesDescription = dataSet.SeriesDescription
                    };

                study.Series.Add(series);
                this.seriesCache.Add(seriesKey, series);
            }

            return series;
        }

        /// <summary>
        /// Gets or creates a study.
        /// </summary>
        /// <param name="patient">The patient.</param>
        /// <param name="dataSet">The data set.</param>
        /// <returns>The matching study, or a new study instance</returns>
        private Study GetOrCreateStudy(Patient patient, IDicomDataSet dataSet)
        {
            Study study;
            string studyKey = this.GetStudyKey(dataSet);
            if (this.studyCache.ContainsKey(studyKey))
            {
                study = this.studyCache[studyKey];
            }
            else
            {
                study = new Study
                    {
                        Uid = dataSet.StudyUid,
                        AccessionNumber = dataSet.AccessionNumber,
                        Description = dataSet.StudyDescription,
                        StudyDate = dataSet.StudyDate,
                        StudyTime = dataSet.StudyTime,
                        ReferringPhysician = StringUtilities.ConvertDicomName(dataSet.ReferringPhysician),
                        Procedure = dataSet.PerformedProcedureStepDescription,
                        Patient = patient
                    };

                this.studyCache.Add(studyKey, study);
            }

            return study;
        }

        /// <summary>
        /// Gets a key representing a patient, for use in a patient cache.
        /// </summary>
        /// <param name="dataSet">
        /// The data set.
        /// </param>
        /// <returns>
        /// The patient key.
        /// </returns>
        private string GetPatientKey(IDicomDataSet dataSet)
        {
            return dataSet.PatientId + "_" + dataSet.PatientName + "_" + dataSet.PatientBirthDate + "_"
                   + dataSet.PatientSex;
        }

        /// <summary>
        /// Gets a key representing a series, for use in a series cache.
        /// </summary>
        /// <param name="dataSet">
        /// The data set.
        /// </param>
        /// <returns>
        /// The series key.
        /// </returns>
        private string GetSeriesKey(IDicomDataSet dataSet)
        {
            return dataSet.StudyUid + "_" + dataSet.SeriesUid;
        }

        /// <summary>
        /// Gets the staging file count.
        /// </summary>
        /// <param name="studies">The studies.</param>
        /// <returns>
        /// The number of files that need to be staged, for use in progress bar updates
        /// </returns>
        private int GetStagingFileCount(IEnumerable<Study> studies)
        {
            return studies.Sum(study => study.Series.Sum(series => series.SopInstances.Count));
        }

        /// <summary>
        /// Gets the study key, for use in the study cache.
        /// </summary>
        /// <param name="dataSet">The data set.</param>
        /// <returns>The key for the study</returns>
        private string GetStudyKey(IDicomDataSet dataSet)
        {
            return dataSet.StudyUid;
        }

        /// <summary>
        /// Gets the study list from files.
        /// </summary>
        /// <param name="sourceRootPath">The source root path.</param>
        /// <param name="dicomFiles">The dicom files.</param>
        private void GetStudyListFromFiles(string sourceRootPath, List<string> dicomFiles)
        {
            // Reset the progress bar to show only the dicom files
            this.ProgressViewModel.IsIndeterminate = false;
            this.ProgressViewModel.Minimum = 0;
            this.ProgressViewModel.Maximum = dicomFiles.Count;
            this.ProgressViewModel.Value = 0;
            foreach (string dicomFile in dicomFiles)
            {
                this.ProgressViewModel.Text = "Reading header for file: " + dicomFile;

                // DicomDataSet dataSet = new DicomDataSet(dicomFile);
                IDicomDataSet dataSet = GetDicomDataSet(dicomFile);

                this.ProgressViewModel.Text = "Adding file to study: " + dicomFile;
                this.AddFileToStudy(sourceRootPath, dicomFile, dataSet);
                this.ProgressViewModel.Value++;
                if (this.Worker.CancellationPending)
                {
                    return;
                }
            }

            // Now that we have gone through all the files and built the list of studies, add
            // them to the WorkItemDetails
            int studyNumber = 1;
            foreach (Study study in this.studyCache.Values)
            {
                study.IdInMediaBundle = studyNumber++;
                this.UIDispatcher.Invoke(
                    DispatcherPriority.Normal, (Action)(() => this.StudiesOnMedia.Add(study)));
            }
        }

        /// <summary>
        /// Determines whether the file has a DICOM preamble.
        /// </summary>
        /// <param name="filePath">The file path.</param>
        /// <returns>
        ///   <c>true</c> if the file has a DICOM preamble; otherwise, <c>false</c>.
        /// </returns>
        private bool HasDicomPreamble(string filePath)
        {
            bool isDicomFile = false;

            try
            {
                using (var reader = new BinaryReader(File.Open(filePath, FileMode.Open, FileAccess.Read)))
                {
                    reader.BaseStream.Seek(128, SeekOrigin.Begin);
                    byte[] buffer = reader.ReadBytes(4);

                    if (buffer.Length == 4 && (buffer[0] == 68) && (buffer[1] == 73) && (buffer[2] == 67)
                        && (buffer[3] == 77))
                    {
                        isDicomFile = true;
                    }
                }
            }
            catch (Exception e)
            {
                var sb = new StringBuilder();
                sb.AppendLine("Unable to open file to check DICOM for preamble: " + filePath);
                sb.AppendLine(e.Message);
                Logger.Warn(sb.ToString());
                isDicomFile = false;
            }

            return isDicomFile;
        }

        /// <summary>
        /// The initialize work item.
        /// </summary>
        /// <param name="sourceRootPath">The source root path.</param>
        /// <param name="isToBeStaged">The is to be staged.</param>
        private void InitializeWorkItem(string sourceRootPath, bool isToBeStaged)
        {
            this.InitializeWorkItem(sourceRootPath, isToBeStaged, null);
        }

        /// <summary>
        /// The perform file copy.
        /// </summary>
        /// <param name="serverAndShare">The server and share.</param>
        /// <param name="rootDir">The root dir.</param>
        /// <param name="credentials">The credentials.</param>
        /// <exception cref="NetworkLocationConnectionException">Could not connect to the current write location at ' + serverAndShare + '</exception>
        private void PerformFileCopy(string serverAndShare, string rootDir, NetworkCredential credentials)
        {
            NetworkConnection conn = null;
            try
            {
                // Cancel if requested
                if (this.Worker != null && this.Worker.CancellationPending)
                {
                    return;
                }

                if (serverAndShare.StartsWith("\\\\"))
                {
                    // Not a local drive. Open network connection
                    ProgressViewModel.IsIndeterminate = true;
                    ProgressViewModel.Text = "Opening network connection...";

                    conn = NetworkConnection.GetNetworkConnection(serverAndShare, credentials);
                    if (conn == null)
                    {
                        throw new NetworkLocationConnectionException("Could not connect to the current write location at '" + serverAndShare + "'");
                    }
                }

                int totalFiles = this.GetStagingFileCount(this.WorkItemDetails.Studies);

                // Reset the progress bar for the file copying operation
                this.ProgressViewModel.IsIndeterminate = false;
                this.ProgressViewModel.Maximum = totalFiles;
                this.ProgressViewModel.Minimum = 0;
                this.ProgressViewModel.Value = 0;
                int currentFile = 1;

                // Establish the non-DICOM root directory
                string nonDicomRootDir = rootDir + "\\NonDicom";

                // Copy over all the images
                foreach (Study study in this.WorkItemDetails.Studies)
                {
                    if (study.Series != null)
                    {
                        foreach (Series series in study.Series)
                        {
                            foreach (SopInstance instance in series.SopInstances)
                            {
                                string sourcePath = this.BuildSourcePath(
                                    this.WorkItemDetails.LocalSourcePath, instance.FilePath);
                                string destinationPath = this.BuildDestinationPath(
                                    serverAndShare, rootDir, instance.FilePath);

                                this.ProgressViewModel.Text = "Staging DICOM file " + currentFile++ + " of " +
                                                                totalFiles + ": "
                                                                + sourcePath;

                                var f = new FileInfo(destinationPath);
                                if (f.Directory != null && !f.Directory.Exists)
                                {
                                    f.Directory.Create();
                                }

                                if (!instance.IsStaged)
                                {
                                    // Copy the file using the default number of retries
                                    RetryUtility.RetryAction(
                                        () => this.EraseAndCopyFile(sourcePath, destinationPath));
                                    instance.IsStaged = true;
                                }

                                // Increment the progressbar
                                this.ProgressViewModel.Value++;

                                // Cancel if requested
                                if (this.Worker != null && this.Worker.CancellationPending)
                                {
                                    return;
                                }
                            }
                        }
                    }

                    // Stage any reconciled NonDicomFiles
                    if (study.Reconciliation != null && study.Reconciliation.NonDicomFiles != null)
                    {
                        // Copy over all the Non-DICOM files
                        ObservableCollection<NonDicomFile> destNonDicomFiles = new ObservableCollection<NonDicomFile>();
                        foreach (NonDicomFile sourceNonDicomFile in study.Reconciliation.NonDicomFiles)
                        {
                            FileInfo destNonDicomFile = StageNonDicomFile(serverAndShare, sourceNonDicomFile, nonDicomRootDir);

                            this.ProgressViewModel.Text = "Staging Non-DICOM file " + currentFile++ + " of " + this.ProgressViewModel.Maximum +
                                    ": " + sourceNonDicomFile.FilePath;


                            destNonDicomFiles.Add(new NonDicomFile(destNonDicomFile.FullName, sourceNonDicomFile.Name));
                        }

                        study.Reconciliation.NonDicomFiles = destNonDicomFiles;
                    }
                }

                if (this.IsMixedorNonDicomMedia)
                {
                    // Reset the progress bar for the Non-DICOM file copying operation
                    this.ProgressViewModel.IsIndeterminate = false;
                    this.ProgressViewModel.Maximum = this.WorkItemDetails.NonDicomFiles.Count;
                    this.ProgressViewModel.Minimum = 0;
                    this.ProgressViewModel.Value = 0;
                    currentFile = 1;

                    ObservableCollection<NonDicomFile> destNonDicomFiles = new ObservableCollection<NonDicomFile>();

                    // Copy over all the Non-DICOM files
                    foreach (NonDicomFile sourceNonDicomFile in this.WorkItemDetails.NonDicomFiles)
                    {
                        FileInfo destNonDicomFile = StageNonDicomFile(serverAndShare, sourceNonDicomFile, nonDicomRootDir);

                        this.ProgressViewModel.Text = "Staging Non-DICOM file " + currentFile++ + " of " + this.ProgressViewModel.Maximum +
                              ": " + sourceNonDicomFile.FilePath;


                        // Increment the progressbar
                        this.ProgressViewModel.Value++;

                        // Cancel if requested
                        if (this.Worker != null && this.Worker.CancellationPending)
                        {
                            return;
                        }

                        destNonDicomFiles.Add(new NonDicomFile(destNonDicomFile.FullName, sourceNonDicomFile.Name));
                    }

                    this.WorkItemDetails.NonDicomFiles = destNonDicomFiles;

                }
            }
            catch (Exception e)
            {
                Logger.Error(e.Message, e);
            }
            finally
            {
                if (conn != null)
                {
                    conn.Dispose();
                }
            }
        }

        /// <summary>
        /// Removes Studies, Series, or SOP instances from the object graph if the referenced files
        /// are not found on the media.
        /// </summary>
        /// <param name="sourceRootPath">The source root path.</param>
        /// <param name="studiesOnMedia">The studies on media.</param>
        /// <returns>Returns <c>true</c> if any files were found to be missing; otherwise <c>false</c></returns>
        private bool StripMissingFiles(string sourceRootPath, ObservableCollection<Study> studiesOnMedia)
        {
            int totalFiles = this.GetStagingFileCount(studiesOnMedia);
            int missingFiles = 0;

            this.ProgressViewModel.IsIndeterminate = false;
            this.ProgressViewModel.Value = 0;
            this.ProgressViewModel.Maximum = totalFiles;

            for (int i = studiesOnMedia.Count - 1; i >= 0; i--)
            {
                Study study = studiesOnMedia[i];

                for (int j = study.Series.Count - 1; j >= 0; j--)
                {
                    Series series = study.Series[j];

                    for (int k = series.SopInstances.Count - 1; k >= 0; k--)
                    {
                        SopInstance instance = series.SopInstances[k];

                        this.ProgressViewModel.Value++;
                        this.ProgressViewModel.Text = "Verifying existence of file " + this.ProgressViewModel.Value
                                                      + ": " + instance.FilePath;

                        string fullPath = PathUtilities.CombinePath(sourceRootPath, instance.FilePath);

                        if (!File.Exists(fullPath))
                        {
                            this.UIDispatcher.Invoke(
                                DispatcherPriority.Normal, (Action)(() => series.SopInstances.RemoveAt(k)));
                            missingFiles++;
                        }
                    }

                    if (series.SopInstances.Count == 0)
                    {
                        this.UIDispatcher.Invoke(
                            DispatcherPriority.Normal, (Action)(() => study.Series.RemoveAt(j)));
                    }
                }

                if (study.Series.Count == 0)
                {
                    this.UIDispatcher.Invoke(
                        DispatcherPriority.Normal, (Action)(() => studiesOnMedia.RemoveAt(i)));
                }
            }

            if (missingFiles > 0)
            {
                string message =
                    string.Format(
                        "The DICOMDIR file indicated that there should be {0} images, \n"
                        + "but the number of images actually found on the media was {1}.\n\n"
                        + "Would you like to continue?", 
                        totalFiles, 
                        totalFiles - missingFiles);

                string caption = "Invalid DICOMDIR";

                this.WorkItemDetails.MediaValidationStatusCode = DicomMediaValidationStatusCodes.InvalidDicomDir;

                this.WorkItemDetails.MediaValidationMessage =
                    string.Format(
                        "DICOMDIR indicated {0} files but only {1} were found", totalFiles, totalFiles - missingFiles);

                return this.DialogService.ShowYesNoBox(this.UIDispatcher, message, caption, MessageTypes.Warning);
            }
            else
            {
                return true;
            }
        }

        #endregion
    }
}
