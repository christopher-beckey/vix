using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.IO;
using System.Diagnostics;
using log4net;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public enum VixPrerequisiteOption { Active, Deprecated };
    public enum VixWebApplicationOption { AddUpdate, Remove };
    public enum VixJavaPropertyOption { AddUpdate, Remove, Installed };
    public enum VixConfigFileOption { DoNotCopyIfExist, Remove, Installed };
    
    public enum VixJavaPropertyType {property, memory};
    public enum ViXConfigurationUtilityType { ViX, Realm, Cache, SiteResolutionProvider, ClinicalDisplayProvider,
        ExchangeDataSourceProvider, ImageConversion, VistaDataSourceProvider, FederationDataSourceProvider,
        TransactionLoggerJdbcSourceProvider, VixHealthConfiguration, NotificationConfiguration, NotificationEmailConfiguration,
        XCAInitiatingGatewayDataSourceProvider, ExchangeProcedureFilterTermsConfiguration, VixLogConfiguration, ByteBufferPoolConfiguration,
        VistaRadCommandConfiguration, IdsProxyConfiguration, DicomGatewayConfiguration, StorageServerConfiguration, PeriodicCommandConfiguration,
        VistaConnectionConfiguration, CommandConfiguration, RoiConfiguration, ImageGearDataSourceProvider, VistaOnlyDataSourceProvider,
        ImagingFacadeConfiguration, MixDataSourceProvider, DxDataSourceProvider, FileSystemCacheConfigurator, MuseDataSourceProvider, IngestConfiguration, 
		ScpConfiguration, DicomCategoryFilterConfiguration
    }
    public enum AppFolderType { TomcatRoot, JavaRoot, VixConfigRoot, AbsoluteFilespec, NoRoot, CertificateRoot, DcfRoot }

    public enum VixDeploymentType
    { 
        SingleServer,
        FirstFocClusterNode, // deprecated but retained during migration to FocClusterNode
        SecondFocClusterNode, // deprecated but retained during migration to FocClusterNode
        //CvixClusterNode,
        //CvixFirstFocClusterNode,
        //CvixSecondFocClusterNode,
        NotSpecified,
        FocClusterNode, // generically replaces the 4 deprecated FocClusterNode options
        Deprecated
        //CvixFocClusterNode // generically replaces the 2 deprecated CvixFocClusterNode options
    };
    public enum VixRoleType
    {
        SiteVix, EnterpriseGateway, LoggingVix, MiniVix, NotSpecified, DicomGateway, RelayVix
    }
    public enum VixCacheType { 
        ExchangeTimeEvictionLocalFilesystem, 
        ExchangeTimeStorageEvictionLocalFilesystem,
        ExchangeTimeEvictionCifsFilesystem, 
        ExchangeTimeStorageEvictionCifsFilesystem,
        NotSpecified, NotRequired };

    public enum VixDependencyType { AppExtensionJar, XmlConfigFile, OpenSourceDll, CommercialDll, OpenSourceJar,
    ModifiedOpenSourceJar, CommercialJar, AppJar, AppWar, JavaPropertyFile, ZipConfigFile, ResourceFile, TextFile, InHouseDll,
    ModifiedOpenSourceDll, Certificate, RoiAnnotationExe, RoiPdfExe, CommercialOcx, CommercialOther, IngestThumbnailMakerExe, 
	IngestConversionExe
    };

    public enum DcfLicenseType { MAC, Enterprise };
    public enum NativeType { x86, x64, all };

    public class VixManifest
    {
        private string appRoot = null;
        private string payloadPath = null;
        private string manifestFilespec = null;

        private XmlDocument manifest = null;
        private DcfPrerequisite activeDcfPrerequisite = null;
        private DcfPrerequisite deprecatedDcfPrerequisiteSingle = null;
        private DcfPrerequisite[] deprecatedDcfPrerequisites = null;
        private TomcatPrerequisite activeTomcatPrerequisite = null;
        private TomcatPrerequisite[] deprecatedTomcatPrerequisites = null;
        private JavaPrerequisite activejavaPrerequisite = null;
        private JavaPrerequisite[] deprecatedJavaPrerequisites = null;
        private ZFViewerPrerequisite activeZFViewerPrerequisite = null;
        private ZFViewerPrerequisite[] deprecatedZFViewerPrerequisites = null;
        private VixCacheConfiguration[] vixCacheConfigurations = null;
        private VixDeploymentConfiguration[] vixDeploymentConfigurations = null;
        private VixJavaConfigurationUtility[] javaConfigurationUtilityProperties = null;
        private ListenerPrerequisite activeListenerPrerequisite = null;
        private ListenerPrerequisite[] deprecatedListenerPrerequisites = null;

        public VixManifest(String appRoot)
        {
            Debug.Assert(appRoot != null);
            this.appRoot = appRoot;
            this.manifestFilespec = Path.Combine(appRoot, VixManifest.ManifestFilename);
            Debug.Assert(File.Exists(this.manifestFilespec));
            this.manifest = new XmlDocument();
            this.manifest.Load(this.manifestFilespec);
            this.payloadPath = BusinessFacade.GetPayloadPath(this.FullyQualifiedPatchNumber, appRoot); ;
        }

        #region public properties
        public static string ManifestFilename { get { return "VixManifest.xml"; } }
        public string AppRoot
        {
            get { return appRoot; }
            set { appRoot = value; }
        }

        public XmlDocument ManifestDoc
        {
            get { return manifest; }
        }
        public static ILog Logger()
        {
            return LogManager.GetLogger(typeof(VixManifest).Name);
        }

        public DcfPrerequisite ActiveDcfPrerequisite
        {
            get
            {
                if (activeDcfPrerequisite == null)
                {
                    string xpath = null;
                    if (Enable64BitInstallation)
                    {
                        // native attributes are be defined on Java prerequisite elements - use them
                        if (BusinessFacade.Is64BitOperatingSystem())
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Laurel Bridge' and @option='Active' and @native='x64']";
                        }
                        else
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Laurel Bridge' and @option='Active' and @native='x86']";
                        }
                    }
                    else
                    {
                        xpath = "VixManifest/Prerequisites/Prerequisite[@name='Laurel Bridge' and @option='Active']";
                    }
                    XmlNode xmlPrerequisite = this.manifest.SelectSingleNode(xpath);
                    activeDcfPrerequisite = new DcfPrerequisite(xmlPrerequisite, PayloadPath);
                }
                return activeDcfPrerequisite;
            }
        }
        public DcfPrerequisite[] DeprecatedDcfPrerequisites
        {
            get
            {
                if (deprecatedDcfPrerequisites == null)
                {
                    string xpath = null;
                    string systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper();
                    if (Enable64BitInstallation)
                    {
                        // native attributes are be defined on Java prerequisite elements - use them
                        if (BusinessFacade.Is64BitOperatingSystem())
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Laurel Bridge' and @option='Deprecated' and @native='x64']";
                        }
                        else
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Laurel Bridge' and @option='Deprecated' and @native='x86']";
                        }
                    }
                    else
                    {
                        xpath = "VixManifest/Prerequisites/Prerequisite[@name='Laurel Bridge' and @option='Deprecated']";
                    }

                    List<DcfPrerequisite> prerequisiteList = new List<DcfPrerequisite>();
                    XmlNodeList xmlPrerequisiteList = this.manifest.SelectNodes(xpath);

                    foreach (XmlNode xmlPrerequisite in xmlPrerequisiteList)
                    {
                        prerequisiteList.Add(new DcfPrerequisite(xmlPrerequisite, PayloadPath));
                    }

                    deprecatedDcfPrerequisites = prerequisiteList.ToArray();
                }
                return deprecatedDcfPrerequisites;
            }
        }

        public DcfPrerequisite DeprecatedDcfPrerequisiteSingle
        {
            get
            {
                if (deprecatedDcfPrerequisiteSingle == null)
                {
                    string xpath = null;
                    if (Enable64BitInstallation)
                    {
                        // native attributes are be defined on Java prerequisite elements - use them
                        if (BusinessFacade.Is64BitOperatingSystem())
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Laurel Bridge' and @option='Deprecated' and @native='x64']";
                        }
                        else
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Laurel Bridge' and @option='Deprecated' and @native='x86']";
                        }
                    }
                    else
                    {
                        xpath = "VixManifest/Prerequisites/Prerequisite[@name='Laurel Bridge' and @option='Deprecated']";
                    }

                    XmlNode xmlPrerequisite = this.manifest.SelectSingleNode(xpath);
                    deprecatedDcfPrerequisiteSingle = new DcfPrerequisite(xmlPrerequisite, PayloadPath);
                }
                return deprecatedDcfPrerequisiteSingle;
            }
        }

        public TomcatPrerequisite ActiveTomcatPrerequisite
        {
            get
            {
                if (activeTomcatPrerequisite == null)
                {
                    string xpath = null;
                    if (Enable64BitInstallation)
                    {
                        // native attributes are be defined on Java prerequisite elements - use them
                        if (BusinessFacade.Is64BitOperatingSystem())
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Apache Tomcat' and @option='Active' and @native='x64']";
                        }
                        else
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Apache Tomcat' and @option='Active' and @native='x86']";
                        }
                    }
                    else
                    {
                        xpath = "VixManifest/Prerequisites/Prerequisite[@name='Apache Tomcat' and @option='Active']";
                    }
                    XmlNode xmlPrerequisite = this.manifest.SelectSingleNode(xpath);
                    //
                    activeTomcatPrerequisite = new TomcatPrerequisite(xmlPrerequisite, PayloadPath);
                }
                return activeTomcatPrerequisite;
            }
        }
        public TomcatPrerequisite[] DeprecatedTomcatPrerequisites
        {
            get
            {
                if (deprecatedTomcatPrerequisites == null)
                {
                    string xpath = null;
                    string systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper();
                    //if (Enable64BitInstallation)
                    //{
                    //    // native attributes are be defined on Java prerequisite elements - use them
                    //    if (BusinessFacade.Is64BitOperatingSystem())
                    //    {
                    //        xpath = "VixManifest/Prerequisites/Prerequisite[@name='Apache Tomcat' and @option='Deprecated' and @native='x64']";
                    //    }
                    //    else
                    //    {
                    //        xpath = "VixManifest/Prerequisites/Prerequisite[@name='Apache Tomcat' and @option='Deprecated' and @native='x86']";
                    //    }
                    //}
                    //else
                    //{
                    //    xpath = "VixManifest/Prerequisites/Prerequisite[@name='Apache Tomcat' and @option='Deprecated']";
                    //}

                    // allow both x64 and x86 deprecated prerequisites
                    xpath = "VixManifest/Prerequisites/Prerequisite[@name='Apache Tomcat' and @option='Deprecated']";

                    List<TomcatPrerequisite> prerequisiteList = new List<TomcatPrerequisite>();
                    XmlNodeList xmlPrerequisiteList = this.manifest.SelectNodes(xpath);

                    foreach (XmlNode xmlPrerequisite in xmlPrerequisiteList)
                    {
                        prerequisiteList.Add(new TomcatPrerequisite(xmlPrerequisite, PayloadPath));
                    }

                    deprecatedTomcatPrerequisites = prerequisiteList.ToArray();
                }
                return deprecatedTomcatPrerequisites;
            }
        }
        public JavaPrerequisite ActiveJavaPrerequisite
        {
            get
            {
                if (activejavaPrerequisite == null)
                {
                    string xpath = null;
                    if (Enable64BitInstallation)
                    {
                        // native attributes are be defined on Java prerequisite elements - use them
                        if (BusinessFacade.Is64BitOperatingSystem())
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Java' and @option='Active' and @native='x64']";
                        }
                        else
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Java' and @option='Active' and @native='x86']";
                        }
                    }
                    else
                    {
                        xpath = "VixManifest/Prerequisites/Prerequisite[@name='Java' and @option='Active']";
                    }
                    XmlNode xmlPrerequisite = this.manifest.SelectSingleNode(xpath);
                    activejavaPrerequisite = new JavaPrerequisite(xmlPrerequisite, PayloadPath);
                }
                return activejavaPrerequisite;
            }
        }
        public JavaPrerequisite[] DeprecatedJavaPrerequisites
        {
            get
            {
                if (deprecatedJavaPrerequisites == null)
                {
                    string xpath = null;
                    string systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper();
                    if (Enable64BitInstallation)
                    {
                        // native attributes are be defined on Java prerequisite elements - use them
                        if (BusinessFacade.Is64BitOperatingSystem())
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Java' and @option='Deprecated']"; // either x86 or x64 could be installed - will be x86 in P119 scenerio
                        }
                        else
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Java' and @option='Deprecated' and @native='x86']";
                        }
                    }
                    else
                    {
                        xpath = "VixManifest/Prerequisites/Prerequisite[@name='Java' and @option='Deprecated']";
                    }

                    List<JavaPrerequisite> prerequisiteList = new List<JavaPrerequisite>();
                    XmlNodeList xmlPrerequisiteList = this.manifest.SelectNodes(xpath);

                    foreach (XmlNode xmlPrerequisite in xmlPrerequisiteList)
                    {
                        prerequisiteList.Add(new JavaPrerequisite(xmlPrerequisite, PayloadPath));
                    }
                    deprecatedJavaPrerequisites = prerequisiteList.ToArray();
                }
                return deprecatedJavaPrerequisites;
            }
        }

        public ZFViewerPrerequisite ActiveZFViewerPrerequisite
        {
            get
            {
                if (activeZFViewerPrerequisite == null)
                {
                    string xpath = null;
                    if (Enable64BitInstallation)
                    {
                        // native attributes are defined on prerequisite elements - use them
                        if (BusinessFacade.Is64BitOperatingSystem())
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Viewer Services' and @option='Active' and @native='x64']";
                        }
                        else
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Viewer Services' and @option='Active' and @native='x86']";
                        }
                    }
                    else
                    {
                        xpath = "VixManifest/Prerequisites/Prerequisite[@name='Viewer Services' and @option='Active']";
                    }
                    XmlNode xmlPrerequisite = this.manifest.SelectSingleNode(xpath);
                    activeZFViewerPrerequisite = new ZFViewerPrerequisite(xmlPrerequisite, PayloadPath);
                }
                return activeZFViewerPrerequisite;
            }
        }
        public ZFViewerPrerequisite[] DeprecatedZFViewerPrerequisites
        {
            get
            {
                if (deprecatedZFViewerPrerequisites == null)
                {
                    string xpath = null;
                    string systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper();
                    if (Enable64BitInstallation)
                    {
                        // native attributes are be defined on Java prerequisite elements - use them
                        if (BusinessFacade.Is64BitOperatingSystem())
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Viewer Services' and @option='Deprecated' and @native='x64']";
                        }
                        else
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Viewer Services' and @option='Deprecated' and @native='x86']";
                        }
                    }
                    else
                    {
                        xpath = "VixManifest/Prerequisites/Prerequisite[@name='Viewer Services' and @option='Deprecated']";
                    }

                    List<ZFViewerPrerequisite> prerequisiteList = new List<ZFViewerPrerequisite>();
                    XmlNodeList xmlPrerequisiteList = this.manifest.SelectNodes(xpath);

                    foreach (XmlNode xmlPrerequisite in xmlPrerequisiteList)
                    {
                        prerequisiteList.Add(new ZFViewerPrerequisite(xmlPrerequisite, PayloadPath));
                    }

                    deprecatedZFViewerPrerequisites = prerequisiteList.ToArray();
                }
                return deprecatedZFViewerPrerequisites;
            }
        }


        public ListenerPrerequisite ActiveListenerPrerequisite
        {
            get
            {
                if (activeListenerPrerequisite == null)
                {
                    string xpath = null;
                    if (Enable64BitInstallation)
                    {
                        // native attributes are defined on prerequisite elements - use them
                        if (BusinessFacade.Is64BitOperatingSystem())
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Listener' and @option='Active' and @native='x64']";
                        }
                        else
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Listener' and @option='Active' and @native='x86']";
                        }
                    }
                    else
                    {
                        xpath = "VixManifest/Prerequisites/Prerequisite[@name='Listener' and @option='Active']";
                    }
                    XmlNode xmlPrerequisite = this.manifest.SelectSingleNode(xpath);
                    activeListenerPrerequisite = new ListenerPrerequisite(xmlPrerequisite, PayloadPath);
                }
                if (activeListenerPrerequisite == null)
                {
                    VixManifest.Logger().Info("Failed to create new ListenerPrerequisite...");
                }
                return activeListenerPrerequisite;
            }
        }


        public ListenerPrerequisite[] DeprecatedListenerPrerequisites
        {
            get
            {
                if (deprecatedListenerPrerequisites == null)
                {
                    string xpath = null;
                    string systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper();
                    if (Enable64BitInstallation)
                    {
                        // native attributes are be defined on Java prerequisite elements - use them
                        if (BusinessFacade.Is64BitOperatingSystem())
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Listener' and @option='Deprecated' and @native='x64']";
                        }
                        else
                        {
                            xpath = "VixManifest/Prerequisites/Prerequisite[@name='Listener' and @option='Deprecated' and @native='x86']";
                        }
                    }
                    else
                    {
                        xpath = "VixManifest/Prerequisites/Prerequisite[@name='Listener' and @option='Deprecated']";
                    }

                    List<ListenerPrerequisite> prerequisiteList = new List<ListenerPrerequisite>();
                    XmlNodeList xmlPrerequisiteList = this.manifest.SelectNodes(xpath);

                    foreach (XmlNode xmlPrerequisite in xmlPrerequisiteList)
                    {
                        prerequisiteList.Add(new ListenerPrerequisite(xmlPrerequisite, PayloadPath));
                    }

                    deprecatedListenerPrerequisites = prerequisiteList.ToArray();
                }
                return deprecatedListenerPrerequisites;
            }
        }

        public string PayloadPath
        {
            get { return payloadPath; }
        }
        public string WelcomeMessage
        {
            get
            {
                XmlNode xmlWelcomePageText = this.manifest.SelectSingleNode("VixManifest/Patch/WelcomePageText");
                Debug.Assert(xmlWelcomePageText != null);
                string welcomeMessage = xmlWelcomePageText.InnerText.Trim();
                return welcomeMessage;
            }
        }

        public int MajorPatchNumber
        {
            get
            {
                XmlNode xmlVistaPatch = this.manifest.SelectSingleNode("VixManifest/Patch");
                Debug.Assert(xmlVistaPatch != null);
                string fullyQualifiedPatchNumber = xmlVistaPatch.Attributes["number"].Value.Trim();
                string[] splits = fullyQualifiedPatchNumber.Split('.'); //VistaReleaseNumber.PatchNumber.BuildNumber.IterationNumber
                Debug.Assert(splits.Length == 4);
                return Int32.Parse(splits[1]);
            }
        }

        public int Log4jVersion
        {
            get
            {
                XmlNode xmlVistaPatch = this.manifest.SelectSingleNode("VixManifest/Patch");
                string log4jVersion = "1";

                if (xmlVistaPatch.Attributes["log4jVersion"] != null)
                {
                    log4jVersion = xmlVistaPatch.Attributes["log4jVersion"].Value.Trim();
                }
                return Int32.Parse(log4jVersion);
            }
        }
        
        
        public string FullyQualifiedPatchNumber
        {
            get
            {
                XmlNode xmlVistaPatch = this.manifest.SelectSingleNode("VixManifest/Patch");
                Debug.Assert(xmlVistaPatch != null);
                string fullyQualifiedPatchNumber = xmlVistaPatch.Attributes["number"].Value.Trim();
                return fullyQualifiedPatchNumber;
            }
        }
        public bool ClearCache
        {
            get
            {
                bool clearCache = false;
                XmlNode xmlVistaPatch = this.manifest.SelectSingleNode("VixManifest/Patch");
                if (xmlVistaPatch != null)
                {
                    if (xmlVistaPatch.Attributes["clearCache"] != null)
                    {
                        string clearCacheString = xmlVistaPatch.Attributes["clearCache"].Value.Trim();
                        if (clearCacheString != null)
                        {
                            bool tryit;
                            if (bool.TryParse(clearCacheString, out tryit))
                            {
                                clearCache = tryit;
                            }
                        }
                    }
                }
                return clearCache;
            }
        }
        public bool Enable64BitInstallation
        {
            get
            {
                bool enable64BitInstall = false;
                XmlNode xmlVistaPatch = this.manifest.SelectSingleNode("VixManifest/Patch");
                if (xmlVistaPatch != null)
                {
                    if (xmlVistaPatch.Attributes["enable64BitInstall"] != null)
                    {
                        string enable64BitString = xmlVistaPatch.Attributes["enable64BitInstall"].Value;
                        bool enable;
                        if (Boolean.TryParse(enable64BitString, out enable))
                        {
                            enable64BitInstall = enable;
                        }
                    }
                }
                return enable64BitInstall;
            }
        }
        public NativeType CurrentNativeInstallation
        {
            get
            {
                NativeType nativeType = NativeType.x86;
                // Enable64BitInstallation is here to support build manifests that still use tomcat 6.0.20 - this may not be needed depending on patch sequencing
                if (Enable64BitInstallation && BusinessFacade.Is64BitOperatingSystem())
                {
                    nativeType = NativeType.x64;
                }
                return nativeType;
            }
        }
        public VixCacheConfiguration[] VixCacheConfigurations
        {
            get
            {
                if (vixCacheConfigurations == null)
                {
                    List<VixCacheConfiguration> vixCacheConfigurationList = new List<VixCacheConfiguration>();
                    XmlNodeList xmlVixCacheConfigurations = this.manifest.SelectNodes("VixManifest/Patch/CacheConfigurations/CacheConfiguration");
                    Debug.Assert(xmlVixCacheConfigurations != null);
                    foreach (XmlNode xmlVixCacheConfiguration in xmlVixCacheConfigurations)
                    {
                        vixCacheConfigurationList.Add(new VixCacheConfiguration(xmlVixCacheConfiguration));
                    }

                    vixCacheConfigurations = vixCacheConfigurationList.ToArray();
                }
                return vixCacheConfigurations;
            }
        }
        public VixDeploymentConfiguration[] VixDeploymentConfigurations
        {
            get
            {
                if (vixDeploymentConfigurations == null)
                {
                    List<VixDeploymentConfiguration> vixDeploymentConfigurationList = new List<VixDeploymentConfiguration>();
                    XmlNodeList xmlVixDeploymentConfigurations = this.manifest.SelectNodes("VixManifest/Patch/DeploymentConfigurations/DeploymentConfiguration");
                    Debug.Assert(xmlVixDeploymentConfigurations != null);
                    foreach (XmlNode xmlVixDeploymentConfiguration in xmlVixDeploymentConfigurations)
                    {
                        vixDeploymentConfigurationList.Add(new VixDeploymentConfiguration(xmlVixDeploymentConfiguration));
                    }
                    vixDeploymentConfigurations = vixDeploymentConfigurationList.ToArray(); ;
                }
                return vixDeploymentConfigurations;
            }
        }
        public VixJavaConfigurationUtility[] JavaConfigurationUtilityProperties
        {
            get
            {
                if (javaConfigurationUtilityProperties == null)
                {
                    List<VixJavaConfigurationUtility> javaConfigurationUtilityPropertyList = new List<VixJavaConfigurationUtility>();
                    XmlNodeList xmlVixConfigUtilityProperties = this.manifest.SelectNodes("VixManifest/ViX/ConfigurationFileUtilities/ConfigurationFileUtility");
                    Debug.Assert(xmlVixConfigUtilityProperties != null);
                    foreach (XmlNode xmlConfigUtilityProperty in xmlVixConfigUtilityProperties)
                    {
                        javaConfigurationUtilityPropertyList.Add(new VixJavaConfigurationUtility(xmlConfigUtilityProperty));
                    }
                    javaConfigurationUtilityProperties = javaConfigurationUtilityPropertyList.ToArray();
                }
                return javaConfigurationUtilityProperties;
            }
        }
        private VixWebApplication[] vixWebApplication = null;
        public VixWebApplication[] VixWebApplications
        {
            get
            {
                if (vixWebApplication == null)
                {
                    List<VixWebApplication> vixWebApplications = new List<VixWebApplication>();
                    XmlNodeList xmlWebApplications = this.manifest.SelectNodes("VixManifest/ViX/WebApplications/WebApplication");
                    Debug.Assert(xmlWebApplications != null);
                    foreach (XmlNode xmlVixWebApplication in xmlWebApplications)
                    {
                        vixWebApplications.Add(new VixWebApplication(xmlVixWebApplication));
                    }
                    vixWebApplication = vixWebApplications.ToArray();
                }
                return vixWebApplication;
            }
        }
        #endregion

        #region Public methods
        /// <summary>
        /// 
        /// </summary>
        /// <param name="previousVersion"></param>
        /// <returns></returns>
        public bool ClearCacheIfPreviousVersion(String previousVersion)
        {
            bool clearCache = false;
            if (previousVersion != null)
            {
                XmlNode xmlVistaPatch = this.manifest.SelectSingleNode("VixManifest/Patch");
                if (xmlVistaPatch != null)
                {
                    if (xmlVistaPatch.Attributes["clearCacheIfPreviousVersion"] != null)
                    {
                        string previousVersionToClear = xmlVistaPatch.Attributes["clearCacheIfPreviousVersion"].Value.Trim();
                        string[] previousVersionToClearSplits = previousVersionToClear.Split('.');
                        string[] previousVersionSplits = previousVersion.Split('.');
                        Debug.Assert(previousVersionToClearSplits.Length == 4);
                        Debug.Assert(previousVersionSplits.Length == 4);
                        int matchCount = 0;
                        for (int i = 0; i < 4; i++)
                        {
                            // match wildcard or previous version number part
                            if (previousVersionToClearSplits[i] == "*" || previousVersionToClearSplits[i] == previousVersionSplits[i])
                            {
                                matchCount++;
                            }
                        }
                        if (matchCount == 4)
                        {
                            clearCache = true;
                        }
                    }
                }
            }
            return clearCache;
        }


        public bool IsCurrentMajorVersionSameAsPrevious(String previousVersion)
        {
            bool sameMajorVersion = false;
            if (previousVersion != null)
            {
                XmlNode xmlVistaPatch = this.manifest.SelectSingleNode("VixManifest/Patch");
                if (xmlVistaPatch != null)
                {
                    string currentVersion = xmlVistaPatch.Attributes["number"].Value.Trim();
                    string[] currentVersionSplits = currentVersion.Split('.');
                    string[] previousVersionSplits = previousVersion.Split('.');
                    Debug.Assert(currentVersionSplits.Length == 4);
                    Debug.Assert(previousVersionSplits.Length == 4);
                    int matchCount = 0;
                    for (int i = 0; i < 2; i++)
                    {
                        // match wildcard or previous version number part
                        if (currentVersionSplits[i] == previousVersionSplits[i])
                        {
                            matchCount++;
                        }
                    }
                    if (matchCount == 2)
                    {
                        sameMajorVersion = true;
                    }
                }
            }
            return sameMajorVersion;
        }

        public VixJavaProperty[] GetManifestVixJavaProperties(string configFolder)
        {
            List<VixJavaProperty> vixJavaProperties = new List<VixJavaProperty>();
            XmlNodeList xmlVixProperties = this.manifest.SelectNodes("VixManifest/ViX/JvmEnvironmentVariables/JvmEnvironmentVariable");
            Debug.Assert(xmlVixProperties != null);
            foreach (XmlNode xmlVixJavaProperty in xmlVixProperties)
            {
                VixJavaProperty vixJavaProperty = new VixJavaProperty(xmlVixJavaProperty, configFolder);
                vixJavaProperties.Add(vixJavaProperty);
            }

            return vixJavaProperties.ToArray();
        }

        public VixDependencyFile[] GetDependencyFiles(IVixConfigurationParameters config)
        {
            return GetXpathDependencyFiles(config, "VixManifest/ViX/DependencyFiles/File");
        }

        public VixDependencyFile[] GetWebAppDependencyFiles(IVixConfigurationParameters config)
        {
            return GetXpathDependencyFiles(config, "VixManifest/ViX/WebAppDependencyFiles/File");
        }

        public VixDependencyFile[] GetImageGearDependencyFiles(IVixConfigurationParameters config)
        {
            return GetXpathDependencyFiles(config, "VixManifest/ViX/ImageGearDependencyFiles/File");
        }

        public VixDeprecatedFile[] GetDeprecatedFiles(IVixConfigurationParameters config)
        {
            List<VixDeprecatedFile> vixDeprecatedFiles = new List<VixDeprecatedFile>();
            XmlNodeList xmlVixDeprecatedFiles = this.manifest.SelectNodes("VixManifest/ViX/DeprecatedFiles/File");
            if (xmlVixDeprecatedFiles != null)
            {
                foreach (XmlNode xmlVixDeprecatedFile in xmlVixDeprecatedFiles)
                {
                    VixDeprecatedFile vixDeprecatedFile = new VixDeprecatedFile(xmlVixDeprecatedFile, config.ConfigDir);
                    vixDeprecatedFiles.Add(vixDeprecatedFile);
                }
            }

            return vixDeprecatedFiles.ToArray();
        }

        public VixDeprecatedDirectory[] GetDeprecatedDirectories(IVixConfigurationParameters config)
        {
            List<VixDeprecatedDirectory> vixDeprecatedDirectories = new List<VixDeprecatedDirectory>();
            XmlNodeList xmlVixDeprecatedDirectories = this.manifest.SelectNodes("VixManifest/ViX/DeprecatedDirectories/Directory");
            if (xmlVixDeprecatedDirectories != null)
            {
                foreach (XmlNode xmlVixDeprecatedDirectory in xmlVixDeprecatedDirectories)
                {
                    VixDeprecatedDirectory vixDeprecatedDirectory = new VixDeprecatedDirectory(xmlVixDeprecatedDirectory, config.ConfigDir);
                    vixDeprecatedDirectories.Add(vixDeprecatedDirectory);
                }
            }

            return vixDeprecatedDirectories.ToArray();
        }

        public static string GetFolderFromAppFolderType(AppFolderType appFolderType, string configFolder)
        {
            string appRootFolder = "";
            switch (appFolderType)
            {
                case AppFolderType.TomcatRoot:
                    appRootFolder = TomcatFacade.TomcatInstallationFolder;
                    break;
                case AppFolderType.JavaRoot:
                    appRootFolder = JavaFacade.GetActiveJavaPath(JavaFacade.IsActiveJreInstalled());
                    break;
                case AppFolderType.VixConfigRoot:
                    appRootFolder = configFolder;
                    break;
                case AppFolderType.CertificateRoot:
                    appRootFolder = VixFacade.GetVixCertificateStoreDir();
                    break;
                case AppFolderType.DcfRoot:
                    appRootFolder = LaurelBridgeFacade.GetActiveDcfRootFromManifest();
                    break;
                case AppFolderType.AbsoluteFilespec:
                case AppFolderType.NoRoot:
                    break;
            }
            return appRootFolder;
        }

        public bool ContainsVixRole(VixRoleType value)
        {
            foreach (VixDeploymentConfiguration vixDeployConfig in this.vixDeploymentConfigurations)
            {
                if (value == vixDeployConfig.VixRole)
                {
                    return true;
                }
            }
            return false;
        }


    #endregion

    #region Private methods

        private VixDependencyFile[] GetXpathDependencyFiles(IVixConfigurationParameters config, string xpath)
        {
            List<VixDependencyFile> vixDependencyFiles = new List<VixDependencyFile>();
            XmlNodeList xmlVixDependencyFiles = this.manifest.SelectNodes(xpath);
            if (xmlVixDependencyFiles != null)
            {
                foreach (XmlNode xmlVixDependencyFile in xmlVixDependencyFiles)
                {
                    VixDependencyFile vixDependencyFile = new VixDependencyFile(xmlVixDependencyFile, config.ConfigDir, this.payloadPath);
                    vixDependencyFiles.Add(vixDependencyFile);
                }
            }

            return vixDependencyFiles.ToArray();
        }


    #endregion

    }

    #region Value Objects
    /// <summary>
    /// 
    /// </summary>
    public class VixCacheConfiguration
    {
        public VixCacheType CacheOption { get; private set; }
        public string Description { get; private set; }
        public string ShortDescription  { get; private set; }

        public VixCacheConfiguration(XmlNode xmlVixCacheConfiguration)
        {
            string vixCacheConfigurationNameAsString = xmlVixCacheConfiguration.Attributes["name"].Value;
            CacheOption = (VixCacheType)Enum.Parse(typeof(VixCacheType), vixCacheConfigurationNameAsString);
            ShortDescription = xmlVixCacheConfiguration.Attributes["shortDescription"].Value;
            Description = xmlVixCacheConfiguration.InnerText.Trim();
        }
    }
    
    /// <summary>
    /// Value object for manifest DeploymentConfiguration elements
    /// </summary>
    public class VixDeploymentConfiguration
    {
        public VixRoleType VixRole  { get; private set; }
        public string Description { get; private set; }
        public string ShortDescription { get; private set; }

        public VixDeploymentConfiguration(XmlNode xmlVixDeploymentConfiguration)
        {
            string vixDeploymentConfigurationNameAsString = xmlVixDeploymentConfiguration.Attributes["name"].Value;
            VixManifest.Logger().Info("vixDeploymentConfigurationNameAsString = " + vixDeploymentConfigurationNameAsString);

            VixRole = (VixRoleType)Enum.Parse(typeof(VixRoleType), vixDeploymentConfigurationNameAsString);
            VixManifest.Logger().Info("vixDeploymentConfiguration VixRole = " + VixRole);
            
            ShortDescription = xmlVixDeploymentConfiguration.Attributes["shortDescription"].Value;
            Description = xmlVixDeploymentConfiguration.InnerText.Trim();
        }

    }
    
    /// <summary>
    /// Value object for Java JVM properties
    /// </summary>
    public class VixJavaProperty
    {
        public string Name { get; private set; }
        public string Value{ get; set; }
        public VixJavaPropertyOption Option { get; private set; }
        public VixJavaPropertyType Type { get; private set; }
        public string Prefix { get; private set; }

        public VixJavaProperty(VixJavaPropertyOption option, string prefix, string name, string value, string configFolder)
        {
            Option = option;
            Name = name;
            Value = value;
            Prefix = prefix;
            if (configFolder != null)
            {
                Value = Path.Combine(configFolder, Value).Replace(@"\", "/");
            }
        }

        public VixJavaProperty(XmlNode xmlVixJavaProperty, string configFolder)
        {
            //VixJavaPropertyOption option, String name, String value, string configFolder
            string configUtilityOptionAsString = xmlVixJavaProperty.Attributes["option"].Value;
            Option = (VixJavaPropertyOption)Enum.Parse(typeof(VixJavaPropertyOption), configUtilityOptionAsString);

            string configUtilityTypeAsString = (xmlVixJavaProperty.Attributes["type"].Value);
            Type = (VixJavaPropertyType)Enum.Parse(typeof(VixJavaPropertyType), configUtilityTypeAsString);
            
            Name = xmlVixJavaProperty.Attributes["name"].Value.Trim();
            Value = xmlVixJavaProperty.InnerText.Trim();
            if (Type == VixJavaPropertyType.property)
            {
                Prefix = "-D";
            }
            else if (Type == VixJavaPropertyType.memory)
            {
                Prefix = "-XX:";
            }
            else
            {
                Prefix = "-D";
            }

            XmlAttribute xmlAttribute = xmlVixJavaProperty.Attributes["appRootFolderType"];
            string folder = null;
            if (xmlAttribute != null)
            {
                string vixDependencyFileAsString = xmlAttribute.Value;
                AppFolderType appFolderType = (AppFolderType)Enum.Parse(typeof(AppFolderType), vixDependencyFileAsString);
                Debug.Assert(appFolderType == AppFolderType.VixConfigRoot);
                // this is a kludge until I can think of something better
                if (Name.StartsWith("log4j.configuration"))
                {
                    folder = "file:/" + configFolder;
                }
                else
                {
                    folder = configFolder;
                }
            }
            if (folder != null)
            {
                Value = Path.Combine(folder, Value).Replace(@"\", "/");
            }
        }

        /// <summary>
        /// Format as a JVM property paramater.
        /// </summary>
        /// <returns>the property as a JVM -D or -X parameter</returns>
        public override String ToString()
        {
            StringBuilder sb = new StringBuilder();
            if (this.Value == null)
            {
                sb.AppendFormat("{0}{1}", this.Prefix, this.Name);
            }
            else
            {
                sb.AppendFormat("{0}{1}={2}", this.Prefix, this.Name, this.Value);
            }
            return sb.ToString();
        }

    }

    /// <summary>
    /// Value object for Configuration Utility properties
    /// </summary>
    public class VixJavaConfigurationUtility
    {
        public string Jar { get; private set; }
        public string Package { get; private set; }
        public ViXConfigurationUtilityType ConfigUtilityType { get; private set; }

        public VixJavaConfigurationUtility(XmlNode xmlConfigUtilityProperty)
        {
            string configUtilityTypeAsString = xmlConfigUtilityProperty.Attributes["configUtilityType"].Value;
            ConfigUtilityType = (ViXConfigurationUtilityType)Enum.Parse(typeof(ViXConfigurationUtilityType), configUtilityTypeAsString);
            Jar = xmlConfigUtilityProperty.Attributes["jar"].Value.Trim();
            Package = xmlConfigUtilityProperty.Attributes["package"].Value.Trim();
        }
    }

    /// <summary>
    /// Value object for dependency files
    /// </summary>
    public class VixDependencyFile
    {
        private string configFolder;
        private string filename;
        private string payloadRelativeFolder;
        private string appRelativeFolder;
        private string payloadRootFolder;
        private AppFolderType appFolderType;
        private VixDependencyType vixDependencyType;
        private VixConfigFileOption option = VixConfigFileOption.Installed;
        private bool register = false;
        private NativeType nativeType = NativeType.all;

        public VixDependencyType DependencyType
        {
            get { return this.vixDependencyType; }
        }

        public NativeType Native
        {
            get { return this.nativeType; }
        }

        public bool Register
        {
            get {return this.register; }
        }

        public VixConfigFileOption Option
        {
            get { return this.option; }
        }

        public VixDependencyFile(XmlNode xmlVixDependencyFile, string configFolder, string payloadFolder)
        {

            //public VixDependencyFile(AppFolderType appFolderType, String payloadRelativeFolder, String appRelativeFolder, string filename,
            //string configFolder, string payloadRootFolder, VixDependencyType vixDependencyType)


            string vixDependencyFileAsString = xmlVixDependencyFile.Attributes["appRootFolderType"].Value;
            this.appFolderType = (AppFolderType)Enum.Parse(typeof(AppFolderType), vixDependencyFileAsString);

            string vixDependencyTypeAsString = xmlVixDependencyFile.Attributes["dependencyType"].Value;
            this.vixDependencyType = (VixDependencyType)Enum.Parse(typeof(VixDependencyType), vixDependencyTypeAsString);

            bool register = false;
            if (xmlVixDependencyFile.Attributes["register"] != null)
            {
                string registerAsString = xmlVixDependencyFile.Attributes["register"].Value;
                bool tryit;
                if (bool.TryParse(registerAsString, out tryit))
                {
                    register = tryit;
                }
            }

            if (xmlVixDependencyFile.Attributes["native"] != null)
            {
                string nativeAsString = xmlVixDependencyFile.Attributes["native"].Value;
                this.nativeType = (NativeType)Enum.Parse(typeof(NativeType), nativeAsString);
            }

            if (xmlVixDependencyFile.Attributes["option"] != null)
            {
                string optionTypeAsString = xmlVixDependencyFile.Attributes["option"].Value;
                this.option = (VixConfigFileOption)Enum.Parse(typeof(VixConfigFileOption), optionTypeAsString);
            }

            this.payloadRelativeFolder = xmlVixDependencyFile.Attributes["payloadRelativeFolder"].Value.Trim().Replace("/", @"\");
            this.appRelativeFolder = xmlVixDependencyFile.Attributes["appRelativeFolder"].Value.Trim().Replace("/", @"\");
            this.filename = xmlVixDependencyFile.InnerText.Trim();
            this.configFolder = configFolder;
            this.payloadRootFolder = payloadFolder;
            this.register = register;
        }

        public string GetPayloadFilespec()
        {
            string payloadFolder = Path.Combine(this.payloadRootFolder, this.payloadRelativeFolder);
            return Path.Combine(payloadFolder, this.filename);
        }

        public string GetAppFilespec()
        {
            string appRootFolder = VixManifest.GetFolderFromAppFolderType(this.appFolderType, this.configFolder);
            string appFolder = Path.Combine(appRootFolder, this.appRelativeFolder);
            if (Directory.Exists(appFolder) == false)
            {
                Directory.CreateDirectory(appFolder);
            }
            return Path.Combine(appFolder, this.filename);
        }

        public string GetAppFolder()
        {
            string appRootFolder = VixManifest.GetFolderFromAppFolderType(this.appFolderType, this.configFolder);
            string appFolder = Path.Combine(appRootFolder, this.appRelativeFolder);
            if (Directory.Exists(appFolder) == false)
            {
                Directory.CreateDirectory(appFolder);
            }
            return appFolder;
        }

    }

    /// <summary>
    /// Value object for Web Application
    /// </summary>
    public class VixWebApplication
    {
        public bool UseContextFolder { get; private set; }
        public string War { get; private set; }
        public string Path { get; private set; }
        public VixWebApplicationOption Option { get; private set; }

        public string DocBase
        {
            get { return Path.StartsWith("/") ? Path.Substring(1) : Path; }
        }

        public VixWebApplication(XmlNode xmlVixWebApplication)
        {
            string webApplicationOptionTypeAsString = xmlVixWebApplication.Attributes["option"].Value;
            Option = (VixWebApplicationOption)Enum.Parse(typeof(VixWebApplicationOption), webApplicationOptionTypeAsString);

            string useContextFolderAsString = xmlVixWebApplication.Attributes["useContextFile"].Value.Trim();
            bool use;
            if (Boolean.TryParse(useContextFolderAsString, out use) == false)
            {
                Debug.Assert(false);
            }
            UseContextFolder = use;

            Path = xmlVixWebApplication.Attributes["path"].Value.Trim();
            War = xmlVixWebApplication.InnerText.Trim();
        }

        public bool IsAxis2WebApplication()
        {
            bool isAxis2 = false;
            string ext = System.IO.Path.GetExtension(War).ToLower();
            if (ext == ".jar" || ext == ".aar")
            {
                isAxis2 = true;
            }

            return isAxis2;
        }
    }

    /// <summary>
    /// Value object for deprecated dependency files
    /// </summary>
    public class VixDeprecatedFile
    {
        private string filename;
        private string appRelativeFolder;
        private AppFolderType appFolderType;
        private string configFolder;

        public VixDeprecatedFile(XmlNode xmlVixDeprecatedFile, string configFolder)
        {
          
            string appFolderTypeAsString = xmlVixDeprecatedFile.Attributes["appRootFolderType"].Value;
            this.appFolderType = (AppFolderType)Enum.Parse(typeof(AppFolderType), appFolderTypeAsString);
            this.appRelativeFolder = xmlVixDeprecatedFile.Attributes["appRelativeFolder"].Value.Trim().Replace("/", @"\");
            this.filename = xmlVixDeprecatedFile.InnerText.Trim();
            this.configFolder = configFolder;
        }

        public string GetAppFilespec()
        {
            string appRootFolder = VixManifest.GetFolderFromAppFolderType(this.appFolderType, this.configFolder);
            string appFolder = this.appRelativeFolder.Length == 0 ? appRootFolder : Path.Combine(appRootFolder, this.appRelativeFolder);
            //Debug.Assert(Directory.Exists(appFolder), "Directory does not exist " + appFolder);
            return Path.Combine(appFolder, this.filename);
        }

    }

    /// <summary>
    /// Value object for deprecated dependency directories
    /// </summary>
    public class VixDeprecatedDirectory
    {
        private string directoryName;
        private AppFolderType appFolderType;
        private string configFolder;

        public VixDeprecatedDirectory(XmlNode xmlVixDeprecatedDirectory, string configFolder)
        {
            string appFolderTypeAsString = xmlVixDeprecatedDirectory.Attributes["appRootFolderType"].Value;
            this.appFolderType = (AppFolderType)Enum.Parse(typeof(AppFolderType), appFolderTypeAsString);
            this.directoryName = xmlVixDeprecatedDirectory.InnerText.Trim();
            this.configFolder = configFolder;
        }

        public string GetDirectoryPath()
        {
            string appRootFolder = VixManifest.GetFolderFromAppFolderType(this.appFolderType, this.configFolder);
            return Path.Combine(appRootFolder, this.directoryName);
        }

    }

    /// <summary>
    /// Value object for Java Prerequisite
    /// </summary>
    public class JavaPrerequisite
    {
        public NativeType Native { get; private set; }
        public string Version { get; private set; }
        public string JrePath { get; private set; }
        public string JdkPath { get; private set; }
        public string JreInstallerFilespec { get; private set; }
        public string UninstallArgs { get; private set; }

        public JavaPrerequisite(XmlNode xmlPrerequisite, string payloadPath)
        {
            string systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper();
            Debug.Assert(xmlPrerequisite != null);
            Version = xmlPrerequisite.Attributes["version"].Value.Trim();
            Native = NativeType.x86;
            if (xmlPrerequisite.Attributes["native"] != null)
            {
                string nativeAsString = xmlPrerequisite.Attributes["native"].Value.Trim();
                Native = (NativeType)Enum.Parse(typeof(NativeType), nativeAsString);
            }

            XmlNode xmlJre = xmlPrerequisite.SelectSingleNode("./JRE");
            Debug.Assert(xmlJre != null);
            JrePath = systemDrive + xmlJre.Attributes["appRootRelativeFolder"].Value.Trim();
            if (Native == NativeType.x86 && BusinessFacade.Is64BitOperatingSystem())
            {
                JrePath = JrePath.Replace("Program Files", "Program Files (x86)");
            }

            XmlNode xmlJdk = xmlPrerequisite.SelectSingleNode("./JDK");
            Debug.Assert(xmlJdk != null);
            JdkPath = systemDrive + xmlJdk.Attributes["appRootRelativeFolder"].Value.Trim();
            if (Native == NativeType.x86 && BusinessFacade.Is64BitOperatingSystem())
            {
                JdkPath = JdkPath.Replace("Program Files", "Program Files (x86)");
            }

            XmlNode xmlInstallCommand = xmlJre.SelectSingleNode("./InstallCommand");
            Debug.Assert(xmlInstallCommand != null);
            string installerFilename = xmlInstallCommand.InnerText.Trim();
            if (installerFilename != "deprecated")
            {
                string payloadRelativeFolder = xmlInstallCommand.Attributes["payloadRelativeFolder"].Value.Trim();
                JreInstallerFilespec = Path.Combine(payloadPath, Path.Combine(payloadRelativeFolder, installerFilename)).Replace("/", @"\");
            }

            XmlNode xmlUninstallArgs = xmlJre.SelectSingleNode("./UninstallCommand");
            Debug.Assert(xmlUninstallArgs != null);
            UninstallArgs = xmlUninstallArgs.InnerText.Trim();
        }
    }

    /// <summary>
    /// Value object for Tomcat Prerequisite
    /// </summary>
    public class TomcatPrerequisite
    {
        public NativeType Native { get; private set; }
        public string Version { get; private set; }
        public string InstallerFilespec { get; private set; }
        public string ServiceName { get; private set; }
        public string UnInstallerFilename { get; private set; }
        public string UnInstallerArguments { get; private set; }
        public string DeleteStartMenuFolder { get; private set; }
        public string UnregisterFilename { get; private set; }
        public string UnregisterArguments { get; private set; }
        public string TomcatRegistryKey { get; private set; }
        public string DeleteUninstallerRegistryKey { get; private set; }

        public TomcatPrerequisite(XmlNode xmlPrerequisite, string payloadPath)
        {
            Debug.Assert(xmlPrerequisite != null);
            Version = xmlPrerequisite.Attributes["version"].Value.Trim();
            Native = NativeType.x86;
            if (xmlPrerequisite.Attributes["native"] != null)
            {
                string nativeAsString = xmlPrerequisite.Attributes["native"].Value.Trim();
                Native = (NativeType)Enum.Parse(typeof(NativeType), nativeAsString);
            }

            XmlNode xmlTomcat = xmlPrerequisite.SelectSingleNode("./Tomcat");
            ServiceName = xmlTomcat.Attributes["serviceName"].Value.Trim();

            XmlNode xmlInstallCommand = xmlTomcat.SelectSingleNode("./InstallCommand");
            Debug.Assert(xmlInstallCommand != null);
            string installerFilename = xmlInstallCommand.InnerText.Trim();
            if (installerFilename != "deprecated")
            {
                string payloadRelativeFolder = xmlInstallCommand.Attributes["payloadRelativeFolder"].Value.Trim();
                InstallerFilespec = Path.Combine(payloadPath, Path.Combine(payloadRelativeFolder, installerFilename)).Replace("/", @"\");
            }

            XmlNode xmlUninstallCommand = xmlTomcat.SelectSingleNode("./UninstallCommand");
            Debug.Assert(xmlUninstallCommand != null);
            UnInstallerArguments = xmlUninstallCommand.InnerText.Trim();
            UnInstallerFilename = xmlUninstallCommand.Attributes["uninstallerFilename"].Value.Trim();
            
            if (xmlUninstallCommand.Attributes["deleteStartMenuFolder"] != null)
            {
                String systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper();
                DeleteStartMenuFolder = systemDrive + xmlUninstallCommand.Attributes["deleteStartMenuFolder"].Value.Trim();
            }

            // Tomcat 6.0.35 and greater requires that the uninstaller registry entry be removed manually to clean up the add/remove programs list
            if (xmlUninstallCommand.Attributes["deleteUninstallerRegistryKey"] != null)
            {
                DeleteUninstallerRegistryKey = xmlUninstallCommand.Attributes["deleteUninstallerRegistryKey"].Value.Trim();
            }

            // Tomcat 6.0.35 and greater requires that the Tomcat registry entry be removed manually 
            if (xmlUninstallCommand.Attributes["tomcatRegistryKey"] != null)
            {
                TomcatRegistryKey = xmlUninstallCommand.Attributes["tomcatRegistryKey"].Value.Trim();
            }

            // Tomcat 6.0.35 and greater requires that the windows service be manually unregistered before uninstalling tomcat.
            XmlNode xmlUnregisterCommand = xmlTomcat.SelectSingleNode("./UnregisterServiceCommand");
            if (xmlUnregisterCommand != null)
            {
                UnregisterArguments = xmlUnregisterCommand.InnerText.Trim();
                UnregisterFilename = xmlUnregisterCommand.Attributes["unregisterFilename"].Value.Trim();
            }
        }
    }

    /// <summary>
    /// Value object for DCF Prerequisite
    /// </summary>
    public class DcfPrerequisite
    {
        public NativeType Native { get; private set; }
        public string Version { get; private set; }
        public DcfLicenseType LicenseType { get; private set; }
        public string PayloadFilespec { get; private set; }
        public string InstallPath { get; private set; }

        public DcfPrerequisite(XmlNode xmlPrerequisite, string payloadPath)
        {
            string systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper();
            Debug.Assert(xmlPrerequisite != null);
            Version = xmlPrerequisite.Attributes["version"].Value.Trim().ToLower();
            Native = NativeType.x86;
            if (xmlPrerequisite.Attributes["native"] != null)
            {
                string nativeAsString = xmlPrerequisite.Attributes["native"].Value.Trim();
                Native = (NativeType)Enum.Parse(typeof(NativeType), nativeAsString);
            }
            string dcfLicenseTypeAsString = xmlPrerequisite.Attributes["licenseType"].Value.Trim();
            LicenseType = (DcfLicenseType)Enum.Parse(typeof(DcfLicenseType), dcfLicenseTypeAsString);

            XmlNode xmlDcf = xmlPrerequisite.SelectSingleNode("./DCF");
            Debug.Assert(xmlDcf != null);    
            string installerFilename = xmlDcf.InnerText.Trim();
            if (installerFilename != "deprecated")
            {
                string payloadRelativeFolder = xmlDcf.Attributes["payloadRelativeFolder"].Value.Trim();
                string relativeFilespec = Path.Combine(payloadRelativeFolder, installerFilename);
                PayloadFilespec = Path.Combine(payloadPath, relativeFilespec).Replace("/", @"\");

                string dcfPath = xmlDcf.Attributes["appRootRelativeFolder"].Value.Trim();
                InstallPath = systemDrive + dcfPath.Replace("/", @"\");
            }
        }
    }


    /// <summary>
    /// Value object for Prerequisite
    /// </summary>
    public class ZFViewerPrerequisite
    {
        public NativeType Native { get; private set; }
        public string Version { get; private set; }
        public string PayloadFilespec { get; private set; }
        public string InstallPath { get; private set; }

        public ZFViewerPrerequisite(XmlNode xmlPrerequisite, string payloadPath)
        {
            string systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper();
            Debug.Assert(xmlPrerequisite != null);
            Version = xmlPrerequisite.Attributes["version"].Value.Trim().ToLower();
            Native = NativeType.x64;
            if (xmlPrerequisite.Attributes["native"] != null)
            {
                string nativeAsString = xmlPrerequisite.Attributes["native"].Value.Trim();
                Native = (NativeType)Enum.Parse(typeof(NativeType), nativeAsString);
            }
            XmlNode xmlZFvrs = xmlPrerequisite.SelectSingleNode("./ZFV");
            Debug.Assert(xmlZFvrs != null);
            string installerFilename = xmlZFvrs.InnerText.Trim();
            if (installerFilename != "deprecated")
            {
                string payloadRelativeFolder = xmlZFvrs.Attributes["payloadRelativeFolder"].Value.Trim();
                string relativeFilespec = Path.Combine(payloadRelativeFolder, installerFilename);
                PayloadFilespec = Path.Combine(payloadPath, relativeFilespec).Replace("/", @"\");

                string ZFvrsPath = xmlZFvrs.Attributes["appRootRelativeFolder"].Value.Trim();
                InstallPath = systemDrive + ZFvrsPath.Replace("/", @"\");
                VixManifest.Logger().Info("Payload Path for ZFViewer: " + PayloadFilespec);
                VixManifest.Logger().Info("Install Path for ZFViewer: " + InstallPath);
            }
        }
    }

    public class ListenerPrerequisite
    {
        public NativeType Native { get; private set; }
        public string Version { get; private set; }
        public string PayloadFilespec { get; private set; }
        public string InstallPath { get; private set; }

        public ListenerPrerequisite(XmlNode xmlPrerequisite, string payloadPath)
        {
            string systemDrive = Environment.GetEnvironmentVariable("SystemDrive", EnvironmentVariableTarget.Process).ToUpper();
            Debug.Assert(xmlPrerequisite != null);
            Version = xmlPrerequisite.Attributes["version"].Value.Trim().ToLower();
            Native = NativeType.x86;
            if (xmlPrerequisite.Attributes["native"] != null)
            {
                string nativeAsString = xmlPrerequisite.Attributes["native"].Value.Trim();
                Native = (NativeType)Enum.Parse(typeof(NativeType), nativeAsString);
            }

            XmlNode xmlLST = xmlPrerequisite.SelectSingleNode("./LST");
            Debug.Assert(xmlLST != null);
            string installerFilename = xmlLST.InnerText.Trim();
            if (installerFilename != "deprecated")
            {
                string payloadRelativeFolder = xmlLST.Attributes["payloadRelativeFolder"].Value.Trim();
                string relativeFilespec = Path.Combine(payloadRelativeFolder, installerFilename);
                PayloadFilespec = Path.Combine(payloadPath, relativeFilespec).Replace("/", @"\");

                string lstPath = xmlLST.Attributes["appRootRelativeFolder"].Value.Trim();
                InstallPath = systemDrive + lstPath.Replace("/", @"\");
                VixManifest.Logger().Info("Payload Path for Listener: " + PayloadFilespec);
                VixManifest.Logger().Info("Install Path for Listener: " + InstallPath);
            }
        }
    }

#endregion
}
