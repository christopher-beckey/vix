// -----------------------------------------------------------------------
// <copyright file="VistAAccessVerifyCredential.cs" company="Department of Veterans Affairs">
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
    using System.Net;
    using VistA.Imaging.Models;

    /// <summary>
    /// VistA Access and Verify Credential
    /// </summary>
    public class VistAAccessVerifyCredential : NetworkCredential, IVistACredential
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="VistAAccessVerifyCredential"/> class.
        /// </summary>
        public VistAAccessVerifyCredential()
        {
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="VistAAccessVerifyCredential"/> class.
        /// </summary>
        /// <param name="accessCode">The access code.</param>
        /// <param name="verifyCode">The verify code.</param>
        /// <param name="institution">The institution.</param>
        public VistAAccessVerifyCredential(string accessCode, string verifyCode, Institution institution)
            : base(accessCode, verifyCode)
        {
            this.Institution = institution;
        }

        /// <summary>
        /// Gets or sets the access code.
        /// </summary>
        public string AccessCode
        {
            get { return this.UserName; }
            set { this.UserName = value; }
        }

        /// <summary>
        /// Gets or sets the access code.
        /// </summary>
        public string VerifyCode
        {
            get { return this.Password; }
            set { this.Password = value; }
        }
        
        /// <summary>
        /// Gets or sets the institution.
        /// </summary>
        public Institution Institution { get; set; }
    }
}
