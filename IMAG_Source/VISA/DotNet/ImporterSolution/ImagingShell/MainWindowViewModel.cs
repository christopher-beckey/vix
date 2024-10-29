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

using System.Collections.Generic;
using DicomImporter.Common.User;
using DicomImporter.Common.Views;

namespace ImagingShell
{
    using System;
    using System.ComponentModel;
    using System.Configuration;
   using System.Text.RegularExpressions;
   using System.Timers;
    using System.Windows.Input;
    using System.Windows.Threading;
    using ImagingClient.Infrastructure;
    using ImagingClient.Infrastructure.Commands;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.User.Model;
   using ImagingClient.Infrastructure.Utilities;
   using ImagingClient.Infrastructure.ViewModels;
    using log4net;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Events;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// The main window view model.
    /// </summary>
    public class MainWindowViewModel : ImagingViewModel
    {
        #region Constant and Fields

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(MainWindow));

        /// <summary>
        /// The default number of seconds that the application 
        /// can go without user interaction before it logs out.
        /// </summary>
        private static int DefaultSecondsIdleLogout = 300;

        /// <summary>
        /// The interval, in seconds, in which the application will check 
        /// to see if the idle time has been reached.
        /// </summary>
        private const int TimerInterval = 2;

        /// <summary>
        /// The time that has passed since a user interaction.
        /// </summary>
        private int timeIdle;

        /// <summary>
        /// The timer used to check whether the max user idle time has been reached.
        /// </summary>
        private Timer idleChecker;


        //P346 - Pramod Kumar Chikkappaiah - VHAISHCHIKKP - BEGIN-Handle ShowAdminMenu property
        /// <summary>
        /// To show Importer Admin Menu
        /// </summary>
        private bool _ShowAdminMenu { get; set; }
        //P346 - Pramod Kumar Chikkappaiah - VHAISHCHIKKP - END

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="MainWindowViewModel"/> class.
        /// </summary>
        public MainWindowViewModel()
        {
            this.OnLogOut = new DelegateCommand<object>(
                o =>
                    {
                        var e = new CancelEventArgs();
                        if (CompositeCommands.LogoutCommand.CanExecute(e))
                        {
                            CompositeCommands.LogoutCommand.Execute(e);
                        }

                        if (!e.Cancel)
                        {
                            LoginManager.IsAttemptingLogout = true;

                            // Try to navigate back to the home view. The active view will have a chance to cancel navigation
                            // and logout...
                            var manager = ServiceLocator.Current.GetInstance<IRegionManager>();
                            manager.RequestNavigate(RegionNames.MainRegion, "ImagingClientHomeView");
                            var test = manager.Regions["MainRegion"].ActiveViews;

                            // If the user didn't cancel logout, clear the credentials and show the login window
                            if (!LoginManager.IsLogoutCancelled)
                            {
                             //Commented code by Gary Pham
                             //Logger.Info("The user " + UserContext.UserCredentials.Fullname + " has logged out.");
                             /*
                             Gary Pham (oitlonphamg)
                             P332
                             Validate string for nonprintable characters based on Fortify software recommendation.
                             */
                             String strTemp = "The user " + UserContext.UserCredentials.Fullname + " has logged out.";

                             //Logger.Info("Before regexvalidlog:  " + strTemp);
                             //if (Regex.IsMatch(strTemp, "^[A-Za-z0-9 _.,!\"'/$;@:%]+$"))
                             if (StringUtilities.IsRegexValidLog(strTemp))
                                //Logger.Info("After regexvalidlog:  " + strTemp);
                             Logger.Info(strTemp);
									
                                UserContext.IsLoginSuccessful = false;
                                this.idleChecker.Stop();

                                //TLB - Show logout window
                                //this.OnShowLoginWindow();
                                this.OnShowLogoutWindow();
                            }

                            // Clean up for next time...
                            LoginManager.IsAttemptingLogout = false;
                            LoginManager.IsLogoutCancelled = false;

                            // If login is successful, navigate to Importer home
                            if (UserContext.IsLoginSuccessful)
                            {
                                this.ConfigureAndStartTimer();
                                manager.RequestNavigate(RegionNames.MainRegion, "ImporterHomeView");
                                UpdateMenus();
                            }
                        }
                    });

            this.eventAggregator.GetEvent<IsWorkInProgressEvent>().Subscribe(UpdateTimer);
            this.eventAggregator.GetEvent<UserActionEvent>().Subscribe(ResetTimeIdle);
            this.eventAggregator.GetEvent<UserLoginEvent>().Subscribe(LogUserLogin);

            // handlers added to help determine application idle time.
            System.Windows.Application.Current.MainWindow.KeyDown += new KeyEventHandler(onKeyAction);
            System.Windows.Application.Current.MainWindow.MouseMove += new MouseEventHandler(onMouseMove);
            System.Windows.Application.Current.MainWindow.MouseWheel += new MouseWheelEventHandler(onMouseWheel);
            System.Windows.Application.Current.MainWindow.MouseDown += new MouseButtonEventHandler(onMouseAction);

            // Initialize menu commands
            InitializeMenuCommands();
        }

