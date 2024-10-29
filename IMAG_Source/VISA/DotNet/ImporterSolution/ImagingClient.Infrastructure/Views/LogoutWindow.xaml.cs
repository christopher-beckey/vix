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
namespace ImagingClient.Infrastructure.Views
{
    using System;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Windows;

    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.User.Model;
    using ImagingClient.Infrastructure.ViewModels;

    using log4net;

    /// <summary>
    /// Interaction logic for LogoutWindow.xaml
    /// </summary>
    public partial class LogoutWindow
    {
        #region Constants and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog logger = LogManager.GetLogger(typeof(LogoutWindow));

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="LogoutWindow"/> class.
        /// </summary>
        public LogoutWindow()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="LogoutWindow"/> class.
        /// </summary>
        /// <param name="viewModel">
        /// The view model.
        /// </param>
        public LogoutWindow(LogoutWindowViewModel viewModel)
        {
            this.InitializeComponent();
            this.ShowInTaskbar = false;
            this.LoginSuccessful = false;
            this.SecurityKeys = new ObservableCollection<string>();
            this.DataContext = viewModel;
            this.ViewModel.WindowAction += this.HandleWindowAction;
            this.ViewModel.UIDispatcher = this.Dispatcher;

            try
            {
                this.Title = this.ViewModel.WindowTitle;
            }
            catch
            {
                // Application is shutting down. Ignore
                logger.Info("Shutting down...");
            }
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets a value indicating whether LoginSuccessful.
        /// </summary>
        public bool LoginSuccessful { get; set; }

        /// <summary>
        /// Gets or sets SecurityKeys.
        /// </summary>
        public ObservableCollection<string> SecurityKeys { get; set; }

        /// <summary>
        /// Gets the view model.
        /// </summary>
        public LogoutWindowViewModel ViewModel 
        { 
            get
            {
                return (LogoutWindowViewModel)this.DataContext;
            }
        }

        #endregion

        #region Methods

        /// <summary>
        /// The on closing.
        /// </summary>
        /// <param name="e">
        /// The e.
        /// </param>
        protected override void OnClosing(CancelEventArgs e)
        {
            base.OnClosing(e);

            if (!this.LoginSuccessful)
            {
                Application.Current.Shutdown();
            }
        }

        /// <summary>
        /// The handle window action.
        /// </summary>
        /// <param name="sender">
        /// The sender.
        /// </param>
        /// <param name="e">
        /// The e.
        /// </param>
        private void HandleWindowAction(object sender, WindowActionEventArgs e)
        {
            if (e.IsOk)
            {
                this.LoginSuccessful = true;

                if (UserContext.UserCredentials != null)
                {
                    try
                    {
                        Application.Current.MainWindow.Title = "Importer - " + UserContext.UserCredentials.SiteName
                                                               + " (" + UserContext.UserCredentials.SiteNumber + ")";
                    }
                    catch (Exception)
                    {
                        logger.Info("Unable to set Main Window title. Maybe the Application is shutting down...");
                    }
                }

                this.DialogResult = true;
            }
            else
            {
                this.Close();
            }
        }

        #endregion
    }
}