/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 8, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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

import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.conversion.ImageConversionFilePath;
import gov.va.med.imaging.conversion.ImageConversionUtility;
import gov.va.med.imaging.conversion.enums.ImageConversionSatisfaction;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodRemoteException;
import gov.va.med.imaging.datasource.AbstractVersionableDataSource;
import gov.va.med.imaging.datasource.ImageDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.ImageFormatQuality;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.ImageStreamResponse;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.proxy.ExchangeProxy;
import gov.va.med.imaging.exchange.proxy.v1.ExchangeProxyServices;
import gov.va.med.imaging.exchange.proxy.v1.ExchangeProxyUtilities;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;
import gov.va.med.imaging.exchange.storage.ExchangeStorageUtility;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.exchange.ExchangeConnection;
import gov.va.med.imaging.url.exchange.configuration.ExchangeConfiguration;
import gov.va.med.imaging.url.exchange.configuration.ExchangeSiteConfiguration;
import gov.va.med.imaging.url.exchange.exceptions.ExchangeConfigurationException;
import gov.va.med.imaging.url.exchange.exceptions.ExchangeConnectionException;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractExchangeImageDataSourceService
extends AbstractVersionableDataSource
implements ImageDataSourceSpi
{
	protected final ExchangeConnection exchangeConnection;
	private final static Logger LOGGER = Logger.getLogger(AbstractExchangeImageDataSourceService.class);
	
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
//		acceptableDiagnosticResponseTypes.add(ImageFormat.DICOM); // DICOM must be here because the request type will be application/dicom which literally converts to this one
	}	
	
	private final static String EXCHANGE_PROXY_SERVICE_NAME = "Exchange";
	public final static String SUPPORTED_PROTOCOL = "exchange";
	private ExchangeProxyServices exchangeProxyServices = null;
	@SuppressWarnings("unused")
	private ExchangeSiteConfiguration exchangeConfiguration = null;
	
	public AbstractExchangeImageDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol) 
	throws UnsupportedProtocolException
	{
		super(resolvedArtifactSource, protocol);
		exchangeConnection = new ExchangeConnection(getArtifactUrl());
	}			
	
	protected Logger getLogger()
	{
		return LOGGER;
	}
	
	protected abstract ExchangeProxy getProxy(Image image)
	throws IOException;
	
	protected abstract String getDataSourceVersion();	
	
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
	
	@Override
	public ImageStreamResponse getImage(Image image, ImageFormatQualityList requestFormatQualityList) 
	throws MethodException, ConnectionException
	{
        LOGGER.info("AbstractExchangeImageDataSourceService.getImage(1) --> Given IEN [{}] from Image object TransactionContext [{}]", image.getIen(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			return getImage(image.getImageUrn(), requestFormatQualityList,  getProxy(image));
		}
		catch(IOException ioX)
		{
			String msg = "AbstractExchangeImageDataSourceService.getImage(1) --> IOException for Image URN [" + image.getImageUrn().toString(SERIALIZATION_FORMAT.NATIVE) + "]: " + ioX.getMessage();
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
			throw new MethodException("AbstractExchangeImageDataSourceService.getImage(2) --> Given Id [" + gai.toString() + "] is not instanceof ImageURN.");
		}
		
		ImageURN imageUrn = (ImageURN) gai;

        LOGGER.info("AbstractExchangeImageDataSourceService.getImage(2) --> Image URN [{}], TransactionContext identify [{}]", imageUrn.toString(SERIALIZATION_FORMAT.NATIVE), TransactionContextFactory.get().getDisplayIdentity());
		
		try
		{
			ExchangeProxy proxy = getProxy(null);
			return getImage(imageUrn, requestFormatQualityList, proxy);
		}
		catch(IOException ioX)
		{
			String msg = "AbstractExchangeImageDataSourceService.getImage(2) --> IOException for Image URN [" + imageUrn.toString(SERIALIZATION_FORMAT.NATIVE) + "]: " + ioX.getMessage();
			LOGGER.error(msg);
			throw new MethodRemoteException(msg, ioX);
		}		
	}
	
	private ImageStreamResponse getImage(
		ImageURN imageUrn, 
		ImageFormatQualityList requestFormatQualityList, 
		ExchangeProxy proxy) 
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
			ExchangeDataSourceCommon.setDataSourceMethodAndVersion("getImage", getDataSourceVersion());
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

	protected ExchangeSiteConfiguration getExchangeSiteConfiguration(String alienSiteNumber)
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
	
	protected ExchangeProxyServices getExchangeProxyServices(String alienSiteNumber)
	throws IOException
	{
		if(exchangeProxyServices == null)
		{
			boolean isAlienSiteNumber = false;
			String host = exchangeConnection.getURL().getHost();
			int port = exchangeConnection.getURL().getPort();
			ExchangeSiteConfiguration exchangeSiteConfiguration = getExchangeSiteConfiguration(alienSiteNumber);
			if(exchangeSiteConfiguration.containsHostAndPort())
			{
				host = exchangeSiteConfiguration.getHost();
				port = exchangeSiteConfiguration.getPort();
				isAlienSiteNumber = true;
			}
			exchangeProxyServices = 
				ExchangeProxyUtilities.getExchangeProxyServices(exchangeSiteConfiguration, 
						createUniqueSiteNumber(exchangeSiteConfiguration),
						EXCHANGE_PROXY_SERVICE_NAME, getDataSourceVersion(), 
						host, 
						port, 
						isAlienSiteNumber ? alienSiteNumber : null);
		}
		return exchangeProxyServices;
	}
	
	/**
	 * This method returns a unique site number so IDS can properly cache the site results uniquely
	 * the concern is if the VIX is querying an alien site (PACSi) for IDS, it shouldn't store that
	 * in the IDS cache under site 200 (200 should be the BIA).
	 * 
	 * if the exchangesiteconfiguration is for site 200 (BIA), then 200 is not prepended
	 * 
	 * 
	 * @param exchangeSiteConfiguration
	 * @return
	 */
	private String createUniqueSiteNumber(ExchangeSiteConfiguration exchangeSiteConfiguration)
	{
		if(ExchangeConfiguration.DEFAULT_BIA_SITE.equals(exchangeSiteConfiguration.getSiteNumber()))
			return exchangeSiteConfiguration.getSiteNumber();
		return ExchangeConfiguration.DEFAULT_BIA_SITE + "_" + exchangeSiteConfiguration.getSiteNumber();
	}
	
	protected String getResolvedArtifactSourceString()
	{
		ArtifactSource artifactSource = getResolvedArtifactSource().getArtifactSource();
		return artifactSource.getHomeCommunityId() + ", " + artifactSource.getRepositoryId();	
	}
}