        #endregion

        #region Delegates

        /// <summary>
        /// The show countdown message handler.
        /// </summary>
        public delegate void ShowCountdownMessageHandler();

        /// <summary>
        /// The show login window handler.
        /// </summary>
        public delegate void ShowLoginWindowHandler();

        /// <summary>
        /// The show logout window handler.
        /// </summary>
        public delegate void ShowLogoutWindowHandler();

        #endregion

        #region Public Events

        /// <summary>
        /// The show countdown window.
        /// </summary>
        public event ShowCountdownMessageHandler ShowCountdownMessage;

        /// <summary>
        /// The show login window.
        /// </summary>
        public event ShowLoginWindowHandler ShowLoginWindow;

        /// <summary>
        /// The show logout window.
        /// </summary>
        public event ShowLogoutWindowHandler ShowLogoutWindow;

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets OnExit.
        /// </summary>
        public DelegateCommand<object> OnExit { get; set; }

        /// <summary>
        /// Gets or sets OnLogOut.
        /// </summary>
        public DelegateCommand<object> OnLogOut { get; set; }

        /// <summary>
        /// Gets or sets NavigateToDicomHome.
        /// </summary>
        public DelegateCommand<object> NavigateToDicomHome { get; set; }

        /// <summary>
        /// Gets or sets the NavigateToStaging command.
        /// </summary>
        public DelegateCommand<object> NavigateToStaging { get; set; }

        /// <summary>
        /// Gets or sets the NavigateToImportList command.
        /// </summary>
        public DelegateCommand<object> NavigateToImportList { get; set; }

        /// <summary>
        /// Gets or sets the NavigateToDirectImport command.
        /// </summary>
        public DelegateCommand<object> NavigateToDirectImport { get; set; }

        /// <summary>
        /// Gets or sets the NavigateToReports command.
        /// </summary>
        public DelegateCommand<object> NavigateToReports { get; set; }

        /// <summary>
        /// Gets or sets the NavigateToAdminHome command.
        /// </summary>
        public DelegateCommand<object> NavigateToAdminHome { get; set; }

        /// <summary>
        /// Gets or sets the NavigateToAdminRevert command.
        /// </summary>
        public DelegateCommand<object> NavigateToAdminRevert { get; set; }

        /// <summary>
        /// Gets or sets the NavigateToAdminInProcessItems command.
        /// </summary>
        public DelegateCommand<object> NavigateToAdminInProcessItems { get; set; }

        /// <summary>
        /// Gets or sets the NavigateToAdminFailedItems command.
        /// </summary>
        public DelegateCommand<object> NavigateToAdminFailedItems { get; set; }

