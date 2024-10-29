package gov.va.med.imaging.mix.proxy.v1;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.imaging.DateUtil;
import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageConversionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.Requestor;
import gov.va.med.imaging.exchange.business.StudyFilter;
// import gov.va.med.imaging.mix.webservices.fhir.types.v1.StudyType;
import gov.va.med.imaging.mix.webservices.rest.exceptions.MIXMetadataException;
import gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorTypePurposeOfUse;
import gov.va.med.imaging.mix.webservices.rest.v1.ImageMetadata;
import gov.va.med.imaging.mix.proxy.MixProxy;
import gov.va.med.imaging.mixdatasource.MixDataSourceProvider;
// import gov.va.med.imaging.proxy.ImageXChangeHttpCommonsSender;
import gov.va.med.imaging.proxy.ImagingProxy;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.exchange.StudyParameters;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;

import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;
import java.util.zip.Checksum;

import javax.xml.rpc.ServiceException;
import javax.xml.rpc.Stub;

import org.apache.commons.httpclient.methods.GetMethod;
import gov.va.med.logging.Logger;

/**
 * The proxy that talks to the XChange interface of the ViXS server and the BHIE Image Adapter.
 * @author vhaiswbeckec
 *
 */
public class ImageMixProxy
extends ImagingProxy
implements MixProxy
{
	public final static String defaultImageProtocol = "https";
	private String alienSiteNumber; // supposed to be 200
	protected final MIXConfiguration mixConfiguration;
	Logger logger = Logger.getLogger(ImageMixProxy.class);
	
	public ImageMixProxy(ProxyServices proxyServices, String alienSiteNumber, 
			MIXConfiguration mixConfiguration)
	{
		super(proxyServices, true);
		this.alienSiteNumber = alienSiteNumber;
		this.mixConfiguration = mixConfiguration;
	}
	
	private ImageMetadata getImageMetadataService() 
	throws MalformedURLException, ServiceException, ProxyServiceNotFoundException
	{		
		ImageMixMetadataImpl imageMetadata = new ImageMixMetadataImpl(proxyServices, MixDataSourceProvider.getMixConfiguration());
		return imageMetadata;
	}
	
	/**
	 * 
	 * @deprecated use getStudies(StudyParameters parameters)
	 * 
	 * @param requestor
	 * @param filter
	 * @param patientIdentification
	 * @param sendSecurityContext
	 * @return
	 * @throws MalformedURLException
	 * @throws ServiceException
	 * @throws RemoteException
	 */
	/*
	public StudyResult getStudies(
			StudyFilter filter, 
			String patientIdentification) 
	throws MalformedURLException, ServiceException, RemoteException 
	{
		//DateFormat df = new SimpleDateFormat("yyyyMMddhhmmss.SSSSSSZ");
		StudyParameters parameters;
		parameters = new StudyParameters(
				patientIdentification, 
				filter.getFromDate(),
				filter.getToDate(),
				filter.getStudyId() );
		
		return getStudies(parameters);
	}*/
	
	/**
	 * 
	 */
	private void setMetadataCredentials(ImageMetadata imageMetadata)
	{
		try
		{
			ProxyService metadataService = proxyServices.getProxyService(ProxyServiceType.metadata);

            logger.info("Metadata parameters is {}", metadataService == null ? "NULL" : "NOT NULL");
            logger.info("UID = '{}'.", metadataService.getUid());
			
			if(metadataService.getUid() != null)
				((Stub)imageMetadata)._setProperty(Stub.USERNAME_PROPERTY, metadataService.getUid());
			
			if(metadataService.getCredentials() != null)
				((Stub)imageMetadata)._setProperty(Stub.PASSWORD_PROPERTY, metadataService.getCredentials());
		
		}
		catch(ProxyServiceNotFoundException psnfX)
		{
			logger.error(psnfX);
		}
	}
	
	/**
	 * Make a webservice call to get the studies that meet the filter criteria 
	 * 
	 * @param parameters /requestor, filter(from/toDate, studyURN?), patientIdentification/
	 * @return StudyResult
	 * @throws MalformedURLException
	 * @throws ServiceException
	 * @throws RemoteException
	 * @throws ConnectionException
	 */
	public StudyResult getStudies(StudyParameters parameters)
	throws MalformedURLException, ServiceException, RemoteException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();

        logger.info("MIXClient getStudies Transaction [{}] initiated ", transactionContext.getTransactionId());
		ImageMetadata imageMetadata = getImageMetadataService(); //  new ImageMetadata();
		
		// if the metadata connection parameters are not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		// JMW 8/13/08 - set the connection socket timeout to 30 seconds (default of 600 seconds)
		// CPT 11/14/16 - take care of this inside MIX call
		// ((org.apache.axis.client.Stub)imageMetadata).setTimeout(mixConfiguration.getMetadataTimeout());
		
		Requestor requestor = parameters.getRequestor();
		RequestorType rt = requestor == null ?
				new RequestorType() : 
				new RequestorType(
				requestor.getUsername(), 
				requestor.getSsn(), 
				requestor.getFacilityId(), 
				requestor.getFacilityName(), 
				RequestorTypePurposeOfUse.value1);
		
		StudyFilter filter = parameters.getFilter();
		StudyURN studyUrn = (StudyURN)filter.getStudyId();
		FilterType ft = filter == null ? 
			new FilterType() : 
			new FilterType(
				filter.getFromDate() == null ? null : DateUtil.getDicomDateFormat().format(filter.getFromDate()), 
				filter.getToDate() == null ? null : DateUtil.getDicomDateFormat().format(filter.getToDate()), 
				studyUrn == null ? null : studyUrn.toString(SERIALIZATION_FORMAT.CDTP));
		
		String datasource = parameters.getDatasource();
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		// Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
		ReportStudyListResponseType studies = null;
		try {
			studies = imageMetadata.getPatientReportStudyList(
					datasource, 
					rt, 
					ft, 
					parameters.getPatientId(), 
					true, // fullTree with study list
					transactionContext.getTransactionId(),
					getAlienSiteNumber()
					);
		}
		catch(MIXMetadataException rX)
		{
			logger.error("Error in MIX getPatientStudies", rX);
			throw new ConnectionException(rX);
		}
		Thread.currentThread().setContextClassLoader(loader);
        logger.info("MIXClient getStudies Transaction [{}] returned {} studies", transactionContext.getTransactionId(), studies == null ? 0 : studies.getStudies().length);
		
		return new StudyResult(transactionContext.getTransactionId(), studies);
	}
	
	/**
	 * Override the getInstance methods to instruct the real getInstance methods not to
	 * include the security context information
	 * @param imageURN
	 * @param requestFormatQualityList
	 * @return SizedInputStream
	 * @throws ImageNearLineException 
	 * @throws ImageNotFoundException 
	 * @throws SecurityCredentialsExpiredException 
	 * @throws ImageConversionException 
	 * @throws ConnectionException 
	 * @throws MethodException 
	 */
	public SizedInputStream getInstance(String imageUrn, ImageFormatQualityList requestFormatQualityList) 
	throws ImageNearLineException, ImageNotFoundException, 
	SecurityCredentialsExpiredException, ImageConversionException, ConnectionException, MethodException
	{
		return super.getInstance(imageUrn, requestFormatQualityList, false);
	}

	/**
	 * Override the getInstance methods to instruct the real getInstance methods not to
	 * include the security context information
	 * @param imageURN
	 * @param requestFormatQualityList
	 * @param checksum
	 * @return SizedInputStream
	 * @throws ImageNearLineException 
	 * @throws ImageNotFoundException 
	 * @throws SecurityCredentialsExpiredException 
	 * @throws ImageConversionException 
	 * @throws ConnectionException 
	 * @throws MethodException 
	 */
	public SizedInputStream getInstance(String imageUrn, ImageFormatQualityList requestFormatQualityList, Checksum checksum) 
	throws ImageNearLineException, ImageNotFoundException, 
	SecurityCredentialsExpiredException, ImageConversionException, ConnectionException, MethodException
	{
		return super.getInstance(imageUrn, requestFormatQualityList, checksum, false);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.proxy.ImagingProxy#addOptionalGetInstanceHeaders(org.apache.commons.httpclient.methods.GetMethod)
	 */
	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod) 
	{
		// not needed here
	}	
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.proxy.ImagingProxy#getInstanceRequestProxyServiceType()
	 */
	@Override
	protected ProxyServiceType getInstanceRequestProxyServiceType() 
	{
		return ProxyServiceType.image;
	}	
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.proxy.ImagingProxy#getTextFileRequestProxyServiceType()
	 */
	@Override
	protected ProxyServiceType getTextFileRequestProxyServiceType() 
	{
		return ProxyServiceType.text;
	}

	@Override
	public String getAlienSiteNumber()
	{
		return alienSiteNumber;
	}

	
}

