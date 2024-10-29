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

using System;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Net;
using System.Windows.Threading;
using DicomImporter.Common.Model;
using ImagingClient.Infrastructure.Storage.Model;
using ImagingClient.Infrastructure.StorageDataSource;
using ImagingClient.Infrastructure.Utilities;
using log4net;

namespace DicomImporter.ViewModels
{
    using System.Collections.Generic;

    using DicomImporter.Common.Interfaces.DataSources;
    using DicomImporter.Common.Views;
    using DicomImporter.Common.ViewModels;

    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Model;

    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The patient selection view model.
    /// </summary>
    public class AddNonDicomFilesToReconciliationViewModel : ImporterReconciliationViewModel
    {
        #region Fields

        /// <summary>
        /// The selected available file
        /// </summary>
        private NonDicomFile selectedAvailableFile = null;

        /// <summary>
        /// The selected reconciled file
        /// </summary>
        private NonDicomFile selectedReconciledFile = null;

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(AddNonDicomFilesToReconciliationViewModel));


        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="PatientSelectionViewModel"/> class.
        /// </summary>
        /// <param name="dialogService">
        /// The dialog service.
        /// </param>
        /// <param name="dicomImporterDataSource">
        /// The dicom importer data source.
        /// </param>
        public AddNonDicomFilesToReconciliationViewModel(IDialogService dialogService, IDicomImporterDataSource dicomImporterDataSource, IStorageDataSource storageDataSource)
        {
            this.DialogService = dialogService;
            this.DicomImporterDataSource = dicomImporterDataSource;
            this.StorageDataSource = storageDataSource;

            //
            // Add a file to the reconciled list
            //
            this.AddAvailableFile = new DelegateCommand<object>(
                o => this.UIDispatcher.Invoke(
                    DispatcherPriority.Normal,
                    (Action)(() =>
                                 {
                                     NonDicomFile file = SelectedAvailableFile;
                                     AvailableNonDicomFiles.Remove(file);
                                     ReconciledNonDicomFiles.Add(file);
                                     RefreshShuttleButtons();
                                 })),
                o => this.SelectedAvailableFile != null);

            //
            // Add all available files to the reconciled list
            //
            this.AddAllAvailableFiles = new DelegateCommand<object>(
                o => this.UIDispatcher.Invoke(
                    DispatcherPriority.Normal,
                    (Action)(() =>
                                 {
                                     foreach (NonDicomFile file in AvailableNonDicomFiles)
                                     {
                                         ReconciledNonDicomFiles.Add(file);
                                     }
                                     AvailableNonDicomFiles.Clear();
                                     RefreshShuttleButtons();
                                 })),
                o => this.WorkItemDetails.NonDicomFiles != null && this.WorkItemDetails.NonDicomFiles.Count > 0);

            //
            // Remove a reconciled file from the reconciled list
            //
            this.RemoveReconciledFile = new DelegateCommand<object>(
                o => this.UIDispatcher.Invoke(
                    DispatcherPriority.Normal,
                    (Action)(() =>
                                 {
                                     NonDicomFile file = SelectedReconciledFile;
                                     ReconciledNonDicomFiles.Remove(file);
                                     AvailableNonDicomFiles.Add(file);
                                     RefreshShuttleButtons();
                                 })),
                o => this.SelectedReconciledFile != null);

            //
            // Remove all reconciled files from the reconciled list
            //
            this.RemoveAllReconciledFiles = new DelegateCommand<object>(
                o => this.UIDispatcher.Invoke(
                    DispatcherPriority.Normal,
                    (Action)(() =>
                                 {
                                     foreach (NonDicomFile file in ReconciledNonDicomFiles)
                                     {
                                         AvailableNonDicomFiles.Add(file);
                                     }
                                     ReconciledNonDicomFiles.Clear();
                                     RefreshShuttleButtons();
                                 })),
                o => this.ReconciledNonDicomFiles != null && this.ReconciledNonDicomFiles.Count > 0);

            //
            // View the selected "available file"
            //
            this.ViewAvailableFile = new DelegateCommand<object>(
                   o => LaunchPDFViewer(this.SelectedAvailableFile.FilePath),
                   o => SelectedAvailableFile != null);


            //
            // View the selected "reconciled file"
            //
            this.ViewReconciledFile = new DelegateCommand<object>(
                   o => LaunchPDFViewer(this.SelectedReconciledFile.FilePath),
                   o => SelectedReconciledFile != null);

            //
            // Navigate forward
            //
            this.NavigateForward = new DelegateCommand<object>(
                o => this.NavigateWorkItem(ImporterViewNames.ReconciliationSummaryView), 
                o => this.SelectedPatient != null);

            //
            // Navigate backward
            //
            this.NavigateBack = new DelegateCommand<object>(
                o => this.NavigateWorkItem(this.CurrentReconciliation.UseExistingOrder
                                               ? ImporterViewNames.ChooseExistingOrderView
                                               : ImporterViewNames.CreateNewRadiologyOrderView));

            this.CancelReconciliationCommand = new DelegateCommand<object>(
                o => this.CancelReconciliation());
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets NavigateBack.
        /// </summary>
        public DelegateCommand<object> NavigateBack { get; set; }

        /// <summary>
        /// Gets or sets NavigateForward.
        /// </summary>
        public DelegateCommand<object> NavigateForward { get; set; }

        /// <summary>
        /// Gets or sets the AddAvailableFile command.
        /// </summary>
        public DelegateCommand<object> AddAvailableFile { get; set; }

        /// <summary>
        /// Gets or sets the AddAllAvailableFiles command.
        /// </summary>
        public DelegateCommand<object> AddAllAvailableFiles { get; set; }

        /// <summary>
        /// Gets or sets the RemoveReconciledFile command.
        /// </summary>
        public DelegateCommand<object> RemoveReconciledFile { get; set; }

        /// <summary>
        /// Gets or sets the RemoveAllReconciledFiles command.
        /// </summary>
        public DelegateCommand<object> RemoveAllReconciledFiles { get; set; }

        /// <summary>
        /// Gets or sets the ViewAvailableFile command.
        /// </summary>
        public DelegateCommand<object> ViewAvailableFile { get; set; }

        /// <summary>
        /// Gets or sets the ViewReconciledFile command.
        /// </summary>
        public DelegateCommand<object> ViewReconciledFile { get; set; }

        /// <summary>
        /// Gets or sets the ScanDocument command.
        /// </summary>
        public DelegateCommand<object> ScanDocument { get; set; }

        /// <summary>
        /// Gets or sets the SelectedAvailableFile.
        /// </summary>
        public NonDicomFile SelectedAvailableFile 
        { 
            get { return selectedAvailableFile; }
            set 
            {
                selectedAvailableFile = value;
                RefreshShuttleButtons();
            }
        }

        /// <summary>
        /// Gets or sets the SelectedReconciledFile.
        /// </summary>
        public NonDicomFile SelectedReconciledFile
        {
            get { return selectedReconciledFile; }
            set
            {
                selectedReconciledFile = value;
                RefreshShuttleButtons();
            }
        }

        private void RefreshShuttleButtons()
        {
            AddAvailableFile.RaiseCanExecuteChanged();
            AddAllAvailableFiles.RaiseCanExecuteChanged();
            RemoveReconciledFile.RaiseCanExecuteChanged();
            RemoveAllReconciledFiles.RaiseCanExecuteChanged();
            ViewAvailableFile.RaiseCanExecuteChanged();
            ViewReconciledFile.RaiseCanExecuteChanged();
        }


        /// <summary>
        /// Gets the reconciled non DICOM files list.
        /// </summary>
        public ObservableCollection<NonDicomFile> ReconciledNonDicomFiles
        {
            get { return this.CurrentReconciliation.NonDicomFiles; }
            set { this.CurrentReconciliation.NonDicomFiles = value; }
        }

        /// <summary>
        /// Gets the available non DICOM files list.
        /// </summary>
        public ObservableCollection<NonDicomFile> AvailableNonDicomFiles
        {
            get { return this.WorkItemDetails.NonDicomFiles; }
        }

        /// <summary>
        /// Gets the SelectedPatient.
        /// </summary>
        public Patient SelectedPatient
        {
            get
            {
                return this.WorkItemDetails.CurrentStudy.Reconciliation.Patient;
            }
        }

        /// <summary>
        /// Gets the Selected Order.
        /// </summary>
        public Order SelectedOrder
        {
            get
            {
                return this.WorkItemDetails.CurrentStudy.Reconciliation.Order;
            }
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// Adds the files.
        /// </summary>
        /// <param name="files">The files.</param>
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

                        this.ReconciledNonDicomFiles.Add(file);
                    }

                    // re-sorts the Non DICOM files
                    IOrderedEnumerable<NonDicomFile> sortedList = this.ReconciledNonDicomFiles.ToList<NonDicomFile>().OrderBy(x => x.Name);
                    this.ReconciledNonDicomFiles = new ObservableCollection<NonDicomFile>(sortedList);
                }
                catch (Exception e)
                {
                    string message = "Error staging Non-DICOM file: " + e.Message;
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
                        this.ReconciledNonDicomFiles.Add(file);
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
                IOrderedEnumerable<NonDicomFile> sortedList = this.ReconciledNonDicomFiles.ToList<NonDicomFile>().OrderBy(x => x.Name);
                this.ReconciledNonDicomFiles = new ObservableCollection<NonDicomFile>(sortedList);
            }
        }

        /// <summary>
        /// Determines whether [is file already added] [the specified file].
        /// </summary>
        /// <param name="file">The file.</param>
        /// <returns>
        ///   <c>true</c> if [is file already added] [the specified file]; otherwise, <c>false</c>.
        /// </returns>
        private bool IsFileAlreadyAdded(NonDicomFile file)
        {
            foreach (NonDicomFile alreadyAddedFile in this.ReconciledNonDicomFiles)
            {
                if (file == null || file.FilePath.Equals(alreadyAddedFile.FilePath))
                {
                    return true;
                }
            }

            return false;
        }


        #endregion
    }
}