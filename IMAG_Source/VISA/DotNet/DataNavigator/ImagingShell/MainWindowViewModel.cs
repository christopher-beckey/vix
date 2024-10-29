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

using System.ComponentModel;
using System.Windows;
using ImagingClient.Infrastructure;
using ImagingClient.Infrastructure.Commands;
using ImagingClient.Infrastructure.User.Model;
using ImagingClient.Infrastructure.ViewModels;
using Microsoft.Practices.Prism.Commands;
using Microsoft.Practices.Prism.Regions;
using Microsoft.Practices.ServiceLocation;
using ImagingClient.Infrastructure.Prism.Mvvm;

namespace ImagingShell
{
    public class MainWindowViewModel : ViewModel
    {
        public delegate void ShowLoginWindowHandler();
        public event ShowLoginWindowHandler ShowLoginWindow;

        public MainWindowViewModel(IRegionManager regionManager)
            : base(regionManager)
        {
            OnLogOut = new DelegateCommand<object>(
                o =>
                {
                    CancelEventArgs e = new CancelEventArgs();
                    if (CompositeCommands.LogoutCommand.CanExecute(e))
                        CompositeCommands.LogoutCommand.Execute(e);

                    if (!e.Cancel)
                    {
                        LoginManager.IsAttemptingLogout = true;

                        // If the user didn't cancel logout, clear the credentials and show the login window
                        if (!LoginManager.IsLogoutCancelled)
                        {
                            UserContext.UserCredentials = null;
                            OnShowLoginWindow();
                        }

                        // Clean up for next time...
                        LoginManager.IsAttemptingLogout = false;
                        LoginManager.IsLogoutCancelled = false;
                    }

                });

            //ShowDicomHome = new DelegateCommand<object>(
            //    o => NavigateMainRegionTo("ImporterHomeView"));
        }

        public void OnShowLoginWindow()
        {
            if (ShowLoginWindow != null)
            {
                ShowLoginWindow();
            }
        }

        public DelegateCommand<object> OnExit { get; set; }
        public DelegateCommand<object> OnLogOut { get; set; }
        public DelegateCommand<object> ShowDicomHome { get; set; }
    }
}
