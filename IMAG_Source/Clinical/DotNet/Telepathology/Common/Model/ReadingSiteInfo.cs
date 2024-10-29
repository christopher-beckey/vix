// -----------------------------------------------------------------------
// <copyright file="ReadingSiteInfo.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: May 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Duc Nguyen
//  Description: Basic reading site information
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
    using System.Collections.Generic;
    using System.Xml.Serialization;

    /// <summary>
    /// Type available for site configuration
    /// </summary>
    public enum ReadingSiteType
    {
        /// <summary>
        /// For site doing primary interpretation
        /// </summary>
        interpretation,

        /// <summary>
        /// For site doing consultation
        /// </summary>
        consultation,

        /// <summary>
        /// For site doing both
        /// </summary>
        both,

        /// <summary>
        /// Undefined type
        /// </summary>
        undefined
    }

    /// <summary>
    /// Basic information for a reading site
    /// </summary>
    public class ReadingSiteInfo : SiteInfo
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="ReadingSiteInfo"/> class
        /// </summary>
        public ReadingSiteInfo() : base()
        {
            this.SiteType = ReadingSiteType.undefined;
        }

        /// <summary>
        /// Gets or sets the type of the reading site
        /// </summary>
        [XmlElement("readingSiteType")]
        public ReadingSiteType SiteType { get; set; }

        ///// <summary>
        ///// Gets or sets reading type for site
        ///// </summary>
        //public ReadingSiteType Type
        //{
        //    get
        //    {
        //        if (!string.IsNullOrWhiteSpace(this.SiteType))
        //        {
        //            if (this.SiteType == "interpretation")
        //            {
        //                return ReadingSiteType.Interpretation;
        //            }
        //            else if (this.SiteType == "consultation")
        //            {
        //                return ReadingSiteType.Consultation;
        //            }
        //            else if (this.SiteType == "both")
        //            {
        //                return ReadingSiteType.Both;
        //            }
        //        }
        //        return ReadingSiteType.Interpretation;
        //    }
        //}

        /// <summary>
        /// Gets a value indicating whether site can do primary interpretation
        /// </summary>
        public bool CanSiteInterpretate
        {
            get
            {
                switch (this.SiteType)
                {
                    case ReadingSiteType.interpretation:
                    case ReadingSiteType.both:
                        return true;
                    case ReadingSiteType.consultation:
                    case ReadingSiteType.undefined:
                        return false;
                    default:
                        return false;
                }
            }
        }

        /// <summary>
        /// Gets a value indicating whether site can do consultation
        /// </summary>
        public bool CanSiteConsult
        {
            get
            {
                switch (this.SiteType)
                {
                    case ReadingSiteType.consultation:
                    case ReadingSiteType.both:
                        return true;
                    case ReadingSiteType.interpretation:
                    case ReadingSiteType.undefined:
                        return false;
                    default:
                        return false;
                }
            }
        }
    }

    [XmlRoot("pathologyReadingSitesType")]
    public class ReadingSiteList
    {
        public ReadingSiteList()
        {
            this.Items = new List<ReadingSiteInfo>();
        }

        [XmlElement("site")]
        public List<ReadingSiteInfo> Items { get; set; }
    }
}
