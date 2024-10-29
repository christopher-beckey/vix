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
namespace DicomImporter.Views
{
    using System;
    using DicomImporter.Common.Model;
    using DicomImporter.ViewModels;
    using log4net;

    /// <summary>
    /// Interaction logic for StudyDetailsView.xaml
    /// </summary>
    public partial class DicomViewerLauncherWindow
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(DicomViewerLauncherWindow));

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="DicomViewerLauncherWindow"/> class.
        /// </summary>
        public DicomViewerLauncherWindow()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="DicomViewerLauncherWindow"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public DicomViewerLauncherWindow(DicomViewerLauncherViewModel viewModel) : base()
        {
            this.InitializeComponent();

            // Set the data context
            this.DataContext = viewModel;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets Study.
        /// </summary>
        public Study Study { get; set; }

        /// <summary>
        /// Gets ViewModel.
        /// </summary>
        public DicomViewerLauncherViewModel ViewModel
        {
            get
            {
                return (DicomViewerLauncherViewModel)this.DataContext;
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// The btn close_ click.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void Close_Click(object sender, EventArgs e)
        {
            this.CleanUpAndClose();
        }

        /// <summary>
        /// Cleans up all work being done currently and kills all 
        /// external processes spawned by this window before closing.
        /// </summary>
        private void CleanUpAndClose()
        {
            // Cancel background work
            this.ViewModel.CancelBackgroundWork();

            // Kill the viewer if it's running
            if (this.ViewModel.ViewerProcess != null && !this.ViewModel.ViewerProcess.HasExited)
            {
                try
                {
                    this.ViewModel.ViewerProcess.Kill();
                }
                catch (Exception ex)
                {
                    Logger.Error("Couldn't kill viewer process: " + ex.Message, ex);
                }
            }

            // Delete any temp files
            this.ViewModel.DeleteTempFiles();

            // Close the navigator window
            this.Close(null);
        }

        #endregion
    }
}