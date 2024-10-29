﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.261
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ClearCanvas.ImageViewer.StudyLoaders.Streaming {
    
    
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator", "10.0.0.0")]
    internal sealed partial class StreamingSettings : global::System.Configuration.ApplicationSettingsBase {
        
        private static StreamingSettings defaultInstance = ((StreamingSettings)(global::System.Configuration.ApplicationSettingsBase.Synchronized(new StreamingSettings())));
        
        public static StreamingSettings Default {
            get {
                return defaultInstance;
            }
        }
        
        /// <summary>
        /// Format of a WADO URL (2 items, server and port).
        /// </summary>
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Configuration.SettingsDescriptionAttribute("Format of a WADO URL (2 items, server and port).")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("http://{0}:{1}/WADO")]
        public string FormatWadoUriPrefix {
            get {
                return ((string)(this["FormatWadoUriPrefix"]));
            }
        }
        
        /// <summary>
        /// Format of a header streaming service URL.
        /// </summary>
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Configuration.SettingsDescriptionAttribute("Format of a header streaming service URL.")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("http://{0}:{1}/HeaderStreaming/HeaderStreaming")]
        public string FormatHeaderServiceUri {
            get {
                return ((string)(this["FormatHeaderServiceUri"]));
            }
        }
        
        /// <summary>
        /// The number of concurrent threads that should be used to pre-fetch streamed image data.
        /// </summary>
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Configuration.SettingsDescriptionAttribute("The number of concurrent threads that should be used to pre-fetch streamed image " +
            "data.")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("5")]
        public int RetrieveConcurrency {
            get {
                return ((int)(this["RetrieveConcurrency"]));
            }
        }
        
        /// <summary>
        /// An arbitrary weighting value for loading images in the selected image box versus all the other unselected image boxes.
        /// </summary>
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Configuration.SettingsDescriptionAttribute("An arbitrary weighting value for loading images in the selected image box versus " +
            "all the other unselected image boxes.")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("3")]
        public int SelectedWeighting {
            get {
                return ((int)(this["SelectedWeighting"]));
            }
        }
        
        /// <summary>
        /// An arbitrary weighting value for loading images in the selected image box versus all the other unselected image boxes.
        /// </summary>
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Configuration.SettingsDescriptionAttribute("An arbitrary weighting value for loading images in the selected image box versus " +
            "all the other unselected image boxes.")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("2")]
        public int UnselectedWeighting {
            get {
                return ((int)(this["UnselectedWeighting"]));
            }
        }
        
        /// <summary>
        /// The number of concurrent threads used to decompress pre-fetched image pixel data.
        /// </summary>
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Configuration.SettingsDescriptionAttribute("The number of concurrent threads used to decompress pre-fetched image pixel data." +
            "")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("1")]
        public int DecompressConcurrency {
            get {
                return ((int)(this["DecompressConcurrency"]));
            }
        }
        
        /// <summary>
        /// The number of images ahead and behind the current (visible) image to pre-fetch the pixel data for.
        /// </summary>
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Configuration.SettingsDescriptionAttribute("The number of images ahead and behind the current (visible) image to pre-fetch th" +
            "e pixel data for.")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("20")]
        public int ImageWindow {
            get {
                return ((int)(this["ImageWindow"]));
            }
        }
        
        /// <summary>
        /// The minimum amount of available memory required for pre-fetching to continue.  If this limit is hit, pre-fetching stops for the remainder of the viewer session.
        /// </summary>
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Configuration.SettingsDescriptionAttribute("The minimum amount of available memory required for pre-fetching to continue.  If" +
            " this limit is hit, pre-fetching stops for the remainder of the viewer session.")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("250")]
        public int AvailableMemoryLimitMegabytes {
            get {
                return ((int)(this["AvailableMemoryLimitMegabytes"]));
            }
        }
    }
}
