/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 27, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.federationdatasource.v4;

import java.io.IOException;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.ImageAccessLoggingSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.ImagingLogEvent;
import gov.va.med.imaging.federation.proxy.v4.FederationRestImageAccessLoggingProxyV4;
import gov.va.med.imaging.federationdatasource.AbstractFederationImageAccessLoggingDataSourceService;
import gov.va.med.imaging.federationdatasource.FederationDataSourceProvider;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationImageAccessLoggingDataSourceServiceV4
extends AbstractFederationImageAccessLoggingDataSourceService 
{
	protected final VftpConnection federationConnection;
	
	private final static String DATASOURCE_VERSION = "4";
	public final static String SUPPORTED_PROTOCOL = "vftp";

	private FederationRestImageAccessLoggingProxyV4 proxy;
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationImageAccessLoggingDataSourceServiceV4(ResolvedArtifactSource resolvedArtifactSource,
		String protocol) throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getArtifactUrl());
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federationdatasource.AbstractFederationImageAccessLoggingDataSourceService#getDataSourceVersion()
	 */
	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageAccessLoggingDataSource#LogImageAccessEvent(gov.va.med.imaging.exchange.ImageAccessLogEvent)
	 */
	@Override
	public void LogImageAccessEvent(ImageAccessLogEvent logEvent)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationImageAccessLoggingDataSourceServiceV4.LogImageAccessEvent() --> Image IEN [{}], transaction idenity [{}]", logEvent == null ? "null" : logEvent.getImageIen(), TransactionContextFactory.get().getDisplayIdentity());
		if(logEvent != null)
		{
			try 
			{
				federationConnection.connect();			
			}
			catch(IOException ioX) 
			{
				String msg = "FederationImageAccessLoggingDataSourceServiceV4.LogImageAccessEvent() --> Failed to connect: " + ioX.getMessage();
				getLogger().error(msg);
				throw new FederationConnectionException(msg, ioX);
			}		
			boolean result = getProxy().logImageAccessEvent(logEvent);
            getLogger().info("FederationImageAccessLoggingDataSourceServiceV4.LogImageAccessEvent() --> Completed. Result [{}]", result ? "ok" : "error");
		}
	}
	
	protected FederationRestImageAccessLoggingProxyV4 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationImageAccessLoggingDataSourceServiceV4.getProxy() --> Did not receive any applicable services from IDS service for site number [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestImageAccessLoggingProxyV4(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}
	
	protected ProxyServiceType getProxyServiceType()
	{
		return ProxyServiceType.metadata;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.PassthroughDataSource#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible() 
	{
		if(getFederationProxyServices() == null)			
			return false;
		
		ProxyServiceType serviceType = getProxyServiceType();
		String siteNumber = getSite().getSiteNumber();
		
		try
		{
            getLogger().debug("Found FederationProxyServices, looking for [{}] service type at site [{}]", serviceType, siteNumber);
			getFederationProxyServices().getProxyService(serviceType);
            getLogger().debug("Found service type [{}] at site [{}], returning true for version compatible.", serviceType, siteNumber);
			return true;
		}
		catch(gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException psnfX)
		{
            getLogger().warn("Cannot find proxy service type [{}] at site [{}]", serviceType, siteNumber);
			return false;
		}
	}
	
	@Override
	public void LogImagingLogEvent(ImagingLogEvent logEvent)
	throws MethodException, ConnectionException
	{
		throw new UnsupportedServiceMethodException(ImageAccessLoggingSpi.class, "LogImagingLogEvent");
	}
}
