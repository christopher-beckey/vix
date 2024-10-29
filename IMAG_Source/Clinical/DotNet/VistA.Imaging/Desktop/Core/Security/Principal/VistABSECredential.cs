// -----------------------------------------------------------------------
// <copyright file="VistABSECredential.cs" company="Department of Veterans Affairs">
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

namespace VistA.Imaging.Security.Principal
{
    using System;
    using System.Diagnostics.Contracts;
    using VistA.Imaging.Models;

    /// <summary>
    /// BSE Credentials
    /// </summary>
    public class VistABSECredential : IVistACredential
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="VistABSECredential"/> class.
        /// </summary>
        public VistABSECredential()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="VistABSECredential"/> class.
        /// </summary>
        /// <param name="bseToken">The bse token.</param>
        /// <param name="institution">The institution.</param>
        public VistABSECredential(string bseToken, Institution institution)
        {
            Contract.Requires<ArgumentException>(!string.IsNullOrWhiteSpace(bseToken));
            this.BSEToken = bseToken;
            this.Institution = institution;
        }

        /// <summary>
        /// Gets or sets the BSEToken.
        /// </summary>
        public string BSEToken { get; set; }

        /// <summary>
        /// Gets or sets the institution.
        /// </summary>
        public Institution Institution { get; set; }
    }
}
