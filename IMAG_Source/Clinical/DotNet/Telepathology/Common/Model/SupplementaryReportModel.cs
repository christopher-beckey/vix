// -----------------------------------------------------------------------
// <copyright file="SupplementaryReportModel.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Mar 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Pathology Case
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

namespace VistA.Imaging.Telepathology.Common.Model
{
    using System;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Xml.Serialization;
    using VistA.Imaging.Telepathology.Common.VixModels;

    /// <summary>
    /// Supplementary report model
    /// </summary>
    public class SupplementaryReport : INotifyPropertyChanged
    {
        public SupplementaryReport()
        {
            Index = -1;
            SRDate = "";
            Verified = "";
            VerifiedBy = "";
            Modified = "";
            Content = "";
            IsDirty = false;
        }

        public int Index { get; set; }
        public string SRDate { get; set; }

        private string _VerifiedBy;
        public string VerifiedBy
        {
            get
            {
                return _VerifiedBy;
            }
            set
            {
                if (_VerifiedBy != value)
                {
                    _VerifiedBy = value;
                    NotifyPropertyChanged("VerifiedBy");
                }
            }
        }
        private string _Verified;
        public string Verified
        {
            get
            {
                return _Verified;
            }
            set
            {
                if (_Verified != value)
                {
                    _Verified = value;
                    NotifyPropertyChanged("Verified");
                    NotifyPropertyChanged("SRLabel");
                }
            }
        }
        public string Modified { get; set; }

        private string _Content;
        public string Content
        {
            get
            {
                return _Content;
            }
            set
            {
                if (_Content != value)
                {
                    _Content = value;
                    IsDirty = true;
                    NotifyPropertyChanged("Content");
                    NotifyPropertyChanged("SRLabel");
                }
            }
        }
        public bool IsDirty { get; set; }
        public string SRLabel
        {
            get
            {
                string lab;
                lab = "Date: " + SRDate + "\tVerified: " + Verified + "\n";
                lab += Content;
                return lab;
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(string info)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(info));
            }
        }
    }

    public class NewSupplementaryReport : INotifyPropertyChanged
    {
        public NewSupplementaryReport()
        {
            this.DateTimeUTC = string.Empty;
            this.Values = new List<string>();
            this.Verified = string.Empty;
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

        [XmlElement("supplementalReportDate")]
        public string DateTimeUTC { get; set; }

        [XmlIgnore]
        public string ReportDateTime
        {
            get
            {
                if (!string.IsNullOrEmpty(this.DateTimeUTC))
                {
                    DateTime studyDate;
                    if (DateTime.TryParse(this.DateTimeUTC, out studyDate))
                    {
                        return studyDate.ToString("MM-dd-yyyy HH:mm");
                    }
                    else
                    {
                        return string.Empty;
                    }
                }
                else
                {
                    return string.Empty;
                }
            }
        }

        [XmlArray("values")]
        [XmlArrayItem("value")]
        public List<string> Values { get; set; }

        [XmlIgnore]
        public string Content
        {
            get
            {
                string result = string.Empty;
                foreach (string value in this.Values)
                {
                    if (value != string.Empty)
                    {
                        result += value + "\r\n";
                    }
                }

                result = result.Trim();
                return result;
            }
        }

        [XmlElement("verified")]
        public string Verified { get; set; }
    }

    public class SupplementaryReportModel
    {
        public SupplementaryReportModel()
        {
            SRList = new ObservableCollection<SupplementaryReport>();
        }

        public void LoadSupplementReports(SupplementaryReportList supList)
        {
            if (supList == null)
                return;

            int entryInd = 0;
            foreach (NewSupplementaryReport rep in supList.Items)
            {
                SupplementaryReport sr = new SupplementaryReport()
                {
                    Index = entryInd,
                    SRDate = rep.ReportDateTime,
                    Verified = Boolean.Parse(rep.Verified) ? "Yes" : "No",
                    Content = rep.Content
                };
                sr.IsDirty = false;
                SRList.Add(sr);
                entryInd++;
            }
        }

        public void LoadSupplementReports(List<string> rawSR)
        {
            if (rawSR == null)
                return;

            int entryInd = 0;
            foreach (string entry in rawSR)
            {
                // entry = date^verified^modified^verifiedBy^Value1|Value2|
                string[] data = entry.Split('^');
                string[] values = data[4].Split('|');

                SupplementaryReport sr = new SupplementaryReport() {
                    Index = entryInd,
                    SRDate = data[0],
                    Verified = data[1],
                    Modified = data[2],
                    VerifiedBy = data[3],
                    Content = ""
                };

                for (int i = 0; i < values.Length - 1; i++)
                {
                    if (values[i] != "")
                        sr.Content += values[i] + "\r\n";
                }
                sr.IsDirty = false;
                SRList.Add(sr);
                entryInd++;
            }
        }

        public ObservableCollection<SupplementaryReport> SRList { get; set; }
    }
}
