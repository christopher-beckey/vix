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
    using DicomImporter.Common.Views;
    using DicomImporter.Common.ViewModels;

    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// The administration home view model.
    /// </summary>
    public class AdministrationHomeViewModel : ImporterViewModel
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="AdministrationHomeViewModel"/> class.
        /// </summary>
        public AdministrationHomeViewModel()
        {
            this.NavigateToAdminRevertWorkItemView =
                new DelegateCommand<object>(
                    o => this.NavigateMainRegionTo(ImporterViewNames.AdminRevertWorkItemView), o => this.HasAdministratorKey);

            this.NavigateToInProcessImportsView =
                new DelegateCommand<object>(
                    o => this.NavigateMainRegionTo(ImporterViewNames.AdminInProcessImportsView), o => this.HasAdministratorKey);

            this.NavigateToAdminFailedImportView =
                new DelegateCommand<object>(
                    o => this.NavigateMainRegionTo(ImporterViewNames.AdminFailedImportView), o => this.HasAdministratorKey);

            this.NavigateToLogView =
                new DelegateCommand<object>(
                    o => this.NavigateMainRegionTo(ImporterViewNames.LogView), o => this.HasAdministratorKey);

            this.NavigateToImporterHomeView =
               new DelegateCommand<object>(
                   o => this.NavigateMainRegionTo(ImporterViewNames.ImporterHomeView), o => this.HasAdministratorKey);
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets NavigateToAdminRevertWorkItemView.
        /// </summary>
        public DelegateCommand<object> NavigateToAdminRevertWorkItemView { get; set; }

        /// <summary>
        /// Gets or sets NavigateToInProcessImportsView.
        /// </summary>
        public DelegateCommand<object> NavigateToInProcessImportsView { get; set; }

        /// <summary>
        /// Gets or sets NavigateToFailedImportView.
        /// </summary>
        public DelegateCommand<object> NavigateToAdminFailedImportView { get; set; }

        /// <summary>
        /// Gets or sets NavigateToLogView
        /// </summary>
        public DelegateCommand<object> NavigateToLogView { get; set; }

        /// <summary>
        /// Gets or sets NavigateToImporterHomeView.
        /// </summary>
        public DelegateCommand<object> NavigateToImporterHomeView { get; set; }

        #endregion
    }
}