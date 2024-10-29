/**
 * 
 */
package gov.va.med.imaging.musedatasource;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.PatientArtifactDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.muse.proxy.IMuseProxy;
import gov.va.med.imaging.muse.proxy.MuseProxyUtilities;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServices;

/**
 * @author William Peterson
 *
 */
public abstract class AbstractMusePatientArtifactDataSourceService 
extends AbstractMuseDataSourceService
implements PatientArtifactDataSourceSpi{

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public AbstractMusePatientArtifactDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
		
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
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ExternalPackageDataSource#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible() 
	{
		return true;
	}	


	protected abstract IMuseProxy getProxy(MuseServerConfiguration museServer)
	throws ConnectionException;

	
	@Override
	protected ProxyServices getProxyServices(MuseServerConfiguration museServer)
	{
		if(museProxyServices == null)
		{
			museProxyServices = 
				MuseProxyUtilities.getProxyServices(getMuseConfiguration(), museServer, getSite().getSiteNumber(), 
						getProxyName(), getDataSourceVersion());
			
		}
		return museProxyServices;
	}


	@Override
	protected String getDataSourceVersion() {
		return null;
	}


	@Override
	public ArtifactResults getPatientArtifacts(RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier, StudyFilter studyFilter,
			StudyLoadLevel studyLoadLevel, boolean includeImages,
			boolean includeDocuments) throws MethodException,
			ConnectionException {
		throw new UnsupportedServiceMethodException(PatientArtifactDataSourceSpi.class, "getPatientArtifacts");
	}

}
