﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.261
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ClearCanvas.ImageViewer.Thumbnails.Configuration {
    
    
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator", "10.0.0.0")]
    internal sealed partial class ThumbnailsSettings : global::System.Configuration.ApplicationSettingsBase {
        
        private static ThumbnailsSettings defaultInstance = ((ThumbnailsSettings)(global::System.Configuration.ApplicationSettingsBase.Synchronized(new ThumbnailsSettings())));
        
        public static ThumbnailsSettings Default {
            get {
                return defaultInstance;
            }
        }
        
        /// <summary>
        /// Specifies whether or not to automatically open the thumbnail panel when the viewer opens.
        /// </summary>
        [global::System.Configuration.UserScopedSettingAttribute()]
        [global::System.Configuration.SettingsDescriptionAttribute("Specifies whether or not to automatically open the thumbnail panel when the viewe" +
            "r opens.")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("False")]
        public bool AutoOpenThumbnails {
            get {
                return ((bool)(this["AutoOpenThumbnails"]));
            }
            set {
                this["AutoOpenThumbnails"] = value;
            }
        }
    }
}
