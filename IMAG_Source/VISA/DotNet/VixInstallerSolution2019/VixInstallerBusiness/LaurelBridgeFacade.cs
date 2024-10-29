using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using Microsoft.Win32;
using System.Diagnostics;
using System.Xml;
using System.Runtime.InteropServices;
using log4net;
using System.Threading;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public static class LaurelBridgeFacade
    {
        /// <summary>
        /// Retrieve a logger for this class.
        /// </summary>
        /// <returns>A logger as a ILog interface.</returns>
        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(LaurelBridgeFacade).Name);
        }

        public static VixManifest Manifest { get; set; }
        public static InfoDelegate InfoDelegate { get; set; }
        public static AppEventsDelegate AppEventsDelegate { get; set; }

        private static readonly String DCF_VERSION_FILENAME = @"dcfversion";

        /// <summary>
        /// A helper method to wrap the infoDelegate member, which if non null provide a way to report status to the 
        /// user interface.
        /// </summary>
        /// <param name="infoMessage">message to display in the user interface.</param>
        /// <returns>the message string passed in the infoMessage parameter to support chaining.</returns>
        private static String Info(String infoMessage)
        {
            if (InfoDelegate != null)
            {
                InfoDelegate(infoMessage);
            }
            Logger().Info(infoMessage); // any info provided to the presentation layer will be logged.
            return infoMessage;
        }

        /// <summary>
        /// A helper method to wrap the appEventsDelegate member, which if non null provide a way to allow the OS to process
        /// events and keep the UI responsive during a long running method. See WizardPage control to see initialization 
        /// of delegate.
        /// </summary>
        private static void DoEvents()
        {
            if (AppEventsDelegate != null)
            {
                AppEventsDelegate();
            }
        }

        /// <summary>
        /// Returns the Laurel Bridge root dirspec of the active installation as specified by the manifest.
        /// Corresponds to what the DCF_ROOT environment variable will be initiatized to. 
        /// </summary>
        /// <returns>DCF installation dirpsec</returns>
        public static string GetActiveDcfRootFromManifest()
        {
            return Manifest.ActiveDcfPrerequisite.InstallPath;
        }

        /// <summary>
        /// Get the license type of the active installation.
        /// </summary>
        /// <returns>license type of the active DCF installation</returns>
        public static DcfLicenseType GetActiveDcfLicenseType()
        {
            return Manifest.ActiveDcfPrerequisite.LicenseType;
        }

        /// <summary>
        /// Returns the version string of the deprecated Laurel Bridge prerequisite.
        /// </summary>
        /// <returns>version string of the installed deprecated prerequisite</returns>
        public static string GetDeprecatedLaurelBridgeVersion()
        {
            string version = null;
            DcfPrerequisite prerequisite = GetInstalledDeprecatedDcfPrerequsite();
            if (prerequisite != null)
            {
                version = prerequisite.Version;
            }
            else
            {
                version = Manifest.DeprecatedDcfPrerequisiteSingle.Version; // we can't find an installed version of Laurel Bridge
            }
            return version;
        }

        /// <summary>
        /// Runs dcf_info.exe to see if the Laurel Bridge toolkit is configured correctly. Does not return any configuration
        /// error messages.
        /// </summary>
        /// <returns></returns>
        public static bool IsLaurelBridgeLicensed()
        {
            string licenseErrorDetail = null;
            return IsLaurelBridgeLicensed(ref licenseErrorDetail);
        }

        /// <summary>
        /// Runs dcf_info.exe to see if the Laurel Bridge toolkit is configured correctly. This
        /// included checking the validity of the run time license.
        /// </summary>
        /// <returns><c>true</c> if the DCF toolkit is configured correctly; otherwise <c>false</c></returns>
        public static bool IsLaurelBridgeLicensed(ref string licenseErrorDetail)
        {
            bool isLicensed = false;

            if (IsLaurelBridgeInstalled() == false)
            {
                return false;
            }

            String dcfBin = Environment.GetEnvironmentVariable("DCF_BIN", EnvironmentVariableTarget.Machine);
            licenseErrorDetail = ""; // establish a default

            if (dcfBin != null)
            {
                Process externalProcess = new System.Diagnostics.Process();
                try
                {
                    String dcfInfoFilespec = Path.Combine(dcfBin, @"dcf_info.exe");

                    externalProcess.StartInfo.FileName = dcfInfoFilespec;
                    //externalProcess.StartInfo.Arguments = commandParameters;
                    externalProcess.StartInfo.WorkingDirectory = dcfBin;
                    externalProcess.StartInfo.UseShellExecute = false;
                    //externalProcess.StartInfo.RedirectStandardError = true;
                    externalProcess.StartInfo.RedirectStandardOutput = true;
                    externalProcess.StartInfo.CreateNoWindow = true; // DKB - 5/25/10
                    InitializeProcessEnvironmentForLaurelBridge(externalProcess);
                    // kick off dcf_info.exe
                    externalProcess.Start();
                    do
                    {
                        Thread.Sleep(500);
                        externalProcess.Refresh();
                    } while (!externalProcess.HasExited);

                    if (externalProcess.ExitCode == 0)
                    {
                        string output = externalProcess.StandardOutput.ReadToEnd();
                        if (output.IndexOf("invalid") < 0)
                        {
                            isLicensed = true;
                        }
                        else // try and return a meaningful error message about why the license is not valid
                        {
                            licenseErrorDetail = ParseDcfInfoOutputForErrorMessage(output);
                        }
                    }
                    else
                    {
                        Info("LaurelBridgeFacade.IsLaurelBridgeLicensed(): Error running dcf_info.exe");
                        licenseErrorDetail = "Error running dcf_info.exe";
                    }
                }
                catch (Exception ex)
                {
                    Info("LaurelBridgeFacade.IsLaurelBridgeLicensed() Exception: " + ex.Message);
                    licenseErrorDetail = "Exception occurred: " + ex.Message;
                }
                finally
                {
                    externalProcess.Close();
                    externalProcess = null;
                }
            }

            return isLicensed;
        }

        /// <summary>
        /// Parses the standard output from the execution of dcf_info.exe for an error message.
        /// </summary>
        /// <param name="output">The standard output from a dcf_info run as a string.</param>
        /// <returns>The error message string or a canned response indicating no error message found.</returns>
        private static string ParseDcfInfoOutputForErrorMessage(string output)
        {
            string licenseErrorDetail = "no error license information available";
            string[] errorLines = output.Split('\n');
            for (int i = 0; i < errorLines.Length; i++)
            {
                if (errorLines[i].StartsWith("invalid"))
                {
                    if (i + 1 < errorLines.Length)
                    {
                        licenseErrorDetail += errorLines[i + 1] + "\n";
                        Info(licenseErrorDetail);
                    }
                    else // should not happen unless Laurel Bridge radically changes dcf_info.exe output
                    {
                        licenseErrorDetail = "Invalid Laurel Bridge run time license for this computer.";
                        Info(licenseErrorDetail);
                    }
                    break;
                }
            }
            return licenseErrorDetail;
        }

        /// <summary>
        /// Initializes the process environment with the variables needed for a Laurel Bridge dcf_info.exe call to succeed.
        /// </summary>
        /// <param name="externalProcess"></param>
        /// <returns><c>true</c> if the environment was successfully initialized; otherwise <c>false</c></returns>
        private static void InitializeProcessEnvironmentForLaurelBridge(Process externalProcess)
        {
            // initialize the DCF environment required by dcf_info.exe
            string dcf = Environment.GetEnvironmentVariable("DCF_BIN", EnvironmentVariableTarget.Machine);
            if (dcf != null)
            {
                if (externalProcess.StartInfo.EnvironmentVariables.ContainsKey("DCF_BIN"))
                {
                    externalProcess.StartInfo.EnvironmentVariables.Remove("DCF_BIN");
                }
                externalProcess.StartInfo.EnvironmentVariables.Add("DCF_BIN", dcf);
            }

            dcf = Environment.GetEnvironmentVariable("DCF_CFG", EnvironmentVariableTarget.Machine);
            if (dcf != null)
            {
                if (externalProcess.StartInfo.EnvironmentVariables.ContainsKey("DCF_CFG"))
                {
                    externalProcess.StartInfo.EnvironmentVariables.Remove("DCF_CFG");
                }
                externalProcess.StartInfo.EnvironmentVariables.Add("DCF_CFG", dcf);
            }

            dcf = Environment.GetEnvironmentVariable("DCF_CLASSES", EnvironmentVariableTarget.Machine);
            if (dcf != null)
            {
                if (externalProcess.StartInfo.EnvironmentVariables.ContainsKey("DCF_CLASSES"))
                {
                    externalProcess.StartInfo.EnvironmentVariables.Remove("DCF_CLASSES");
                }
                externalProcess.StartInfo.EnvironmentVariables.Add("DCF_CLASSES", dcf);
            }

            dcf = Environment.GetEnvironmentVariable("DCF_LIB", EnvironmentVariableTarget.Machine);
            if (dcf != null)
            {
                if (externalProcess.StartInfo.EnvironmentVariables.ContainsKey("DCF_LIB"))
                {
                    externalProcess.StartInfo.EnvironmentVariables.Remove("DCF_LIB");
                }
                externalProcess.StartInfo.EnvironmentVariables.Add("DCF_LIB", dcf);
            }

            dcf = Environment.GetEnvironmentVariable("DCF_LOG", EnvironmentVariableTarget.Machine);
            if (dcf != null)
            {
                if (externalProcess.StartInfo.EnvironmentVariables.ContainsKey("DCF_LOG"))
                {
                    externalProcess.StartInfo.EnvironmentVariables.Remove("DCF_LOG");
                }
                externalProcess.StartInfo.EnvironmentVariables.Add("DCF_LOG", dcf);
            }

            dcf = Environment.GetEnvironmentVariable("DCF_PLATFORM", EnvironmentVariableTarget.Machine);
            if (dcf != null)
            {
                if (externalProcess.StartInfo.EnvironmentVariables.ContainsKey("DCF_PLATFORM"))
                {
                    externalProcess.StartInfo.EnvironmentVariables.Remove("DCF_PLATFORM");
                }
                externalProcess.StartInfo.EnvironmentVariables.Add("DCF_PLATFORM", dcf);
            }

            dcf = Environment.GetEnvironmentVariable("DCF_ROOT", EnvironmentVariableTarget.Machine);
            if (dcf != null)
            {
                if (externalProcess.StartInfo.EnvironmentVariables.ContainsKey("DCF_ROOT"))
                {
                    externalProcess.StartInfo.EnvironmentVariables.Remove("DCF_ROOT");
                }
                externalProcess.StartInfo.EnvironmentVariables.Add("DCF_ROOT", dcf);
            }

            dcf = Environment.GetEnvironmentVariable("DCF_TMP", EnvironmentVariableTarget.Machine);
            if (dcf != null)
            {
                if (externalProcess.StartInfo.EnvironmentVariables.ContainsKey("DCF_TMP"))
                {
                    externalProcess.StartInfo.EnvironmentVariables.Remove("DCF_TMP");
                }
                externalProcess.StartInfo.EnvironmentVariables.Add("DCF_TMP", dcf);
            }

            String path = Environment.GetEnvironmentVariable("path", EnvironmentVariableTarget.Machine);
            if (externalProcess.StartInfo.EnvironmentVariables.ContainsKey("path"))
            {
                externalProcess.StartInfo.EnvironmentVariables.Remove("path");
            }
            externalProcess.StartInfo.EnvironmentVariables.Add("path", path);
        }

        /// <summary>
        /// Examine the passed configuration parameters, which for P34 will be initialized with DICOM configuration information, to determine if
        /// the Laurel Bridge toolkit needs to be installed.
        /// </summary>
        /// <param name="config"></param>
        /// <returns><c>true</c> if a DCF toolkit is required; otherwise <c>false</c></returns>
        public static bool IsLaurelBridgeRequired(IVixConfigurationParameters config)
        {
            bool isRequired = config.IsLaurelBridgeRequired; // provides for developer override from app.config file - usually returns true;

            if (config.VixRole == VixRoleType.DicomGateway && config.DicomListenerEnabled == false)
            {
                isRequired = false;
            }

            return isRequired;
        }

        /// <summary>
        /// Checks to see if the Laurel Bridge toolkit is installed on the current machine. The criteria used to make this
        /// determination is to check for the DCF_CFG environment variable, and if found check for the existence of the
        /// run time license at the location specified.
        /// </summary>
        /// <returns><c>true</c> if a DCF toolkit is installed; otherwise <c>false</c></returns>
        public static bool IsLaurelBridgeInstalled()
        {
            bool isInstalled = false;
            String dcfCfg = Environment.GetEnvironmentVariable("DCF_CFG", EnvironmentVariableTarget.Machine);

            if (dcfCfg != null)
            {
                String licensePath = Path.Combine(dcfCfg, "systeminfo");
                if (File.Exists(licensePath))
                {
                    string installedVersion = GetInstalledLaurelBridgeVersion().ToLower();
                    if (installedVersion == Manifest.ActiveDcfPrerequisite.Version)
                    {
                        isInstalled = true;
                    }
                    else if (LaurelBridgeFacade.CanRunDcfInfo())
                    {
                        isInstalled = true;
                    }
                    else
                    {
                        Info("DCF toolkit is installed but compatible C++ runtime is not");
                    }
                }
                
                if(isInstalled)
                {
                    CreateLaurelBridgeLogAndTmpDirectory();
                }
            }
            
            return isInstalled;
        }
        
        /// <summary>
        /// Check to see if a deprecated version of the DCF toolkit as specified by the manifest is installed.
        /// </summary>
        /// <returns><c>true</c> if a deprecated DCF toolkit is installed; otherwise <c>false</c></returns>
        public static bool IsDeprecatedLaurelBridgeInstalled()
        {
            bool isInstalled = false;
            if (IsLaurelBridgeInstalled()) // note: only DCF_CFG environment variable used here
            {
                string installedVersion = GetInstalledLaurelBridgeVersion();
                if (installedVersion != Manifest.ActiveDcfPrerequisite.Version)
                {
                    isInstalled = true;
                }
            }
            else
            {
                isInstalled = false; // nothing is installed - safety net
            }
            Info("IsDeprecatedLaurelBridgeInstalled: " + isInstalled.ToString());
            return isInstalled;
        }
        
        /// <summary>
        /// Creates the log and tmp folders in the DCF toolkit location if missing
        /// </summary>
        public static void CreateLaurelBridgeLogAndTmpDirectory()
        {         
            string dcfRoot = GetInstalledLaurelBridgeRootDirectory();    
            string dcfLog = Path.Combine(dcfRoot, @"log");
            if(!Directory.Exists(dcfLog))
            {
                try
                {              
                    Directory.CreateDirectory(dcfLog);
                    Info("Creating folder " + dcfLog);
                }
                catch (Exception ex)
                {
                    Info(ex.Message);
                }
            }
            string dcfTmp = Path.Combine(dcfRoot, @"tmp");
            if (!Directory.Exists(dcfTmp))
            {
                try
                {
                    Directory.CreateDirectory(dcfTmp);
                    Info("Creating folder " + dcfTmp);
                }
                catch (Exception ex)
                {
                    Info(ex.Message);
                }
            }
        }

        /// <summary>
        /// Return the fully qualified directory where DCF toolkit is currently installed.
        /// </summary>
        /// <returns>fully qualified directory name or null if DCF environment was not initialized properly</returns>
        public static string GetInstalledLaurelBridgeRootDirectory()
        {
            string dcfDir = null;
            // try to find version in a new style DCF deployment. New style means the installation that is supported in P34, and P104
            // VIXen after the 3.2.2c update.
            string dcfRootDirSpec = Environment.GetEnvironmentVariable("DCF_ROOT", EnvironmentVariableTarget.Machine);
            if (dcfRootDirSpec != null)
            {
                Info("GetLaurelBridgeVersion: Using DCF_ROOT=" + dcfRootDirSpec);
                dcfDir = dcfRootDirSpec;
            }
            else // old style DCF deployment will have bin files in the root of the DCF directory tree
            {
                string dcfBinDirSpec = Environment.GetEnvironmentVariable("DCF_BIN", EnvironmentVariableTarget.Machine);
                if (dcfBinDirSpec != null)
                {
                    Info("GetLaurelBridgeVersion: Using DCF_BIN=" + dcfBinDirSpec);
                    dcfDir = dcfBinDirSpec;
                }
                else
                {
                    Info("GetInstalledLaurelBridgeRootDirectory: current installation not found");
                }

            }
            return dcfDir;
        }

        /// <summary>
        /// Get the version of the installed DCF toolkit.
        /// </summary>
        /// <returns>The version string or the empty string if the version file isn't found.</returns>
        public static string GetInstalledLaurelBridgeVersion()
        {
            string version = "";
            string dcfDir = GetInstalledLaurelBridgeRootDirectory();
            if (dcfDir != null)
            {
                string versionFilespec = Path.Combine(dcfDir, DCF_VERSION_FILENAME);
                if (File.Exists(versionFilespec))
                {
                    using (StreamReader sr = new StreamReader(versionFilespec))
                    {
                        try
                        {
                            string line = sr.ReadLine();
                            if (line != null) // safety net
                            {
                                version = line.Trim().ToLower();
                            }
                        }
                        catch (Exception ex)
                        {
                            Info("GetLaurelBridgeVersion exception: " + ex.Message);
                        }
                        finally
                        {
                            sr.Close();
                        }
                    }
                }
                else
                {
                    Info("GetInstalledLaurelBridgeVersion: " + versionFilespec + " does not exist");
                }
            }
            Info("Installed DCF version is " + version);
            return version;
        }

        /// <summary>
        /// Install but dont configure the Active Laurel Bridge DCF toolkit. Environment variables will be initialized.
        /// </summary>
        /// <param name="dcfPath">The fully qualified directory name where the DCF toolkit should be installed</param>
        static public bool InstallLaurelBridgeDcfToolkit(string dcfPath, ref string installErrorDetail)
        {
            if (IsLaurelBridgeInstalled() == false)
            {
                try
                {
                    if (IsLaurelBridgeInstalled() == false)
                    {
                        if (Directory.Exists(dcfPath))
                        {
                            Directory.Delete(dcfPath, true);
                        }
                        if (!Directory.Exists(dcfPath))
                        {
                            Directory.CreateDirectory(dcfPath);
                        }
                        Info(Info("Installing Laurel Bridge DCF toolkit version " + Manifest.ActiveDcfPrerequisite.Version + " to " + dcfPath));
                        // for HDIG installs the 
                        ZipUtilities.ImprovedExtractToDirectory(Manifest.ActiveDcfPrerequisite.PayloadFilespec, dcfPath, ZipUtilities.Overwrite.Always);
                        DoEvents();

                        // create environment variables
                        CreateLaurelBridgeEnvironmentVariables(dcfPath);

                        // make some required sub directories - this may not be required anymore but leave anyway
                        string dir = Path.Combine(dcfPath, @"cfg\apps");
                        if (!Directory.Exists(dir))
                        {
                            Directory.CreateDirectory(dir);
                            Info("Creating folder " + dir);
                        }
                        dir = Path.Combine(dcfPath, @"cfg\apps\defaults");
                        if (!Directory.Exists(dir))
                        {
                            Directory.CreateDirectory(dir);
                            Info("Creating folder " + dir);
                        }
                        dir = Path.Combine(dcfPath, @"cfg\procs");
                        if (!Directory.Exists(dir))
                        {
                            Directory.CreateDirectory(dir);
                            Info("Creating folder " + dir);
                        }
                    }

                    //restore previous DicomScpConfig and ae_title_mappings config files if exist
                    string deprecatedDcfRoot = LaurelBridgeFacade.GetDeprecatedRenamedRootDirspec(dcfPath);
                    if (Directory.Exists(deprecatedDcfRoot))
                    {
                        string deprecateDdcfCfg = Path.Combine(deprecatedDcfRoot, @"cfg\");
                        string dcfCfg = Path.Combine(dcfPath, @"cfg\");
                        string dicomScpConfig = "DicomScpConfig";
                        if (File.Exists(Path.Combine(deprecateDdcfCfg, dicomScpConfig)))
                        {
                            File.Copy(Path.Combine(deprecateDdcfCfg, dicomScpConfig), Path.Combine(dcfCfg, dicomScpConfig), true);
                        }
                        else
                        {
                            string message = "Cannot restore DicomScpConfig file from " + deprecateDdcfCfg + " as file did not exist";
                            Info(message);
                        }

                        string deprecatedCcfCfgDicom = Path.Combine(deprecatedDcfRoot, @"cfg\dicom\");
                        string dcfCfgDicom = Path.Combine(dcfPath, @"cfg\dicom\");
                        string aetitlemappingsConfig = "ae_title_mappings";
                        if (File.Exists(Path.Combine(deprecatedCcfCfgDicom, aetitlemappingsConfig)))
                        {
                            File.Copy(Path.Combine(deprecatedCcfCfgDicom, aetitlemappingsConfig), Path.Combine(dcfCfgDicom, aetitlemappingsConfig), true);
                        }
                        else
                        {
                            string message = "Cannot restore ae_title_mappings file from " + deprecatedCcfCfgDicom + " as file did not exist";
                            Info(message);
                        }
                    }

                    // install the VC++ runtime if necessary
                    if (BusinessFacade.IsVCPlusPlus2015to2022x64RedistributableInstalled() == false)
                    {
                        Info("Installing the Visual C++ 2015-2022 Redistributable needed by the Laurel Bridge DCF toolkit");
                        if (BusinessFacade.InstallVCPlusPlusRedistributableForLaurelBridge(dcfPath) == false)
                        {
                            installErrorDetail = "Unable to install the Visual C++ 2015-2022 Redistributable needed by the Laurel Bridge DCF toolkit";
                            Info(installErrorDetail);
                        }
                    }
                }
                catch (Exception ex)
                {
                    Info("LaurelBridgeFacade.InstallLaurelBridgeDcfToolkit() Exception: " + ex.Message);
                    installErrorDetail = "Exception occurred: " + ex.Message;
                }
            }
            else
            {
                Info("Laurel Bridge DCF toolkit is already installed");
            }
            return IsLaurelBridgeInstalled();
        }

        /// <summary>
        /// Licenses a DCF installation using a MAC based key file.
        /// </summary>
        /// <param name="licenseFilespec">the key filespec</param>
        /// <param name="licenseErrorDetail">a string passed by reference that will contain any generated error messages</param>
        /// <returns>true if the installation was successfully licensed, false otherwise</returns>
        static public bool LicenseLaurelBridgeDcfToolkitWithMacBasedKeyFile(string licenseFilespec, ref string licenseErrorDetail)
        {
            bool isLicensed = IsLaurelBridgeLicensed();
            if (isLicensed == false)
            {
                try
                {
                    string dcfCfg = Environment.GetEnvironmentVariable("DCF_CFG", EnvironmentVariableTarget.Machine);
                    Debug.Assert(dcfCfg != null);
                    Debug.Assert(File.Exists(licenseFilespec));
                    string keyFilespec = Path.Combine(dcfCfg, "systeminfo");
                    string restoreFilespec = Path.Combine(dcfCfg, "systeminfo.restore");
                    if (File.Exists(keyFilespec))
                    {
                        File.Copy(keyFilespec, restoreFilespec, true);
                    }
                    File.SetAttributes(licenseFilespec, FileAttributes.Normal); // just in case the file is read only
                    Info("Copying license key file " + licenseFilespec + " to " + keyFilespec + ".");
                    File.Copy(licenseFilespec, keyFilespec, true); // overwrite
                    // check if licensing sucessful
                    DoEvents();
                    try
                    {
                        isLicensed = IsLaurelBridgeLicensed(ref licenseErrorDetail);
                    }
                    finally
                    {
                        if (isLicensed == false)
                        {
                            Info(licenseErrorDetail);
                            // restore the VA systeminfo that is suitable for enterprise licensing
                            File.Copy(restoreFilespec, keyFilespec, true);
                            File.Delete(restoreFilespec);
                        }
                    }
                    DoEvents();
                }
                catch (Exception ex)
                {
                    Info("LaurelBridgeFacade.LicenseLaurelBridgeDcfToolkitWithMacBasedKeyFile Exception: " + ex.Message);
                }
            }
            else
            {
                Info("Laurel Brdige DCF toolkit is already licensed.");
            }

            return isLicensed;
        }

        /// <summary>
        /// License the DCF installation using Enterprise License Activation. The UI will provide feedback as to sucess or failure.
        /// </summary>
        /// <param name="macAddress">the MAC address from the previous installation or null</param>
        static public void LicenseLaurelBridgeDcfToolkitWithEnterpriseLicense(string macAddress)
        {
            if (IsLaurelBridgeLicensed() == false) // safety net
            {
                string dcfClasses = Environment.GetEnvironmentVariable("DCF_CLASSES", EnvironmentVariableTarget.Machine);
                if (dcfClasses != null) //safety net
                {
                    Process externalProcess = new System.Diagnostics.Process();
                    try
                    {
                        string javaExeFilespec = Path.Combine(JavaFacade.GetActiveJavaPath(JavaFacade.IsActiveJreInstalled()), @"bin\java.exe");
                        string args = @"-cp LaurelBridge.jar com.lbs.ActivateDcfLicense.ActivateDcfLicense";
                        if (macAddress != null)
                        {
                            args += " -u \"" + macAddress + "\"";
                        }

                        externalProcess.StartInfo.FileName = javaExeFilespec;
                        externalProcess.StartInfo.Arguments = args;
                        externalProcess.StartInfo.WorkingDirectory = dcfClasses;
                        externalProcess.StartInfo.UseShellExecute = false;
                        //externalProcess.StartInfo.RedirectStandardError = true;
                        //externalProcess.StartInfo.RedirectStandardOutput = true;
                        externalProcess.StartInfo.CreateNoWindow = true;
                        InitializeProcessEnvironmentForLaurelBridge(externalProcess);
                        externalProcess.Start();
                        do
                        {
                            Thread.Sleep(500);
                            externalProcess.Refresh();
                        } while (!externalProcess.HasExited);
                    }
                    finally
                    {
                        externalProcess.Close();
                        externalProcess = null;
                    }
                }
            }
        }

        /// <summary>
        /// Creates the windows environment variables required by the DCF toolkit.
        /// </summary>
        /// <param name="dcfPath">the root dirspec of the DCF installation</param>
        public static void CreateLaurelBridgeEnvironmentVariables(string dcfPath)
        {
            string dcf_bin = Path.Combine(dcfPath, "bin");
            string dcf_cfg = Path.Combine(dcfPath, "cfg");
            string dcf_classes = Path.Combine(dcfPath, "Classes");
            string dcf_lib = Path.Combine(dcfPath, "lib");
            string dcf_tmp = Path.Combine(dcfPath, "tmp");
            string dcf_log = Path.Combine(dcfPath, "log");
            string dcf_platform = "Windows_x64_VisualStudio16.x";
            string dcf_root = dcfPath;
            // new additions for P66 and HDIG
            string dcf_user_bin = dcf_bin;
            string dcf_user_classes = dcf_classes;
            string dcf_user_lib = dcf_lib;
            string dcf_user_root = dcf_root;
            string omni_bin = dcf_bin;
            string omni_lib = dcf_lib;
            string omni_root = Path.Combine(dcfPath, "omni");
            string ld_library_path = dcf_lib;

            Info("Setting Windows environment variable DCF_BIN=" + dcf_bin);
            Environment.SetEnvironmentVariable("DCF_BIN", dcf_bin, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable DCF_CFG=" + dcf_cfg);
            Environment.SetEnvironmentVariable("DCF_CFG", dcf_cfg, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable DCF_CLASSES=" + dcf_classes);
            Environment.SetEnvironmentVariable("DCF_CLASSES", dcf_classes, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable DCF_LIB=" + dcf_lib);
            Environment.SetEnvironmentVariable("DCF_LIB", dcf_lib, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable DCF_TMP=" + dcf_tmp);
            Environment.SetEnvironmentVariable("DCF_TMP", dcf_tmp, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable DCF_LOG=" + dcf_log);
            Environment.SetEnvironmentVariable("DCF_LOG", dcf_log, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable DCF_PLATFORM=" + dcf_platform);
            Environment.SetEnvironmentVariable("DCF_PLATFORM", dcf_platform, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable DCF_ROOT=" + dcf_root);
            Environment.SetEnvironmentVariable("DCF_ROOT", dcf_root, EnvironmentVariableTarget.Machine);
            // new additions
            Info("Setting Windows environment variable DCF_USER_BIN=" + dcf_user_bin);
            Environment.SetEnvironmentVariable("DCF_USER_BIN", dcf_user_bin, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable DCF_USER_CLASSES=" + dcf_user_classes);
            Environment.SetEnvironmentVariable("DCF_USER_CLASSES", dcf_user_classes, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable DCF_USER_LIB=" + dcf_user_lib);
            Environment.SetEnvironmentVariable("DCF_USER_LIB", dcf_user_lib, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable DCF_USER_ROOT=" + dcf_user_root);
            Environment.SetEnvironmentVariable("DCF_USER_ROOT", dcf_user_root, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable OMNI_BIN=" + omni_bin);
            Environment.SetEnvironmentVariable("OMNI_BIN", omni_bin, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable OMNI_LIB=" + omni_lib);
            Environment.SetEnvironmentVariable("OMNI_LIB", omni_lib, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable OMNI_ROOT=" + omni_root);
            Environment.SetEnvironmentVariable("OMNI_ROOT", omni_root, EnvironmentVariableTarget.Machine);
            Info("Setting Windows environment variable LD_LIBRARY_PATH=" + ld_library_path);
            Environment.SetEnvironmentVariable("LD_LIBRARY_PATH", ld_library_path, EnvironmentVariableTarget.Machine);

            Info("Adding DCF_BIN to Windows PATH environment variable");
            AppendToPath(dcf_bin);
            Info("Adding DCF_LIB to Windows PATH environment variable");
            AppendToPath(dcf_lib);
        }

        /// <summary>
        /// Removes the windows environment variables required by the DCF toolkit.
        /// </summary>
        public static void RemoveLaurelBridgeEnvironmentVariables()
        {
            string dcfPath = GetInstalledLaurelBridgeRootDirectory(); // uses DCF_ROOT or DCF_BIN
            if (dcfPath != null)
            {
                if (dcfPath == @"C:\DCF") // Patch 83 installation - hate this but the dir structure changed to we have to deal
                {
                    Info(@"Removing C:\DCF from Windows PATH environment variable");
                    RemoveFromPath(@"C:\DCF");
                }
                else
                {
                    string dcf_bin = Path.Combine(dcfPath, "bin");
                    string dcf_lib = Path.Combine(dcfPath, "lib");
                    Info("Removing DCF_BIN from Windows PATH environment variable");
                    RemoveFromPath(dcf_bin);
                    Info("Removing DCF_LIB from Windows PATH environment variable");
                    RemoveFromPath(dcf_lib);
                }
            }
            else
            {
                Info("RemoveLaurelBridgeEnvironmentVariables: GetInstalledLaurelBridgeRootDirectory() returned null");
            }

            Info("Removing Windows environment variable DCF_BIN");
            Environment.SetEnvironmentVariable("DCF_BIN", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable DCF_CFG");
            Environment.SetEnvironmentVariable("DCF_CFG", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable DCF_CLASSES");
            Environment.SetEnvironmentVariable("DCF_CLASSES", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable DCF_LIB");
            Environment.SetEnvironmentVariable("DCF_LIB", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable DCF_TMP");
            Environment.SetEnvironmentVariable("DCF_TMP", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable DCF_LOG");
            Environment.SetEnvironmentVariable("DCF_LOG", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable DCF_PLATFORM");
            Environment.SetEnvironmentVariable("DCF_PLATFORM", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable DCF_ROOT");
            Environment.SetEnvironmentVariable("DCF_ROOT", null, EnvironmentVariableTarget.Machine);
            // new additions
            Info("Removing Windows environment variable DCF_USER_BIN");
            Environment.SetEnvironmentVariable("DCF_USER_BIN", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable DCF_USER_CLASSES");
            Environment.SetEnvironmentVariable("DCF_USER_CLASSES", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable DCF_USER_LIB");
            Environment.SetEnvironmentVariable("DCF_USER_LIB", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable DCF_USER_ROOT");
            Environment.SetEnvironmentVariable("DCF_USER_ROOT", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable OMNI_BIN");
            Environment.SetEnvironmentVariable("OMNI_BIN", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable OMNI_LIB");
            Environment.SetEnvironmentVariable("OMNI_LIB", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable OMNI_ROOT");
            Environment.SetEnvironmentVariable("OMNI_ROOT", null, EnvironmentVariableTarget.Machine);
            Info("Removing Windows environment variable LD_LIBRARY_PATH");
            Environment.SetEnvironmentVariable("LD_LIBRARY_PATH", null, EnvironmentVariableTarget.Machine);
        }

        /// <summary>
        /// Appends a path fragment to the Windows path environment variable.
        /// </summary>
        /// <param name="pathFragment">The path fragment to append.</param>
        private static void AppendToPath(string pathFragment)
        {
            // append to the path
            String path = Environment.GetEnvironmentVariable("path", EnvironmentVariableTarget.Machine);
            if (path == null)
            {
                Info("Adding " + pathFragment + " to the Windows PATH environment variable");
                Environment.SetEnvironmentVariable("path", pathFragment, EnvironmentVariableTarget.Machine);
            }
            else
            {
                if (!path.Contains(pathFragment))
                {
                    if (!path.EndsWith(";"))
                    {
                        path += ";";
                    }
                    path += pathFragment;
                    Environment.SetEnvironmentVariable("path", path, EnvironmentVariableTarget.Machine);
                }
            }
        }

        /// <summary>
        /// Removes a path fragment from the Windows path environment variable.
        /// </summary>
        /// <param name="pathFragment">The path fragment to remove.</param>
        private static void RemoveFromPath(string pathFragment)
        {
            // remove from the path
            string path = Environment.GetEnvironmentVariable("path", EnvironmentVariableTarget.Machine);
            if (path != null) // safety net
            {
                if (path.Contains(pathFragment + ";"))
                {
                    path = path.Replace(pathFragment + ";", "");
                    Environment.SetEnvironmentVariable("path", path, EnvironmentVariableTarget.Machine);
                }
                if (path.Contains(pathFragment))
                {
                    path = path.Replace(pathFragment, "");
                    Environment.SetEnvironmentVariable("path", path, EnvironmentVariableTarget.Machine);
                }
            }
        }

        /// <summary>
        /// Generates the root dirspec where the deprecated DCF directories will be stored
        /// </summary>
        /// <param name="deprecatedDcfRoot">The dirspec where the deprecated DCF is installed</param>
        /// <returns>A dirspec suitable for use in backing up the deprecated DCF installation</returns>
        public static string GetDeprecatedRenamedRootDirspec(string deprecatedDcfRoot)
        {
            Debug.Assert(deprecatedDcfRoot != null);
            string deprecatedVersion = GetDeprecatedLaurelBridgeVersion();
            deprecatedVersion = deprecatedVersion.Replace(".", "_");

            string[] splits = deprecatedDcfRoot.Split('\\');
            Debug.Assert(splits.Length > 0);
            string dcfDirName = splits[splits.Length - 1];
            string dcfRenamedRoot = deprecatedDcfRoot.Replace(dcfDirName, dcfDirName + "_" + deprecatedVersion);
            return dcfRenamedRoot;
        }

        /// <summary>
        /// Get the MAC address from the deprecated LB license file if present
        /// </summary>
        /// <param name="deprecatedDcfRoot">The dirspec where the deprecated DCF is installed</param>
        /// <returns>the MAX address from the deprecated license file if found, otherwise null</returns>
        public static string GetMacAddressFromDeprecatedKeyFile(string deprecatedDcfRoot)
        {
            string macAddress = null;
            if (deprecatedDcfRoot != null)
            {
                string deprecatedKeyFile = Path.Combine(deprecatedDcfRoot, @"cfg\systeminfo");

                if (File.Exists(deprecatedKeyFile) == true)
                {
                    using (StreamReader sr = new StreamReader(deprecatedKeyFile))
                    {
                        String line;
                        while ((line = sr.ReadLine()) != null)
                        {
                            if (line.Contains("machine_id"))
                            {
                                string[] splits = line.Split('=');
                                if (splits.Length == 2)
                                {
                                    macAddress = splits[1].Trim();
                                }
                                break;
                            }
                        }
                        sr.Close();
                    }
                }
            }
            return macAddress;
        }

        /// <summary>
        /// Removes the currently installed DCF toolkit by renaming the installation directory, deleting environment
        /// variables, and removing relevant directories from the path environment variable. As a side effect, the
        /// the directory that the deprecated installation is saved is stored in the VIX configuration.
        /// </summary>
        /// <param name="config">VIX installer configuration</param>
        static public void RemoveLaurelBridgeInstallation(IVixConfigurationParameters config)
        {
            string dcfRoot = GetInstalledLaurelBridgeRootDirectory(); // uses DCF_ROOT or DCF_BIN
            if (dcfRoot == null || Directory.Exists(dcfRoot) == false)
            {
                dcfRoot = GetActiveDcfRootFromManifest(); // check to make sure where we want to install doesnt exist - safety net
                if (Directory.Exists(dcfRoot) == false)
                {
                    Info("Cannot remove existing Laurel Bridge installation - directory not found)");
                    dcfRoot = null;
                }
            }

            if (dcfRoot != null)
            {
                dcfRoot = dcfRoot.Replace("/", @"\"); // convert any forward slashes to back slashes
                dcfRoot = dcfRoot.TrimEnd('\\');
                string dcfRenamedRoot = GetDeprecatedRenamedRootDirspec(dcfRoot);
                config.RenamedDeprecatedDcfRoot = dcfRenamedRoot;

                // this can happen in development/text
                if (Directory.Exists(dcfRenamedRoot))
                {
                    Directory.Delete(dcfRenamedRoot, true);
                }
                try
                {
                    Directory.Move(dcfRoot, dcfRenamedRoot);
                }
                catch (Exception ex)
                {
                    string message = "Cannot rename DCF directory from " + dcfRoot + " to " + dcfRenamedRoot + "\nException message is\n" + ex.Message;
                    Info(message);
                }
            }
            RemoveLaurelBridgeEnvironmentVariables();
        }

        /// <summary>
        /// Loads the config file from disk and if does not match the current previous verison of the DCF toolkit
        /// the folder is deleted
        /// </summary>
        /// <param name="renamedDeprecatedDcfRoot">The dirspec that the previous version of the DCF toolkit has been renamed to.</param>
        public static void DeleteOldDeprecatedDcfRoot(string renamedDeprecatedDcfRoot)
        {
            if (renamedDeprecatedDcfRoot != null)
            {
                VixConfigurationParameters config = VixConfigurationParameters.FromXml(VixFacade.GetVixConfigurationDirectory());
                if (config != null && config.RenamedDeprecatedDcfRoot != renamedDeprecatedDcfRoot)
                {
                    if (Directory.Exists(config.RenamedDeprecatedDcfRoot))
                    {
                        try
                        {
                            Directory.Delete(config.RenamedDeprecatedDcfRoot, true);
                        }
                        catch (Exception ex)
                        {
                            string message = "Cannot delete old DCF directory from " + config.RenamedDeprecatedDcfRoot + "\nException message is\n" + ex.Message;
                            Info(message);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// Removes the renamed DCF toolkit folder if exists
        /// </summary>
        /// <param name="renamedDeprecatedDcfRoot">The dirspec that the previous version of the DCF toolkit has been renamed to.</param>
        public static void DeleteDeprecatedDcfRoot(string renamedDeprecatedDcfRoot)
        {
            if (renamedDeprecatedDcfRoot != null)
            {
                if (Directory.Exists(renamedDeprecatedDcfRoot))
                {
                    try
                    {
                        Directory.Delete(renamedDeprecatedDcfRoot, true);
                    }
                    catch (Exception ex)
                    {
                        string message = "Cannot delete deprecated DCF directory from " + renamedDeprecatedDcfRoot + "\nException message is\n" + ex.Message;
                        Info(message);
                    }
                }  
            }
        }

        /// <summary>
        /// Load the config file from disk, initialize RenamedDeprecatedDcfRoot, then save it back so we dont lose this
        /// information. We don't want to save anything else until the install is complete.
        /// </summary>
        /// <param name="renamedDeprecatedDcfRoot">The dirspec that the previous version of the DCF toolkit has been renamed to.</param>
        public static void SaveRenamedDeprecatedDcfRoot(string renamedDeprecatedDcfRoot)
        {
            if (renamedDeprecatedDcfRoot != null)
            {
                VixConfigurationParameters config = VixConfigurationParameters.FromXml(VixFacade.GetVixConfigurationDirectory());
                if (config != null)
                {
                    config.RenamedDeprecatedDcfRoot = renamedDeprecatedDcfRoot;
                    config.ToXml();
                }
            }
        }

        /// <summary>
        /// Determine if a Visual Studio C++ Redistributable package is installed that can support
        /// Activation Request Code generation.
        /// </summary>
        /// <param name="cwd">The current working dirspec</param>
        /// <returns><c>true</c> if dcf_info.exe can run; otherwise, <c>false</c>.</returns>
        public static bool CanRunDcfInfo()
        {
            bool canRun = false;
            Process externalProcess = new System.Diagnostics.Process();
            try
            {
                String dcfBin = Environment.GetEnvironmentVariable("DCF_BIN", EnvironmentVariableTarget.Machine);
                String dcfInfoFilespec = Path.Combine(dcfBin, @"dcf_info.exe");

                externalProcess.StartInfo.FileName = dcfInfoFilespec;
                externalProcess.StartInfo.Arguments = "-r";
                externalProcess.StartInfo.WorkingDirectory = dcfBin;
                externalProcess.StartInfo.UseShellExecute = false;
                externalProcess.StartInfo.ErrorDialog = false;
                externalProcess.StartInfo.RedirectStandardError = true;
                externalProcess.StartInfo.RedirectStandardOutput = true;
                externalProcess.StartInfo.CreateNoWindow = true; // DKB - 5/25/10
                InitializeProcessEnvironmentForLaurelBridge(externalProcess);
                // kick off dcf_info.exe
                externalProcess.Start();
                do
                {
                    Thread.Sleep(500);
                    externalProcess.Refresh();
                } while (!externalProcess.HasExited);

                if (externalProcess.ExitCode == 0)
                {
                    canRun = true;
                }
            }
            catch (Exception)
            {
                canRun = false; // place holder - already false
            }
            finally
            {
                externalProcess.Close();
                externalProcess = null;
            }
            return canRun;
        }

        #region Private methods
        /// <summary>
        /// Determines whether the provided DCF prerequisite is installed.
        /// </summary>
        /// <param name="prerequisite">The prerequisite to check for.</param>
        /// <returns><c>true</c> if DCF prerequisite is installed; otherwise, <c>false</c>.</returns>
        private static bool IsPrerequisiteInstalled(DcfPrerequisite prerequisite)
        {
            bool isInstalled = false;
            string installedVersion = GetInstalledLaurelBridgeVersion().ToLower();
            
            if (installedVersion != null && installedVersion == prerequisite.Version)
            {
                isInstalled = true;
            }

            return isInstalled;
        }

        /// <summary>
        /// Gets the installed deprecated DCF prerequisite.
        /// </summary>
        /// <returns>the installed deprecated DCF prerequisite.</returns>
        /// <remarks>can return null</remarks>
        private static DcfPrerequisite GetInstalledDeprecatedDcfPrerequsite()
        {
            Debug.Assert(IsLaurelBridgeInstalled() == true);
            string installedDcfVersion = GetInstalledLaurelBridgeVersion();
            DcfPrerequisite dcfPrerequisite = null;

            foreach (DcfPrerequisite prerequisite in Manifest.DeprecatedDcfPrerequisites)
            {
                if (IsPrerequisiteInstalled(prerequisite))
                {
                    dcfPrerequisite = prerequisite;
                    break;
                }
            }
            return dcfPrerequisite;
        }

        #endregion
    }
}
