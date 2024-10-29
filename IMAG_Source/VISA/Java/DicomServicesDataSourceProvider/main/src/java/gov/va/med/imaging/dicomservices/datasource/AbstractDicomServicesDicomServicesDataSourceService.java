/**
 * 
 */
package gov.va.med.imaging.dicomservices.datasource;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.DicomServicesDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.WorkItem;

/**
 * @author William Peterson
 *
 */
public abstract class AbstractDicomServicesDicomServicesDataSourceService 
extends AbstractDicomServicesDataSourceService
		implements DicomServicesDataSourceSpi {


	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public AbstractDicomServicesDicomServicesDataSourceService(ResolvedArtifactSource resolvedArtifactSource,String protocol) {
		super(resolvedArtifactSource, protocol);
		
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");

	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.DicomServicesDataSourceSpi#sendToAE(gov.va.med.imaging.exchange.business.dicom.DicomAE, java.lang.Object)
	 */
	@Override
	public void postToAE(RoutingToken routingToken, DicomAE dicomAE, List<String> dicomFileList) throws MethodException, ConnectionException {

		throw new UnsupportedServiceMethodException(DicomServicesDataSourceSpi.class, "sendToAE");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.DicomServicesDataSourceSpi#getListedAEs()
	 */
	@Override
	public List<DicomAE> getAEList(RoutingToken routingToken) throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(DicomServicesDataSourceSpi.class, "getAEList");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.DicomServicesDataSourceSpi#getDicomReportText(RoutingToken, int, String, String)
	 */
	@Override
	public String getDicomReportText(RoutingToken routingToken, WorkItem workItem) throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(DicomServicesDataSourceSpi.class, "getDicomReportText");
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.dicomservices.datasource.AbstractDicomServicesDataSourceService#getDataSourceVersion()
	 */
	@Override
	protected String getDataSourceVersion() {
		return null;
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


}
