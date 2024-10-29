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
namespace ImagingClient.Infrastructure.UserDataSource
{
    using System;
    using System.Text;
    using System.Net.Http;
    using System.Collections.ObjectModel;
    using System.ComponentModel;
    using ImagingClient.Infrastructure.Commands;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.Model;
    using ImagingClient.Infrastructure.Rest;
    using ImagingClient.Infrastructure.User.Model;
    using Microsoft.Practices.Prism.Events;
    using Microsoft.Practices.ServiceLocation;

    /// <summary>
    /// The user data source.
    /// </summary>
    public class UserDataSource : IUserDataSource
    {
        #region Constants and Fields

        /// <summary>
        /// The user service url.
        /// </summary>
        private string userServiceUrl = "UserWebApp";

        #endregion

        #region Public Methods

        /// <summary>
        /// Authenticates the user.
        /// </summary>
        /// <param name="accessCode">
        /// The access code.
        /// </param>
        /// <param name="verifyCode">
        /// The verify code.
        /// </param>
        public void AuthenticateUser(string accessCode, string verifyCode)
        {
            // Put an initial version of the UserCredential object in context, containing access and verify codes.
            // It will be replaced with the full version upon successful login
            UserContext.UserCredentials = new UserCredentials(accessCode, verifyCode);

            // Build the resource path
            string resourcePath = "user/authenticateUser?applicationName=Importer2";

            try
            {
                UserCredentials credentials = RestUtils.DoGetObject<UserCredentials>(this.userServiceUrl, resourcePath);
                credentials.AccessCode = accessCode;
                credentials.VerifyCode = verifyCode;
                UserContext.IsLoginSuccessful = true;
                UserContext.UserCredentials = credentials;
                UserContext.LoginErrorMessage = string.Empty;

                CancelEventArgs e = new CancelEventArgs();
                IEventAggregator eventAggregator = ServiceLocator.Current.GetInstance<IEventAggregator>();

                // Initiaties appropriate clean up actions if a new user has logged in after a timeout has occurred.
                if (UserContext.LastLoggedInUsersDUZ != null)
                {
                    if (!UserContext.LastLoggedInUsersDUZ.Equals(UserContext.UserCredentials.Duz))
                    {
                        if (CompositeCommands.TimeoutClearReconcileCommand.CanExecute(e) && UserContext.TimeoutOccurred)
                        {
                            // Notifies open children windows that a new user has logged in
                            eventAggregator.GetEvent<NewUserLoginEvent>().Publish(UserContext.UserCredentials.Duz);
                            CompositeCommands.TimeoutClearReconcileCommand.Execute(e);
                        }
                    }
                }

                UserContext.TimeoutOccurred = false;
                UserContext.LastLoggedInUsersDUZ = UserContext.UserCredentials.Duz;

                eventAggregator.GetEvent<UserLoginEvent>().Publish(UserContext.UserCredentials.Fullname);
            }
            catch (Exception e)
            {
                UserContext.IsLoginSuccessful = false;
                UserContext.LoginErrorMessage = e.Message;
            }
        }

        /// <summary>
        /// Authenticates the user.
        /// </summary>
        /// <param name="xmlToken">
        /// PIV/PIN XML Token from IAM.
        /// </param>
        public void AuthenticatePivUser(string xmlToken)
        {
            // Put an initial version of the UserCredential object in context, containing access and verify codes.
            // It will be replaced with the full version upon successful login
            UserContext.UserCredentials = new UserCredentials(); //new UserCredentials(accessCode, verifyCode);

            try
            {
                HttpContent tokenContent = new StringContent(xmlToken);
                tokenContent.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/xml");

                UserCredentials credentials = RestUtils.DoPost<UserCredentials>(this.userServiceUrl, "public/authenticateSSOUser", tokenContent, false);
                if (credentials != null)
                {
                    int duz = 0;
                    int.TryParse(credentials.Duz, out duz);

                    if (duz > 0)
                    {
                        //credentials.AccessCode = accessCode;
                        //credentials.VerifyCode = verifyCode;
                        UserContext.IsLoginSuccessful = true;
                        UserContext.UserCredentials = credentials;
                        UserContext.LoginErrorMessage = string.Empty;

                        CancelEventArgs e = new CancelEventArgs();
                        IEventAggregator eventAggregator = ServiceLocator.Current.GetInstance<IEventAggregator>();

                        // Initiaties appropriate clean up actions if a new user has logged in after a timeout has occurred.
                        if (UserContext.LastLoggedInUsersDUZ != null)
                        {
                            if (!UserContext.LastLoggedInUsersDUZ.Equals(UserContext.UserCredentials.Duz))
                            {
                                if (CompositeCommands.TimeoutClearReconcileCommand.CanExecute(e) && UserContext.TimeoutOccurred)
                                {
                                    // Notifies open children windows that a new user has logged in
                                    eventAggregator.GetEvent<NewUserLoginEvent>().Publish(UserContext.UserCredentials.Duz);
                                    CompositeCommands.TimeoutClearReconcileCommand.Execute(e);
                                }
                            }
                        }

                        UserContext.TimeoutOccurred = false;
                        UserContext.LastLoggedInUsersDUZ = UserContext.UserCredentials.Duz;

                        eventAggregator.GetEvent<UserLoginEvent>().Publish(UserContext.UserCredentials.Fullname);
                    }
                    else
                        //if DUZ = 0 than there is an authentication issue, check FullName for message
                        throw new Exception(credentials.Fullname);
                }
                else
                    throw new Exception("An unexpected error occurred, please try again.");
            }
            catch (Exception e)
            {
                UserContext.IsLoginSuccessful = false;
                UserContext.LoginErrorMessage = e.Message;
            }
        }

