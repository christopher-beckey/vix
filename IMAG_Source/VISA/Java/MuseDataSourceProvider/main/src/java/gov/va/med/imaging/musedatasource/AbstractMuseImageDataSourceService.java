/**
 * 
 */
package gov.va.med.imaging.musedatasource;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.ImageDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.ImageStreamResponse;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;
import gov.va.med.imaging.muse.proxy.IMuseImageProxy;
import gov.va.med.imaging.muse.proxy.MuseProxyUtilities;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServices;

/**
 * @author William Peterson
 *
 */
public abstract class AbstractMuseImageDataSourceService 
extends AbstractMuseDataSourceService 
implements ImageDataSourceSpi {

	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public AbstractMuseImageDataSourceService(
			ResolvedArtifactSource resolvedArtifactSource, String protocol) {
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
	
	protected abstract IMuseImageProxy getProxy(MuseServerConfiguration museServer)
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


	/**
	 * Determines if this data source can ever get a text file. If this returns false, then no matter
	 * what type of image is requested, don't bother getting a text file
	 * @return
	 */
	protected abstract boolean canGetTextFile();



	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageDataSourceSpi#getImage(gov.va.med.GlobalArtifactIdentifier, gov.va.med.imaging.exchange.business.ImageFormatQualityList)
	 */
	@Override
	public ImageStreamResponse getImage(GlobalArtifactIdentifier gai,
			ImageFormatQualityList requestFormatQualityList)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(ImageDataSourceSpi.class, "getImage");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageDataSourceSpi#getImage(gov.va.med.imaging.exchange.business.Image, gov.va.med.imaging.exchange.business.ImageFormatQualityList)
	 */
	@Override
	public ImageStreamResponse getImage(Image image,
			ImageFormatQualityList requestFormatQualityList)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(ImageDataSourceSpi.class, "getImage");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageDataSourceSpi#getImageTXTFile(gov.va.med.imaging.exchange.business.Image)
	 */
	@Override
	public DataSourceInputStream getImageTXTFile(Image image)
			throws MethodException, ConnectionException,
			ImageNotFoundException, ImageNearLineException {
		throw new UnsupportedServiceMethodException(ImageDataSourceSpi.class, "getImageTXTFile");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageDataSourceSpi#getImageTXTFile(gov.va.med.imaging.ImageURN)
	 */
	@Override
	public DataSourceInputStream getImageTXTFile(ImageURN imageURN)
			throws MethodException, ConnectionException,
			ImageNotFoundException, ImageNearLineException {
		throw new UnsupportedServiceMethodException(ImageDataSourceSpi.class, "getImageTXTFile");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageDataSourceSpi#getImageInformation(gov.va.med.imaging.AbstractImagingURN, boolean)
	 */
	@Override
	public String getImageInformation(AbstractImagingURN imagingUrn,
			boolean includeDeletedImages) throws MethodException,
			ConnectionException, ImageNotFoundException {
		throw new UnsupportedServiceMethodException(ImageDataSourceSpi.class, "getImageInformation");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageDataSourceSpi#getImageSystemGlobalNode(gov.va.med.imaging.AbstractImagingURN)
	 */
	@Override
	public String getImageSystemGlobalNode(AbstractImagingURN imagingUrn)
			throws MethodException, ConnectionException, ImageNotFoundException {
		throw new UnsupportedServiceMethodException(ImageDataSourceSpi.class, "getImageSystemGlobalNode");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageDataSourceSpi#getImageDevFields(gov.va.med.imaging.AbstractImagingURN, java.lang.String)
	 */
	@Override
	public String getImageDevFields(AbstractImagingURN imagingUrn, String flags)
			throws MethodException, ConnectionException, ImageNotFoundException {
		throw new UnsupportedServiceMethodException(ImageDataSourceSpi.class, "getImageDevFields");
	}

}
