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
namespace ImagingClient.Infrastructure.Views
{
    using System.Collections.ObjectModel;

    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.ViewModels;

    /// <summary>
    /// Interaction logic for LoginWindow.xaml
    /// </summary>
    public partial class DivisionWindow
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="DivisionWindow"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public DivisionWindow(DivisionWindowViewModel viewModel) : base()
        {
            this.InitializeComponent();
            this.DataContext = viewModel;
            viewModel.WindowAction += this.HandleWindowAction;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets AccessCode.
        /// </summary>
        public string AccessCode { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether LoginSuccessful.
        /// </summary>
        public bool LoginSuccessful { get; set; }

        /// <summary>
        /// Gets or sets SecurityKeys.
        /// </summary>
        public ObservableCollection<string> SecurityKeys { get; set; }

        /// <summary>
        /// Gets or sets VerifyCode.
        /// </summary>
        public string VerifyCode { get; set; }

        #endregion

        #region Methods

        /// <summary>
        /// The handle window action.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void HandleWindowAction(object sender, WindowActionEventArgs e)
        {
            this.Close(null);
        }

        #endregion
    }
}