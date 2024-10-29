/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 08/30/2012
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Lenard Williams, Duc Nguyen
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

namespace DicomImporter.ViewModels
{
    using System;
    using System.IO;
    using DicomImporter.Common.Views;
    using DicomImporter.Common.ViewModels;
    using log4net;
    using log4net.Appender;
    using Microsoft.Practices.Prism.Commands;
    using ImagingClient.Infrastructure.DialogService;

    /// <summary>
    /// The Log View Model used to retrieve the contents of the log file.
    /// </summary>
    public class LogViewModel : ImporterViewModel
    {

        #region Constants and Fields

        /// <summary>
        /// The no entries in the log file message.
        /// </summary>
        private const string NoLogFileEntriesMessage = "There are currently no entries in the log file.";

        /// <summary>
        /// The last time the log was refreshed message.
        /// </summary>
        private const string LastRefreshedMessage = "Last Refreshed on ";

        /// <summary>
        /// The importer client log message.
        /// </summary>
        private const string ImporterLogMessage = "Importer Client Log";
        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog logger = LogManager.GetLogger(typeof(LogViewModel));

        #endregion

        #region Constructors
      
        /// <summary>
        /// Initializes a new instance of the <see cref="LogViewModel"/> class.
        /// </summary>
        /// <param name="logPath">The log path.</param>
        public LogViewModel()
        {
            this.Log = String.Empty;
            this.logFilePath = String.Empty;
            this.LogLastRefreshed = ImporterLogMessage;

            this.RefreshLogCommand = new DelegateCommand<object>(o => this.RefreshLog(), o => this.HasAdministratorKey);

            this.NavigateToAdministrationHomeView = new DelegateCommand<object>(o => this.NavigateMainRegionTo(ImporterViewNames.AdministrationHomeView), 
                                                                                o => this.HasAdministratorKey);

            // Retrieves log4j log information
            FileAppender rootAppender = (FileAppender)((log4net.Repository.Hierarchy.Hierarchy)LogManager.GetRepository()).Root.Appenders[0];

            // Populates the log file path variable only if a location exists in the config file.
            if (!String.IsNullOrWhiteSpace(rootAppender.File))
            {
                logFilePath = rootAppender.File;
            }

            // initially populates the display with log entries.
            RefreshLog();
        }

        #endregion

        #region Public Properties 
        
        /// <summary>
        /// Gets or sets the log.
        /// </summary>
        /// <value>
        /// The log.
        /// </value>
        public string Log { get; set; }

        /// <summary>
        /// Gets or sets the time that the log was last refreshed in view.
        /// </summary>
        /// <value>
        /// The log status.
        /// </value>
        public string LogLastRefreshed { get; set; }

        /// <summary>
        /// Gets or sets the refresh list.
        /// </summary>
        /// <value>
        /// The refresh list.
        /// </value>
        public DelegateCommand<object> RefreshLogCommand { get; set; }

        /// <summary>
        /// Gets or sets NavigateToAdministrationHomeView.
        /// </summary>
        public DelegateCommand<object> NavigateToAdministrationHomeView { get; set; }

        #endregion

        #region Private Methods

        /// <summary>
        /// Refreshes the log.
        /// </summary>
        private void RefreshLog()
        {
            if (File.Exists(this.logFilePath))
            {
                try
                {
                    // Opens up a connection to the log file on the file system
                    using (StreamReader reader = new StreamReader(new FileStream(this.logFilePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)))
                    {
                        // reads in the entire contents of the log file
                        this.Log = String.Empty;
                        this.Log = reader.ReadToEnd();
                        reader.Close();
                    
                        if (this.Log.Length == 0)
                        {
                            this.Log = NoLogFileEntriesMessage;
                        }
                        
                        // updates the last refreshed status displayed to the user.
                        this.LogLastRefreshed = LastRefreshedMessage + DateTime.Now.ToString("M/d/yyyy")  + " at " +
                                                DateTime.Now.ToString("h:mm:ss tt");
                    }
                }
                catch (Exception e)
                {
                    this.LogLastRefreshed = ImporterLogMessage;

                    logger.Error(e);
                    this.DialogService.ShowExceptionWindow(UIDispatcher, e);
                }
            }
            else
            {
                this.LogLastRefreshed = ImporterLogMessage;

                logger.Error("Unable to display log entries. The log file: " + this.logFilePath + " does not exist.");
                this.DialogService.ShowAlertBox(this.UIDispatcher,
                                "Unable to display log entries. The log file does not exist.",
                                "File Does Not Exist",
                                MessageTypes.Error);
            }
        }

        #endregion

        #region Private Properties

        private string logFilePath;

        #endregion
    }
}
