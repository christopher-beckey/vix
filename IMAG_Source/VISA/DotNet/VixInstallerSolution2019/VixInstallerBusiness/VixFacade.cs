using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using log4net;
using System.Diagnostics;
using System.Threading;
using Microsoft.Win32;
using Microsoft.VisualBasic.FileIO;
using System.Xml;
using System.Net.Sockets;
using System.Net;
using System.Runtime.InteropServices;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public static class VixFacade
    {
        private static readonly String VIX_CONFIG_FILENAME = "ViXConfig.xml";
        private static readonly String SITE_SERVICE_SITE_RESOLUTION_FILENAME = "SiteServiceSiteResolution-1.0.config";
        private static readonly String EXCHANGE_DATA_SOURCE_FILENAME = "ExchangeDataSource-1.0.config";
        private static readonly String EXCHANGE_CACHE_CONFIG_REL_FILESPEC = @"cache-config\ImagingExchangeCache-cache.xml";
        private static readonly String EXCHANGE_CACHE_DOD_IMAGE_REGION = @"dod-image-region";
        private static readonly String FEDERATION_KEYSTORE_FILENAME = "federation.keystore";
        private static readonly String FEDERATION_TRUSTSTORE_FILENAME = "federation.truststore";
        public static readonly String VIX_CACHE_DIRECTORY = @"VixCache";
        public static readonly String VIX_CONFIG_DIRECTORY = @"VixConfig";
        public static readonly String VIX_ARCHIVED_LOGS_DIRECTORY = @"ImagingArchivedLogs";
        public static readonly String VIX_CERTSTORE_DIRECTORY = @"VixCertStore";
        public static readonly String VIX_TRANSACTION_LOGS_DB_DIRECTORY = @"VixTxDb";
        public static readonly int MINIMUM_VIX_CACHE_SIZE_GB = 20;
        private static readonly long ONE_GIGBYTE = (1024 * 1024 * 1024);
        public static readonly String HDIG_DICOM_DIRECTORY = @"DICOM";
        //private static readonly String XCA_KEYSTORE_FILENAME = "xca.keystore";
        //private static readonly String XCA_TRUSTSTORE_FILENAME = "xca.truststore";
        private static readonly String XCA_CERTIFICATE_FILENAME = "CVIX_XCA_Certificate.pem";
        private static readonly String XCA_PRIVATE_KEY_FILENAME = "CVIX_XCA_PrivateKey.pem";
        private static readonly String MODALITY_BLACKLIST_FILENAME = "ExchangeModalityBlackList.txt";
        private static readonly String ROI_DISCLOSURE_DIRECTORY = @"ROI\disclosure";
        private static readonly String THUMBNAIL_MAKER_EXE = "ISI_makeabs.exe";
        private static readonly String INGEST_TEMP_PATH = "Ingest_temp";

        [DllImport("kernel32.dll", EntryPoint = "CreateSymbolicLinkW", CharSet = CharSet.Unicode)]
        public static extern int CreateSymbolicLink(string lpSymlinkFileName, string lpTargetFileName, uint dwFlags);

        #region properties
        private static InfoDelegate infoDelegate = null; // used to display a line of text to any WizardPage that has registered
        public static InfoDelegate InfoDelegate
        {
            get { return VixFacade.infoDelegate; }
            set { VixFacade.infoDelegate = value; }
        }

        private static AppEventsDelegate appEventsDelegate = null; // used to keep the UI responsive
        public static AppEventsDelegate AppEventsDelegate
        {
            get { return VixFacade.appEventsDelegate; }
            set { VixFacade.appEventsDelegate = value; }
        }

        private static VixManifest manifest = null; // the installation manifest
        public static VixManifest Manifest
        {
            get { return VixFacade.manifest; }
            set { VixFacade.manifest = value; }
        }

        public static string VixConfigFilespec
        {
            get { return Path.Combine(GetVixConfigurationDirectory(), VIX_CONFIG_FILENAME); }
        }

        public static string SiteServiceSiteResolutionConfigFilespec
        {
            get { return Path.Combine(GetVixConfigurationDirectory(), SITE_SERVICE_SITE_RESOLUTION_FILENAME); }
        }

        public static string ExchangeDataSourceConfigFilespec
        {
            get { return Path.Combine(GetVixConfigurationDirectory(), EXCHANGE_DATA_SOURCE_FILENAME); }
        }

        public static string ExchangeCacheConfigFilespec
        {
            get { return Path.Combine(GetVixConfigurationDirectory(), EXCHANGE_CACHE_CONFIG_REL_FILESPEC); }
        }

        #endregion

        #region public methods
        /// <summary>
        /// Checks to see if a VIX is installed with all the required prerequisites.
        /// </summary>
        /// <returns>true if the VIX is installed, false otherwise</returns>
        public static bool IsVixInstalled()
        {
            bool isInstalled = false;

            //if (TomcatFacade.IsTomcatInstalled() == true && JavaFacade.IsJavaInstalled(isDeveloperMode) == true)
            if (TomcatFacade.IsTomcatInstalled() == true)
            {
                String vixPath = Path.Combine(TomcatFacade.TomcatWebApplicationFolder, @"VixServerHealthWebApp");
                if (Directory.Exists(vixPath) && IsVixConfigured())
                {
                    isInstalled = true;
                }
            }
            return isInstalled;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static bool IsVixConfigured()
        {
            bool isConfigured = false;

            String vixConfigDir = Environment.GetEnvironmentVariable("vixconfig", EnvironmentVariableTarget.Machine);
            if (vixConfigDir != null)
            {
                String vixConfigFilepath = Path.Combine(vixConfigDir, VIX_CONFIG_FILENAME);
                if (File.Exists(vixConfigFilepath))
                {
                    isConfigured = true;
                }
            }

            return isConfigured;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static bool IsFederationCertificateInstalledOrNotRequired(IVixConfigurationParameters config)
        {
            bool isVixCertificateInstalledOrNotRequired = false;
            string certStoreDir = VixFacade.GetVixCertificateStoreDir();
            string vixKeystoreFilepath = Path.Combine(certStoreDir, FEDERATION_KEYSTORE_FILENAME);
            string vixTruststoreFilepath = Path.Combine(certStoreDir, FEDERATION_TRUSTSTORE_FILENAME);

            //if (VixFacade.Manifest.MajorPatchNumber == 34)
            if (config.VixRole == VixRoleType.DicomGateway)
            {
                isVixCertificateInstalledOrNotRequired = true;
                Logger().Info("VIX Certificate not required.");
            }
            else if (File.Exists(vixKeystoreFilepath) && File.Exists(vixTruststoreFilepath))
            {
                isVixCertificateInstalledOrNotRequired = true;
                Logger().Info("VIX Certificate is installed.");
            }
            return isVixCertificateInstalledOrNotRequired;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static bool IsXcaCertificateInstalled()
        {
            bool isXcaCertificateInstalled = false;
            string certStoreDir = VixFacade.GetVixCertificateStoreDir();
            //string xcaKeystoreFilepath = Path.Combine(certStoreDir, XCA_KEYSTORE_FILENAME);
            //string xcaTruststoreFilepath = Path.Combine(certStoreDir, XCA_TRUSTSTORE_FILENAME);
            string xcaCertificateFilepath = Path.Combine(certStoreDir, XCA_CERTIFICATE_FILENAME);
            string xcaPrivateKeyFilepath = Path.Combine(certStoreDir, XCA_PRIVATE_KEY_FILENAME);

            //if (File.Exists(xcaKeystoreFilepath) && File.Exists(xcaTruststoreFilepath) && File.Exists(xcaCertificateFilepath) && File.Exists(xcaPrivateKeyFilepath))
            if (File.Exists(xcaCertificateFilepath) && File.Exists(xcaPrivateKeyFilepath))
            {
                isXcaCertificateInstalled = true;
            }

            return isXcaCertificateInstalled;
        }

        /// <summary>
        /// Install the VIX service. This is the method that acutally installs a VIX. It's what the wizard exists to support.
        /// </summary>
        /// <param name="isDeveloperMode"></param>
        public static void InstallVix(IVixConfigurationParameters config) //, bool isDeveloperMode)
        {
            // HDIG servers now have a certificate - needed for viewing encrypted log entries
            if (config.VixRole == VixRoleType.DicomGateway)
            {
                string certStoreDir = VixFacade.GetVixCertificateStoreDir();
                if (!Directory.Exists(certStoreDir))
                {
                    Directory.CreateDirectory(certStoreDir); // this must be done before ACLs are applied
                }
            }

            //determine patch number
            string fullVersionCurrent = config.ProductVersionProp;
            string[] versionPassArray = fullVersionCurrent.Split('.');
            string versionPassCurrent = versionPassArray[1];
            //determine prior patch number
            string fullVersionPrior;
            string versionPassPrior;
            if (config.PreviousProductVersionProp != null)
            {
                fullVersionPrior = config.PreviousProductVersionProp;
                string[] versionPassPriorArray = fullVersionPrior.Split('.');
                versionPassPrior = versionPassPriorArray[1];
            }
            else
            {
                fullVersionPrior = null;
                versionPassPrior = null;
            }

            //determine if for CVIX install or VIX
            string vixRoleTypePass = "";
            if (config.VixRole == VixRoleType.EnterpriseGateway)
            {
                vixRoleTypePass = "CVIX";
            }
            else
            {
                vixRoleTypePass = "VIX";
            }

            //VAI 1205 - create VixTxDb dir, for transcation log database
            string vixTxDbDefaultPath;
            if (config.VixTxDbDir != null)
            {
                vixTxDbDefaultPath = config.VixTxDbDir.Replace("/", @"\");
                try
                {
                    if (!Directory.Exists(vixTxDbDefaultPath))
                    {
                        Directory.CreateDirectory(vixTxDbDefaultPath);
                        Info("Created (#1) VixTxDb dir=" + vixTxDbDefaultPath);
                    }
                }
                catch (Exception ex)
                {
                    Info("Exception (#1) when creating vixTxDb path:" + ex.Message);
                }
            }
            else
            {
                //this is needed for P348 support for the GUI version since the create button already pressed in prior patch
                FileInfo fileCache = new FileInfo(config.LocalCacheDir.Replace("/", @"\"));
                string driveCache = Path.GetPathRoot(fileCache.FullName).ToUpper();
                vixTxDbDefaultPath = driveCache + VixFacade.VIX_TRANSACTION_LOGS_DB_DIRECTORY;
                try
                {
                    if (!Directory.Exists(vixTxDbDefaultPath))
                    {
                        Directory.CreateDirectory(vixTxDbDefaultPath);
                        Info("Created (#2) VixTxDb dir=" + vixTxDbDefaultPath);
                    }
                }
                catch (Exception ex)
                {
                    Info("Exception (#2) when creating vixTxDb path:" + ex.Message);
                }
                config.VixTxDbDir = vixTxDbDefaultPath.Replace(@"\", "/"); // config dir is stored with forward slash
            }

            // Run Silent PowerShell script to set permissions for VIX service account
            Info("Setting file system access rules.");
            BusinessFacade.RunSilentPSProcess(vixRoleTypePass, config.LocalCacheDir, config.VixTxDbDir);

            // Apply DAC for the ViX service account to the file system - HDIG DICOM directory only
            ApplyAccessControl(config);

            // set the ViX environment variables
            CreateEnvironmentVariables(config);

            // delete any deprecated files from a previous release
            DeleteDeprecatedDistributionFiles(config, true);

            // delete any deprecated directories from a previous release
            DeleteDeprecatedDistributionDirectories(config, true);

            // re-create tomcat-users.xml
            TomcatFacade.ConfigureTomcatUsers(config);

            if (config.VixRole == VixRoleType.SiteVix)
            {
                // Unregister any OCX dependencies
                UnregisterImageGearDependencyFiles(config);

                // Copy distribution files to target locations
                DeployImageGearDependencyFiles(config, true);

                // Register any OCX dependencies
                RegisterImageGearDependencyFiles(config);
            }

            // Copy distribution files to target locations
            DeployDependencyFiles(config, true);

            // deploy the web applications as dictated by the manifest and configuration parameters
            DeployVixWebApplications(config);

            // Copy distribution file that update the deployed web apps
            DeployWebAppDependencyFiles(config, true);

            // write ViX configuration files
            // this must come after manifest files are copied
            WriteViXConfigurationFiles(config); //, isDeveloperMode);

            // add the java properties needed to by the ViX to the Procrun environment
            ApplyVixJavaPropertiesFromManifest(config, true); // commit result

            // fixup Tomcat to point to the JVM specified in the manifest
            TomcatFacade.FixupTomcatServiceJvm();

            // prevent Tomcat Monitor from running at log in
            TomcatFacade.DisableTomcatMonitor();

            // for CVIX installs, deploy the vhasites.xml file that drives the site service to the 
            // VIX config directory.
            if (config.VixRole == VixRoleType.EnterpriseGateway && config.SitesFile != null)
            {
                DeploySitesFile(config);
            }

            // turn off Tomcat logging to Stdout
            TomcatFacade.DisableStdOutLogging();

            // fixup Tomcat JVM memory usage to correct case where more than 1G was being allocated for 32 bit process
            TomcatFacade.ConfigureTomcatJvmMemory(config);

            //set TCP Timeout
            TCPTimeoutInRegistry();

            //Run a Netsh command
            RunNetworkConfigurationCommand();

            // save the VIX installer configuration parameters for later use
            // this must go here because the WriteConfigurationFiles step changes the configuration.
            config.ToXml();

            if (manifest.ClearCache || manifest.ClearCacheIfPreviousVersion(config.PreviousProductVersionProp))
            {
                DeleteAllLocalCacheRegions(config);
            }

            // start the ViX if not running on a cluster
            switch (config.VixDeploymentOption)
            {
                case VixDeploymentType.FocClusterNode:
                    return;
            }

            //Reset Catalina.properties if it has been changed
            String tomcatConfPath = TomcatFacade.TomcatConfigurationFolder;
            if (HadCatalinaPropBeenChanged(tomcatConfPath))
                ResetCatalinaProp(tomcatConfPath);

            //1 used for start of install process 2 used for end of install process
            int installPassCase = 2;

            //Run process to create single line history of install process to track each install
            BusinessFacade.VIXBackupInstallHistory(fullVersionCurrent, fullVersionPrior, installPassCase);

            //Run process to delete the C:\VIXbackup\temp folder if exists
            BusinessFacade.VIXBackupDeleteTemp();

            //Run end of install process - use to to fix config files, ssl binding, and apachetomcat user checks
            BusinessFacade.RunStartOrEndOfInstallProcess(versionPassCurrent, versionPassPrior, installPassCase, vixRoleTypePass, config.ConfigCheck);

            Info("Starting the " + TomcatFacade.TomcatServiceName + " service.");
            ServiceUtilities.StartLocalService(TomcatFacade.TomcatServiceName);
            System.ServiceProcess.ServiceControllerStatus status;
            // wait for the ViX to start
            do
            {
                DoEvents();
                Thread.Sleep(500);
                status = ServiceUtilities.GetLocalServiceStatus(TomcatFacade.TomcatServiceName);
            }
            while (status == System.ServiceProcess.ServiceControllerStatus.StartPending);

            if (status == System.ServiceProcess.ServiceControllerStatus.Running)
            {
                Info("The " + TomcatFacade.TomcatServiceName + " service has been started.");

                //now start the Viewer and Render services.
                if (ZFViewerFacade.IsZFViewerInstalled())
                {
                    bool viewerStatus = ZFViewerFacade.StartZFViewerServices();
                    if (viewerStatus == false)
                    {
                        Info("The " + ZFViewerFacade.ViewerServiceAccountName + " could not be started.");
                    }
                }

                // VAI-480 - Turn off Listener
                ListenerFacade.ChangeListenerServiceType(); // Set Listener to Manual Startup

                //if (ListenerFacade.IsListenerInstalled())
                //{
                //    bool listenerStatus = ListenerFacade.StartListenerService();
                //    if (listenerStatus == false)
                //    {
                //        Info("The " + ListenerFacade.LISTENER_SERVICE_NAME + " could not be started.");
                     
                //    }
                //}
            }
            else
            {
                Info("The " + TomcatFacade.TomcatServiceName + " could not be started. The current status is " + status.ToString());
            }
        }

        public static void CopyCertificates(string certStoreDir, string prepCertPath)
        {
            if (prepCertPath.Contains("/"))
            {
                prepCertPath = prepCertPath.Replace(@"/", @"\");
            }

            string sourceVixKeystoreFilepath = Path.Combine(prepCertPath, FEDERATION_KEYSTORE_FILENAME);
            string sourceVixTruststoreFilepath = Path.Combine(prepCertPath, FEDERATION_TRUSTSTORE_FILENAME);

            string targetVixKeystoreFilepath = Path.Combine(certStoreDir, FEDERATION_KEYSTORE_FILENAME);
            string targetVixTruststoreFilepath = Path.Combine(certStoreDir, FEDERATION_TRUSTSTORE_FILENAME);

            if (File.Exists(sourceVixKeystoreFilepath) && !File.Exists(targetVixKeystoreFilepath))
            {
                File.Copy(sourceVixKeystoreFilepath, targetVixKeystoreFilepath);
            }

            if (File.Exists(sourceVixTruststoreFilepath) && !File.Exists(targetVixTruststoreFilepath))
            {
                File.Copy(sourceVixTruststoreFilepath, targetVixTruststoreFilepath);
            }
        }

        private static bool HadCatalinaPropBeenChanged(String conf)
        {
            String catalinaProp = conf + @"\catalina.properties";

            FileStream fs = new FileStream(catalinaProp, FileMode.OpenOrCreate, FileAccess.Read, FileShare.None);
            StreamReader sr = new StreamReader(fs);

            var line = "";
            var result = false;

            while ((line = sr.ReadLine()) != null)
            {
                if (line.Contains("tomcat.util.scan.StandardJarScanFilter.jarsToSkip=*.jar"))
                {
                    result = true;
                    break;
                }
            }

            fs.Close();
            return result;
        }

        private static void ResetCatalinaProp(String conf)
        {
            Console.WriteLine("\nReset " + conf + @"\Catalina.properties to scan new jars...");

            String catalinaProp = conf + @"\catalina.properties";
            String newCatalinaProp = conf + @"\newcatalina.properties";

            FileStream fs = new FileStream(catalinaProp, FileMode.OpenOrCreate, FileAccess.Read, FileShare.None);
            FileStream nfs = new FileStream(newCatalinaProp, FileMode.Create, FileAccess.Write, FileShare.None);

            StreamReader sr = new StreamReader(fs);
            StreamWriter sw = new StreamWriter(nfs);
            var line = "";

            while ((line = sr.ReadLine()) != null)
            {
                if (line.Contains("tomcat.util.scan.StandardJarScanFilter.jarsToSkip="))
                {
                    line = @"tomcat.util.scan.StandardJarScanFilter.jarsToSkip=\";
                }
                sw.WriteLine(line);
            }

            sw.Flush();
            fs.Close();
            nfs.Close();

            File.Delete(catalinaProp);
            File.Copy(newCatalinaProp, catalinaProp);
            File.Delete(newCatalinaProp);
        }



        /// <summary>
        /// Unregisters Image Gear dependency files.
        /// </summary>
        /// <remarks>At this time used to unregister Image Gear components</remarks>
        public static void UnregisterImageGearDependencyFiles(IVixConfigurationParameters config)
        {
            VixDependencyFile[] igFiles = Manifest.GetImageGearDependencyFiles(config);
            if (igFiles.Length > 0)
            {
                Info("Unregistering ImageGear files");
                foreach (VixDependencyFile igFile in igFiles)
                {
                    if (igFile.Register)
                    {
                        string igFilespec = igFile.GetAppFilespec();
                        if (File.Exists(igFilespec))
                        {
                            int exitCode = RegisterOrUnregisterOcx(igFilespec, false);
                            Info("Unregister file " + igFilespec + " : " + (exitCode == 0 ? "Success" : "Failure"));
                        }
                    }
                }
            }
            else
            {
                Info("ImageGear not installed - no files to unregister");
            }
        }

        /// <summary>
        /// Registers Image Gear dependency files.
        /// </summary>
        /// <remarks>At this time used to register Image Gear components</remarks>
        public static void RegisterImageGearDependencyFiles(IVixConfigurationParameters config)
        {
            VixDependencyFile[] igFiles = Manifest.GetImageGearDependencyFiles(config);
            if (igFiles.Length > 0)
            {
                Info("Registering ImageGear files");
                foreach (VixDependencyFile igFile in igFiles)
                {
                    if (igFile.Register)
                    {
                        string igFilespec = igFile.GetAppFilespec();
                        if (!File.Exists(igFilespec))
                        {
                            throw new Exception("Trying to register file which does not exist: " + igFilespec);
                        }
                        int exitCode = RegisterOrUnregisterOcx(igFilespec, true);
                        Info("Register file " + igFilespec + " : " + (exitCode == 0 ? "Success" : "Failure"));
                    }
                }
            }
        }

        /// <summary>
        /// Remove the web application traces associated with the web applications specified in the manifest. Note that
        /// it is not necessary to delete application contexts from server.xml because the contexts will be generated
        /// from scratch in the server.xml shell that is distributed with each ViX payload.
        /// </summary>
        /// <param name="config"></param>
        public static void UndeployVixWebApplications(IVixConfigurationParameters config)
        {
            if (TomcatFacade.IsTomcatInstalled() == false) // sanity check - could happen in JDK manual uninstall/reinstall scenerio
            {
                return;
            }

            VixWebApplication[] vixWebApplications = Manifest.VixWebApplications;

            foreach (VixWebApplication vixWebApplication in vixWebApplications)
            {
                if (vixWebApplication.IsAxis2WebApplication())
                {
                    continue;
                }
                Info("Uninstalling Web Application " + vixWebApplication.Path);
                UninstallWebApplication(config, vixWebApplication, true);
            }
            Info("All web applications have been uninstalled.");
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="config"></param>
        public static void DeployVixWebApplications(IVixConfigurationParameters config)
        {
            VixWebApplication[] vixWebApplications = Manifest.VixWebApplications;

            foreach (VixWebApplication vixWebApplication in vixWebApplications)
            {
                if (vixWebApplication.Option == VixWebApplicationOption.Remove)
                {
                    continue; // dont deploy web applications marked as remove
                }

                if (vixWebApplication.IsAxis2WebApplication())
                {
                    Info("Installing Axis2 Web Application " + vixWebApplication.War);
                    string sourceJarFileSpec = Path.Combine(TomcatFacade.TomcatWebApplicationFolder, vixWebApplication.War);
                    string targetJarFileSpec = Path.Combine(TomcatFacade.TomcatAxis2WebApplicationFolder, vixWebApplication.War);
                    File.Copy(sourceJarFileSpec, targetJarFileSpec);
                    File.Delete(sourceJarFileSpec);
                }
                else
                {
                    Info("Installing Web Application " + vixWebApplication.Path);
                    string warFileSpec = Path.Combine(TomcatFacade.TomcatWebApplicationFolder, vixWebApplication.War);
                    Debug.Assert(File.Exists(warFileSpec));

                    string pathFolder = vixWebApplication.Path.StartsWith("/") ? vixWebApplication.Path.Substring(1) : vixWebApplication.Path;
                    string webAppPathFolder = Path.Combine(TomcatFacade.TomcatWebApplicationFolder, pathFolder);
                    if (Directory.Exists(webAppPathFolder)) // safety net - should not happen
                    {
                        UninstallWebApplication(config, vixWebApplication, false);
                    }
                    Directory.CreateDirectory(webAppPathFolder);
                    ZipUtilities.ImprovedExtractToDirectory(warFileSpec, webAppPathFolder, ZipUtilities.Overwrite.Always);
                    File.Delete(warFileSpec); // delete the war so that it does not auto deploy
                }
            }

            AddWebAppContextElements(Path.Combine(TomcatFacade.TomcatConfigurationFolder, "server.xml"), config);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="serverXmlFilespec"></param>
        public static void AddWebAppContextElements(string serverXmlFilespec, IVixConfigurationParameters config)
        {
            Debug.Assert(File.Exists(serverXmlFilespec));
            XmlDocument xmlServerDom = new XmlDocument();
            xmlServerDom.Load(serverXmlFilespec);

            Logger().Info("Replacing connector for " + config.VixRole); // any info provided to the presentation layer will be logged.

            if (config.VixRole == VixRoleType.EnterpriseGateway)
            {
                XmlNode xmlHttpConnector = xmlServerDom.SelectSingleNode("Server/Service/Connector[@port='xxx']"); // Get port from config
                Debug.Assert(xmlHttpConnector != null);
                Logger().Info("Updating httpConnector with " + config.CvixHttpConnectorPort.ToString());
                UpdateHttpConnector(config, xmlHttpConnector);

                XmlNode xmlHttpsConnector = xmlServerDom.SelectSingleNode("Server/Service/Connector[@port='yyy']"); // Get port from config
                Debug.Assert(xmlHttpsConnector != null);
                Logger().Info("Updating httpsConnector with " + config.CvixHttpsConnectorPort.ToString());
                UpdateHttpsConnector(config, xmlHttpsConnector);

                //**** Xca is no longer used *** 
                //XmlNode xmlXcaConnector = null;
                //if (config.UseOpenSslForXCAConnector)
                //{
                // delete the connector that would be used with jsee
                //xmlXcaConnector = xmlServerDom.SelectSingleNode("Server/Service/Connector[@port='yyy']"); // Get port from config
                //Debug.Assert(xmlXcaConnector != null);
                //xmlXcaConnector.ParentNode.RemoveChild(xmlXcaConnector);
                //xmlXcaConnector = xmlServerDom.SelectSingleNode("Server/Service/Connector[@port='zzz']"); // Get port from config
                //Debug.Assert(xmlXcaConnector != null);
                //UpdateOpenSslXcaConnector(config, xmlXcaConnector);
                //}
                //else
                //    {
                // delete the connector that would be used with OpenSSL
                //xmlXcaConnector = xmlServerDom.SelectSingleNode("Server/Service/Connector[@port='zzz']"); // Get port from config
                //Debug.Assert(xmlXcaConnector != null);
                //xmlXcaConnector.ParentNode.RemoveChild(xmlXcaConnector);
                //xmlXcaConnector = xmlServerDom.SelectSingleNode("Server/Service/Connector[@port='yyy']"); // Get port from config
                //Debug.Assert(xmlXcaConnector != null);
                //UpdateXcaConnector(config, xmlXcaConnector);
                //}
            }
            else if (config.VixRole == VixRoleType.SiteVix || config.VixRole == VixRoleType.DicomGateway || config.VixRole == VixRoleType.MiniVix) // configure a SSL connector to be used java logs
            {
                XmlNode xmlHttpsConnector = xmlServerDom.SelectSingleNode("Server/Service/Connector[@port='443']");
                if (xmlHttpsConnector != null)
                {
                    UpdateVixHdigHttpsConnector(config, xmlHttpsConnector);
                }
            }
            ////else if (config.VixRole == VixRoleType.DicomGateway)
            ////{
            ////    XmlNode xmlHttpsConnector = xmlServerDom.SelectSingleNode("Server/Service/Connector[@port='443']");
            ////    if (xmlHttpsConnector != null)
            ////    {
            ////        UpdateHdigHttpsConnector(config, xmlHttpsConnector);
            ////    }
            ////}

            XmlNode xmlConnector = xmlServerDom.SelectSingleNode("Server/Service/Connector[@port='8443']");
            if (xmlConnector != null) // patch 34 doesnt have a federation interface
            {
                UpdateFederationConnector(config, xmlConnector);
            }

            XmlNode xmlNioConnector = xmlServerDom.SelectSingleNode("Server/Service/Connector[@port='8442']");
            if (xmlNioConnector != null) // patch 34 doesnt have a federation interface
            {
                UpdateFederationConnector(config, xmlNioConnector);
            }

            // update Engine element with default host name
            XmlNode xmlEngine = xmlServerDom.SelectSingleNode("Server/Service[@name='Catalina']/Engine");
            UpdateEngine(config, xmlEngine);

            // update Host element name attribute
            XmlNode xmlHost = xmlEngine.SelectSingleNode("./Host");
            UpdateHost(config, xmlHost);

            // update Realm element site information
            XmlNode xmlRealm = xmlHost.SelectSingleNode("./Realm");
            Logger().Info("Updating Catalina Service Engine");
            UpdateRealm(config, xmlRealm);

            // write context elements for each web application
            VixWebApplication[] vixWebApplications = Manifest.VixWebApplications;
            foreach (VixWebApplication vixWebApplication in vixWebApplications)
            {
                if (vixWebApplication.Option == VixWebApplicationOption.Remove)
                {
                    continue;
                }

                if (vixWebApplication.UseContextFolder == true)
                {
                    continue; // web app provides its own META-INF\context.xml - no context tag needed in server.xml
                }

                XmlElement xmlContext = CreateContext(config, xmlServerDom, vixWebApplication);
                xmlHost.InsertAfter(xmlContext, xmlRealm);
            }

            // configure the DicomSCPService service child elements if present
            xmlEngine = xmlServerDom.SelectSingleNode("Server/Service[@name='DicomSCPService']/Engine");
            if (xmlEngine != null)
            {
                // update Engine element with default host name
                UpdateEngine(config, xmlEngine);
                // update Realm element site information
                xmlRealm = xmlEngine.SelectSingleNode("./Realm");
                Logger().Info("Updating DicomSCPService Service Engine");
                UpdateRealm(config, xmlRealm);
                // update Host element name attribute
                xmlHost = xmlEngine.SelectSingleNode("./Host");
                UpdateHost(config, xmlHost);
            }

            // configure the PeriodicCommandService service child elements if present
            xmlEngine = xmlServerDom.SelectSingleNode("Server/Service[@name='PeriodicCommandService']/Engine");
            if (xmlEngine != null)
            {
                // update Engine element with default host name
                UpdateEngine(config, xmlEngine);
                // update Realm element site information
                xmlRealm = xmlEngine.SelectSingleNode("./Realm");
                Logger().Info("Updating PeriodicCommandService Service Engine");
                UpdateRealm(config, xmlRealm);
                // update Host element name attribute
                xmlHost = xmlEngine.SelectSingleNode("./Host");
                UpdateHost(config, xmlHost);
            }

            // configure the PeriodicCommandService service child elements if present
            xmlEngine = xmlServerDom.SelectSingleNode("Server/Service[@name='PeriodicROICommandService']/Engine");
            if (xmlEngine != null)
            {
                // update Engine element with default host name
                UpdateEngine(config, xmlEngine);
                // update Realm element site information
                xmlRealm = xmlEngine.SelectSingleNode("./Realm");
                Logger().Info("Updating PeriodicROICommandService Service Engine");
                UpdateRealm(config, xmlRealm);
                // update Host element name attribute
                xmlHost = xmlEngine.SelectSingleNode("./Host");
                UpdateHost(config, xmlHost);
            }

            xmlServerDom.Save(serverXmlFilespec);
        }
        //--------------------------------------------------------

        private static void UpdateFederationConnector(IVixConfigurationParameters config, XmlNode xmlConnector)
        {
            String s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), FEDERATION_KEYSTORE_FILENAME);
            String federationKeystorePath = s.Replace(@"\", "/");
            s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), FEDERATION_TRUSTSTORE_FILENAME);
            String federationTruststorePath = s.Replace(@"\", "/");

            xmlConnector.Attributes["keystoreFile"].Value = federationKeystorePath;
            xmlConnector.Attributes["keystorePass"].Value = config.FederationKeystorePassword;
            xmlConnector.Attributes["truststoreFile"].Value = federationTruststorePath;
            xmlConnector.Attributes["truststorePass"].Value = config.FederationTruststorePassword;
        }

        private static void UpdateVixHdigHttpsConnector(IVixConfigurationParameters config, XmlNode xmlConnector)
        {
            String s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), FEDERATION_KEYSTORE_FILENAME);
            String keystorePath = s.Replace(@"\", "/");

            xmlConnector.Attributes["keystoreFile"].Value = keystorePath;
            xmlConnector.Attributes["keystorePass"].Value = config.FederationKeystorePassword;
            xmlConnector.Attributes["keyAlias"].Value = "vixfederation";
        }

        ////private static void UpdateVixHttpsConnector(IVixConfigurationParameters config, XmlNode xmlConnector)
        ////{
        ////    String s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), FEDERATION_KEYSTORE_FILENAME);
        ////    String federationKeystorePath = s.Replace(@"\", "/");

        ////    xmlConnector.Attributes["keystoreFile"].Value = federationKeystorePath;
        ////    xmlConnector.Attributes["keystorePass"].Value = config.FederationKeystorePassword;
        ////}

        //private static void UpdateXcaConnector(IVixConfigurationParameters config, XmlNode xmlConnector)
        //{
        //    String s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), FEDERATION_KEYSTORE_FILENAME); //XCA_KEYSTORE_FILENAME);
        //    String xcaKeystorePath = s.Replace(@"\", "/");
        //    s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), FEDERATION_TRUSTSTORE_FILENAME); //XCA_TRUSTSTORE_FILENAME);
        //    String xcaTruststorePath = s.Replace(@"\", "/");

        //    xmlConnector.Attributes["port"].Value = config.XcaConnectorPort.ToString();
        //    xmlConnector.Attributes["keystoreFile"].Value = xcaKeystorePath;
        //    xmlConnector.Attributes["keystorePass"].Value = config.FederationKeystorePassword; // reusing federation credentials? Dont think it matters...
        //    xmlConnector.Attributes["truststoreFile"].Value = xcaTruststorePath;
        //    xmlConnector.Attributes["truststorePass"].Value = config.FederationTruststorePassword;  // reusing federation credentials? Dont think it matters...
        //}

        //private static void UpdateOpenSslXcaConnector(IVixConfigurationParameters config, XmlNode xmlConnector)
        //{
        //    String s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), XCA_CERTIFICATE_FILENAME);
        //    String xcaKeystorePath = s.Replace(@"\", "/");
        //    s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), XCA_PRIVATE_KEY_FILENAME);
        //    String xcaPrivateKeyPath = s.Replace(@"\", "/");

        //    xmlConnector.Attributes["port"].Value = config.XcaConnectorPort.ToString();
        //    xmlConnector.Attributes["SSLCertificateFile"].Value = xcaKeystorePath;
        //    xmlConnector.Attributes["SSLCertificateKeyFile"].Value = xcaPrivateKeyPath;
        //    //xmlConnector.Attributes["SSLPassword"].Value = config.FederationKeystorePassword; // reusing federation credentials? Dont think it matters...
        //}

        private static void UpdateHttpConnector(IVixConfigurationParameters config, XmlNode xmlConnector)
        {
            xmlConnector.Attributes["port"].Value = config.CvixHttpConnectorPort.ToString();
        }

        private static void UpdateHttpsConnector(IVixConfigurationParameters config, XmlNode xmlConnector)
        {
            xmlConnector.Attributes["port"].Value = config.CvixHttpsConnectorPort.ToString();
            String s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), FEDERATION_KEYSTORE_FILENAME);
            String keystorePath = s.Replace(@"\", "/");
            xmlConnector.Attributes["keystoreFile"].Value = keystorePath;
            xmlConnector.Attributes["keystorePass"].Value = config.FederationKeystorePassword;
            xmlConnector.Attributes["keyAlias"].Value = "vixfederation";
        }

        private static void UpdateEngine(IVixConfigurationParameters config, XmlNode xmlEngine)
        {
            string hostName = config.SiteNumber + ".med.va.gov";
            xmlEngine.Attributes["defaultHost"].Value = hostName;
        }

        private static void UpdateHost(IVixConfigurationParameters config, XmlNode xmlHost)
        {
            string hostName = config.SiteNumber + ".med.va.gov";
            xmlHost.Attributes["name"].Value = hostName;
        }

        /// <summary>
        /// Checks to see if the current server is a development CVIX. Very fragile!!!
        /// </summary>
        /// <param name="config"></param>
        /// <returns><c>true</c> if the current server is a development CVIX; <c>false</c> otherwise</returns>
        private static bool IsDevelopmentCvix(IVixConfigurationParameters config)
        {
            bool isDevCvix = false;
            if (config.VixRole == VixRoleType.EnterpriseGateway)
            {
                // fragile - must be updated as the test environment is updated - last update 9/25/2012
                if (config.VixServerNameProp.ToUpper() == "VHAISWIMMIXCVIX" || config.VixServerNameProp.ToUpper() == "VHAISWIMMIXVIX2" || config.VixServerNameProp.ToUpper() == "PRIV-DEVCVIX" ||
                    config.VixServerNameProp.ToUpper() == "PRIV-DICVIX" || config.VixServerNameProp.ToUpper() == "PRIV-RTCVIX" || config.VixServerNameProp.ToUpper() == "VHAISWSQACVIX" ||
                    /* Silver Spring Interagency CVIX servers */
                    config.VixServerNameProp.ToUpper() == "VHAISWIMGX64VIX" || config.VixServerNameProp.ToUpper() == "VHAISWIMMIXVIX9" ||
                    /* Martinsburg Interagency CVIX servers */
                    config.VixServerNameProp.ToUpper() == "VHACRBNODCVIX5" || config.VixServerNameProp.ToUpper() == "VHACRBNODCVIX6")
                {
                    isDevCvix = true;
                }
            }
            return isDevCvix;
        }

        /// <summary>
        /// Checks to see if the current server is a development interagency CVIX. Very fragile!!!
        /// </summary>
        /// <param name="config"></param>
        /// <returns><c>true</c> if the current server is a developement interagency CVIX; <c>false</c> otherwise</returns>
        private static bool IsDevelopmentInteragencyCvix(IVixConfigurationParameters config)
        {
            bool isInteragencyCvix = false;
            if (config.VixRole == VixRoleType.EnterpriseGateway)
            {
                // fragile - must be updated as the test environment is updated - last update 9/25/2012
                if (/* Silver Spring Interagency CVIX servers */
                    config.VixServerNameProp.ToUpper() == "VHAISWIMGX64VIX" || config.VixServerNameProp.ToUpper() == "VHAISWIMMIXVIX9" ||
                    /* Martinsburg Interagency CVIX servers */
                    config.VixServerNameProp.ToUpper() == "VHACRBNODCVIX5" || config.VixServerNameProp.ToUpper() == "VHACRBNODCVIX6")
                {
                    isInteragencyCvix = true;
                }
            }
            return isInteragencyCvix;
        }

        private static void UpdateRealm(IVixConfigurationParameters config, XmlNode xmlRealm)
        {
            Debug.Assert(xmlRealm != null);
            Debug.Assert(config != null);
            xmlRealm.Attributes["siteNumber"].Value = config.SiteNumber;
            xmlRealm.Attributes["siteAbbreviation"].Value = config.SiteAbbreviation;
            xmlRealm.Attributes["siteName"].Value = config.SiteName;
            xmlRealm.Attributes["vistaServer"].Value = config.VistaServerName;
            xmlRealm.Attributes["vistaPort"].Value = config.VistaServerPort;
            if (config.VixRole == VixRoleType.EnterpriseGateway && xmlRealm.Attributes["additionalUserRoles"] != null)
            {
                if (config.Station200UserName != null)
                {
                    xmlRealm.Attributes["additionalUserRoles"].Value = config.Station200UserName + ":xca,vista-user";
                    // set CPRS context to false in the test environment for now
                    if (config.Station200UserName.ToLower() == "testing_1" || config.Station200UserName.ToLower() == "boating1")
                    {
                        if (xmlRealm.Attributes["setCprsContext"] != null)
                        {
                            xmlRealm.Attributes["setCprsContext"].Value = "false"; // Perfrom local connection to VistA Imaging in Realm - true would mean perform a local VistA connection
                        }
                    }
                }
                if (IsDevelopmentCvix(config) == true && IsDevelopmentInteragencyCvix(config) == true)
                {
                    if (xmlRealm.Attributes["generateBseToken"] != null)
                    {
                        // Dont generate a BSE token because Station 200 token will not work with our test environment - CAPRI will be used instead.
                        xmlRealm.Attributes["generateBseToken"].Value = "false";
                    }
                }
            }
        }

        private static XmlElement CreateContext(IVixConfigurationParameters config, XmlDocument xmlServerDom, VixWebApplication vixWebApplication)
        {
            XmlElement xmlContext = xmlServerDom.CreateElement("Context");
            xmlContext.SetAttribute("cookies", "false");
            xmlContext.SetAttribute("crossContext", "false");
            xmlContext.SetAttribute("docBase", vixWebApplication.DocBase);
            xmlContext.SetAttribute("path", vixWebApplication.Path);
            xmlContext.SetAttribute("privileged", "false");
            xmlContext.SetAttribute("reloadable", "false");
            xmlContext.SetAttribute("useNaming", "true");
            return xmlContext;
        }

        //-------------------------------------

        /// <summary>
        /// Add or removes the java properties required by the ViX to the Tomcat Java environment.
        /// The only reason this method is public is for testing purposes.
        /// </summary>
        /// <returns>The set of Procrun Java properties that were added as part of the current installation.</returns>
        public static void ApplyVixJavaPropertiesFromManifest(IVixConfigurationParameters config, bool commit)
        {
            List<String> modifiedOptionsInfoList = new List<String>();
            string parametersKey = null;
            RegistryView regView = RegistryView.Registry64;
            if (BusinessFacade.Is64BitOperatingSystem())
            {
                parametersKey = @"SOFTWARE\Wow6432Node\Apache Software Foundation\Procrun 2.0\" + TomcatFacade.TomcatServiceName + @"\Parameters\Java";
            }
            else
            {
                parametersKey = @"SOFTWARE\Apache Software Foundation\Procrun 2.0\" + TomcatFacade.TomcatServiceName + @"\Parameters\Java";
            }

            using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
            {
                using (RegistryKey java = regKey.OpenSubKey(parametersKey, true))
                {
                    Debug.Assert(java.GetValueKind("Options") == RegistryValueKind.MultiString);
                    VixJavaProperty[] manifestVixJavaProperties = Manifest.GetManifestVixJavaProperties(config.ConfigDir);
                    Dictionary<String, VixJavaProperty> installedVixJavaProperties = GetInstalledViXJavaProperties((String[])java.GetValue("Options"));

                    foreach (VixJavaProperty manifestViXJavaProperty in manifestVixJavaProperties)
                    {
                        // kludge - must fix up jcifs property file location with the selection ViX configuration folder
                        //if (manifestViXJavaProperty.Name == "jcifs.properties" && Manifest.VixIteration > 6)
                        //{
                        //    manifestViXJavaProperty.Value = Path.Combine(config.ConfigDir, manifestViXJavaProperty.Value);
                        //}

                        if (manifestViXJavaProperty.Option == VixJavaPropertyOption.AddUpdate)
                        {
                            if (installedVixJavaProperties.ContainsKey(manifestViXJavaProperty.Name))
                            {
                                VixJavaProperty installedViXJavaProperty = installedVixJavaProperties[manifestViXJavaProperty.Name];
                                if (installedViXJavaProperty.Value != manifestViXJavaProperty.Value)
                                {
                                    modifiedOptionsInfoList.Add(installedViXJavaProperty.Name + " changed from " +
                                        installedViXJavaProperty.Value + " to " + manifestViXJavaProperty.Value);
                                    installedViXJavaProperty.Value = manifestViXJavaProperty.Value;
                                }
                            }
                            else
                            {
                                if (string.IsNullOrEmpty(manifestViXJavaProperty.Value))
                                {
                                    modifiedOptionsInfoList.Add(manifestViXJavaProperty.Name + " has been added");
                                }
                                else
                                {
                                    modifiedOptionsInfoList.Add(manifestViXJavaProperty.Name + "=" + manifestViXJavaProperty.Value
                                    + " has been added");
                                }

                                installedVixJavaProperties.Add(manifestViXJavaProperty.Name, manifestViXJavaProperty);
                            }
                        }
                        else if (manifestViXJavaProperty.Option == VixJavaPropertyOption.Remove)
                        {
                            if (installedVixJavaProperties.ContainsKey(manifestViXJavaProperty.Name))
                            {
                                modifiedOptionsInfoList.Add(manifestViXJavaProperty.Name + "=" + manifestViXJavaProperty.Value
                                    + " has been removed");
                                installedVixJavaProperties.Remove(manifestViXJavaProperty.Name);
                            }
                        }
                    }

                    if (modifiedOptionsInfoList.Count > 0)
                    {
                        Info("Procrun JVM environment options have been changed");
                        if (commit == true)
                        {
                            modifiedOptionsInfoList.Add("Updated Procrun JVM options are as follows:");
                        }
                        else
                        {
                            modifiedOptionsInfoList.Add("Procrun JVM options that would be written (commit = false):");
                        }
                        List<String> optionsList = new List<String>();
                        foreach (String key in installedVixJavaProperties.Keys)
                        {
                            if (string.IsNullOrEmpty(installedVixJavaProperties[key].Value))
                            {
                                optionsList.Add(installedVixJavaProperties[key].Prefix + installedVixJavaProperties[key].Name);
                            }
                            else
                            {
                                optionsList.Add(installedVixJavaProperties[key].ToString());
                            }
                        }
                        modifiedOptionsInfoList.AddRange(optionsList);
                        if (commit == true)
                        {
                            java.SetValue("Options", optionsList.ToArray());
                        }
                        foreach (String option in modifiedOptionsInfoList)
                        {
                            Info(option);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Reformats a passed array of java property strings as used by Procrun to establish Tomcat Java environment
        /// as a Dictionary of VixJavaProperty objects.
        /// The only reason this method is public is for testing purposes.
        /// </summary>
        /// <param name="propertyList">The array of Java properties expressed as command line paramaters (i.e. -Dparameter=value)</param>
        /// <returns>Returns a Dictionary of Java properties as VixJavaProperty objects keyed by name</returns>
        public static Dictionary<String, VixJavaProperty> GetInstalledViXJavaProperties(String[] propertyList)
        {
            Dictionary<String, VixJavaProperty> vixJavaProperties = new Dictionary<String, VixJavaProperty>();
            string prefix = null;
            int prefixLength = 0;
            foreach (String property in propertyList)
            {
                if (property == "")
                {
                    continue;
                }
                //Debug.Assert(property.StartsWith("-D") || property.StartsWith("-X"));
                if (property.StartsWith("-D"))
                {
                    prefix = "-D";
                    prefixLength = 2;
                }
                else if (property.StartsWith("-XX"))
                {
                    prefix = "-XX:";
                    prefixLength = 4;
                }
                else if (property.StartsWith("-X"))
                {
                    prefix = "-X";
                    prefixLength = 2;
                }
                else if (property.StartsWith("-java"))
                {
                    prefix = "-j";
                    prefixLength = 0;
                }
                else
                {
                    throw new Exception("Unexpected prefix in Java property - was expecting -D or -XX: or -j or -X " + property);
                }

                String s = property.Substring(prefixLength);
                String[] splits = s.Split('=');
                string name = splits[0].Trim();
                string value = null;
                if (splits.Length >= 2)
                {
                    value = splits[1].Trim();
                    if (splits.Length > 2)
                    {
                        for (int i = 2; i < splits.Length; i++)
                        {
                            value += "=" + splits[i];
                        }
                        value = value.Trim();
                    }
                }

                VixJavaProperty installedVixJavaProperty = new VixJavaProperty(VixJavaPropertyOption.Installed, prefix, name, value, null);

                if (!vixJavaProperties.ContainsKey(installedVixJavaProperty.Name))
                {
                    vixJavaProperties.Add(installedVixJavaProperty.Name, installedVixJavaProperty);
                }
            }

            return vixJavaProperties;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GetVixConfigurationDirectory()
        {
            String vixConfigDir = null;
            String vixconfig = Environment.GetEnvironmentVariable("vixconfig", EnvironmentVariableTarget.Machine);
            if (vixconfig != null)
            {
                vixConfigDir = vixconfig.Replace("/", @"\"); // translate file system delimiter back from Java forward slash
            }
            return vixConfigDir;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static String GetLocalVixCacheDirectory()
        {
            String vixCacheDir = null;
            String vixcache = Environment.GetEnvironmentVariable("vixcache", EnvironmentVariableTarget.Machine);
            if (vixcache != null)
            {
                vixCacheDir = vixcache.Replace("/", @"\"); // translate file system delimiter back from Java forward slash
            }
            return vixCacheDir;
        }

        /// <summary>
        /// This method searches for an existing VIX configuration file in a clustered install and returns the directory where the configuration resides
        /// </summary>
        /// <returns>The directory where the configuration resides if found, null otherwise</returns>
        public static string GetExistingFocVixConfigurationDir()
        {
            Debug.Assert(ClusterFacade.IsServerClusterNode());
            DriveInfo[] drives = GetConfigDrives();

            foreach (DriveInfo drive in drives)
            {
                string configDir = Path.Combine(drive.Name, VixFacade.VIX_CONFIG_DIRECTORY);
                string filespec = Path.Combine(configDir, VIX_CONFIG_FILENAME);
                if (File.Exists(filespec))
                {
                    return configDir;
                }
            }

            return null;
        }

        /// <summary>
        /// Returns a list of local drives that can be used for a local VIX cache or configuration based on DeploymentType
        /// </summary>
        /// <param name="deploymentType"></param>
        /// <returns></returns>
        public static DriveInfo[] GetConfigDrives()
        {
            List<DriveInfo> drives = new List<DriveInfo>();

            foreach (DriveInfo drive in FileSystem.Drives)
            {
                if (drive.IsReady && drive.DriveType == DriveType.Fixed)
                {
                    if (IsDriveOkForDeployment(drive))
                    {
                        drives.Add(drive);
                    }
                }
            }
            Debug.Assert(drives.Count > 0);
            return drives.ToArray();
        }

        /// <summary>
        /// Returns a list of local drives that can be used for a local VIX cache or configuration based on DeploymentType
        /// </summary>
        /// <param name="deploymentType"></param>
        /// <returns></returns>
        public static DriveInfo[] GetCacheDrives(VixDeploymentType deploymentType, VixCacheType cacheType, int cacheSizeInGB)
        {
            List<DriveInfo> drives = new List<DriveInfo>();

            foreach (DriveInfo drive in FileSystem.Drives)
            {
                if (drive.IsReady && drive.DriveType == DriveType.Fixed)
                {
                    if (cacheType == VixCacheType.ExchangeTimeStorageEvictionLocalFilesystem && drive.AvailableFreeSpace < (cacheSizeInGB * ONE_GIGBYTE))
                    {
                        continue;
                    }

                    if (IsDriveOkForDeployment(drive))
                    {
                        drives.Add(drive);
                    }
                }
            }
            Debug.Assert(drives.Count > 0);
            return drives.ToArray();
        }

        public static DriveInfo[] GetCacheAllDrives(VixDeploymentType deploymentType, VixCacheType cacheType, int cacheSizeInGB)
        {
            List<DriveInfo> drives = new List<DriveInfo>();

            foreach (DriveInfo drive in DriveInfo.GetDrives())
            {
                if (drive.IsReady)
                    drives.Add(drive);
            }
            Debug.Assert(drives.Count > 0);
            return drives.ToArray();
        }

        public static DriveInfo[] GetArchivedLogsAllDrives()
        {
            List<DriveInfo> drives = new List<DriveInfo>();

            foreach (DriveInfo drive in DriveInfo.GetDrives())
            {
                if (drive.IsReady)
                    drives.Add(drive);
            }
            Debug.Assert(drives.Count > 0);
            return drives.ToArray();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static String GetDefaultLocalVixCacheDrive(VixDeploymentType deploymentType, VixCacheType cacheType, int cacheSizeInGB)
        {
            String vixCacheDrive = null;
            DriveInfo mostFreeSpace = null;
            Info("GetDefaultLocalVixCacheDrive:");

            foreach (DriveInfo drive in FileSystem.Drives)
            {
                if (drive.IsReady && drive.DriveType == DriveType.Fixed)
                {
                    if (IsDriveOkForDeployment(drive))
                    {
                        // dont recommend the quorum drive as the default (but allow it)
                        if (ClusterFacade.IsClusterQuorumDrive(drive))
                        {
                            Info("Drive " + drive.Name + " is quorum drive - skipping");
                            continue;
                        }

                        if (cacheType == VixCacheType.ExchangeTimeStorageEvictionLocalFilesystem && drive.AvailableFreeSpace < (cacheSizeInGB * ONE_GIGBYTE))
                        {
                            Info("Drive " + drive.Name + " has less than " + cacheSizeInGB.ToString() + " free space - skipping");
                            continue;
                        }

                        if (mostFreeSpace == null || drive.TotalFreeSpace > mostFreeSpace.TotalFreeSpace)
                        {
                            mostFreeSpace = drive;
                            Info("Drive " + drive.Name + " is a candidate");
                        }
                    }
                }
            }

            Debug.Assert(mostFreeSpace != null);
            vixCacheDrive = mostFreeSpace.Name.ToUpper();
            return vixCacheDrive;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static String GetFullyQuaifiedHdigDicomDirectory()
        {
            Info("GetFullyQuaifiedHdigDicomDirectory: ");

            foreach (DriveInfo drive in FileSystem.Drives)
            {
                if (drive.IsReady && drive.DriveType == DriveType.Fixed)
                {
                    string dicomDirectory = drive.Name + VixFacade.HDIG_DICOM_DIRECTORY;
                    if (Directory.Exists(dicomDirectory))
                    {
                        Info("\tFound " + dicomDirectory);
                        return dicomDirectory;
                    }
                }
            }

            Info("\tFound null");
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="deploymentType"></param>
        /// <param name="cacheType"></param>
        /// <param name="cacheSizeInGB"></param>
        /// <returns></returns>
        public static String GetDefaultVixConfigDrive(VixDeploymentType deploymentType, VixCacheType cacheType, int cacheSizeInGB)
        {
            if (deploymentType == VixDeploymentType.SingleServer)
            {
                String systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper() + @"\";
                return systemDrive;
            }
            else
            {
                return GetDefaultLocalVixCacheDrive(deploymentType, cacheType, cacheSizeInGB);
            }
        }

        /// <summary>
        ///  Returns the directory where the VIX keystore and truststore files will go.
        /// </summary>
        /// <returns></returns>
        public static String GetVixCertificateStoreDir()
        {
            String systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper() + @"\";
            return Path.Combine(systemDrive, VIX_CERTSTORE_DIRECTORY);
        }


        public static void DeleteLocalCacheRegions(IVixConfigurationParameters config)
        {
            Logger().Info(Info("Deleting files from the local VIX cache."));
            Info("This may take several minutes - please be patient.");
            string baseCacheDir = config.LocalCacheDir.Replace("/", @"\");
            DeleteCacheRegion(baseCacheDir, DOD_METADATA_REGION);
            DeleteCacheRegion(baseCacheDir, DOD_IMAGE_REGION);
            DeleteCacheRegion(baseCacheDir, VA_METADATA_REGION);
            DeleteCacheRegion(baseCacheDir, VA_IMAGE_REGION);
            Info("The VIX cache has been cleared.");
        }
        public static class NativeMethods
        {
            private static readonly IntPtr INVALID_HANDLE_VALUE = new IntPtr(-1);

            private const uint FILE_READ_EA = 0x0008;
            private const uint FILE_FLAG_BACKUP_SEMANTICS = 0x2000000;

            [DllImport("Kernel32.dll", SetLastError = true, CharSet = CharSet.Auto)]
            static extern uint GetFinalPathNameByHandle(IntPtr hFile, [MarshalAs(UnmanagedType.LPTStr)] StringBuilder lpszFilePath, uint cchFilePath, uint dwFlags);

            [DllImport("kernel32.dll", SetLastError = true)]
            [return: MarshalAs(UnmanagedType.Bool)]
            static extern bool CloseHandle(IntPtr hObject);

            [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
            public static extern IntPtr CreateFile(
                    [MarshalAs(UnmanagedType.LPTStr)] string filename,
                    [MarshalAs(UnmanagedType.U4)] uint access,
                    [MarshalAs(UnmanagedType.U4)] FileShare share,
                    IntPtr securityAttributes, // optional SECURITY_ATTRIBUTES struct or IntPtr.Zero
                    [MarshalAs(UnmanagedType.U4)] FileMode creationDisposition,
                    [MarshalAs(UnmanagedType.U4)] uint flagsAndAttributes,
                    IntPtr templateFile);

            public static string GetFinalPathName(string path)
            {
                var h = CreateFile(path,
                    FILE_READ_EA,
                    FileShare.ReadWrite | FileShare.Delete,
                    IntPtr.Zero,
                    FileMode.Open,
                    FILE_FLAG_BACKUP_SEMANTICS,
                    IntPtr.Zero);
                try
                {
                    var sb = new StringBuilder(1024);
                    var res = GetFinalPathNameByHandle(h, sb, 1024, 0);
                    return sb.ToString();
                }
                finally
                {
                    CloseHandle(h);
                }
            }
        }

        #endregion

        #region private utility methods

        /// <summary>
        /// Recursively remove read only attributes from all files in the specified folder and its subfolders.
        /// </summary>
        /// <param name="parentFolder">The parent folder.</param>
        /// <remarks></remarks>
        static private void RemoveReadOnlyAttributes(String parentFolder)
        {
            String[] folders = Directory.GetDirectories(parentFolder);
            long folderCount = folders.Length;

            DirectoryInfo parentFolderInfo = new DirectoryInfo(parentFolder);
            foreach (FileInfo fileInfo in parentFolderInfo.GetFiles())
            {
                File.SetAttributes(fileInfo.FullName, FileAttributes.Normal);
            }

            foreach (String folder in folders)
            {
                RemoveReadOnlyAttributes(folder);
            }
        }

        /// <summary>
        /// Registers the or unregisters an ocx file
        /// </summary>
        /// <param name="ocxFilespec">The ocx filespec to register or unregusrer.</param>
        /// <param name="register">if set to <c>true</c> [register]; <c>false</c> [unregister].</param>
        /// <returns>command processor exit code where 0 is success</returns>
        /// <remarks></remarks>
        private static int RegisterOrUnregisterOcx(string ocxFilespec, bool register)
        {
            int exitCode = 0; // external process executed ok - command shell convention

            using (Process externalProcess = new Process())
            {
                externalProcess.StartInfo.FileName = "regsvr32";
                externalProcess.StartInfo.Arguments = (register ? "/s" : "/s /u") + " " + ocxFilespec;
                externalProcess.StartInfo.WorkingDirectory = Path.GetDirectoryName(ocxFilespec); ;
                externalProcess.StartInfo.UseShellExecute = false;
                externalProcess.StartInfo.CreateNoWindow = true;
                externalProcess.Start();

                try
                {
                    do
                    {
                        DoEvents();
                        Thread.Sleep(500);
                        externalProcess.Refresh();
                    } while (!externalProcess.HasExited);
                    exitCode = externalProcess.ExitCode;
                }
                finally
                {
                    externalProcess.Close();
                }
            }

            return exitCode;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="deploymentType"></param>
        /// <returns></returns>
        private static bool IsDriveOkForDeployment(DriveInfo drive)
        {
            bool isDriveOk = true;
            String systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper() + @"\";

            try
            {
                if (drive.DriveType == DriveType.Fixed && drive.IsReady == true)
                {
                    if (drive.Name.ToUpper() == systemDrive) // for FOC clusters, system drive is not shared
                    {
                        if (ClusterFacade.IsServerClusterNode())
                        {
                            isDriveOk = false;
                        }
                    }
                }
                else
                {
                    isDriveOk = false;
                }
            }
            catch (Exception ex)
            {
                Info(ex.Message);
                isDriveOk = false;
            }
            //finally
            //{
            //    Info(drive.Name + (isDriveOk ? " is OK for cache or config files" : "is not OK for cache or config files"));
            //}

            return isDriveOk;
        }

        /// <summary>
        /// A helper method to wrap the infoDelegate member, which if non null provide a way to report status to the 
        /// user interface.
        /// </summary>
        /// <param name="infoMessage">message to display in the user interface.</param>
        /// <returns>the message string passed in the infoMessage parameter to support chaining.</returns>
        private static String Info(String infoMessage)
        {
            if (infoDelegate != null)
            {
                infoDelegate(infoMessage);
            }
            Logger().Info(infoMessage); // any info provided to the presentation layer will be logged.
            return infoMessage;
        }

        /// <summary>
        /// 
        /// </summary>
        private static void DoEvents()
        {
            if (appEventsDelegate != null)
            {
                appEventsDelegate();
            }
        }

        /// <summary>
        /// Retrieve a logger for this class.
        /// </summary>
        /// <returns>A logger as a ILog interface.</returns>
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(VixFacade).Name);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="filename"></param>
        /// <param name="targetDir"></param>
        private static void DeleteHelper(String filename, String targetDir)
        {
            String targetPath = Path.Combine(targetDir, filename);
            if (File.Exists(targetPath))
            {
                Info("Deleting deprecated file " + targetPath);
                File.Delete(targetPath);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="commandParameters"></param>
        /// <param name="payloadPath"></param>
        /// <param name="config"></param>
        private static string RunJavaUtility(String commandParameters, IVixConfigurationParameters config)
        {
            string payloadJar = Path.Combine(VixFacade.Manifest.PayloadPath, @"server\jars");
            string javaExeFilespec = Path.Combine(JavaFacade.GetActiveJavaPath(JavaFacade.IsActiveJreInstalled()), @"bin\java.exe");
            string processOutput = "";

            using (Process externalProcess = new Process())
            {
                externalProcess.StartInfo.FileName = javaExeFilespec;
                externalProcess.StartInfo.Arguments = commandParameters;
                externalProcess.StartInfo.WorkingDirectory = payloadJar;
                externalProcess.StartInfo.UseShellExecute = false;
                externalProcess.StartInfo.CreateNoWindow = true; // DKB - 5/25/10
                externalProcess.StartInfo.RedirectStandardOutput = true;
                if (externalProcess.StartInfo.EnvironmentVariables.ContainsKey("vixconfig"))
                {
                    externalProcess.StartInfo.EnvironmentVariables.Remove("vixconfig");
                }
                externalProcess.StartInfo.EnvironmentVariables.Add("vixconfig", config.ConfigDir);
                if (externalProcess.StartInfo.EnvironmentVariables.ContainsKey("vixcache"))
                {
                    externalProcess.StartInfo.EnvironmentVariables.Remove("vixcache");
                }
                externalProcess.StartInfo.EnvironmentVariables.Add("vixcache", config.LocalCacheDir);
                if (externalProcess.StartInfo.EnvironmentVariables.ContainsKey("vixtxdb"))
                {
                    externalProcess.StartInfo.EnvironmentVariables.Remove("vixtxdb");
                }
                externalProcess.StartInfo.EnvironmentVariables.Add("vixtxdb", config.VixTxDbDir);

                //do not log parameters as it is redundant
                Logger().Info(payloadJar + " " + javaExeFilespec);

                externalProcess.Start();
                processOutput = externalProcess.StandardOutput.ReadToEnd();

                try
                {
                    do
                    {
                        DoEvents();
                        Thread.Sleep(500);
                        externalProcess.Refresh();
                    } while (!externalProcess.HasExited);
                    //exitCode = externalProcess.ExitCode;
                }
                finally
                {
                    externalProcess.Close();
                }
            }

            return processOutput;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="config"></param>
        /// <param name="payloadPath"></param>
        public static void DeployDependencyFiles(IVixConfigurationParameters config, bool commit)
        {
            VixDependencyFile[] vixDependencyFiles = Manifest.GetDependencyFiles(config);
            NativeType native = manifest.CurrentNativeInstallation;

            if (vixDependencyFiles.Length > 0)
            {
                Info("Copying distribution files...");
            }
            foreach (VixDependencyFile vixDependencyFile in vixDependencyFiles)
            {
                if (commit == true)
                {
                    if (vixDependencyFile.DependencyType == VixDependencyType.ZipConfigFile)
                    {
                        Info("Unzipping " + vixDependencyFile.GetPayloadFilespec() + " to " + vixDependencyFile.GetAppFolder());
                        ZipUtilities.ImprovedExtractToDirectory(vixDependencyFile.GetPayloadFilespec(), vixDependencyFile.GetAppFolder(), ZipUtilities.Overwrite.Always);
                    }
                    else if (vixDependencyFile.Native == NativeType.all || vixDependencyFile.Native == native)
                    {
                        if (File.Exists(vixDependencyFile.GetAppFilespec()))
                        {
                            if (vixDependencyFile.Option == VixConfigFileOption.Remove)
                            {
                                Info("Deleting " + vixDependencyFile.GetAppFilespec());
                                File.Delete(vixDependencyFile.GetAppFilespec());
                            }
                            else if (vixDependencyFile.Option == VixConfigFileOption.DoNotCopyIfExist)
                            {
                                Info("Skipping " + vixDependencyFile.GetPayloadFilespec() + ", dependency file option: " + VixConfigFileOption.DoNotCopyIfExist);
                            }
                            else
                            {
                                File.SetAttributes(vixDependencyFile.GetAppFilespec(), FileAttributes.Normal);
                                Info("Copying " + vixDependencyFile.GetPayloadFilespec() + " to " + vixDependencyFile.GetAppFilespec());
                                File.Delete(vixDependencyFile.GetAppFilespec());
                                File.Copy(vixDependencyFile.GetPayloadFilespec(), vixDependencyFile.GetAppFilespec());
                            }
                        }
                        else
                        {
                            Info("Copying " + vixDependencyFile.GetPayloadFilespec() + " to " + vixDependencyFile.GetAppFilespec());
                            File.Copy(vixDependencyFile.GetPayloadFilespec(), vixDependencyFile.GetAppFilespec());
                        }
                    }
                    else
                    {
                        Info("Skipping " + vixDependencyFile.Native + " dependency " + vixDependencyFile.GetPayloadFilespec());
                    }
                }
            }

            if (!config.IsPatch)
            {
                String payloadProperties = Path.Combine(VixFacade.Manifest.PayloadPath, @"server/properties");
                if (commit == true)
                {
                    Logger().Info("Log4j version: " + VixFacade.Manifest.Log4jVersion);
                    if (VixFacade.Manifest.Log4jVersion == 2)
                    {
                        RewriteLoggingPropertiesFile(payloadProperties, "log4j2.xml", VixFacade.GetVixConfigurationDirectory(), config);
                    }
                    else
                    {
                        RewriteLoggingPropertiesFile(payloadProperties, "log4j.properties", VixFacade.GetVixConfigurationDirectory(), config);
                    }
                }
            }
        }


        public static void DeployWebAppDependencyFiles(IVixConfigurationParameters config, bool commit)
        {
            VixDependencyFile[] vixDependencyFiles = Manifest.GetWebAppDependencyFiles(config);
            NativeType native = manifest.CurrentNativeInstallation;

            if (vixDependencyFiles.Length > 0)
            {
                Info("Copying web application distribution files...");
            }
            foreach (VixDependencyFile vixDependencyFile in vixDependencyFiles)
            {
                if (commit == true)
                {
                    if (vixDependencyFile.DependencyType == VixDependencyType.ZipConfigFile)
                    {
                        Info("Unzipping " + vixDependencyFile.GetPayloadFilespec() + " to " + vixDependencyFile.GetAppFolder());
                        ZipUtilities.ImprovedExtractToDirectory(vixDependencyFile.GetPayloadFilespec(), vixDependencyFile.GetAppFolder(), ZipUtilities.Overwrite.Always);
                    }
                    else if (vixDependencyFile.Native == NativeType.all || vixDependencyFile.Native == native)
                    {
                        Info("Copying " + vixDependencyFile.GetPayloadFilespec() + " to " + vixDependencyFile.GetAppFilespec());
                        if (File.Exists(vixDependencyFile.GetAppFilespec()))
                        {
                            File.SetAttributes(vixDependencyFile.GetAppFilespec(), FileAttributes.Normal);
                        }
                        File.Delete(vixDependencyFile.GetAppFilespec()); // handles read only file
                        File.Copy(vixDependencyFile.GetPayloadFilespec(), vixDependencyFile.GetAppFilespec());
                    }
                    else
                    {
                        Info("Skipping " + vixDependencyFile.Native + " dependency " + vixDependencyFile.GetPayloadFilespec());
                    }
                }
            }
        }

        public static void DeployImageGearDependencyFiles(IVixConfigurationParameters config, bool commit)
        {
            VixDependencyFile[] vixDependencyFiles = Manifest.GetImageGearDependencyFiles(config);

            if (vixDependencyFiles.Length > 0)
            {
                Info("Copying web application distribution files...");
            }
            foreach (VixDependencyFile vixDependencyFile in vixDependencyFiles)
            {
                if (commit == true)
                {
                    if (vixDependencyFile.DependencyType == VixDependencyType.ZipConfigFile)
                    {
                        Info("Unzipping " + vixDependencyFile.GetPayloadFilespec() + " to " + vixDependencyFile.GetAppFolder());

                        ZipUtilities.ImprovedExtractToDirectory(vixDependencyFile.GetPayloadFilespec(), vixDependencyFile.GetAppFolder(), ZipUtilities.Overwrite.Always);
                    }
                    else
                    {
                        Info("Copying " + vixDependencyFile.GetPayloadFilespec() + " to " + vixDependencyFile.GetAppFilespec()); // side effect - creates folder if necessary
                        if (File.Exists(vixDependencyFile.GetAppFilespec()))
                        {
                            File.SetAttributes(vixDependencyFile.GetAppFilespec(), FileAttributes.Normal);
                        }
                        File.Delete(vixDependencyFile.GetAppFilespec()); // handles read only file
                        File.Copy(vixDependencyFile.GetPayloadFilespec(), vixDependencyFile.GetAppFilespec());
                    }
                }
            }
        }

        public static void DeleteDeprecatedDistributionFiles(IVixConfigurationParameters config, bool commit)
        {
            VixDeprecatedFile[] vixDeprecatedFiles = Manifest.GetDeprecatedFiles(config);

            Info("Deleting deprecated files...");
            foreach (VixDeprecatedFile vixDeprecatedFile in vixDeprecatedFiles)
            {
                if (File.Exists(vixDeprecatedFile.GetAppFilespec()))
                {
                    Info("Deleting " + vixDeprecatedFile.GetAppFilespec());
                    if (commit == true)
                    {
                        File.Delete(vixDeprecatedFile.GetAppFilespec());
                    }
                }
            }
        }

        public static VixDependencyFile[] FilterFilesByType(VixDependencyFile[] vixDependencyFiles, IVixConfigurationParameters config, VixDependencyType vixDependencyType)
        {
            List<VixDependencyFile> filteredFiles = new List<VixDependencyFile>();

            foreach (VixDependencyFile vixDependencyFile in vixDependencyFiles)
            {
                if (vixDependencyFile.DependencyType == vixDependencyType)
                {
                    filteredFiles.Add(vixDependencyFile);
                }
            }
            return filteredFiles.ToArray();
        }

        public static void DeleteDeprecatedDistributionDirectories(IVixConfigurationParameters config, bool commit)
        {
            VixDeprecatedDirectory[] vixDeprecatedDirectories = Manifest.GetDeprecatedDirectories(config);

            Info("Deleting deprecated directories...");
            foreach (VixDeprecatedDirectory vixDeprecatedDirectory in vixDeprecatedDirectories)
            {
                if (Directory.Exists(vixDeprecatedDirectory.GetDirectoryPath()))
                {
                    Info("Deleting " + vixDeprecatedDirectory.GetDirectoryPath());
                    if (commit == true)
                    {
                        Directory.Delete(vixDeprecatedDirectory.GetDirectoryPath(), true); // recursive delete
                    }
                }
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="config"></param>
        /// <param name="payloadPath"></param>
        /// <param name="isDeveloperMode"></param>
        public static void WriteViXConfigurationFiles(IVixConfigurationParameters config) //, bool isDeveloperMode)
        {
            VixJavaConfigurationUtility[] vixConfigUtilites = Manifest.JavaConfigurationUtilityProperties;

            foreach (VixJavaConfigurationUtility configUtility in vixConfigUtilites)
            {
                ExecuteConfigurationUtility(configUtility, config);
            }
        }

        public static string ReadViXConfigurationFiles(IVixConfigurationParameters config, string commandParamJar, string commandParamPackage) //, bool isDeveloperMode)
        {
            Logger().Info("Reading config file using " + commandParamJar);
            StringBuilder sbd = new StringBuilder();
            string logPropertiesFilespec = Path.Combine(config.ConfigDir, "log4j2.xml");
            sbd.AppendFormat(" -Dlog4j.configurationFile=file:/{0} -cp ./*;../trustedjars/*;", logPropertiesFilespec.Replace(@"\", "/"));
            sbd.AppendFormat("{0} {1} \"{2}\"", commandParamJar, commandParamPackage, "-readConfig");
            string cmdparam = sbd.ToString();
            string output;
            try
            {
                output = RunJavaUtility(cmdparam, config);
            }
            catch (Exception ex)
            {
                output = "";
                Logger().Info(ex.Message);
            }

            return output;
        }

        /// <summary>
        /// Check to see that a zip file contains a keystore and truststore making it a "valid" certificate. 
        /// </summary>
        /// <param name="certificateFilespec">The zip file which should contain a keystore and truststore</param>
        /// <returns>true if the zip file contains a keystore and truststore</returns>
        public static bool IsFederationCertificateValid(string certificateFilespec)
        {
            bool isVixCertificateValid = false;
            List<string> allowedCertificateFiles = new List<string>();
            allowedCertificateFiles.Add(FEDERATION_KEYSTORE_FILENAME);
            allowedCertificateFiles.Add(FEDERATION_TRUSTSTORE_FILENAME);
            //TODO: add host name check
            if (ZipUtilities.ZipFileCount(certificateFilespec) == 2 && ZipUtilities.VerifyZipContents(certificateFilespec, allowedCertificateFiles.ToArray()))
            {
                isVixCertificateValid = true;
            }
            return isVixCertificateValid;
        }

        /// <summary>
        /// Check to see that a zip file contains a keystore and truststore making it a "valid" certificate. 
        /// </summary>
        /// <param name="certificateFilespec">The zip file which should contain a keystore and truststore</param>
        /// <returns>true if the zip file contains a keystore and truststore</returns>
        public static bool IsXcaCertificateValid(string certificateFilespec)
        {
            bool isXcaCertificateValid = false;
            List<string> allowedCertificateFiles = new List<string>();
            //allowedCertificateFiles.Add(XCA_KEYSTORE_FILENAME);
            //allowedCertificateFiles.Add(XCA_TRUSTSTORE_FILENAME);
            allowedCertificateFiles.Add(XCA_CERTIFICATE_FILENAME);
            allowedCertificateFiles.Add(XCA_PRIVATE_KEY_FILENAME);
            //TODO: add host name check
            if (ZipUtilities.ZipFileCount(certificateFilespec) >= allowedCertificateFiles.Count && ZipUtilities.VerifyZipContents(certificateFilespec, allowedCertificateFiles.ToArray()))
            {
                isXcaCertificateValid = true;
            }
            return isXcaCertificateValid;
        }

        /// <summary>
        /// Check to see that a zip file contains certificates making it a "valid" certificate. 
        /// </summary>
        /// <param name="certificateFilespec">The zip file which should contain a keystore and truststore</param>
        /// <returns>true if the zip file contains a keystore and truststore</returns>
        public static bool IsDoDCertificateValid(string certificateFilespec)
        {
            bool isDoDCertificateValid = false;
            //List<string> allowedCertificateFiles = new List<string>();
            //allowedCertificateFiles.Add(DOD_CERTIFICATE_FILENAME);
            int nCerts = ZipUtilities.ZipFileCount(certificateFilespec);
            if (nCerts >= 1)
            {
                Logger().Info("IsDoDCertificateValid - # of certificates: " + nCerts);
                isDoDCertificateValid = true;
            }
            return isDoDCertificateValid;
        }


        #endregion

        #region private installation methods


        /// <summary>
        /// Uninstalls the web application.
        /// </summary>
        /// <param name="vixWebApplication">The vix web application object.</param>
        /// <param name="deleteWar">if set to <c>true</c> [delete the war the web application came from].</param>
        /// <remarks></remarks>
        private static void UninstallWebApplication(IVixConfigurationParameters config, VixWebApplication vixWebApplication, bool deleteWar)
        {
            if (deleteWar)
            {
                string warFileSpec = Path.Combine(TomcatFacade.TomcatWebApplicationFolder, vixWebApplication.War);
                if (File.Exists(warFileSpec))
                {
                    File.Delete(warFileSpec);
                    Info("    Deleted " + warFileSpec);
                }
            }

            string pathFolder = vixWebApplication.Path.StartsWith("/") ? vixWebApplication.Path.Substring(1) : vixWebApplication.Path;
            string webAppPathFolder = Path.Combine(TomcatFacade.TomcatWebApplicationFolder, pathFolder);
            if (Directory.Exists(webAppPathFolder))
            {
                RemoveReadOnlyAttributes(webAppPathFolder); // recurse
                Directory.Delete(webAppPathFolder, true); // recurse
                Info("    Deleted " + webAppPathFolder);
            }
            string webAppPathWorkFolder = Path.Combine(TomcatFacade.GetTomcatWorkFolder(config.SiteNumber), pathFolder);
            if (Directory.Exists(webAppPathWorkFolder))
            {
                RemoveReadOnlyAttributes(webAppPathWorkFolder); // recurse
                Directory.Delete(webAppPathWorkFolder, true); // recurse
                Info("    Deleted " + webAppPathWorkFolder);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sourceDir"></param>
        /// <param name="sourceFilename"></param>
        /// <param name="targetDir"></param>
        /// <param name="config"></param>
        private static void RewriteLoggingPropertiesFile(String sourceDir, String sourceFilename, String targetDir,
            IVixConfigurationParameters config)
        {
            String sourcePath = Path.Combine(sourceDir, sourceFilename);
            String targetPath = Path.Combine(targetDir, sourceFilename);
            String vixConfigDir = config.ConfigDir.Replace(@"\", "/"); // translate file system delimiter so Java doesnt barf
            Info("Rewriting " + sourcePath + " to " + targetPath);

            using (StreamReader sr = new StreamReader(sourcePath))
            {
                using (StreamWriter sw = File.CreateText(targetPath)) // file will be overwritten
                {
                    String line;
                    while ((line = sr.ReadLine()) != null)
                    {
                        if (line.Contains("vixconfig="))
                        {
                            sw.WriteLine("vixconfig=" + vixConfigDir);
                        }
                        else
                        {
                            sw.WriteLine(line);
                        }
                    }
                    sw.Close();
                }
                sr.Close();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="configUtility"></param>
        /// <param name="config"></param>
        /// <param name="payloadPath"></param>
        private static void ExecuteConfigurationUtility(VixJavaConfigurationUtility configUtility, IVixConfigurationParameters config)
        {
            StringBuilder sb = new StringBuilder();

            // Transaction Import Log utility requires this to operate
            string logPropertiesFilespec = null;

            Logger().Info("Log4j version: " + VixFacade.Manifest.Log4jVersion);
            if (VixFacade.Manifest.Log4jVersion == 2)
            {
                logPropertiesFilespec = Path.Combine(config.ConfigDir, "log4j2.xml");
                sb.AppendFormat(" -Dlog4j.configurationFile=file:/{0} -cp ./*;{1} {2} ", logPropertiesFilespec.Replace(@"\", "/"),
                    configUtility.Jar, configUtility.Package);
            }
            else
            {
                logPropertiesFilespec = Path.Combine(config.ConfigDir, "log4j.properties");
                sb.AppendFormat(" -Dlog4j.configuration=file:/{0} -cp ./*;{1} {2} ", logPropertiesFilespec.Replace(@"\", "/"),
                configUtility.Jar, configUtility.Package);
            }

            switch (configUtility.ConfigUtilityType)
            {
                case ViXConfigurationUtilityType.ViX:
                    sb.AppendFormat("\"LocalSiteNumber={0}\" \"SmtpServerUri={1}\" \"VixSoftwareVersion={2}\"",
                        config.SiteNumber, BusinessFacade.GetSmtpServerUri(), config.ProductVersionProp);
                    break;
                case ViXConfigurationUtilityType.Cache:
                    BuildCacheConfigurationParameters(config, sb); // sb gets populated
                    break;
                case ViXConfigurationUtilityType.SiteResolutionProvider:
                    //}
                    if (config.VixRole == VixRoleType.EnterpriseGateway)
                    {
                        string commandFilespec = Path.Combine(config.ConfigDir, "configureSiteResolutionProvider.commands");
                        sb.AppendFormat("-f \"file:/{0}\" \"{1}\"", commandFilespec.Replace(@"\", "/"), config.SiteServiceUri);
                    }
                    else if (config.VixRole == VixRoleType.SiteVix)
                    {
                        // param 3 - exchange
                        string commandFilespec = Path.Combine(config.ConfigDir, "configureSiteResolutionProvider.commands");
                        sb.AppendFormat("-f \"file:/{0}\" \"{1}\" \"{2}\"", commandFilespec.Replace(@"\", "/"), config.SiteServiceUri, config.SiteNumber);
                    }
                    else if (config.VixRole == VixRoleType.DicomGateway)
                    {
                        string commandFilespec = Path.Combine(config.ConfigDir, "configureSiteResolutionProvider.commands");
                        sb.AppendFormat("-f \"file:/{0}\" \"{1}\" \"{2}\"", commandFilespec.Replace(@"\", "/"), config.SiteServiceUri, config.SiteNumber);
                    }
                    else if (config.VixRole == VixRoleType.MiniVix)
                    {
                        // param 3 - exchange
                        string commandFilespec = Path.Combine(config.ConfigDir, "configureSiteResolutionProvider2.commands");
                        sb.AppendFormat("-f \"file:/{0}\" \"{1}\" \"{2}\"", commandFilespec.Replace(@"\", "/"), config.SiteServiceUri, config.SiteNumber);
                    }
                    else // should never happen
                    {
                        throw new Exception(config.VixRole.ToString() + "  Site Resolution Configuration not currently supported");
                    }
                    break;
                case ViXConfigurationUtilityType.ClinicalDisplayProvider:
                    break; // no parameters yet
                case ViXConfigurationUtilityType.ExchangeDataSourceProvider:
                    sb.AppendFormat("\"-biaUsername\" \"{0}\" \"-biaPassword\" \"{1}\"", config.BiaUsername, config.BiaPassword);
                    if (config.VixRole == VixRoleType.EnterpriseGateway)
                    {
                        sb.Append(BlacklistModalityArguments(config));
                    }
                    break;
                case ViXConfigurationUtilityType.ExchangeProcedureFilterTermsConfiguration:
                    break; // no parameters yet
                case ViXConfigurationUtilityType.ImageConversion:
                    break; // no parameters yet
                case ViXConfigurationUtilityType.VistaDataSourceProvider:
                    break; // no parameters yet
                case ViXConfigurationUtilityType.VistaOnlyDataSourceProvider:
                    // used to be CVIX only - not any more as of P119 - DKB
                    if (config.Station200UserName == null) // VIX or Mini-VIX
                    {
                        sb.Append("false"); // production - use CPRS Treating Facility List RPC
                    }
                    else if (config.Station200UserName.ToLower() == "testing_1" || config.Station200UserName.ToLower() == "boating1") // CVIX
                    {
                        sb.Append("true"); // internal test environment - use VistA Imaging Treating Facility List RPC
                    }
                    else
                    {
                        sb.Append("false"); // production - use CPRS Treating Facility List RPC - CVIX
                    }
                    break;
                case ViXConfigurationUtilityType.TransactionLoggerJdbcSourceProvider:
                    break; // no parameters yet
                case ViXConfigurationUtilityType.VixLogConfiguration:
                    break; // no parameters yet
                case ViXConfigurationUtilityType.ByteBufferPoolConfiguration:
                    if (config.VixRole == VixRoleType.MiniVix)
                    {
                        sb.Append("-m");
                    }
                    break;
                case ViXConfigurationUtilityType.VistaRadCommandConfiguration:
                    if (config.VixRole == VixRoleType.MiniVix)
                    {
                        sb.Append("-m");
                    }
                    break;
                case ViXConfigurationUtilityType.IdsProxyConfiguration:
                    break; // no parameters yet
                case ViXConfigurationUtilityType.FederationDataSourceProvider:
                    String s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), FEDERATION_KEYSTORE_FILENAME);
                    String federationKeystorePath = s.Replace(@"\", "/");
                    s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), FEDERATION_TRUSTSTORE_FILENAME);
                    String federationTruststorePath = s.Replace(@"\", "/");
                    sb.AppendFormat("\"-truststorePassword\" \"{0}\" \"-keystorePassword\" \"{1}\" \"-keystoreUrl\" \"file:///{2}\" \"-truststoreUrl\" \"file:///{3}\" -federationSslProtocol \"https\"",
                        config.FederationTruststorePassword, config.FederationKeystorePassword, federationKeystorePath, federationTruststorePath);
                    break;
                case ViXConfigurationUtilityType.VixHealthConfiguration:
                    if (config.VixRole == VixRoleType.EnterpriseGateway)
                    {
                        sb.AppendFormat("\"{0}\" true true true false", config.SiteNumber);
                    }
                    else if (config.VixRole == VixRoleType.SiteVix || config.VixRole == VixRoleType.MiniVix)
                    {
                        sb.AppendFormat("\"{0}\" true true false false", config.SiteNumber);
                    }
                    else if (config.VixRole == VixRoleType.DicomGateway)
                    {
                        sb.AppendFormat("\"{0}\" true true false true", config.SiteNumber);
                    }
                    else // should never happen
                    {
                        throw new Exception(config.VixRole.ToString() + "  Health Configuration not currently supported");
                    }
                    break;
                case ViXConfigurationUtilityType.NotificationConfiguration:
                    if (config.VixRole == VixRoleType.DicomGateway)
                    {
                        sb.AppendFormat("\"{0}\" false", config.SiteNumber); // DICOM VIXen do not enable notifications for now
                    }
                    else
                    {
                        sb.AppendFormat("\"{0}\" true", config.SiteNumber);
                    }
                    break;
                case ViXConfigurationUtilityType.NotificationEmailConfiguration:
                    if (config.NotificationEmailAddresses != null)
                    {
                        sb.AppendFormat(" \"{0}\"", config.NotificationEmailAddresses);
                    }
                    break;
                case ViXConfigurationUtilityType.DicomGatewayConfiguration:
                    string dcorrectDir = Path.Combine(config.LocalCacheDir, "DCorrect").Replace(@"\", "/");
                    string ddebugDir = Path.Combine(config.LocalCacheDir, "DDebug").Replace(@"\", "/");
                    sb.AppendFormat("\"{0}\" \"{1}\" \"{2}\" \"{3}\" \"{4}\" \"DLE={5}\" \"AE={6}\" \"IPE={7}\"", config.SiteNumber, config.DicomImageGatewayServer,
                        config.DicomImageGatewayPort, config.VdigAccessor, config.VdigVerifier, config.DicomListenerEnabled.ToString().ToLower(), config.ArchiveEnabled.ToString().ToLower(),
                        config.IconGenerationEnabled.ToString().ToLower());
                    break;
                case ViXConfigurationUtilityType.StorageServerConfiguration:
                    break;  // no parameters yet
                case ViXConfigurationUtilityType.PeriodicCommandConfiguration:
                    if (config.VixRole == VixRoleType.DicomGateway)
                    {
                        sb.AppendFormat("\"{0}\" \"{1}\" \"{2}\" \"{3}\" \"{4}\" \"{5}\" \"{6}\" \"{7}\" \"{8}\" \"{9}\" \"{10}\" \"{11}\" \"{12}\" \"{13}\"",
                            "accessCode", "none",
                            "verifyCode", "none",
                            "ProcessAsyncStorageQueueSendEmailCommand", "60000",
                            "ProcessDicomCorrectCommand", "60000",
                            "ProcessIconImageCreationQueueCommand", "60000",
                            "ProcessEmailQueueCommand", "30000",
                            "ProcessPortListeningCheckCommand", "60000");
                        // this was previously a P79 only feature...
                        sb.AppendFormat(" \"{0}\" \"{1}\"", "ProcessStoreCommitWorkItemCommand", "60000");
                    }
                    else
                    {
                        if ((config.VixRole == VixRoleType.SiteVix) && (manifest.MajorPatchNumber >= 197))
                        {
                            sb.AppendFormat(" \"{0}\" \"{1}\" \"{2}\" \"{3}\" \"{4}\" \"{5}\"",
                                "accessCode", config.VistaAccessor,
                                "verifyCode", config.VistaVerifier,
                                "ProcessViewerPreCacheWorkItemsCommand", "60000");
                        }
                    }
                    break;
                case ViXConfigurationUtilityType.RoiConfiguration: // P130, P138 VIX
                    sb.AppendFormat("\"{0}\" \"{1}\"", config.VistaAccessor, config.VistaVerifier);
                    break;
                case ViXConfigurationUtilityType.ScpConfiguration:
                    sb.AppendFormat("\"{0}\" \"{1}\"", config.VistaAccessor, config.VistaVerifier);
                    break;
                case ViXConfigurationUtilityType.ImageGearDataSourceProvider: // P130, P138 VIX
                    VixDependencyFile[] roiAnnotate = FilterFilesByType(manifest.GetDependencyFiles(config), config, VixDependencyType.RoiAnnotationExe);
                    if (roiAnnotate.Length != 1) throw new Exception("Cannot configure ImageGearDataSourceProvider - missing ROI annotation exe");
                    VixDependencyFile[] roiPdf = FilterFilesByType(manifest.GetDependencyFiles(config), config, VixDependencyType.RoiPdfExe);
                    if (roiAnnotate.Length != 1) throw new Exception("Cannot configure ImageGearDataSourceProvider - missing ROI PDF exe");
                    string roiDisclosureDirspec = Path.Combine(config.ConfigDir, ROI_DISCLOSURE_DIRECTORY);
                    if (!Directory.Exists(roiDisclosureDirspec))
                    {
                        Directory.CreateDirectory(roiDisclosureDirspec);
                    }
                    sb.AppendFormat("\"{0}\" \"{1}\" \"{2}\" \"{3}\"", roiDisclosureDirspec, config.SiteName, roiPdf[0].GetAppFilespec(), roiAnnotate[0].GetAppFilespec());
                    break;
                //Copy the config file rather than generate using java
                //case ViXConfigurationUtilityType.VistaConnectionConfiguration:
                //    if (config.VixRole == VixRoleType.EnterpriseGateway || config.VixRole == VixRoleType.SiteVix)
                //    {
                //        if (IsDevelopmentCvix(config) == false)
                //        {
                //            sb.Append("-new false"); // use new style broker
                //        }
                //    }
                //    break;
                case ViXConfigurationUtilityType.CommandConfiguration:
                    if (config.VixRole == VixRoleType.EnterpriseGateway)
                    {
                        if (config.Station200UserName.ToLower() == "testing_1" || config.Station200UserName.ToLower() == "boating1")
                        {
                            sb.Append("true false false"); // dont not use CPRS context
                        }
                        else
                        {
                            sb.Append("true true false");
                        }
                    }
                    else // VIX and Mini-VIX, HDIG does not have this configured
                    {
                        sb.Append("true false true");
                    }
                    break;
                case ViXConfigurationUtilityType.ImagingFacadeConfiguration:
                    if (config.VixRole == VixRoleType.EnterpriseGateway)
                    {
                        sb.Append("false true");
                    }
                    else if (config.VixRole == VixRoleType.SiteVix || config.VixRole == VixRoleType.MiniVix)
                    {
                        sb.Append("true false");
                    }
                    else // should never happen
                    {
                        throw new Exception(config.VixRole.ToString() + "  Imaging Facade Configuration not currently supported");
                    }
                    break;
                case ViXConfigurationUtilityType.MixDataSourceProvider:
                    //sb.AppendFormat("\"-biaUsername\" \"{0}\" \"-biaPassword\" \"{1}\"", 
                    //    config.BiaUsername, config.BiaPassword);
                    if (config.VixRole == VixRoleType.EnterpriseGateway)
                    {
                        sb.Append(BlacklistModalityArguments(config));
                        sb.AppendFormat(" \"-host\" \"{0}\" \"-port\" \"{1}\" \"-cvixCertPwd\" \"{2}\" \"-dasCertPwd\" \"{3}\"",
                            config.DoDConnectorHost, config.DoDConnectorPort,
                            config.FederationKeystorePassword, config.FederationTruststorePassword
                            );
                    }
                    break;
                 case ViXConfigurationUtilityType.DxDataSourceProvider:
                    if (config.VixRole == VixRoleType.EnterpriseGateway)
                    {
                        sb.AppendFormat("\"-host\" \"{0}\" \"-port\" \"{1}\" \"-provider\" \"{2}\" " +
                            "\"-loinc\" \"{3}\" \"-requestSource\" \"{4}\" \"-cvixCertPwd\" \"{5}\" \"-dasCertPwd\" \"{6}\" " +
                            "\"-localIp\" \"{7}\" \"-alexdelargePwd\" \"655321\"",
                            config.DoDConnectorHost, config.DoDConnectorPort, config.DoDConnectorProvider,
                            config.DoDConnectorLoinc, config.DoDConnectorRequestSource,
                            config.FederationKeystorePassword, config.FederationTruststorePassword,
                            Environment.MachineName
                            );
                       }
                    break;
                case ViXConfigurationUtilityType.FileSystemCacheConfigurator:
                    break;
                case ViXConfigurationUtilityType.MuseDataSourceProvider:
                    sb.AppendFormat("\"{0}\" \"{1}\" \"{2}\" \"{3}\" \"{4}\" \"{5}\" \"{6}\"", "-museEnabled=" + config.MuseEnabled.ToString(), "-museSiteNumber=" + config.MuseSiteNum, "-museHost=" + config.MuseHostname,
                     "-username=" + config.MuseUsername, "-password=" + config.MusePassword, "-musePort=" + config.MusePort, "-museProtocol=" + config.MuseProtocol);
                    break;
                case ViXConfigurationUtilityType.DicomCategoryFilterConfiguration:
                    break;
                case ViXConfigurationUtilityType.IngestConfiguration:
                    //sb.AppendFormat("\"{0}\" \"{1}\"",
                    //    Path.Combine(GetVixConfigurationDirectory() + @"\thumbnailMaker\", THUMBNAIL_MAKER_EXE),
                    //    Path.Combine(GetVixConfigurationDirectory(), INGEST_TEMP_PATH)
                    //    );
                    break;
                    //case ViXConfigurationUtilityType.XCAInitiatingGatewayDataSourceProvider:
                    //    //"file:/C:/VixCertStore/xca.keystore" "R00tbeer" "file:/C:/VixCertStore/xca.truststore" "R00tbeer" "7443" "null" "null" "null" "xcas" "null" "null" "xcas" "ncatusername" "ncatpassword"

                    //    s = Path.Combine(VixFacade.GetVixConfigurationDirectory(), "configureCVIX_XCA.commands");
                    //    String xcaCommands = s.Replace(@"\", "/");
                    //    sb.AppendFormat("-f \"file:/{0}\" ", xcaCommands);

                    //    s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), FEDERATION_KEYSTORE_FILENAME); // XCA_KEYSTORE_FILENAME);
                    //    String xcaKeystorePath = s.Replace(@"\", "/");
                    //    s = Path.Combine(VixFacade.GetVixCertificateStoreDir(), FEDERATION_TRUSTSTORE_FILENAME);// XCA_TRUSTSTORE_FILENAME);
                    //    String xcaTruststorePath = s.Replace(@"\", "/");
                    //    sb.AppendFormat("\"file:/{0}\" \"{1}\" \"file:/{2}\" \"{3}\" \"{4}\" \"{5}\" \"{6}\" \"{7}\" \"{8}\" \"{9}\" \"{10}\" \"{11}\" \"{12}\" \"{13}\"",
                    //        xcaKeystorePath, config.FederationKeystorePassword, xcaTruststorePath, config.FederationTruststorePassword, config.XcaConnectorPort.ToString(),
                    //        config.BhieProtocol, (config.BhieUserName == null ? "null" : config.BhieUserName), (config.BhiePassword == null ? "null" : config.BhiePassword),
                    //        config.HaimsProtocol, (config.HaimsUserName == null ? "null" : config.HaimsUserName), (config.HaimsPassword == null ? "null" : config.HaimsPassword),
                    //        config.NcatProtocol, (config.NcatUserName == null ? "null" : config.NcatUserName), (config.NcatPassword == null ? "null" : config.NcatPassword));
                    //    break;
            }

            String parameters = sb.ToString();
            if ((configUtility.ConfigUtilityType == ViXConfigurationUtilityType.PeriodicCommandConfiguration) && (config.VixRole == VixRoleType.SiteVix) && (manifest.MajorPatchNumber >= 197))
            {
                if (config.VistaAccessor != config.VistaVerifier)
                {
                    sb.Replace(config.VistaVerifier, "removed");
                    sb.Replace(config.VistaAccessor, "removed");
                }
                else
                {
                    sb.Replace(config.VistaAccessor, "removed");
                }
                Logger().Info("java arg: " + sb.ToString());
            }
            else
            {
                //do not log Vista and MUSE credentials
                if ((configUtility.ConfigUtilityType != ViXConfigurationUtilityType.DxDataSourceProvider) && (configUtility.ConfigUtilityType != ViXConfigurationUtilityType.MixDataSourceProvider) && (configUtility.ConfigUtilityType != ViXConfigurationUtilityType.DxDataSourceProvider) && (configUtility.ConfigUtilityType != ViXConfigurationUtilityType.MixDataSourceProvider))                
                {
                    Logger().Info("java arg: " + parameters);
                }
                else
                {
                    //do not log DxDataSourceProvider or MixDataSourceProvider if not a new install or the ConfigCheck is false
                    if ((configUtility.ConfigUtilityType == ViXConfigurationUtilityType.DxDataSourceProvider) || (configUtility.ConfigUtilityType == ViXConfigurationUtilityType.MixDataSourceProvider))
                    {
                        if ((config.PreviousProductVersionProp != null) && (config.ConfigCheck == false))
                        {
                            //Don't log call into jar if DxDataSourceProvider or MixDataSourceProvider if not a new install or the ConfigCheck is false
                        }
                        else
                        {
                            Logger().Info("java arg: " + parameters);
                        }
                    }
                }
            }
            if ((configUtility.ConfigUtilityType != ViXConfigurationUtilityType.DxDataSourceProvider) && (configUtility.ConfigUtilityType != ViXConfigurationUtilityType.MixDataSourceProvider))
            {
                Logger().Info("Configuring " + configUtility.ConfigUtilityType.ToString());
                RunJavaUtility(parameters, config);
                Logger().Info("Done.");
            }
            else
            {
                if ((config.PreviousProductVersionProp != null) && (config.ConfigCheck == false))
                {
                    //Don't call into jar if DxDataSourceProvider or MixDataSourceProvider if not a new install or the ConfigCheck is false
                }
                else
                {
                    Logger().Info("Configuring " + configUtility.ConfigUtilityType.ToString());
                    RunJavaUtility(parameters, config);
                    Logger().Info("Done.");
                }
            }
        }

        private static string GetLocalIp()
        {
            string localIP;
            using (Socket socket = new Socket(AddressFamily.InterNetwork, SocketType.Dgram, 0))
            {
                socket.Connect("8.8.8.8", 65530);
                IPEndPoint endPoint = socket.LocalEndPoint as IPEndPoint;
                localIP = endPoint.Address.ToString();
            }
            return localIP;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="config"></param>
        /// <returns></returns>
        private static string BlacklistModalityArguments(IVixConfigurationParameters config)
        {
            string blacklistFilespec = Path.Combine(config.ConfigDir, MODALITY_BLACKLIST_FILENAME);
            StringBuilder sb = new StringBuilder();

            if (File.Exists(blacklistFilespec))
            {
                string line;

                using (StreamReader sr = new StreamReader(blacklistFilespec))
                {
                    while ((line = sr.ReadLine()) != null)
                    {
                        if (line.Length == 0)
                        {
                            continue;
                        }
                        sb.Append(" -emptyModality " + "\"" + line + "\"");
                    }
                    sr.Close();
                }
            }

            return sb.ToString();
        }

        /// <summary>
        /// Populate the passed StringBuilder with the parameters needed to initialize the VIX cache
        /// </summary>
        /// <param name="config"></param>
        /// <param name="sb"></param>
        private static void BuildCacheConfigurationParameters(IVixConfigurationParameters config, StringBuilder sb)
        {
            string localCacheDir = config.LocalCacheDir.Replace(@"\", "/"); // translate file system delimiter so Java doesnt barf
            switch (config.VixCacheOption)
            {
                case VixCacheType.ExchangeTimeEvictionLocalFilesystem:
                    sb.AppendFormat("create \"<ImagingExchangeCache>\" \"<file://{0}>\" \"<VixPrototype>\" initialize enable store exit",
                        localCacheDir);
                    break;
                case VixCacheType.ExchangeTimeStorageEvictionLocalFilesystem:
                    sb.AppendFormat("create \"<ImagingExchangeCache>\" \"<file://{0}>\" \"<LimitedSpaceVixPrototype>\" initialize enable ",
                        localCacheDir);
                    // image storage eviction modification based on cache size
                    // default combined metadata region size is 1GB which should be all we need
                    long imageRegionSize = (config.VixCacheSize - 1) * ONE_GIGBYTE;
                    Debug.Assert(imageRegionSize > 0);
                    long imageRegionFreeSpaceThreshold = (long)(imageRegionSize * 0.05); // start evicting at 95% full
                    long imageRegionTargetFreeSpaceThreshold = (long)(imageRegionSize * 0.1); // stop evicting at 90% full
                    sb.AppendFormat("modify-eviction \"<image-storage-threshold>\" \"<maxUsedSpaceThreshold>\" \"<{0}>\" ",
                        imageRegionSize); // maxUsedSpaceThreshold is MAX cache size (may be exceeded)
                    sb.AppendFormat("modify-eviction \"<image-storage-threshold>\" \"<minFreeSpaceThreshold>\" \"<{0}>\" ",
                        imageRegionFreeSpaceThreshold); // MAX - minFreeSpaceThreshold is where eviction starts to occur
                    sb.AppendFormat("modify-eviction \"<image-storage-threshold>\" \"<targetFreeSpaceThreshold>\" \"<{0}>\" ",
                        imageRegionTargetFreeSpaceThreshold); // MAX - targetFreeSpaceThreshold is where eviction stops
                    // save and exit
                    sb.Append("store exit");
                    break;
                default:
                    string message = "BuildCacheConfigurationParameters: unsupported cache option " + config.VixCacheOption.ToString();
                    throw new Exception(message);
            }
        }

        /// <summary>
        /// Set access control on HDIG DICOM directory needed by the Apache Tomcat service account
		/// The rest of the access control needed for the Apache Tomcat service account has been relocated to
		/// BusinessFacade.RunSilentPSProcess that runs permission_fixer.ps1
        /// </summary>
        /// <param name="config"></param>
        private static void ApplyAccessControl(IVixConfigurationParameters config)
        {
            String serviceAccountUsername = TomcatFacade.ServiceAccountUsername;

            if (config.VixRole == VixRoleType.DicomGateway)
            {
                string dicomDir = GetFullyQuaifiedHdigDicomDirectory();
                if (dicomDir != null)
                {
                    Info("Applying access control for the " + serviceAccountUsername + " account to " + dicomDir);
                    AccessContolUtilities.SetFullDirectoryAccessControl(serviceAccountUsername, dicomDir);
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="config"></param>
        private static void CreateEnvironmentVariables(IVixConfigurationParameters config)
        {
            Info("Setting Windows environment variables.");
            // set the vixconfig environment variable to the local configuration dir
            String vixConfigDir = config.ConfigDir.Replace(@"\", @"/"); // translate file system delimiter so Java doesnt barf
            Info("Setting Windows environment variable vixconfig=" + vixConfigDir.Replace(@"/", @"\"));
            Environment.SetEnvironmentVariable("vixconfig", vixConfigDir, EnvironmentVariableTarget.Machine);

            if (config.LocalCacheDir != null)
            {
                String vixCacheDir = config.LocalCacheDir.Replace(@"\", @"/"); // translate file system delimiter so Java doesnt barf
                // set the vixcache environment variable to the local cache dir
                Info("Setting Windows environment variable vixcache=" + vixCacheDir.Replace(@"/", @"\"));
                Environment.SetEnvironmentVariable("vixcache", vixCacheDir, EnvironmentVariableTarget.Machine);
            }
            else
            {
                // set the vixcache environment variable to the cache network share
                Info("Setting Windows environment variable vixcache=" + config.NetworkFileShare);
                Environment.SetEnvironmentVariable("vixcache", config.NetworkFileShare, EnvironmentVariableTarget.Machine);
            }

            String VixTxDbDir = config.VixTxDbDir.Replace(@"\", @"/"); // translate file system delimiter so Java doesnt barf
            Info("Setting Windows environment variable vixtxdb=" + VixTxDbDir.Replace(@"/", @"\"));
            Environment.SetEnvironmentVariable("vixtxdb", VixTxDbDir, EnvironmentVariableTarget.Machine);

            Info("Setting Windows environment variable CATALINA_HOME=" + TomcatFacade.TomcatInstallationFolder);
            Environment.SetEnvironmentVariable("CATALINA_HOME", TomcatFacade.TomcatInstallationFolder, EnvironmentVariableTarget.Machine);
        }

        private static bool IsLocalCacheConfigured(IVixConfigurationParameters config)
        {
            bool isConfigured = true;
            Debug.Assert(config.LocalCacheDir != null);
            Debug.Assert(config.ConfigDir != null);

            if (File.Exists(VixFacade.VixConfigFilespec) == false)
            {
                isConfigured = false;
            }

            string cacheRegionDirspec = Path.Combine(config.LocalCacheDir, EXCHANGE_CACHE_DOD_IMAGE_REGION);
            if (Directory.Exists(cacheRegionDirspec) == false)
            {
                isConfigured = false;
            }

            return isConfigured;
        }

        private static readonly String DOD_METADATA_REGION = @"dod-metadata-region";
        private static readonly String DOD_IMAGE_REGION = @"dod-image-region";
        private static readonly String VA_METADATA_REGION = @"va-metadata-region";
        private static readonly String VA_IMAGE_REGION = @"va-image-region";

        private static void DeleteAllLocalCacheRegions(IVixConfigurationParameters config)
        {
            if (IsLocalCacheConfigured(config))
            {
                Logger().Info(Info("Deleting files from the local VIX cache."));
                Info("This may take several minutes - please be patient.");
                string baseCacheDir = config.LocalCacheDir.Replace("/", @"\");
                DeleteCacheRegion(baseCacheDir, DOD_METADATA_REGION);
                DeleteCacheRegion(baseCacheDir, DOD_IMAGE_REGION);
                DeleteCacheRegion(baseCacheDir, VA_METADATA_REGION);
                DeleteCacheRegion(baseCacheDir, VA_IMAGE_REGION);
                Info("The VIX cache has been cleared.");
            }
        }

        private static void DeleteCacheRegion(string baseCacheDir, string regionDir)
        {
            string regionPath = Path.Combine(baseCacheDir, regionDir);
            string fooDir = Path.Combine(baseCacheDir, "foo");
            if (Directory.Exists(regionPath))
            {
                Logger().Info(Info("Deleting contents of " + regionPath));
                string[] dirs = Directory.GetDirectories(regionPath);
                foreach (string subDir in dirs)
                {
                    try
                    {
                        Directory.Move(subDir, fooDir);
                        Directory.Delete(fooDir, true);
                    }
                    catch (Exception) { }
                    finally
                    {
                        if (Directory.Exists(subDir))
                        {
                            Logger().Error("Could not delete directory " + subDir);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Copy the sites file (usualy vhasites.xml) to the VIX config directory and rename to vhasites.xml.
        /// </summary>
        /// <param name="config"></param>
        private static void DeploySitesFile(IVixConfigurationParameters config)
        {
            string targetFilespec = Path.Combine(GetVixConfigurationDirectory(), "VhaSites.xml");
            Debug.Assert(File.Exists(config.SitesFile));
            File.Copy(config.SitesFile, targetFilespec, true); // overwrite
        }

        private static void TCPTimeoutInRegistry()
        {

            RegistryView regView = RegistryView.Registry64;
            string key = @"SYSTEM\CurrentControlSet\Services\Tcpip\Parameters";
            using (RegistryKey regKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, regView))
            {
                using (RegistryKey tcpKey = regKey.OpenSubKey(key, true))
                {
                    tcpKey.SetValue("TcpTimedWaitDelay", 30, RegistryValueKind.DWord);
                }
            }
        }

        private static void RunNetworkConfigurationCommand()
        {
            int exitCode = 0;
            using (Process externalProcess = new Process())
            {
                externalProcess.StartInfo.FileName = "NetSh";
                externalProcess.StartInfo.Arguments = "INT IPV4 SET DynamicPort TCP Start=1025 num=64511";
                //externalProcess.StartInfo.WorkingDirectory;
                externalProcess.StartInfo.UseShellExecute = false;
                externalProcess.StartInfo.CreateNoWindow = true;
                externalProcess.Start();

                try
                {
                    do
                    {
                        DoEvents();
                        Thread.Sleep(500);
                        externalProcess.Refresh();
                    } while (!externalProcess.HasExited);
                    exitCode = externalProcess.ExitCode;
                }
                finally
                {
                    externalProcess.Close();
                }
            }

        }

        #endregion
    }
}


