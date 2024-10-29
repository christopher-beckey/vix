using System;
using System.Collections.Generic;
using System.Text;
using System.Runtime.InteropServices;
using log4net;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    #region interop_data
    [StructLayout(LayoutKind.Sequential)]
    public struct LSA_UNICODE_STRING
    {
        public UInt16 Length;
        public UInt16 MaximumLength;
        public IntPtr Buffer;
    }

    [StructLayout(LayoutKind.Sequential)]
    public struct LSA_OBJECT_ATTRIBUTES
    {
        public int Length;
        public IntPtr RootDirectory;
        public LSA_UNICODE_STRING ObjectName;
        public UInt32 Attributes;
        public IntPtr SecurityDescriptor;
        public IntPtr SecurityQualityOfService;
    }

    // enum all policies

    public enum LSA_AccessPolicy : long
    {
        POLICY_VIEW_LOCAL_INFORMATION = 0x00000001L,
        POLICY_VIEW_AUDIT_INFORMATION = 0x00000002L,
        POLICY_GET_PRIVATE_INFORMATION = 0x00000004L,
        POLICY_TRUST_ADMIN = 0x00000008L,
        POLICY_CREATE_ACCOUNT = 0x00000010L,
        POLICY_CREATE_SECRET = 0x00000020L,
        POLICY_CREATE_PRIVILEGE = 0x00000040L,
        POLICY_SET_DEFAULT_QUOTA_LIMITS = 0x00000080L,
        POLICY_SET_AUDIT_REQUIREMENTS = 0x00000100L,
        POLICY_AUDIT_LOG_ADMIN = 0x00000200L,
        POLICY_SERVER_ADMIN = 0x00000400L,
        POLICY_LOOKUP_NAMES = 0x00000800L,
        POLICY_NOTIFICATION = 0x00001000L
    }
    #endregion interop_data

    public static class LsaUtilities
    {
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(LsaUtilities).Name);
        }

        private const String seNetworkLogonRight = "SeNetworkLogonRight";
        private const String seInteractiveLogonRight = "SeInteractiveLogonRight";
        private const String seBatchLogonRight = "SeBatchLogonRight";
        private const String seServiceLogonRight = "SeServiceLogonRight";
        private const String seRemoteInteractiveLogonRight = "SeRemoteInteractiveLogonRight";
        private const String seDenyNetworkLogonRight = "SeDenyNetworkLogonRight";
        private const String seDenyInteractiveLogonRight = "SeDenyInteractiveLogonRight";
        private const String seDenyBatchLogonRight = "SeDenyBatchLogonRight";
        private const String seDenyServiceLogonRight = "SeDenyServiceLogonRight";
        private const String seDenyRemoteInteractiveLogonRight = "SeDenyRemoteInteractiveLogonRight";

        // Import the LSA functions

        #region interop_methods
        [DllImport("advapi32.dll", PreserveSig = true)]
        private static extern UInt32 LsaOpenPolicy(
            ref LSA_UNICODE_STRING SystemName,
            ref LSA_OBJECT_ATTRIBUTES ObjectAttributes,
            Int32 DesiredAccess,
            out IntPtr PolicyHandle
        );


        [DllImport("advapi32.dll", SetLastError = true, PreserveSig = true)]
        static extern uint LsaAddAccountRights(
           IntPtr PolicyHandle,
           IntPtr AccountSid,
           LSA_UNICODE_STRING[] UserRights,
           uint CountOfRights);
        
        [DllImport("advapi32")]
        private static extern void FreeSid(IntPtr pSid);

        [DllImport("advapi32.dll", CharSet = CharSet.Auto, SetLastError = true, PreserveSig = true)]
        private static extern bool LookupAccountName(
            string lpSystemName, string lpAccountName,
            IntPtr psid,
            ref int cbsid,
            StringBuilder domainName, ref int cbdomainLength, ref int use);

        [DllImport("advapi32.dll")]
        private static extern bool IsValidSid(IntPtr pSid);

        [DllImport("advapi32.dll")]
        private static extern long LsaClose(IntPtr ObjectHandle);

        [DllImport("kernel32.dll")]
        private static extern int GetLastError();

        [DllImport("advapi32.dll")]
        private static extern uint LsaNtStatusToWinError(uint status);
        #endregion interop_methods

        public static void SetServiceAccountPrivleges(String accountName)
        {
            // 
            SetRight(accountName, seDenyInteractiveLogonRight);
            SetRight(accountName, seDenyNetworkLogonRight);
            SetRight(accountName, seDenyBatchLogonRight);
            SetRight(accountName, seServiceLogonRight);
            // TODO: if terminal services not installed will this cause problems?
            SetRight(accountName, seDenyRemoteInteractiveLogonRight);
        }

        /// <summary>Adds a privilege to an account</summary>
        /// <param name="accountName">Name of an account - "domain\account" or only "account"</param>
        /// <param name="privilegeName">Name ofthe privilege</param>
        /// <returns>The windows error code returned by LsaAddAccountRights</returns>
        private static long SetRight(String accountName, String privilegeName)
        {
            long winErrorCode = 0; //contains the last error

            //pointer an size for the SID
            IntPtr sid = IntPtr.Zero;
            int sidSize = 0;
            //StringBuilder and size for the domain name
            StringBuilder domainName = new StringBuilder();
            int nameSize = 0;
            //account-type variable for lookup
            int accountType = 0;

            //get required buffer size
            LookupAccountName(String.Empty, accountName, sid, ref sidSize, domainName, ref nameSize, ref accountType);

            //allocate buffers
            domainName = new StringBuilder(nameSize);
            sid = Marshal.AllocHGlobal(sidSize);

            //lookup the SID for the account
            bool result = LookupAccountName(String.Empty, accountName, sid, ref sidSize, domainName, ref nameSize, ref accountType);

            //say what you're doing
            Console.WriteLine("LookupAccountName result = " + result);
            Console.WriteLine("IsValidSid: " + IsValidSid(sid));
            Console.WriteLine("LookupAccountName domainName: " + domainName.ToString());

            if (!result)
            {
                winErrorCode = GetLastError();
                Console.WriteLine("LookupAccountName failed: " + winErrorCode);
            }
            else
            {

                //initialize an empty unicode-string
                LSA_UNICODE_STRING systemName = new LSA_UNICODE_STRING();
                //combine all policies
                int access = (int)(
                    LSA_AccessPolicy.POLICY_AUDIT_LOG_ADMIN |
                    LSA_AccessPolicy.POLICY_CREATE_ACCOUNT |
                    LSA_AccessPolicy.POLICY_CREATE_PRIVILEGE |
                    LSA_AccessPolicy.POLICY_CREATE_SECRET |
                    LSA_AccessPolicy.POLICY_GET_PRIVATE_INFORMATION |
                    LSA_AccessPolicy.POLICY_LOOKUP_NAMES |
                    LSA_AccessPolicy.POLICY_NOTIFICATION |
                    LSA_AccessPolicy.POLICY_SERVER_ADMIN |
                    LSA_AccessPolicy.POLICY_SET_AUDIT_REQUIREMENTS |
                    LSA_AccessPolicy.POLICY_SET_DEFAULT_QUOTA_LIMITS |
                    LSA_AccessPolicy.POLICY_TRUST_ADMIN |
                    LSA_AccessPolicy.POLICY_VIEW_AUDIT_INFORMATION |
                    LSA_AccessPolicy.POLICY_VIEW_LOCAL_INFORMATION
                    );
                //initialize a pointer for the policy handle
                IntPtr policyHandle = IntPtr.Zero;

                //these attributes are not used, but LsaOpenPolicy wants them to exists
                LSA_OBJECT_ATTRIBUTES ObjectAttributes = new LSA_OBJECT_ATTRIBUTES();
                ObjectAttributes.Length = 0;
                ObjectAttributes.RootDirectory = IntPtr.Zero;
                ObjectAttributes.Attributes = 0;
                ObjectAttributes.SecurityDescriptor = IntPtr.Zero;
                ObjectAttributes.SecurityQualityOfService = IntPtr.Zero;

                //get a policy handle
                uint resultPolicy = LsaOpenPolicy(ref systemName, ref ObjectAttributes, access, out policyHandle);
                winErrorCode = LsaNtStatusToWinError(resultPolicy);

                if (winErrorCode != 0)
                {
                    Console.WriteLine("OpenPolicy failed: " + winErrorCode);
                }
                else
                {
                    //Now that we have the SID an the policy,
                    //we can add rights to the account.

                    //initialize an unicode-string for the privilege name
                    LSA_UNICODE_STRING[] userRights = new LSA_UNICODE_STRING[1];
                    userRights[0] = new LSA_UNICODE_STRING();
                    userRights[0].Buffer = Marshal.StringToHGlobalUni(privilegeName);
                    userRights[0].Length = (UInt16)(privilegeName.Length * UnicodeEncoding.CharSize);
                    userRights[0].MaximumLength = (UInt16)((privilegeName.Length + 1) * UnicodeEncoding.CharSize);

                    //add the right to the account
                    uint res = LsaAddAccountRights(policyHandle, sid, userRights, 1);
                    winErrorCode = LsaNtStatusToWinError(res);
                    if (winErrorCode != 0)
                    {
                        Console.WriteLine("LsaAddAccountRights failed: " + winErrorCode);
                    }

                    LsaClose(policyHandle);
                }
                FreeSid(sid);
            }

            return winErrorCode;
        }
    }
}
