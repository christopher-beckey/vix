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
package gov.va.med.imaging.mixdatasource;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
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
import gov.va.med.imaging.exchange.storage.DataSourceImageInputStream;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;
import gov.va.med.imaging.mix.DODImageURN;
import gov.va.med.imaging.mix.proxy.v1.ImageMixProxy;
import gov.va.med.imaging.mix.proxy.v1.ImageMixProxyFactory;
import gov.va.med.imaging.mix.rest.proxy.AbstractMixRestImageProxy;
import gov.va.med.imaging.mix.rest.proxy.MixRestGetClient;
import gov.va.med.imaging.mix.webservices.rest.endpoints.MixImageWADORestUri;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.mixs.MIXsConnection;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;
import gov.va.med.imaging.url.mix.configuration.MIXSiteConfiguration;
import gov.va.med.imaging.url.mix.exceptions.MIXConfigurationException;
import gov.va.med.imaging.url.mix.exceptions.MIXConnectionException;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import gov.va.med.logging.Logger;

import com.sun.jersey.api.client.ClientResponse;

//import com.sun.jersey.api.client.ClientResponse;

//import com.sun.jersey.api.client.ClientResponse;

/**
 * @author VHAISWWERFEJ
 *
 */
public class MixImageDataSourceService 
extends AbstractVersionableDataSource
implements ImageDataSourceSpi
{
	
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
	
	private final MIXsConnection mixConnection;
	private MIXConfiguration mixConfiguration = null;
	private MIXSiteConfiguration mixSiteConfiguration = null;
	private AbstractMixRestImageProxy amrip;

	
	// Hashmap to hold proxies based on the alien site number (if empty string, will return proxy to BIA), otherwise will use wormhole.
	private HashMap<String, ImageMixProxy> xchangeProxies = new HashMap<String, ImageMixProxy>();
	
	private final static Logger logger = Logger.getLogger(MixImageDataSourceService.class);
	// private final static String MIX_PROXY_SERVICE_NAME = "MIX";
	private final static String DATASOURCE_VERSION = "1";
//	public final static String SUPPORTED_PROTOCOL = "mix";
	
	/**
     * The Provider will use the create() factory method preferentially
     * over a constructor.  This allows for caching of VistaStudyGraphDataSourceService
     * instances according to the criteria set here.
     * 
     * @param url
     * @param protocol
     * @return
     * @throws ConnectionException
     * @throws UnsupportedProtocolException 
     */
    public static MixImageDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
    throws ConnectionException, UnsupportedProtocolException
    {
    	return new MixImageDataSourceService(resolvedArtifactSource, protocol);
    }
	
    /**
     * 
     * @param resolvedArtifactSource
     * @param protocol
     * @throws UnsupportedProtocolException if the ResolvedArtifactSource is not an instance of ResolvedSite
     */
	public MixImageDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol) 
	throws UnsupportedProtocolException
	{
		super(resolvedArtifactSource, protocol);		
		mixConnection = new MIXsConnection(getArtifactUrl());
		mixConfiguration = MixDataSourceProvider.getMixConfiguration();
	}	

	@Override
	public boolean isVersionCompatible() 
	{
		// nothing really to check
		return true;
	}

