﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.1008
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ClearCanvas.Enterprise.Common {
    using System;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option, or rebuild your VS project.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("System.Resources.Tools.StronglyTypedResourceBuilder", "4.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    internal class SR {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal SR() {
        }
        
        /// <summary>
        ///   Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("ClearCanvas.Enterprise.Common.SR", typeof(SR).Assembly);
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Audit service not reachable and the offline cache is either not configured, or not writable..
        /// </summary>
        internal static string ExceptionAuditServiceNotReachableAndNoOfflineCache {
            get {
                return ResourceManager.GetString("ExceptionAuditServiceNotReachableAndNoOfflineCache", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Authority group &apos;{0}&apos; could not be deleted. There are currently {1} users belonging to this group..
        /// </summary>
        internal static string ExceptionAuthorityGroupIsNotEmpty_MultipleUsers {
            get {
                return ResourceManager.GetString("ExceptionAuthorityGroupIsNotEmpty_MultipleUsers", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Authority group &apos;{0}&apos; could not be deleted. There is currently one user belonging to this group..
        /// </summary>
        internal static string ExceptionAuthorityGroupIsNotEmpty_OneUser {
            get {
                return ResourceManager.GetString("ExceptionAuthorityGroupIsNotEmpty_OneUser", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Object modified by another user or process.
        /// </summary>
        internal static string ExceptionConcurrentModification {
            get {
                return ResourceManager.GetString("ExceptionConcurrentModification", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Invalid or expired user session..
        /// </summary>
        internal static string ExceptionInvalidUserSession {
            get {
                return ResourceManager.GetString("ExceptionInvalidUserSession", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Offline cache not found..
        /// </summary>
        internal static string ExceptionOfflineCacheNotFound {
            get {
                return ResourceManager.GetString("ExceptionOfflineCacheNotFound", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The password for this account has expired and must be changed before a new session can be initiated..
        /// </summary>
        internal static string ExceptionPasswordExpired {
            get {
                return ResourceManager.GetString("ExceptionPasswordExpired", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Access denied.  The user credentials may be invalid or the account may be disabled..
        /// </summary>
        internal static string ExceptionUserAccessDenied {
            get {
                return ResourceManager.GetString("ExceptionUserAccessDenied", resourceCulture);
            }
        }
    }
}
