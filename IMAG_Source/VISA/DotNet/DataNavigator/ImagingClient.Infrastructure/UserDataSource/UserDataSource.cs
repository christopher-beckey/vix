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
using System.Configuration;
using ImagingClient.Infrastructure.Rest;
using ImagingClient.Infrastructure.User.Model;
using VistaCommon.gov.va.med.Security;
using VistaCommon.gov.va.med;
using VistaCommon;

namespace ImagingClient.Infrastructure.UserDataSource
{
    public class UserDataSource : IUserDataSource
    {
        private static Uri userServiceUrl;

        public UserDataSource()
        {

        }

        private static Uri UserServiceUrl
        {
            get
            {
                if (userServiceUrl == null)
                {
                    string url = ConfigurationManager.AppSettings["UserWebAppUrl"];
                    if (string.IsNullOrWhiteSpace(url))
                    {
                        SiteAddress address = SiteServiceHelper.GetSite(ConfigurationManager.AppSettings["SiteId"]);
                        url = "http://" + address.VixHost + ":" + address.VixPort + "/UserWebApp";
                    }

                    userServiceUrl = new Uri(url);
                }

                return userServiceUrl;
            }
        }

        public void AuthenticateUser(string accessCode, string verifyCode)
        {

            // Put an initial version of the UserCredential object in context, containing access and verify codes.
            // It will be replaced with the full version upon successful login
            UserContext.UserCredentials = new UserCredentials(accessCode, verifyCode);

            // Build the resource path
            String resourcePath = "user/authenticateUser";


            try
            {
                UserCredentials credentials = RestUtils.DoGetObject<UserCredentials>(UserServiceUrl.ToString(), resourcePath);
                credentials.AccessCode = accessCode;
                credentials.VerifyCode = verifyCode;
                UserContext.IsLoginSuccessful = true;
                UserContext.UserCredentials = credentials;
                UserContext.LoginErrorMessage = String.Empty;
            }
            catch (Exception e)
            {
                UserContext.IsLoginSuccessful = false;
                UserContext.LoginErrorMessage = e.Message;
            }

        }

        public AuthenticationResult Authenticate(VistACredentials credentials)
        {
            throw new NotImplementedException();
        }

        public string GetWelcomeMessage()
        {
            String welcomeMessage = "";

            try
            {
                String resourcePath = "public/getWelcomeMessage";
                return RestUtils.DoGetString(UserServiceUrl.ToString(), resourcePath, false);
            }
            catch (Exception)
            {
                welcomeMessage = "Unable to retrieve welcome message from VistA...";
            }

            return welcomeMessage;


        }

        public ObservableCollection<ImagingClient.Infrastructure.User.Model.Division> GetDivisionList(String accessCode)
        {
            String resourcePath = "user/getDivisionList?accessCode=" + accessCode;
            return RestUtils.DoGetObject<ObservableCollection<ImagingClient.Infrastructure.User.Model.Division>>(UserServiceUrl.ToString(), resourcePath);
        }
    }
}
