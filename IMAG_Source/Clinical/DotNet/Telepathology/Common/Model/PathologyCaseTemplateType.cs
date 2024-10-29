// -----------------------------------------------------------------------
// <copyright file="PathologyCaseTemplateType.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: July 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
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

namespace VistA.Imaging.Telepathology.Common.Model
{
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Xml.Serialization;

    public class PathologyCaseTemplateFieldType : INotifyPropertyChanged
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

        [XmlElement("fieldNumber")]
        public string FieldNumber { get; set; }

        [XmlElement("label")]
        public string Label { get; set; }

        [XmlArray("values")]
        [XmlArrayItem("value")]
        public ObservableCollection<string> Values { get; set; }

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
    }

    [XmlRoot("pathologyCaseTemplateType")]
    public class PathologyCaseTemplateType : INotifyPropertyChanged
    {
        public PathologyCaseTemplateType()
        {
            this.Fields = new ObservableCollection<PathologyCaseTemplateFieldType>();
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

        [XmlArray("fields")]
        [XmlArrayItem("field")]
        public ObservableCollection<PathologyCaseTemplateFieldType> Fields { get; set; }
    }
}
