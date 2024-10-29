package gov.va.med.imaging.url.mix.configuration;

import gov.va.med.imaging.configuration.DetectConfigNonTransientValueChanges;
import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;
import gov.va.med.imaging.url.mix.exceptions.MIXConfigurationException;
import gov.va.med.logging.Logger;

import java.io.Serializable;
import java.util.*;


/**
 * 
 * @author VACOTITTOC
 *
 */
public class MIXConfiguration
implements Serializable, DetectConfigNonTransientValueChanges
{	
	// Default values for ECIA connection
	
	public final static boolean DEFAULT_USE_ECIA = true;
	
	public final static String DEFAULT_ECIA_DICOM_HOST = "10.247.210.11"; // AWS Test server
	public final static int DEFAULT_ECIA_DICOM_PORT = 104;
	public final static String DEFAULT_ECIA_CALLING_AE = "ACUO_TESTING";
	public final static String DEFAULT_ECIA_CALLED_AE = "VA_ECIA_TESTAPP1";
	public final static int DEFAULT_ECIA_DICOM_CONNECT_TIMEOUT = 60000;
	public final static int DEFAULT_ECIA_DICOM_CFIND_TIMEOUT = 60000;

	public final static String DEFAULT_ECIA_WADO_PROTOCOL = "http";
	public final static String DEFAULT_ECIA_WADO_HOST = "10.247.210.11";
	public final static int DEFAULT_ECIA_WADO_PORT = 8081;
	public final static String DEFAULT_ECIA_WADO_APP = "AcuoRest";
	public final static String DEFAULT_ECIA_WADO_PATH = "wadoget?requestType=WADO&contenttype=application/dicom&studyUID={studyUid}&seriesUID={seriesUid}&objectUID={instanceUid}";
	
	// DO NOT CHANGE THESE VALUES
	public final static String DEFAULT_ECIA_DICOM_SITE = "200D";
	public final static String DEFAULT_ECIA_WADO_SITE = "200W";
	
	//+++++++++++++++++++++++++++++++++++++++++++++
	// Constants for names of viewers (used for SOP Blacklists)
	public static final String VIEWER_CLINICAL_DISPLAY = "ClinicalDisplay";
	public static final String VIEWER_VISTA_RAD = "VistARad";
	public static final String VIEWER_VIX = "VixViewer";
	public static final String DEFAULT_IMAGE_TYPE_NOT_SUPPORTED_FILE = "C:/VixConfig/ImageTypeNotSupported.dcm";
	
	//+++++++++++++++++++++++++++++++++++++++++++++
	
	private final static long serialVersionUID = 1L;

	private static final String DEFAULT_DAS_USERNAME = "vixuser";
	private static final String DEFAULT_DAS_KEY = "vixvix1.";
	public static final String DEFAULT_DAS_SITE = "200";
	public static final String DEFAULT_DAS_PROTOCOL = "mixs";
	
	public final static String defaultMIXProtocol = "https";
	
	public final static String defaultDODXChangeApplication = "haims"; // DAS is proxy only...
	public final static String defaultDODMetadataXChangePath1 = "/mix/v1/DiagnosticReport/subject"; // "/mix/DiagnosticReport/subject" (FHIR) -- pass 1 level 1
	public final static String defaultDODMetadataXChangePath2 = "/mix/v1/ImagingStudy"; // "/mix/ImagingStudy" (FHIR) -- pass 1 level 2
	public final static String defaultDODImageXChangePath1 = "/mix/v1/RetrieveThumbnail"; // "/mix/RetrieveThumbnail" (WADO-URI) -- pass 2 (TN)
	public final static String defaultDODImageXChangePath2 = "/mix/v1/RetrieveInstance"; // "/mix/RetrieveInstance" (WADO-RS) -- pass 2 (Ref/Diag)
	//public final static String defaultDODImageHost = "das-sqa.va.gov";
	public final static String defaultDODImageHost = "das-test.va.gov";  // Quoc changed to test. Should have one patient to test as of 03/18/2020
	
	public final static int defaultDODImagePort = 443;
	
	public final static String defaultImageXChangeApplication = "MIXWebApp";// was "ImagingExchangeWebApp";
	public final static String defaultImageMetadataXChangePath1 = "/restservices/mix/DiagnosticReport/subject"; // (FHIR) -- pass 1 level 1
	public final static String defaultImageMetadataXChangePath2 = "/restservices/mix/ImagingStudy"; // (FHIR) -- pass 1 level 2
	public final static String defaultImageXChangePath1 = "/mix/retrieveThumbnail";	// (WADO-URI) -- pass 2 (TN)
	public final static String defaultImageXChangePath2 = "/mix/retrieveInstance";	// (WADO-URI) -- pass 2 (Ref/Diag); later WADO-RS
	public final static String defaultImageHost = "localhost";
	public final static int defaultImagePort = 443;
	
	public final static String defaultKeystoreUrl = "file:///c:/VixCertStore/federation.keystore";
	public final static String defaultTruststoreUrl = "file:///c:/VixCertStore/federation.truststore";
		
	private final static Logger logger = Logger.getLogger(MIXConfiguration.class);
	
	private List<MIXSiteConfiguration> configurations;
	private List<String> emptyStudyModalities;
	// VistA Rad modality blacklist to filter by
	private List<String> vistaRadModalityBlacklist;
	private List<String> sopBlacklistForClinicalDisplay;
	private List<String> sopBlacklistForVixViewer;
	private List<String> sopBlacklistForVistaRad;
	private Map<String, List<String>> sopBlacklists;
	private int metadataTimeout;
	private int metadataConcurentQueryTimeout;
	private int maxConcurentThreads;	
	private String keystoreUrl;
	private EncryptedConfigurationPropertyString keystorePassword;
	private String truststoreUrl;
	private EncryptedConfigurationPropertyString truststorePassword;
	
	public final static int defaultMetadataTimeout = 210000;
	public final static int defaultMetadataConcurrentQueryTimeoutTimeout = 7000;
	public final static int defaultmaxConcurentThreads = 10;
	
	// Flag to switch to ECIA as a data source
	private Boolean useEcia;
		
	// Replacement image for unsupported image in viewers
	private String imageTypeNotSupportedFile;
	
	/**
	 * 
	 */
	public MIXConfiguration() 
	{
		super();
		configurations = new ArrayList<MIXSiteConfiguration>();
		emptyStudyModalities = new ArrayList<String>();
		metadataTimeout = defaultMetadataTimeout; // 45 sec
		metadataConcurentQueryTimeout = defaultMetadataConcurrentQueryTimeoutTimeout; // 4+ sec
		maxConcurentThreads = defaultmaxConcurentThreads; // 10

		// Default initializers to provide empty tags in the configuration XML
		vistaRadModalityBlacklist = new ArrayList<String>();
		sopBlacklistForClinicalDisplay = new ArrayList<String>();
		sopBlacklistForVixViewer = new ArrayList<String>();
		sopBlacklistForVistaRad = new ArrayList<String>();
		imageTypeNotSupportedFile = DEFAULT_IMAGE_TYPE_NOT_SUPPORTED_FILE;
		useEcia = new Boolean(false);
	}

	public static MIXConfiguration createDefaultMixConfiguration(
			List<String> emptyStudyModalities, 
			int metadataTimeout, 
			String imageHost, int imagePort,
			String cvixCertPwd,
			String dasCertPwd
			)
	throws MIXConfigurationException
	{
		MIXConfiguration mixConfiguration = new MIXConfiguration();
		mixConfiguration.createDoDSite(null,  null, imageHost, imagePort);
		
		mixConfiguration.createDefaulEciaDicomSite();  // added for config file template creation
		mixConfiguration.createDefaulEciatWadoSite();	// added for config file template creation
		mixConfiguration.useEcia = new Boolean(DEFAULT_USE_ECIA); 	// added for config file template creation
		
		mixConfiguration.emptyStudyModalities.addAll(emptyStudyModalities);
		mixConfiguration.metadataTimeout = metadataTimeout;
		mixConfiguration.keystoreUrl = defaultKeystoreUrl;
		mixConfiguration.truststoreUrl = defaultTruststoreUrl;
		mixConfiguration.keystorePassword = new EncryptedConfigurationPropertyString(cvixCertPwd);
		mixConfiguration.truststorePassword = new EncryptedConfigurationPropertyString(dasCertPwd);
	
		return mixConfiguration;
	}

	/**
	 * Create an MIXConfiguration instance with a DOD and multiple VA site
	 * entries.
	 * 
	 * @param vaSites
	 * @return
	 * @throws MIXConfigurationException
	 */
	public static MIXConfiguration createDefaultMixConfiguration(String[] vaSites)
	throws MIXConfigurationException
	{
		MIXConfiguration mixConfiguration = new MIXConfiguration();
		/*
		xchangeConfiguration.setDasPassword(DEFAULT_DAS_PASSWORD);
		xchangeConfiguration.setDasUsername(DEFAULT_DAS_USERNAME);
		*/
		
		if(vaSites != null)
		{
			for(String vaSite : vaSites)
			{
                logger.debug("Adding VA template for site [{}]", vaSite);
				if(vaSite != null)
				{
					MIXSiteConfiguration site = 
						new MIXSiteConfiguration(
							vaSite, "", "", 
							defaultImageXChangeApplication, 
							defaultImageMetadataXChangePath1, 
							defaultImageMetadataXChangePath2, 
							defaultImageXChangePath1,
							defaultImageXChangePath2,
							true,
							defaultImageHost,
							defaultImagePort, defaultMIXProtocol);
					
					mixConfiguration.addSiteConfiguration(site);
				}
			}
		}
		
		mixConfiguration.createDefaultDoDSite();		
		return mixConfiguration;
	}
	
	public void createDefaulEciaDicomSite() // new
	{ 
		EciaDicomSiteConfiguration site = new EciaDicomSiteConfiguration();
		
		site.setSiteNumber(DEFAULT_ECIA_DICOM_SITE);
		site.setCallingAE(DEFAULT_ECIA_CALLING_AE);
		site.setCalledAE(DEFAULT_ECIA_CALLED_AE);
		site.setHost(DEFAULT_ECIA_DICOM_HOST);
		site.setPort(DEFAULT_ECIA_DICOM_PORT);
		site.setConnectTimeOut(DEFAULT_ECIA_DICOM_CONNECT_TIMEOUT);
		site.setCfindRspTimeOut(DEFAULT_ECIA_DICOM_CFIND_TIMEOUT);

		addSiteConfiguration(site);
	}

	
	public void createDefaulEciatWadoSite() // new
	{ 
		MIXSiteConfiguration site = new MIXSiteConfiguration();
		
		site.setSiteNumber(DEFAULT_ECIA_WADO_SITE);
		site.setMixApplication(DEFAULT_ECIA_WADO_APP);
		site.setProtocol(DEFAULT_ECIA_WADO_PROTOCOL);
		site.setHost(DEFAULT_ECIA_WADO_HOST);
		site.setPort(DEFAULT_ECIA_WADO_PORT);

		addSiteConfiguration(site);
	}
	
	public void createDefaultDoDSite() // was private
	{
		MIXSiteConfiguration site = new MIXSiteConfiguration(DEFAULT_DAS_SITE, 
				DEFAULT_DAS_USERNAME, DEFAULT_DAS_KEY, defaultDODXChangeApplication,
				defaultDODMetadataXChangePath1, defaultDODMetadataXChangePath2,
				defaultDODImageXChangePath1, defaultDODImageXChangePath1, false,
				defaultDODImageHost, defaultDODImagePort, defaultMIXProtocol);
		
		addSiteConfiguration(site);
	}
	
	private void createDoDSite(String dasUsername, String dasPassword, String imageHost, int imagePort)
	{
		MIXSiteConfiguration site = new MIXSiteConfiguration(DEFAULT_DAS_SITE, 
				DEFAULT_DAS_USERNAME, DEFAULT_DAS_KEY, defaultDODXChangeApplication,
				defaultDODMetadataXChangePath1, defaultDODMetadataXChangePath2,
				defaultDODImageXChangePath1, defaultDODImageXChangePath1, false,
				imageHost, imagePort, defaultMIXProtocol);
		
		addSiteConfiguration(site);
	}

	@SuppressWarnings("unused")
	private void createDoDSite(String dasUsername, String dasPassword)
	{
		String username = DEFAULT_DAS_USERNAME;
		String dasKey = DEFAULT_DAS_KEY;
		if(dasUsername != null)
			username = dasUsername;
		if(dasPassword != null)
			dasKey = dasPassword;
        logger.debug("Adding DOD Site with username [{}] and password [{}]", username, dasKey);
		MIXSiteConfiguration site = new MIXSiteConfiguration(DEFAULT_DAS_SITE, 
				username, dasKey, defaultDODXChangeApplication,
				defaultDODMetadataXChangePath1, defaultDODMetadataXChangePath2,
				defaultDODImageXChangePath1, defaultDODImageXChangePath1, false,
				defaultDODImageHost, defaultDODImagePort, defaultMIXProtocol);
		addSiteConfiguration(site);
	}
	
	private void addSiteConfiguration(MIXSiteConfiguration site)
	{
		this.configurations.add(site);
	}

	public MIXSiteConfiguration getSiteConfiguration(String preferredSiteNumber, String alternateSiteNumber)
	throws MIXConfigurationException
	{
        logger.debug("Searching for MIX data source site configuration [{}]", preferredSiteNumber);
		for(int i = 0; i < configurations.size(); i++)
		{
			MIXSiteConfiguration site = configurations.get(i);
			if((site != null) && (site.equals(preferredSiteNumber)))
			{
                logger.debug("Found MIX data source site configuration [{}]", preferredSiteNumber);
				return site;
			}
		}
        logger.warn("Unable to find preferred site [{}] in MIX configuration", preferredSiteNumber);
		if((alternateSiteNumber != null) && (alternateSiteNumber.length() > 0))
		{
            logger.debug("Searching for MIX data source site configuration with alternative site [{}]", alternateSiteNumber);
			for(int i = 0; i < configurations.size(); i++)
			{
				MIXSiteConfiguration site = configurations.get(i);
				if((site != null) && (site.equals(alternateSiteNumber)))
				{
                    logger.debug("Found MIX data source site configuration for alternate site [{}]", alternateSiteNumber);
					return site;
				}
			}
		}
		String msg = "Unable to find preferred site [" + preferredSiteNumber + "]";
		if((alternateSiteNumber != null) && (alternateSiteNumber.length() > 0))
			msg += " or alternate site number [" + alternateSiteNumber + "]";
		msg += " in MIX configuration";
		throw new MIXConfigurationException(msg);
	}

	/**
	 * return an unmodifiable List of configurations
	 * @return
	 */
	public List<MIXSiteConfiguration> getConfigurations() 
	{
		return configurations;
	}

	public void setConfigurations(List<MIXSiteConfiguration> configurations) 
	{
		this.configurations = configurations;
	}

	public List<String> getEmptyStudyModalities()
	{
		return emptyStudyModalities;
	}

	public void setEmptyStudyModalities(List<String> emptyStudyModalities)
	{
		this.emptyStudyModalities = emptyStudyModalities;
	}

	public int getMetadataTimeout()
	{
		return metadataTimeout;
	}

	public void setMetadataTimeout(int metadataTimeout)
	{
		this.metadataTimeout = metadataTimeout;
	}
	
	public int getMetadataConcurentQueryTimeout()
	{
		return metadataConcurentQueryTimeout;
	}

	public void setMetadataConcurentQueryTimeout(int metadataCQTimeout)
	{
		this.metadataConcurentQueryTimeout = metadataCQTimeout;
	}
		
	public int getMaxConcurentThreads() {
		return maxConcurentThreads;
	}

	public void setMaxConcurentThreads(int maxConcurentThreads) {
		this.maxConcurentThreads = maxConcurentThreads;
	}

	/**
	 * @return the truststoreUrl
	 */
	public String getTruststoreUrl() 
	{
		//return getTlsConfiguration().getTruststoreUrl().toString();
		return truststoreUrl;
	}

	/**
	 * @param truststoreUrl the truststoreUrl to set
	 */
	public void setTruststoreUrl(String truststoreUrl) 
	//throws MalformedURLException 
	{
		//getTlsConfiguration().setTruststoreUrl(new URL(truststoreUrl));
		this.truststoreUrl = truststoreUrl;
	}

	/**
	 * @return the truststorePassword
	 */
	public String getTruststorePassword() 
	{
		//return getTlsConfiguration().getTruststorePassword();
		if(truststorePassword == null) return null;
		return truststorePassword.getValue();
	}

	/**
	 * @param truststorePassword the truststorePassword to set
	 */
	public void setTruststorePassword(EncryptedConfigurationPropertyString truststorePassword)
	{
		//getTlsConfiguration().setTruststorePassword(truststorePassword);
		this.truststorePassword = truststorePassword;
	}

	/**
	 * @return the keystoreUrl
	 */
	public String getKeystoreUrl() 
	{
		//return getTlsConfiguration().getKeystoreUrl().toString();
		return keystoreUrl;
	}

	/**
	 * @param keystoreUrl the keystoreUrl to set
	 */
	public void setKeystoreUrl(String keystoreUrl) 
	//throws MalformedURLException 
	{
		//getTlsConfiguration().setKeystoreUrl(new URL(keystoreUrl));
		this.keystoreUrl = keystoreUrl;
	}

	/**
	 * @return the keystorePassword
	 */
	public String getKeystorePassword() 
	{
		//return getTlsConfiguration().getKeystorePassword();
		if(keystorePassword == null) return null;
		return keystorePassword.getValue();
	}

	/**
	 * @param keystorePassword the keystorePassword to set
	 */
	public void setKeystorePassword(EncryptedConfigurationPropertyString keystorePassword)
	{
		//getTlsConfiguration().setKeystorePassword(keystorePassword);
		this.keystorePassword = keystorePassword;
	}
	
	public boolean useEcia() {
		if (sopBlacklists == null) {
			sopBlacklists = new HashMap<String, List<String>>();
			sopBlacklists.put(VIEWER_CLINICAL_DISPLAY, getSopBlacklistForClinicalDisplay());
			sopBlacklists.put(VIEWER_VISTA_RAD, getSopBlacklistForVistaRad());
			sopBlacklists.put(VIEWER_VIX, getSopBlacklistForVixViewer());
		}
	 
		return useEcia != null ? useEcia.booleanValue() : DEFAULT_USE_ECIA;
	}
	
	public void setUseEcia(Boolean useEcia) {
		this.useEcia = useEcia;
	}
	
	public List<String> getVistaRadModalityBlacklist() {
		return vistaRadModalityBlacklist;
	}

	public void setVistaRadModalityBlacklist(List<String> vistaRadModalityBlacklist) {
		this.vistaRadModalityBlacklist = vistaRadModalityBlacklist;
	}

	// SOP filter getter / setters
	public List<String> getSopBlacklistForClinicalDisplay() {
		return sopBlacklistForClinicalDisplay;
	}

	public void setSopBlacklistForClinicalDisplay(List<String> sopBlackListForClinicalDisplay) {
		this.sopBlacklistForClinicalDisplay = sopBlackListForClinicalDisplay;
	}

	public List<String> getSopBlacklistForVixViewer() {
		return sopBlacklistForVixViewer;
	}

	public void setSopBlacklistForVixViewer(List<String> sopBlacklistForVixViewer) {
		this.sopBlacklistForVixViewer = sopBlacklistForVixViewer;
	}

	public List<String> getSopBlacklistForVistaRad() {
		return sopBlacklistForVistaRad;
	}

	public void setSopBlacklistForVistaRad(List<String> sopBlacklistForVistaRad) {
		this.sopBlacklistForVistaRad = sopBlacklistForVistaRad;
	}

	@SuppressWarnings("unchecked")
	public List<String> getSOPBlacklistByName(String name) {
		List<String> blacklist = (sopBlacklists == null) ? (Collections.EMPTY_LIST) : (sopBlacklists.get(name));
		return (blacklist == null) ? (Collections.EMPTY_LIST) : (blacklist);
	}

	public String getImageTypeNotSupportedFile() {
		return imageTypeNotSupportedFile;
	}

	public void setImageTypeNotSupportedFile(String imageTypeNotSupportedFile) {
		this.imageTypeNotSupportedFile = imageTypeNotSupportedFile;
	}

	public void validateConfigurationEncryption(){

	}

	@Override
	public boolean hasValueChangesToPersist(boolean autoStoreChanges) {
		if(this.keystorePassword != null && this.keystorePassword.isUnencryptedAtRest()) return true;
		if(this.truststorePassword != null && this.truststorePassword.isUnencryptedAtRest()) return true;
		return false;
	}
}
