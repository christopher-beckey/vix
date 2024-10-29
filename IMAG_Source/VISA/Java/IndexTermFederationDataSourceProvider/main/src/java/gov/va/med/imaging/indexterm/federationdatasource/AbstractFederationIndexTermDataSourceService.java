package gov.va.med.imaging.indexterm.federationdatasource;

import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.federation.proxy.FederationProxyUtilities;
import gov.va.med.imaging.federationdatasource.AbstractFederationDataSourceService;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.datasource.IndexTermDataSourceSpi;
import gov.va.med.imaging.indexterm.enums.IndexClass;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author William Peterson
 *
 */

public abstract class AbstractFederationIndexTermDataSourceService 
extends AbstractFederationDataSourceService
implements IndexTermDataSourceSpi 
{

	private ProxyServices federationProxyServices = null;
	private final static String FEDERATION_PROXY_SERVICE_NAME = "Federation";
	private final static Logger logger = Logger.getLogger(AbstractFederationIndexTermDataSourceService.class);
	
	public abstract String getDataSourceVersion();
	protected final VftpConnection federationConnection;

	
	public AbstractFederationIndexTermDataSourceService(ResolvedArtifactSource resolvedArtifactSource,
			String protocol) {
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getMetadataUrl());
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}
	
	/**
	 * The artifact source must be checked in the constructor to assure that it is an instance
	 * of ResolvedSite.
	 * 
	 * @return
	 */
	protected ResolvedSite getResolvedSite()
	{
		return (ResolvedSite)getResolvedArtifactSource();
	}
	
	protected Site getSite()
	{
		return getResolvedSite().getSite();
	}
	
	protected Logger getLogger()
	{
		return logger;
	}
	
	/**
	 * Returns the proxy services available, if none are available then null is returned
	 */
	protected ProxyServices getFederationProxyServices()
	{
		if(federationProxyServices == null)
		{
			federationProxyServices = 
				FederationProxyUtilities.getFederationProxyServices(getSite(), 
						getFederationProxyName(), getDataSourceVersion());
		}
		return federationProxyServices;
	}
	
	protected String getFederationProxyName()
	{
		return FEDERATION_PROXY_SERVICE_NAME;
	}


	@Override
	public List<IndexTermValue> getOrigins(RoutingToken globalRoutingToken)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(IndexTermDataSourceSpi.class, "getOrigins");
	}

	@Override
	public List<IndexTermValue> getSpecialties(RoutingToken globalRoutingToken, List<IndexClass> indexClasses,
			List<IndexTermURN> eventUrns) throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(IndexTermDataSourceSpi.class, "getSpecialties");
	}

	@Override
	public List<IndexTermValue> getProcedureEvents(RoutingToken globalRoutingToken, List<IndexClass> indexClasses,
			List<IndexTermURN> specialtyUrns) throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(IndexTermDataSourceSpi.class, "getProcedureEvents");
	}

	@Override
	public List<IndexTermValue> getTypes(RoutingToken globalRoutingToken, List<IndexClass> indexClasses)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(IndexTermDataSourceSpi.class, "getTypes");
	}

	//@Override
	//public List<IndexTermValue> getIndexTermValues(RoutingToken globalRoutingToken, List<IndexTerm> terms)
	//		throws MethodException, ConnectionException {
	//	throw new UnsupportedServiceMethodException(IndexTermDataSourceSpi.class, "getIndexTermValues");
	//}

}
