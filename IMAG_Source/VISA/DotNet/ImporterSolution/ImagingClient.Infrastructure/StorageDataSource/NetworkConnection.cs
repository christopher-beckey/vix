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

namespace ImagingClient.Infrastructure.StorageDataSource
{
    using System;
    using System.IO;
    using System.Net;
    using System.Runtime.InteropServices;
    using System.Threading;

    using log4net;
    using Microsoft.Win32.SafeHandles;

    /// <summary>
    /// The resource scope.
    /// </summary>
    public enum ResourceScope
    {
        /// <summary>
        /// The connected.
        /// </summary>
        Connected = 1,

        /// <summary>
        /// The global network.
        /// </summary>
        GlobalNetwork,

        /// <summary>
        /// The remembered.
        /// </summary>
        Remembered,

        /// <summary>
        /// The recent.
        /// </summary>
        Recent,

        /// <summary>
        /// The context.
        /// </summary>
        Context
    }

    /// <summary>
    /// The resource type.
    /// </summary>
    public enum ResourceType
    {
        /// <summary>
        /// The any.
        /// </summary>
        Any = 0,

        /// <summary>
        /// The disk.
        /// </summary>
        Disk = 1,

        /// <summary>
        /// The print.
        /// </summary>
        Print = 2,

        /// <summary>
        /// The reserved.
        /// </summary>
        Reserved = 8,
    }

    /// <summary>
    /// The resource displaytype.
    /// </summary>
    public enum ResourceDisplaytype
    {
        /// <summary>
        /// The generic.
        /// </summary>
        Generic = 0x0,

        /// <summary>
        /// The domain.
        /// </summary>
        Domain = 0x01,

        /// <summary>
        /// The server.
        /// </summary>
        Server = 0x02,

        /// <summary>
        /// The share.
        /// </summary>
        Share = 0x03,

        /// <summary>
        /// The file.
        /// </summary>
        File = 0x04,

        /// <summary>
        /// The group.
        /// </summary>
        Group = 0x05,

        /// <summary>
        /// The network.
        /// </summary>
        Network = 0x06,

        /// <summary>
        /// The root.
        /// </summary>
        Root = 0x07,

        /// <summary>
        /// The shareadmin.
        /// </summary>
        Shareadmin = 0x08,

        /// <summary>
        /// The directory.
        /// </summary>
        Directory = 0x09,

        /// <summary>
        /// The tree.
        /// </summary>
        Tree = 0x0a,

        /// <summary>
        /// The ndscontainer.
        /// </summary>
        Ndscontainer = 0x0b
    }

    /// <summary>
    /// The network connection.
    /// </summary>
    public class NetworkConnection : IDisposable
    {
        #region Constants and Fields

        /// <summary>
        /// The max attempts.
        /// </summary>
        private const int MaxAttempts = 5;

        /// <summary>
        /// The sleep duration millis.
        /// </summary>
        private const int SleepDurationMillis = 500;

        /// <summary>
        /// The logger.
        /// </summary>
        private static readonly ILog Logger = LogManager.GetLogger(typeof(NetworkConnection));

        /// <summary>
        /// The _network name.
        /// </summary>
        private readonly string networkName;

        //BEGIN-Fortify Mitigation recommendation for Unsafe Native Invoke. Added this bool property to handle Imporper use of P/Invoke can render managed applications vulnerable to security flaws.(p289-OITCOPondiS)
        //private bool isDisposed;       
        

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="NetworkConnection"/> class.
        /// </summary>
        /// <param name="networkName">
        /// The network name.
        /// </param>
        /// <param name="credentials">
        /// The credentials.
        /// </param>
        /// <exception cref="IOException">
        /// Can return IO Exception
        /// </exception>
        private NetworkConnection(string networkName, NetworkCredential credentials)
        {
            int result = 0;
            this.networkName = networkName;

            if (this.networkName.EndsWith("\\"))
            {
                this.networkName = this.networkName.Substring(0, this.networkName.Length - 1);
            }

            var netResource = new NetResource
            {
                Scope = ResourceScope.GlobalNetwork,
                ResourceType = ResourceType.Disk,
                DisplayType = ResourceDisplaytype.Share,
                RemoteName = this.networkName
            };

            //BEGIN-Fortify Mitigation recommendation for Unsafe Native Invoke. Added try/catch error handling when calling third party dll to capture any failed scenario on other end.(p289-OITCOPondiS)
            try
            {
                Logger.Info("Trying to establish WNetAddConnection2");
                result = NativeMethods.WNetAddConnection2(netResource, credentials.Password, credentials.UserName, 0);
                //this.Dispose();                
                Logger.Info("WNetAddConnection2 add is completed");
            }
            catch(Exception oException)
            {
                Logger.Error("WNetAddConnection2 returned a failure code of: " + oException);
                //this.Dispose();
            }
            //END

            if (result != 0)
            {
                Logger.Error("WNetAddConnection2 returned a failure code of: " + result);
                throw new IOException("Error connecting to remote share: ErrorCode(" + result.ToString() + ")");
            }
        }

