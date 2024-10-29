package gov.va.med.imaging.federationdatasource;

import java.io.IOException;
import java.util.SortedSet;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.federation.proxy.v4.FederationRestStudyProxyV4;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.vftp.VftpConnection;

public class FederationStudyGraphDataSourceServiceV4 
extends AbstractFederationStudyGraphDataSourceService 
{
	private final VftpConnection federationConnection;
	
	private final static String DATASOURCE_VERSION = "4";
	private FederationRestStudyProxyV4 proxy;
	public final static String SUPPORTED_PROTOCOL = "vftp";

	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationStudyGraphDataSourceServiceV4(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getMetadataUrl());

		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a [" + resolvedArtifactSource.getClass().getSimpleName() + "]");
	}

	protected FederationRestStudyProxyV4 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationStudyGraphDataSourceServiceV4.getProxy() --> Did not receive any applicable services from IDS service for site number [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestStudyProxyV4(proxyServices, 
					FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}

	@Override
	public StudySetResult getPatientStudies(RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier,
			StudyFilter filter, StudyLoadLevel studyLoadLevel)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationStudyGraphDataSourceServiceV4.getPatientStudies() --> For patient Id [{}], StudyLoadLevel [{}], transaction identity [{}]", patientIdentifier.toString(), studyLoadLevel, TransactionContextFactory.get().getDisplayIdentity());
		if(patientIdentifier.getPatientIdentifierType().isLocal())
			throw new MethodException("FederationStudyGraphDataSourceServiceV4.getPatientStudies() --> Cannot use local patient identifier to retrieve remote patient information");
		String patientIcn = patientIdentifier.getValue();
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationStudyGraphDataSourceServiceV4.getPatientStudies() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}					
		if(filter != null)
		{
			if(filter.isStudyIenSpecified())
			{
                getLogger().info("FederationStudyGraphDataSourceServiceV4.getPatientStudies() --> Filtering study by study Id [{}]", filter.getStudyId());
			}
		}
		StudySetResult result = getProxy().getStudies(patientIcn, filter, globalRoutingToken, studyLoadLevel);
		SortedSet<Study> studies = result.getArtifacts();
        getLogger().info("FederationStudyGraphDataSourceServiceV4.getPatientStudies() --> Got [{}] studies from site number [{}]", studies == null ? 0 : studies.size(), getSite().getSiteNumber());
		return result;		
	}

	@Override
	public boolean isVersionCompatible() 
	throws SecurityException 
	{
		if(getFederationProxyServices() == null)
		{
			getLogger().debug("FederationStudyGraphDataSourceServiceV4.isVersionCompatible() --> No FederationProxyServices.  Return false.");
			return false;
		}
		
		ProxyServiceType serviceType = ProxyServiceType.metadata;
		String siteNumber = getSite().getSiteNumber();
		
		try
		{

            getLogger().debug("FederationStudyGraphDataSourceServiceV4.isVersionCompatible() --> Found FederationProxyServices, looking for [{}] service type at site number [{}]", serviceType, siteNumber);
			getFederationProxyServices().getProxyService(serviceType);
            getLogger().debug("FederationStudyGraphDataSourceServiceV4.isVersionCompatible() --> Found service type [{}] at site number [{}], returning true for version compatible.", serviceType, siteNumber);
			return true;
		}
		catch(gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException psnfX)
		{
            getLogger().warn("FederationStudyGraphDataSourceServiceV4.isVersionCompatible() --> Return false. Cannot find proxy service type [{}] at site number [{}]", serviceType, siteNumber);
			return false;
		}
	}	
}
