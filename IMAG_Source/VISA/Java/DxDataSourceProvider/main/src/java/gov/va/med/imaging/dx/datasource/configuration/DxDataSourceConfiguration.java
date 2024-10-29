/**
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 4, 2017
  Developer:  vhaisltjahjb
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.dx.datasource.configuration;

import gov.va.med.OID;
import gov.va.med.RoutingToken;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSourceImpl;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dx.datasource.DxDocumentSetDataSourceService;
import gov.va.med.imaging.dx.rest.endpoints.DxDesProxyAdapterRestUri;

import java.io.Serializable;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;

import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;
import gov.va.med.imaging.configuration.DetectConfigNonTransientValueChanges;
import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 *
 */
public class DxDataSourceConfiguration
implements Serializable, DetectConfigNonTransientValueChanges
{
	private static final long serialVersionUID = -7814886817785999850L;
	private static final Logger LOGGER = Logger.getLogger(DxDataSourceConfiguration.class);
	
	public final static String defaultKeystoreAlias = "vixfederation";
	public final static String defaultKeystoreUrl = "file:///c:/VixCertStore/federation.keystore";
	public final static String defaultTruststoreUrl = "file:///c:/VixCertStore/federation.truststore";
	public final static String defaultTLSProtocol = "dxs";
	public final static int defaultTLSPort = 443;
	
	public final static int defaultQueryTimeout = 50000;
	public final static int defaultRetrieveTimeout = 120000;
	public final static int defaultDelayPeriod = 2000;

	public final static String defaultDasProtocol = "dxs";
	public final static String defaultDasHost = "das-test.va.gov"; //For testing purposes
	public final static int defaultDasPort = -1;
	public final static String defaultRequestSource = "VADAS";
	public final static String defaultLoinc = "34794-8";
	public final static String defaultProvider = "123";
	public final static String defaultDesHomeCommunityId = "2.16.840.1.113883.3.42.10001.100001.1000";
	public final static String defaultAccessibleIpAddress = "127.0.0.1";
	
	private SortedSet<DxSiteConfiguration> artifactSourceConfigurations = 
			new TreeSet<DxSiteConfiguration>(new DxSiteConfigurationComparator()); 
	private boolean useCertificate = false;
	
	private Integer queryTimeout;
	private Integer retrieveTimeout;
	private String desService;
	private String desVersion;
	private String desServiceVersion;
	private String desRequestSource;
	private String desLoinc;
	private String desProvider;
	private String desHomeCommunityId;
	
	private Integer delayPeriod;

	private String dasProtocol;
	private String dasHost;
	private int dasPort;

	private Boolean allowPartialSuccess;
	private String keystoreAlias;
	private String keystoreUrl;
	private EncryptedConfigurationPropertyString keystorePassword;
	private String truststoreUrl;
	private EncryptedConfigurationPropertyString truststorePassword;
	private String tlsProtocol;
	private int tlsPort;
	private String accessibleIpAddress;
	private EncryptedConfigurationPropertyString alexdelargePassword;

	
	/**
	 * Create a configuration with the minimum default values
	 * @return
	 * @throws MalformedURLException
	 */
	public static DxDataSourceConfiguration create()
	throws MalformedURLException 
	{
		return new DxDataSourceConfiguration(
			null, null, null, null, null, 443, defaultKeystoreAlias, true, 
			defaultQueryTimeout, 
			defaultRetrieveTimeout, 
			DxDesProxyAdapterRestUri.dxServicePath,
			DxDataSourceProxyConfiguration.DEFAULT_DES_VERSION,
			DxDataSourceProxyConfiguration.DEFAULT_DES_SERVICE_VERSION,
			defaultDelayPeriod,
			defaultDasProtocol,
			defaultDasHost,
			defaultDasPort,
			defaultRequestSource,
			defaultLoinc,
			defaultProvider,
			defaultDesHomeCommunityId,
			defaultAccessibleIpAddress,
			null
		);
	}
	
	public static DxDataSourceConfiguration create(
		String keystorePassword, String truststorePassword)
	throws MalformedURLException 
	{
		return DxDataSourceConfiguration.create(
			defaultKeystoreUrl, 
			keystorePassword, 
			defaultTruststoreUrl, 
			truststorePassword);
	}
	
	public static DxDataSourceConfiguration create(
		String keystoreUrl, 
		String keystorePassword, 
		String truststoreUrl, 
		String truststorePassword)
	throws MalformedURLException 
	{
		return DxDataSourceConfiguration.create(
			keystoreUrl, 
			keystorePassword, 
			truststoreUrl, 
			truststorePassword, 
			defaultTLSProtocol,
			defaultTLSPort,
			defaultKeystoreAlias,
			DxDataSourceProxyConfiguration.DEFAULT_ALLOWPARTIALSUCCESS.booleanValue());
	}
	
	public static DxDataSourceConfiguration create(
		String keystoreUrl, 
		String keystorePassword, 
		String truststoreUrl, 
		String truststorePassword, 
		String tlsProtocol,
		int tlsPort,
		String keystoreAlias,
		boolean allowPartialSuccess)
	throws MalformedURLException 
	{
		if(keystoreUrl == null)
			keystoreUrl = defaultKeystoreUrl;
		if(truststoreUrl == null)
			truststoreUrl = defaultTruststoreUrl;
		if(tlsProtocol == null)
			tlsProtocol = defaultTLSProtocol;
		if(tlsPort <= 0)
			tlsPort = defaultTLSPort;
		
		return new DxDataSourceConfiguration(
			keystoreUrl, 
			keystorePassword, 
			truststoreUrl, 
			truststorePassword, 
			tlsProtocol,
			tlsPort, 
			keystoreAlias,
			allowPartialSuccess,
			defaultQueryTimeout, 
			defaultRetrieveTimeout,
			DxDesProxyAdapterRestUri.dxServicePath,
			DxDataSourceProxyConfiguration.DEFAULT_DES_VERSION,
			DxDataSourceProxyConfiguration.DEFAULT_DES_SERVICE_VERSION,
			defaultDelayPeriod,
			defaultDasProtocol,
			defaultDasHost,
			defaultDasPort,
			defaultRequestSource,
			defaultLoinc,
			defaultProvider,
			defaultDesHomeCommunityId,
			defaultAccessibleIpAddress,
			null
		);
	}

	public static DxDataSourceConfiguration create(
		String keystoreUrl,
		String keystorePassword, 
		String truststoreUrl, 
		String truststorePassword, 
		String tlsProtocol,
		int tlsPort,
		String keystoreAlias,
		boolean allowPartialSuccess,
		int queryTimeout,
		int retrieveTimeout,
		String desService,
		String desVersion,
		String desServiceVersion,
		int delayPeriod,
		String dasProtocol,
		String dasHost,
		int dasPort,
		String desRequestSource,
		String desLoinc,
		String desProvider,
		String desHomeCommunityId,
		String accessibleIpAddress,
		String alexdelargePassword
	)
	throws MalformedURLException 
	{
		return new DxDataSourceConfiguration(
				keystoreUrl,
				keystorePassword, 
				truststoreUrl, 
				truststorePassword, 
				tlsProtocol,
				tlsPort,
				keystoreAlias,
				allowPartialSuccess,
				queryTimeout,
				retrieveTimeout,
				desService,
				desVersion,
				desServiceVersion,
				delayPeriod,
				dasProtocol,
				dasHost,
				dasPort,
				desRequestSource,
				desLoinc,
				desProvider,
				desHomeCommunityId,
				accessibleIpAddress,
				alexdelargePassword
				);
	}

	// ====================================================================================
	
	/**
	 * @return the logger
	 */
	protected synchronized Logger getLogger()
	{
		return LOGGER;
	}

	/**
	 * 
	 * @param truststoreUrl
	 * @param keystoreUrl
	 * @param keystorePassword
	 * @param truststorePassword
	 * @param tlsProtocol
	 * @throws MalformedURLException 
	 */
	private DxDataSourceConfiguration(
		String keystoreUrl,
		String keystorePassword, 
		String truststoreUrl, 
		String truststorePassword, 
		String tlsProtocol,
		int tlsPort,
		String keystoreAlias,
		boolean allowPartialSuccess,
		int queryTimeout,
		int retrieveTimeout,
		String desService,
		String desVersion,
		String desServiceVersion,
		int delayPeriod,
		String dasProtocol,
		String dasHost,
		int dasPort,
		String desRequestSource,
		String desLoinc,
		String desProvider,
		String desHomeCommunityId,
		String accessibleIpAddress,
		String alexdelargePassword
		) 
	throws MalformedURLException 
	{
		super();
		
		this.keystoreUrl =  keystoreUrl;
		this.keystorePassword = new EncryptedConfigurationPropertyString(keystorePassword);
		this.truststoreUrl = truststoreUrl;
		this.truststorePassword = new EncryptedConfigurationPropertyString(truststorePassword);
		this.tlsProtocol = tlsProtocol;
		this.tlsPort = tlsPort;
		this.keystoreAlias = keystoreAlias;
		this.allowPartialSuccess = new Boolean(allowPartialSuccess);

		this.queryTimeout = queryTimeout;
		this.retrieveTimeout = retrieveTimeout;
		this.desService = desService;
		this.desVersion = desVersion;
		this.desServiceVersion = desServiceVersion;
		this.delayPeriod = delayPeriod;
		this.dasProtocol = dasProtocol;
		this.dasHost = dasHost;
		this.dasPort = dasPort;
		this.desRequestSource = desRequestSource;
		this.desLoinc = desLoinc;
		this.desProvider = desProvider;
		this.desHomeCommunityId = desHomeCommunityId;
		this.accessibleIpAddress = accessibleIpAddress;
		this.alexdelargePassword = new EncryptedConfigurationPropertyString(alexdelargePassword);
	}
	

	public void setAccessibleIpAddress(String ipAddress) {
		this.accessibleIpAddress = ipAddress;
	}

	public String getAccessibleIpAddress() {
		return accessibleIpAddress;
	}

	/**
	 * @return the allowPartialSuccess
	 */
	public Boolean isAllowPartialSuccess()
	{
		return this.allowPartialSuccess;
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
	 * @throws MalformedURLException 
	 */
	public void setTruststoreUrl(String truststoreUrl)  
	{
		this.truststoreUrl = truststoreUrl;
	}

	/**
	 * @return the keystoreUrl
	 */
	public String getKeystoreUrl() 
	{
		return keystoreUrl;
	}

	/**
	 * @param keystoreUrl the keystoreUrl to set
	 * @throws MalformedURLException 
	 */
	public void setKeystoreUrl(String keystoreUrl) 
	{
		this.keystoreUrl = keystoreUrl;
	}

	/**
	 * @return the keystorePassword
	 */
	public String getKeystorePassword() 
	{
		return keystorePassword.getValue();
	}

	/**
	 * @param keystorePassword the keystorePassword to set
	 */
	public void setKeystorePassword(EncryptedConfigurationPropertyString keystorePassword)
	{
		this.keystorePassword = keystorePassword;
	}

	/**
	 * The alias of the certificate to use as the credentials.
	 */
	public String getKeystoreAlias()
	{
		return keystoreAlias;
		//return getTlsConfiguration().getAlias();
	}
	
	public void setKeystoreAlias(String alias)
	{
		this.keystoreAlias = alias;
	}
	
	/**
	 * @return the truststorePassword
	 */
	public String getTruststorePassword()
	{
		return truststorePassword.getValue();
	}

	/**
	 * @param truststorePassword the truststorePassword to set
	 */
	public void setTruststorePassword(EncryptedConfigurationPropertyString truststorePassword)
	{
		this.truststorePassword = truststorePassword;
	}

	/**
	 * @return the useCertificate
	 */
	public boolean isUseCertificate() 
	{
		return useCertificate;
	}

	/**
	 * @param useCertificate the useCertificate to set
	 */
	public void setUseCertificate(boolean useCertificate) 
	{
		this.useCertificate = useCertificate;
	}
	
	public Integer getQueryTimeout()
	{
		return queryTimeout;
	}

	public void setQueryTimeout(Integer queryTimeout)
	{
		this.queryTimeout = queryTimeout;
	}

	public Integer getRetrieveTimeout()
	{
		return retrieveTimeout;
	}

	public void setRetrieveTimeout(Integer retrieveTimeout)
	{
		this.retrieveTimeout = retrieveTimeout;
	}

	/**
	 * @return the tlsProtocol
	 */
	public String getTLSProtocol()
	{
		return tlsProtocol;
	}

	/**
	 * @return the tlsPort
	 */
	public int getTLSPort()
	{
		return tlsPort;
	}

	/**
	 * @param protocol the tlsProtocol to set
	 */
	public void setTLSProtocol(String protocol)
	{
		//getTlsConfiguration().setProtocol(protocol);
		this.tlsProtocol = protocol;
	}

	/**
	 * @param port the tlsPort to set
	 */
	public void setTLSPort(int port)
	{
		this.tlsPort = port;
	}
	
	/**
	 * @return the desVersion
	 */
	public String getDesVersion() 
	{
		return this.desVersion;
	}

	/**
	 * @param desVersion the desVersion to set
	 */
	public void setDesVersion(String desVersion) 
	{
		this.desVersion = desVersion;
	}

	/**
	 * @return the desVersion
	 */
	public String getDesServiceVersion() 
	{
		return this.desServiceVersion;
	}

	/**
	 * @param desServiceVersion the desServiceVersion to set
	 */
	public void setDesServiceVersion(String desServiceVersion) 
	{
		this.desServiceVersion = desServiceVersion;
	}

	/**
	 * @return the desRequestSource
	 */
	public String getDesRequestSource() 
	{
		return this.desRequestSource;
	}

	/**
	 * @param desRequestSource the desRequestSource to set
	 */
	public void setDesRequestSource(String desRequestSource) 
	{
		this.desRequestSource = desRequestSource;
	}
	
	/**
	 * @return the desLoinc
	 */
	public String getDesLoinc() 
	{
		return this.desLoinc;
	}

	/**
	 * @param desLoinc the desLoinc to set
	 */
	public void setDesLoinc(String desLoinc) 
	{
		this.desLoinc = desLoinc;
	}
	
	/**
	 * @return the desProvider
	 */
	public String getDesProvider() 
	{
		return this.desProvider;
	}

	/**
	 * @param desProvider the desProvider to set
	 */
	public void setDesProvider(String desProvider) 
	{
		this.desProvider = desProvider;
	}
	
	/**
	 * @return the delayPeriod
	 */
	public Integer getDelayPeriod()
	{
		return delayPeriod;
	}

	/**
	 * @param delayPeriod the delayPeriod to set
	 */
	public void setDelayPeriod(Integer delayPeriod)
	{
		this.delayPeriod = delayPeriod;
	}

	/**
	 * @return the dasProtocol
	 */
	public String getDasProtocol() 
	{
		return this.dasProtocol;
	}

	/**
	 * @param dasProtocol the dasProtocol to set
	 */
	public void setDasProtocol(String dasProtocol) 
	{
		this.dasProtocol = dasProtocol;
	}
	
	/**
	 * @return the dasHost
	 */
	public String getDasHost() 
	{
		return this.dasHost;
	}

	/**
	 * @param dasHost the dasHost to set
	 */
	public void setDasHost(String dasHost) 
	{
		this.dasHost = dasHost;
	}

	/**
	 * @return the dasPort
	 */
	public int getDasPort() 
	{
		return this.dasPort;
	}

	/**
	 * @param dasPort the dasPort to set
	 */
	public void setDasPort(int dasPort) 
	{
		this.dasPort = dasPort;
	}

	/**
	 * @return the desService
	 */
	public String getDesService() {
		return this.desService;
	}
	
	/**
	 * @param desService the desService to set
	 */
	public void setDesService(String desService) 
	{
		this.desService = desService;
	}
	

	/**
	 * @return the desHomeCommunityId
	 */
	public String getDesHomeCommunityId() 
	{
		return this.desHomeCommunityId;
	}

	/**
	 * @param desHomeCommunityId the desHomeCommunityId to set
	 */
	public void getDesHomeCommunityId(String desHomeCommunityId) 
	{
		this.desHomeCommunityId = desHomeCommunityId;
	}

	/**
	 * 
	 */
	public void clear()
	{
		artifactSourceConfigurations.clear();
	}

	/**
	 * @return the alextdelargePassword
	 */
	public String getAlextdelargePassword() 
	{
		return alexdelargePassword.getValue();
	}

	/**
	 * @param alexdelargePassword the alexdelargePassword to set
	 */
	public void setAlextdelargePassword(EncryptedConfigurationPropertyString alexdelargePassword)
	{
		this.alexdelargePassword = alexdelargePassword;
	}
	
	// =============================================================================
	/**
	 *
	 * @param resolvedArtifactSource
	 * @return
	 * @throws MethodException
	 */
	public DxSiteConfiguration findSiteConfiguration(ResolvedArtifactSource resolvedArtifactSource)
	throws MethodException
	{
		if(resolvedArtifactSource == null || resolvedArtifactSource.getArtifactSource() == null)
		{
			LOGGER.warn("DxDataSourceConfiguration.findSiteConfiguration() --> Either resolvedArtifactSource or resolvedArtifactSource.getArtifactSource() are null. Return null.");
			return null;
		}
		
		OID homeCommunityId = resolvedArtifactSource.getArtifactSource().getHomeCommunityId();
		String repositoryId = resolvedArtifactSource.getArtifactSource().getRepositoryId();
		
		DxSiteConfiguration siteConfiguration;
		try
		{
			siteConfiguration = get(homeCommunityId, repositoryId);
			if(siteConfiguration == null)
			{
                LOGGER.warn("DxDataSourceConfiguration.findSiteConfiguration() --> Could not find DX gateway site configuration for artifact source [{}]. Return null.", resolvedArtifactSource.toString());
				return null;
			}
			
			return siteConfiguration;
		}
		catch (RoutingTokenFormatException x)
		{
			throw new MethodException("DxDataSourceConfiguration.findSiteConfiguration() --> Exception thrown while finding site configuration for [" + resolvedArtifactSource.toString() + "]: " + x.toString());
		}
	}
	
	/**
	 * Replaces the URL with the specified protocol with a URL formed from the
	 * path.  The resulting ResolvedArtifactSource will have only one query and
	 * one retrieve URL, which will be the ones to use for DX.  Any component
	 * of the URL may be changed by the URLComponentMerger.
	 * 
	 * @param resolvedArtifactSource
	 * @param siteConfiguration
	 * @return
	 * @throws MethodException 
	 * @throws MalformedURLException 
	 */
	public ResolvedArtifactSource fixupURLPaths(
		ResolvedArtifactSource resolvedArtifactSource,
		DxSiteConfiguration siteConfiguration) throws MethodException 
	{
		if(siteConfiguration == null)
			return resolvedArtifactSource;
		
		List<URL> fixedUpQueryUrls = new ArrayList<URL>();
		for( URL metadataUrl : resolvedArtifactSource.getMetadataUrls() )
			if( DxDocumentSetDataSourceService.SUPPORTED_PROTOCOL.equals(metadataUrl.getProtocol()) )
			{
				URL fixedUpUrl = null;
				try {
					fixedUpUrl = siteConfiguration.getQueryComponentMerger().merge(metadataUrl);
				} catch (MalformedURLException e) {
					throw new MethodException("DxDataSourceConfiguration.fixupURLPaths() --> Fixing query URL [" + metadataUrl.toString() + "] encountered MalformedURLException: " + e.getMessage());
				}
				fixedUpQueryUrls.add(fixedUpUrl); 
			}
		
		List<URL> fixedUpRetrieveUrls = new ArrayList<URL>();
		for( URL retrieveUrl : resolvedArtifactSource.getArtifactUrls() )
			if( DxDocumentSetDataSourceService.SUPPORTED_PROTOCOL.equals(retrieveUrl.getProtocol()) )
			{
				URL fixedUpUrl = null;
				try {
					fixedUpUrl = siteConfiguration.getRetrieveComponentMerger().merge(retrieveUrl);
				} catch (MalformedURLException e) {
					throw new MethodException("DxDataSourceConfiguration.fixupURLPaths() --> Fixing retrieve URL [" +  retrieveUrl.toString() + "] encountered MalformedURLException: " + e.getMessage());
				}
				fixedUpRetrieveUrls.add(fixedUpUrl); 
			}
		
		ResolvedArtifactSourceImpl result = ResolvedArtifactSourceImpl.create(
			resolvedArtifactSource.getArtifactSource(), fixedUpQueryUrls, fixedUpRetrieveUrls
		);
		
		return result;
	}
	
	/**
	 * @param siteConfiguration
	 */
	public void add(DxSiteConfiguration siteConfiguration)
	{
		synchronized(artifactSourceConfigurations)
		{
			artifactSourceConfigurations.add(siteConfiguration);
		}
	}
	
	/**
	 * 
	 * @param homeCommunityId
	 * @param repositoryId
	 * @return
	 * @throws RoutingTokenFormatException 
	 */
	public DxSiteConfiguration get(OID homeCommunityId, String repositoryId) 
	throws RoutingTokenFormatException
	{
		if(homeCommunityId == null || repositoryId == null)
			return null;
		
		return get(RoutingTokenImpl.create(homeCommunityId, repositoryId));
	}
	
	public DxSiteConfiguration get(RoutingToken target) 
	throws RoutingTokenFormatException
	{
		synchronized(artifactSourceConfigurations)
		{
			for(DxSiteConfiguration siteConfig : artifactSourceConfigurations)
				if( target.equals(siteConfig.getRoutingToken()) )
					return siteConfig;
		}
		return null;
	}
	
	/**
	 * 
	 * @param homeCommunityId
	 * @param repositoryId
	 * @throws RoutingTokenFormatException 
	 */
	public void remove(OID homeCommunityId, String repositoryId) 
	throws RoutingTokenFormatException
	{
		if(homeCommunityId == null || repositoryId == null)
			return;
		remove(RoutingTokenImpl.create(homeCommunityId, repositoryId));
	}
	
	public void remove(RoutingToken target) 
	throws RoutingTokenFormatException
	{	
		synchronized(artifactSourceConfigurations)
		{
			DxSiteConfiguration siteToRemove = get(target);
			
			if(siteToRemove != null)
				artifactSourceConfigurations.remove(siteToRemove);
		}
	}
	
	/**
	 * 
	 */
	@Override
	public String toString()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append("BEGIN " + this.getClass().getName() + " \n");
		for(DxSiteConfiguration site : artifactSourceConfigurations)
		{
			sb.append('\t');
			sb.append(site.toString());
			sb.append('\n');
		}
		sb.append("END " + this.getClass().getName() + " \n");
		
		return sb.toString();
	}


	@Override
	public boolean hasValueChangesToPersist(boolean autoStoreChanges) {
		if(this.alexdelargePassword != null && this.alexdelargePassword.isUnencryptedAtRest()) return true;
		if(this.keystorePassword != null && this.keystorePassword.isUnencryptedAtRest()) return true;
		if(this.truststorePassword != null && this.truststorePassword.isUnencryptedAtRest()) return true;
		return false;
	}
}
