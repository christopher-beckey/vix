using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration.Install;
using System.Diagnostics;
using System.IO;
using System.Threading;


namespace VixInstallerClassDll
{
    [RunInstaller(true)]
    public partial class VixInstallerClass : System.Configuration.Install.Installer
    {
        public VixInstallerClass()
        {
            InitializeComponent();
        }

        public override void Install(System.Collections.IDictionary stateSaver)
        {
            base.Install(stateSaver);
            stateSaver.Add("TargetDir", Context.Parameters["DP_TargetDir"].ToString());
        }

        public override void Commit(System.Collections.IDictionary savedState)
        {
            base.Commit(savedState);
            Process externalProcess = new System.Diagnostics.Process();
            String workingDir = @savedState["TargetDir"].ToString();
            String exeFilespec = Path.Combine(workingDir, @"VixInstaller");
            if (!File.Exists(exeFilespec))
            {
                Thread.Sleep(3000);
            }
            externalProcess.StartInfo.FileName = exeFilespec;
            externalProcess.StartInfo.WorkingDirectory = workingDir;
            externalProcess.Start();
        }

        public override void Rollback(System.Collections.IDictionary savedState)
        {
            base.Rollback(savedState);
        }

        public override void Uninstall(System.Collections.IDictionary savedState)
        {
            base.Uninstall(savedState);
        }
    }
}