        /// <summary>
        /// Gets or sets the NavigateToAdminLog command.
        /// </summary>
        public DelegateCommand<object> NavigateToAdminLog { get; set; }

        /// <summary>
        /// Gets a value indicating whether HasAdministratorKey.
        /// </summary>
        public bool HasAdministratorKey
        {
            get
            {
                return UserContext.UserHasKey(ImporterSecurityKeys.Administrator);
            }
        }

        /// <summary>
        /// Gets or sets a value indicating whether to show the admin menus.
        /// </summary>

        //Commented by P346 - Pramod Kumar Chikkappaiah - VHAISHCHIKKP - To fix Importer Admin menu
        //public bool ShowAdminMenu { get; set; }

        //P346 - Pramod Kumar Chikkappaiah - VHAISHCHIKKP - BEGIN-Handle ShowAdminMenu property
        /// <summary>
        /// Gets or sets a value indicating whether ShowAdminMenu 
        /// </summary>
        public bool ShowAdminMenu
        {
            get { return _ShowAdminMenu; }
            set
            {
                _ShowAdminMenu = value;
                this.RaisePropertyChanged("ShowAdminMenu");
            }
        }

        //P346 - Pramod Kumar Chikkappaiah - VHAISHCHIKKP - END


        /// <summary>
        /// Gets a value indicating whether HasAdvancedStagingKey.
        /// </summary>
        public bool HasAdvancedStagingKey
        {
            get
            {
                return UserContext.UserHasKey(ImporterSecurityKeys.AdvancedStaging);
            }
        }

        /// <summary>
        /// Gets a value indicating whether HasContractedStudiesKey.
        /// </summary>
        public bool HasContractedStudiesKey
        {
            get
            {
                return UserContext.UserHasKey(ImporterSecurityKeys.ContractedStudies);
            }
        }

        /// <summary>
        /// Gets a value indicating whether HasReportsKey.
        /// </summary>
        public bool HasReportsKey
        {
            get
            {
                return UserContext.UserHasKey(ImporterSecurityKeys.Reports);
            }
        }

        /// <summary>
        /// Gets a value indicating whether HasStagingKey.
        /// </summary>
        public bool HasStagingKey
        {
            get
            {
                return UserContext.UserHasKey(ImporterSecurityKeys.Staging);
            }
        }

        /// <summary>
        /// Gets a value indicating whether this user has any importer key.
        /// </summary>
        protected bool HasAnyImporterKey
        {
            get
            {
                bool hasAnyImporterKey = this.HasAdministratorKey ||
                    this.HasAdvancedStagingKey ||
                    this.HasContractedStudiesKey ||
                    this.HasReportsKey ||
                    this.HasStagingKey;

                return hasAnyImporterKey;
            }
        }


        #endregion

        #region Public Methods

        /// <summary>
        /// Configures and starts the timer.
        /// </summary>
        public void ConfigureAndStartTimer()
        {
            this.ConfigureTimer();
            this.ResetTimeIdle();
            this.idleChecker.Start();
        }

        /// <summary>
        /// The on show countdown message.
        /// </summary>
        public void OnShowCountdownMessage()
        {
            if (this.ShowCountdownMessage != null)
            {
                this.ShowCountdownMessage();
            }
        }

        /// <summary>
        /// The on show login window.
        /// </summary>
        public void OnShowLoginWindow()
        {
            if (this.ShowLoginWindow != null)
            {
                this.ShowLoginWindow();
            }
        }

        /// <summary>
        /// The on show login window.
        /// </summary>
        public void OnShowLogoutWindow()
        {
            if (this.ShowLogoutWindow != null)
            {
                this.ShowLogoutWindow();
            }
        }

