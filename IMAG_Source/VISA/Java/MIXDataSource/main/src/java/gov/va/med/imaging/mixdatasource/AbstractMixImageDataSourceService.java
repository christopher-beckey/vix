/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Nov 11, 2016
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vacotittoc
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
import gov.va.med.imaging.exchange.storage.ByteBufferBackedImageInputStream;
import gov.va.med.imaging.exchange.storage.DataSourceInputStream;
import gov.va.med.imaging.mix.DODImageURN;
import gov.va.med.imaging.mix.proxy.MixProxy;
import gov.va.med.imaging.mix.proxy.v1.ImageMixProxy;
import gov.va.med.imaging.mix.proxy.v1.MixProxyServices;
import gov.va.med.imaging.mix.proxy.v1.MixProxyUtilities;
import gov.va.med.imaging.mix.rest.proxy.MixRestGetClient;
import gov.va.med.imaging.mix.webservices.rest.endpoints.MixImageWADORestUri;
import gov.va.med.imaging.mix.webservices.rest.endpoints.MixRestUri;
import gov.va.med.imaging.proxy.rest.RestProxyCommon;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.mixs.MIXsConnection;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;
import gov.va.med.imaging.url.mix.configuration.MIXSiteConfiguration;
import gov.va.med.imaging.url.mix.exceptions.MIXConfigurationException;
import gov.va.med.imaging.url.mix.exceptions.MIXConnectionException;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import gov.va.med.logging.Logger;

import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.ClientResponse.Status;


/**
 * @author vacotittoc
 *
 */
public abstract class AbstractMixImageDataSourceService
extends AbstractVersionableDataSource
implements ImageDataSourceSpi
{
	protected final MIXsConnection mixConnection;
	private MIXConfiguration mixConfiguration = null;
	private MIXSiteConfiguration mixSiteConfiguration = null;
	
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
	
	// Hashmap to hold proxies based on the alien site number (if empty string, will return proxy to BIA), otherwise will use wormhole.
	private HashMap<String, ImageMixProxy> xchangeProxies = new HashMap<String, ImageMixProxy>();

	private final static Logger logger = Logger.getLogger(AbstractMixImageDataSourceService.class);
	private final static String MIX_PROXY_SERVICE_NAME = "MIX";
	private final static String DATASOURCE_VERSION = "1";
	public final static String SUPPORTED_PROTOCOL = "mix";
	private MixProxyServices mixProxyServices = null;
	private TransactionContext transactionContext = TransactionContextFactory.get();

	@SuppressWarnings("unused")
	
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
	public AbstractMixImageDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol) 
	throws UnsupportedProtocolException
	{
		super(resolvedArtifactSource, protocol);
		mixConnection = new MIXsConnection(getArtifactUrl());
		mixConfiguration = MixDataSourceProvider.getMixConfiguration();
	}			
	
	protected Logger getLogger()
	{
		return logger;
	}
	
	protected abstract MixProxy getProxy(Image image)
	throws IOException;
	