        public void AuthenticateBseUser()
        {
            if (UserContext.UserCredentials == null) return;

            // Build the resource path
            string resourcePath = "user/authenticateUser?applicationName=Importer2";

            try
            {
                UserCredentials credentials = RestUtils.DoGetObject<UserCredentials>(this.userServiceUrl, resourcePath);
                if (credentials == null)
                    throw new Exception("ERROR: UserDataSource.AuthenticateBseUser - UserCredentials returned from Vix is null");

                UserContext.IsLoginSuccessful = true;
                UserContext.UserCredentials.SecurityKeys = credentials.SecurityKeys;
                UserContext.LoginErrorMessage = string.Empty;

                CancelEventArgs e = new CancelEventArgs();
                IEventAggregator eventAggregator = ServiceLocator.Current.GetInstance<IEventAggregator>();

                // Initiaties appropriate clean up actions if a new user has logged in after a timeout has occurred.
                if (UserContext.LastLoggedInUsersDUZ != null)
                {
                    if (!UserContext.LastLoggedInUsersDUZ.Equals(UserContext.UserCredentials.Duz))
                    {
                        if (CompositeCommands.TimeoutClearReconcileCommand.CanExecute(e) && UserContext.TimeoutOccurred)
                        {
                            // Notifies open children windows that a new user has logged in
                            eventAggregator.GetEvent<NewUserLoginEvent>().Publish(UserContext.UserCredentials.Duz);
                            CompositeCommands.TimeoutClearReconcileCommand.Execute(e);
                        }
                    }
                }

                UserContext.TimeoutOccurred = false;
                UserContext.LastLoggedInUsersDUZ = UserContext.UserCredentials.Duz;

                eventAggregator.GetEvent<UserLoginEvent>().Publish(UserContext.UserCredentials.Fullname);
            }
            catch (Exception e)
            {
                UserContext.IsLoginSuccessful = false;
                UserContext.LoginErrorMessage = e.Message;
            }
        }

        /// <summary>
        /// Gets the application timeout.
        /// </summary>
        /// <returns></returns>
        public ApplicationTimeoutParameters GetApplicationTimeout()
        {
            string resourcePath = string.Format("user/getApplicationTimeoutParameters?siteId={0}&applicationName={1}", UserContext.UserCredentials.SiteNumber, "IMPORTER");

            return RestUtils.DoGetObject<ApplicationTimeoutParameters>(this.userServiceUrl, resourcePath);
        }

        /// <summary>
        /// Gets a collection of divisions accessible by the user.
        /// </summary>
        /// <param name="accessCode">
        /// The access code.
        /// </param>
        /// <returns>
        /// a collection of divisions accessible by the user
        /// </returns>
        public ObservableCollection<Division> GetDivisionList(string accessCode)
        {
            string resourcePath = "user/getDivisionList?accessCode=" + accessCode;
            return RestUtils.DoGetObject<ObservableCollection<Division>>(this.userServiceUrl, resourcePath);
        }

        /// <summary>
        /// Gets the welcome message.
        /// </summary>
        /// <returns>
        /// The welcome message string
        /// </returns>
        public string GetWelcomeMessage()
        {
            string welcomeMessage;

            try
            {
                string resourcePath = "public/getWelcomeMessage";
                welcomeMessage = RestUtils.DoGetString(this.userServiceUrl, resourcePath, false);
            }
            catch (Exception)
            {
                welcomeMessage = "Unable to retrieve welcome message from VistA...";
            }

            return welcomeMessage;
        }

        #endregion
    }
}