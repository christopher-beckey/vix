using System;
namespace gov.va.med.imaging.exchange.VixInstaller.business
{
    public interface IVixConfigurationParameters
    {
        string TomcatAdminPassword { get; set; }
        string BiaPassword { get; set; }
        string BiaUsername { get; set; }
        string ConfigDir { get; set; }
        string FederationKeystorePassword { get; set; }
        string FederationTruststorePassword { get; set; }
        bool IsNewVixInstallation();
        string LocalCacheDir { get; set; }
        string NetworkFileShare { get; set; }
        string NetworkFileSharePassword { get; set; }
        string NetworkFileShareUsername { get; set; }
        string PreviousProductVersion1 { get; set; }
        string PreviousProductVersionProp { get; set; }
        string ProductVersionProp { get; set; }
        string SiteAbbreviation { get; set; }
        string SiteName { get; set; }
        string SiteNumber { get; set; }
        string SiteServiceUri { get; set; }
        void ToXml();
        string TomcatArchiveDir { get; set; }
        string VistaServerName { get; set; }
        string VistaServerPort { get; set; }
        VixCacheType VixCacheOption { get; set; }
        int VixCacheSize { get; set; }
        //string VixCertificateInstallZipFilespec { get; set; }
        VixDeploymentType VixDeploymentOption { get; }
        bool AreBothNodesInstalled();
        bool AreBothNodesUpdated();
        string GetOtherNode();
        //bool IsPatch90orPatch101Installed { get; set; }
        string ApacheTomcatPassword1 { get; set; }
        string ApacheTomcatPassword { get; set; }
        VixRoleType VixRole { get; set; }
        bool IsPatch { get; set; }
        string VdigAccessor { get; set; }
        string VdigVerifier { get; set; }
        string DicomImageGatewayServer { get; set; }
        string DicomImageGatewayPort { get; set; }
        bool HasDicomConfiguration();
        //string DivisionNumber { get; set; }
        bool DicomListenerEnabled { get; set; }
        bool ArchiveEnabled { get; set; }
        bool IconGenerationEnabled { get; set; }
        string SitesFile { get; set; }
        //string BhieUserName { get; set; }
        //string BhiePassword { get; set; }
        //string BhieProtocol { get; set; }
        //string HaimsUserName { get; set; }
        //string HaimsPassword { get; set; }
        //string HaimsProtocol { get; set; }
        //string NcatUserName { get; set; }
        //string NcatPassword { get; set; }
        //string NcatProtocol { get; set; }
        //bool HasXcaConfiguration();
        //int XcaConnectorPort { get; set; }
        int CvixHttpConnectorPort { get; set; }
        int CvixHttpsConnectorPort { get; set; }
        string Station200UserName { get; set; }
        string VixServerNameProp { get; set; }
        bool UseOpenSslForXCAConnector { get; set; }
        string RenamedDeprecatedDcfRoot { get; set; }
        string NotificationEmailAddresses { get; set; }
        string VistaAccessor { get; set; }
        string VistaVerifier { get; set; }

        bool MuseEnabled { get; set; }
        string MuseSiteNum { get; set; }
        string MuseHostname { get; set; }
        string MuseUsername { get; set; }
        string MusePassword { get; set; }
        string MusePort { get; set; }
        string MuseProtocol { get; set; }

        bool HasVistaConfiguration();
        bool HasMuseConfiguration();
        bool IsLaurelBridgeRequired { get; set; }

        string DoDConnectorHost { get; set; }
        int DoDConnectorPort { get; set; }
        string DoDConnectorProvider { get; set; }
        string DoDConnectorLoinc { get; set; }
        string DoDConnectorRequestSource { get; set; }

        string VixRenderCache { get; set; }
        string VixCertStoreDir { get; set; }

        string VixTxDbDir { get; set; }

        bool ConfigCheck { get; set; }
    }

}
