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
    using System.Collections.ObjectModel;
    using System.Configuration;
    using System.Windows;
    using System.Runtime.InteropServices;
    using ImagingClient.Infrastructure.Broker;
    using ImagingClient.Infrastructure.DialogService;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.Logging;
    using ImagingClient.Infrastructure.Model;
    using ImagingClient.Infrastructure.User.Model;
    using ImagingClient.Infrastructure.UserDataSource;
    using Microsoft.Practices.Prism.Commands;
    using log4net;
    using VistaCommon;

    /// <summary>
    /// The login window view model.
    /// </summary>
    public class LogoutWindowViewModel : ImagingViewModel
    {
        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(LogoutWindowViewModel));
        
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="LogoutWindowViewModel"/> class.
        /// </summary>
        /// <param name="userDataSource">The user data source.</param>
        /// <param name="dialogService">The dialog service.</param>
        public LogoutWindowViewModel(IUserDataSource userDataSource, IDialogService dialogService)
        {
            this.DialogService = dialogService;

            // Handle Login attempt
            this.OnLogin = new DelegateCommand<object>(
                o =>
                {
                    //TLB - New login process
                    BrokerClient client = new BrokerClient();

                    try
                    {
                        //loginWindow.Owner = this;
                        //loginWindow.ShowDialog();
                        if (client.AuthenticateUser())
                        {
                            //Broker initialization moved to AuthenticateUser

                            this.WindowAction(this, new WindowActionEventArgs(true));
                        }
                        else
                        {
                            throw new Exception("ERR: Authentication cannot be completed.");
                        }
                    }
                    catch (Exception ex)
                    {
                        Logger.Error("ERROR - LogoutWindowViewModel - client.AuthenticateUser(): " + ex.Message);
                        // Shutting down...
                        Logger.Info("Shutting down...");
                        Application.Current.Shutdown();
                    }
                });

            // If they've cancelled login, then either go back to the division list, or shutdown the application
            this.OnCancelLogin = new DelegateCommand<object>(o =>
                {
                    Application.Current.Shutdown();
                });
        }
        #endregion

        #region Delegates

        /// <summary>
        /// The division action event handler.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        public delegate void DivisionActionEventHandler(object sender, DivisionActionEventArgs e);

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
        /// The division action.
        /// </summary>
        public event DivisionActionEventHandler DivisionAction;

        /// <summary>
        /// The window action.
        /// </summary>
        public event WindowActionEventHandler WindowAction;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets WindowTitle.
        /// </summary>
        public string WindowTitle
        {
            get
            {
                return "Importer Logout";
            }
        }

        /// <summary>
        /// Gets or sets OnCancelLogin.
        /// </summary>
        public DelegateCommand<object> OnCancelLogin { get; set; }

        /// <summary>
        /// Gets or sets OnLogin.
        /// </summary>
        public DelegateCommand<object> OnLogin { get; set; }

        #endregion
    }
}
