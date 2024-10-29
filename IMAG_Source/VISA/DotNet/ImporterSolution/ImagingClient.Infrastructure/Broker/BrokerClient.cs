// -----------------------------------------------------------------------
// <copyright file="PathologyAcquisitionSiteType.cs" company="Department of Veterans Affairs">
//  Package: MAG - VistA Imaging
//  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//  Date Created: Jan 2012
//  Site Name:  Washington OI Field Office, Silver Spring, MD
//  Developer: Paul Pentapaty, Duc Nguyen
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

namespace ImagingClient.Infrastructure.Broker
{
    using System;
    using System.ComponentModel;
    using System.Collections.Generic;
    using System.Collections.ObjectModel;
    using System.Configuration;
    using System.Text.RegularExpressions;
    using Microsoft.Practices.Prism.Events;
    using Microsoft.Practices.ServiceLocation;
    using log4net;
    using ImagingClient.Infrastructure.Commands;
    using ImagingClient.Infrastructure.Events;
    using ImagingClient.Infrastructure.Model;
    using ImagingClient.Infrastructure.User.Model;
    using ImagingClient.Infrastructure.UserDataSource;
    using VistaCommon;

    public class BrokerClient
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(BrokerClient));

        private Client client = new Client();

        private IUserDataSource userDataSource = new UserDataSource();

        public BrokerClient()
        {
        }

        public bool AuthenticateUser()
        {
            Log.Info("Authenticating...");

            // Put an initial version of the UserCredential object in context.
            // It will be replaced with the full version upon successful login
            UserContext.UserCredentials = new UserCredentials();
            UserContext.IsLoginSuccessful = false;

            //client.ApplicationLabel = ConfigurationManager.AppSettings["ApplicationLabel"];
            //client.PassCode = ConfigurationManager.AppSettings["Passcode"];

            if (client.Connect() != null)
            {
                UserContext.IsLoginSuccessful = true;
                UserContext.LoginErrorMessage = string.Empty;
                UserContext.ServerName = this.ServerName;
                UserContext.ServerPort = this.ServerPort.ToString();

                //Not all values are present in the client object, some need to be set with InitializeUserContext
                //This may not even be necessary here...review at a later date
                UserContext.UserCredentials.Fullname = client.CurrentConnection.UserName;
                UserContext.UserCredentials.Duz = client.CurrentConnection.UserDUZ;
                UserContext.UserCredentials.Ssn = client.CurrentConnection.UserSSN;
                UserContext.UserCredentials.SiteName = client.CurrentConnection.SiteName;
                UserContext.StationNumber = UserContext.UserCredentials.SiteNumber = client.CurrentConnection.Division;

                try
                {
                    Log.Info("Initializing broker connection...");

                    this.SetApplicationContext();

                    this.UpdateSecurityToken();

                    this.InitializeUserContext();

                    //this.GetMagSecurityKeys();

                    userDataSource.AuthenticateBseUser();

                    Log.Info("Broker connection initialized succesfully.");
                }
                catch (Exception ex)
                {
                    string msg = "Broker initialization failed.";
                    Log.Error(msg, ex);
                    throw ex;
                }

                ApplicationTimeoutParameters parameters = userDataSource.GetApplicationTimeout();

                if (parameters != null)
                {
                    UserContext.SecondsIdleLogout = parameters.TimeoutInSeconds;
                }
                else
                {
                    UserContext.SecondsIdleLogout = 0;
                }

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
                //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.Logged other details without by passing the actual issue reported by tool.(p289-OITCOPondiS)
                //Log.Info(UserContext.UserCredentials.Fullname + " access is verified.");
                if(client != null && client.CurrentConnection != null)
                {
                    Log.Info(client.CurrentConnection.UserName + " access is verified.");
                    Log.Info("UserDUZ: " + client.CurrentConnection.UserDUZ);
                    //Log.Info("UserSSN: " + client.CurrentConnection.UserSSN);
                    Log.Info("SiteName: " + client.CurrentConnection.SiteName);
                    Log.Info("Division: " + client.CurrentConnection.Division);
                }                
                //END
                return true;
            }

            return false;
        }

        public void Close()
        {
            if (this.client != null)
            {
                this.client.Close();
                UserContext.ResetUserContext();
            }
        }
        
        public void UpdateSecurityToken()
        {
            if (client.CurrentConnection != null)
            {
                Log.Debug("Calling RPC: MAG BROKER SECURITY.");
                
                Response response = client.CurrentConnection.Execute(new Request { MethodName = "MAG BROKER SECURITY" });

                if ((response == null) || (response.RawData == null))
                {
                    string message = "Failed to establish broker security. " +
                                     "ERR: Receive no response from VistA: response = null.";
                    throw new Exception(message);
                }
                else
                {
                    UserContext.UserCredentials.SecurityToken = response.RawData;
                        //string.Format("{0}^{1}^{2}^{3}",
                        //              "IMPORTER",
                        //              response.RawData,
                        //              client.CurrentConnection.SiteNumber,
                        //              client.CurrentConnection.Port);
                }
            }
            else
            {
                throw new Exception("Failed to establish broker security. ERR: There is no current connection.");
            }
        }

        public void SetApplicationContext()
        {
            if (client.CurrentConnection != null)
            {
                Log.Debug("Calling RPC: XWB CREATE CONTEXT.");
                
                Response response = client.CurrentConnection.Execute(new Request { MethodName = "XWB CREATE CONTEXT" }.AddParameter("'#0zg+q>@{S5,Ngq#z{0"));
                if ((response == null) || (response.RawData == null))
                {
                    string message = "Failed to create application context. " +
                                     "ERR: Receive no response from VistA: response = null.";
                    throw new Exception(message);
                }
                else
                {
                    if (response.RawData != "1")
                    {
                        throw new Exception("Failed to create application context. ERR: " + response.RawData);
                    }
                }
            }
            else
            {
                throw new Exception("Failed to create application context. ERR: There is no current connection.");
            }
        }

        public void GetMagSecurityKeys()
        {
            if (client.CurrentConnection != null)
            {
                Log.Debug("Calling RPC: MAGGUSERKEYS.");
                try
                {
                    Response response = client.CurrentConnection.Execute(new Request { MethodName = "MAGGUSERKEYS" });
                    if ((response == null) || (response.RawData == null))
                    {
                        string message = "Failed to retrieve user security keys. " +
                                     "ERR: Receive no response from VistA: response = null.";
                        throw new Exception(message);
                    }
                    else
                    {
                        Log.Debug(string.Format("MAG Keys:" + Environment.NewLine + "{0}", response.RawData));
                        if (!string.IsNullOrWhiteSpace(response.RawData))
                        {
                            string[] keys = Regex.Split(response.RawData, Environment.NewLine);
                            if (keys != null)
                            {
                                if (UserContext.UserCredentials.SecurityKeys == null)
                                {
                                    UserContext.UserCredentials.SecurityKeys = new List<string>();
                                }

                                foreach (string key in keys)
                                {
                                    UserContext.UserCredentials.SecurityKeys.Add(key);
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    Log.Error("Failed to retrieve user security keys.", ex);
                }
            }
        }

        public string ServerName
        {
            get
            {
                return (client.CurrentConnection != null) ? client.CurrentConnection.Server : "Error";
            }
        }

        public int ServerPort
        {
            get
            {
                return (client.CurrentConnection != null) ? client.CurrentConnection.Port : 0;
            }
        }

        /// <summary>
        /// Initializes the user context at the local site
        /// </summary>
        public void InitializeUserContext()
        {
            if (client.CurrentConnection != null)
            {
                Log.Debug("Calling RPC: MAGTP USER.");
                
                Response response = client.CurrentConnection.Execute(new Request { MethodName = "MAGTP USER" });
                if ((response == null) || (response.RawData == null))
                {
                    string message = "Failed to initialize user context. " +
                                     "ERR: Receive no response from VistA: response = null.";
                    throw new Exception(message);
                }
                else
                {
                    ResponseParser.ParseGetUserResponse(response.RawData);
                }
            }
            else
            {
                throw new Exception("Failed to initialize user context. ERR: There is no current connection.");
            }
        }

        public int GetApplicationTimeout()
        {
            Log.Debug("Calling RPC: MAGG GET TIMEOUT.");

            if (client.CurrentConnection != null)
            {
                Response response = client.CurrentConnection.Execute(new Request { MethodName = "MAGG GET TIMEOUT" }.AddParameter("TELEPATHOLOGY"));
                if ((response == null) || (response.RawData == null))
                {
                    Log.Error("Received no reponse.");
                    return -1; 
                }
                else
                {
                    int result = ResponseParser.ParseGetApplicationTimeout(response.RawData);
                    return result;
                }
            }
            else
            {
                Log.Error("There is no connection.");
                return 0;
            }
        }

        public void SetApplicationTimeout(int duration)
        {
            Log.Debug("Calling RPC: MAG3 SET TIMEOUT.");

            if (client.CurrentConnection != null)
            {
                Response response = client.CurrentConnection.Execute(new Request { MethodName = "MAG3 SET TIMEOUT" }.AddParameter("TELEPATHOLOGY").AddParameter(duration.ToString()));
                if ((response == null) || (response.RawData == null))
                {
                    throw new Exception("Receive no response from Vista: response = null");
                }
                else
                {
                    bool result = ResponseParser.ParseSetApplicationTimeout(response.RawData);
                    if (!result)
                    {
                        throw new Exception("Failed to set application timeout.");
                    }
                }
            }
            else
            {
                throw new Exception("There is no connection.");
            }
        }
    }
}
