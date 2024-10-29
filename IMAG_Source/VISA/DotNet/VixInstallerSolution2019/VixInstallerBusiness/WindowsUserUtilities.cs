using System;
using System.Collections.Generic;
using System.Text;
using System.DirectoryServices;
using log4net;
using System.Security.Principal;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    [Flags]
    public enum AdsUserFlags
    {
        Script = 1,                  // 0x1
        AccountDisabled = 2,              // 0x2
        HomeDirectoryRequired = 8,           // 0x8 
        AccountLockedOut = 16,             // 0x10
        PasswordNotRequired = 32,           // 0x20
        PasswordCannotChange = 64,           // 0x40
        EncryptedTextPasswordAllowed = 128,      // 0x80
        TempDuplicateAccount = 256,          // 0x100
        NormalAccount = 512,              // 0x200
        InterDomainTrustAccount = 2048,        // 0x800
        WorkstationTrustAccount = 4096,        // 0x1000
        ServerTrustAccount = 8192,           // 0x2000
        PasswordDoesNotExpire = 65536,         // 0x10000
        MnsLogonAccount = 131072,           // 0x20000
        SmartCardRequired = 262144,          // 0x40000
        TrustedForDelegation = 524288,         // 0x80000
        AccountNotDelegated = 1048576,         // 0x100000
        UseDesKeyOnly = 2097152,            // 0x200000
        DontRequirePreauth = 4194304,          // 0x400000
        PasswordExpired = 8388608,           // 0x800000
        TrustedToAuthenticateForDelegation = 16777216, // 0x1000000
        NoAuthDataRequired = 33554432         // 0x2000000
    }
    
    public static class WindowsUserUtilities
    {
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(WindowsUserUtilities).Name);
        }

        public static bool LocalAccountExists(String accountName)
        {
            bool accountExists = true;

            String fullyQualifiedAccountName = Environment.MachineName + @"\" + accountName;
            NTAccount ntAccount = new NTAccount(fullyQualifiedAccountName);
            SecurityIdentifier sid = null;
            try
            {
                sid = (SecurityIdentifier)ntAccount.Translate(typeof(SecurityIdentifier));
            }
            catch (IdentityNotMappedException)
            {
                accountExists = false;
            }

            return accountExists;
        }


        /// <summary>
        /// Creates the service account.
        /// </summary>
        /// <param name="userName">Name of the user.</param>
        /// <param name="password">The password.</param>
        /// <param name="userDescription">The user description.</param>
        /// <returns></returns>
        /// <remarks></remarks>
        public static bool CreateServiceAccount(String userName, String password, String userDescription)
        {
            // TODO: add exception handling
            DirectoryEntry localServer = null;
            DirectoryEntry newUser = null;
            try
            {
                string localServerPath = "WinNT://" + Environment.MachineName + ",computer";
                localServer = new DirectoryEntry(localServerPath);
                newUser = localServer.Children.Add(userName, "User");
                newUser.Invoke("SetPassword", new object[] { password });
                newUser.Invoke("Put", new object[] { "Description", userDescription });
                AdsUserFlags userFlags = AdsUserFlags.NormalAccount | AdsUserFlags.PasswordCannotChange | AdsUserFlags.PasswordDoesNotExpire;
                newUser.Invoke("Put", new object[] { "UserFlags", userFlags });
                newUser.CommitChanges();
				
				// NOTE: VAI - 494 - the apachetomcat user in the above code, is added to Computer Management > Local Users and Groups > Users 
				// but not to Computer Management > Local Users and Groups > Groups > Users. Refer to the PowerShell script 
				// permission_fixer.ps1 (run as part of ViewerRenderConfigChecker.ps1) that sets the apachetomcat user at the 
				// Computer Management > Local Users and Groups > Groups level.
				
                ////if (config.VixRole == VixRoleType.DicomGateway) // add user to the users group
                ////{
                ////    DirectoryEntry group = null;
                ////    group = localServer.Children.Find("Users", "group");
                ////    group.Invoke("Add", new object[] { newUser.Path.ToString() });
                ////}
            }
            catch (Exception ex) // could not create the user
            {
                Logger().Error("Could not create user account. Exception is: " + ex.Message);
            }
            finally
            {
                localServer.Close();
                newUser.Close();
            }
            return LocalAccountExists(userName);
        }

        public static bool UpdateServiceAccountPassword(string userName, string newPassword)
        {
            DirectoryEntry localServer = null;
            DirectoryEntry userAccount = null;
            try
            {
                string localServerPath = "WinNT://" + Environment.MachineName + ",computer";
                localServer = new DirectoryEntry(localServerPath);
                userAccount = localServer.Children.Find(userName, "User");

                if (userAccount != null)
                {
                    userAccount.Invoke("SetPassword", new object[] { newPassword });
                    userAccount.CommitChanges();
                    return true;
                }
                else
                {
                    Logger().Error("User account not found.");
                }
            }
            catch (Exception ex)
            {
                Logger().Error("Could not update user account password. Exception is: " + ex.Message);
            }
            finally
            {
                localServer.Close();
                userAccount.Close();
            }

            return false;
        }

        public static bool DeleteServiceAccount(String userName)
        {
            DirectoryEntry localServer = null;
            try
            {
                string localServerPath = "WinNT://" + Environment.MachineName + ",computer";
                localServer = new DirectoryEntry(localServerPath);

                using (var userAccount = localServer.Children.Find(userName))
                {
                    localServer.Children.Remove(userAccount);
                }
            }
            catch (Exception ex) // could not delete the user
            {
                Logger().Error("Could not delete user account. Exception is: " + ex.Message);
            }
            finally
            {
                localServer.Close();
            }
            return (LocalAccountExists(userName) == false);
        }


    }
}
 
