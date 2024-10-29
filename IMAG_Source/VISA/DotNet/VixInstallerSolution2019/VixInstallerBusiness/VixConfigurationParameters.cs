using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Xml;
using System.Xml.Serialization;
using System.Diagnostics;
using log4net;
using System.Security.Cryptography;
using System.Security.Cryptography.Xml;

namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    /// <summary>
    /// This class holds all the configuration information needed to install the VIX service.
    /// </summary>
    public class VixConfigurationParameters : gov.va.med.imaging.exchange.VixInstaller.business.IVixConfigurationParameters
    {
        private static readonly String VIX_INSTALLER_CONFIG_FILENAME = @"VixInstallerConfig.xml";

        private static ILog Logger()
        {
            return LogManager.GetLogger(typeof(VixConfigurationParameters).Name);
        }

        public VixConfigurationParameters() // for use by the FromXml method
        {
        }

        public VixConfigurationParameters(string productVersion, string keyStorePassword, string trustStorePassword) // for use with a new VIX installation
        {
            this.VixServerNameProp = Environment.MachineName; // must happen first
            this.ProductVersionProp = productVersion;
            this.federationKeystorePassword = keyStorePassword;
            this.federationTruststorePassword = trustStorePassword;
            this.VixDeploymentOption = DetermineDeploymentTypeForServer();
            this.vixCacheOption = GetVixCacheTypeByDeploymentOption(this.VixDeploymentOption);
            // This is bad in that we are dependent on the Facades to have had their manifest field initialized (which is always done before the manifest gets loaded).
            // It is less bad than having to initialize the VixRole in the WizardForm load event
            VixDeploymentConfiguration[] deployConfigs = VixFacade.Manifest.VixDeploymentConfigurations; 
            this.VixRole = deployConfigs[0].VixRole; // DKB 5/10/2011 - first deployment configuration role is the default
            Logger().Info("VixRole = " + this.VixRole);
            if (this.VixRole == VixRoleType.EnterpriseGateway)
            {
            }
            // initialize deprecated fields as deporecated
            this.ProductVersion = "deprecated";
            this.PreviousProductVersion = "deprecated";
        }

        private String siteServiceUri = null;
        private String siteNumber = null;
        private String vistaServerName = null;
        private String vistaServerPort = null;
        private String localCacheDir = null;
        private String networkFileShare = null;
        private String networkFileShareUsername = null;
        private String networkFileSharePassword = null;
        private String configDir = null;
        private String biaUsername = BusinessFacade.GetProductionBiaUsername(); // production default
        private String biaPassword = BusinessFacade.GetProductionBiaPassword(); // production default
        private String siteName = null;
        private String siteAbbreviation = null;
        private String vixTxDbDir = null;
        private bool configCheck = false;

        public  String ProductVersion = null; // deprecated by still enabled for migration to productVersion1 and productVersion2 fields
        public  String PreviousProductVersion = null; // deprecated by still enabled for migration to productVersion1 and productVersion2 fields

        private String federationKeystorePassword = null;
        private String federationTruststorePassword = null;
        
        private String vixServerName1 = null; // populated for Single Server and Fail Over Clusters
        private String vixServerName2 = null; // not populated except for Fail Over Clusters
        private VixDeploymentType vixDeploymentOptionServer1 = VixDeploymentType.Deprecated; // populated for Single Server and Fail Over Clusters
        private VixDeploymentType vixDeploymentOptionServer2 = VixDeploymentType.Deprecated; // not populated except for Fail Over Clusters
        private VixCacheType vixCacheOption = VixCacheType.NotSpecified;
        private int vixCacheSize = VixFacade.MINIMUM_VIX_CACHE_SIZE_GB; // cache size in GB
        private String productVersion1 = null;
        private String productVersion2 = null;
        private String previousProductVersion1 = null;
        private String previousProductVersion2 = null;
        private VixDeploymentType vixDeploymentOption = VixDeploymentType.NotSpecified;
        private String tomcatAdminPassword = null;
        private String apachetomcatpassword1 = null;
        private String apachetomcatpassword2 = null;
        private VixRoleType vixRole = VixRoleType.NotSpecified;
        //private VixDeploymentConfiguration[] deployConfigs = null;
        private bool isPatch = false; // if true the VixpatchingUtility console app will be used

        // HDIG support
        private string vdigAccessor = null;
        private string vdigVerifier = null;
        private string dicomImageGatewayServer = null;
        private string dicomImageGatewayPort = null;
        private string divisionNumber = null;
        private bool dicomListenerEnabled = true;
        private bool archiveEnabled = true;
        private bool iconGenerationEnabled = true;

        // CVIX support
        private string sitesFile = null;
        private string bhieUserName = null;
        private string bhiePassword = null;
        private string bhieProtocol = null;
        private string haimsUserName = null;
        private string haimsPassword = null;
        private string haimsProtocol = null;
        private string ncatUserName = null;
        private string ncatPassword = null;
        private string ncatProtocol = null;
        private int dodConnectorPort = 443;
        private string dodConnectorHost = null;
        private string station200UserName = null;
        private bool useOpenSslForXCAConnector = true;

        private int cvixHttpConnectorPort = 80;
        private int cvixHttpsConnectorPort = 443;
        
        // LB DCF enterprise licensing support
        private string renamedDeprecatedDcfRoot = null;

        // email notifications
        private string notificationEmailAddresses = null;

        // DKB - remember to add any new private members to the Copy method

        // VistA support
        private string vistaAccessor = null;
        private string vistaVerifier = null;

        // Muse support
        private bool museEnabled = true;
        private string museSiteNum = null;
        private string museHostname = null;
        private string museUsername = null;
        private string musePassword = null;
        private string musePort = null;
        private string museProtocol = null;

        // non peristable developer override for forcing Laurel Bridge not to be required.
        private bool isLaurelBridgeRequired = true;

        //DoD Connector
        private string dodConnectorLoinc = null;
        private string dodConnectorRequestSource = null;
        private string dodConnectorProvider = null;

        //silent install support
        private string vixRenderCache = null;
        private string tomcatArchiveDir = null;
        private string vixCertStoreDir = null;

        #region properties

        public string RenamedDeprecatedDcfRoot
        {
            get { return renamedDeprecatedDcfRoot; }
            set { renamedDeprecatedDcfRoot = value; }
        }

        public bool UseOpenSslForXCAConnector
        {
            get { return useOpenSslForXCAConnector; }
            set { useOpenSslForXCAConnector = value; }
        }

        public string Station200UserName
        {
            get { return station200UserName; }
            set { station200UserName = value; }
        }

        public int CvixHttpConnectorPort
        {
            get { return cvixHttpConnectorPort; }
            set { cvixHttpConnectorPort = value; }
        }

        public int CvixHttpsConnectorPort
        {
            get { return cvixHttpsConnectorPort; }
            set { cvixHttpsConnectorPort = value; }
        }

        public string DoDConnectorHost
        {
            get { return dodConnectorHost; }
            set { dodConnectorHost = value; }
        }

        public int DoDConnectorPort
        {
            get { return dodConnectorPort; }
            set { dodConnectorPort = value; }
        }

        public string DoDConnectorLoinc
        {
            get { return dodConnectorLoinc; }
            set { dodConnectorLoinc = value; }
        }

        public string DoDConnectorRequestSource
        {
            get { return dodConnectorRequestSource; }
            set { dodConnectorRequestSource = value; }
        }

        public string DoDConnectorProvider
        {
            get { return dodConnectorProvider; }
            set { dodConnectorProvider = value; }
        }

        public string SitesFile
        {
            get { return sitesFile; }
            set { sitesFile = value; }
        }

        public bool DicomListenerEnabled
        {
            get { return dicomListenerEnabled; }
            set { dicomListenerEnabled = value; }
        }

        public bool ArchiveEnabled
        {
            get { return archiveEnabled; }
            set { archiveEnabled = value; }
        }

        public bool IconGenerationEnabled
        {
            get { return iconGenerationEnabled; }
            set { iconGenerationEnabled = value; }
        }

        public string DivisionNumber
        {
            get { return divisionNumber; }
            set { divisionNumber = value; }
        }

        public string VdigAccessor
        {
            get { return vdigAccessor; }
            set { vdigAccessor = value; }
        }

        public string VdigVerifier
        {
            get { return vdigVerifier; }
            set { vdigVerifier = value; }
        }

        public string DicomImageGatewayServer
        {
            get { return dicomImageGatewayServer; }
            set { dicomImageGatewayServer = value; }
        }

        public string DicomImageGatewayPort
        {
            get { return dicomImageGatewayPort; }
            set { dicomImageGatewayPort = value; }
        }

        [XmlIgnore]
        public bool IsPatch
        {
            get { return isPatch; }
            set { isPatch = value; }
        }

        public VixRoleType VixRole
        {
            get { return vixRole; }
            set { vixRole = value; }
        }

        public String ApacheTomcatPassword1
        {
            get { return apachetomcatpassword1; }
            set { apachetomcatpassword1 = value; }
        }

        public String Apachetomcatpassword2
        {
            get { return apachetomcatpassword2; }
            set { apachetomcatpassword2 = value; }
        }

        public int VixCacheSize
        {
            get { return vixCacheSize; }
            set { vixCacheSize = value; }
        }

        public VixCacheType VixCacheOption
        {
            get { return vixCacheOption; }
            set { vixCacheOption = value; }
        }

        public VixDeploymentType VixDeploymentOption
        {
            get { return vixDeploymentOption; }
            set { vixDeploymentOption = value; }
        }
        
        public String VixServerName1
        {
            get { return vixServerName1; }
            set { vixServerName1 = value; }
        }

        public String VixServerName2
        {
            get { return vixServerName2; }
            set { vixServerName2 = value; }
        }

        public VixDeploymentType VixDeploymentOptionServer1
        {
            get { return vixDeploymentOptionServer1; }
            set { vixDeploymentOptionServer1 = value; }
        }

        public VixDeploymentType VixDeploymentOptionServer2
        {
            get { return vixDeploymentOptionServer2; }
            set { vixDeploymentOptionServer2 = value; }
        }

        public String FederationKeystorePassword
        {
            get { return federationKeystorePassword; }
            set { federationKeystorePassword = value; }
        }

        public String FederationTruststorePassword
        {
            get { return federationTruststorePassword; }
            set { federationTruststorePassword = value; }
        }

        public String VixRenderCache
        {
            get { return vixRenderCache; }
            set { vixRenderCache = value; }
        }

        public string VixCertStoreDir
        {
            get { return vixCertStoreDir; }
            set { vixCertStoreDir = value; }
        }

        public String TomcatArchiveDir
        {
            get { return tomcatArchiveDir; }
            set { tomcatArchiveDir = value; }
        }

        [XmlIgnore]
        public String VixServerNameProp
        {
            get
            {
                Debug.Assert(this.vixServerName1 == Environment.MachineName || this.vixServerName2 == Environment.MachineName);
                return Environment.MachineName;
            }
            set
            {
                if (this.vixServerName1 == null)
                {
                    this.vixServerName1 = value;
                }
                else if (this.vixServerName1 != null && this.vixServerName2 == null && this.vixServerName1 != value)
                {
                    this.vixServerName2 = value;
                }
                else
                {
                    Debug.Assert(this.vixServerName1 == value || this.vixServerName2 == value);
                }
            }
        }

        [XmlIgnore]
        public String PreviousProductVersionProp
        {
            get
            {
                if (this.vixServerName1 == Environment.MachineName)
                {
                    return previousProductVersion1;
                }
                else if (this.vixServerName2 == Environment.MachineName)
                {
                    return previousProductVersion2;
                }
                else
                {
                    throw new Exception("PreviousProductVersionProp get: machinename mismatch");
                }
            }
            set
            {
                if (this.vixServerName1 == Environment.MachineName)
                {
                    this.previousProductVersion1 = value;
                }
                else if (this.vixServerName2 == Environment.MachineName)
                {
                    this.previousProductVersion2 = value;
                }
                else
                {
                    throw new Exception("PreviousProductVersionProp set : machine name mismatch");
                }
            }
        }


        [XmlIgnore]
        public String ApacheTomcatPassword
        {
            get
            {
                if (this.vixServerName1 == Environment.MachineName)
                {
                    return apachetomcatpassword1;
                }
                else if (this.vixServerName2 == Environment.MachineName)
                {
                    return apachetomcatpassword2;
                }
                else
                {
                    throw new Exception("ApacheTomcatPassword get: machinename mismatch");
                }
            }
            set
            {
                if (this.vixServerName1 == Environment.MachineName)
                {
                    this.apachetomcatpassword1 = value;
                }
                else if (this.vixServerName2 == Environment.MachineName)
                {
                    this.apachetomcatpassword2 = value;
                }
                else
                {
                    throw new Exception("ApacheTomcatPassword set : machine name mismatch");
                }
            }
        }

        [XmlIgnore]
        public String ProductVersionProp
        {
            get
            {
                if (this.vixServerName1 == Environment.MachineName)
                {
                    return productVersion1;
                }
                else if (this.vixServerName2 == Environment.MachineName)
                {
                    return productVersion2;
                }
                else
                {
                    throw new Exception("ProductVersionProp get: machinename mismatch");
                }
            }
            set
            {
                if (this.vixServerName1 == Environment.MachineName)
                {
                    this.productVersion1 = value;
                }
                else if (this.vixServerName2 == Environment.MachineName)
                {
                    this.productVersion2 = value;
                }
                else
                {
                    throw new Exception("ProductVersionProp set: machinename mismatch");
                }
            }
        }

        public String SiteAbbreviation
        {
            get { return siteAbbreviation; }
            set { siteAbbreviation = value; }
        }

        public String SiteName
        {
            get { return siteName; }
            set { siteName = value; }
        }

        public String BiaPassword
        {
            get { return biaPassword; }
            set { biaPassword = value; }
        }

        public String BiaUsername
        {
            get { return biaUsername; }
            set { biaUsername = value; }
        }

        public String ConfigDir
        {
            get { return configDir; }
            set { configDir = value; }
        }

        public bool ConfigCheck
        {
            get { return configCheck; }
            set { configCheck = value; }
        }

        public String NetworkFileSharePassword
        {
            get { return networkFileSharePassword; }
            set { networkFileSharePassword = value; }
        }

        public String NetworkFileShareUsername
        {
            get { return networkFileShareUsername; }
            set { networkFileShareUsername = value; }
        }

        public String NetworkFileShare
        {
            get { return networkFileShare; }
            set { networkFileShare = value; }
        }

        public String LocalCacheDir
        {
            get { return localCacheDir; }
            set { localCacheDir = value; }
        }

        public String SiteServiceUri
        {
            get { return siteServiceUri; }
            set { siteServiceUri = value; }
        }

        public String SiteNumber
        {
            get { return siteNumber; }
            set { siteNumber = value; }
        }

        public String VistaServerName
        {
            get { return vistaServerName; }
            set { vistaServerName = value; }
        }

        public String VistaServerPort
        {
            get { return vistaServerPort; }
            set { vistaServerPort = value; }
        }

        public String ProductVersion1
        {
            get { return productVersion1; }
            set { productVersion1 = value; }
        }

        public String ProductVersion2
        {
            get { return productVersion2; }
            set { productVersion2 = value; }
        }

        public String PreviousProductVersion1
        {
            get { return previousProductVersion1; }
            set { previousProductVersion1 = value; }
        }

        public String PreviousProductVersion2
        {
            get { return previousProductVersion2; }
            set { previousProductVersion2 = value; }
        }

        public String TomcatAdminPassword
        {
            get { return tomcatAdminPassword; }
            set { tomcatAdminPassword = value; }
        }

        public string NotificationEmailAddresses
        {
            get { return this.notificationEmailAddresses; }
            set { this.notificationEmailAddresses = value; }
        }

        public string VistaAccessor
        {
            get { return this.vistaAccessor; }
            set { this.vistaAccessor = value; }
        }

        public string VistaVerifier
        {
            get { return this.vistaVerifier; }
            set { this.vistaVerifier = value; }
        }

        public bool MuseEnabled
        {
            get { return this.museEnabled; }
            set { this.museEnabled = value; }
        }

        public string MuseSiteNum
        {
            get { return this.museSiteNum; }
            set { this.museSiteNum = value; }
        }

        public string MuseHostname
        {
            get { return this.museHostname; }
            set { this.museHostname = value; }
        }

        public string MuseUsername
        {
            get { return this.museUsername; }
            set { this.museUsername = value; }
        }

        public string MusePassword
        {
            get { return this.musePassword; }
            set { this.musePassword = value; }
        }

        public string MusePort
        {
            get { return this.musePort; }
            set { this.musePort = value; }
        }

        public string MuseProtocol
        {
            get { return this.museProtocol; }
            set { this.museProtocol = value; }
        }

        [XmlIgnore]
        public bool IsLaurelBridgeRequired
        {
            get { return this.isLaurelBridgeRequired; }
            set { this.isLaurelBridgeRequired = value; }
        }

        public String VixTxDbDir
        {
            get { return vixTxDbDir; }
            set { vixTxDbDir = value; }
        }

        #endregion

        #region public methods
        /// <summary>
        /// 
        /// </summary>
        /// <returns>return true if the VIX installer is installing a VIX for the first time, false otherwise</returns>
        public bool IsNewVixInstallation()
        {
            return this.PreviousProductVersionProp == null ? true : false;
        }

        /// <summary>
        /// Check to see if both nodes of a cluster are installed
        /// </summary>
        /// <returns>true if both nodes have a VIX </returns>
        public bool AreBothNodesInstalled()
        {
            Debug.Assert(ClusterFacade.IsServerClusterNode());
            return (this.productVersion1 != null && this.productVersion2 != null) ? true : false;
        }

        /// <summary>
        /// Get the machine name of the other node in the cluster.
        /// </summary>
        /// <returns>the machine name of the other node in the cluster</returns>
        public string GetOtherNode()
        {
            Debug.Assert(this.vixServerName1 != null && this.vixServerName2 != null);
            if (this.vixServerName1 == Environment.MachineName)
            {
                return this.vixServerName2;
            }
            else
            {
                return this.vixServerName1;
            }
        }


        /// <summary>
        /// Check to see if both nodes of a cluster are the same software version
        /// </summary>
        /// <returns>true if both nodes are the same software version, false otherwise</returns>
        public bool AreBothNodesUpdated()
        {
            Debug.Assert(ClusterFacade.IsServerClusterNode());
            //Debug.Assert(AreBothNodesInstalled());
            return (this.productVersion1 == this.productVersion2) ? true : false;
        }

        public void Copy(VixConfigurationParameters config)
        {
            this.siteServiceUri = config.siteServiceUri;
            this.siteNumber = config.siteNumber;
            this.vistaServerName = config.vistaServerName;
            this.vistaServerPort = config.vistaServerPort;
            this.localCacheDir = config.localCacheDir;
            this.networkFileShare = config.networkFileShare;
            this.networkFileShareUsername = config.networkFileShareUsername;
            this.networkFileSharePassword = config.networkFileSharePassword;
            this.configDir = config.configDir;
            this.biaUsername = config.biaUsername;
            this.biaPassword = config.biaPassword;
            this.siteName = config.siteName;
            this.siteAbbreviation = config.siteAbbreviation;
            this.ProductVersion = config.ProductVersion; // TODO: deprecated but still active for migration purposes
            this.PreviousProductVersion = config.PreviousProductVersion; // TODO: deprecated but still active for migration purposes
            this.federationKeystorePassword = config.federationKeystorePassword;
            this.federationTruststorePassword = config.federationTruststorePassword;
            //this.vixCertificateInstallZipFilespec = config.vixCertificateInstallZipFilespec;
            this.vixDeploymentOptionServer1 = config.vixDeploymentOptionServer1; // TODO: deprecated but still active for migration purposes
            this.vixDeploymentOptionServer2 = config.vixDeploymentOptionServer2; // TODO: deprecated but still active for migration purposes
            this.vixServerName1 = config.vixServerName1;
            this.vixServerName2 = config.vixServerName2;
            this.configCheck = config.configCheck;
            this.vixCacheOption = config.vixCacheOption;
            this.vixCacheSize = config.vixCacheSize;
            this.productVersion1 = config.productVersion1;
            this.productVersion2 = config.productVersion2;
            this.previousProductVersion1 = config.previousProductVersion1;
            this.previousProductVersion2 = config.previousProductVersion2;
            this.vixDeploymentOption = config.vixDeploymentOption;
            this.tomcatAdminPassword = config.tomcatAdminPassword;
            //this.isPatch90orPatch101Installed = config.isPatch90orPatch101Installed;
            this.apachetomcatpassword1 = config.apachetomcatpassword1;
            this.apachetomcatpassword2 = config.apachetomcatpassword2;
            this.vixRole = config.vixRole;
            this.isPatch = config.isPatch;
            this.vdigAccessor = config.vdigAccessor;
            this.vdigVerifier = config.vdigVerifier;
            this.dicomImageGatewayServer = config.dicomImageGatewayServer;
            this.dicomImageGatewayPort = config.dicomImageGatewayPort;
            this.divisionNumber = config.divisionNumber;
            this.dicomListenerEnabled = config.dicomListenerEnabled;
            this.archiveEnabled = config.archiveEnabled;
            this.iconGenerationEnabled = config.iconGenerationEnabled;
            this.bhieUserName = config.bhieUserName;
            this.bhiePassword = config.bhiePassword;
            this.bhieProtocol = config.bhieProtocol;
            this.haimsUserName = config.haimsUserName;
            this.haimsPassword = config.haimsPassword;
            this.haimsProtocol = config.haimsProtocol;
            this.ncatUserName = config.ncatUserName;
            this.ncatPassword = config.ncatPassword;
            this.ncatProtocol = config.ncatProtocol;
            this.station200UserName = config.station200UserName;
            this.useOpenSslForXCAConnector = config.useOpenSslForXCAConnector;
            this.renamedDeprecatedDcfRoot = config.renamedDeprecatedDcfRoot;
            this.notificationEmailAddresses = config.notificationEmailAddresses;
            this.vistaAccessor = config.vistaAccessor;
            this.vistaVerifier = config.vistaVerifier;
            this.isLaurelBridgeRequired = config.isLaurelBridgeRequired;
            //this.deployConfigs = config.deployConfigs;
        }

        public void LogConfigState()
        {
            Logger().Info("siteServiceUri = " + this.siteServiceUri);
            Logger().Info("siteNumber = " + this.siteNumber);
            Logger().Info("vistaServerName = " + this.vistaServerName);
            Logger().Info("vistaServerPort = " + this.vistaServerPort);
            Logger().Info("localCacheDir = " + this.localCacheDir);
            Logger().Info("networkFileShare = " + this.networkFileShare);
            Logger().Info("networkFileShareUsername = " + this.networkFileShareUsername);
            Logger().Info("networkFileSharePassword = " + this.networkFileSharePassword);
            Logger().Info("configDir = " + this.configDir);
            Logger().Info("configCheck = " + this.configCheck);
            Logger().Info("biaUsername = <not shown>");
            Logger().Info("biaPassword = <not shown>");
            Logger().Info("siteName = " + this.siteName);
            Logger().Info("siteAbbreviation = " + this.siteAbbreviation);
            Logger().Info("productVersion = " + this.ProductVersion);
            Logger().Info("previousProductVersion = " + this.PreviousProductVersion);
            Logger().Info("federationKeystorePassword = <not shown>");
            Logger().Info("federationTruststorePassword = <not shown>");
            //Logger().Info("vixCertificateInstallZipFilespec = " + this.vixCertificateInstallZipFilespec);
            Logger().Info("vixDeploymentOptionServer1 = " + this.vixDeploymentOptionServer1);
            Logger().Info("vixDeploymentOptionServer2 = " + this.vixDeploymentOptionServer2);
            Logger().Info("vixServerName1 = " + this.vixServerName1);
            Logger().Info("vixServerName2 = " + this.vixServerName2);
            Logger().Info("vixTxDbDir = " + this.vixTxDbDir);
            Logger().Info("vixCacheOption = " + this.vixCacheOption);
            Logger().Info("vixCacheSize = " + this.vixCacheSize);
            Logger().Info("isNewVixInstallation = " + this.IsNewVixInstallation());
            Logger().Info("productVersion1 = " + this.productVersion1);
            Logger().Info("productVersion2 = " + this.productVersion2);
            Logger().Info("previousProductVersion1 = " + this.previousProductVersion1);
            Logger().Info("previousProductVersion2 = " + this.previousProductVersion2);
            Logger().Info("vixDeploymentOption = " + this.vixDeploymentOption);
            Logger().Info("tomcatAdminPassowrd = <not shown>");
            //Logger().Info("isPatch90orPatch101Installed = " + this.isPatch90orPatch101Installed);
            Logger().Info("apachetomcatpassword1 = <not shown>");
            Logger().Info("apachetomcatpassword2 = <not shown>");
            Logger().Info("vixRole = " + this.vixRole);
            Logger().Info("isPatch = " + this.isPatch);
            Logger().Info("vdigAccessor = <not shown>");
            Logger().Info("vdigVerifier = <not shown>");
            Logger().Info("dicomImageGatewayServer = " + this.dicomImageGatewayServer);
            Logger().Info("dicomImageGatewayPort = " + this.dicomImageGatewayPort);
            Logger().Info("divisionNumber = " + this.divisionNumber);
            Logger().Info("dicomListenerEnabled = " + this.dicomListenerEnabled);
            Logger().Info("archiveEnabled = " + this.archiveEnabled);
            Logger().Info("iconGenerationEnabled = " + this.iconGenerationEnabled);
            Logger().Info("bhieUserName =  <not shown>");
            Logger().Info("bhiePassword =  <not shown>");
            Logger().Info("bhieProtocol = " + this.bhieProtocol);
            Logger().Info("haimsUserName =  <not shown>");
            Logger().Info("haimsPassword =  <not shown>");
            Logger().Info("haimsProtocol = " + this.haimsProtocol);
            Logger().Info("ncatUserName =  <not shown>");
            Logger().Info("ncatPassword =  <not shown>");
            Logger().Info("ncatProtocol = " + this.ncatProtocol);
            Logger().Info("station200UserName = " + this.station200UserName);
            Logger().Info("useOpenSslForXCAConnector = " + this.useOpenSslForXCAConnector);
            Logger().Info("renamedDeprecatedDcfRoot = " + this.renamedDeprecatedDcfRoot);
            Logger().Info("notificationEmailAddresess = " + this.notificationEmailAddresses);
            Logger().Info("vistaAccessor =  <not shown>");
            Logger().Info("vistaVerifier =  <not shown>");
            Logger().Info("isLaurelBridgeRequired = " + this.isLaurelBridgeRequired);
        }

        public bool HasVistaConfiguration()
        {
            if (this.vistaAccessor != null && this.vistaVerifier != null && notificationEmailAddresses != null)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool HasMuseConfiguration()
        {
            if (this.museSiteNum != null && this.museHostname != null && this.museUsername != null && this.musePassword != null && this.musePort != null && this.museProtocol != null)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool HasDicomConfiguration()
        {
            if (dicomImageGatewayServer != null && dicomImageGatewayPort != null && vdigAccessor != null && vdigVerifier != null && notificationEmailAddresses != null)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public bool HasXcaConfiguration()
        {
            bool configured = true;
            if (bhieProtocol == null || haimsProtocol == null || ncatProtocol == null)
            {
                configured = false;
            }
            if (bhieUserName != null && bhiePassword == null)
            {
                configured = false;
            }
            if (haimsUserName != null && haimsPassword == null)
            {
                configured = false;
            }
            if (ncatUserName != null && ncatPassword == null)
            {
                configured = false;
            }

            return configured;
        }

        public void ToXml()
        {
            //Logger().Info("Configuration state before persisting");
            //this.LogConfigState();
            XmlSerializer serializer = null;
            //FileStream stream = null;
            Debug.Assert(this.configDir != null);
            Debug.Assert(Directory.Exists(this.configDir));
            String filepsec = Path.Combine(this.configDir, VIX_INSTALLER_CONFIG_FILENAME);
            XmlDocument doc = new XmlDocument();
            doc.PreserveWhitespace = true;
            TripleDESDocumentEncryption cryptotron = null;
            MemoryStream stream = null;

            try
            {
                // Create a serializer for the Sailboat type
                serializer = new XmlSerializer(this.GetType());
                // Create a new writable FileStream, using the path passed
                // as a parameter.
                //stream = new FileStream(filepsec, FileMode.Create, FileAccess.Write);
                stream = new MemoryStream();
                serializer.Serialize(stream, this);
                stream.Position = 0;
                doc.Load(stream);
                cryptotron = new TripleDESDocumentEncryption(doc);
                cryptotron.Encrypt("FederationKeystorePassword");
                cryptotron.Encrypt("FederationTruststorePassword");
                cryptotron.Encrypt("BiaPassword");
                cryptotron.Encrypt("BiaUsername");
                cryptotron.Encrypt("Apachetomcatpassword1");
                cryptotron.Encrypt("Apachetomcatpassword2");
                cryptotron.Encrypt("TomcatAdminPassword");
                cryptotron.Encrypt("VdigAccessor");
                cryptotron.Encrypt("VdigVerifier");
                cryptotron.Encrypt("BhieUserName");
                cryptotron.Encrypt("BhiePassword");
                cryptotron.Encrypt("HaimsUserName");
                cryptotron.Encrypt("HaimsPassword");
                cryptotron.Encrypt("NcatUserName");
                cryptotron.Encrypt("NcatPassword");
                cryptotron.Encrypt("Station200UserName");
                cryptotron.Encrypt("VistaAccessor");
                cryptotron.Encrypt("VistaVerifier");
                doc.Save(filepsec);
            }
            finally
            {
                if (stream != null)
                {
                    stream.Close();
                }
            }
        }


        #endregion

        #region public static methods
        /// <summary>
        /// 
        /// </summary>
        /// <param name="newProductVersion"></param>
        /// <param name="keyStorePassword"></param>
        /// <param name="trustStorePassword"></param>
        /// <returns></returns>
        public static VixConfigurationParameters GetVixConfiguration(string newProductVersion, string keyStorePassword, string trustStorePassword, bool isPatch)
        {
            VixConfigurationParameters config = null;

///            if (VixFacade.IsVixConfigured() || VixConfigurationParameters.IsVixInstallerConfigured()) // use the existing ViX configuration if it exists
            if (VixConfigurationParameters.IsVixInstallerConfigured()) // use the existing ViX configuration if it exists
            {
                if (ClusterFacade.IsServerClusterNode())
                {
                    Logger().Info(Environment.MachineName + " belongs to a High Availibility Cluster");
                }
                else
                {
                    Logger().Info(Environment.MachineName + " is a Single Server VIX installation");
                }
                config = VixConfigurationParameters.FromXml(VixFacade.GetVixConfigurationDirectory()); //, keyStorePassword, trustStorePassword);
                config.PreviousProductVersionProp = config.ProductVersionProp;
                config.ProductVersionProp = newProductVersion;
                Logger().Info("Existing VIX deployment of type " + config.VixDeploymentOption.ToString() + " for server " + Environment.MachineName);
            }
            else if (ClusterFacade.IsServerClusterNode() && VixFacade.GetExistingFocVixConfigurationDir() != null)
            {
                //Debug.Assert(VixConfigurationParameters.IsVixInstallerConfigured()); - not true for initial install of 2nf foc node
                Logger().Info(Environment.MachineName + " belongs to a High Availibility Cluster - second node new installation");
                string configDir = VixFacade.GetExistingFocVixConfigurationDir();
                Debug.Assert(configDir != null);
                config = VixConfigurationParameters.FromXml(configDir); //, keyStorePassword, trustStorePassword);
                config.VixServerNameProp = Environment.MachineName;
                config.ProductVersionProp = newProductVersion; //PreviousProductVersion == null
            }
            else // new installation
            {
                config = new VixConfigurationParameters(newProductVersion, keyStorePassword, trustStorePassword);
            }
            config.IsPatch = isPatch;

            // null out site information (except for number) information so we must prompt for it again (site service refresh)
            // this is not done if he VixPatchingUtility is used
            if (!config.isPatch)
            {
                config.vistaServerName = null;
                config.vistaServerPort = null;
                config.siteAbbreviation = null;
                config.siteName = null;
            }

            // change existing VIXen over to the VixLimitedSizePrototype
            if (config.vixCacheOption == VixCacheType.NotSpecified)
            {
                config.vixCacheOption = GetVixCacheTypeByDeploymentOption(config.VixDeploymentOption); // use property that gets the deployment option based on machine name
            }

            Logger().Info("Configuration state after initialization");
            config.LogConfigState();
            return config;
        }

        #endregion

        #region private methods

        /// <summary>
        /// Migrate between older versions of the VixConfigurationParameters to the current version.
        /// </summary>
        private void migrate()
        {
            if (this.vixRole == VixRoleType.NotSpecified)
            {
                if (this.ProductVersionProp.StartsWith("30.83"))
                {
                    this.vixRole = VixRoleType.SiteVix;
                }
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="deploymentOption"></param>
        /// <returns></returns>
        private static VixCacheType GetVixCacheTypeByDeploymentOption(VixDeploymentType deploymentOption)
        {
            VixCacheType vixCacheOption = VixCacheType.NotSpecified;
            switch (deploymentOption)
            {
                case VixDeploymentType.SingleServer:
                case VixDeploymentType.FocClusterNode:
                //case VixDeploymentType.CvixFocClusterNode:
                    vixCacheOption = VixCacheType.ExchangeTimeEvictionLocalFilesystem;
                    break;
            }
            Debug.Assert(vixCacheOption != VixCacheType.NotSpecified);
            return vixCacheOption;
        }

        /// <summary>
        /// For new installations, determine the deployment type from the current server. We are smart.
        /// </summary>
        /// <returns></returns>
        private static VixDeploymentType DetermineDeploymentTypeForServer()
        {
            VixDeploymentType deploymentType = VixDeploymentType.NotSpecified;

            if (BusinessFacade.IsWindowsXP())
            {
                deploymentType = VixDeploymentType.SingleServer;
            }
            else if (ClusterFacade.IsServerClusterNode())
            {
                deploymentType = VixDeploymentType.FocClusterNode; // DKB - 5/10/2011 - remove last vestiges of pre-manifest installer
            }
            else
            {
                deploymentType = VixDeploymentType.SingleServer; // DKB - 5/10/2011 - remove last vestiges of pre-manifest installer
            }

            return deploymentType;
        }

        /// <summary>
        /// Loads the persisted state of the VixConfigurationParameters object
        /// </summary>
        /// <param name="vixConfigDir"></param>
        /// <returns>an initialized VixConfigurationParameters object or null if persisted state could not be found </returns>
        /// 
        public static VixConfigurationParameters FromXml(String vixConfigDir) //, string keyStorePassword, string trustStorePassword)
        {
            String filespec = Path.Combine(vixConfigDir, VIX_INSTALLER_CONFIG_FILENAME);
            return FromXmlFile(filespec);
        }
        public static VixConfigurationParameters FromXmlFile(String filespec) //, string keyStorePassword, string trustStorePassword)
        {
            XmlSerializer serializer = null;
            VixConfigurationParameters config = null;

            if (File.Exists(filespec)) // no encryption
            {
                XmlDocument doc = new XmlDocument();
                doc.PreserveWhitespace = true;
                TripleDESDocumentEncryption cryptotron = null;
                MemoryStream stream = null;

                try
                {
                    config = new VixConfigurationParameters();
                    doc.Load(filespec);
                    cryptotron = new TripleDESDocumentEncryption(doc);
                    cryptotron.Decrypt();
                    stream = new MemoryStream();
                    //doc.Save(Path.Combine(vixConfigDir, "foo.xml"));
                    doc.Save(stream);
                    stream.Position = 0;
                    serializer = new XmlSerializer(config.GetType());
                    config = (VixConfigurationParameters)serializer.Deserialize(stream);
                }
                finally
                {
                    if (stream != null)
                    {
                        stream.Close();
                    }
                }
                config.migrate();
            }

            return config;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="vixConfigDir"></param>
        /// <returns></returns>
        public static void FromXmlToFile(String vixConfigDir)
        {
            String filespec = Path.Combine(vixConfigDir, VIX_INSTALLER_CONFIG_FILENAME);

            if (File.Exists(filespec)) // no encryption
            {
                XmlDocument doc = new XmlDocument();
                doc.PreserveWhitespace = true;
                TripleDESDocumentEncryption cryptotron = null;
                doc.Load(filespec);
                cryptotron = new TripleDESDocumentEncryption(doc);
                cryptotron.Decrypt();
                doc.Save(Path.Combine(vixConfigDir, "foo.xml"));
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private static bool IsVixInstallerConfigured()
        {
            bool isConfigured = false;

            String vixConfigDir = Environment.GetEnvironmentVariable("vixconfig", EnvironmentVariableTarget.Machine);
            if (vixConfigDir != null)
            {
                String vixConfigPlainTextFilepath = Path.Combine(vixConfigDir, VIX_INSTALLER_CONFIG_FILENAME);
                String vixConfigFilepath = Path.Combine(vixConfigDir, VIX_INSTALLER_CONFIG_FILENAME);
                if (File.Exists(vixConfigPlainTextFilepath) || File.Exists(vixConfigFilepath))
                {
                    isConfigured = true;
                }
            }

            return isConfigured;
        }
        #endregion

        class TripleDESDocumentEncryption
        {
            private XmlDocument xmlDoc;
            private TripleDES algorithm;

            public TripleDESDocumentEncryption(XmlDocument doc)
            {
                byte[] key = { 58, 250, 251, 44, 187, 30, 176, 28, 199, 140, 220, 19, 159, 244, 226, 217, 38, 217, 231, 178, 117, 188, 225, 43 };
                byte[] iv = { 34, 15, 64, 79, 93, 70, 14, 161 };
                if (doc != null)
                {
                    xmlDoc = doc;
                }
                else
                {
                    throw new ArgumentNullException("Doc");
                }

                algorithm = new TripleDESCryptoServiceProvider();
                algorithm.Key = key;
                algorithm.IV = iv;
            }

            public void Encrypt(string elementName)
            {
                // Find the element by name and create a new
                // XmlElement object.
                XmlElement inputElement = xmlDoc.GetElementsByTagName(elementName)[0] as XmlElement;

                // If the element was not found, we're done.
                if (inputElement == null)
                {
                    return; // this is because the XmlSerializer does not create elements with default values
                }

                // Create a new EncryptedXml object.
                EncryptedXml exml = new EncryptedXml(xmlDoc);

                // Encrypt the element using the symmetric key.
                byte[] rgbOutput = exml.EncryptData(inputElement, algorithm, false);

                // Create an EncryptedData object and populate it.
                EncryptedData ed = new EncryptedData();

                // Specify the namespace URI for XML encryption elements.
                ed.Type = EncryptedXml.XmlEncElementUrl;

                // Specify the namespace URI for the TrippleDES algorithm.
                ed.EncryptionMethod = new EncryptionMethod(EncryptedXml.XmlEncTripleDESUrl);

                // Create a CipherData element.
                ed.CipherData = new CipherData();

                // Set the CipherData element to the value of the encrypted XML element.
                ed.CipherData.CipherValue = rgbOutput;

                // Replace the plaintext XML elemnt with an EncryptedData element.
                EncryptedXml.ReplaceElement(inputElement, ed, false);
            }

            public void Decrypt()
            {
                XmlElement encryptedElement = null;
                while ((encryptedElement = xmlDoc.GetElementsByTagName("EncryptedData")[0] as XmlElement) != null)
                {
                    // Create an EncryptedData object and populate it.
                    EncryptedData ed = new EncryptedData();
                    ed.LoadXml(encryptedElement);

                    // Create a new EncryptedXml object.
                    EncryptedXml exml = new EncryptedXml();

                    // Decrypt the element using the symmetric key.
                    byte[] rgbOutput = exml.DecryptData(ed, algorithm);

                    // Replace the encryptedData element with the plaintext XML elemnt.
                    exml.ReplaceData(encryptedElement, rgbOutput);
                }
            }

        }

    }
}