//	/* (non-Javadoc)
//	 * @see gov.va.med.imaging.datasource.ImageDataSourceSpi#getUrl()
//	 */
//	public URL getUrl() 
//	{
//		return mixConnection.getURL();
//	}
	
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
        logger.info("getImage({}) from Image object TransactionContext ({}).", image.getIen(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{			
			ImageMixProxy proxy = getProxy(image);
			ImageURN imageUrn = image.getImageUrn();
			//ImageURN imageUrn = ImageURN.create(image.getSiteNumber(), image.getIen(), image.getStudyIen(), image.getPatientICN());
			return getImage(imageUrn, requestFormatQualityList, proxy);
		}
		catch(IOException ioX)
		{
			logger.error("Error getting image", ioX);
			throw new MethodRemoteException(ioX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageDataSourceSpi#getImage(gov.va.med.imaging.ImageURN, int, java.lang.String)
	 * This is the main getImage call in MIX !!!
	 */
	@Override
	public ImageStreamResponse getImage(GlobalArtifactIdentifier gai, ImageFormatQualityList requestFormatQualityList) 
	throws MethodException, MIXConnectionException, ConnectionException
	{		
		// substitute if(!(gai instanceof ImageURN)) check
		DODImageURN dIU = new DODImageURN();
		if (!gai.toString().startsWith(dIU.getDODPrefix()))
		{
			throw new MethodException("GlobalArtifactIdentifier '" + gai.toString() + "' is not instanceof DODImageURN, cannot retrieve image from DAS.");
		}
		ImageURN imageUrn = (ImageURN)gai;
        logger.info("getImage({}) from Image URN TransactionContext ({}).", imageUrn.toString(), TransactionContextFactory.get().getDisplayIdentity());
		try
		{
			ImageMixProxy proxy = getProxy(null);
			return getImage(imageUrn, requestFormatQualityList, proxy);
		}
		catch(IOException ioX)
		{
			logger.error("Error getting image", ioX);
			throw new MethodRemoteException(ioX);
		}		
	}
	
	// this is the common MIX getImage client call
	private ImageStreamResponse getImage(
		ImageURN imageUrn, 
		ImageFormatQualityList requestFormatQualityList, 
		ImageMixProxy proxy) 
	throws MethodException, MIXConnectionException, ConnectionException
	{
		MixDataSourceCommon.setDataSourceMethodAndVersion("getImage", DATASOURCE_VERSION);
		String imageURN = imageUrn.toString(SERIALIZATION_FORMAT.NATIVE);
		if(proxy.getAlienSiteNumber() != null)
			TransactionContextFactory.get().addDebugInformation("Retrieving image from alien site number [" + proxy.getAlienSiteNumber() + "]");
        logger.info("MIX getImage: Retrieving image [{}] from site [{}]", imageURN, getResolvedArtifactSourceString());
		// get desired imageQuality
		ImageFormatQualityList prunedList = pruneRequestList(requestFormatQualityList);
		if (prunedList.size()==0)
		{
			String msg = "MIX getImage Error: No/Bad FormatQuality list received for  [" + imageURN + "] from site [" + getResolvedArtifactSourceString() + "]";
			logger.info(msg);
			throw new MethodException(msg);
		}
		ImageQuality iQ = prunedList.getFirstImageQuality();
		
		// compose URL to client
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		// urlParameterKeyValues.put("{routingToken}", routingToken.toRoutingTokenString());
		DODImageURN dodUrn = new DODImageURN(imageUrn);
		urlParameterKeyValues.put("{studyUid}", dodUrn.getStudyUID());
		urlParameterKeyValues.put("{seriesUid}", dodUrn.getSeriesUID());
		urlParameterKeyValues.put("{instanceUid}", dodUrn.getInstanceUID());

		MediaType mT = MediaType.APPLICATION_OCTET_STREAM_TYPE; // ?????
		
		String urlPath = MixImageWADORestUri.thumbnailPath;
		if (iQ == ImageQuality.REFERENCE) 
		{
			urlPath = MixImageWADORestUri.dicomJ2KReferencePath;
		}
		else if (iQ == ImageQuality.DIAGNOSTIC)
		{
			urlPath = MixImageWADORestUri.dicomJ2KDiagnosticPath;
		}
		String url="";
		try {
			url = amrip.getWebResourceUrl(urlPath, urlParameterKeyValues); 
		}
		catch (ConnectionException ce) {
			throw new MIXConnectionException("MIX getImage: Failed to connect to/compose URL source!" + ce.getMessage());
		}
		// send request to Client and check response
		MixRestGetClient getClient = new MixRestGetClient(url, mT, mixConfiguration);
		ImageStreamResponse imageStreamResponse= null;
		ClientResponse clientResponse=null;
		try{ // *** unsure how to get the stream!!!!
			clientResponse = getClient.executeRequest(ClientResponse.class); // ConnectionException & MethodException
			if (clientResponse.getClientResponseStatus() == ClientResponse.Status.OK) {
				imageStreamResponse = new ImageStreamResponse((DataSourceImageInputStream)clientResponse.getEntityInputStream(), iQ);
				imageStreamResponse.setMediaType(mT.toString());
			}
		}
		catch (ConnectionException ce) {
			throw new MIXConnectionException("MIX getImage: Failed to connect to Client!");
		}
		catch (MethodException me) {
			throw new MIXConnectionException("MIX getImage: Error getting Client response!" + me.getMessage());
		}
        return imageStreamResponse;
	}

	private MIXSiteConfiguration getMixSiteConfiguration(String alienSiteNumber)
	throws IOException
	{
//		MIXSiteConfiguration mixSiteConfiguration = null;
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
			mixSiteConfiguration = 
				MixDataSourceProvider.getMixConfiguration().getSiteConfiguration(primarySiteNumber, secondarySiteNumber);
		}
		catch(MIXConfigurationException ecX)
		{
			throw new IOException(ecX);
		}		
		return mixSiteConfiguration;
	}
	
	/*
	private ImageXChangeProxy getProxy()
	throws IOException
	{
		return getProxy(null);
	}
	*/
	
	private ImageMixProxy getProxy(Image image)
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
		MIXSiteConfiguration mixSiteConfiguration = getMixSiteConfiguration(alienSiteNumber);
		String host = mixConnection.getURL().getHost();
		int port = mixConnection.getURL().getPort();
		if(mixSiteConfiguration.containsHostAndPort())
		{
			host = mixSiteConfiguration.getHost();
			port = mixSiteConfiguration.getPort();
			isAlienSiteNumber = true;
		}
		ImageMixProxy proxy = ImageMixProxyFactory.getSingleton().get(
				host, 
				port, 
				mixSiteConfiguration,
				isAlienSiteNumber ? alienSiteNumber : null,
				MixDataSourceProvider.getMixConfiguration());	
		
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
		throw new UnsupportedOperationException("The MIX ImageDataSource does not support the getImageInformation method.");
	}

	@Override
	public String getImageSystemGlobalNode(AbstractImagingURN imagingUrn)
			throws UnsupportedOperationException, MethodException,
			ConnectionException, ImageNotFoundException {
		throw new UnsupportedOperationException("The MIX ImageDataSource does not support the getImageSystemGlobalNode method.");
	}
	
	@Override
	public String getImageDevFields(AbstractImagingURN imagingUrn, String flags)
	throws UnsupportedOperationException, MethodException,
		ConnectionException, ImageNotFoundException 
	{
		throw new UnsupportedOperationException("The MIX ImageDataSource does not support the getImageDevFields method.");
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
//		else if(quality == ImageQuality.DIAGNOSTICUNCOMPRESSED) -- retired for MIX!
//			return acceptableDiagnosticResponseTypes;
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
