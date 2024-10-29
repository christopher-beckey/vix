// -----------------------------------------------------------------------
// <copyright file="CaseConsultation.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Jun 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Consultation status for a case
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
    using System.ComponentModel;
    using System.Xml.Serialization;

    /// <summary>
    /// Store the information of a consultation for a case to be deserialized from XML output of ViX REST service
    /// </summary>
    public class CaseConsultation : INotifyPropertyChanged
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="CaseConsultation"/> class
        /// </summary>
        public CaseConsultation()
        {
            this.ConsultationID = string.Empty;
            this.Type = string.Empty;
            this.SiteID = string.Empty;
            this.SiteAbbr = string.Empty;
            this.Status = string.Empty;
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
        /// Gets or sets the interpretation id of the consultation
        /// </summary>
        [XmlElement("consultationId")]
        public string ConsultationID { get; set; }

        /// <summary>
        /// Gets or sets the type of the intepretation entry
        /// </summary>
        [XmlElement("consultationType")]
        public string Type { get; set; }

        /// <summary>
        /// Gets or sets the ID of the site doing consultation
        /// </summary>
        [XmlElement("siteId")]
        public string SiteID { get; set; }

        /// <summary>
        /// Gets or sets the abbreviation of the consulting site
        /// </summary>
        [XmlElement("siteAbbr")]
        public string SiteAbbr { get; set; }

        /// <summary>
        /// Gets or sets the status of the consultation
        /// </summary>
        [XmlElement("status")]
        public string Status { get; set; }
    }
}
