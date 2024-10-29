/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: June 8, 2018
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaisltjahjb
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
package gov.va.med.imaging.federationdatasource.v9;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.federation.proxy.FederationProxyUtilities;
import gov.va.med.imaging.federation.proxy.v9.FederationRestExternalPackageProxyV9;
import gov.va.med.imaging.federationdatasource.v8.FederationExternalPackageDataSourceServiceV8;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.vftp.VftpConnection;

import java.io.IOException;
import java.util.List;

/**
 * @author vhaisltjahjb
 *
 */
public class FederationExternalPackageDataSourceServiceV9
extends FederationExternalPackageDataSourceServiceV8
{	
	protected final VftpConnection federationConnection;

	private final static String DATASOURCE_VERSION = "9";	
	
	private FederationRestExternalPackageProxyV9 proxy;
	private ProxyServices federationProxyServices;

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationExternalPackageDataSourceServiceV9(ResolvedArtifactSource resolvedArtifactSource, String protocol)
		throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getMetadataUrl());
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federationdatasource.AbstractFederationExternalPackageDataSourceService#getDataSourceVersion()
	 */
	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}

	@Override
	protected FederationRestExternalPackageProxyV9 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getCurrentFederationProxyServices();
			
			if(proxyServices == null)
				throw new ConnectionException("FederationExternalPackageDataSourceServiceV9.getProxy() --> Did not receive any applicable services from IDS service for site [" + getSite().getSiteNumber() + "]");
			
			proxy = new FederationRestExternalPackageProxyV9(proxyServices, getFederationConfiguration());
		}
		return proxy;
	}	
	
	/**
	 * Returns the current version of proxy services, if none are available then null is returned
	 */
	private ProxyServices getCurrentFederationProxyServices()
	{
		if(federationProxyServices == null)
		{
			federationProxyServices = 
				FederationProxyUtilities.getCurrentFederationProxyServices(
						getSite(), 
						getFederationProxyName(), 
						getDataSourceVersion());
		}
		return federationProxyServices;
	}
	
	@Override
	public List<WorkItem> getRemoteWorkItemListFromDataSource(
			RoutingToken globalRoutingToken, 
			String idType, 
			String patientId,
			String cptCode) 
	throws MethodException, ConnectionException 
	{
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationExternalPackageDataSourceServiceV9.getRemoteWorkItemListFromDataSource() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}

		return getProxy().getWorkItemList(globalRoutingToken, idType, patientId, cptCode);	
	}

	@Override
	public boolean deleteRemoteWorkItemFromDataSource(RoutingToken globalRoutingToken, String id) 
	throws MethodException, ConnectionException 
	{
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationExternalPackageDataSourceServiceV9.deleteRemoteWorkItemFromDataSource() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}

		return getProxy().deleteWorkItem(globalRoutingToken, id);
	}
}
