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
using System.Collections.ObjectModel;
using System.Text;
using ImagingClient.Infrastructure.User.Model;
using ImagingClient.Infrastructure.UserDataSource;

namespace ImagingClient.Infrastructure.UserDataSource
{
    public class MockUserDataSource : IUserDataSource
    {
        public void AuthenticateUser(String accessCode, String verifyCode)
        {
            UserCredentials credentials = new UserCredentials(accessCode, verifyCode);
            UserContext.UserCredentials = credentials;
            UserContext.IsLoginSuccessful = false;
            UserContext.LoginErrorMessage = String.Empty;

            if (accessCode == "Staging")
            {
                UserContext.IsLoginSuccessful = true;
                UserContext.UserCredentials.SecurityKeys = new List<String> { "Staging" };
            }
            if (accessCode == "AdvancedStaging")
            {
                UserContext.IsLoginSuccessful = true;
                UserContext.UserCredentials.SecurityKeys = new List<String> { "AdvancedStaging" };
            }
            if (accessCode == "ContractedStudies")
            {
                UserContext.IsLoginSuccessful = true;
                UserContext.UserCredentials.SecurityKeys = new List<String> { "ContractedStudies" };
            }
            if (accessCode == "Administrator")
            {
                UserContext.IsLoginSuccessful = true;
                UserContext.UserCredentials.SecurityKeys = new List<String> { "Administrator" };
            }
            if (accessCode == "Reports")
            {
                UserContext.IsLoginSuccessful = true;
                UserContext.UserCredentials.SecurityKeys = new List<String> { "Reports" };
            }

            if (!UserContext.IsLoginSuccessful)
            {
                UserContext.LoginErrorMessage = "Invalid Access Code";
            }
        }

        public string GetWelcomeMessage()
        {
            StringBuilder builder = new StringBuilder();

            builder.Append("You are currently using a fully functional UI going against local mock data. ");
            builder.AppendLine("You can use this UI to test all GUI functionality, including security roles.");
            builder.AppendLine("");
            builder.AppendLine("There are 5 different access codes you can use, mapping to the 5 roles in the system. None of them require a verify code:");
            builder.AppendLine("");
            builder.AppendLine("   Staging");
            builder.AppendLine("   AdvancedStaging");
            builder.AppendLine("   ContractedStudies");
            builder.AppendLine("   Administrator");
            builder.AppendLine("   Reports");
            return builder.ToString();
        }

        public ObservableCollection<Division> GetDivisionList(String accessCode)
        {
            return new ObservableCollection<Division>
                       {
                           new Division
                               {
                                   DivisionIen = "1",
                                   DivisionCode = "660",
                                   DivisionName = "Salt Lake City"
                               }
                       };
        }

        public AuthenticationResult Authenticate(VistaCommon.gov.va.med.Security.VistACredentials credentials)
        {
            throw new NotImplementedException();
        }
    }
}
