﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.261
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ClearCanvas.ImageServer.Rules {
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
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("ClearCanvas.ImageServer.Rules.SR", typeof(SR).Assembly);
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
        ///   Looks up a localized string similar to Attempted to autoroute to Device {0} with autoroute support disabled on partition {1}.
        /// </summary>
        internal static string AlertAutoRouteDestinationAEDisabled {
            get {
                return ResourceManager.GetString("AlertAutoRouteDestinationAEDisabled", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Attempted to autoroute to unknown device &apos;{0}&apos; on partition &apos;{1}&apos;.
        /// </summary>
        internal static string AlertAutoRouteUnknownDestination {
            get {
                return ResourceManager.GetString("AlertAutoRouteUnknownDestination", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Auto Route Rule.
        /// </summary>
        internal static string AlertComponentAutorouteRule {
            get {
                return ResourceManager.GetString("AlertComponentAutorouteRule", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Data Access Rule.
        /// </summary>
        internal static string AlertComponentDataAccessRule {
            get {
                return ResourceManager.GetString("AlertComponentDataAccessRule", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Server Rules.
        /// </summary>
        internal static string AlertComponentRules {
            get {
                return ResourceManager.GetString("AlertComponentRules", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Attempted to Grant Access to unknown Authority Group OID &apos;{0}&apos; on partition &apos;{1}&apos;.
        /// </summary>
        internal static string AlertDataAccessUnknownAuthorityGroup {
            get {
                return ResourceManager.GetString("AlertDataAccessUnknownAuthorityGroup", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Bad server rule configuration: specified tag &apos;{0}&apos; is invalid.
        /// </summary>
        internal static string AlertRuleInvalid {
            get {
                return ResourceManager.GetString("AlertRuleInvalid", resourceCulture);
            }
        }
    }
}
