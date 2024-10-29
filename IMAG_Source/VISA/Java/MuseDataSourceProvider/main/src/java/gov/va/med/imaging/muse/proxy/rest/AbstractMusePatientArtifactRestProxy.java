/**
 * 
 */
package gov.va.med.imaging.muse.proxy.rest;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.muse.proxy.IMuseProxy;
import gov.va.med.imaging.musedatasource.configuration.MuseConfiguration;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
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
public abstract class AbstractMusePatientArtifactRestProxy 
extends AbstractMuseRestProxy
implements IMuseProxy{

	/**
	 * @param proxyServices
	 * @param museConfiguration
	 */
	public AbstractMusePatientArtifactRestProxy(ProxyServices proxyServices,
			MuseConfiguration museConfiguration, MuseServerConfiguration museServer, boolean instanceUrlEscaped) {
		super(proxyServices, museConfiguration, museServer, instanceUrlEscaped);
	}
	
	protected abstract String getMusePatientId(String musePatientId);
	

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

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.proxy.ImagingProxy#addOptionalGetInstanceHeaders(org.apache.commons.httpclient.methods.GetMethod)
	 */
	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod) {
		// TODO Auto-generated method stub

	}

	
	protected String getRestServicePath()
	{
		//WFP-return web service endpoint.
		//return MixRestUri.mixRestUriV1;
		return null;
	}
	
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

	public ProxyServiceType getProxyServiceType()
	{
		//WFP-not sure if metadata or patient.
		return ProxyServiceType.metadata;
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
	public ArtifactResults getPatientArtifacts(Site site, PatientIdentifier patientIdentifier,
			StudyFilter filter, RoutingToken routingToken,
			StudyLoadLevel studyLoadLevel, boolean includeImages,
			boolean includeDocuments)
			throws InsufficientPatientSensitivityException, MethodException,
			ConnectionException {
		throw new MethodException("Unsupported Muse web service proxy, getPatientArtifacts.");
	}

	@Override
	protected void addSecurityContextToHeader(HttpClient client,
			GetMethod getMethod, boolean includeVistaSecurityContext) {
		// TODO Auto-generated method stub
		
	}

}
