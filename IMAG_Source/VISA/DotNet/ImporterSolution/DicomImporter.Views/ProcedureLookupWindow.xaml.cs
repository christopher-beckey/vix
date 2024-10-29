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
    using System.Windows.Controls;
    using System.Windows.Data;
    using System.Windows.Input;

    using DicomImporter.ViewModels;

    using ImagingClient.Infrastructure.Events;

    /// <summary>
    /// Interaction logic for OrderingProviderLookupWindow.xaml
    /// </summary>
    public partial class ProcedureLookupWindow
    {
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="ProcedureLookupWindow"/> class.
        /// </summary>
        public ProcedureLookupWindow() : base()
        {
            this.InitializeComponent();
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ProcedureLookupWindow"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public ProcedureLookupWindow(ProcedureLookupViewModel viewModel) : base()
        {
            this.InitializeComponent();
            viewModel.UIDispatcher = this.Dispatcher;
            this.DataContext = viewModel;
            this.ViewModel.WindowAction += this.HandleWindowAction;
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets ViewModel.
        /// </summary>
        public ProcedureLookupViewModel ViewModel
        {
            get
            {
                return (ProcedureLookupViewModel)this.DataContext;
            }
        }

        #endregion

        #region Private Methods

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
            if (e.IsOk)
            {
                this.DialogResult = true;
            }
            else
            {
                this.Close(null);
            }
        }

        /// <summary>
        /// The search text box_ key up.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void SearchTextBox_KeyUp(object sender, KeyEventArgs e)
        {
            BindingExpression bindingExpression = this.txtSearchCriteria.GetBindingExpression(TextBox.TextProperty);
            if (bindingExpression != null)
            {
                bindingExpression.UpdateSource();
            }

            this.ViewModel.SelectedProcedure = null;
            this.ViewModel.PeformFilter();
        }

        #endregion
    }
}