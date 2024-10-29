// -----------------------------------------------------------------------
// <copyright file="PathologyCptCode.cs" company="Department of Veterans Affairs">
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

namespace VistA.Imaging.Telepathology.Common.VixModels
{
    using System;
    using System.ComponentModel;
    using System.Xml.Serialization;

    public class PathologyCptCode : INotifyPropertyChanged
    {
        public PathologyCptCode()
        {
            this.CPTCode = string.Empty;
            this.Description = string.Empty;
            this.MultiplyFactor = string.Empty;
            this.DateEntered = string.Empty;
            this.User = string.Empty;
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

        [XmlElement("cptCode")]
        public string CPTCode { get; set; }

        [XmlElement("description")]
        public string Description { get; set; }

        [XmlIgnore]
        public string CodeDesc
        {
            get
            {
                return String.Format("{0} {1}", this.CPTCode, this.Description);
            }
        }

        [XmlElement("multiplyFactor")]
        public string MultiplyFactor { get; set; }

        [XmlElement("dateEntered")]
        public string DateEntered { get; set; }

        [XmlIgnore]
        public string DateTimeEntered
        {
            get
            {
                if (!string.IsNullOrWhiteSpace(this.DateEntered))
                {
                    DateTime enterDate;
                    if (DateTime.TryParse(this.DateEntered, out enterDate))
                    {
                        return enterDate.ToString("MM-dd-yyyy HH:mm:ss");
                    }
                }

                return string.Empty;
            }
        }

        [XmlElement("user")]
        public string User { get; set; }
    }
}
