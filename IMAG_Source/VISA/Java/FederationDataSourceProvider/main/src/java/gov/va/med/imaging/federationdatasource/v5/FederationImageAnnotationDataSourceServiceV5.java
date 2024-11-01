/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 20, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.federationdatasource.v5;

import java.io.IOException;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.ImageAnnotationURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityException;
import gov.va.med.imaging.datasource.ImageAnnotationDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotation;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationDetails;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationSource;
import gov.va.med.imaging.federation.proxy.FederationProxyUtilities;
import gov.va.med.imaging.federation.proxy.v5.FederationRestImageAnnotationProxyV5;
import gov.va.med.imaging.federationdatasource.AbstractFederationDataSourceService;
import gov.va.med.imaging.federationdatasource.v4.FederationPatientArtifactDataSourceServiceV4;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationImageAnnotationDataSourceServiceV5
extends AbstractFederationDataSourceService
implements ImageAnnotationDataSourceSpi
{
	
	private final VftpConnection federationConnection;
	private ProxyServices federationProxyServices;
	
	private final static String DATASOURCE_VERSION = "5";
	private FederationRestImageAnnotationProxyV5 proxy;
	public final static String SUPPORTED_PROTOCOL = "vftp";
	private final static String FEDERATION_PROXY_SERVICE_NAME = "Federation";
	
	private final static Logger LOGGER = Logger.getLogger(FederationPatientArtifactDataSourceServiceV4.class);

	public FederationImageAnnotationDataSourceServiceV5(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getMetadataUrl());

		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a [" + resolvedArtifactSource.getClass().getSimpleName() + "]");
	}
	
	public static FederationImageAnnotationDataSourceServiceV5 create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws ConnectionException, UnsupportedProtocolException
	{
		return new FederationImageAnnotationDataSourceServiceV5(resolvedArtifactSource, protocol);
	}
	
	protected Logger getLogger()
	{
		return LOGGER;
	}

	@Override
	public List<ImageAnnotation> getImageAnnotations(AbstractImagingURN imagingUrn)
	throws MethodException, ConnectionException
	{
        getLogger().info("FederationImageAnnotationDataSourceServiceV5.getImageAnnotations() --> For ImageURN [{}], transaction identity [{}]", imagingUrn.toString(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationImageAnnotationDataSourceServiceV5.getImageAnnotations() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		List<ImageAnnotation> result = getProxy().getImageAnnotations(imagingUrn);
        getLogger().info("FederationImageAnnotationDataSourceServiceV5.getImageAnnotations() --> Got [{}] image annotations from site number [{}]", result == null ? 0 : result.size(), getSite().getSiteNumber());
		return result;
	}

	@Override
	public ImageAnnotationDetails getAnnotationDetails(
			AbstractImagingURN imagingUrn,
			ImageAnnotationURN imageAnnotationUrn) 
	throws MethodException, ConnectionException
	{
        getLogger().info("FederationImageAnnotationDataSourceServiceV5.getAnnotationDetails() --> For ImageURN [{}], annotation [{}], transaction identity [{}]", imagingUrn.toString(), imageAnnotationUrn.toString(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationImageAnnotationDataSourceServiceV5.getAnnotationDetails() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		ImageAnnotationDetails result = getProxy().getAnnotationDetails(imagingUrn,
				imageAnnotationUrn);
        getLogger().info("FederationImageAnnotationDataSourceServiceV5.getAnnotationDetails() --> Got [{}] image annotation details from site number [{}]", result == null ? "null" : "not null", getSite().getSiteNumber());
		return result;
	}

	@Override
	public ImageAnnotation storeImageAnnotationDetails(AbstractImagingURN imagingUrn,
			String annotationDetails, String annotationVersion, ImageAnnotationSource annotationSource)
	throws MethodException, ConnectionException
	{

        getLogger().info("FederationImageAnnotationDataSourceServiceV5.storeImageAnnotationDetails() --> For ImageURN [{}], transaction identity [{}]", imagingUrn.toString(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationImageAnnotationDataSourceServiceV5.storeImageAnnotationDetails() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		ImageAnnotation result = getProxy().storeImageAnnotationDetails(imagingUrn, 
				annotationDetails, annotationVersion, annotationSource);
        getLogger().info("FederationImageAnnotationDataSourceServiceV5.storeImageAnnotationDetails() --> Got [{}] image annotation from site number [{}]", result == null ? "null" : "not null", getSite().getSiteNumber());
		return result;
	}

	@Override
	public boolean isVersionCompatible() 
	throws SecurityException
	{
		if(getFederationProxyServices() == null)
			return false;

		ProxyServiceType serviceType = ProxyServiceType.vistaRadMetadata;
		String siteNumber = getSite().getSiteNumber();

		try
		{
            getLogger().debug("FederationImageAnnotationDataSourceServiceV5.isVersionCompatible() --> Found FederationProxyServices, looking for [{}] service type at site number [{}]", serviceType, siteNumber);
			getFederationProxyServices().getProxyService(serviceType);
            getLogger().debug("FederationImageAnnotationDataSourceServiceV5.isVersionCompatible() --> Found service type [{}] at site number [{}], returning true for version compatible.", serviceType, siteNumber);
			return true;
		}
		catch(gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException psnfX)
		{
            getLogger().warn("FederationImageAnnotationDataSourceServiceV5.isVersionCompatible() --> Cannot find proxy service type [{}] at site number [{}]", serviceType, siteNumber);
			return false;
		}
	}
	
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
	
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
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
	
	private FederationRestImageAnnotationProxyV5 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationImageAnnotationDataSourceServiceV5.getProxy() --> Did not receive any applicable services from IDS service for site [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestImageAnnotationProxyV5(proxyServices,
					getFederationConfiguration());
		}
		return proxy;
	}

	@Override
	public ImageAnnotationDetails getMostRecentAnnotationDetails(
			AbstractImagingURN imagingUrn) 
	throws MethodException, ConnectionException
	{
		// v5 of this interface does not explicitly define this method so use existing methods to implement this
		// functionality - add a specific method for this in the next Federation interface
		List<ImageAnnotation> imageAnnotations = getImageAnnotations(imagingUrn);
		// get the last item in the list (the newest annotation layer)
		ImageAnnotation mostRecentAnnotationLayer = imageAnnotations.get(imageAnnotations.size() - 1);

		return getAnnotationDetails(imagingUrn, mostRecentAnnotationLayer.getAnnotationUrn());
	}

}
