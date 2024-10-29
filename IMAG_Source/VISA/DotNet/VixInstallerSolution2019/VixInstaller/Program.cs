using System;
using System.Collections.Generic;
using System.Windows.Forms;
using log4net;
using gov.va.med.imaging.exchange.VixInstaller.business;
using System.IO;
using System.Configuration;


namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {
            //VAI-356 Install .NET Framework 4.8 if 4.8 or greater is not installed
            double versionDotNet = BusinessFacade.GetNET48PlusFromRegistry();
            if (versionDotNet >= 4.8)
            {
                //NET Framework 4.8 or greater is installed
            }
            else
            {
                try
                {
                    BusinessFacade.InstallNETFramework(Application.StartupPath, 1);
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message, "Unable to install required .NET Framework 4.8", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
            }

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            string installLogFile = @"vix-install-log.txt";
            //if the prior install log exists use temp folder to save for the install log backup
            if (File.Exists(installLogFile))
            {
                try
                {
                    string dirPathVIXBackupTemp = @"C:\VIXBackup\temp";
                    var installLogFileTemp = dirPathVIXBackupTemp + @"\" +  installLogFile;
                    if (!Directory.Exists(dirPathVIXBackupTemp))
                    {
                        Directory.CreateDirectory(dirPathVIXBackupTemp);
                    }
                    System.IO.File.Move(installLogFile, installLogFileTemp);                              
                }
                catch (Exception)
                {
                    // Do nothing, install log backup will show not created in PreUninstallConfigBackups.ps1
                }
                finally
                {
                    File.Delete(installLogFile);
                }
            }
            log4net.Config.XmlConfigurator.Configure(new System.IO.FileInfo("VixInstallerLog.xml"));

            if (args.Length == 1 && args[0] == "-testbed")
            {
                Application.Run(new Form1());
            }
            else
            {
                // unzip the VIX distribution payload if necessary
                VixManifest manifest = new VixManifest(Application.StartupPath);
                String payloadJar = Path.Combine(manifest.PayloadPath, @"server\jars");

                if (!Directory.Exists(payloadJar))
                {
                    String unzipPath = Path.Combine(Application.StartupPath, "VIX");
                    String vixZipFile = BusinessFacade.GetPayloadZipPath(Application.StartupPath);
                    try
                    {
                        Application.UseWaitCursor = true;
                        ZipUtilities.ImprovedExtractToDirectory(vixZipFile, unzipPath, ZipUtilities.Overwrite.Always);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message, "VIX Installer Exception", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    }
                    finally
                    {
                        Application.UseWaitCursor = false;
                    }
                }

                // reality check against the ViX distribution zip file being built incorrectly
                if (!Directory.Exists(payloadJar))
                {
                    String message = "The VIX distribution files [" + payloadJar + "] contained in the VixDistribution.zip file cannot be installed by the VIX Installer version " +
                        Application.ProductVersion + ". Please contact technical support.";
                    MessageBox.Show(message, "VIX Distribution/Installer Mismatch", MessageBoxButtons.OK, MessageBoxIcon.Error);
                }
                else
                {
                    //TomcatFacade.Manifest = manifest;
                    //if (TomcatFacade.CheckAndFixTomcatUserAccess())
                    //{
                        // display the wizard form to the user
                        Application.Run(new WizardForm());
                        if (Directory.Exists(manifest.PayloadPath))
                        {
                            Directory.Delete(manifest.PayloadPath, true); // uninstall will clean up the zip file
                        }
                    //}
                    //else
                    //{
                    //    String message = "Unable to fix corrupted Tomcat User access. Please remove apachetomcat user and uninstall tomcat manually";
                    //    MessageBox.Show(message, "Tomcat user access", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    //}
                }
            }

        }
    }
}