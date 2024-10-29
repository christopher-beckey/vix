package gov.va.med.imaging.url.exchange.configuration;

import java.io.Serializable;

import gov.va.med.imaging.configuration.DetectConfigNonTransientValueChanges;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;

public class ExchangeSiteConfiguration
implements Serializable, DetectConfigNonTransientValueChanges
{
	private final static long serialVersionUID = 1L;

	private EncryptedConfigurationPropertyString password;
	private EncryptedConfigurationPropertyString username;
	private String siteNumber;
	private String xChangeApplication;
	private String metadataPath;
	private String imagePath;
	private boolean useVersioning;
	private String host;
	private int port;
	
	public ExchangeSiteConfiguration()
	{
		super();
		password = null;
		username = new EncryptedConfigurationPropertyString("");
		siteNumber = xChangeApplication = metadataPath = imagePath = "";
		host = "";
		port = 0;
		useVersioning = false;
	}
	
	public ExchangeSiteConfiguration(String siteNumber, String username, String password,
			String xchangeApplication, String metadataPath, String imagePath, boolean useVersioning,
			String host, int port) {
		super();
		this.password = new EncryptedConfigurationPropertyString(StringUtils.cleanString(password));
		this.username = new EncryptedConfigurationPropertyString(username);
		this.siteNumber = siteNumber;
		xChangeApplication = xchangeApplication;
		this.metadataPath = metadataPath;
		this.imagePath = imagePath;	
		this.useVersioning = useVersioning;
		this.host = host;
		this.port = port;
	}

	public String getPassword() {
		if(password == null) return null;
		return StringUtils.cleanString(password.getValue());
	}

	public void setPassword(EncryptedConfigurationPropertyString password) {
		this.password = password;
	}

	public String getUsername() {
		if(username == null) return null;
		return username.getValue();
	}

	public void setUsername(EncryptedConfigurationPropertyString username) {
		this.username = username;
	}

	public String getSiteNumber() {
		return siteNumber;
	}

	public void setSiteNumber(String siteNumber) {
		this.siteNumber = siteNumber;
	}
	
	public String getXChangeApplication() {
		return xChangeApplication;
	}

	public void setXChangeApplication(String changeApplication) {
		xChangeApplication = changeApplication;
	}

	public String getMetadataPath() {
		return metadataPath;
	}

	public void setMetadataPath(String metadataPath) {
		this.metadataPath = metadataPath;
	}

	public String getImagePath() {
		return imagePath;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public boolean isUseVersioning() {
		return useVersioning;
	}

	public void setUseVersioning(boolean useVersioning) {
		this.useVersioning = useVersioning;
	}
	
	public boolean getUseVersioning()
	{
		return this.useVersioning;
	}

	/**
	 * Optional value if the host is not the default value from the Site object
	 * @return the host
	 */
	public String getHost() {
		return host;
	}

	/**
	 * @param host the host to set
	 */
	public void setHost(String host) {
		this.host = host;
	}

	/**
	 * Optional value if the port is not the default value from the Site object
	 * @return the port
	 */
	public int getPort() {
		return port;
	}
	
	public boolean containsHostAndPort()
	{
		if(port <= 0)
			return false;		
		if((host != null) && (host.length() > 0))
			return true;
		return false;
	}

	/**
	 * @param port the port to set
	 */
	public void setPort(int port) {
		this.port = port;
	}

	@Override
	public String toString() {
		return "Site [" + siteNumber + "]  Username [" + username + "]";
	}

	@Override
	public boolean equals(Object obj) {
		
		if(obj.getClass() == ExchangeSiteConfiguration.class)
		{
			ExchangeSiteConfiguration e = (ExchangeSiteConfiguration)obj;
			return e.siteNumber.equals(this.siteNumber);
		}
		else if(obj.getClass() == String.class)
		{
			return this.siteNumber.equals(obj.toString());
		}
		return false;
	}

	public boolean hasValueChangesToPersist(boolean autoStoreChanges) {
		if(this.username != null && this.username.isUnencryptedAtRest()) return true;
		if(this.password != null && this.password.isUnencryptedAtRest()) return true;
		return false;
	}

	public void storeValueChanges() {
		//not implemented as this class is naive to its storage condition
	}
}
