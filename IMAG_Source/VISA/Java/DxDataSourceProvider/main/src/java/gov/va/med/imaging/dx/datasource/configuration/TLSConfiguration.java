/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * @date Jun 29, 2010
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author vhaiswbeckec
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */

package gov.va.med.imaging.dx.datasource.configuration;

import java.net.MalformedURLException;
import java.net.URL;

/**
 * @author vhaisltjahjb
 *
 */
public class TLSConfiguration
{
	public final static String DEFAULT_KEYSTORE = "file:///c:/VixConfig/dx.keystore";
	public final static String DEFAULT_TRUSTSTORE = "file:///c:/vixconfig/dx.truststore";
	public final static String DEFAULT_PROTOCOL = "https";
	public final static int DEFAULT_PORT = 8443;
	
	private URL truststoreUrl;
	private URL keystoreUrl;
	private String keystorePassword = null;
	private String truststorePassword = null;
	private String protocol = DEFAULT_PROTOCOL;
	private int port = DEFAULT_PORT;
	private String alias;

	public static TLSConfiguration create(
		String keystorePassword, String truststorePassword)
	throws MalformedURLException 
	{
		return TLSConfiguration.create(
			DEFAULT_KEYSTORE, 
			keystorePassword, 
			DEFAULT_TRUSTSTORE, 
			truststorePassword);
	}
	
	public static TLSConfiguration create(
		String keystoreUrl, 
		String keystorePassword, 
		String truststoreUrl, 
		String truststorePassword)
	throws MalformedURLException 
	{
		return TLSConfiguration.create(
			keystoreUrl, 
			keystorePassword, 
			truststoreUrl, 
			truststorePassword, 
			DEFAULT_PROTOCOL,
			DEFAULT_PORT);
	}
	
	public static TLSConfiguration create(
		String keystoreUrl, 
		String keystorePassword, 
		String truststoreUrl, 
		String truststorePassword, 
		String federationSslProtocol,
		int tlsPort)
	throws MalformedURLException 
	{
		if(keystoreUrl == null)
			keystoreUrl = DEFAULT_KEYSTORE;
		if(truststoreUrl == null)
			truststoreUrl = DEFAULT_TRUSTSTORE;
		if(federationSslProtocol == null)
			federationSslProtocol = DEFAULT_PROTOCOL;
		if(tlsPort <= 0)
			tlsPort = DEFAULT_PORT;
		
		return new TLSConfiguration(
			keystoreUrl, 
			keystorePassword, 
			truststoreUrl, 
			truststorePassword, 
			federationSslProtocol,
			tlsPort);
	}
	
	// ===================================================================================
	// Constructors
	// ===================================================================================
	
	public TLSConfiguration()
	{
		super();
	}
	
	private TLSConfiguration(
		String keystoreUrl,
		String keystorePassword, 
		String truststoreUrl, 
		String truststorePassword, 
		String tlsProtocol,
		int tlsPort) 
	throws MalformedURLException 
	{
		super();
		this.truststoreUrl = new URL(truststoreUrl);
		this.keystoreUrl = new URL(keystoreUrl);
		this.keystorePassword = keystorePassword;
		this.truststorePassword = truststorePassword;
		this.protocol = tlsProtocol;
		this.port = tlsPort;
	}

	// ===================================================================================
	// Accessors
	// ===================================================================================
	
	/**
	 * @return the truststoreUrl
	 */
	public URL getTruststoreUrl()
	{
		return this.truststoreUrl;
	}

	/**
	 * @return the keystoreUrl
	 */
	public URL getKeystoreUrl()
	{
		return this.keystoreUrl;
	}

	/**
	 * @return the keystorePassword
	 */
	public String getKeystorePassword()
	{
		return this.keystorePassword;
	}

	/**
	 * @return the truststorePassword
	 */
	public String getTruststorePassword()
	{
		return this.truststorePassword;
	}

	/**
	 * @return the protocol
	 */
	public String getProtocol()
	{
		return this.protocol;
	}

	/**
	 * @return the port
	 */
	public int getPort()
	{
		return this.port;
	}

	/**
	 * @param truststoreUrl the truststoreUrl to set
	 */
	public void setTruststoreUrl(URL truststoreUrl)
	{
		this.truststoreUrl = truststoreUrl;
	}

	/**
	 * @param keystoreUrl the keystoreUrl to set
	 */
	public void setKeystoreUrl(URL keystoreUrl)
	{
		this.keystoreUrl = keystoreUrl;
	}

	/**
	 * @param keystorePassword the keystorePassword to set
	 */
	public void setKeystorePassword(String keystorePassword)
	{
		this.keystorePassword = keystorePassword;
	}

	/**
	 * @param truststorePassword the truststorePassword to set
	 */
	public void setTruststorePassword(String truststorePassword)
	{
		this.truststorePassword = truststorePassword;
	}

	/**
	 * @param protocol the protocol to set
	 */
	public void setProtocol(String protocol)
	{
		this.protocol = protocol;
	}

	/**
	 * @param port the port to set
	 */
	public void setPort(int port)
	{
		this.port = port;
	}

	/**
	 * @return
	 */
	public String getAlias()
	{
		return alias;
	}

	/**
	 * @param alias
	 */
	public void setAlias(String alias)
	{
		this.alias = alias;
	}

	/**
	 * 
	 */
	public void clear()
	{
		truststoreUrl = null;
		keystoreUrl = null;
		keystorePassword = null;
		truststorePassword = null;
		protocol = DEFAULT_PROTOCOL;
		port = DEFAULT_PORT;
		alias = null;
	}
	
	
}
