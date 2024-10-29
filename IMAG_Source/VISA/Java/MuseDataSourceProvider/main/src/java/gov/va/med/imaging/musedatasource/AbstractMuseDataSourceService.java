/**
 * 
 */
package gov.va.med.imaging.musedatasource;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.datasource.AbstractVersionableDataSource;
import gov.va.med.imaging.muse.DefaultMuseValues;
import gov.va.med.imaging.musedatasource.configuration.MuseConfiguration;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServices;

import gov.va.med.logging.Logger;

/**
 * @author William Peterson
 *
 */
public abstract class AbstractMuseDataSourceService 
extends AbstractVersionableDataSource {

	
	private final static Logger logger = 
			Logger.getLogger(AbstractMuseDataSourceService.class);	
	
	protected ProxyServices museProxyServices = null;


	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public AbstractMuseDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
	}
	
	protected abstract ProxyServices getProxyServices(MuseServerConfiguration museServer);

	protected abstract String getDataSourceVersion();
		
	protected String getProxyName(){
		return DefaultMuseValues.MUSE_PROXY_SERVICE_NAME;
	}
	
	protected MuseConfiguration getMuseConfiguration(){
		return MuseDataSourceProvider.getMuseConfiguration();
	}
	
	protected Logger getLogger(){
		return logger;
	}
}
