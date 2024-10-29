/**
 * 
 */
package gov.va.med.imaging.dicomservices.datasource;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.datasource.AbstractVersionableDataSource;
import gov.va.med.imaging.dicomservices.datasource.configuration.DicomServicesConfiguration;

/**
 * @author William Peterson
 *
 */
public abstract class AbstractDicomServicesDataSourceService 
extends AbstractVersionableDataSource {

	private final static Logger logger = Logger.getLogger(AbstractDicomServicesDataSourceService.class);	
	

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public AbstractDicomServicesDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
	}
	
	protected abstract String getDataSourceVersion();
		
	
	protected DicomServicesConfiguration getDicomServicesConfiguration(){
		return DicomServicesDataSourceProvider.getDicomServicesConfiguration();
	}
	
	protected Logger getLogger(){
		return logger;
	}


}