        /// <summary>
        /// Initializes the menu commands.
        /// </summary>
        public void InitializeMenuCommands()
        {
            this.NavigateToDicomHome = new DelegateCommand<object>(
                o => this.NavigateMainRegionTo(ImporterViewNames.ImporterHomeView),
                o => this.HasAnyImporterKey);

            this.NavigateToStaging = new DelegateCommand<object>(
                o => this.NavigateMainRegionTo(ImporterViewNames.SelectMediaCategoryView + "?IsForMediaStaging=true"),
                o => this.HasStagingKey || this.HasAdvancedStagingKey || this.HasContractedStudiesKey || this.HasAdministratorKey);

            this.NavigateToImportList = new DelegateCommand<object>(
                o => this.NavigateMainRegionTo(ImporterViewNames.WorkListView + "?IsFirstWorkListLoading=true"),
                o => this.HasContractedStudiesKey || this.HasAdministratorKey);
            
            this.NavigateToDirectImport = new DelegateCommand<object>(
                o => this.NavigateMainRegionTo(ImporterViewNames.SelectMediaCategoryView + "?IsForMediaStaging=false"),
                o => this.HasContractedStudiesKey || this.HasAdministratorKey);
            
            this.NavigateToReports = new DelegateCommand<object>(
                o => this.NavigateMainRegionTo(ImporterViewNames.ReportsHomeView),
                o => this.HasReportsKey || this.HasAdministratorKey);
            
            this.NavigateToAdminHome = new DelegateCommand<object>(
                o => this.NavigateMainRegionTo(ImporterViewNames.AdministrationHomeView),
                o => this.HasAdministratorKey);
            
            this.NavigateToAdminRevert = new DelegateCommand<object>(
                o => this.NavigateMainRegionTo(ImporterViewNames.AdminRevertWorkItemView),
                o => this.HasAdministratorKey);
            
            this.NavigateToAdminInProcessItems = new DelegateCommand<object>(
                o => this.NavigateMainRegionTo(ImporterViewNames.AdminInProcessImportsView),
                o => this.HasAdministratorKey);
            
            this.NavigateToAdminFailedItems = new DelegateCommand<object>(
                o => this.NavigateMainRegionTo(ImporterViewNames.AdminFailedImportView),
                o => this.HasAdministratorKey);
            
            this.NavigateToAdminLog = new DelegateCommand<object>(
                o => this.NavigateMainRegionTo(ImporterViewNames.LogView),
                o => this.HasAdministratorKey);
        }

        /// <summary>
        /// Updates the menus.
        /// </summary>
        public void UpdateMenus()
        {
            NavigateToDicomHome.RaiseCanExecuteChanged();
            NavigateToStaging.RaiseCanExecuteChanged();
            NavigateToImportList.RaiseCanExecuteChanged();
            NavigateToDirectImport.RaiseCanExecuteChanged();
            NavigateToReports.RaiseCanExecuteChanged();

            if (HasAdministratorKey)
            {
                ShowAdminMenu = true;
                NavigateToAdminHome.RaiseCanExecuteChanged();
                NavigateToAdminRevert.RaiseCanExecuteChanged();
                NavigateToAdminInProcessItems.RaiseCanExecuteChanged();
                NavigateToAdminFailedItems.RaiseCanExecuteChanged();
                NavigateToAdminLog.RaiseCanExecuteChanged();
            }
            else
            {
                ShowAdminMenu = false;
            }
        }

        #endregion

        #region Private Events

        /// <summary>
        /// Event handler for when a key on the keyboard is pressed within the application. 
        /// This method is used to reset the idle counter.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="args">The <see cref="KeyboardEventArgs" /> instance containing the event data.</param>
        private void onKeyAction(object sender, KeyboardEventArgs args)
        {
            this.ResetTimeIdle();
        }

        /// <summary>
        /// Event handler for when a button on the mouse is pressed within the application. 
        /// This method is used to reset the idle counter.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="arg">The <see cref="MouseButtonEventArgs" /> instance containing the event data.</param>
        private void onMouseAction(object sender, MouseButtonEventArgs arg)
        {
            this.ResetTimeIdle();
        }

