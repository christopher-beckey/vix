// -----------------------------------------------------------------------
// <copyright file="UserCredentials.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Jan 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Paul Pentapaty
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

namespace VistA.Imaging.Telepathology.Common.Model
{
    using System.Collections.Generic;
using VistA.Imaging.Telepathology.Common.VixModels;
    using System;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    public class UserCredentials
    {
        public string AccessCode { get; set; }
        
        public string VerifyCode { get; set; }
        
        public string Fullname { get; set; }

        public string Initials { get; set; }
        
        public string Duz { get; set; }
        
        public string Ssn { get; set; }
        
        public string SiteName { get; set; }
        
        public string SiteNumber { get; set; }

        public string SecurityToken { get; set; }

        public List<string> SecurityKeys { get; set; }

        public Dictionary<string, List<string>> LabSecurityKeys { get; set; }

        public Dictionary<string, PathologyElectronicSignatureNeedType> ESignatureStatuses { get; set; }

        public UserCredentials() 
        {
            SecurityKeys = new List<string>();
            LabSecurityKeys = new Dictionary<string, List<string>>();
            ESignatureStatuses = new Dictionary<string, PathologyElectronicSignatureNeedType>();
        }
        
        public UserCredentials(string accessCode, string verifyCode)
        {
            AccessCode = accessCode;
            VerifyCode = verifyCode;
            SecurityKeys = new List<string>();
            LabSecurityKeys = new Dictionary<string, List<string>>();
            ESignatureStatuses = new Dictionary<string, PathologyElectronicSignatureNeedType>();
        }

        public bool UserHasKey(string key)
        {
            if (SecurityKeys == null)
                return false;
            return SecurityKeys.Contains(key);
        }

        public bool UserHasKey(string siteID, string key)
        {
            if (this.LabSecurityKeys == null)
            {
                return false;
            }

            if (this.LabSecurityKeys.ContainsKey(siteID))
            {
                if (this.LabSecurityKeys[siteID] != null)
                {
                    return this.LabSecurityKeys[siteID].Contains(key);
                }
            }

            return false;
        }

        /// <summary>
        /// Retrieve the ESignature status for a user at a site for a report type
        /// </summary>
        /// <param name="key">A combincation of SiteStationNumber^ReportType</param>
        /// <returns>the status object or null</returns>
        public PathologyElectronicSignatureNeedType GetESignatureStatusAtSite(string key)
        {
            if (this.ESignatureStatuses == null)
            {
                return null;
            }

            if (this.ESignatureStatuses.ContainsKey(key))
            {
                PathologyElectronicSignatureNeedType status;
                try
                {
                    this.ESignatureStatuses.TryGetValue(key, out status);
                    return status;
                }
                catch (Exception)
                {
                    return null;
                }
            }

            return null;
        }

        /// <summary>
        /// Check to see if the user has the esignature status for the selected key yet
        /// </summary>
        /// <param name="key">A combincation of SiteStationNumber^ReportType</param>
        /// <returns>true if the user has the status and false otherwise</returns>
        public bool UserHasESignatureStatus(string key)
        {
            if (this.ESignatureStatuses == null)
                return false;

            if (this.ESignatureStatuses.ContainsKey(key))
                return true;
            else
                return false;
        }
    }
}
