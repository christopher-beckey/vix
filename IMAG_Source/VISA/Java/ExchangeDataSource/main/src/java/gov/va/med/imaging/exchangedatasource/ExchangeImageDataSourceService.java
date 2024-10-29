/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 10, 2008
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
package gov.va.med.imaging.exchangedatasource;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.conversion.ImageConversionFilePath;
import gov.va.med.imaging.conversion.ImageConversionUtility;
import gov.va.med.imaging.conversion.enums.ImageConversionSatisfaction;
import gov.va.med.imaging.core.interfaces.exceptions.*;
import gov.va.med.imaging.datasource.AbstractVersionableDataSource;
import gov.va.med.imaging.datasource.ImageDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exchange.business.*;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.proxy.v1.ImageXChangeProxy;
import gov.va.med.imaging.exchange.proxy.v1.ImageXChangeProxyFactory;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;
import gov.va.med.imaging.exchange.storage.ExchangeStorageUtility;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.exchange.ExchangeConnection;
import gov.va.med.imaging.url.exchange.configuration.ExchangeSiteConfiguration;
import gov.va.med.imaging.url.exchange.exceptions.ExchangeConfigurationException;
import gov.va.med.imaging.url.exchange.exceptions.ExchangeConnectionException;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ExchangeImageDataSourceService 
extends AbstractVersionableDataSource
implements ImageDataSourceSpi
{
	private final static Logger LOGGER = Logger.getLogger(ExchangeImageDataSourceService.class);
	
	public static final List<ImageFormat> acceptableThumbnailResponseTypes;
	public static final List<ImageFormat> acceptableReferenceResponseTypes;
	public static final List<ImageFormat> acceptableDiagnosticResponseTypes;
	
	static
	{
		acceptableThumbnailResponseTypes = new ArrayList<ImageFormat>();
		acceptableThumbnailResponseTypes.add(ImageFormat.JPEG);
		
		acceptableReferenceResponseTypes = new ArrayList<ImageFormat>();
		acceptableReferenceResponseTypes.add(ImageFormat.DICOMJPEG2000);
		
		acceptableDiagnosticResponseTypes = new ArrayList<ImageFormat>();
		acceptableDiagnosticResponseTypes.add(ImageFormat.DICOMJPEG2000);
	}	
	
	private final ExchangeConnection exchangeConnection;
	
	// Hashmap to hold proxies based on the alien site number (if empty string, will return proxy to BIA), otherwise will use wormhole.
	private HashMap<String, ImageXChangeProxy> xchangeProxies = new HashMap<String, ImageXChangeProxy>();
	
	
	private final static String EXCHANGE_PROXY_SERVICE_NAME = "Exchange";
	private final static String DATASOURCE_VERSION = "1";
	public final static String SUPPORTED_PROTOCOL = "exchange";
	
	/**
     * The Provider will use the create() factory method preferentially
     * over a constructor.  This allows for caching of VistaStudyGraphDataSourceService
     * instances according to the criteria set here.
     * 
     * @param url
     * @param site
     * @return
     * @throws ConnectionException
     * @throws UnsupportedProtocolException 
     */
    public static ExchangeImageDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
    throws ConnectionException, UnsupportedProtocolException
    {
    	return new ExchangeImageDataSourceService(resolvedArtifactSource, protocol);
    }
	
    /**
     * 
     * @param resolvedArtifactSource
     * @param protocol
     * @throws UnsupportedProtocolException if the ResolvedArtifactSource is not an instance of ResolvedSite
     */
	public ExchangeImageDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol) 
	throws UnsupportedProtocolException
	{
		super(resolvedArtifactSource, protocol);		
		exchangeConnection = new ExchangeConnection(getArtifactUrl());
	}	
	
	@Override
	public boolean isVersionCompatible() 
	{
		// nothing really to check
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageDataSourceSpi#getUrl()
	 */
	public URL getUrl() 
	{
		return exchangeConnection.getURL();
	}
	
	@Override
	public DataSourceInputStream getImageTXTFile(Image image)
	throws MethodException, ConnectionException
	{
		return null;
	}

	/**
	 * 
	 * @see gov.va.med.imaging.datasource.ImageDataSource#getImage(gov.va.med.imaging.exchange.business.Image, int, java.lang.String)
	 */
	@Override
	public ImageStreamResponse getImage(Image image, ImageFormatQualityList requestFormatQualityList) 
	throws MethodException, ConnectionException
	{
        LOGGER.info("ExchangeImageDataSourceService.getImage(1) --> Given Image IEN [{}], TransactionContext identity [{}]", image.getIen(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			return getImage(image.getImageUrn(), requestFormatQualityList, getProxy(image));
		}
		catch(IOException ioX)
		{
			String msg = "ExchangeImageDataSourceService.getImage(1) --> IOException for Image URN [" + image.getImageUrn().toString(SERIALIZATION_FORMAT.NATIVE) + "]: " + ioX.getMessage();
			LOGGER.error(msg);
			throw new MethodRemoteException(msg, ioX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageDataSourceSpi#getImage(gov.va.med.imaging.ImageURN, int, java.lang.String)
	 */
	@Override
	public ImageStreamResponse getImage(GlobalArtifactIdentifier gai, ImageFormatQualityList requestFormatQualityList) 
	throws MethodException, ExchangeConnectionException, ConnectionException
	{		
		if(!(gai instanceof ImageURN))
		{
			throw new MethodException("ExchangeImageDataSourceService.getImage(2) --> Given Id [" + gai.toString() + "] is not instanceof ImageURN.");
		}
		ImageURN imageUrn = (ImageURN)gai;
        LOGGER.info("ExchangeImageDataSourceService.getImage(2) --> Given Image URN [{}], TransactionContext identify [{}]", imageUrn.toString(SERIALIZATION_FORMAT.NATIVE), TransactionContextFactory.get().getDisplayIdentity());
		try
		{
			return getImage(imageUrn, requestFormatQualityList, getProxy(null));
		}
		catch(IOException ioX)
		{
			String msg = "ExchangeImageDataSourceService.getImage(2) --> IOException for Image URN [" + imageUrn.toString(SERIALIZATION_FORMAT.NATIVE) + "]: " + ioX.getMessage();
			LOGGER.error(msg);
			throw new MethodRemoteException(msg, ioX);
		}		
	}
	
	private ImageStreamResponse getImage(
		ImageURN imageUrn, 
		ImageFormatQualityList requestFormatQualityList, 
		ImageXChangeProxy proxy) 
	throws MethodException, ExchangeConnectionException, ConnectionException
	{
		try 
		{
			exchangeConnection.connect();			
		}
		catch(IOException ioX)
		{
			String msg = "AbstractExchangeImageDataSourceService.getImage(3) --> Couldn't connect to Exchange: " + ioX.getMessage();
			LOGGER.error(msg);
			throw new MethodRemoteException(msg, ioX);
		}
		try 
		{
			ExchangeDataSourceCommon.setDataSourceMethodAndVersion("getImage", DATASOURCE_VERSION);
			String imageId = imageUrn.toString(SERIALIZATION_FORMAT.NATIVE);
			if(proxy.getAlienSiteNumber() != null)
				TransactionContextFactory.get().addDebugInformation("Retrieving image from alien site number [" + proxy.getAlienSiteNumber() + "]");
						
			List<ImageConversionFilePath> files = new ArrayList<ImageConversionFilePath>(1);
			files.add(new ImageConversionFilePath(imageId, null, null));			
			ImageFormatQualityList prunedList = pruneRequestList(requestFormatQualityList);
			
			ExchangeStorageUtility storageUtility = new ExchangeStorageUtility(proxy);
			ImageConversionUtility imageConversionUtility = new ImageConversionUtility(storageUtility, 
					ImageConversionSatisfaction.SATISFY_ANY_REQUEST, false);					
			return imageConversionUtility.getImage(files, prunedList, requestFormatQualityList, false);			
		}
		catch (ImageNotFoundException infX)
        {
			String msg = "AbstractExchangeImageDataSourceService.getImage(3) --> Return null: Image not found for Image URN [" + imageUrn.toString(SERIALIZATION_FORMAT.NATIVE) + "]: " + infX.getMessage();
			LOGGER.warn(msg);
			return null;
        }
	}

	private ExchangeSiteConfiguration getExchangeSiteConfiguration(String alienSiteNumber)
	throws IOException
	{
		ExchangeSiteConfiguration exchangeConfiguration = null;
		String repositoryId = getResolvedArtifactSource().getArtifactSource().getRepositoryId();
		String primarySiteNumber = repositoryId;
		String secondarySiteNumber = null;
		if((alienSiteNumber != null) && (alienSiteNumber.length() > 0))
		{
			secondarySiteNumber = repositoryId;
			primarySiteNumber = alienSiteNumber;
		}
		try 
		{
			
			exchangeConfiguration = 
				ExchangeDataSourceProvider.getExchangeConfiguration().getSiteConfiguration(primarySiteNumber, secondarySiteNumber);
		}
		catch(ExchangeConfigurationException ecX)
		{
			String msg = "AbstractExchangeImageDataSourceService.getExchangeSiteConfiguration() --> Couldn't get Exchange configuration: " + ecX.getMessage();
			LOGGER.error(msg);
			throw new IOException(msg, ecX);
		}		
		return exchangeConfiguration;
	}
	
	/*
	private ImageXChangeProxy getProxy()
	throws IOException
	{
		return getProxy(null);
	}
	*/
	
	private ImageXChangeProxy getProxy(Image image)
	throws IOException
	{
		String alienSiteNumber = null;
		boolean isAlienSiteNumber = false;
		if((image != null) && (image.getAlienSiteNumber() != null))
		{
			alienSiteNumber = image.getAlienSiteNumber();
			if(xchangeProxies.containsKey(alienSiteNumber))
			{
				return xchangeProxies.get(alienSiteNumber);
			}			
		}		
		ExchangeSiteConfiguration exchangeSiteConfiguration = getExchangeSiteConfiguration(alienSiteNumber);
		String host = exchangeConnection.getURL().getHost();
		int port = exchangeConnection.getURL().getPort();
		if(exchangeSiteConfiguration.containsHostAndPort())
		{
			host = exchangeSiteConfiguration.getHost();
			port = exchangeSiteConfiguration.getPort();
			isAlienSiteNumber = true;
		}
		ImageXChangeProxy proxy = ImageXChangeProxyFactory.getSingleton().get(
				host, 
				port, 
				exchangeSiteConfiguration,
				isAlienSiteNumber ? alienSiteNumber : null,
				ExchangeDataSourceProvider.getExchangeConfiguration());	
		
		xchangeProxies.put(alienSiteNumber, proxy);	
		
		return proxy;		
		
	}

	@Override
	public DataSourceInputStream getImageTXTFile(ImageURN imageURN)
	throws UnsupportedOperationException, MethodException,
		ConnectionException, ImageNotFoundException, ImageNearLineException 
	{
		return null;
	}

	@Override
	public String getImageInformation(AbstractImagingURN imagingUrn, boolean includeDeletedImages)
	throws UnsupportedOperationException, MethodException,
		ConnectionException, ImageNotFoundException 
	{
		throw new UnsupportedOperationException("The Exchange ImageDataSource does not support the getImageInformation method.");
	}

	@Override
	public String getImageSystemGlobalNode(AbstractImagingURN imagingUrn)
			throws UnsupportedOperationException, MethodException,
			ConnectionException, ImageNotFoundException {
		throw new UnsupportedOperationException("The Exchange ImageDataSource does not support the getImageInformation method.");
	}
	
	@Override
	public String getImageDevFields(AbstractImagingURN imagingUrn, String flags)
	throws UnsupportedOperationException, MethodException,
		ConnectionException, ImageNotFoundException 
	{
		throw new UnsupportedOperationException("The Exchange ImageDataSource does not support the getImageInformation method.");
	}

	/**
	 * This function reduces the requested format list to a list acceptable by the DOD.
	 * If the request includes formats that the DOD does not expect, they will not work properly
	 * so if the request came from the Clinical Display client, it must be reduced to eliminate
	 * types like TGA, J2K, PDF, DOC, etc.
	 */
	private ImageFormatQualityList pruneRequestList(ImageFormatQualityList requestList)
	{
		ImageFormatQualityList prunedList = new ImageFormatQualityList();
		for(ImageFormatQuality quality : requestList)
		{
			List<ImageFormat> allowableFormats = getAcceptableImageFormatsForQuality(quality.getImageQuality());
			if(isQualityFormatAllowed(quality.getImageFormat(), allowableFormats))
			{
				prunedList.addUniqueMime(quality);
			}
		}
		return prunedList;
	}
	
	private List<ImageFormat> getAcceptableImageFormatsForQuality(ImageQuality quality)
	{		
		if(quality == ImageQuality.REFERENCE) 
			return acceptableReferenceResponseTypes;
		else if(quality == ImageQuality.DIAGNOSTIC)
			return acceptableDiagnosticResponseTypes;
		else if(quality == ImageQuality.DIAGNOSTICUNCOMPRESSED)
			return acceptableDiagnosticResponseTypes;
		else // thumbnail or other
			return acceptableThumbnailResponseTypes;
	}
	
	private boolean isQualityFormatAllowed(ImageFormat format, List<ImageFormat> acceptableFormats)
	{
		for(ImageFormat acceptableFormat : acceptableFormats)
		{
			if((acceptableFormat == ImageFormat.ANYTHING) ||
				(acceptableFormat.getMime().equalsIgnoreCase(format.getMime())))
			{
				return true;
			}
		}		
		return false;
	}
	
	protected String getResolvedArtifactSourceString()
	{
		ArtifactSource artifactSource = getResolvedArtifactSource().getArtifactSource();
		return artifactSource.getHomeCommunityId() + ", " + artifactSource.getRepositoryId();	
	}
}
