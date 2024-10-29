//-----------------------------------------------------------------------
// <copyright file="ViewModel.cs" company="Department of Veterans Affairs">
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
namespace VistA.Imaging.Prism
{
    using System;
    using System.ComponentModel;
    using System.Diagnostics.Contracts;
    using Microsoft.Practices.Prism;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// A base class for view models which implements INotifyPropertyChanged, IConfirmNavigationRequest, IActiveAware
    /// </summary>
    /// <typeparam name="TModule">The type of the module.</typeparam>
    public abstract class ViewModel : INotifyPropertyChanged, IConfirmNavigationRequest, IActiveAware
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
            Contract.Ensures(this.RegionManager == regionManager);
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
        // Warning disabled because the event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 0067

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets a value indicating whether the object is active.
        /// </summary>
        public virtual bool IsActive { get; set; }

        #endregion

        #region Protected Properties

        /// <summary>
        /// Gets or sets the region manager.
        /// </summary>
        protected IRegionManager RegionManager { get; set; }

        #endregion

        /// <summary>
        /// Initialzes this instance.
        /// </summary>
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
