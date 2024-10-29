// -----------------------------------------------------------------------
// <copyright file="MemoryTarget.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 03/26/2012
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
//         ;; is considered to   be a violation of US Federal Statutes.
//         ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.Log
{
    using System;
    using System.Collections.ObjectModel;
    using NLog;
    using NLog.Targets;
    using System.Text;

    /// <summary>
    /// Target used by <see cref="NLog"/> to handle logging of all 
    /// log messages. The MemoryTarget uses an in memory observable 
    /// collection to keep track of warnings, exceptions, and other 
    /// informative messages.
    /// </summary>
    [Target("InMemory")]
    public sealed class MemoryTarget : Target
    {
        #region Constructors
       
        /// <summary>
        /// Initializes a new instance of the <see cref="MemoryTarget"/> class.
        /// </summary>
        public MemoryTarget()
        { 
            this.Log = new ObservableCollection<string>();
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets or sets the log.
        /// </summary>
        /// <value>
        /// The log.
        /// </value>
        public ObservableCollection<string> Log { get; set; }

        #endregion

        #region Public Methods
        
        /// <summary>
        /// Clears out all entries in the log (ObservableCollection). 
        /// </summary>
        public void Clear()
        {
            this.Log.Clear();
        }

        #endregion

        #region Protected Methods

        /// <summary>
        /// Closes the target and releases any unmanaged resources.
        /// </summary>
        protected override void CloseTarget()
        {
            this.Clear();
            base.CloseTarget();
        }

        /// <summary>
        /// Writes logging events to the log target.
        /// classes.
        /// </summary>
        /// <param name="logEvent">Logging event to be written out.</param>
        protected override void Write(LogEventInfo logEvent)
        {
            // prepending log event identifier information to the log message
            StringBuilder logMessageBuilder = new StringBuilder();
            logMessageBuilder.Append(logEvent.TimeStamp.ToString("MMM dd yyyy HH:mm:ss "));
            logMessageBuilder.Append(logEvent.Level.Name.ToUpper());
            logMessageBuilder.Append(" (" + logEvent.LoggerName + ") - ");

            // adds the stack trace to the log message if the log event is an exception
            if (logEvent.Exception != null)
            {
                logMessageBuilder.Append(logEvent.Message);
                logMessageBuilder.Append(Environment.NewLine);
                logMessageBuilder.Append(logEvent.Exception.StackTrace);
            }
            else
            {
                logMessageBuilder.Append(logEvent.FormattedMessage); 
            }

           this.Log.Add(logMessageBuilder.ToString());
        }

        #endregion
    }
}
