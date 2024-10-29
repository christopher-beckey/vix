package gov.va.med.imaging.url.mix.configuration;

import gov.va.med.imaging.url.vista.StringUtils;

public class MIXSiteConfiguration 
{
	private final static long serialVersionUID = 1L;

	private String password;
	private String username;
	private String siteNumber;
	private String mixApplication;
	private String metadataPath1;
	private String metadataPath2;
	private String imagePath1;
	private String imagePath2;
	private boolean useVersioning;
	private String host;
	private int port;
	private String protocol;
	
	public MIXSiteConfiguration()
	{
		super();
		password = null;
		username = siteNumber = mixApplication = metadataPath1 = imagePath1 = metadataPath2 = imagePath2 = protocol = "";
		host = "";
		port = 0;
		useVersioning = false;
	}
	
	public MIXSiteConfiguration(String siteNumber, String username, String password,
			String mixApplication, String metadataPath1, String metadataPath2, String imagePath1, String imagePath2, boolean useVersioning,
			String host, int port, String protocol) {
		super();
		this.password = StringUtils.cleanString(password);
		this.username = username;
		this.siteNumber = siteNumber;
		this.mixApplication = mixApplication;
		this.metadataPath1 = metadataPath1;
		this.metadataPath2 = metadataPath2;
		this.imagePath1 = imagePath1;	
		this.imagePath2 = imagePath2;	
		this.useVersioning = useVersioning;
		this.host = host;
		this.port = port;
		this.setProtocol(protocol);
	}

	public String getPassword() {
		return StringUtils.cleanString(password);
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getSiteNumber() {
		return siteNumber;
	}

	public void setSiteNumber(String siteNumber) {
		this.siteNumber = siteNumber;
	}
	
	public String getMixApplication() {
		return mixApplication;
	}

	public void setMixApplication(String changeApplication) {
		mixApplication = changeApplication;
	}

	/* Use renamed method above for Java bean consistency
	public void setXChangeApplication(String changeApplication) {
		mixApplication = changeApplication;
	}
	 */
	public String getMetadataPath1() {
		return metadataPath1;
	}

	public void setMetadataPath1(String metadataPath) {
		this.metadataPath1 = metadataPath;
	}

	public String getImagePath1() {
		return imagePath1;
	}

	public void setImagePath1(String imagePath) {
		this.imagePath1 = imagePath;
	}
	public String getMetadataPath2() {
		return metadataPath2;
	}

	public void setMetadataPath2(String metadataPath) {
		this.metadataPath2 = metadataPath;
	}

	// Fixed to return path2 instead of path1
	public String getImagePath2() {
		return imagePath2;
	}

	public void setImagePath2(String imagePath) {
		this.imagePath2 = imagePath;
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

	public String getProtocol() {
		return protocol;
	}

	public void setProtocol(String protocol) {
		this.protocol = protocol;
	}

	@Override
	public String toString() {
		// Regenerated to hide username and password (security concern) and to display better values
		return "MIXSiteConfiguration [siteNumber=" + siteNumber + ", mixApplication=" + mixApplication + ", host="
				+ host + ", port=" + port + ", protocol=" + protocol + "]";
	}
	
	/*
	@Override
	public String toString() {
		return "Site [" + siteNumber + "]  Username [" + username + "] Password [" + password + "]";
	}
	 */
	
	@Override
	public boolean equals(Object obj) {
		
		if(obj.getClass() == MIXSiteConfiguration.class)
		{
			MIXSiteConfiguration e = (MIXSiteConfiguration)obj;
			return e.siteNumber.equals(this.siteNumber);
		}
		else if(obj.getClass() == String.class)
		{
			return this.siteNumber.equals(obj.toString());
		}
		return false;
	}
}
