// -----------------------------------------------------------------------
// <copyright file="SiteConnectionInfo.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 11/30/2011
//   Site Name:  Washington OI Field Office, Silver Spring, MD
//   Developer: vhaiswgraver
//   Description: 
//         ;; +--------------------------------------------------------------------+
//         ;; Property of the US Government.
//         ;; No permission to copy or redistribute this software is given.
//         ;; Use of unreleased versions of this software requires the user
//         ;;  to execute a written test agreement with the VistA Imaging
//         ;;  Development Office of the Department of Veterans Affairs,
//         ;;  telephone (301) 734-0100.
//         ;;
//         ;; The Food and Drug Administration classifies this software as
//         ;; a Class II medical device.  As such, it may not be changed
//         ;; in any way.  Modifications to this software may result in an
//         ;; adulterated medical device under 21CFR820, the use of which
//         ;; is considered to be a violation of US Federal Statutes.
//         ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.Models
{
    using System;
using System.Collections.Generic;

    /// <summary>
    /// The site connection information
    /// </summary>
    public class SiteConnectionInfo
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="SiteConnectionInfo"/> class.
        /// </summary>
        public SiteConnectionInfo()
        {
            this.Services = new Dictionary<string, ServiceGroupInfo>();
        }

        /// <summary>
        /// Gets or sets the id.
        /// </summary>
        public string Id { get; set; }

        /// <summary>
        /// Gets or sets the name.
        /// </summary>
        public string Name { get; set; }

        /// <summary>
        /// Gets or sets the abreviation.
        /// </summary>
        public string Abreviation { get; set; }

        /// <summary>
        /// Gets or sets the vist A URI.
        /// </summary>
        public Uri VistAUri { get; set; }

        /// <summary>
        /// Gets or sets the vix URI.
        /// </summary>
        public Uri VixUri { get; set; }

        /// <summary>
        /// Gets or sets the services.
        /// </summary>
        public Dictionary<string, ServiceGroupInfo> Services { get; set; }
    }
}
