//-----------------------------------------------------------------------
// <copyright file="View.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace ImagingClient.Infrastructure.Prism.Mvvm
{
    using System;
    using System.Linq;
    using System.Windows.Controls;
    using Microsoft.Practices.Prism;
    using ImagingClient.Infrastructure.ViewModels;
    using Microsoft.Practices.Prism.Modularity;

    /// <summary>
    /// Base for implementing views
    /// </summary>
    /// <typeparam name="TModule">The type of the module.</typeparam>
    /// <typeparam name="TViewModel">The type of the view model.</typeparam>
    public class View<TViewModel> : UserControl, IActiveAware
        where TViewModel : ViewModel
    {
        /// <summary>
        /// Backing field for IsActive Property
        /// </summary>
        private bool isActive;

        #region Constructors

        /// <summary>
        /// Initializes a new instance of the View class
        /// </summary>
        public View()
        {

        }

        /// <summary>
        /// Initializes a new instance of the View class
        /// </summary>
        /// <param name="viewModel">The ViewModel for this view</param>
        public View(TViewModel viewModel)
        {
            this.ViewModel = viewModel;
            this.ViewModel.UIDispatcher = Dispatcher;
            this.ViewModel.Initialze();
        }

        #endregion

        /// <summary>
        /// Notifies that the value for Microsoft.Practices.Prism.IActiveAware.IsActive property has changed.
        /// </summary>
        public event EventHandler IsActiveChanged;

        /// <summary>
        /// Gets or sets a value indicating whether the View is active.
        /// </summary>
        /// <value>
        /// 	<see langword="true"/> if the object is active; otherwise <see langword="false"/>.
        /// </value>
        public virtual bool IsActive
        {
            get
            {
                return isActive;
            }
            set
            {
                if (isActive != value)
                {
                    isActive = value;
                    OnIsActiveChanged();
                }
            }
        }

        /// <summary>
        /// Gets or sets the ViewModel for this View
        /// </summary>
        protected TViewModel ViewModel
        {
            get
            {
                return this.DataContext as TViewModel;
            }

            set
            {
                this.DataContext = value;
            }
        }

        /// <summary>
        /// Raises the IsActiveChanged event
        /// </summary>
        /// <remarks>
        /// The OnIsActiveChanged is called by NotifyPropertyWeaver when the IsActive property changes
        /// (http://code.google.com/p/notifypropertyweaver/)
        /// </remarks>
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
