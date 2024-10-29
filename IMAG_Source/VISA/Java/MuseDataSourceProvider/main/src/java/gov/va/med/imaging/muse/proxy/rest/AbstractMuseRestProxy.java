/**
 * 
 */
package gov.va.med.imaging.muse.proxy.rest;

import gov.va.med.imaging.channels.ChecksumValue;
import gov.va.med.imaging.channels.exceptions.ChecksumFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.muse.DefaultMuseValues;
import gov.va.med.imaging.musedatasource.configuration.MuseConfiguration;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.proxy.rest.RestProxyCommon;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.io.IOException;
import java.util.Locale;
import java.util.Map;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;
import gov.va.med.logging.Logger;

/**
 * @author William Peterson
 *
 */
public abstract class AbstractMuseRestProxy{

	private final static Logger logger = Logger.getLogger(AbstractMuseRestProxy.class);

	protected final MuseConfiguration museConfiguration;
	protected final ProxyServices proxyServices;
	
	protected MuseServerConfiguration museServer;
	protected String responseContentType="";
	protected String responseEncoding="";
	protected String responseMessage="";
	protected String responseChecksum=null;

	protected final boolean instanceUrlEscaped;

	protected AbstractMuseRestProxy(ProxyServices proxyServices, MuseConfiguration museConfiguration, 
					MuseServerConfiguration museServer, boolean instanceUrlEscaped)
	{
		assert proxyServices != null;
		this.proxyServices = proxyServices;
		this.museConfiguration = museConfiguration;
		this.museServer = museServer;
		this.instanceUrlEscaped = instanceUrlEscaped;
	}
	
	public abstract ProxyService getProxyService();
	
	public abstract ProxyServiceType getProxyServiceType();
	
	protected abstract String getRestServicePath();
	
	public abstract String getRestProxyVersion();
	
	public abstract String getMuseServerVersion();

	protected abstract void addSecurityContextToHeader(HttpClient client, GetMethod getMethod, 
			boolean includeVistaSecurityContext);
	
	protected abstract void addOptionalGetInstanceHeaders(GetMethod getMethod);	
	

	protected int getMetadataTimeoutMs()
	{
		if(museConfiguration != null)
		{
			return museServer.getMetadataTimeoutMs();
		}
		return DefaultMuseValues.defaultMetadataTimeoutMs;			
	}
	
	protected MuseConfiguration getMuseConfiguration(){
		return museConfiguration;
	}
	
	protected MuseServerConfiguration getMuseServerConfiguration(){
		return museServer;
	}
	

	protected void setDataSourceMethodAndVersion(String methodName)
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setDataSourceMethod(methodName);
		transactionContext.setDataSourceVersion(getRestProxyVersion());
	}
	
	public String getWebResourceUrl(String methodUri, Map<String, String> urlParameterKeyValues) // was protected...
	throws ConnectionException
	{
		
		StringBuilder url = new StringBuilder();
		url.append(museServer.getProtocol());
		url.append("://");
		url.append(museServer.getHost());
		url.append(":");
		url.append(museServer.getPort());
		url.append("/");
		url.append(museConfiguration.getMuseApplicationName());
		url.append("/");
		url.append(RestProxyCommon.replaceMethodUriWithValues(methodUri, urlParameterKeyValues));
        getLogger().debug("Muse Client WebResourceUrl: {}", url.toString());
		
		return url.toString();

		
	}

	protected static Logger getLogger() {
		return logger;
	}

	public String getResponseContentType()
	{
		return this.responseContentType;
	}

	public String getResponseMessage()
	{
		return this.responseMessage;
	}

	public String getResponseChecksum()
	{
		return this.responseChecksum;
	}

	public ChecksumValue getResponseChecksumValue()
	{
		try
		{
			return getResponseChecksum() == null ?
					null : new ChecksumValue(getResponseChecksum());
		} 
		catch (ChecksumFormatException x)
		{
            logger.warn("Error parsing checksum '{}'.", getResponseChecksum(), x);
			return null;
		}
	}


	/**
	 * @param client
	 * @param getMethod 
	 * @return
	 */
	protected String readResponseMessageBody(String contentType, GetMethod getMethod)
	{
		if(contentType != null && contentType.toLowerCase(Locale.ENGLISH).startsWith("text"))
		{
			try
			{
				return getMethod.getResponseBodyAsString();
			} 
			catch (IOException x)
			{
				logger.error(x);
			}
		}
		return null;
	}

	
	/**
	 * @param client
	 * @param getMethod 
	 * @return
	 */
	protected String readHTTPMessage(HttpClient client, GetMethod getMethod)
	{
			String response = " " + getMethod.getStatusText();
			return response;
	}

}
