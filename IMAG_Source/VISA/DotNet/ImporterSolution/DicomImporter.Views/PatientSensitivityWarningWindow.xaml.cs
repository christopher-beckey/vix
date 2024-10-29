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
    /// <summary>
    /// Interaction logic for StudyDetailsView.xaml
    /// </summary>
    public partial class PatientSensitivityWarningWindow
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="PatientSensitivityWarningWindow"/> class.
        /// </summary>
        /// <param name="warningMessage">The warning message.</param>
        public PatientSensitivityWarningWindow(string warningMessage) : base()
        {
            this.InitializeComponent();
            this.txtWarning.Text = warningMessage;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets a value indicating whether the warning was accepted.
        /// </summary>
        /// <value>
        ///   <c>true</c> if the warning was accepted; otherwise, <c>false</c>.
        /// </value>
        public bool WarningAccepted { get; set; }
        
        #endregion

        #region Private Methods

        /// <summary>
        /// Handles the Click event of the btnOk control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.RoutedEventArgs"/> instance containing the event data.</param>
        private void BtnOk_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            this.WarningAccepted = true;
            this.Close(null);
        }

        /// <summary>
        /// Handles the Click event of the btnCancel control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.RoutedEventArgs"/> instance containing the event data.</param>
        private void BtnCancel_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            this.WarningAccepted = false;
            this.Close(null);
        }

        #endregion
    }
}