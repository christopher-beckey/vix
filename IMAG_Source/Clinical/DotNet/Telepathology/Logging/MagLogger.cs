// -----------------------------------------------------------------------
// <copyright file="MagLogger.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: April 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Paul Pentapaty, Duc Nguyen
//  Description: Logging for the applications
//        ;; +--------------------------------------------------------------------+
//        ;; Property of the US Government.
//        ;; No permission to copy or redistribute this software is given.
//        ;; Use of unreleased versions of this software requires the user
//        ;;  to execute a written test agreement with the VistA Imaging
//        ;;  Development Office of the Department of Veterans Affairs,
//        ;;  telephone (301) 734-0100.
//        ;;
//        ;; The Food and Drug Administration classifies this software as
//        ;; a Class II medical device.  As such, it may not be changed
//        ;; in any way.  Modifications to this software may result in an
//        ;; adulterated medical device under 21CFR820, the use of which
//        ;; is considered to be a violation of US Federal Statutes.
//        ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.Logging
{
    using System;
    using System.IO;
    using log4net;
    using log4net.Config;

    /// <summary>
    /// Keep the logs for the applications
    /// </summary>
    public class MagLogger
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="MagLogger"/> class
        /// </summary>
        /// <param name="typeToBeLogged">log type</param>
        public MagLogger(Type typeToBeLogged)
        {
            this.Logger = LogManager.GetLogger(typeToBeLogged);
        }

        /// <summary>
        /// Gets or sets the logger interface
        /// </summary>
        private ILog Logger { get; set; }

        /// <summary>
        /// Initializes new log
        /// </summary>
        /// <param name="configFile">logger configuration file information</param>
        public static void Initialize(FileInfo configFile)
        {
            XmlConfigurator.Configure(configFile);
        }

        /// <summary>
        /// Logs information
        /// </summary>
        /// <param name="message">info message</param>
        public void Info(string message)
        {
            this.Logger.Info(message);
        }

        /// <summary>
        /// Logs debugging information
        /// </summary>
        /// <param name="message">debug message</param>
        public void Debug(string message)
        {
            this.Logger.Debug(message);
        }

        /// <summary>
        /// Logs errors
        /// </summary>
        /// <param name="message">error message</param>
        public void Error(string message)
        {
            this.Logger.Error(message);
        }

        public void Error(string message, Exception ex)
        {
            this.Logger.Error(message, ex);
        }

        /// <summary>
        /// Logs warnings
        /// </summary>
        /// <param name="message">warning message</param>
        public void Warn(string message)
        {
            this.Logger.Warn(message);
        }
    }
}
