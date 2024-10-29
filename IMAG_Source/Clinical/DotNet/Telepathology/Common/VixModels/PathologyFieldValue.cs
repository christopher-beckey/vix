// -----------------------------------------------------------------------
// <copyright file="PathologyFieldValue.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Jul 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Generic object to hold simple data
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

    /// <summary>
    /// Generic object to be populated via the VIX that hold simple data pair id and value
    /// </summary>
    public class PathologyFieldValue : INotifyPropertyChanged
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="PathologyFieldValue"/> class
        /// </summary>
        public PathologyFieldValue()
        {
            this.FieldURN = string.Empty;
            this.FieldName = string.Empty;
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

        /// <summary>
        /// Gets or sets the id of the field
        /// </summary>
        [XmlElement("id")]
        public string FieldURN { get; set; }

        /// <summary>
        /// Gets or sets the name of the field
        /// </summary>
        [XmlElement("name")]
        public string FieldName { get; set; }

        [XmlIgnore]
        public string FieldDescription
        {
            get
            {
                if (!string.IsNullOrEmpty(this.FieldName))
                {
                    string[] piece = this.FieldName.Split('^');
                    if ((piece != null) && (piece.Length > 0))
                    {
                        return piece[0];
                    }
                }

                return string.Empty;
            }
        }

        [XmlIgnore]
        public string FieldCode
        {
            get
            {
                if (!string.IsNullOrEmpty(this.FieldName))
                {
                    string[] piece = this.FieldName.Split('^');
                    if ((piece != null) && (piece.Length > 1))
                    {
                        return piece[1];
                    }
                }

                return string.Empty;
            }
        }

        [XmlIgnore]
        public string FieldDisplay
        {
            get
            {
                return String.Format("{0} {1}", this.FieldDescription, this.FieldCode);
            }
        }
    }
}
