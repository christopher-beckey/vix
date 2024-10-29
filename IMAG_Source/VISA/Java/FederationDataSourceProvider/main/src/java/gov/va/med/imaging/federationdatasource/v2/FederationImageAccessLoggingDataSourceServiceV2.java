/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 4, 2009
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
package gov.va.med.imaging.federationdatasource.v2;

import java.io.IOException;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.ImageAccessLoggingSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.ImagingLogEvent;
import gov.va.med.imaging.federation.proxy.FederationProxyV2;
import gov.va.med.imaging.federationdatasource.AbstractFederationImageAccessLoggingDataSourceService;
import gov.va.med.imaging.federationdatasource.FederationDataSourceProvider;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.vftp.VftpConnection;


/**
 * @author vhaiswwerfej
 *
 */
public class FederationImageAccessLoggingDataSourceServiceV2 
extends AbstractFederationImageAccessLoggingDataSourceService 
{
	
	private final VftpConnection federationConnection;
	
	private final static String DATASOURCE_VERSION = "2";
	public final static String SUPPORTED_PROTOCOL = "vftp";
	
	private FederationProxyV2 proxy;
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationImageAccessLoggingDataSourceServiceV2(ResolvedArtifactSource resolvedArtifactSource,
		String protocol) throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getMetadataUrl());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federationdatasource.AbstractFederationImageAccessLoggingDataSourceService#getDataSourceVersion()
	 */
	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}

	private FederationProxyV2 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationImageAccessLoggingDataSourceServiceV2.getProxy() --> Did not receive any applicable services from IDS service for site number [" + getSite().getSiteNumber() + "]");
			proxy = new FederationProxyV2(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageAccessLoggingDataSource#LogImageAccessEvent(gov.va.med.imaging.exchange.ImageAccessLogEvent)
	 */
	@SuppressWarnings("unused")
	@Override
	public void LogImageAccessEvent(ImageAccessLogEvent logEvent)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationImageAccessLoggingDataSourceServiceV2.LogImageAccessEvent() --> Image IEN [{}], transaction identity [{}]", logEvent.getImageIen(), TransactionContextFactory.get().getDisplayIdentity());
		
		if(logEvent == null)
		{
			getLogger().debug("FederationImageAccessLoggingDataSourceServiceV2.LogImageAccessEvent() --> Given log event is null. Return.");
			return;
		}
		
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationImageAccessLoggingDataSourceServiceV2.LogImageAccessEvent() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}		
		
		boolean result = getProxy().logImageAccessEvent(logEvent);
        getLogger().info("FederationImageAccessLoggingDataSourceServiceV2.LogImageAccessEvent() --> Completed. Result [{}]", result ? "ok" : "error");
	}

	@Override
	public void LogImagingLogEvent(ImagingLogEvent logEvent)
	throws MethodException, ConnectionException
	{
		throw new UnsupportedServiceMethodException(ImageAccessLoggingSpi.class, "LogImagingLogEvent");
	}
}
