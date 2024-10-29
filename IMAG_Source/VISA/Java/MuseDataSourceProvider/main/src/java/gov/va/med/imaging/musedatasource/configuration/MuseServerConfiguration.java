package gov.va.med.imaging.musedatasource.configuration;

import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;
import gov.va.med.imaging.configuration.DetectConfigNonTransientValueChanges;
import gov.va.med.imaging.muse.DefaultMuseValues;

import java.io.Serializable;
import java.util.Objects;

public class MuseServerConfiguration
implements Serializable, DetectConfigNonTransientValueChanges
{

	private static final long serialVersionUID = 1L;
	
	private int id;
	private String museSiteNumber;
	private String vaSiteNumber;
	private String host;
	private int port;
	private int metadataTimeoutMs;
	private EncryptedConfigurationPropertyString username;
	private EncryptedConfigurationPropertyString password;
	private String protocol;
	private boolean museDisabled;

	

	public MuseServerConfiguration() {
		super();
	}

	public static MuseServerConfiguration createDefaultConfiguration() {

		MuseServerConfiguration config = new MuseServerConfiguration();
		config.museSiteNumber = DefaultMuseValues.defaultSiteNumber;
		config.host = DefaultMuseValues.defaulthost;
		config.port = new Integer(DefaultMuseValues.defaultport);
		config.metadataTimeoutMs = 60000;
		config.setPassword(new EncryptedConfigurationPropertyString(DefaultMuseValues.defaultpassword));
		config.setUsername(new EncryptedConfigurationPropertyString(DefaultMuseValues.defaultusername));
		config.protocol = DefaultMuseValues.defaultProtocol;
		config.museDisabled = false;

		return config;
	}
	
	/**
	 * @return the alienSiteNumber
	 */
	public String getMuseSiteNumber() {
		return museSiteNumber;
	}

	/**
	 * @return the host
	 */
	public String getHost() {
		return host;
	}

	/**
	 * @return the port
	 */
	public int getPort() {
		return port;
	}

	/**
	 * @return the metadataTimeout
	 */
	public int getMetadataTimeoutMs() {
		return metadataTimeoutMs;
	}

	/**
	 * @return the username
	 */
	public String getUsername() {
		if(username == null) return null;
		return username.getValue();
	}

	/**
	 * @return the password
	 */
	public String getPassword() {
		if(password == null) return null;
		return password.getValue();
	}

	/**
	 * @param museSiteNumber the museSiteNumber to set
	 */
	public void setMuseSiteNumber(String museSiteNumber) {
		this.museSiteNumber = museSiteNumber;
	}


	/**
	 * @param host the host to set
	 */
	public void setHost(String host) {
		this.host = host;
	}


	/**
	 * @param port the port to set
	 */
	public void setPort(int port) {
		this.port = port;
	}


	/**
	 * @param metadataTimeoutMs the metadataTimeoutMs to set
	 */
	public void setMetadataTimeoutMs(int metadataTimeoutMs) {
		this.metadataTimeoutMs = metadataTimeoutMs;
	}


	/**
	 * @param username the username to set
	 */
	public void setUsername(EncryptedConfigurationPropertyString username) {
		this.username = username;
	}


	/**
	 * @param password the password to set
	 */
	public void setPassword(EncryptedConfigurationPropertyString password) {
		this.password = password;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;
		MuseServerConfiguration that = (MuseServerConfiguration) o;
		return id == that.id && port == that.port && metadataTimeoutMs == that.metadataTimeoutMs
				&& museDisabled == that.museDisabled && museSiteNumber.equals(that.museSiteNumber)
				&& vaSiteNumber.equals(that.vaSiteNumber) && host.equals(that.host)
				&& username.equals(that.username) && password.equals(that.password) && protocol.equals(that.protocol);
	}

	@Override
	public int hashCode() {
		return Objects.hash(id, museSiteNumber, vaSiteNumber, host, port, metadataTimeoutMs, username, password,
				protocol, museDisabled);
	}

	/**
	 * @return the museDisabled
	 */
	public boolean isMuseDisabled() {
		return museDisabled;
	}

	/**
	 * @param museDisabled the museDisabled to set
	 */
	public void setMuseDisabled(boolean museDisabled) {
		this.museDisabled = museDisabled;
	}

	/**
	 * @return the id
	 */
	public int getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(int id) {
		this.id = id;
	}

	/**
	 * @return the vaSiteNumber
	 */
	public String getVaSiteNumber() {
		return vaSiteNumber;
	}

	/**
	 * @param vaSiteNumber the vaSiteNumber to set
	 */
	public void setVaSiteNumber(String vaSiteNumber) {
		this.vaSiteNumber = vaSiteNumber;
	}

	public String getProtocol() {
		return protocol;
	}

	public void setProtocol(String protocol) {
		this.protocol = protocol;
	}

	@Override
	public boolean hasValueChangesToPersist(boolean autoStoreChanges) {
		if(password != null && password.isUnencryptedAtRest()) return true;
		if(username != null && username.isUnencryptedAtRest()) return true;
		return false;
	}
}
