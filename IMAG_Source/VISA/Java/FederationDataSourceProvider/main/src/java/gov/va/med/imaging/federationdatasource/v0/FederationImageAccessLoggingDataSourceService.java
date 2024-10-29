/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 6, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.federationdatasource.v0;

import java.io.IOException;

import javax.xml.rpc.ServiceException;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.ImageAccessLoggingSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.ImagingLogEvent;
import gov.va.med.imaging.federation.proxy.FederationProxy;
import gov.va.med.imaging.federationdatasource.AbstractFederationImageAccessLoggingDataSourceService;
import gov.va.med.imaging.federationdatasource.FederationDataSourceProvider;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.federation.exceptions.FederationMethodException;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationImageAccessLoggingDataSourceService 
extends AbstractFederationImageAccessLoggingDataSourceService
{
	
	private final VftpConnection federationConnection;
	
	private final static Logger LOGGER = Logger.getLogger(FederationImageAccessLoggingDataSourceService.class);
	
	private final static String DATASOURCE_VERSION = "0";
	public final static String SUPPORTED_PROTOCOL = "vftp";
			
	private FederationProxy proxy;
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationImageAccessLoggingDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol)
		throws UnsupportedOperationException
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
	 * @see gov.va.med.imaging.datasource.ImageAccessLoggingSpi#LogImageAccessEvent(gov.va.med.imaging.exchange.ImageAccessLogEvent)
	 */
	@SuppressWarnings("unused")
	@Override
	public void LogImageAccessEvent(ImageAccessLogEvent logEvent)
	throws UnsupportedOperationException, MethodException, ConnectionException 
	{
        LOGGER.info("FederationImageAccessLoggingDataSourceService.LogImageAccessEvent() --> Image IEN [{}], transaction identity [{}]", logEvent.getImageIen(), TransactionContextFactory.get().getDisplayIdentity());
		
		if(logEvent == null)
		{
			LOGGER.info("FederationImageAccessLoggingDataSourceService.LogImageAccessEvent() --> Given log event is null.  Return.");
			return;
		}
		
		try 
		{
			federationConnection.connect();			
			boolean result = getProxy().logImageAccessEvent(logEvent);
            LOGGER.info("FederationImageAccessLoggingDataSourceService.LogImageAccessEvent() --> Completed. Result [{}]", result ? "ok" : "error");
		}
		catch(ServiceException sX) 
		{
			String msg = "FederationImageAccessLoggingDataSourceService.LogImageAccessEvent() --> Encountered ServiceException: " + sX.getMessage();
			LOGGER.error(msg);
			throw new FederationMethodException(msg, sX);
		}
		catch(IOException ioX) 
		{
			String msg = "FederationImageAccessLoggingDataSourceService.LogImageAccessEvent() --> Failed to connect OR cannot log: " + ioX.getMessage();
			LOGGER.error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
	}

	private FederationProxy getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();			
			if(proxyServices == null)
				throw new ConnectionException("FederationImageAccessLoggingDataSourceService.getProxy() --> Did not receive any applicable services from IDS service for site number [" + getSite().getSiteNumber() + "]");
			proxy = new FederationProxy(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}

	@Override
	public void LogImagingLogEvent(ImagingLogEvent logEvent)
	throws MethodException, ConnectionException
	{
		throw new UnsupportedServiceMethodException(ImageAccessLoggingSpi.class, "LogImagingLogEvent");		
	}
}
