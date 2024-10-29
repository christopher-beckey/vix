/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */


using System;
using System.Collections.Generic;
using System.Configuration;
using System.Security;

namespace ImagingClient.Infrastructure.User.Model
{
    public class UserCredentials
    {
        public String AccessCode { get; set; }
        public String VerifyCode { get; set; }
        public String Fullname { get; set; }
        public String Duz { get; set; }
        public String Ssn { get; set; }
        public String SiteName { get; set; }
        public String SiteNumber { get; set; }
        private String SiteId = ConfigurationManager.AppSettings.Get("SiteId");
        public Division CurrentDivision { get; set; }
        public String PlaceId 
        { 
            get
            {
                if (CurrentDivision != null)
                {
                    return CurrentDivision.DivisionCode;
                }
                else
                {
                    return SiteNumber;
                }
            }
        }

        public String PlaceName
        {
            get
            {
                if (CurrentDivision != null)
                {
                    return CurrentDivision.DivisionName;
                }
                else
                {
                    return SiteName;
                }
            }
        }

        public List<String> SecurityKeys { get; set; }

        public UserCredentials() {}
        public UserCredentials(string accessCode, string verifyCode)
        {
            AccessCode = accessCode;
            VerifyCode = verifyCode;
        }

        public bool UserHasKey(String key)
        {
            return SecurityKeys.Contains(key);
        }
    }
}
