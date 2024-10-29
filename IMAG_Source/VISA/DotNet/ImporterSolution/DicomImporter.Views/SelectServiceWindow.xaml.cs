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
    public partial class SelectServiceWindow
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(SelectServiceWindow));

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="DeleteWithRemainingFilesWindow"/> class.
        /// </summary>
        public SelectServiceWindow() : base()
        {
            this.InitializeComponent();
            this.cboWorkItemServices.Items.Add("Radiology");
            this.cboWorkItemServices.Items.Add("Consult");
            this.cboWorkItemServices.Items.Add("Lab");

            this.ShowInTaskbar = false;
        }


        #endregion

        #region Properties

        public bool IsServiceSelected { get; set; }
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
        private void UpdateServiceClick(object sender, System.Windows.RoutedEventArgs e)
        {

            IsServiceSelected = true;

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
            IsServiceSelected = false;

            // Close the navigator window
            this.Close(null);
        }

        #endregion

        #region public Methods
        public string getService()
        {
            return this.cboWorkItemServices.SelectedItem.ToString();
        }


        #endregion

    }
}