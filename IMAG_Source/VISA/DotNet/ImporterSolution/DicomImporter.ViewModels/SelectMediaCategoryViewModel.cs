/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 05/20/2013
 * Site Name:  Washington OI Field Office, Columbia, MD
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
    using DicomImporter.Common.Model;
    using DicomImporter.Common.ViewModels;
    using DicomImporter.Common.Views;
    using ImagingClient.Infrastructure.DialogService;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// The Select Media Category View Model
    /// </summary>
    public class SelectMediaCategoryViewModel : ImporterViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The dicom importing details
        /// </summary>
        private const string dicomDetailsImporting = "• Only DICOM files will be allowed to be imported.";

        /// <summary>
        /// The dicom staging details
        /// </summary>
        private const string dicomDetailsStaging = "• Only DICOM files will be allowed to be staged.";

        /// <summary>
        /// The Non-DICOM importing details 
        /// </summary>
        private const string nonDicomDetailsImporting = "• Only Non-DICOM files will be allowed to be imported. \n\n" +
                                                        "• All Non-DICOM files selected must be for the same patient and order.";

        /// <summary>
        /// The Non-DICOM staging details 
        /// </summary>
        private const string nonDicomDetailsStaging = "• A patient must be selected in order to stage the media. \n\n" +
                                                      "• A text area is provided in order to pass notes to the reconciler \n\n" +
                                                      "• Only Non-DICOM files will be allowed to be staged. \n\n" +
                                                      "• All Non-DICOM files selected must be for the same patient and order.";

        /// <summary>
        /// The mixed DICOM details
        /// </summary>
        private const string mixedDicomDetails = "• Each Non-DICOM file selected here must belong with a study in the same media bundle. \n\n" +
                                                 "• At least one valid DICOM and non-DICOM file must be selected in order to stage media.";

        /// <summary>
        /// The mixed DICOM importing details 
        /// </summary>
        private const string mixedDicomDetailsImporting = "• Each non-DICOM file selected must belong with a study in the same media bundle. \n\n" +
                                                          "• At least one valid DICOM and non-DICOM file must be selected in order to import.";

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="SelectMediaCategoryViewModel" /> class.
        /// </summary>
        /// <param name="dialogService">The dialog service.</param>
        public SelectMediaCategoryViewModel(IDialogService dialogService)
        {
            this.DialogService = dialogService;

            this.NavigateToDirectImportHomeView = new DelegateCommand<object>(
                    o => this.NavigateMediaCategory(ImporterViewNames.DirectImportHomeView),
                    o => this.MediaCategorySelected() && this.IsForDirectImport);

            this.NavigateToMediaStagingView = new DelegateCommand<object>(
                    o => this.NavigateMediaCategory(ImporterViewNames.MediaStagingView),
                    o => this.MediaCategorySelected() && this.IsForMediaStaging);
           
            this.NavigateToImporterHomeView = new DelegateCommand<object>(
                    o => this.NavigateMainRegionTo(ImporterViewNames.ImporterHomeView));

            this.ServiceNoneSelected = true;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets a value indicating whether [DICOM only media selected].
        /// </summary>
        public bool DicomOnlyMediaSelected
        {
            get
            {
                if (this.MediaCategory == null)
                {
                    return false;
                }

                return MediaCategories.DICOM.Equals(this.SelectedMediaCategory);
            }

            set
            {
                this.SelectedMediaCategory = MediaCategories.DICOM;

                this.RemoveInstructions();
                this.RaisePropertyChanged("MixedMediaSelected");
                this.RaisePropertyChanged("NonDicomMediaSelected");

                this.NavigateToMediaStagingView.RaiseCanExecuteChanged();
                this.NavigateToDirectImportHomeView.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets a value indicating whether [Service Radiology selected].
        /// </summary>
        public bool ServiceRadiologySelected
        {
            get
            {
                if (this.WorkItemService == null)
                {
                    return false;
                }

                return Services.Radiology.Equals(this.SelectedWorkItemService);
            }

            set
            {
                this.SelectedWorkItemService = Services.Radiology;
                this.RaisePropertyChanged("ServiceConsultSelected");
                this.RaisePropertyChanged("ServiceLabSelected");
                this.RaisePropertyChanged("ServiceNoneSelected");
            }
        }

        /// <summary>
        /// Gets a value indicating whether [Service Consult selected].
        /// </summary>
        public bool ServiceConsultSelected
        {
            get
            {
                if (this.WorkItemService == null)
                {
                    return false;
                }

                return Services.Consult.Equals(this.SelectedWorkItemService);
            }

            set
            {
                this.SelectedWorkItemService = Services.Consult;
                this.RaisePropertyChanged("ServiceRadiologySelected");
                this.RaisePropertyChanged("ServiceLabSelected");
                this.RaisePropertyChanged("ServiceNoneSelected");
            }
        }

        /// <summary>
        /// Gets a value indicating whether [Service Lab selected].
        /// </summary>
        public bool ServiceLabSelected
        {
            get
            {
                if (this.WorkItemService == null)
                {
                    return false;
                }

                return Services.Lab.Equals(this.SelectedWorkItemService);
            }

            set
            {
                this.SelectedWorkItemService = Services.Lab;
                this.RaisePropertyChanged("ServiceRadiologySelected");
                this.RaisePropertyChanged("ServiceConsultSelected");
                this.RaisePropertyChanged("ServiceNoneSelected");
            }
        }

        /// <summary>
        /// Gets a value indicating whether [Service None selected].
        /// </summary>
        public bool ServiceNoneSelected
        {
            get
            {
                if (this.WorkItemService == null)
                {
                    return false;
                }

                return Services.None.Equals(this.SelectedWorkItemService);
            }

            set
            {
                this.SelectedWorkItemService = Services.None;
                this.RaisePropertyChanged("ServiceRadiologySelected");
                this.RaisePropertyChanged("ServiceConsultSelected");
                this.RaisePropertyChanged("ServiceLabSelected");
            }
        }

        /// <summary>
        /// Gets a value indicating whether this instance is for direct import.
        /// </summary>
        public bool IsForDirectImport 
        {
            get
            {
                if (this.MediaCategory == null)
                {
                    return false;
                }
               
                return !this.MediaCategory.IsForMediaStaging;
            }
        }

        /// <summary>
        /// Gets a value indicating whether this instance is for media staging.
        /// </summary>
        public bool IsForMediaStaging
        {
            get
            {
                if (this.MediaCategory == null)
                {
                    return false;
                }

                return this.MediaCategory.IsForMediaStaging;
            }
        }

        /// <summary>
        /// Gets the media category details.
        /// </summary>
        public string MediaCategoryDetails
        {
            get
            {
                if (this.MediaCategory != null && this.MediaCategory.IsForMediaStaging)
                {
                    switch (this.SelectedMediaCategory)
                    {
                        case MediaCategories.DICOM:
                            return dicomDetailsStaging;
                        case MediaCategories.NonDICOM:
                            return nonDicomDetailsStaging;
                        case MediaCategories.Mixed:
                            return mixedDicomDetails;
                    }
                }
                else
                {
                    switch (this.SelectedMediaCategory)
                    {
                        case MediaCategories.DICOM:
                            return dicomDetailsImporting;
                        case MediaCategories.NonDICOM:
                            return nonDicomDetailsImporting;
                        case MediaCategories.Mixed:
                            return mixedDicomDetailsImporting;
                    }
                }

                return String.Empty;
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether [mixed media selected].
        /// </summary>
        public bool MixedMediaSelected
        {
            get
            {
                if (this.MediaCategory == null)
                {
                    return false;
                }

                return MediaCategories.Mixed.Equals(this.SelectedMediaCategory);
            }

            set
            {
                this.SelectedMediaCategory = MediaCategories.Mixed;

                this.RemoveInstructions();

                this.RaisePropertyChanged("DicomOnlyMediaSelected");
                this.RaisePropertyChanged("NonDicomMediaSelected");

                this.NavigateToMediaStagingView.RaiseCanExecuteChanged();
                this.NavigateToDirectImportHomeView.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether [non DICOM media selected].
        /// </summary>
        public bool NonDicomMediaSelected
        {
            get
            {
                if (this.MediaCategory == null)
                {
                    return false;
                }

                return MediaCategories.NonDICOM.Equals(this.SelectedMediaCategory);
            }

            set
            {
                this.SelectedMediaCategory = MediaCategories.NonDICOM;

                this.RemoveInstructions();
                this.RaisePropertyChanged("MixedMediaSelected");
                this.RaisePropertyChanged("DicomOnlyMediaSelected");

                this.NavigateToMediaStagingView.RaiseCanExecuteChanged();
                this.NavigateToDirectImportHomeView.RaiseCanExecuteChanged();
            }
        }

        /// <summary>
        /// Gets the title.
        /// </summary>
        public string Title
        {
            get
            {
                string title = " Media Category";

                if (this.IsForMediaStaging)
                {
                    return  "Staging" + title;
                }

                return "Direct Import" + title;
            }
        }

        #endregion

        #region Delegate Commands

        /// <summary>
        /// Gets or sets the navigate to direct import home view.
        /// </summary>
        public DelegateCommand<object> NavigateToDirectImportHomeView { get; set; }

        /// <summary>
        /// Gets or sets the navigate to importer home view.
        /// </summary>
        public DelegateCommand<object> NavigateToImporterHomeView { get; set; }

        /// <summary>
        /// Gets or sets the navigate to media staging view.
        /// </summary>
        public DelegateCommand<object> NavigateToMediaStagingView { get; set; }

        #endregion

        #region Public Methods

      
        #endregion

        #region Public Events

        /// <summary>
        /// The on navigated to.
        /// </summary>
        /// <param name="navigationContext">The navigation context.</param>
        public override void OnNavigatedTo(NavigationContext navigationContext)
        {
            base.OnNavigatedTo(navigationContext);

            this.RaisePropertyChanged("Instructions");
            this.RaisePropertyChanged("IsForDirectImport");
            this.RaisePropertyChanged("IsForMediaStaging");
            this.RaisePropertyChanged("Title");

            if (!this.DicomOnlyMediaSelected && !this.MixedMediaSelected && !this.NonDicomMediaSelected)
            {
                this.AddMessage(MessageTypes.Info, this.GetInstructions());
            }
        }

        #endregion

        #region Private Methods


        /// <summary>
        /// Gets the generated instructions.
        /// </summary>
        /// <value>
        /// The instructions.
        /// </value>
        private string GetInstructions()
        {
            string instructions = "Please select the type of media that will be ";

            if (this.IsForMediaStaging)
            {
                return instructions + "staged.";
            }

            return instructions + "imported.";  
        }

        /// <summary>
        /// Medias the category selected.
        /// </summary>
        /// <returns></returns>
        private bool MediaCategorySelected()
        {
            if (String.IsNullOrEmpty(this.SelectedMediaCategory)) 
            {
                return false;
            }

            return true;
        }

        /// <summary>
        /// Remove the instructions.
        /// </summary>
        /// <returns></returns>
        private void RemoveInstructions()
        {
            this.RemoveMessage(this.GetInstructions());
        }

        /// <summary>
        /// Gets or sets the selected media category.
        /// </summary>
        private string SelectedMediaCategory 
        {
            get
            {
                if (this.MediaCategory == null)
                {
                    return null;
                }

                return this.MediaCategory.Category;
            }

            set
            {
                if (this.MediaCategory == null)
                {
                    this.MediaCategory = new MediaCategory();
                }

                this.MediaCategory.Category = value;

                this.RaisePropertyChanged("MediaCategoryDetails");
            }
        }

        
        /// <summary>
        /// Gets or sets the selected work item service
        /// </summary>
        private string SelectedWorkItemService
        {
            get
            {
                if (this.WorkItemService == null)
                {
                    return null;
                }

                return this.WorkItemService.Value;
            }

            set
            {
                if (this.WorkItemService == null)
                {
                    this.WorkItemService = new Service();
                }

                this.WorkItemService.Value = value;
            }
        }

        #endregion
    }
}