//	@Override
	protected String getDataSourceVersion() {
		return DATASOURCE_VERSION;
	}

	//@Override
	public DataSourceInputStream getImageTXTFile(Image image)
	throws MethodException, ConnectionException
	{
		return null;
	}

	//@Override
	public DataSourceInputStream getImageTXTFile(ImageURN imageURN)
	throws UnsupportedOperationException, MethodException,
		ConnectionException, ImageNotFoundException, ImageNearLineException 
	{
		return null;
	}

	//@Override
	public String getImageInformation(AbstractImagingURN imagingUrn, boolean includeDeletedImages)
	throws UnsupportedOperationException, MethodException,
		ConnectionException, ImageNotFoundException 
	{
		throw new UnsupportedOperationException("AbstractMixImageDataSourceService --> class does not support the getImageInformation() method.");
	}

	//@Override
	public String getImageSystemGlobalNode(AbstractImagingURN imagingUrn)
			throws UnsupportedOperationException, MethodException,
			ConnectionException, ImageNotFoundException {
		throw new UnsupportedOperationException("AbstractMixImageDataSourceService class does not support the getImageSystemGlobalNode() method.");
	}
	
	//@Override
	public String getImageDevFields(AbstractImagingURN imagingUrn, String flags)
	throws UnsupportedOperationException, MethodException,
		ConnectionException, ImageNotFoundException 
	{
		throw new UnsupportedOperationException("AbstractMixImageDataSourceService class does not support the getImageDevFields() method.");
	}
	
	//@Override
	public ImageStreamResponse getImage(Image image, ImageFormatQualityList requestFormatQualityList) 
	throws MethodException, ConnectionException
	{
        logger.info("getImage(1)  --> Image IEN [{}] from TransactionContext [{}]", image.getIen(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{	
			
			return getImage(image.getImageUrn(), requestFormatQualityList, getProxy(image));
		}
		catch(IOException ioX)
		{
            logger.error("getImage(1) --> Image IEN [{}] --> Encountered IOException.", image.getIen(), ioX);
			throw new MethodRemoteException(ioX.getMessage(), ioX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ImageDataSourceSpi#getImage(gov.va.med.imaging.ImageURN, int, java.lang.String)
	 * This is the main getImage call in MIX !!!
	 */
	//@Override
	public ImageStreamResponse getImage(GlobalArtifactIdentifier gai, ImageFormatQualityList requestFormatQualityList) 
	throws MethodException, MIXConnectionException, ConnectionException
	{
		
		try {
			if ((gai == null) || (!gai.toString().startsWith(new DODImageURN().getDODPrefix()))) {
					throw new IOException("getImage(2) --> Given GlobalArtifactIdentifier is either null or not an instance of DODImageURN. Cannot retrieve the requested image from DoD.");
				}
				
				ImageURN imageUrn = (ImageURN) gai;

            logger.info("getImage(2) --> Image URN [{}] from TransactionContext [{}]", imageUrn.toString(), TransactionContextFactory.get().getDisplayIdentity());
			
				return imageUrn.toString().contains("useLocalImage") ? getImageTypeNotSupportedImage(imageUrn.toString(SERIALIZATION_FORMAT.NATIVE)) : getImage(imageUrn, requestFormatQualityList, getProxy(null));
				
			} catch(IOException ioX) {	
				// See log if this gets the same message twice????
				logger.error(ioX.getMessage(), ioX);
				throw new MethodRemoteException(ioX.getMessage(), ioX);
			}		
		
	}
	
	// this is the common MIX getImage client call
	// Quoc reworked logging and cleaned up a bit.
	private ImageStreamResponse getImage(
		ImageURN imageUrn, 
		ImageFormatQualityList requestFormatQualityList, 
		MixProxy proxy) 
	throws MethodException, MIXConnectionException, ConnectionException
	{
		MixDataSourceCommon.setDataSourceMethodAndVersion("getImage(3) --> Data Source version", getDataSourceVersion());
		
		String strImageURN = imageUrn.toString(SERIALIZATION_FORMAT.NATIVE);
		
		String aliSite = proxy.getAlienSiteNumber() != null ? proxy.getAlienSiteNumber() : MIXConfiguration.DEFAULT_DAS_SITE;
		
		String msg1 = "getImage(3) --> Retrieving image [" + strImageURN + "] from site [" + aliSite + "]";
		
		transactionContext.addDebugInformation(msg1);
		
		logger.info(msg1); msg1 = null;
		
		// get desired imageQuality
		ImageFormatQualityList prunedList = pruneRequestList(requestFormatQualityList);
		
		if (prunedList.size() == 0)
		{
			String msg = "getImage(3) --> Error: No/Bad FormaQuality list received for  [" + strImageURN + "] from site [" + aliSite + "]";
			logger.info(msg);
			throw new MethodException(msg);
		}
		
		ImageQuality iQ = prunedList.getFirstImageQuality();
		
		DODImageURN dodUrn = new DODImageURN(imageUrn);
		
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		
		urlParameterKeyValues.put("{studyUid}", dodUrn.getStudyUID());
		urlParameterKeyValues.put("{seriesUid}", dodUrn.getSeriesUID());
		urlParameterKeyValues.put("{instanceUid}", dodUrn.getInstanceUID());

		MediaType mT = 	MediaType.APPLICATION_OCTET_STREAM_TYPE; // ????? APPLICATION_OCTET_STREAM
		
		String urlPath = MixImageWADORestUri.thumbnailPath;
		
		if (iQ == ImageQuality.REFERENCE) 
		{
			urlPath = MixImageWADORestUri.dicomJ2KReferencePath;
		}
		else if (iQ == ImageQuality.DIAGNOSTIC)
		{
			urlPath = MixImageWADORestUri.dicomJ2KDiagnosticPath;
		}
		
		String url = null;
		
		try {
			url = getWebResourceUrl(urlPath, urlParameterKeyValues); 
		}
		catch (ConnectionException ce) {
			throw new MIXConnectionException("getWebResourceUrl() --> Failed to compose URL source! " + ce.getMessage());
		}
		
		ImageStreamResponse imageStreamResponse = null;

		ClientResponse clientResponse = new MixRestGetClient(url, mT, mixConfiguration).getInputStreamResponse();
		
		if(clientResponse.getStatus() == Status.OK.getStatusCode())
		{
			if(logger.isDebugEnabled()){logger.debug("MixRestGetClient.getInputStreamResponse() returned successfully !!!");}
			InputStream inputStream = clientResponse.getEntityInputStream();
				
			if (inputStream != null)
			{
				imageStreamResponse = new ImageStreamResponse(new ByteBufferBackedImageInputStream(inputStream, 0));
				imageStreamResponse.setImageQuality(iQ);
				imageStreamResponse.setMediaType(MediaType.APPLICATION_OCTET_STREAM);
				transactionContext.setDataSourceImageFormatReceived(imageStreamResponse.getImageFormat() == null ? "" : "" + imageStreamResponse.getImageFormat().toString());
				transactionContext.setDataSourceImageQualityReceived(imageStreamResponse.getImageQuality().toString());
			}
		}				

        return imageStreamResponse;
	}

	private ImageStreamResponse getImageTypeNotSupportedImage(String strImageURN) throws MethodException {
		
        if(logger.isDebugEnabled()){
            logger.debug("getImageTypeNotSupportedImage() --> Requested image URN [{}] comes from local drive; attempting to load from there...", strImageURN);}
           
        File imageTypeNotSupportedFile = new File(this.mixConfiguration != null ?  this.mixConfiguration.getImageTypeNotSupportedFile() : MIXConfiguration.DEFAULT_IMAGE_TYPE_NOT_SUPPORTED_FILE);
      
        if(logger.isDebugEnabled()){
            logger.debug("getImageTypeNotSupportedImage() --> Got imageTypeNotSupported file [{}]", imageTypeNotSupportedFile.getAbsolutePath());}
       
        // Load and return the image
        try {
            ImageStreamResponse imageStreamResponse = new ImageStreamResponse(new ByteBufferBackedImageInputStream(new FileInputStream(imageTypeNotSupportedFile), 0));
            imageStreamResponse.setImageQuality(ImageQuality.REFERENCE);
            imageStreamResponse.setMediaType(MediaType.APPLICATION_OCTET_STREAM);
            return imageStreamResponse;
        } catch (FileNotFoundException fnfe) {
            logger.error(fnfe.getMessage(), fnfe);
            throw new MethodException("Unable to return ImageTypeNotSupported image file: " +  fnfe.getMessage(), fnfe);
        }
    }

	protected MIXSiteConfiguration getMixSiteConfiguration(String alienSiteNumber)
	throws IOException
	{
		String repositoryId = alienSiteNumber; // *** hardcoded! *** getResolvedArtifactSource().getArtifactSource().getRepositoryId();
		String primarySiteNumber = repositoryId;
		String secondarySiteNumber = null;
		
		if((alienSiteNumber != null) && (alienSiteNumber.length() > 0))
		{
			secondarySiteNumber = repositoryId;
			primarySiteNumber = alienSiteNumber;
		}
		try 
		{
			mixSiteConfiguration = this.mixConfiguration.getSiteConfiguration(primarySiteNumber, secondarySiteNumber);
		}
		catch(MIXConfigurationException ecX)
		{
			logger.error(ecX.getMessage(), ecX);
			throw new IOException(ecX.getMessage(), ecX);
		}
		
		return mixSiteConfiguration;
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
	
	protected MixProxyServices getMixProxyServices(String alienSiteNumber)
	throws IOException
	{
		if(mixProxyServices == null)
		{
			boolean isAlienSiteNumber = false;
			String host = mixConnection.getURL().getHost();
			int port = mixConnection.getURL().getPort();
			MIXSiteConfiguration mixSiteConfiguration = getMixSiteConfiguration(alienSiteNumber);
			if(mixSiteConfiguration.containsHostAndPort())
			{
				host = mixSiteConfiguration.getHost();
				port = mixSiteConfiguration.getPort();
				isAlienSiteNumber = true;
			}
			mixProxyServices = 
				MixProxyUtilities.getMixProxyServices(mixSiteConfiguration, 
						createUniqueSiteNumber(mixSiteConfiguration),
						MIX_PROXY_SERVICE_NAME, getDataSourceVersion(), 
						host, 
						port, 
						isAlienSiteNumber ? alienSiteNumber : null);
		}
		return mixProxyServices;
	}
	
	/**
	 * This method returns a unique site number so IDS can properly cache the site results uniquely
	 * the concern is if the VIX is querying an alien site (PACSi) for IDS, it shouldn't store that
	 * in the IDS cache under site 200 (200 should be the DAS).
	 * 
	 * if the mixSiteConfiguration is for site 200 (DAS), then 200 is not prepended
	 * 
	 * 
	 * @param mixSiteConfiguration
	 * @return
	 */
	private String createUniqueSiteNumber(MIXSiteConfiguration mixSiteConfiguration)
	{
		if(MIXConfiguration.DEFAULT_DAS_SITE.equals(mixSiteConfiguration.getSiteNumber()))
			return mixSiteConfiguration.getSiteNumber();
		return MIXConfiguration.DEFAULT_DAS_SITE + "_" + mixSiteConfiguration.getSiteNumber();
	}
	
	protected String getRestServicePath()
	{
		return MixRestUri.mixRestUriV1;
	}
	
	protected ProxyServiceType getProxyServiceType()
	{
		return ProxyServiceType.image;
	}
	
	// ************* Quoc reworked from here to end **********************

	
	/**
	 * Get a web resource URL as a String to use in invocation.
	 * Reworked to include path to ECIA WADO and to base on site config object.
	 * 
	 * The "methodUri" param is for DoD and can be completely changed if ECIA is used.
	 * Keep it as is for backward compatibility.
	 * 
	 * @param String 				full path for UID replacements
	 * @param Map<String, String>	contains UIDs to replace place-holders in URI string
	 * @return String				fully composed URL included host, port and path with replacement values
	 * @throws ConnectionException	Wrapper exception for other exceptions
	 * 
	 */
	protected String getWebResourceUrl(String methodUri, Map<String, String> replacementUids) throws ConnectionException {
		
		if(logger.isDebugEnabled()){logger.debug("getWebResourceUrl() --> Getting a web resource URL........");}
		
		MIXSiteConfiguration siteConfig = null;
		
		try {
			if(this.mixConfiguration == null) {
				// Doesn't exist.  Assign a new one to have access to default values
				this.mixConfiguration = new MIXConfiguration();
				siteConfig = getDefaultSite();
			} else {
				// Don't want to use the already existed getMixSiteConfiguration() method above: cleaner
				// this way in terms of exception handling and loading default config
				siteConfig = getDestinationSite(this.mixConfiguration.useEcia() ? MIXConfiguration.DEFAULT_ECIA_WADO_SITE : MIXConfiguration.DEFAULT_DAS_SITE);
			}		
		} catch (MIXConfigurationException mce) {
			String msg = "getWebResourceUrl() --> Can't proceed because can't load the requested or default site.";
			if(logger.isDebugEnabled()){logger.debug(msg);}
			throw new ConnectionException(msg, mce);
		}
		
		String destinationUrl = getDestinationUrlString(siteConfig, methodUri, replacementUids);
		
		if(logger.isDebugEnabled()){
            logger.debug("getWebResourceUrl() --> Got a web resource URL [{}]", destinationUrl);}
		
		return destinationUrl;
	}
	
	/**
	 * Helper method to get a site config object that is based on a known
	 * site number. Works for either DoD or ECIA.
	 * 
	 * This looks very similar to the getDefaultSite() method. The difference is to start from a known
	 * site number, which is the same as the default site number, and try to get a site config from 
	 * the loaded configs instead of getting a site config with all the default values.  Could have config'ed
	 * a separate site number but we control this particular site number, it's overkill to do so.
	 * 
	 * @return MIXSiteConfiguration			found config based on a known site number or default
	 * @throws MIXConfigurationException	can't get either requested site or default
	 * 
	 */
	private MIXSiteConfiguration getDestinationSite(String siteNumber) throws MIXConfigurationException {
		
		if(logger.isDebugEnabled()){logger.debug("getDestinationSite() --> Getting destination site........");}
		
		MIXSiteConfiguration siteConfig = null;
		
		try {
			siteConfig = this.mixConfiguration.getSiteConfiguration(siteNumber, siteNumber);
		} catch (MIXConfigurationException mce) {
			if(logger.isDebugEnabled()){
                logger.debug("getDestinationSite() --> Requested site [{}] not found. Getting default...", siteNumber);}
			siteConfig = getDefaultSite();
		}
		
		if(logger.isDebugEnabled()){
            logger.debug("getDestinationSite() --> Got destination site [{}] for ECIA = {}", siteConfig, this.mixConfiguration.useEcia());}
		
		return siteConfig;
	}
	
	/**
	 * Helper method to get the default site config object for either DoD or ECIA
	 * 
	 * @param MIXConfiguration				MIX configuration object to operate from
	 * @return MIXSiteConfiguration			default site for either DoD or ECIA
	 * @throws MIXConfigurationException	can't get a default site
	 * 
	 */
	private MIXSiteConfiguration getDefaultSite() throws MIXConfigurationException {
		
		if(logger.isDebugEnabled()){logger.debug("getDefaultSite() --> Getting default site..........");}
		
		String siteNumber = null;
		
		if(this.mixConfiguration.useEcia()) {
			this.mixConfiguration.createDefaulEciatWadoSite();
			siteNumber = MIXConfiguration.DEFAULT_ECIA_WADO_SITE;
		} else {
			this.mixConfiguration.createDefaultDoDSite();
			siteNumber = MIXConfiguration.DEFAULT_DAS_SITE;
		}
		
		MIXSiteConfiguration siteConfig = this.mixConfiguration.getSiteConfiguration(siteNumber, siteNumber);
		
		if(logger.isDebugEnabled()){
            logger.debug("getDefaultSite() --> Got default site [{}] for ECIA = {}", siteConfig, this.mixConfiguration.useEcia());}
		
		return siteConfig;
	}
	
	/**
	 * Helper method to get a destination URL from a site config object
	 * 
	 * @param MIXSiteConfiguration		site config object to get values from	
	 * @param String 					full path for UID replacements
	 * @param Map<String, String>		contains UIDs to replace place-holders in URI string
	 * @return String					fully composed URL included host, port and path with replacement values
	 * 					
	 */
	private String getDestinationUrlString(MIXSiteConfiguration siteConfig, String methodUri, Map<String, String> replacementUids) {
		
		if(logger.isDebugEnabled()){logger.debug("getDestinationUrlString() --> Getting destination URL..........");}
		
		StringBuilder url= new StringBuilder();
		
		url.append(siteConfig.getProtocol() + "://");
		url.append(siteConfig.getHost());
		url.append(":");
		url.append(siteConfig.getPort());
		url.append("/");
		url.append(siteConfig.getMixApplication());
		url.append("/");
		
		String localUri = null;
		
		if(!this.mixConfiguration.useEcia()) {
			url.append(getRestServicePath());  // DoD specific
			url.append("/");
			localUri = methodUri;
		} else {
			localUri = MixImageWADORestUri.ecaiWadoUri;
		}
	
		url.append(RestProxyCommon.replaceMethodUriWithValues(localUri, replacementUids));	
		
		if(logger.isDebugEnabled()){
            logger.debug("getDestinationUrlString() --> Got destination URL [{}] for ECIA = {}", url, this.mixConfiguration.useEcia());}
		
		return url.toString();
	}
}


/* ORIGINAL version

protected String getWebResourceUrl(String methodUri, Map<String, String> urlParameterKeyValues)
throws ConnectionException
{
	StringBuilder url = new StringBuilder();
	//url.append("https://das-xxx.va.gov:443/haims/");
//	url.append(proxyServices.getProxyService(getProxyServiceType()).getConnectionURL()); // protocol://FQDN:port
	url.append(MIXConfiguration.defaultMIXProtocol + "://");
	boolean gotConfig = false;
	try
	{
		if ((this.mixConfiguration != null) &&
			(this.mixConfiguration.getSiteConfiguration(MIXConfiguration.DEFAULT_DAS_SITE, MIXConfiguration.DEFAULT_DAS_SITE) != null)) {
			MIXSiteConfiguration mixSiteConfig = this.mixConfiguration.getSiteConfiguration(MIXConfiguration.DEFAULT_DAS_SITE, MIXConfiguration.DEFAULT_DAS_SITE);
			url.append(mixSiteConfig.getHost() + ":" + mixSiteConfig.getPort() + "/" + mixSiteConfig.getMixApplication() + "/");
			gotConfig=true;
		}
	} catch(MIXConfigurationException mce) {
	}
	if (!gotConfig) {
		getLogger().debug("MIXClient WARNING: Using hardcoded DOD Configuration!!!");
		url.append(MIXConfiguration.defaultDODImageHost + ":"+ MIXConfiguration.defaultDODImagePort + "/" + MIXConfiguration.defaultDODXChangeApplication);
	}
	url.append(getRestServicePath());
	url.append("/");
	url.append(RestProxyCommon.replaceMethodUriWithValues(methodUri, urlParameterKeyValues));		
	
	getLogger().debug("MIXClient WebResourceUrl: " + url.toString());
	return url.toString();
}
*/