package gov.va.med.imaging.exchange.proxy.v1;

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
import gov.va.med.imaging.exchange.proxy.ExchangeProxy;
import gov.va.med.imaging.exchange.webservices.soap.v1.ImageMetadata;
import gov.va.med.imaging.exchange.webservices.soap.v1.ImageMetadataServiceLocator;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.FilterType;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.RequestorType;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.RequestorTypePurposeOfUse;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType;
import gov.va.med.imaging.proxy.ImageXChangeHttpCommonsSender;
import gov.va.med.imaging.proxy.ImagingProxy;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.exchange.StudyParameters;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.exchange.configuration.ExchangeConfiguration;

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
public class ImageXChangeProxy
extends ImagingProxy
implements ExchangeProxy
{
	private static final Logger LOGGER = Logger.getLogger(ImageXChangeProxy.class);
	
	public final static String defaultImageProtocol = "http";
	private String alienSiteNumber;
	protected final ExchangeConfiguration exchangeConfiguration;

	
	public ImageXChangeProxy(ProxyServices proxyServices, String alienSiteNumber, 
			ExchangeConfiguration exchangeConfiguration)
	{
		super(proxyServices, true);
		this.alienSiteNumber = alienSiteNumber;
		this.exchangeConfiguration = exchangeConfiguration;
	}
	
	private ImageMetadata getImageMetadataService() 
	throws MalformedURLException, ServiceException, ProxyServiceNotFoundException
	{
		URL localTestUrl = new URL(proxyServices.getProxyService(ProxyServiceType.metadata).getConnectionURL());
		ImageMetadataServiceLocator locator = new ImageMetadataServiceLocator();
		ImageMetadata imageMetadata = locator.getImageMetadataV1(localTestUrl);
		
		return imageMetadata;
	}
	
	
	/**
	 * 
	 */
	private void setMetadataCredentials(ImageMetadata imageMetadata)
	{
		try
		{
			ProxyService metadataService = proxyServices.getProxyService(ProxyServiceType.metadata);
			
			if(metadataService.getUid() != null)
				((Stub)imageMetadata)._setProperty(Stub.USERNAME_PROPERTY, metadataService.getUid());
			
			if(metadataService.getCredentials() != null)
				((Stub)imageMetadata)._setProperty(Stub.PASSWORD_PROPERTY, metadataService.getCredentials());
		
		}
		catch(ProxyServiceNotFoundException psnfX)
		{
            LOGGER.warn("ImageXChangeProxy.setMetadataCredentials() --> Proxy not found for [{}]: {}", ProxyServiceType.metadata, psnfX.getMessage());
		}
	}
	
	/**
	 * Make a webservice call to get the studies that meet the filter criteria 
	 * 
	 * @param requestor
	 * @param filter
	 * @param patientIdentification
	 * @return
	 * @throws MalformedURLException
	 * @throws ServiceException
	 * @throws RemoteException
	 */
	public StudyResult getStudies(StudyParameters parameters)
	throws MalformedURLException, ServiceException, RemoteException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		ImageMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters are not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		// JMW 8/13/08 - set the connection socket timeout to 30 seconds (default of 600 seconds)
		((org.apache.axis.client.Stub)imageMetadata).setTimeout(exchangeConfiguration.getMetadataTimeout());
		
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
		Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
		StudyType[] studies = imageMetadata.getPatientStudyList(
				datasource, 
				rt, 
				ft, 
				parameters.getPatientId(), 
				transactionContext.getTransactionId()
		);
		Thread.currentThread().setContextClassLoader(loader);
        LOGGER.info("ImageXChangeProxy.getStudies() --> returned [{}] study(ies)", studies == null ? 0 : studies.length);
		
		return new StudyResult(transactionContext.getTransactionId(), studies);
	}
	
	/**
	 * Override the getInstance methods to instruct the real getInstance methods not to
	 * include the security context information
	 * @throws ProxyException 
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
	 * @throws ProxyException 
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

