// -----------------------------------------------------------------------
// <copyright file="SiteInfo.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: May 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Basic site information
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
    /// Basic information for a site
    /// </summary>
    public class SiteInfo : INotifyPropertyChanged
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="SiteInfo"/> class
        /// </summary>
        public SiteInfo()
        {
            this.SiteIEN = string.Empty;
            this.SiteStationNumber = string.Empty;
            this.SiteName = string.Empty;
            this.SiteAbr = string.Empty;
            this.Active = false;
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
        /// Gets or sets a value indicating whether site is available or not
        /// </summary>
        [XmlElement("active")]
        public bool Active { get; set; }

        /// <summary>
        /// Gets or sets site IEN
        /// </summary>
        [XmlIgnore]
        public string SiteIEN { get; set; }

        /// <summary>
        /// Gets or sets site station number
        /// </summary>
        [XmlElement("siteId")]
        public string SiteStationNumber { get; set; }

        /// <summary>
        /// Gets or sets site name
        /// </summary>
        [XmlElement("siteName")]
        public string SiteName { get; set; }

        /// <summary>
        /// Gets or sets site abbreviation
        /// </summary>
        [XmlElement("siteAbbr")]
        public string SiteAbr { get; set; }

        /// <summary>
        /// Gets the standard name for a site
        /// </summary>
        [XmlIgnore]
        public string SiteDisplayName
        {
            get
            {
                if (this.SiteStationNumber != string.Empty)
                {
                    return this.SiteName + " (" + this.SiteStationNumber + ")";
                }
                else
                {
                    return this.SiteName;
                }
            }
        }

        /// <summary>
        /// Set the availability of a site
        /// </summary>
        /// <param name="value">0 for inactive and 1 for active</param>
        public void SetActive(string value)
        {
            if (value == "0")
            {
                this.Active = false;
            }
            else
            {
                this.Active = true;
            }
        }
    }
}
