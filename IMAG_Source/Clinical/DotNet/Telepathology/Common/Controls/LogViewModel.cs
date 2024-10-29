// -----------------------------------------------------------------------
// <copyright file="LogViewModel.cs" company="Department of Veterans Affairs">
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
    using System.IO;
    using System.Text.RegularExpressions;

   
    public enum MagLogLevel
    {
        Fatal,
        Error,
        Warn,
        Info,
        Debug
    }

    public class LogViewModel : INotifyPropertyChanged
    {
        private string[] listText;

        public LogViewModel()
        {
            this.RegularLog = string.Empty;
            this.SystemLog = string.Empty;
            this.listText = null ;
            this.CanViewSystemLog = false;
        }

        public LogViewModel(string logPath, bool canViewSystemLog)
        {
            this.RegularLog = string.Empty;
            this.SystemLog = string.Empty;
            this.listText = null;
            this.CanViewSystemLog = canViewSystemLog;

            LoadLog(logPath);
            ParseText();

            this.MessageLog = this.RegularLog;
        }

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

        public string RegularLog { get; set; }

        public string SystemLog { get; set; }

        public string MessageLog { get; set; }

        public bool CanViewSystemLog { get; set; }

        public void ChangeLogType(bool sysLog)
        {
            if ((this.CanViewSystemLog) && (sysLog))
            {
                this.MessageLog = this.SystemLog;
            }
            else
            {
                this.MessageLog = this.RegularLog;
            }
        }

        private void LoadLog(string logPath)
        {
            if (File.Exists(logPath))
            {
                try
                {
                    using (StreamReader reader = new StreamReader(new FileStream(logPath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)))
                    {
                        string rawText = reader.ReadToEnd();
                        listText = Regex.Split(rawText, Environment.NewLine);
                    }
                }
                catch (Exception)
                {

                }
            }
        }

        private void ParseText()
        {
            if (this.listText == null)
            {
                this.RegularLog = string.Empty;
                this.SystemLog = string.Empty;
                return;
            }

            bool errorLines = false;
            foreach (string line in this.listText)
            {
                if (string.IsNullOrWhiteSpace(line))
                    continue;

                string[] pieces = line.Split('~');
                if ((pieces != null) && (pieces.Length >= 1))
                {
                    MagLogLevel level;
                    if (!Enum.TryParse<MagLogLevel>(pieces[0], true, out level))
                    {
                        // if level cannot be parsed, put it error level
                        level = MagLogLevel.Error;
                    }
                    else
                    {
                        // if level can be parse then no longer error line
                        errorLines = false;
                    }

                    if (!errorLines)
                    {
                        // Info, warn go to normal log, the rest goes to system log
                        switch (level)
                        {
                            case MagLogLevel.Info:
                            case MagLogLevel.Warn:
                                if (pieces.Length >= 5)
                                {
                                    string[] infoPieces = pieces[4].Split('|');
                                    string infoLines = string.Empty;

                                    if ((infoPieces == null) || (infoPieces.Length == 1))
                                    {
                                        infoLines = pieces[4];
                                    }
                                    else
                                    {
                                        infoLines += infoPieces[0];
                                        for (int i = 1; i < infoPieces.Length; i++ )
                                            infoLines += Environment.NewLine + "\t\t" + infoPieces[i];
                                    }

                                    this.RegularLog += String.Format("{0}\t{1}\n", pieces[1], infoLines);
                                    this.SystemLog += String.Format("{0}\t{1}\t{2}\n\t{3}\n", pieces[1], pieces[0], pieces[3], infoLines);
                                }
                                break;
                            default:
                                if (pieces.Length >= 2)
                                {
                                    // begining of error lines
                                    errorLines = true;
                                    this.SystemLog += String.Format("{0}\t{1}\t{2}\n\t{3}\n", pieces[1], pieces[0], pieces[3], pieces[4]);
                                }
                                break;
                        }
                    }
                    else
                    {
                       // continue to add error lines
                        if (pieces.Length >= 1)
                        {
                            this.SystemLog += String.Format("\t\t{0}\n", pieces[0].Trim());
                        }
                    }
                }
            }
        }
    }
}
