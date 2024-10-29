using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.ServiceProcess;
using gov.va.med.imaging.exchange.VixInstaller.business;
using System.Security;
using System.Security.Principal;
using System.Diagnostics;
using System.Threading;
using Microsoft.Win32;
using System.Configuration;
using System.Security.Cryptography;
using System.Net.Sockets;
using System.IO;
using System.Timers;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
    public partial class Form1 : Form
    {
        private System.Diagnostics.Process p;
        private VixManifest manifest = null;
        private VixConfigurationParameters config = null;
        //private string payloadPath = null;

        private void ClearInfo()
        {
            this.textBoxInfo.Clear();
        }

        protected String Info(String infoMessage)
        {
            this.textBoxInfo.AppendText(infoMessage + Environment.NewLine);
            return infoMessage;
        }

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            this.config = new VixConfigurationParameters();
            this.config.ProductVersion = Application.ProductVersion;
            //this.config.PreviousProductVersion is null
            this.config.ConfigDir = @"C:\VixConfig";
            this.config.SiteServiceUri = "http://localhost/VistaWebSvcs/ImagingExchangeSiteService.asmx";
            this.config.SiteNumber = "660";
            this.config.BiaUsername = "vixuser";
            this.config.BiaPassword = "vixvix1.";
            this.config.SiteAbbreviation = "SLC";
            this.config.SiteName = "Salt Lake City, UT";
            this.config.VistaServerName = "localhost";
            this.config.VistaServerPort = "9300";
            this.config.LocalCacheDir = @"C:\VixCache";
            this.config.FederationKeystorePassword = ConfigurationManager.AppSettings["FederationKeystorePassword"];
            this.config.FederationTruststorePassword = ConfigurationManager.AppSettings["FederationTruststorePassword"];
            // config is missing all the wormhole and deployment information
            this.manifest = new VixManifest(Application.StartupPath);
            VixFacade.Manifest = this.manifest;
            VixFacade.InfoDelegate = this.Info;
            TomcatFacade.Manifest = this.manifest;
            JavaFacade.InfoDelegate = this.Info;
            JavaFacade.Manifest = this.manifest;
            LaurelBridgeFacade.Manifest = this.manifest;
            LaurelBridgeFacade.InfoDelegate = this.Info;
            BusinessFacade.Manifest = this.manifest;
            BusinessFacade.InfoDelegate = this.Info;

            try
            {
                WindowsIdentity wi = WindowsIdentity.GetCurrent();
                Debug.Assert(wi != null);
                WindowsPrincipal principal = new WindowsPrincipal(wi);
                this.Text += " - " + wi.Name + " (" + (principal.IsInRole(WindowsBuiltInRole.Administrator) ? "Administrator" : "Not Administrator") + ")";
            }
            catch (SecurityException ex)
            {
                // do better for error reporting
                this.Info("Security exception getting window identity: " + ex.InnerException.Message);
                // exit the application
            }
            catch (ArgumentNullException ex)
            {
                // do better for error reporting
                this.Info("Cannot determine current logged in windows user: " + ex.InnerException.Message);
                // exit the application
            }

        }

        private void buttonCreateServiceAccount_Click(object sender, EventArgs e)
        {
            //WindowsUserUtilities.CreateServiceAccount(TomcatFacade.ServiceAccountUsername, "R00tbeer", "VIX service account");
        }

        private void buttonSetServiceAccountRights_Click(object sender, EventArgs e)
        {
            LsaUtilities.SetServiceAccountPrivleges(TomcatFacade.ServiceAccountUsername);
        }

        private void buttonTomcatStatus_Click(object sender, EventArgs e)
        {
            try
            {
                ServiceControllerStatus status = ServiceUtilities.GetLocalServiceStatus("Tomcat5");
                this.Info("Tomcat Status: " + status.ToString());
            }
            catch (Exception ex)
            {
                this.Info("Exception: " + ex.Message);
            }
        }

        private void buttonStopTomcatService_Click(object sender, EventArgs e)
        {
            try
            {
                ServiceUtilities.StopLocalService("Tomcat5");
            }
            catch (Exception ex)
            {
                this.Info("Exception: " + ex.Message);
            }
        }

        private void buttonStartTomcatService_Click(object sender, EventArgs e)
        {
            try
            {
                ServiceUtilities.StartLocalService("Tomcat5");
            }
            catch (Exception ex)
            {
                this.Info("Exception: " + ex.Message);
            }
        }

        private void buttonClear_Click(object sender, EventArgs e)
        {
            this.ClearInfo();
        }

        private void buttonGetEnv_Click(object sender, EventArgs e)
        {
            String foo = Environment.GetEnvironmentVariable("foo", EnvironmentVariableTarget.Machine);

            this.Info("foo=" + (foo == null ? "null" : foo));
        }

        private void buttonSerEnv_Click(object sender, EventArgs e)
        {
            String foo = null;
            Environment.SetEnvironmentVariable("foo", "foo text create", EnvironmentVariableTarget.Machine);
            foo = Environment.GetEnvironmentVariable("foo", EnvironmentVariableTarget.Machine);
            this.Info("foo=" + (foo == null ? "null" : foo));
            Environment.SetEnvironmentVariable("foo", "foo text replace", EnvironmentVariableTarget.Machine);
            foo = Environment.GetEnvironmentVariable("foo", EnvironmentVariableTarget.Machine);
            this.Info("foo=" + (foo == null ? "null" : foo));
            Environment.SetEnvironmentVariable("foo", null, EnvironmentVariableTarget.Machine);
            foo = Environment.GetEnvironmentVariable("foo", EnvironmentVariableTarget.Machine);
            this.Info("foo=" + (foo == null ? "null" : foo));
        }

        private void buttonVixPermissions_Click(object sender, EventArgs e)
        {
            AccessContolUtilities.SetFullDirectoryAccessControl(TomcatFacade.ServiceAccountUsername, @"c:\VIX");
        }

        private void buttonUnzip_Click(object sender, EventArgs e)
        {
            ZipUtilities.ImprovedExtractToDirectory(@"C:\Install\VIX\VIX Server Install.zip", @"c:\Ziptest", ZipUtilities.Overwrite.Always);
        }

        private void buttonStartProcess_Click(object sender, EventArgs e)
        {
            //Process process = Process.Start("Notepad.exe");
            //this.Info("Process started");
            //do
            //{
            //    this.Info("waiting...");
            //    Thread.Sleep(1000);
            //    Application.DoEvents();
            //    process.Refresh();
            //} while (!process.HasExited);
            //this.Info("Process done");

            p = new System.Diagnostics.Process();
            // Handle the Exited event that the Process class fires.
            this.p.Exited += new System.EventHandler(this.p_Exited);
            p.EnableRaisingEvents = true;
            p.SynchronizingObject = this;
            p.StartInfo.FileName = "notepad.exe";
            p.Start();
            this.Info("Process started");
        }

        private void p_Exited(object sender, System.EventArgs e)
        {
            Process process = sender as Process;
            this.Info("Process done at " + process.ExitTime.ToString());
        }

        private void buttonServiceAccount_Click(object sender, EventArgs e)
        {
            try
            {
                //ServiceUtilities.SetServiceCredentials("Tomcat5", TomcatFacade.ServiceAccountUsername, "R00tbeer");
            }
            catch (Exception ex)
            {
                this.Info("Exception: " + ex.Message);
            }
        }

        private void buttonServiceFailureActions_Click(object sender, EventArgs e)
        {
            try
            {
                ServiceUtilities.SetServiceFailureActions("Tomcat5");
            }
            catch (Exception ex)
            {
                this.Info("Exception: " + ex.Message);
            }
        }

        private void buttonGetVixConfigDir_Click(object sender, EventArgs e)
        {
            this.Info("VIX configuration directory is: " + VixFacade.GetVixConfigurationDirectory());
        }

        private void buttonGetVixCacheDir_Click(object sender, EventArgs e)
        {
            this.Info("VIX cache directory is: " + VixFacade.GetLocalVixCacheDirectory());
        }

        private void textBoxTextChanged_TextChanged(object sender, EventArgs e)
        {
            this.Info("Text has changed in TextBox");
        }

        private void buttonRewriteCacheProp_Click(object sender, EventArgs e)
        {
            //VixFacade.RewriteCachePropertiesFile(this.config); i5 is dead
        }

        private void buttonManifestVixJavaProperties_Click(object sender, EventArgs e)
        {
            this.ClearInfo();
            // will cause error is i6 manifest and Tomcat 5.5 installed
            VixFacade.ApplyVixJavaPropertiesFromManifest(this.config, false);
        }

        private void buttonGetVixJavaPropertiesFromManifest_Click(object sender, EventArgs e)
        {
            this.ClearInfo();
            this.Info("VixManifest properties:");
            VixJavaProperty[] vixJavaProperties = this.manifest.GetManifestVixJavaProperties(config.ConfigDir);
            foreach (VixJavaProperty vixJavaProperty in vixJavaProperties)
            {
                this.Info(vixJavaProperty.ToString());
            }
        }

        private void buttonWriteViXConfigFile_Click(object sender, EventArgs e)
        {
            //VixFacade.WriteViXConfigurationFiles(this.config, @"C:\Install\ViXi6", true); // developer mode argument doesnt do anything
        }

        private void buttonCopyManifestDependencyFiles_Click(object sender, EventArgs e)
        {
            //VixFacade.CopyVixDistributionToTomcat(this.config, this.payloadPath);
            //VixFacade.CopyManifestFilesToTomcat(this.config, this.payloadPath, false); // commit = false
        }

        private void DisplayConfigInfo(VixConfigurationParameters vixConfig, int vixIteration)
        {
            this.ClearInfo();
            this.Info("Iteration " + vixIteration.ToString());
            this.Info("ConfigDir: " + vixConfig.ConfigDir);
            this.Info("LocalCacheDir: " + vixConfig.LocalCacheDir);
            this.Info("SiteNumber: " + vixConfig.SiteNumber);
            this.Info("PreviousProductVersion: " + vixConfig.PreviousProductVersion);
            this.Info("BiaUsername: " + vixConfig.BiaUsername);
            this.Info("BiaPassword: " + vixConfig.BiaPassword);
            this.Info("SiteServiceUri: " + vixConfig.SiteServiceUri);
        }

        private void buttonTomcatFacadeProperties_Click(object sender, EventArgs e)
        {
            this.ClearInfo();
            this.Info("TomcatInstallationFolder: " + TomcatFacade.TomcatInstallationFolder);
            this.Info("WebApplicationFolder: " + TomcatFacade.TomcatWebApplicationFolder);
            this.Info("TomcatServiceName: " + TomcatFacade.TomcatServiceName);
            this.Info("ExecutableFolder: " + TomcatFacade.TomcatExecutableFolder);
            this.Info("ConfigurationFolder: " + TomcatFacade.TomcatConfigurationFolder);
            this.Info("TomcatInstallerFilespec: " + TomcatFacade.InstallerFilespec);
            this.Info("TomcatInstalledVersion: " + TomcatFacade.InstalledTomcatVersion);
            this.Info("TomcatRequiredVersion: " + TomcatFacade.ActiveTomcatVersion);
            this.Info("Tomcat Installed? " + TomcatFacade.IsTomcatInstalled());
            this.Info("Required Tomcat Version Installed? " + TomcatFacade.IsActiveTomcatVersionInstalled());
        }

        private void buttonWriteServerXml_Click(object sender, EventArgs e)
        {
            VixFacade.AddWebAppContextElements(@"C:\VixConfigTest\server.xml", this.config);
        }

        private void buttonConfigureTomcatService_Click(object sender, EventArgs e)
        {
            TomcatFacade.ConfigureTomcatService(config);
        }

        private void buttonGetJavaJrePath_Click(object sender, EventArgs e)
        {
            this.ClearInfo();
            this.Info("Java JRE Path: ");
            this.Info(JavaFacade.GetActiveJavaPath(true));
            this.Info("Java JDK Path: ");
            this.Info(JavaFacade.GetActiveJavaPath(false));
        }

        private void buttonJavaVersion_Click(object sender, EventArgs e)
        {
            this.Info("Java Version: ");
            this.Info(JavaFacade.ActiveJavaVersion);
        }

        private void buttonInstallJre_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
            // Handle the Exited event that the Process class fires.
            externalProcess.EnableRaisingEvents = true;
            externalProcess.SynchronizingObject = this;
            externalProcess.StartInfo.FileName = @"C:\Install\Java\j2se6\jre-6u17-windows-i586.exe";
            externalProcess.StartInfo.Arguments = "/s /v \"/qn REBOOT=Suppress JAVAUPDATE=0 INSTALLDIR=\\\"" + JavaFacade.GetActiveJavaPath(true) + "\\\"";
            externalProcess.Start();
            this.Info("Process started");
            do
            {
                this.Info("waiting...");
                Thread.Sleep(1000);
                Application.DoEvents();
                externalProcess.Refresh();
            } while (!externalProcess.HasExited);
            this.Info("Process done");
        }

        private void buttonUninstallJre_Click(object sender, EventArgs e)
        {
            System.Diagnostics.Process externalProcess = new System.Diagnostics.Process();
            // Handle the Exited event that the Process class fires.
            externalProcess.EnableRaisingEvents = true;
            externalProcess.SynchronizingObject = this;
            externalProcess.StartInfo.FileName = @"msiexec.exe";
            externalProcess.StartInfo.Arguments = @"/qn /x {26A24AE4-039D-4CA4-87B4-2F83216017FF}";
            externalProcess.Start();
            this.Info("Process started");
            do
            {
                this.Info("waiting...");
                Thread.Sleep(1000);
                Application.DoEvents();
                externalProcess.Refresh();
            } while (!externalProcess.HasExited);
            this.Info("Process done");
        }

        private void buttonJavaInstallerFilespec_Click(object sender, EventArgs e)
        {
            String filespec = JavaFacade.GetInstallerFilespec();
            this.Info("Java Installer Filespec: " + filespec);
        }

        private void buttonVradFedServicesHack_Click(object sender, EventArgs e)
        {
            //VixFacade.RemovedFederationVistaRadSupportHack();
        }

        private void buttonGetInstalledServices_Click(object sender, EventArgs e)
        {
            string[] services = ServiceUtilities.GetNonDriverServiceNames();
            foreach (string service in services)
            {
                this.Info(service);
            }
        }

        private void buttonIsDeprecatedTomcatServiceInstalled_Click(object sender, EventArgs e)
        {
            if (TomcatFacade.IsDeprecatedTomcatServiceInstalled())
            {
                this.Info("Deprecated Tomcat Service is installed.");
            }
            else
            {
                this.Info("Deprecated Tomcat Service is not installed.");
            }
        }

        private void buttonCrypto_Click(object sender, EventArgs e)
        {
            TripleDESCryptoServiceProvider algValue = new TripleDESCryptoServiceProvider();
            byte[] iv = algValue.IV;
            byte[] key = algValue.Key;
            int keySize = algValue.KeySize;
            StringBuilder sb = new StringBuilder();
            sb.Append("byte[] key = {");
            for (int i = 0 ; i < key.Length ; i++)
            {
                sb.Append(key[i].ToString());
                if (i < key.Length - 1) sb.Append(", ");
            }
            sb.AppendLine("};");
            sb.Append("byte[] iv = {");
            for (int i = 0; i < iv.Length; i++)
            {
                sb.Append(iv[i].ToString());
                if (i < iv.Length - 1) sb.Append(", ");
            }
            sb.AppendLine("};");
            this.Info(sb.ToString());
        }

        private void buttonCorrectJavaDir_Click(object sender, EventArgs e)
        {
            bool isWrongDir = JavaFacade.IsJavaInstalledInWrongDirectory(true);
            this.Info("JavaFacade.IsJavaInstalledInWrongDirectory(true) returned " + isWrongDir.ToString());
            isWrongDir = JavaFacade.IsJavaInstalledInWrongDirectory(false);
            this.Info("JavaFacade.IsJavaInstalledInWrongDirectory(false) returned " + isWrongDir.ToString());
        }

        private void buttonLBVersion_Click(object sender, EventArgs e)
        {
            string version = LaurelBridgeFacade.GetInstalledLaurelBridgeVersion();
            this.Info("LaurelBridgeFacade.GetInstalledLaurelBridgeVersion() returned " + version);

        }

        private void buttonIsDeprecatedDCFInstalled_Click(object sender, EventArgs e)
        {
            bool isDeprecated = LaurelBridgeFacade.IsDeprecatedLaurelBridgeInstalled();
            this.Info("LaurelBridgeFacade.IsDeprecatedLaurelBridgeInstalled() returned " + isDeprecated.ToString());
        }

        private void buttonGetDcfRootDirectory_Click(object sender, EventArgs e)
        {
            string dcfDir = LaurelBridgeFacade.GetInstalledLaurelBridgeRootDirectory();
            this.Info("LaurelBridgeFacade.GetInstalledLaurelBridgeRootDirectory() returned " + dcfDir);
        }

        private void buttonActiveDcfLicenseType_Click(object sender, EventArgs e)
        {
            DcfLicenseType licenseType = LaurelBridgeFacade.GetActiveDcfLicenseType();
            this.Info("LaurelBridgeFacade.GetActiveDcfLicenseType() returned " + licenseType.ToString());
        }

        private void buttonIsVS2005CPlusPlusRuntimeInstalled_Click(object sender, EventArgs e)
        {
            //bool isInstalled = BusinessFacade.IsVCPlusPlus2005x86RedistributableInstalled();
            bool isInstalled = LaurelBridgeFacade.CanRunDcfInfo();
            this.Info("LaurelBridgeFacade.IsVS2005CPlusPlusRedistributableInstalled() returned " + isInstalled.ToString());
        }

        private void buttonInstallVS2005CPlusPlusRuntimeInstalled_Click(object sender, EventArgs e)
        {
            bool isInstalled = BusinessFacade.InstallVCPlusPlusRedistributableForLaurelBridge(@"C:\DCF_Runtime");
            this.Info("LaurelBridgeFacade.InstallVS2005CPlusPlusRedistributable() returned " + isInstalled.ToString());
        }

        private void buttonInstallDcfToolkit_Click(object sender, EventArgs e)
        {
            string errorMessage = "";
            if (LaurelBridgeFacade.InstallLaurelBridgeDcfToolkit(@"C:\DCF_RunTime", ref errorMessage) == false)
            {
                Info("LaurelBridgeFacade.InstallLaurelBridgeDcfToolkit reported the following error message: " + errorMessage);
            }
        }

        private void buttonRemoveDcfToolkit_Click(object sender, EventArgs e)
        {
            LaurelBridgeFacade.RemoveLaurelBridgeInstallation(config);
        }

        private void buttonSetDcfEnvironmentVariables_Click(object sender, EventArgs e)
        {
            LaurelBridgeFacade.CreateLaurelBridgeEnvironmentVariables(@"C:\DCF_RunTime");
        }

        private void buttonRemoveDcfEnvironmentVariables_Click(object sender, EventArgs e)
        {
            LaurelBridgeFacade.RemoveLaurelBridgeEnvironmentVariables();
        }

        private void buttonIsDcfToolkitInstalled_Click(object sender, EventArgs e)
        {
            bool isInstalled = LaurelBridgeFacade.IsLaurelBridgeInstalled();
            Info("LaurelBridgeFacade.IsLaurelBridgeInstalled() returned " + isInstalled.ToString());
        }

        private void buttonIsDcfToolkitLicensed_Click(object sender, EventArgs e)
        {
            bool isInstalled = LaurelBridgeFacade.IsLaurelBridgeLicensed();
            Info("LaurelBridgeFacade.IsLaurelBridgeLicensed() returned " + isInstalled.ToString());
        }

        private void buttonLicenseUsingMacKey_Click(object sender, EventArgs e)
        {
            string errorMessage = "";
            if (LaurelBridgeFacade.LicenseLaurelBridgeDcfToolkitWithMacBasedKeyFile(@"C:\Install\Laurel Bridge\DCF-SDK-DEV-3.3.x-MA-VA-SilverSpring-KeithBucklaptop-99991231-00.24.D7.38.83.C8.key", ref errorMessage) == false)
            {
                Info("LaurelBridgeFacade.LicenseLaurelBridgeDcfToolkitWithMacBasedKeyFile reported the following error message: " + errorMessage);
            }
        }

        private void buttonLicenseUsingEnterpriseLicense_Click(object sender, EventArgs e)
        {
            string macAddress = null;
            LaurelBridgeFacade.LicenseLaurelBridgeDcfToolkitWithEnterpriseLicense(macAddress);
        }

        private void buttonIsVS2008CPlusPlusRuntimeInstalled_Click(object sender, EventArgs e)
        {
            bool isInstalled = BusinessFacade.IsVCPlusPlus2008RedistributableInstalled();
            this.Info("LaurelBridgeFacade.IsVS2008CPlusPlusRedistributableInstalled() returned " + isInstalled.ToString());
        }

        private void buttonInstallVS2008CPlusPlusRuntimeInstalled_Click(object sender, EventArgs e)
        {
            bool isInstalled = BusinessFacade.InstallVCPlusPlus2008Redistributable();
            this.Info("LaurelBridgeFacade.InstallVS2008CPlusPlusRedistributable() returned " + isInstalled.ToString());
        }

        private void buttonIsJaiInstalled_Click(object sender, EventArgs e)
        {
            bool isInstalled = JavaFacade.IsJavaAdvancedImagingInstalledViaMsi();
            this.Info("JavaFacade.isJavaAdvancedImagingInstalledViaMsi() returned " + isInstalled.ToString());
        }

        private void buttonIsJavaImageIOInstalled_Click(object sender, EventArgs e)
        {
            bool isInstalled = JavaFacade.IsJavaImageIOInstalledViaMsi();
            this.Info("JavaFacade.IsJavaImageIOInstalledViaMsi() returned " + isInstalled.ToString());
        }

        private void buttonUninstallActiveJre_Click(object sender, EventArgs e)
        {
            this.Info("Uninstalling Active JRE");
            JavaFacade.UninstallActiveJre();
            this.Info("Done");
        }

        private void buttonDumpVixConfig_Click(object sender, EventArgs e)
        {
            VixConfigurationParameters.FromXmlToFile(VixFacade.GetVixConfigurationDirectory());
            this.Info("Done");
        }

        private void buttonCanRunDcfInfo_Click(object sender, EventArgs e)
        {
            bool canRun = LaurelBridgeFacade.CanRunDcfInfo();
            Info("LaurelBridgeFacade.CanRunDcfInfo() returned " + canRun.ToString());
        }

        private void buttonEnable64BitInstallation_Click(object sender, EventArgs e)
        {
            bool isEnabled = manifest.Enable64BitInstallation;
            this.Info("manifest.Enable64BitInstallation() returned " + isEnabled.ToString());
        }

        private void buttonTestTomcatUserAccess_Click(object sender, EventArgs e)
        {
            VixManifest manifest = new VixManifest(Application.StartupPath);
            TomcatFacade.Manifest = manifest;
            if (!TomcatFacade.TestTomcatUserAccess("apachetomcat"))
            {
                Info("TestTomcatUserAccess - failed - delete user");
                if (TomcatFacade.DeleteTomcatUser("apachetomcat"))
                {
                    Info("TestTomcatUserAccess - user deleted successfully or doesn't exist");

                    //TomcatFacade.UninstallCurrentTomcat();
                    //JavaFacade.UninstallCurrentJre();

                    //VixConfigurationParameters config = VixConfigurationParameters.FromXml(VixFacade.GetVixConfigurationDirectory());
                    //if (config != null)
                    //    VixFacade.DeleteLocalCacheRegions(config);

                }
                else
                {
                    Info("Unable to delete apachetomcat user");

                }

            }
            else
            {
                Info("TestTomcatUserAccess OKAY");
            }

            if (!JavaFacade.UninstallCurrentJre())
            {
                Info("Unable to uninstall java programmatically, please remove manually and reinstall");
            }

            string vixconfig = VixFacade.GetVixConfigurationDirectory();

            if (vixconfig == null)
                vixconfig = @"c:\vixconfig";

            VixConfigurationParameters config = VixConfigurationParameters.FromXml(vixconfig);
            if (config != null)
                VixFacade.DeleteLocalCacheRegions(config);

        }

        DateTime maxTime = DateTime.Now;
        
        private void buttonGetVixVersion_Click(object sender, EventArgs e)
        {
            ProcessStartInfo startInfo = new ProcessStartInfo();
            //startInfo.CreateNoWindow = false;
            startInfo.UseShellExecute = true;
            startInfo.FileName = "VixGetVersion.exe";
            startInfo.WindowStyle = ProcessWindowStyle.Normal;
            //String catalinaProp = Path.Combine(TomcatFacade.TomcatConfigurationFolder, "catalina.properties");
            startInfo.Arguments = @"CVIX " + "\"" + @"C:\Program Files\Apache Software Foundation\Tomcat 8.0\conf" + "\"";
            Process.Start(startInfo);
        }   
        
    }
}