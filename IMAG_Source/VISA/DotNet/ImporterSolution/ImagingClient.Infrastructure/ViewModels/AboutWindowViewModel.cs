// -----------------------------------------------------------------------
// <copyright file="AboutWindowViewModel.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: July 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: DUc Nguyen
//  Description: 
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

namespace ImagingClient.Infrastructure.ViewModels
{
    using System;
    using System.Diagnostics;
    using System.IO;
    using System.Windows;
    using log4net;
    using ImagingClient.Infrastructure.Views;
    using System.Management;

    /// <summary>
    /// The about window view model.
    /// </summary>
    public class AboutWindowViewModel
    {
        #region Constants and Fields

        /// <summary>
        /// The logger
        /// </summary>
        private static readonly ILog logger = LogManager.GetLogger(typeof(AboutWindow));

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="AboutWindowViewModel" /> class.
        /// </summary>
        public AboutWindowViewModel()
        {
        }

        #endregion

        #region Public Properties

        /// <summary>
        /// Gets the name of the application.
        /// </summary>
        public string ApplicationName
        {
            get
            {
                try
                {
                    return Application.Current.MainWindow.GetType().Assembly.GetName().Name;
                }
                catch (Exception e)
                {
                    logger.Error(e.Message, e);
                    return "N/A";
                }
            }
        }

        /// <summary>
        /// Gets the size of the application.
        /// </summary>
        public string ApplicationSize
        {
            get
            {
                try
                {
                    return new FileInfo(this.ApplicationPath).Length.ToString() + " bytes";
                }
                catch (Exception e)
                {
                    logger.Error(e.Message, e);
                    return "N/A";
                }
            }
        }

        /// <summary>
        /// Gets the application path.
        /// </summary>
        public string ApplicationPath
        {
            get
            {
                try
                {
                    return Process.GetCurrentProcess().MainModule.FileName;
                }
                catch (Exception e)
                {
                    logger.Error(e.Message, e);
                    return "N/A";
                }
            }
        }

        /// <summary>
        /// Gets the application version.
        /// </summary>
        public string ApplicationVersion
        {
            get
            {
                try
                {
                    return Application.Current.MainWindow.GetType().Assembly.GetName().Version.ToString();
                }
                catch (Exception e)
                {
                    logger.Error(e.Message, e);
                    return "N/A";
                }
            }
        }

        /// <summary>
        /// Gets the compiled date.
        /// </summary>
        public string CompiledDate
        {
            get
            {
                try
                {
                    DateTime buildDate = new FileInfo(this.ApplicationPath).LastWriteTime;
                    return buildDate.ToString("MM/dd/yyyy HH:mm");
                }
                catch (Exception e)
                {
                    logger.Error(e.Message, e);
                    return "N/A";
                }
            }
        }

        /// <summary>
        /// Gets the patch number.
        /// </summary>
        public string PatchNumber
        {
            get
            {
                try
                {
                    return String.Format("{0}", Application.Current.MainWindow.GetType().Assembly.GetName().Version.Build);
                }
                catch (Exception e)
                {
                    logger.Error(e.Message, e);
                    return "N/A";
                }
            }
        }

        /// <summary>
        /// Gets the name of the OS.
        /// </summary>
        public string OSName
        {
            get
            {
                try
                {
                    string osName = string.Empty;
                    ManagementObjectCollection osDetails = new ManagementObjectSearcher("SELECT * FROM Win32_OperatingSystem").Get();
                    foreach (ManagementObject mo in osDetails)
                    {
                        string propertyname = "caption";
                        osName = mo[propertyname].ToString();
                        break;
                    }

                    if (string.IsNullOrWhiteSpace(osName))
                        osName = "Unknown";

                    return osName;
                }
                catch (Exception)
                {
                    return "Unknown";
                }
            }
        }

        /// <summary>
        /// Gets the OS version.
        /// </summary>
        public string OSVersion
        {
            get
            {
                try
                {
                    return Environment.OSVersion.Version.ToString();
                }
                catch (Exception e)
                {
                    logger.Error(e.Message, e);
                    return "N/A";
                }
            }
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Gets the name of the Win32 NT Operating System.
        /// </summary>
        /// <param name="osMajorVersion">The os major version.</param>
        /// <param name="osMinorVersion">The os minor version.</param>
        /// <param name="osVersion">The os version.</param>
        /// <returns></returns>
        private string GetWin32NTWindowsName(int osMajorVersion, int osMinorVersion, string osVersion)
        {
            string name = String.Empty;

            switch (osMajorVersion)
            {
                case 0:
                    name = "Windows VistA / Windows 2008 Server";
                    break;

                case 1:
                    name = "Windows 7 / Windows 2008 Server R2";
                    break;

                case 2:
                    name = "Windows 8 / Windows 2012 Server";
                    break;

                case 3:
                    name = "Windows NT 3.51";
                    break;

                case 4:
                    name = "Windows NT 4.0";
                    break;

                case 5:
                    name = this.GetWin32WindowsName(osMinorVersion, true);
                    break;

                case 6:
                    name = osVersion;
                    break;

                default:
                    name = "Unknown";
                    break;
            }

            return name;
        }

        /// <summary>
        /// Gets the name of the Win32 Operating System.
        /// </summary>
        /// <param name="osMinorVersion">The os minor version.</param>
        /// <param name="ntNameNeeded">if set to <c>true</c> get the NT Windows name.</param>
        /// <returns>
        /// The string name version of windows
        /// </returns>
        private string GetWin32WindowsName(int osMinorVersion, bool ntNameNeeded)
        {
            string name = String.Empty;

            if (ntNameNeeded)
            {
                switch (osMinorVersion)
                {
                    case 0:
                        name = "Windows 2000";
                        break;

                    case 1:
                        name = "Windows XP";
                        break;

                    case 2:
                        name = "Windows 2003";
                        break;

                    default:
                        name = "Unknown";
                        break;
                }
            }
            else
            {
                switch (osMinorVersion)
                {
                    case 0:
                        name = "Windows 95";
                        break;

                    case 10:
                        name = "Windows 98";
                        break;

                    case 90:
                        name = "Windows ME";
                        break;

                    default:
                        name = "Unknown";
                        break;
                }
            }

            return name;
        }

        #endregion
    }
}
