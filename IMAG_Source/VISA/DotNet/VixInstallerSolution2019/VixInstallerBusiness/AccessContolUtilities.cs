using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Security.Principal;
using System.Security.AccessControl;
using System.Diagnostics;
using log4net;
using System.DirectoryServices.AccountManagement;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public static class AccessContolUtilities
    {
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(AccessContolUtilities).Name);
        }
           
        public static void SetFullDirectoryAccessControl(String accountName, String directory)
        {
            Debug.Assert(accountName != null);
            Debug.Assert(directory != null);
            Debug.Assert(Directory.Exists(directory));
            String fullyQualifiedAccountName = Environment.MachineName + @"\" + accountName;
            NTAccount ntAccount = new NTAccount(fullyQualifiedAccountName);
            FileSystemRights rights = FileSystemRights.FullControl;
            InheritanceFlags inheritance = InheritanceFlags.ContainerInherit | InheritanceFlags.ObjectInherit;
            PropagationFlags propagate = PropagationFlags.None; // this folder, subfolders, and files
            FileSystemAccessRule ace = null;

            ace = GetInheritedDirectoryAceForAccount(accountName, directory);
            if (ace != null) // sever relationship with parent directory if necessary
            {
                DisableAclInheritance(accountName, directory); // copies inherited ACE to explicit ACE
                //EnsureAcesAreCanonical(directory); // ocasionally, they are not after the inheritance is severed
                ace = GetExplicitDirectoryAceForAccount(accountName, directory);
                Debug.Assert(ace != null);
                DeleteAccountExplicitAce(directory, ntAccount);
                Logger().Info("Directory access control inheritance severed for " + directory + ".");
            }
            else
            {
                Logger().Info("Directory access control inheritance already severed for " + directory + ".");
            }

            ace = GetExplicitDirectoryAceForAccount(accountName, directory);
            if (ace == null) // dont overwrite
            {
                // build the ACE that will grant accountName privleges in the directory sub tree
                ace = new FileSystemAccessRule(ntAccount, rights, inheritance, propagate, AccessControlType.Allow);
                // apply the new ACE
                ApplyAceToDirectory(ace, directory);
                Logger().Info("Directory access control applied for " + directory + ".");
            }
            else
            {
                Logger().Info("Directory access control already exists for " + directory + ".");
            }
        }

        public static void Tester()
        {
            //FileSystemAccessRule rootExplicit = GetExplicitDirectoryAceForAccount("apachetomcat", @"c:\");
            //FileSystemAccessRule rootInherit = GetInheritedDirectoryAceForAccount("apachetomcat", @"c:\");
            //FileSystemAccessRule dcfExplicit = GetExplicitDirectoryAceForAccount("apachetomcat", @"c:\dcf");
            //FileSystemAccessRule dcfInherit = GetInheritedDirectoryAceForAccount("apachetomcat", @"c:\dcf");
            //FileSystemAccessRule javaExplicit = GetExplicitDirectoryAceForAccount("apachetomcat", @"C:\Program Files\Java\jdk1.5.0_07\jre");
            //FileSystemAccessRule javaInherit = GetInheritedDirectoryAceForAccount("apachetomcat", @"C:\Program Files\Java\jdk1.5.0_07\jre");
            //FileSystemAccessRule vixExplicit = GetExplicitDirectoryAceForAccount("apachetomcat", @"C:\ViX");
            //FileSystemAccessRule vixInherit = GetInheritedDirectoryAceForAccount("apachetomcat", @"C:\ViX");
            //FileSystemAccessRule installExplicit = GetExplicitDirectoryAceForAccount("apachetomcat", @"c:\install");
            //FileSystemAccessRule installInherit = GetInheritedDirectoryAceForAccount("apachetomcat", @"c:\install");
            //FileSystemAccessRule tomcatExplicit = GetExplicitDirectoryAceForAccount("apachetomcat", @"C:\Program Files\Apache Software Foundation\Tomcat 5.5");
            //FileSystemAccessRule tomcatInherit = GetInheritedDirectoryAceForAccount("apachetomcat", @"C:\Program Files\Apache Software Foundation\Tomcat 5.5");
            //FileSystemAccessRule tomcatServerExplicit = GetExplicitDirectoryAceForAccount("apachetomcat", @"C:\Program Files\Apache Software Foundation\Tomcat 5.5\server");
            //FileSystemAccessRule tomcatServerInherit = GetInheritedDirectoryAceForAccount("apachetomcat", @"C:\Program Files\Apache Software Foundation\Tomcat 5.5\server");
            //AccessContolUtilities.SetVixDirectoryAccessControl("apachetomcat", @"c:\ViX");
        }

        #region private methods

        private static FileSystemAccessRule GetExplicitDirectoryAceForAccount(String accountName, String directory)
        {
            return GetDirectoryAceForAccountHelper(accountName, directory, true, false);
        }

        private static FileSystemAccessRule GetInheritedDirectoryAceForAccount(String accountName, String directory)
        {
            return GetDirectoryAceForAccountHelper(accountName, directory, false, true);
        }

        private static void EnsureAcesAreCanonical(String directory)
        {
            Debug.Assert(directory != null);
            Debug.Assert(Directory.Exists(directory));

            DirectorySecurity sd = Directory.GetAccessControl(directory, AccessControlSections.Access);
            if (!sd.AreAccessRulesCanonical)
            {
                Logger().Info(directory + " access rules are not in canonical order - correcting");
                // put the existing aces in canonical order
                AuthorizationRuleCollection aces = sd.GetAccessRules(true, false, typeof(NTAccount)); // explicit aces only
                DirectorySecurity canonicalOrder = new DirectorySecurity();
                foreach (FileSystemAccessRule ace in aces)
                {
                    canonicalOrder.AddAccessRule(ace);
                }
                Directory.SetAccessControl(directory, canonicalOrder);
                sd = Directory.GetAccessControl(directory, AccessControlSections.Access);
                Debug.Assert(sd.AreAccessRulesCanonical);
            }
        }
        
        private static FileSystemAccessRule GetDirectoryAceForAccountHelper(String accountName, String directory, bool includeExplicit, bool includeInherited)
        {
            FileSystemAccessRule accountAce = null;
            int aceCount = 0;
            Debug.Assert(accountName != null);
            Debug.Assert(directory != null);
            Debug.Assert(Directory.Exists(directory));
            String fullyQualifiedAccountName = Environment.MachineName + @"\" + accountName;
            Logger().Info("Account Name: " + fullyQualifiedAccountName);
            NTAccount ntAccount = new NTAccount(fullyQualifiedAccountName);
            SecurityIdentifier ntAccountSid = (SecurityIdentifier)ntAccount.Translate(typeof(SecurityIdentifier));
            //SecurityIdentifier ntAccountSid = new SecurityIdentifier(WellKnownSidType.AuthenticatedUserSid, null);
            
            Logger().Info("Security ID for apachetomcat: " + ntAccountSid.ToString());
            Debug.Assert(ntAccountSid.IsAccountSid());

            DirectorySecurity sd = Directory.GetAccessControl(directory, AccessControlSections.Access);
            AuthorizationRuleCollection aces = sd.GetAccessRules(includeExplicit, includeInherited, typeof(NTAccount));

            Logger().Info("available aces count: " + aces.Count);

            foreach (FileSystemAccessRule ace in aces)
            {
                if (aces.Count == 1)
                {
                    Logger().Info("- found ace! -");
                    accountAce = ace;
                    aceCount++;
                }
                else
                {
                    SecurityIdentifier aceSid = (SecurityIdentifier)ace.IdentityReference.Translate(typeof(SecurityIdentifier));
                    Logger().Info("IsAccountSid: " + aceSid.IsAccountSid());

                    if (!aceSid.IsAccountSid())
                    {
                        continue;
                    }

                    if (aceSid == ntAccountSid)
                    {
                        Logger().Info("* found ace! *");
                        accountAce = ace;
                        aceCount++;
                        break;
                    }
                }
            }

            Logger().Info("found aces count: " + aceCount);
            
            return accountAce;
        }

        private static void ApplyAceToDirectory(FileSystemAccessRule ace, String directory)
        {
            DirectorySecurity sd = Directory.GetAccessControl(directory);
            sd.AddAccessRule(ace);
            Directory.SetAccessControl(directory, sd);
        }

        private static void DisableAclInheritance(String accountName, String directory)
        {
            Debug.Assert(directory != null);
            Debug.Assert(Directory.Exists(directory));
            // break ACL inheritance with parent folder
            DirectorySecurity sd = Directory.GetAccessControl(directory);
            AuthorizationRuleCollection aces = sd.GetAccessRules(true, false, typeof(NTAccount));
            foreach (FileSystemAccessRule ace in aces)
            {
                sd.RemoveAccessRule(ace);
            }
            sd.SetAccessRuleProtection(true, true);
            Directory.SetAccessControl(directory, sd);
            EnsureAcesAreCanonical(directory); // ocasionally, they are not after the inheritance is severed
        }

        private static void DeleteAccountExplicitAce(String directory, NTAccount ntAccount)
        {
            Debug.Assert(directory != null);
            Debug.Assert(Directory.Exists(directory));
            DirectorySecurity sd = Directory.GetAccessControl(directory);
            sd.PurgeAccessRules(ntAccount);
            Directory.SetAccessControl(directory, sd);
        }


        #endregion

        #region deprecated
        private static void DeprecatedSetDcfDirectoryAccessControl(String accountName, String directory)
        {
            Debug.Assert(accountName != null);
            Debug.Assert(directory != null);
            String fullyQualifiedAccountName = Environment.MachineName + @"\" + accountName;
            NTAccount ntAccount = new NTAccount(fullyQualifiedAccountName);
            //            SecurityIdentifier sid = (SecurityIdentifier)ntAccount.Translate(typeof(SecurityIdentifier));

            // break ACL inheritance with parent folder
            DirectorySecurity sd = Directory.GetAccessControl(directory);
            sd.SetAccessRuleProtection(true, true); // break ACL inheritance, copy current permissions obtained from partent folder            
            Directory.SetAccessControl(directory, sd);

            // TODO: add exception handling
            // TODO: perform dcfDirectory integrity checks

            // build the ACE that will grant accountName privleges in the directory sub tree
            FileSystemRights rights = FileSystemRights.Traverse | FileSystemRights.ListDirectory | FileSystemRights.ReadAttributes |
                FileSystemRights.CreateFiles | FileSystemRights.CreateDirectories | FileSystemRights.WriteAttributes |
                FileSystemRights.WriteExtendedAttributes | FileSystemRights.DeleteSubdirectoriesAndFiles | FileSystemRights.Delete |
                FileSystemRights.ReadPermissions | FileSystemRights.ReadExtendedAttributes;
            InheritanceFlags inheritance = InheritanceFlags.ContainerInherit | InheritanceFlags.ObjectInherit;
            PropagationFlags propagate = PropagationFlags.None; // this folder, subfolders, and files
            FileSystemAccessRule ace = new FileSystemAccessRule(ntAccount, rights, inheritance, propagate, AccessControlType.Allow);

            // remove any existing ACEs for accountName then apply the new ACE
            sd = Directory.GetAccessControl(directory); // refresh
            sd.PurgeAccessRules(ntAccount);
            sd.AddAccessRule(ace);
            Directory.SetAccessControl(directory, sd);
        }

        public static bool IsUserExist(string user)
        {

            using (PrincipalContext pc = new PrincipalContext(ContextType.Machine))
            {
                UserPrincipal up = UserPrincipal.FindByIdentity(
                    pc,
                    IdentityType.SamAccountName,
                    user);

                return (up != null);
            }
        }


        public static bool IsUserTomcatDirectoryAccessControl(String accountName, String directory)
        {
            bool result = false;

            if (Directory.Exists(directory))
            {
                FileSystemAccessRule ace = GetExplicitDirectoryAceForAccount(accountName, directory);
                result = (((ace.FileSystemRights & FileSystemRights.WriteData) > 0) && (ace.AccessControlType != AccessControlType.Deny));
            }

            return result;
        }


        public static bool DeleteUserAccount(string user)
        {
            // Creating the PrincipalContext
            PrincipalContext principalContext = null;
            try
            {
                principalContext = new PrincipalContext(ContextType.Machine);
            }
            catch (Exception e)
            {
                return false;
            }

            //Deleting the user account
            bool bReturn = false;
            UserPrincipal userPrincipal = UserPrincipal.FindByIdentity(principalContext, user);

            if (userPrincipal != null)
            {
                try
                {
                    userPrincipal.Delete();
                    bReturn = true;
                }
                catch (Exception e)
                {
                    return false;
                }
            }

            return bReturn;
        }


        #endregion
    }
}
