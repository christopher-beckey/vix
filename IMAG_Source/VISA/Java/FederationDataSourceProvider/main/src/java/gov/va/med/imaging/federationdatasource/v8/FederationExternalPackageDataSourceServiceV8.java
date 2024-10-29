/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 22, 2017
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
package gov.va.med.imaging.federationdatasource.v8;

import java.io.IOException;
import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.federation.proxy.FederationProxyUtilities;
import gov.va.med.imaging.federation.proxy.v8.FederationRestExternalPackageProxyV8;
import gov.va.med.imaging.federationdatasource.v6.FederationExternalPackageDataSourceServiceV6;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;

/**
 * @author vhaisltjahjb
 *
 */
public class FederationExternalPackageDataSourceServiceV8 
extends FederationExternalPackageDataSourceServiceV6 
{
	private final static String DATASOURCE_VERSION = "8";
	private FederationRestExternalPackageProxyV8 proxy;
	private ProxyServices federationProxyServices;
	//private IDSService remoteIDSService;
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationExternalPackageDataSourceServiceV8(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedOperationException 
	{
		super(resolvedArtifactSource, protocol);
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
	protected FederationRestExternalPackageProxyV8 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getCurrentFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationExternalPackageDataSourceServiceV8.getProxy() --> Did not receive any applicable services from IDS service for site [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestExternalPackageProxyV8(proxyServices, getFederationConfiguration());
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
				FederationProxyUtilities.getCurrentFederationProxyServices(getSite(), 
						getFederationProxyName(), getDataSourceVersion());
		}
		return federationProxyServices;
	}
	
	@Override
	public List<Study> getStudiesFromCprsIdentifierAndFilter(
			RoutingToken globalRoutingToken, 
			String patientIcn,
			CprsIdentifier cprsIdentifier, 
			StudyFilter filter)
	throws MethodException, ConnectionException 
	{
		//No need to pass filter to Federation. It's added here to satisfy the interface  
		// the filter is only used to indicate to retrieve bothdb (2005 & P34) images
		// Federation V8 will retrieve both type of images


        getLogger().info("FederationExternalPackageDataSourceServiceV8.getStudiesFromCprsIdentifierAndFilter() --> Transaction Id [{}]", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationExternalPackageDataSourceServiceV8.getStudiesFromCprsIdentifierAndFilter() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}

		return getProxy().getStudiesFromCprsIdentifierAndFilter(
				globalRoutingToken, 
				patientIcn, 
				cprsIdentifier,
				filter);
	}
	
	@Override
	public List<Study> postStudiesFromCprsIdentifiersAndFilter(
			RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier,
			List<CprsIdentifier> cprsIdentifiers, 
			StudyFilter filter)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationExternalPackageDataSourceServiceV8.postStudiesFromCprsIdentifiersAndFilter() --> Transaction Id [{}]", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationExternalPackageDataSourceServiceV8.postStudiesFromCprsIdentifiersAndFilter() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		return getProxy().postStudiesFromCprsIdentifiersAndFilter(
				globalRoutingToken, 
				patientIdentifier, 
				cprsIdentifiers,
				filter);
	}
}
