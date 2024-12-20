/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 4, 2008
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
package gov.va.med.imaging.federation.proxy;

import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;

import javax.xml.rpc.ServiceException;
import javax.xml.rpc.Stub;

import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.methods.GetMethod;
import gov.va.med.logging.Logger;

import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.DateUtil;
import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageConversionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.Requestor;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.federation.translator.FederationDatasourceTranslator;
import gov.va.med.imaging.federation.webservices.intf.ImageFederationMetadata;
import gov.va.med.imaging.federation.webservices.soap.ImageMetadataFederationServiceLocator;
import gov.va.med.imaging.federation.webservices.types.FederationFilterType;
import gov.va.med.imaging.federation.webservices.types.FederationImageAccessLogEventType;
import gov.va.med.imaging.federation.webservices.types.FederationStudyType;
import gov.va.med.imaging.federation.webservices.types.RequestorType;
import gov.va.med.imaging.federation.webservices.types.RequestorTypePurposeOfUse;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.ImageXChangeHttpCommonsSender;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.exchange.StudyParameters;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationProxy 
extends AbstractFederationProxy 
implements IFederationProxy
{
	private final static FederationDatasourceTranslator federationTranslator = new FederationDatasourceTranslator();
	private final static Logger LOGGER = Logger.getLogger(FederationProxy.class);

	private ImageFormatQualityList currentImageFormatQualityList = null;
	
	public FederationProxy(ProxyServices proxyServices, FederationConfiguration federationConfiguration)
	{
		super(proxyServices, federationConfiguration);
	}
	
	private ImageFederationMetadata getImageMetadataService() 
	throws MalformedURLException, ServiceException, ProxyServiceNotFoundException
	{
		URL localTestUrl = new URL(proxyServices.getProxyService(ProxyServiceType.metadata).getConnectionURL());
		ImageMetadataFederationServiceLocator locator = new ImageMetadataFederationServiceLocator();
		ImageFederationMetadata imageMetadata = locator.getImageMetadataFederation(localTestUrl);
		((org.apache.axis.client.Stub)imageMetadata).setTimeout(getMetadataTimeoutMs());
		return imageMetadata;
	}
	
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.proxy.ImagingProxy#addOptionalGetInstanceHeaders(org.apache.commons.httpclient.methods.GetMethod)
	 */
	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod) 
	{
		if(currentImageFormatQualityList != null)
		{
			String headerValue = currentImageFormatQualityList.getAcceptString(false, true);
            LOGGER.debug("FederationProxy.addOptionalGetInstanceHeaders() --> Adding content type with sub type header value [{}]", headerValue);
			getMethod.setRequestHeader(new Header(TransactionContextHttpHeaders.httpHeaderContentTypeWithSubType, 
				headerValue));
		}
	}	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.proxy.ImagingProxy#getInstance(java.lang.String, gov.va.med.imaging.exchange.business.ImageFormatQualityList, boolean)
	 */
	@Override
	public SizedInputStream getInstance(String imageUrn,
		ImageFormatQualityList requestFormatQualityList,
		boolean includeVistaSecurityContext) 
	throws ImageNearLineException, ImageNotFoundException, 
	SecurityCredentialsExpiredException, ImageConversionException, MethodException, ConnectionException
	{
		try
		{
			currentImageFormatQualityList = requestFormatQualityList;
			return super.getInstance(imageUrn, requestFormatQualityList,
					includeVistaSecurityContext);
		}
		finally 
		{
			currentImageFormatQualityList = null;
		}
	}
	
	private void setMetadataCredentials(ImageFederationMetadata imageMetadata)
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
            LOGGER.warn("FederationProxy.setMetadataCredentials() --> Proxy service not found: {}", psnfX.getMessage());
		}
	}

	public String getImageInformation(AbstractImagingURN imagingUrn)
	throws MalformedURLException, ServiceException, RemoteException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();

        LOGGER.info("FederationProxy.getImageInformation() --> Transaction Id [{}] initiated, image URN [{}]", transactionContext.getTransactionId(), imagingUrn.toString());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
		String result = imageMetadata.getImageInformation(imagingUrn.toString(), transactionContext.getTransactionId());
		Thread.currentThread().setContextClassLoader(loader);
        LOGGER.info("FederationProxy.getImageInformation() --> Transaction Id [{}] returned response of length [{}] bytes.", transactionContext.getTransactionId(), result == null ? "null" : result.length());
		return result;
	}
	
	public String getImageSystemGlobalNode(AbstractImagingURN imagingUrn)
	throws MalformedURLException, ServiceException, RemoteException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();

        LOGGER.info("FederationProxy.getImageSystemGlobalNode () --> Transaction Id [{}] initiated, image URN [{}]", transactionContext.getTransactionId(), imagingUrn.toString());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
		String result = imageMetadata.getImageSystemGlobalNode(imagingUrn.toString(), transactionContext.getTransactionId());
		Thread.currentThread().setContextClassLoader(loader);
        LOGGER.info("FederationProxy.getImageSystemGlobalNode() --> Transaction Id [{}] returned response of length [{}] bytes.", transactionContext.getTransactionId(), result == null ? "null" : result.length());
		return result;
	}	
	
	public String getImageDevFields(AbstractImagingURN imagingUrn, String flags)
	throws MalformedURLException, ServiceException, RemoteException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();

        LOGGER.info("FederationProxy.getImageDevFields --> Transaction Id [{}] initiated, image URN [{}]", transactionContext.getTransactionId(), imagingUrn.toString());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
		String result = imageMetadata.getImageDevFields(imagingUrn.toString(), flags, transactionContext.getTransactionId());
		Thread.currentThread().setContextClassLoader(loader);
        LOGGER.info("FederationProxy.getImageDevFields() --> Transaction Id [{}] returned response of length [{}] bytes.", transactionContext.getTransactionId(), result == null ? "null" : result.length());
		return result;
	}	
	
	public boolean logImageAccessEvent(ImageAccessLogEvent logEvent)
	throws MalformedURLException, ServiceException, RemoteException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();

        LOGGER.info("FederationProxy.logImageAccessEvent() --> Transaction Id [{}] initiated, event Type [{}]", transactionContext.getTransactionId(), logEvent.getEventType().toString());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		FederationImageAccessLogEventType federationLogEvent = federationTranslator.transformLogEvent(logEvent);
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
		boolean result = imageMetadata.postImageAccessEvent(transactionContext.getTransactionId(), federationLogEvent);
		Thread.currentThread().setContextClassLoader(loader);
        LOGGER.info("FederationProxy.logImageAccessEvent() --> Transaction Id [{}] logged image access event [{}]", transactionContext.getTransactionId(), result == true ? "ok" : "failed");
		return result;
	}
	
	public String[] getPatientSitesVisited(Site site, String patientIcn)
	throws MalformedURLException, ServiceException, RemoteException, ConnectionException 
	{
		TransactionContext transactionContext = TransactionContextFactory.get();

        LOGGER.info("FederationProxy.getPatientSitesVisited() --> Transaction Id [{}] initiated, patient ICN [{}] to site number [{}]", transactionContext.getTransactionId(), patientIcn, site.getSiteNumber());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
		String [] sites = imageMetadata.getPatientSitesVisited(patientIcn, transactionContext.getTransactionId(), site.getSiteNumber());
			
		Thread.currentThread().setContextClassLoader(loader);

        LOGGER.info("FederationProxy.getPatientSitesVisited() --> Transaction Id [{}] returned number of site(s) [{}]", transactionContext.getTransactionId(), sites == null ? 0 : sites.length);
		return sites;
	}
	
	public gov.va.med.imaging.federation.webservices.types.PatientType [] searchPatients(Site site, String searchCriteria)
	throws MalformedURLException, ServiceException, RemoteException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();

        LOGGER.info("FederationProxy.searchPatients() --> Transaction Id [{}] initiated, search criteria [{}] to site [{}]", transactionContext.getTransactionId(), searchCriteria, site.getSiteNumber());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
		gov.va.med.imaging.federation.webservices.types.PatientType[] patientsResult = imageMetadata.searchPatients(searchCriteria, transactionContext.getTransactionId(), site.getSiteNumber());	
		Thread.currentThread().setContextClassLoader(loader);
        LOGGER.info("FederationProxy.searchPatients() --> Transaction Id [{}] returned response of [{}] patient(s)", transactionContext.getTransactionId(), patientsResult == null ? 0 : patientsResult.length);
		return patientsResult;
	}
	
	public StudyResult getStudies(StudyParameters parameters, String siteId)
	throws MalformedURLException, ServiceException, RemoteException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();

        LOGGER.info("FederationProxy.getStudies() --> Transaction Id [{}] initiated", transactionContext.getTransactionId());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);

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
		FederationFilterType ft = filter == null ? 
			new FederationFilterType() : 
			new FederationFilterType(filter.getStudy_package(), 
					filter.getStudy_class(), 
					filter.getStudy_type(), 
					filter.getStudy_event(), 
					filter.getStudy_specialty(), 
					filter.getFromDate() == null ? null : DateUtil.getShortDateFormat().format(filter.getFromDate()), 
					filter.getToDate() == null ? null : DateUtil.getShortDateFormat().format(filter.getToDate()),
					federationTranslator.transformOrigin(filter.getOrigin()),
					"urn:bhiestudy:" + filter.getStudyId());		// yack!!!, what a hack.  The filter should contain a URN, not a string
		
		//String datasource = parameters.getDatasource();
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
		FederationStudyType[] studies = imageMetadata.getPatientStudyList(
				rt, 
				ft, 
				parameters.getPatientId(), 
				transactionContext.getTransactionId(), 
				siteId);		
		Thread.currentThread().setContextClassLoader(loader);
        LOGGER.info("FederationProxy.getStudies() --> Transaction [{}] returned [{}] study(ies)", transactionContext.getTransactionId(), studies == null ? 0 : studies.length);
		
		return new StudyResult(transactionContext.getTransactionId(), studies);
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
	protected String getDataSourceVersion()
	{
		return "1";
	}
}
