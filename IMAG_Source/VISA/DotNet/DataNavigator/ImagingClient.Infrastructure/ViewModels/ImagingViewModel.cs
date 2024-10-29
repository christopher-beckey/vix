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


using System;
using System.ComponentModel;
using System.Windows.Threading;
using ImagingClient.Infrastructure.Commands;
using ImagingClient.Infrastructure.DialogService;
using Microsoft.Practices.Prism;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Regions;
using Microsoft.Practices.ServiceLocation;

namespace ImagingClient.Infrastructure.ViewModels
{
    public class ImagingViewModel : IConfirmNavigationRequest, INotifyPropertyChanged, IActiveAware
    {
        // The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
        public Dispatcher UIDispatcher { get; set; }

        public DelegateCommand<CancelEventArgs> ShutdownCommand { get; set; }
        public DelegateCommand<CancelEventArgs> LogoutCommand { get; set; }
        public DelegateCommand<CancelEventArgs> NavigateCommand { get; set; }

        protected BackgroundWorker worker;

        public IDialogService DialogService { get; set; }

        public virtual void OnNavigatedTo(NavigationContext navigationContext)
        {
            ShutdownCommand = new DelegateCommand<CancelEventArgs>(OnShutdown);
            LogoutCommand = new DelegateCommand<CancelEventArgs>(OnLogout);
            NavigateCommand = new DelegateCommand<CancelEventArgs>(OnNavigate);

            CompositeCommands.ShutdownCommand.RegisterCommand(ShutdownCommand);
            CompositeCommands.LogoutCommand.RegisterCommand(LogoutCommand);
            CompositeCommands.NavigateCommand.RegisterCommand(NavigateCommand);

        }

        public virtual void OnNavigatedFrom(NavigationContext navigationContext)
        {
            CompositeCommands.ShutdownCommand.UnregisterCommand(ShutdownCommand);
            CompositeCommands.LogoutCommand.UnregisterCommand(LogoutCommand);
            CompositeCommands.NavigateCommand.UnregisterCommand(NavigateCommand);
        }

        public virtual bool IsNavigationTarget(NavigationContext navigationContext)
        {
            return false;
        }

        protected virtual void OnLogout(CancelEventArgs args)
        {
            CheckForBackgroundWork(args);
        }

        protected virtual void OnShutdown(CancelEventArgs args)
        {
            CheckForBackgroundWork(args);
        }

        protected virtual void OnNavigate(CancelEventArgs args)
        {
            CheckForBackgroundWork(args);
        }

        private void CheckForBackgroundWork(CancelEventArgs args)
        {
            if (worker != null && worker.IsBusy)
            {
                String message = "You currently have work in progress. You must either cancel it or wait for it to complete.";
                String caption = "Work in Progress";
                DialogService.ShowAlertBox(UIDispatcher, message, caption, MessageTypes.Error);
                args.Cancel = true;
            }
        }

        public virtual void ConfirmNavigationRequest(NavigationContext navigationContext, Action<bool> continuationCallback)
        {
            continuationCallback(true);
        }

        protected void NavigateMainRegionTo(String uri)
        {

            CancelEventArgs e = new CancelEventArgs();
            if (CompositeCommands.NavigateCommand.CanExecute(e))
                CompositeCommands.NavigateCommand.Execute(e);

            // Only navigate if the listeners say it's OK.
            if (!e.Cancel)
            {
                var manager = ServiceLocator.Current.GetInstance<IRegionManager>();
                manager.RequestNavigate(RegionNames.MainRegion, uri);
            }
        }

        protected void RaisePropertyChanged(String propertyName)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (handler != null)
            {
                handler.Invoke(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        private bool isActive;
        public bool IsActive
        {
            get
            {
                return isActive;
            }
            set
            {
                isActive = value;
            }
        }

        public event EventHandler IsActiveChanged;
    }
}
