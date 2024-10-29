package gov.va.med.imaging.proxy.ssl;

import java.net.URL;

import javax.net.ssl.SSLContext;

public class AuthSSLRemoteHostMap 
{
	private Integer remoteHostPort; 
	private Integer timeout; 
	private URL keystoreUrl;
	private String keystorePassword;
	private URL truststoreUrl;
	private String truststorePassword;
	private SSLContext sslContext;
	
	public AuthSSLRemoteHostMap(
			Integer remoteHostPort, 
			URL keystoreUrl, 
			String keystorePassword, 
			URL truststoreUrl, 
			String truststorePassword,
			Integer timeout)
	{
		this.remoteHostPort = remoteHostPort; 
		this.keystoreUrl = keystoreUrl;
		this.keystorePassword = keystorePassword; 
		this.truststoreUrl = truststoreUrl; 
		this.truststorePassword = truststorePassword;
		this.timeout = timeout;
		this.sslContext = null;
	}
	
	public void setSslContext(SSLContext sslContext)
	{
		this.sslContext = sslContext;
	}
	
	public SSLContext getSslContext()
	{
		return sslContext;
	}
	
	public void setTimeout(Integer timeout)
	{
		this.timeout = timeout;
	}

	public Integer getTimeout()
	{
		return timeout;
	}

	public Integer getRemoteHostPort()
	{
		return remoteHostPort;
	}

	public URL getKeystoreUrl()
	{
		return keystoreUrl;
	}

	public String getKeystorePassword()
	{
		return keystorePassword;
	}

	public URL getTruststoreUrl()
	{
		return truststoreUrl;
	}

	public String getTruststorePassword()
	{
		return truststorePassword;
	}

}
