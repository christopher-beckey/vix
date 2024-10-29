﻿// -----------------------------------------------------------------------
// <copyright file="PathologySnomedCode.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Jul 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Store the snomed code object from VIX
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
    using System.ComponentModel;
    using System.Xml.Serialization;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class PathologySnomedCode : INotifyPropertyChanged
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

        [XmlElement("tissueId")]
        public string OrganID { get; set; }

        [XmlElement("tissueCode")]
        public string OrganCode { get; set; }

        [XmlElement("tissue")]
        public string OrganName { get; set; }

        [XmlElement("field")]
        public string FieldType { get; set; }

        [XmlElement("snomedCode")]
        public string SnomedCode { get; set; }

        [XmlElement("snomedValue")]
        public string SnomedName { get; set; }

        [XmlElement("snomedId")]
        public string SnomedID { get; set; }

        [XmlElement("etiologyId")]
        public string EtiologyID { get; set; }

        [XmlElement("etiologySnomedCode")]
        public string EtiologySnomedCode { get; set; }

        [XmlElement("etiologySnomedValue")]
        public string EtiologySnomedName { get; set; }
    }
}