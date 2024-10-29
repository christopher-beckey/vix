﻿// -----------------------------------------------------------------------
// <copyright file="PathologyFieldValuesType.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Jul 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Hold a list of generic fields
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
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using System.Xml.Serialization;

    /// <summary>
    /// A serializable object for interfacing with the Vix.
    /// </summary>
    [XmlRoot("pathologyFieldValuesType")]
    public class PathologyFieldValuesType : INotifyPropertyChanged
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="PathologyFieldValuesType"/> class
        /// </summary>
        public PathologyFieldValuesType()
        {
            this.FieldList = new ObservableCollection<PathologyFieldValue>();
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
        /// Gets or sets a list of data fields
        /// </summary>
        [XmlElement("value")]
        public ObservableCollection<PathologyFieldValue> FieldList { get; set; }
    }
}
