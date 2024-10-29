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
    using System;
    using System.ComponentModel;
    using System.Windows;
    using System.Windows.Threading;
    using ImagingClient.Infrastructure.Commands;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Views;
    using Microsoft.Practices.Prism;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Events;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// The imaging view model.
    /// </summary>
    public class ImagingViewModel : IConfirmNavigationRequest, INotifyPropertyChanged, IActiveAware
    {
        #region Constants and Fields

        /// <summary>
        /// The event aggregator
        /// </summary>
        protected IEventAggregator eventAggregator = ServiceLocator.Current.GetInstance<IEventAggregator>();

        /// <summary>
        /// True if a new user login has just occurred.
        /// </summary>
        protected bool isNewUserLogin;

        #endregion
       
        #region Public Events

        /// <summary>
        /// The is active changed.
        /// </summary>
        public event EventHandler IsActiveChanged;

        /// <summary>
        /// The property changed.
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets DialogService.
        /// </summary>
        public IDialogService DialogService { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether IsActive.
        /// </summary>
        public bool IsActive { get; set; }

        /// <summary>
        /// The window that owns this viewmodel
        /// </summary>
        public Window OwningWindow { get; set; }

        /// <summary>
        /// Gets or sets UIDispatcher.
        /// </summary>
        public Dispatcher UIDispatcher { get; set; }

        #endregion

        #region Delegate Commands

        /// <summary>
        /// Gets or sets LogoutCommand.
        /// </summary>
        public DelegateCommand<CancelEventArgs> LogoutCommand { get; set; }

        /// <summary>
        /// Gets or sets NavigateCommand.
        /// </summary>
        public DelegateCommand<CancelEventArgs> NavigateCommand { get; set; }

        /// <summary>
        /// Gets or sets ShutdownCommand.
        /// </summary>
        public DelegateCommand<CancelEventArgs> ShutdownCommand { get; set; }

        /// <summary>
        /// Gets or sets the timeout clear reonciliation command.
        /// </summary>
        public DelegateCommand<CancelEventArgs> TimeoutClearReconcileCommand { get; set; }

        #endregion

        #region Properties

        /// <summary>
        /// Gets or sets the worker.
        /// </summary>
        /// <value>
        /// The worker.
        /// </value>
        protected BackgroundWorker Worker { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// The confirm navigation request.
        /// </summary>
        /// <param name="navigationContext">
        /// The navigation context.
        /// </param>
        /// <param name="continuationCallback">
        /// The continuation callback.
        /// </param>
        public virtual void ConfirmNavigationRequest(
            NavigationContext navigationContext, Action<bool> continuationCallback)
        {
            continuationCallback(true);
        }

        /// <summary>
        /// Called to determine if this instance can handle the navigation request.
        /// </summary>
        /// <param name="navigationContext">
        /// The navigation context.
        /// </param>
        /// <returns>
        /// <see langword="true"/> if this instance accepts the navigation request; otherwise, <see langword="false"/>.
        /// </returns>
        public virtual bool IsNavigationTarget(NavigationContext navigationContext)
        { 
            return false;
        }

        /// <summary>
        /// The on navigated from.
        /// </summary>
        /// <param name="navigationContext">
        /// The navigation context.
        /// </param>
        public virtual void OnNavigatedFrom(NavigationContext navigationContext)
        {
            CompositeCommands.ShutdownCommand.UnregisterCommand(this.ShutdownCommand);
            CompositeCommands.TimeoutClearReconcileCommand.UnregisterCommand(this.TimeoutClearReconcileCommand);
            CompositeCommands.LogoutCommand.UnregisterCommand(this.LogoutCommand);
            CompositeCommands.NavigateCommand.UnregisterCommand(this.NavigateCommand);
        }

        /// <summary>
        /// The on navigated to.
        /// </summary>
        /// <param name="navigationContext">
        /// The navigation context.
        /// </param>
        public virtual void OnNavigatedTo(NavigationContext navigationContext)
        {
            this.ShutdownCommand = new DelegateCommand<CancelEventArgs>(this.OnShutdown);
            this.TimeoutClearReconcileCommand = new DelegateCommand<CancelEventArgs>(this.OnTimeoutCleanup);
            this.LogoutCommand = new DelegateCommand<CancelEventArgs>(this.OnLogout);
            this.NavigateCommand = new DelegateCommand<CancelEventArgs>(this.OnNavigate);

            CompositeCommands.ShutdownCommand.RegisterCommand(this.ShutdownCommand);
            CompositeCommands.TimeoutClearReconcileCommand.RegisterCommand(this.TimeoutClearReconcileCommand);
            CompositeCommands.LogoutCommand.RegisterCommand(this.LogoutCommand);
            CompositeCommands.NavigateCommand.RegisterCommand(this.NavigateCommand);
        }

        #endregion

        #region Methods

        /// <summary>
        /// The navigate main region to.
        /// </summary>
        /// <param name="uri">
        /// The uri.
        /// </param>
        protected bool NavigateMainRegionTo(string uri)
        {
            var e = new CancelEventArgs();
            if (CompositeCommands.NavigateCommand.CanExecute(e))
            {
                CompositeCommands.NavigateCommand.Execute(e);
            }

            bool bReturn = !e.Cancel;

            // Only navigate if the listeners say it's OK.
            if (bReturn)
            {
                var manager = ServiceLocator.Current.GetInstance<IRegionManager>();
                manager.RequestNavigate(RegionNames.MainRegion, uri, this.NavigationCallback);
            }

            return bReturn;
        }

        /// <summary>
        /// The on logout.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        protected virtual void OnLogout(CancelEventArgs args)
        {
            this.CheckForBackgroundWork(args);
        }

        /// <summary>
        /// The on navigate.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        protected virtual void OnNavigate(CancelEventArgs args)
        {
            // Checks to see if the reason for on navigate is because of
            // a new user logging in. If it is then dont ignore the check
            // for additional work.
            if (!this.isNewUserLogin)
            {
                this.CheckForBackgroundWork(args);
            }
        }

        /// <summary>
        /// The on shutdown.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        protected virtual void OnShutdown(CancelEventArgs args)
        {
            this.CheckForBackgroundWork(args);
        }

        /// <summary>
        /// The on timeout shutdown.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        protected virtual void OnTimeoutCleanup(CancelEventArgs args)
        {
            // Navigate back to the Importer Home View
           // this.NavigateMainRegionTo(ImagingViewNames.ImagingClientHomeView);

            this.NavigateMainRegionTo("ImporterHomeView");
        }

        /// <summary>
        /// The raise property changed.
        /// </summary>
        /// <param name="propertyName">
        /// The property name.
        /// </param>
        protected void RaisePropertyChanged(string propertyName)
        {
            PropertyChangedEventHandler handler = this.PropertyChanged;
            if (handler != null)
            {
                handler.Invoke(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        /// <summary>
        /// The check for background work.
        /// </summary>
        /// <param name="args">
        /// The args.
        /// </param>
        private void CheckForBackgroundWork(CancelEventArgs args)
        {
            if (this.Worker != null && this.Worker.IsBusy)
            {
                string message =
                    "You currently have work in progress. You must either cancel it or wait for it to complete.";
                string caption = "Work in Progress";
                this.DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);
                args.Cancel = true;
            }
        }

        /// <summary>
        /// Called when navigation is complete.
        /// </summary>
        /// <param name="navigationResult">The navigation result.</param>
        private void NavigationCallback(NavigationResult navigationResult)
        {
            if (navigationResult.Error != null)
            {
                ExceptionWindow window = new ExceptionWindow(navigationResult.Error);
                window.SubscribeToNewUserLogin();
                window.ShowDialog();
            }
        }

        /// <summary>
        /// Sets the new user login.
        /// </summary>
        /// <returns></returns>
        protected void SetNewUserLoginAlert(string user)
        {
            this.isNewUserLogin = true;
        }

        #endregion
    }
}