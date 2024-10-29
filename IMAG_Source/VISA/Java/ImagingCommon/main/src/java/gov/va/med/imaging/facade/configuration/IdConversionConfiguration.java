package gov.va.med.imaging.facade.configuration;

import gov.va.med.imaging.configuration.DetectConfigNonTransientValueChanges;
import gov.va.med.imaging.configuration.RefreshableConfig;
import gov.va.med.imaging.configuration.VixConfiguration;
import gov.va.med.imaging.facade.configuration.exceptions.CannotLoadConfigurationException;
import gov.va.med.logging.Logger;

/**
 * Class to be loaded from IdConversionConfiguration file.
 * Also, holds default values.
 * 
 * Quoc reworked.
 * 
 * @author Sonny Jiang
 * 
 */
public class IdConversionConfiguration
		extends AbstractBaseFacadeConfiguration
		implements DetectConfigNonTransientValueChanges, RefreshableConfig
{	
	public static final String DEF_PROTOCOL = "https";
	public static final String DEF_HOST = "bhietestsapp1.vaco.va.gov";
	public static final Integer DEF_PORT = 7010;
	public static final String DEF_URL_RESOURCE = "/lvsfhirapi/v1/Patient?_query{queryMethod}{ampersandSign}identifier";

    private String protocol;
	private String host;
	private Integer port;
	private String urlResource;
	private EncryptedConfigurationPropertyString username;
	private EncryptedConfigurationPropertyString password;
	private String keyStoreFilePath;
	private EncryptedConfigurationPropertyString keyStorePassword;
	private String trustStoreFilePath;
	private EncryptedConfigurationPropertyString trustStorePassword;

    public String getProtocol() {
		return protocol;
	}
	
	public void setProtocol(String configProtocol) {
		this.protocol = configProtocol;
	}

    public String getHost() {
		return host;
	}
	
	public void setHost(String configHost) {
		this.host = configHost;
	}

	public Integer getPort() {
		return port;
	}

	public void setPort(Integer configPort) {
		this.port = configPort;
	}

    public String getUrlResource() {
		return urlResource;
	}
	
	public void setUrlResource(String configUrlResource) {
		this.urlResource = configUrlResource;
	}

	public String getUsername() {
		if(this.username == null) return null;
		return username.getValue();
	}

	public void setUsername(EncryptedConfigurationPropertyString username) {
		this.username = username;
	}

	public String getPassword() {
		if(this.password == null) return null;
		return password.getValue();
	}

	public void setPassword(EncryptedConfigurationPropertyString password) {
		this.password = password;
	}

	public String getKeyStoreFilePath() {
		return keyStoreFilePath;
	}

	public void setKeyStoreFilePath(String keyStoreFilePath) {
		this.keyStoreFilePath = keyStoreFilePath;
	}

	public String getKeyStorePassword() {
		if(keyStorePassword == null) return null;
		return keyStorePassword.getValue();
	}

	public void setKeyStorePassword(EncryptedConfigurationPropertyString keyStorePassword) {
		this.keyStorePassword = keyStorePassword;
	}

	public String getTrustStoreFilePath() {
		return trustStoreFilePath;
	}

	public void setTrustStoreFilePath(String trustStoreFilePath) {
		this.trustStoreFilePath = trustStoreFilePath;
	}

	public String getTrustStorePassword() {
		if(this.trustStorePassword == null) return null;
		return trustStorePassword.getValue();
	}

	public void setTrustStorePassword(EncryptedConfigurationPropertyString trustStorePassword) {
		this.trustStorePassword = trustStorePassword;
	}

	/**
	 * Load the configuration.
	 * Should this call getConfiguration() method?
	 */
    @Override
    public AbstractBaseFacadeConfiguration loadDefaultConfiguration()
    {
        return this;
    }

    /**
     * Get/load the configuration from file
     * 
     * @return IdConversionConfiguration the loaded configuration object.
     */
    public synchronized static IdConversionConfiguration getConfiguration() 
    {
    	try
    	{
    		return FacadeConfigurationFactory.getConfigurationFactory().getConfiguration(
    				IdConversionConfiguration.class);
    	}
    	catch(CannotLoadConfigurationException clcX)
    	{
    		return null;
    	}
    }

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((host == null) ? 0 : host.hashCode());
		result = prime * result + port;
		result = prime * result + ((protocol == null) ? 0 : protocol.hashCode());
		result = prime * result + ((urlResource == null) ? 0 : urlResource.hashCode());
		result = prime * result + ((username == null) ? 0 : username.hashCode());
		result = prime * result + ((password == null) ? 0 : password.hashCode());
		result = prime * result + ((trustStoreFilePath == null) ? 0 : trustStoreFilePath.hashCode());
		result = prime * result + ((trustStorePassword == null) ? 0 : trustStorePassword.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		IdConversionConfiguration other = (IdConversionConfiguration) obj;
		if (host == null) {
			if (other.host != null)
				return false;
		} else if (!host.equals(other.host))
			return false;
		if (port != other.port)
			return false;
		if (protocol == null) {
			if (other.protocol != null)
				return false;
		} else if (!protocol.equals(other.protocol))
			return false;
		if (urlResource == null) {
			if (other.urlResource != null)
				return false;
		} else if (!urlResource.equals(other.urlResource))
			return false;
		if (username == null) {
			if (other.username != null)
				return false;
		} else if (!username.equals(other.username))
			return false;
		if (password == null) {
			if (other.password != null)
				return false;
		} else if (!password.equals(other.password))
			return false;
		if (trustStoreFilePath == null) {
			if (other.trustStoreFilePath != null)
				return false;
		} else if (!trustStoreFilePath.equals(other.trustStoreFilePath))
			return false;
		if (trustStorePassword == null) {
			if (other.trustStorePassword != null)
				return false;
		} else if (!trustStorePassword.equals(other.trustStorePassword))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "IdConversionConfiguration [protocol=" + protocol + ", host=" + host + ", port=" + port
				+ ", urlResource=" + urlResource + "]";
	}

	@Override
	public boolean hasValueChangesToPersist(boolean autoStoreChanges) {
		boolean retVal = false;
		if(password != null) retVal = password.isUnencryptedAtRest();
		if(keyStorePassword != null) retVal = retVal || keyStorePassword.isUnencryptedAtRest();
		if(trustStorePassword != null) retVal = retVal || trustStorePassword.isUnencryptedAtRest();
		if(username != null) retVal = retVal || username.isUnencryptedAtRest();
		if(autoStoreChanges && retVal) {
			this.storeConfiguration();
		}
		return retVal;
	}

	@Override
	public VixConfiguration refreshFromFile() {
		try {
			return (IdConversionConfiguration) loadConfiguration();
		} catch (Exception clcX) {
            Logger.getLogger(IdConversionConfiguration.class).error("IdConversionConfiguration.refreshFromFile() --> Unable to load IdConversionConfiguration from file: {}", clcX.getMessage());
			return null;
		}
	}


/*
    public static void main(String[] args) {
        if (args.length != 2)
        {
            printUsage();
            return;
        }
        MviConfiguration defaultConfig = getConfiguration();
        defaultConfig.setLocalSiteNumber(args[0]);
		boolean notificationEnabled = Boolean.parseBoolean(args[1]);
		defaultConfig.setNotificationEnabled(notificationEnabled);
        defaultConfig.storeConfiguration();
    }

    private static void printUsage() {
        System.out.println("This program requires two arguments: local_site_number enable_notifications.");
        System.out.println("enable_notifications can be true or false.");
    }
*/
}