        /// <summary>
        /// Finalizes an instance of the <see cref="NetworkConnection"/> class. 
        /// </summary>
        ~NetworkConnection()
        {
            this.Dispose(false);
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// The get network connection.
        /// </summary>
        /// <param name="networkName">
        /// The network name.
        /// </param>
        /// <param name="credentials">
        /// The credentials.
        /// </param>
        /// <returns>
        /// Returns a network connection
        /// </returns>
        public static NetworkConnection GetNetworkConnection(string networkName, NetworkCredential credentials)
        {

            // First, try to get a connection using the host name.
            NetworkConnection conn = GetConnection(networkName, credentials);

            // If that failed (connection is null), try using the ip address
            if (conn==null)
            {
                conn = GetConnection(ConvertHostnameToIpAddress(networkName), credentials); 
            }

            // The network connection may still be null, but return whatever we have
            return conn;
        }

        private static NetworkConnection GetConnection(string networkName, NetworkCredential credentials)
        {
            NetworkConnection conn = null;

            int attemptCount = 1;
            while (true)
            {
                try
                {
                    //Commented for (p289-OITCOPondiS)
                    //Logger.Debug("Attempting to connect to " + networkName);
                    //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.Logged other details without by passing the actual issue reported by tool.(p289-OITCOPondiS)
                    Logger.Debug("Attempting to connect to network");
                    Logger.Debug("Attempting to connect to " + ImagingClient.Infrastructure.Utilities.PathUtilities.ValidateWindowsFileName(networkName));
                    //END
                    conn = new NetworkConnection(networkName, credentials);
                    return conn;
                }
                catch (Exception e)
                {
                    if (attemptCount <= MaxAttempts)
                    {
                        // Increment the attempt count and sleep for a short period
                        attemptCount++;
                        Thread.Sleep(SleepDurationMillis);
                    }
                    else
                    {
                        // We're unable to connect, but it may be because we're already connected,
                        // so don't throw an error.
                        Logger.Error("Unable to connect to '" + networkName + "' with username='" + credentials.UserName + "'", e);
                        return conn;
                    }
                }
            }
        }

        public static string ConvertHostnameToIpAddress(string shareUsingHostname)
        {

            // Start out with what was passed in. If we can't convert it, we'll just return 
            // the original value and let it try with that...
            string shareUsingIpAddress = shareUsingHostname;

            try
            {
                // First, strip off the leading \\ 
                shareUsingHostname = shareUsingHostname.Substring(2);

                // Get the hostName
                string hostName = shareUsingHostname.Substring(0, shareUsingHostname.IndexOf("\\"));

                // Get the share part...
                string shareName = shareUsingHostname.Substring(shareUsingHostname.IndexOf("\\") + 1);

                // Now that we have the hostName, try to get its IP Address
                // Initialize the ipAddress to empty string
                string ipAddress = string.Empty;
            /*
             Gary Pham (oitlonphamg) (based on secondary code review meeting)
             P332 - Will clean up code once code is deployed to the IOC tested success.
             Removed the code below.
            IPAddress[] addressList = Dns.GetHostAddresses(hostName);

            if (addressList.Length > 0)
             {
                 ipAddress = addressList[0].ToString();
             }

            // If we got an ipAddress, rebuild the full share path using ip address
             shareUsingIpAddress = "\\\\" + ipAddress + "\\" + shareName;
            */
            /*
            Gary Pham (oitlonphamg)
            P332
            New code
            Confirm hostname and ipaddress dns lookup results have the same ipaddress. (Fortify software scan issue)
            */
            //Begin - New code added by Gary Pham
            IPHostEntry ipHostEntryHostname = Dns.GetHostEntry(hostName);

               if (ipHostEntryHostname.AddressList.Length > 0)
               {
                  IPHostEntry ipHostEntryIPAddress = Dns.GetHostEntry(ipHostEntryHostname.AddressList[0].ToString());

                  if (ipHostEntryIPAddress.AddressList.Length > 0 &&
                      ipHostEntryHostname.AddressList[0].ToString() == ipHostEntryIPAddress.AddressList[0].ToString())
                  {
                     ipAddress = ipHostEntryHostname.AddressList[0].ToString();
                     // If we got an ipAddress, rebuild the full share path using ip address
                     shareUsingIpAddress = "\\\\" + ipAddress + "\\" + shareName;
                  }
               }

               //End - New code added by Gary Pham
            }
            catch (Exception e)
            {
                //BEGIN-Fortify Mitigation recommendation for Log Forging.Code writes unvalidated user input to the log.Logged other details without by passing the actual issue reported by tool.(p289-OITCOPondiS)
                Logger.Error("Unable to convert from host name to IP address: " , e);
                //Logger.Error("Unable to convert from host name to IP address: " + shareUsingHostname, e);
                //END
            }

            return shareUsingIpAddress;
        }


        /// <summary>
        /// The dispose.
        /// </summary>
        public void Dispose()
        {
            this.Dispose(true);
            GC.SuppressFinalize(this);
        }

        #endregion

        #region Methods

        /// <summary>
        /// The dispose.
        /// </summary>
        /// <param name="disposing">
        /// The disposing.
        /// </param>
        protected virtual void Dispose(bool disposing)
        {
            //Commented for (p289-OITCOPondiS)
            //WNetCancelConnection2(this.networkName, 0, true);

            //BEGIN-Fortify Mitigation recommendation for Unsafe Native Invoke. Added try/catch error handling when calling third party dll to capture any failed scenario on other end.(p289-OITCOPondiS)
            try
            {
            //if (isDisposed)
            //     return;
            // if (disposing)
            // {
            //     // Free any other managed objects here.  
            //     Logger.Info("Trying to dispose WNetAddConnection2");
            //     WNetCancelConnection2(this.networkName, 0, true);
            //     Logger.Info("WNetAddConnection2 cancellation is completed");
            // }

            // // Free any unmanaged objects here.  
            // isDisposed = true;
            NativeMethods.WNetCancelConnection2(this.networkName, 0, true);
            }
            catch (Exception oException)
            {
                Logger.Error("WNetAddConnection2 cancellation returns: " + oException);
                //this.Dispose();
            }
            //END
        }

        #endregion
    }

   /// <summary>
   /// Gary Pham (oitlonphamg) (based on secondary code review meeting)
   /// P332
   /// Declare native functions from library in static class specific to only this file. (Fortify software scan issue)
   /// </summary>
   internal static class NativeMethods
   {
      /// <summary>
      /// Creates a connection.
      /// </summary>
      /// <param name="netResource">The net resource.</param>
      /// <param name="password">The password.</param>
      /// <param name="username">The username.</param>
      /// <param name="flags">The flags.</param>
      /// <returns>Error code</returns>
      [DllImport("mpr.dll")]
      internal static extern int WNetAddConnection2(NetResource netResource, string password, string username, int flags);

      /// <summary>
      /// Cancels a connection.
      /// </summary>
      /// <param name="name">The name.</param>
      /// <param name="flags">The flags.</param>
      /// <param name="force">if set to <c>true</c> [force].</param>
      /// <returns>Error code</returns>
      [DllImport("mpr.dll")]
      internal static extern int WNetCancelConnection2(string name, int flags, bool force);
   }
}