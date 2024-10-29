/**
 * 
 */
package gov.va.med.imaging.musedatasource.v1;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.MediaType;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.MuseImageURN;
import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.ImageStreamResponse;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.storage.ByteBufferBackedImageInputStream;
import gov.va.med.imaging.exchange.storage.DataSourceImageInputStream;
import gov.va.med.imaging.muse.proxy.rest.v1.MuseImageRestProxyV1;
import gov.va.med.imaging.musedatasource.AbstractMuseImageDataSourceService;
import gov.va.med.imaging.musedatasource.MuseDataSourceProvider;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.muse.MuseConnection;

import java.util.Iterator;


/**
 * @author William Peterson
 *
 */
public class MuseImageDataSourceServiceV1 
extends AbstractMuseImageDataSourceService {

	
	private final static String DATASOURCE_VERSION = "1";

	private MuseImageRestProxyV1 proxy = null;
	private final MuseConnection museConnection;

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public MuseImageDataSourceServiceV1(
			ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
		
		museConnection = new MuseConnection(getMetadataUrl());

	}

	@Override
	protected String getDataSourceVersion() {
		return DATASOURCE_VERSION;
	}

	
	@Override
	protected MuseImageRestProxyV1 getProxy(MuseServerConfiguration museServer)
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getProxyServices(museServer);
			if(proxyServices == null)
				throw new ConnectionException("Did not receive any applicable services for site [" + getSite().getSiteNumber() + "]");
			proxy = new MuseImageRestProxyV1(proxyServices,
					MuseDataSourceProvider.getMuseConfiguration(), museServer, false);
		}
		return proxy;
	}


	//WFP-Implement this correctly.
	@Override
	public boolean isVersionCompatible() {
		return true;
	}

	@Override
	protected boolean canGetTextFile() {
		//Muse don't have text files.  Always false.
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.musedatasource.AbstractMuseImageDataSourceService#getImage(gov.va.med.GlobalArtifactIdentifier, gov.va.med.imaging.exchange.business.ImageFormatQualityList)
	 */
	@Override
	public ImageStreamResponse getImage(GlobalArtifactIdentifier gai,
			ImageFormatQualityList requestFormatQualityList)
			throws MethodException, ConnectionException {
		
		if(!(gai instanceof MuseImageURN)){
			throw new MethodException("URN is not for Muse.");
		}
		MuseImageURN museImageUrn = (MuseImageURN)gai;
		String imageId = gai.toString(SERIALIZATION_FORMAT.RAW);
        getLogger().info("getImage({}) from GlobalArtifactIdentifier TransactionContext ({}).", imageId, TransactionContextFactory.get().getDisplayIdentity());
		
		ImageFormatQualityList queryFormatQualityList = new ImageFormatQualityList();
		queryFormatQualityList.addAll(requestFormatQualityList);
		
		MediaType mT = MediaType.APPLICATION_PDF;
		ImageQuality iQ = ImageQuality.DIAGNOSTICUNCOMPRESSED;

		String selectedMuseServerId = museImageUrn.getMuseServerId();
        getLogger().debug("Muse Server Id for Image: {}", selectedMuseServerId);
		MuseServerConfiguration museServer = null;
		Iterator<MuseServerConfiguration> iter = getMuseConfiguration().getServers().iterator();
		while(iter.hasNext()){
			MuseServerConfiguration temp = (MuseServerConfiguration)iter.next();
			int serverId = Integer.valueOf(selectedMuseServerId).intValue();
			if(temp.getId() == serverId){
				museServer = temp;
				break;
			}
		}
		
		SizedInputStream sistream = getProxy(museServer).getImage(museImageUrn, queryFormatQualityList);
		ByteBufferBackedImageInputStream bbbStream = new ByteBufferBackedImageInputStream(sistream.getInStream(), sistream.getByteSize());
		ImageStreamResponse response = new ImageStreamResponse((DataSourceImageInputStream)bbbStream, iQ);
		response.setMediaType(mT.toString());
				
		return response;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.musedatasource.AbstractMuseImageDataSourceService#getImage(gov.va.med.imaging.exchange.business.Image, gov.va.med.imaging.exchange.business.ImageFormatQualityList)
	 */
	@Override
	public ImageStreamResponse getImage(Image image,
			ImageFormatQualityList requestFormatQualityList)
			throws MethodException, ConnectionException {
		ImageURN imageUrn = image.getImageUrn();// ImageURN.create(image.getSiteNumber(), image.getIen(), image.getStudyIen(), image.getPatientICN());
		return getImage(imageUrn, requestFormatQualityList);
	}
}
