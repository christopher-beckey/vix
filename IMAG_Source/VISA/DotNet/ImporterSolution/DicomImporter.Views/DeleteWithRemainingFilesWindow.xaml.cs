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
    using Microsoft.Practices.Prism.Events;
    using Microsoft.Practices.ServiceLocation;
    using ImagingClient.Infrastructure.Events;

    /// <summary>
    /// Interaction logic for StudyDetailsView.xaml
    /// </summary>
    public partial class DeleteWithRemainingFilesWindow
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(DeleteWithRemainingFilesWindow));

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="DeleteWithRemainingFilesWindow"/> class.
        /// </summary>
        public DeleteWithRemainingFilesWindow() : base()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="DeleteWithRemainingFilesWindow"/> class.
        /// </summary>
        /// <param name="fileCount">
        /// The number of DICOM files left in the staging directory.
        /// </param>
        /// <param name="stagingPath">
        /// The path to the staging directory.
        /// </param>
        public DeleteWithRemainingFilesWindow(int fileCount, String stagingPath) : base()
        {
            this.InitializeComponent();
            String imageCount = fileCount == 1 ? "1 image" : fileCount + " images";

            String messageTemplate =
                "This work item still has " + imageCount + " in the staging area. If you would like to save these images locally before " +
                "you delete the work item (in order to perform a new Direct Import, for example), " +
                "you can find the images under the staging folder at the following location:\n\n{0}\n";

            // Set the data context
            this.txtWarningMessage.Text = String.Format(messageTemplate, stagingPath);

            this.ShowInTaskbar = false;
        }

        #endregion

        #region Properties

        public bool IsDeleteRequested { get; set; }

        #endregion

        #region Private Methods

        /// <summary>
        /// The Delete button handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void DeleteClick(object sender, EventArgs e)
        {

            IsDeleteRequested = true;

            // Close the navigator window
            this.Close(null);
        }

        /// <summary>
        /// The Cancel button handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void CancelClick(object sender, EventArgs e)
        {
            IsDeleteRequested = false;

            // Close the navigator window
            this.Close(null);
        }

        #endregion
    }
}