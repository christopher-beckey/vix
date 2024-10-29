/**
 * 
 */
package gov.va.med.imaging.viewerservicesdatasource;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.datasource.AbstractVersionableDataSource;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.viewerservices.common.DefaultViewerServicesValues;

/**
 * @author William Peterson
 *
 */
public abstract class AbstractViewerServicesDataSourceService 
extends AbstractVersionableDataSource {

	private final static Logger logger = 
			Logger.getLogger(AbstractViewerServicesDataSourceService.class);	
	
	protected ProxyServices ViewerServicesProxyServices = null;

	/**
	 * 
	 */
	public AbstractViewerServicesDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
	}
	
	protected abstract ProxyServices getProxyServices(SiteConnection connection);

	protected abstract String getDataSourceVersion();
		
	protected String getProxyName(){
		return DefaultViewerServicesValues.PROXY_SERVICE_NAME;
	}
		
	protected Logger getLogger(){
		return logger;
	}


}
