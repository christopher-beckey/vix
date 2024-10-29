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
namespace ImagingClient.Infrastructure.ViewModels
{
    using System.Collections.ObjectModel;
    using System.Windows;

    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.User.Model;

    using Microsoft.Practices.Prism.Commands;

    /// <summary>
    /// The division window view model.
    /// </summary>
    public class DivisionWindowViewModel : ImagingViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The selected division.
        /// </summary>
        private Division selectedDivision;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="DivisionWindowViewModel"/> class.
        /// </summary>
        /// <param name="divisions">
        /// The divisions.
        /// </param>
        public DivisionWindowViewModel(ObservableCollection<Division> divisions)
        {
            this.Divisions = divisions;

            // Handle Login attempt
            this.OnSelectDivision =
                new DelegateCommand<object>(
                    o => this.WindowAction(this, new WindowActionEventArgs(true)), 
                    o => this.SelectedDivision != null);

            // If they've cancelled login, then shutdown the application
            this.OnCancelSelectDivision = new DelegateCommand<object>(o => Application.Current.Shutdown());
        }

        #endregion

        #region Delegates

        /// <summary>
        /// The window action event handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public delegate void WindowActionEventHandler(object sender, WindowActionEventArgs e);

        #endregion

        #region Public Events

        /// <summary>
        /// The window action.
        /// </summary>
        public event WindowActionEventHandler WindowAction;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets Divisions.
        /// </summary>
        public ObservableCollection<Division> Divisions { get; set; }

        /// <summary>
        /// Gets or sets OnCancelSelectDivision.
        /// </summary>
        public DelegateCommand<object> OnCancelSelectDivision { get; set; }

        /// <summary>
        /// Gets or sets OnSelectDivision.
        /// </summary>
        public DelegateCommand<object> OnSelectDivision { get; set; }

        /// <summary>
        /// Gets or sets SelectedDivision.
        /// </summary>
        public Division SelectedDivision
        {
            get
            {
                return this.selectedDivision;
            }

            set
            {
                this.selectedDivision = value;
                this.OnSelectDivision.RaiseCanExecuteChanged();
                this.OnCancelSelectDivision.RaiseCanExecuteChanged();
            }
        }

        #endregion
    }
}