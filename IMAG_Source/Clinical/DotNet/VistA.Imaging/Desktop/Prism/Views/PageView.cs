// -----------------------------------------------------------------------
// <copyright file="PageView.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 11/30/2011
//   Site Name:  Washington OI Field Office, Silver Spring, MD
//   Developer: vhaiswgraver
//   Description: 
//         ;; +--------------------------------------------------------------------+
//         ;; Property of the US Government.
//         ;; No permission to copy or redistribute this software is given.
//         ;; Use of unreleased versions of this software requires the user
//         ;;  to execute a written test agreement with the VistA Imaging
//         ;;  Development Office of the Department of Veterans Affairs,
//         ;;  telephone (301) 734-0100.
//         ;;
//         ;; The Food and Drug Administration classifies this software as
//         ;; a Class II medical device.  As such, it may not be changed
//         ;; in any way.  Modifications to this software may result in an
//         ;; adulterated medical device under 21CFR820, the use of which
//         ;; is considered to be a violation of US Federal Statutes.
//         ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Prism.Views
{
    using System;
    using System.Windows.Controls;
    using Microsoft.Practices.Prism;

    /// <summary>
    /// A page with a ViewModel
    /// </summary>
    /// <typeparam name="TViewModel">The type of the view model.</typeparam>
    public class PageView<TViewModel> : Page, IActiveAware
        where TViewModel : ViewModel
    {
        #region Constructors

        /// <summary>
        /// Initializes a new instance of the <see cref="PageView&lt;TViewModel&gt;"/> class.
        /// </summary>
        public PageView()
            : base()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="PageView&lt;TViewModel&gt;"/> class.
        /// </summary>
        /// <param name="viewModel">The view model.</param>
        public PageView(TViewModel viewModel)
            : base()
        {
            this.ViewModel = viewModel;
            this.ViewModel.IsActiveChanged += new EventHandler(this.ViewModel_IsActiveChanged);
        }

        #endregion

        /// <summary>
        /// Notifies that the value for Microsoft.Practices.Prism.IActiveAware.IsActive property has changed.
        /// </summary>
        public event EventHandler IsActiveChanged;

        /// <summary>
        /// Gets or sets a value indicating whether the View is active.
        /// </summary>
        public virtual bool IsActive
        {
            get { return this.ViewModel.IsActive; }
            set { this.ViewModel.IsActive = value; }
        }

        /// <summary>
        /// Gets or sets the ViewModel for this View
        /// </summary>
        protected TViewModel ViewModel
        {
            get { return this.DataContext as TViewModel; }
            set { this.DataContext = value; }
        }

        /// <summary>
        /// Handles the IsActiveChanged event of the ViewModel control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        protected void ViewModel_IsActiveChanged(object sender, EventArgs e)
        {
            this.OnIsActiveChanged();
        }

        /// <summary>
        /// Raises the IsActiveChanged event
        /// </summary>
        protected virtual void OnIsActiveChanged()
        {
            EventHandler handler = this.IsActiveChanged;
            if (handler != null)
            {
                handler.Invoke(this, new EventArgs());
            }
        }
    }
}
