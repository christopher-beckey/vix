﻿// -----------------------------------------------------------------------
// <copyright file="PathologyAcquisitionSiteType.cs" company="Department of Veterans Affairs">
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
    using System.ComponentModel;
    using System.Xml.Serialization;

    [XmlRoot("pathologyAcquisitionSiteType")]
    public class PathologyAcquisitionSiteType : INotifyPropertyChanged
    {
        public PathologyAcquisitionSiteType()
        {
            this.Active = false;
            this.SiteStationNumber = string.Empty;
            this.PrimarySiteStationNumber = string.Empty;
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

        [XmlElement("active")]
        public bool Active { get; set; }

        [XmlElement("siteId")]
        public string SiteStationNumber { get; set; }

        [XmlElement("primarySiteStationNumber")]
        public string PrimarySiteStationNumber { get; set; }
    }
}
