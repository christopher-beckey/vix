// <copyright file="LogViewModel.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 03/22/2012
//   Site Name:  Washington OI Field Office, Silver Spring, MD
//   Developer: vhaiswwillil
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

namespace VistA.Imaging.Viewer.ViewModels
{
    using System;
    using System.Collections;
    using System.Text;
    using System.Windows;
    using System.Windows.Input;
    using MessageBox;
    using Microsoft.Practices.Prism.Commands;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Unity;
    using NLog;
    using VistA.Imaging.Log;
    using VistA.Imaging.Prism;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class LogViewModel : ViewModel
    {
        private readonly Logger logger = LogManager.GetCurrentClassLogger();

        #region Constants

        private const string ENTIRE_LOG = "Entire Log";
        private const string SELECTED_ENTRIES = "Selected Log Entries Only";

        #endregion

        #region Constructors

        /// <summary>
        /// Initializes a new instance of the <see cref="LogViewModel"/> class.
        /// </summary>
        public LogViewModel()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="LogViewModel"/> class.
        /// </summary>
        /// <param name="regionManager">The region manager.</param>
        /// <param name="target">The target.</param>
        [InjectionConstructor]
        public LogViewModel(IRegionManager regionManager, MemoryTarget target)
            : base(regionManager)
        {
            this.Target = target;
            this.DelegateCommands();
        }

        #endregion

        #region Public Properties
        
        /// <summary>
        /// Gets the clear log command which is delegated 
        /// to clear the entire log.
        /// </summary>
        public ICommand ClearLogCommand { get; private set; }

        /// <summary>
        /// Gets the copy log command which is delegated 
        /// to copy the contents of the log.
        /// </summary>
        public ICommand CopyLogCommand { get; private set; }

        /// <summary>
        /// Gets or sets the target.
        /// </summary>
        public MemoryTarget Target { get; set; }

        /// <summary>
        /// Gets or sets the selected logs.
        /// </summary>
        public IList SelectedLogs { get; set; }

        #endregion

        #region Public Methods
        
        /// <summary>
        /// Removes all entries from the log after confirming
        /// with the user.
        /// </summary>
        public void ClearLog()
        {
            if (this.Target.Log.Count == 0)
            {
                Messages.InfoMessage("The log is already empty.");
            }
            else
            {
                Messages.ConfirmMessage(
                                        "Are you sure you want to delete all of the log entries?",
                                        (s, args) =>
                                        {
                                            if (args.DialogResult == true)
                                            {
                                                Target.Clear();
                                            }
                                        });
            }
        }

        /// <summary>
        /// Copies entries from the log. The user is prompted to 
        /// determine whether all or selected entries will be copied.
        /// </summary>
        public void CopyLog() 
        {
            string message = "Are you sure you want to copy the log entries to the clipboard?";

            string[] copyOptions = new string[] { ENTIRE_LOG, SELECTED_ENTRIES };

            // Prompts the user to determine whether all or selected entries will be copied
            CustomMessage confirmCopy = new CustomMessage(message, CustomMessage.MessageType.ComboInput, copyOptions);
            confirmCopy.Show();

            // handles an user response of Yes/OK
            confirmCopy.OKButton.Click += (obj, args) =>
            {
                // Check to see that an option was selected.
                if (confirmCopy.Input != null)
                {
                    CopyLogToClipboard(confirmCopy.Input);
                }
                else
                {
                    string errorMessage = "An option was not selected from the drop down box. Please select a copy option to proceed.";

                    Messages.ErrorMessage(errorMessage);
                    logger.Warn(errorMessage);
                    confirmCopy.Show();
                }
            };
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Copies the log to the clipboard.
        /// </summary>
        /// <param name="copyType">Type of copy performed on the log.
        /// Current types are ENTIRE_LOG or SELECTED_ENTRIES.
        /// </param>
        private void CopyLogToClipboard(string copyType)
        {
            var logEnumerator = this.Target.Log.GetEnumerator();
            StringBuilder logMessagesBuilder = new StringBuilder();

            switch(copyType)
            {
                case ENTIRE_LOG:

                    if (logEnumerator != null)
                    {
                        // combines all of the log entries into one string
                        while (logEnumerator.MoveNext())
                        {
                            logMessagesBuilder.Append(logEnumerator.Current);
                            logMessagesBuilder.Append(Environment.NewLine);
                        }
                    }

                    this.SetClipboardText(logMessagesBuilder.ToString());
                    
                    break;

                case SELECTED_ENTRIES:
                        
                    if (this.SelectedLogs != null)
                    {
                        var selectedLogEnumerator = this.SelectedLogs.GetEnumerator();

                        // combines all of the selected log entries into one string
                        while (selectedLogEnumerator.MoveNext())
                        {
                            logMessagesBuilder.Append(selectedLogEnumerator.Current);
                            logMessagesBuilder.Append(Environment.NewLine);
                        }

                        this.SetClipboardText(logMessagesBuilder.ToString());
                    }
                    else
                    {
                        Messages.InfoMessage("No entries were selected. At least one log entry must be selected in order to "
                                             + "use the selected log entries option.");
                    }

                    break;

                default:
                    string errorMessage = "The copy option " + copyType + " does not exist.";
                    Messages.ErrorMessage(errorMessage);
                    logger.Error(errorMessage); 
                    break;
            }
        }

        /// <summary>
        /// Delegates the commands to public methods.
        /// </summary>
        private void DelegateCommands()
        {
            this.ClearLogCommand = new DelegateCommand(() => this.ClearLog());
            this.CopyLogCommand = new DelegateCommand(() => this.CopyLog());
        }

        /// <summary>
        /// Sets the clipboard text.
        /// </summary>
        /// <param name="logMessages">The log entries text to be set to 
        /// the clipboard.</param>
        private void SetClipboardText(string logMessages)
        {
            try
            {
                Clipboard.SetText(logMessages);
            }
            catch (Exception ex)
            {
                Messages.InfoMessage("Unable to copy to clipboard. Silverlight was not granted access to your clipboard.");
                logger.Warn(ex.Message + ": Silverlight was not granted access to the clipboard.");
            }
        }

        #endregion
    }
}
