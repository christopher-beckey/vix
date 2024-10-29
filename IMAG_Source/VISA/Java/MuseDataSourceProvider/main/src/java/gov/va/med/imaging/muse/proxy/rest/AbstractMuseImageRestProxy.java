/**
 * 
 */
package gov.va.med.imaging.muse.proxy.rest;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.imaging.MuseImageURN;
import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageConversionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.muse.proxy.IMuseImageProxy;
import gov.va.med.imaging.musedatasource.configuration.MuseConfiguration;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.proxy.Utilities;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;

/**
 * @author William Peterson
 *
 */
public abstract class AbstractMuseImageRestProxy 
extends AbstractMuseRestProxy 
implements IMuseImageProxy {


	public AbstractMuseImageRestProxy(ProxyServices proxyServices,
			MuseConfiguration museConfiguration, MuseServerConfiguration museServer, boolean instanceUrlEscaped) {
		super(proxyServices, museConfiguration, museServer, instanceUrlEscaped);
	}
			
	public abstract int getFileLength();
	
	public abstract String getImageChecksum();
	
	public abstract ImageQuality getRequestedQuality();


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseProxy#getDataSourceVersion()
	 */
	@Override
	public String getRestProxyVersion() {
		return null;
	}
	
	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseRestProxy#getMuseServerVersion()
	 */
	@Override
	public String getMuseServerVersion() {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * Returns the ProxyService for the ProxyServiceType.image, if none is found
	 * then the exception is caught and null is returned.
	 */
	@Override
	public ProxyService getProxyService()
	{
		try
		{
			return proxyServices.getProxyService(getProxyServiceType());
		}
		catch(ProxyServiceNotFoundException psnfX)
		{
			return null;
		}
	}
	
	@Override
	public ProxyServiceType getProxyServiceType() {
		return ProxyServiceType.image;
	}


	/**
	 * Create a URL string for an image specific to this proxy. 
	 *  
	 * @param imageUrn
	 * @return
	 */
	public String createImageUrl(String imageUrn, ImageFormatQualityList requestFormatQualityList)
	throws ProxyServiceNotFoundException
	{
		return Utilities.createImageUrl(this.proxyServices, imageUrn, 
				requestFormatQualityList, getProxyServiceType());
	}

	
	@Override
	protected void addSecurityContextToHeader(HttpClient client,
			GetMethod getMethod, boolean includeVistaSecurityContext) {
		// TODO Auto-generated method stub
		
	}

	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public SizedInputStream getImage(MuseImageURN imageUrn, ImageFormatQualityList requestFormatQualityList)
			throws ImageNearLineException, ImageNotFoundException,
			SecurityCredentialsExpiredException, ImageConversionException,
			MethodException, ConnectionException {
		throw new MethodException("Unsupported Muse web service proxy, getImage.");
	}

	
	
	private final static String utf8 = "UTF-8"; 
	protected String encodeGai(GlobalArtifactIdentifier gai)
	throws MethodException
	{
		return encodeString(gai.toString(SERIALIZATION_FORMAT.RAW));
	}
	
	protected String encodeString(String value)
	throws MethodException
	{
		try
		{
			return URLEncoder.encode(value, utf8);
		}
		catch(UnsupportedEncodingException ueX)
		{
			throw new MethodException(ueX);
		}
	}

	@Override
	protected String getRestServicePath() {
		// TODO Auto-generated method stub
		return null;
	}
}
