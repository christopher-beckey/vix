//-----------------------------------------------------------------------
// <copyright file="ViewModelBase.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace ImagingClient.Infrastructure.Prism.Mvvm
{
    using System;
    using System.ComponentModel;
    using System.Diagnostics.Contracts;
    using System.Windows.Threading;
    using Microsoft.Practices.Prism;
    using Microsoft.Practices.Prism.Modularity;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// A base class for view models which implements INotifyPropertyChanged, IConfirmNavigationRequest, IActiveAware
    /// </summary>
    /// <typeparam name="TModule">The type of the module.</typeparam>
    public abstract class ViewModel : IViewModel
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ViewModel"/> class.
        /// </summary>
        public ViewModel()
        {
            
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="ViewModel"/> class.
        /// </summary>
        /// <param name="regionManager">The region manager.</param>
        public ViewModel(IRegionManager regionManager)
        {
            Contract.Requires<ArgumentNullException>(regionManager != null);
            this.RegionManager = regionManager;
        }

        #region Events

        /// <summary>
        /// Notifies that the value for Microsoft.Practices.Prism.IActiveAware.IsActive property has changed.
        /// </summary>
        public event EventHandler IsActiveChanged;

        /// <summary>
        /// Occurs when a property value changes.
        /// </summary>
        /// <remarks>
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </remarks>
#pragma warning disable 0067
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 0067

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets a value indicating whether the object is active.
        /// </summary>
        public virtual bool IsActive { get; set; }

        /// <summary>
        /// Gets or sets the UI dispatcher.
        /// </summary>
        public virtual Dispatcher UIDispatcher { get; set; }

        #endregion

        #region Protected Properties

        protected IRegionManager RegionManager { get; set; }

        #endregion

        public virtual void Initialze()
        {

        }

        #region IConfirmNavigationRequest Methods

        /// <summary>
        /// Determines whether this instance accepts being navigated away from.
        /// </summary>
        /// <param name="navigationContext">The navigation context.</param>
        /// <param name="continuationCallback">The callback to indicate when navigation can proceed.</param>
        public virtual void ConfirmNavigationRequest(NavigationContext navigationContext, Action<bool> continuationCallback)
        {
            if (continuationCallback != null)
            {
                continuationCallback(true);
            }
        }

        /// <summary>
        /// Called to determine if this instance can handle the navigation request.
        /// </summary>
        /// <param name="navigationContext">The navigation context.</param>
        /// <returns>
        ///   <see langword="true"/> if this instance accepts the navigation request; otherwise, <see langword="false"/>.
        /// </returns>
        public virtual bool IsNavigationTarget(NavigationContext navigationContext)
        {
            return false;
        }

        /// <summary>
        /// Called when the implementer is being navigated away from.
        /// </summary>
        /// <param name="navigationContext">The navigation context.</param>
        public virtual void OnNavigatedFrom(NavigationContext navigationContext)
        {
            return;
        }

        /// <summary>
        /// Called when the implementer has been navigated to.
        /// </summary>
        /// <param name="navigationContext">The navigation context.</param>
        public virtual void OnNavigatedTo(NavigationContext navigationContext)
        {
        }

        #endregion

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
