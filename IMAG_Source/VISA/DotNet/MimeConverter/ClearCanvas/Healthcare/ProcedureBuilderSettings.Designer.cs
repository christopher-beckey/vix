﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.269
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace ClearCanvas.Healthcare {
    
    
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Editors.SettingsDesigner.SettingsSingleFileGenerator", "10.0.0.0")]
    internal sealed partial class ProcedureBuilderSettings : global::System.Configuration.ApplicationSettingsBase {
        
        private static ProcedureBuilderSettings defaultInstance = ((ProcedureBuilderSettings)(global::System.Configuration.ApplicationSettingsBase.Synchronized(new ProcedureBuilderSettings())));
        
        public static ProcedureBuilderSettings Default {
            get {
                return defaultInstance;
            }
        }
        
        /// <summary>
        /// Root procedure plan, inherited by all procedure plans that do not explicitly specify a base plan.
        /// </summary>
        [global::System.Configuration.ApplicationScopedSettingAttribute()]
        [global::System.Configuration.SettingsDescriptionAttribute("Root procedure plan, inherited by all procedure plans that do not explicitly spec" +
            "ify a base plan.")]
        [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
        [global::System.Configuration.DefaultSettingValueAttribute("ProcedureBuilderRootProcedurePlan.xml")]
        public string RootProcedurePlanXml {
            get {
                return ((string)(this["RootProcedurePlanXml"]));
            }
        }
    }
}
