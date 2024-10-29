// -----------------------------------------------------------------------
// <copyright file="AcquisitionSiteInfo.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: May 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Basic acquisition site information
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
    using System.Xml.Serialization;

    /// <summary>
    /// Basic information for an acquisition site
    /// </summary>
    public class AcquisitionSiteInfo : SiteInfo
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="AcquisitionSiteInfo"/> class
        /// </summary>
        public AcquisitionSiteInfo() : base()
        {
            this.PrimeSiteStationNumber = string.Empty;
            this.PrimeSiteIEN = string.Empty;
            this.PrimeSiteAbr = string.Empty;
            this.PrimeSiteName = string.Empty;
        }

        /// <summary>
        /// Gets or sets acquisition site station number
        /// </summary>
        [XmlElement("primarySiteStationNumber")]
        public string PrimeSiteStationNumber { get; set; }

        /// <summary>
        /// Gets or sets acquisition site ien
        /// </summary>
        [XmlIgnore]
        public string PrimeSiteIEN { get; set; }

        /// <summary>
        /// Gets or sets acquisition site name
        /// </summary>
        [XmlElement("primarySiteName")]
        public string PrimeSiteName { get; set; }

        /// <summary>
        /// Gets or sets acquisition site abbreviation
        /// </summary>
        [XmlElement("primarySiteAbbr")]
        public string PrimeSiteAbr { get; set; }

        /// <summary>
        /// Gets standard display name
        /// </summary>
        [XmlIgnore]
        public string PrimeSiteDisplayName
        {
            get
            {
                if (this.PrimeSiteStationNumber != string.Empty)
                {
                    return this.PrimeSiteName + " (" + this.PrimeSiteStationNumber + ")";
                }
                else
                {
                    return this.PrimeSiteName;
                }
            }
        }
    }

    [XmlRoot("pathologyAcquisitionSitesType")]
    public class AcquisitionSiteList
    {
        public AcquisitionSiteList()
        {
            this.Items = new ObservableCollection<AcquisitionSiteInfo>();
        }

        [XmlElement("site")]
        public ObservableCollection<AcquisitionSiteInfo> Items { get; set; }
    }
}
