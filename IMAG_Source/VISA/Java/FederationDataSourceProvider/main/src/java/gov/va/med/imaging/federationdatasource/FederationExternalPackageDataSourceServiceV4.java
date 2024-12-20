/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 1, 2010
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
package gov.va.med.imaging.federationdatasource;

import java.io.IOException;
import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.ExternalPackageDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.federation.proxy.v4.FederationRestExternalPackageProxyV4;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationExternalPackageDataSourceServiceV4
extends AbstractFederationExternalPackageDataSourceService
{

	protected final VftpConnection federationConnection;
	
	private final static String DATASOURCE_VERSION = "4";
	private FederationRestExternalPackageProxyV4 proxy = null;
	public final static String SUPPORTED_PROTOCOL = "vftp";
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationExternalPackageDataSourceServiceV4(ResolvedArtifactSource resolvedArtifactSource, String protocol)
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
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ExternalPackageDataSource#getStudyFromCprsIdentifier(java.lang.String, gov.va.med.imaging.CprsIdentifier)
	 */
	@Override
	public List<Study> getStudiesFromCprsIdentifier(RoutingToken globalRoutingToken, String patientIcn,
			CprsIdentifier cprsIdentifier) 
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationExternalPackageDataSourceServiceV4.getStudyFromCprsIdentifier() --> for Cprs Identifier [{}] transaction Id [{}]", cprsIdentifier, TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
            getLogger().error("FederationExternalPackageDataSourceServiceV4.getStudyFromCprsIdentifier() --> Error getting study from CPRS identifier: {}", ioX.getMessage());
			throw new FederationConnectionException(ioX);
		}
		return getProxy().getStudiesFromCprsIdentifier(globalRoutingToken, patientIcn, cprsIdentifier);		
	}

	protected FederationRestExternalPackageProxyV4 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationExternalPackageDataSourceServiceV4.getProxy() --> Did not receive any applicable services from IDS service for site number [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestExternalPackageProxyV4(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.PassthroughDataSource#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible() 
	{
		if(getFederationProxyServices() == null)			
			return false;
		
		ProxyServiceType serviceType = ProxyServiceType.metadata;
		String siteNumber = getSite().getSiteNumber();
		
		try
		{
            getLogger().debug("FederationExternalPackageDataSourceServiceV4.isVersionCompatible() --> Found FederationProxyServices, looking for [{}] service type at site number [{}]", serviceType, siteNumber);
			getFederationProxyServices().getProxyService(serviceType);
            getLogger().debug("FederationExternalPackageDataSourceServiceV4.isVersionCompatible() --> Found service type [{}] at site number [{}], returning true for version compatible.", serviceType, siteNumber);
			return true;
		}
		catch(gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException psnfX)
		{
            getLogger().warn("FederationExternalPackageDataSourceServiceV4.isVersionCompatible() --> Cannot find proxy service type [{}] at site number [{}], returning false for version compatible.", serviceType, siteNumber);
			return false;
		}
	}
}
