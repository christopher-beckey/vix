﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.18444
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ClearCanvas.Enterprise.Core.ServerVersion {
    
    
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator", "10.0.0.0")]
    internal sealed partial class LegacyServiceSettings : global::System.Configuration.ApplicationSettingsBase {
        
        private static LegacyServiceSettings defaultInstance = ((LegacyServiceSettings)(global::System.Configuration.ApplicationSettingsBase.Synchronized(new LegacyServiceSettings())));
        
        public static LegacyServiceSettings Default {
            get {
                return defaultInstance;
            }
        }
        
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("1.0.0.0")]
        public string CompatibilityVersion {
            get {
                return ((string)(this["CompatibilityVersion"]));
            }
        }
        
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("Team")]
        public string CompatibilityEdition {
            get {
                return ((string)(this["CompatibilityEdition"]));
            }
        }
    }
}