        /// <summary>
        /// Event handler for when the mouse is moved within the application. 
        /// This method is used to reset the idle counter.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="args">The <see cref="MouseEventArgs" /> instance containing the event data.</param>
        private void onMouseMove(object sender, MouseEventArgs args)
        {
            this.ResetTimeIdle();
        }

        /// <summary>
        /// Event handler for when the wheel on the mouse is used within the application. 
        /// This method is used to reset the idle counter.
        /// </summary>
        /// <param name="sender">The sender.</param>
        /// <param name="args">The <see cref="MouseWheelEventArgs" /> instance containing the event data.</param>
        private void onMouseWheel(object sender, MouseWheelEventArgs args)
        {
            this.ResetTimeIdle();
        }

        /// <summary>
        /// Event Handler for when the time inteval has elapsed. This method is 
        /// used to check the the idle time of the application.
        /// </summary>
        /// <param name="source">The source.</param>
        /// <param name="args">The <see cref="ElapsedEventArgs" /> instance containing the event data.</param>
        private void onTimeElapsed(object source, ElapsedEventArgs args)
        {
            if (UserContext.IsLoginSuccessful)
            {
                this.CheckIdleTime();
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Checks whether the user has been inactive for a set period
        /// of time and displays the login window if it has been reached.
        /// </summary>
        private void CheckIdleTime()
        {
            if (UserContext.IsLoginSuccessful)
            {
                this.timeIdle += TimerInterval;

                this.LogUserTimeIdle();

                int num = UserContext.SecondsIdleLogout;

                // Displays idle timeout logout countdown message
                if (UserContext.SecondsIdleLogout - this.timeIdle <= 10)
                {
                    this.idleChecker.Stop();

                    this.UIDispatcher.Invoke(DispatcherPriority.Normal, (Action)(() => this.OnShowCountdownMessage()));

                    // TimeoutOccurred will be updated by the countdown message
                    if (UserContext.TimeoutOccurred) 
                    {
                        this.IdleTimeoutLogout();
                    }
                    else
                    {
                        this.ResetTimeIdle();
                        this.idleChecker.Start();
                    }
                } 
            }
        }

        /// <summary>
        /// Configures the timer.
        /// </summary>
        private void ConfigureTimer()
        {
            int seconds = 0;

            // An UserIdleLogout value in the config file overides any database or default value
            if (int.TryParse(ConfigurationManager.AppSettings.Get("UserIdleLogout"), out seconds))
            {
                UserContext.SecondsIdleLogout = seconds;
                Logger.Info("The time for user idle logout has been set to the configuration file value of " + 
                            UserContext.SecondsIdleLogout + " seconds.");
            }
            else if (UserContext.SecondsIdleLogout != 0)
            {
                Logger.Info("The time for user idle logout has been set to the database value of " +
                            UserContext.SecondsIdleLogout + " seconds.");
            }
            else
            {
                UserContext.SecondsIdleLogout = DefaultSecondsIdleLogout;
                Logger.Warn("Unable to retrieve the time for user idle logout from the database or configuration file. " +
                            "The default value of " + UserContext.SecondsIdleLogout + " seconds will be used.");
            }

            // prevents the application from using a user specified idle time that is lower that the timer interval
            if (UserContext.SecondsIdleLogout < TimerInterval)
            {
                Logger.Warn("The user idle timeout value is currently " + UserContext.SecondsIdleLogout + 
                            " seconds. It can at minimum only be " + TimerInterval  +  
                            " seconds. The Importer will use " + TimerInterval + 
                            " seconds as the minimum.");

                UserContext.SecondsIdleLogout = TimerInterval;   
            }

            timeIdle = 0;

            // Sets up Idle Timer
            this.idleChecker = new Timer(TimerInterval * 1000);
            this.idleChecker.Elapsed += new ElapsedEventHandler(onTimeElapsed);
            this.idleChecker.Enabled = true;
            this.idleChecker.AutoReset = true;
        }

        /// <summary>
        /// Performs a logout after an idle timeout
        /// </summary>
        private void IdleTimeoutLogout()
        {
            this.idleChecker.Stop();

            UserContext.TimeoutOccurred = true;

            string loggedOutUserDUZ = UserContext.UserCredentials.Duz;
            //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.(p289-OITCOPondiS)
            //string a=  System.Text.RegularExpressions.Regex.Replace(UserContext.UserCredentials.Fullname, "[^A-Za-z0-9 $]", "");
            Logger.Debug("The user " + " has been logged out. The maximum idle time  has been reached.");
            if (UserContext.SecondsIdleLogout > 0 )
                Logger.Debug("The user has been logged out. The maximum idle time of " + UserContext.SecondsIdleLogout.ToString() + " seconds has been reached.");
             //Logger.Info("The user " + UserContext.UserCredentials.Fullname + " has been logged out. The maximum idle time of " +  UserContext.SecondsIdleLogout.ToString() + " seconds has been reached.");
             //END



            // Notifies listeners that the user has logged out.
            IEventAggregator eventAggregator = ServiceLocator.Current.GetInstance<IEventAggregator>();
            eventAggregator.GetEvent<LogoutEvent>().Publish(UserContext.UserCredentials.Duz);

            //TLB - Per 2FA updates, show logout window (which allows for re-login) 
            //as opposed to the custom login window
            //this.UIDispatcher.Invoke(DispatcherPriority.Normal, (Action)(() => this.OnShowLoginWindow()));
            this.UIDispatcher.Invoke(DispatcherPriority.Normal, (Action)(() => this.OnShowLogoutWindow()));

            this.ConfigureAndStartTimer();
        }

        /// <summary>
        /// Logs the user login.
        /// </summary>
        /// <param name="userFullName">Full name of the user.</param>
        private void LogUserLogin(string userFullName)
        {
            //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.(p289-OITCOPondiS)
            Logger.Info("The user has logged in.");
            //Logger.Info("The user " + UserContext.UserCredentials.Fullname + " has logged in.");
            //END
        }

        /// <summary>
        /// Logs the user time idle every 5 minutes.
        /// </summary>
        private void LogUserTimeIdle()
        {
            if ((this.timeIdle % 300) == 0 && this.timeIdle != 0)
            {
                string minutesIdle = (this.timeIdle / 60).ToString() + " minute";

                if (this.timeIdle / 300 > 1)
                {
                    minutesIdle+= "s";
                }
                //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.(p289-OITCOPondiS)
                Logger.Debug("The user has been idle every 5 minutes");
                //Logger.Debug("The user " + UserContext.UserCredentials.Fullname + " has been idle for " + minutesIdle);
                //END
            }
        }

        /// <summary>
        /// Resets the time idle.
        /// </summary>
        private void ResetTimeIdle()
        {
            this.timeIdle = 0;
        }

        /// <summary>
        /// Resets the time idle.
        /// </summary>
        private void ResetTimeIdle(string windowName)
        {
            this.ResetTimeIdle();
        }

        /// <summary>
        /// Will start or stop the idle checking timer based on whether work is currently in progress or not.
        /// Is used in conjunction with subscribing to IsWorkInProgressEvents.
        /// </summary>
        private void UpdateTimer(bool isWorkInProgress)
        {
            if (isWorkInProgress)
            {
                Logger.Debug("The idle timer has paused due to work in progress.");
                this.idleChecker.Stop();
            }
            else
            {
                Logger.Debug("The idle timer has started. Work in progress has completed.");
                this.ResetTimeIdle();
                this.idleChecker.Start();
            }
        }

        private DelegateCommand<object> CreateMenuCommand(String viewName, List<String> requiredKeys)
        {
            return new DelegateCommand<object>(o => this.NavigateMainRegionTo(ImporterViewNames.ImporterHomeView));
        }

        #endregion

    }

}