﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.261
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ClearCanvas.Desktop.Explorer {
    
    
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator", "10.0.0.0")]
    internal sealed partial class ExplorerLocalSettings : global::System.Configuration.ApplicationSettingsBase {
        
        private static ExplorerLocalSettings defaultInstance = ((ExplorerLocalSettings)(global::System.Configuration.ApplicationSettingsBase.Synchronized(new ExplorerLocalSettings())));
        
        public static ExplorerLocalSettings Default {
            get {
                return defaultInstance;
            }
        }
        
        /// <summary>
        /// Specifies whether or not the Explorer is the primary window/workspace for the application.  When true, the Explorer is shown on startup and cannot be closed.
        /// </summary>
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Configuration.SettingsDescriptionAttribute("Specifies whether or not the Explorer is the primary window/workspace for the app" +
            "lication.  When true, the Explorer is shown on startup and cannot be closed.")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("True")]
        public bool ExplorerIsPrimary {
            get {
                return ((bool)(this["ExplorerIsPrimary"]));
            }
        }
    }
}
