//-----------------------------------------------------------------------
// <copyright file="BaseImagingView.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswlouthj, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace ImagingClient.Infrastructure.Views
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Windows.Controls;
    using ImagingClient.Infrastructure.ViewModels;
    using Microsoft.Practices.Prism;

    /// <summary>
    /// Base class for Imaging Views
    /// </summary>
    /// <typeparam name="TViewModel">The type of the ViewModel</typeparam>
    public class BaseImagingView<TViewModel> : UserControl, IActiveAware where TViewModel : ImagingViewModel
    {
        /// <summary>
        /// Backing field for IsActive Property
        /// </summary>
        private bool isActive;

        #region Constructor(s)

        /// <summary>
        /// Initializes a new instance of the BaseImagingView class
        /// </summary>
        public BaseImagingView()
        {
        }

        /// <summary>
        /// Initializes a new instance of the BaseImagingView class
        /// </summary>
        /// <param name="viewModel">The ImagingViewModel for this view</param>
        public BaseImagingView(TViewModel viewModel)
        {
            this.ViewModel = viewModel;
            this.ViewModel.UIDispatcher = Dispatcher;
        }

        #endregion

        /// <summary>
        /// Notifies that the value for Microsoft.Practices.Prism.IActiveAware.IsActive
        ///     property has changed.
        /// </summary>
        public event EventHandler IsActiveChanged;

        #region Properties

        /// <summary>
        /// Gets or sets the ImagingViewModel for this view stored in the View's DataContext
        /// </summary>
        public TViewModel ViewModel
        {
            get { return (TViewModel)DataContext; }
            protected set { this.DataContext = value; }
        }

        /// <summary>
        /// Gets or sets a value indicating whether the object is active.
        /// </summary>
        public bool IsActive
        {
            get
            {
                return this.isActive;
            }

            set
            {
                if (this.isActive != value)
                {
                    this.isActive = value;
                    IActiveAware viewModelIsAware = this.ViewModel as IActiveAware;
                    if (viewModelIsAware != null)
                    {
                        viewModelIsAware.IsActive = value;
                    }

                    this.OnIsActiveChanged();
                }
            }
        } 

        #endregion

        /// <summary>
        /// Raises the IsActiveChanged event
        /// </summary>
        private void OnIsActiveChanged()
        {
            EventHandler handler = this.IsActiveChanged;
            if (handler != null)
            {
                handler.Invoke(this, new EventArgs());
            }
        }
    }
}