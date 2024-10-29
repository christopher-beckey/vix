// -----------------------------------------------------------------------
// <copyright file="AboutViewModel.cs" company="Department of Veterans Affairs">
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

namespace VistA.Imaging.Telepathology.Common.Controls
{
    using System;
    using System.ComponentModel;
    using System.Diagnostics;
    using System.IO;
    using System.Management;
    using System.Windows;
    using VistA.Imaging.Telepathology.Common.Model;

    public class AboutViewModel : INotifyPropertyChanged
    {
        /// <remarks>
        /// The PropertyChanged event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        /// </remarks>
        /// <summary>
        /// Event to be raised when a property is changed
        /// </summary>
#pragma warning disable 0067
        // Warning disabled because the event is raised by NotifyPropertyWeaver (http://code.google.com/p/notifypropertyweaver/)
        public event PropertyChangedEventHandler PropertyChanged;
#pragma warning restore 0067

        public string ApplicationName
        {
            get
            {
                try
                {
                    return Application.Current.MainWindow.GetType().Assembly.GetName().Name;
                }
                catch (Exception)
                {
                    return "N/A";
                }
            }
        }

        public string ApplicationVersion
        {
            get
            {
                try
                {
                    return Application.Current.MainWindow.GetType().Assembly.GetName().Version.ToString();
                }
                catch (Exception)
                {
                    return "N/A";
                }
            }
        }

        public string ApplicationPath
        {
            get
            {
                try
                {
                    return Process.GetCurrentProcess().MainModule.FileName;
                }
                catch (Exception)
                {
                    return "N/A";
                }
            }
        }

        public string VersionNumber
        {
            get
            {
                try
                {
                    return String.Format("{0}.{1}", Application.Current.MainWindow.GetType().Assembly.GetName().Version.Major,
                                                          Application.Current.MainWindow.GetType().Assembly.GetName().Version.Minor);
                }
                catch (Exception)
                {
                    return "N/A";
                }
            }
        }

        public string PatchNumber
        {
            get
            {
                try
                {
                    return String.Format("{0}", Application.Current.MainWindow.GetType().Assembly.GetName().Version.Build);
                }
                catch (Exception)
                {
                    return "N/A";
                }
            }
        }
        
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

        public string OSVersion
        {
            get
            {
                try
                {
                    return Environment.OSVersion.Version.ToString();
                }
                catch (Exception)
                {
                    return "N/A";
                }
            }
        }

        public string ServerStatus
        {
            get
            {
                try
                {
                    if (UserContext.LocalSite.IsProductionAccount)
                        return "Production";
                    else
                        return "Alpha/Beta Version";
                }
                catch (Exception)
                {
                    return "N/A";
                }
            }
        }

        public string CompiledDate
        {
            get
            {
                try
                {
                    DateTime buildDate = new FileInfo(this.ApplicationPath).LastWriteTime;
                    return buildDate.ToString("MM/dd/yyyy HH:mm");
                }
                catch (Exception)
                {
                    return "N/A";
                }
            }
        }

        public string ApplicationSize
        {
            get
            {
                try
                {
                    return new FileInfo(this.ApplicationPath).Length.ToString() + " bytes";
                }
                catch (Exception)
                {
                    return "N/A";
                }
            }
        }
    }
}
