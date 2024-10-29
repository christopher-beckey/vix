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
    public class LoginWindowViewModel : ImagingViewModel
    {
        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(LoginWindowViewModel));
        
        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="LoginWindowViewModel"/> class.
        /// </summary>
        /// <param name="userDataSource">The user data source.</param>
        /// <param name="dialogService">The dialog service.</param>
        public LoginWindowViewModel(IUserDataSource userDataSource, IDialogService dialogService)
        {
            this.UserDataSource = userDataSource;
            this.DialogService = dialogService;

            // Handle Prompt PIV attempt
            this.OnPromptPiv = new DelegateCommand<object>(
                o =>
                {
                    bool firstTimeLogIn = !UserContext.TimeoutOccurred;

                    IntPtr x = Bapi32_65.MySsoToken();
                    if (x != null)
                    {
                        string myToken = Marshal.PtrToStringAuto(x);
                        this.UserDataSource.AuthenticatePivUser(myToken);

                        if (UserContext.IsLoginSuccessful)
                        {
                            if (this.IsUserAuthorizedForStationNumber())
                            {
                                ApplicationTimeoutParameters parameters = userDataSource.GetApplicationTimeout();

                                if (parameters != null)
                                {
                                    UserContext.SecondsIdleLogout = parameters.TimeoutInSeconds;
                                }
                                else
                                {
                                    UserContext.SecondsIdleLogout = 0;
                                }

                                this.WindowAction(this, new WindowActionEventArgs(true));
                            }
                            else
                            {
                                // We passed the first round of login, but they don't actually have access
                                // to the division selected in the config file. Set login to unsuccessful, and
                                // update the error message.
                                UserContext.IsLoginSuccessful = false;
                                this.LoginErrorMessage = "You do not have access to the configured station number (" + UserContext.StationNumber + ")";
                            }
                        }
                        else
                        {
                            // Display a login error message
                            this.LoginErrorMessage = UserContext.LoginErrorMessage;

                            //TODO: Display login choices
                        }
                    }
                    else
                    {
                        // Display a login error message
                        this.LoginErrorMessage = "An unexpected error occurred while attempting to login with PIV/PIN credentials.  Please try again.";

                        //TODO: Display login choices
                    }
                });

            // Handle Login attempt
            this.OnLogin = new DelegateCommand<object>(
                o =>
                {
                    //TLB - Old login process
                    //bool firstTimeLogIn = !UserContext.TimeoutOccurred;

                    //this.SplitAccessAndVerifyCodes();
                    //this.UserDataSource.AuthenticateUser(this.AccessCode, this.VerifyCode);

                    //if (UserContext.IsLoginSuccessful)
                    //{
                    //    if (this.IsUserAuthorizedForStationNumber())
                    //    {
                    //        ApplicationTimeoutParameters parameters = userDataSource.GetApplicationTimeout();

                    //        if (parameters != null)
                    //        {
                    //            UserContext.SecondsIdleLogout = parameters.TimeoutInSeconds;
                    //        }
                    //        else
                    //        {
                    //            UserContext.SecondsIdleLogout = 0;
                    //        }

                    //        this.WindowAction(this, new WindowActionEventArgs(true));
                    //    }
                    //    else
                    //    {
                    //        // We passed the first round of login, but they don't actually have access
                    //        // to the division selected in the config file. Set login to unsuccessful, and
                    //        // update the error message.
                    //        UserContext.IsLoginSuccessful = false;
                    //        this.LoginErrorMessage = "You do not have access to the configured station number (" + UserContext.StationNumber + ")";
                    //    }
                    //}
                    //else
                    //{
                    //    // Display a login error message
                    //    this.LoginErrorMessage = UserContext.LoginErrorMessage;

                    //    // Clear the invalid login credentials
                    //    this.AccessCode = string.Empty;
                    //    this.VerifyCode = string.Empty;
                    //    this.RaisePropertyChanged("AccessCode");
                    //    this.RaisePropertyChanged("VerifyCode");
                    //}
                    //TLB - End old login process

                    //TLB - New login process
                    BrokerClient client = new BrokerClient();

                    try
                    {
                        //loginWindow.Owner = this;
                        //loginWindow.ShowDialog();
                        if (client.AuthenticateUser())
                        {
                            //Broker initialization moved to AuthenticateUser
                        }
                        else
                        {
                            throw new Exception("ERR: Authentication cannot be completed.");
                        }
                    }
                    catch (Exception ex)
                    {
                        Logger.Error("ERROR - LoginWindowViewModel - client.AuthenticateUser(): " + ex.Message);
                        // Shutting down...
                        Logger.Info("Shutting down...");
                        Application.Current.Shutdown();
                    }
                });

            // If they've cancelled login, then either go back to the division list, or shutdown the application
            this.OnCancelLogin = new DelegateCommand<object>(o =>
                {
                    if (this.ConfiguredDivisions != null && this.ConfiguredDivisions.Count > 1)
                    {
                        this.SelectStationNumber();
                    }
                    else
                    {
                        Application.Current.Shutdown();
                    }
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
                return "VistA Sign-on: " + SiteServiceHelper.GetSite(UserContext.StationNumber).SiteName + " (" + UserContext.StationNumber + ")";
            }
        }

        /// <summary>
        /// Gets or sets AccessCode.
        /// </summary>
        public string AccessCode { get; set; }

        /// <summary>
        /// Gets or sets AlertText.
        /// </summary>
        public string AlertText { get; set; }

        /// <summary>
        /// Gets or sets LoginErrorMessage.
        /// </summary>
        public string LoginErrorMessage { get; set; }

        /// <summary>
        /// Gets or sets OnCancelLogin.
        /// </summary>
        public DelegateCommand<object> OnCancelLogin { get; set; }

        /// <summary>
        /// Gets or sets OnLogin.
        /// </summary>
        public DelegateCommand<object> OnLogin { get; set; }

        /// <summary>
        /// Gets or sets OnPromptPiv.
        /// </summary>
        public DelegateCommand<object> OnPromptPiv { get; set; }

        /// <summary>
        /// Gets or sets UserDataSource.
        /// </summary>
        public IUserDataSource UserDataSource { get; set; }

        /// <summary>
        /// Gets or sets Configured Divisions.
        /// </summary>
        public ObservableCollection<Division> ConfiguredDivisions { get; set; }

        /// <summary>
        /// Gets or sets VerifyCode.
        /// </summary>
        public string VerifyCode { get; set; }

        #endregion

        #region Public Methods

        /// <summary>
        /// Allows the user to select a station number.
        /// </summary>
        public void SelectStationNumber()
        {
            string siteIdParam = ConfigurationManager.AppSettings.Get("SiteId") + string.Empty;

            string[] stationNumbers = siteIdParam.Split(',');

            // Resolve the sites from the site service, based on the configured values
            this.ConfiguredDivisions = new ObservableCollection<Division>();

            foreach (string stationNumber in stationNumbers)
            {
                Site site = SiteServiceHelper.GetSite(stationNumber.Trim());
                if (site != null)
                {
                    this.ConfiguredDivisions.Add(new Division { DivisionCode = site.SiteNumber, DivisionName = site.SiteName });
                }
            }

            if (this.ConfiguredDivisions.Count == 0)
            {
                string caption = "Invalid Configuration";
                string message = "There are no valid station numbers specified in the SiteId key in the ImagingShell.exe.config file. \n\n"
                                 + "Please update the SiteId key in the config file (located in the installation directory) with \n"
                                 + "one or more station numbers, separated by commas.\n\n"
                                 + "More detailed instructions can be found in the comments inside the ImagingShell.exe.config file.";
                DialogService.ShowAlertBox(this.UIDispatcher, message, caption, MessageTypes.Error);

                // Shut down. Config is invalid.
                Application.Current.Shutdown();
            }
            else if (this.ConfiguredDivisions.Count == 1)
            {
                UserContext.StationNumber = this.ConfiguredDivisions[0].DivisionCode;
            }
            else
            {
                // Select the division
                this.DivisionAction(this, new DivisionActionEventArgs(this.ConfiguredDivisions));
            }
        }

        /// <summary>
        /// Gets the welcome text.
        /// </summary>
        public void GetWelcomeText()
        {
            this.AlertText = this.UserDataSource.GetWelcomeMessage();
        }

        #endregion

        #region Methods

        /// <summary>
        /// Determines whether the user is authorized for the station number selected from the importer config file.
        /// </summary>
        /// <returns>
        ///   <c>true</c> if the user is authorized for the station number; otherwise, <c>false</c>.
        /// </returns>
        private bool IsUserAuthorizedForStationNumber()
        {
            if (UserContext.StationNumber.Equals(UserContext.UserCredentials.SiteNumber))
            {
                // The station number requested in config matches the station number that the VIX is running under. Just return true.
                return true;
            }
            else
            {
                // The station number the user requested via config does not match the station number configured on the VIX.
                // Verify that they have access to the specified station number by examining the division list for the user
                ObservableCollection<Division> divisions = this.UserDataSource.GetDivisionList(this.AccessCode);

                foreach (Division division in divisions)
                {
                    if (division.DivisionCode.Equals(UserContext.StationNumber))
                    {
                        // We found the requested division in the list of accessible divisions for the user. Update the UserCredentials 
                        // and get the site name for the site,looked up via the site service.
                        UserContext.UserCredentials.SiteNumber = UserContext.StationNumber;
                        UserContext.UserCredentials.SiteName = SiteServiceHelper.GetSite(UserContext.StationNumber).SiteName;
                        return true;
                    }
                }
            }

            // Since we got here, 
            return false;
        }

        /// <summary>
        /// Checks for single line credentials seperated by a ";". If 
        /// it exists then everything to the left of the semi colon is 
        /// stored as the access code and everything to the right is 
        /// stored as the verify code.
        /// </summary>
        private void SplitAccessAndVerifyCodes()
        {
            if (this.AccessCode == null)
            {
                this.AccessCode = string.Empty;
            }

            if (this.VerifyCode == null)
            {
                this.VerifyCode = string.Empty;
            }

            if (this.AccessCode.Contains(";"))
            {
                string[] credentials = this.AccessCode.Split(';');

                if (credentials.Length == 2)
                {
                    this.AccessCode = credentials[0];
                    this.VerifyCode = credentials[1];
                }
            }
        }

        #endregion
    }
}
