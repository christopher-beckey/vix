/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 4, 2009
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
package gov.va.med.imaging.federation.proxy;

import java.math.BigInteger;
import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;
import java.util.SortedSet;

import javax.xml.rpc.ServiceException;
import javax.xml.rpc.Stub;

import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.methods.GetMethod;
import gov.va.med.logging.Logger;

import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.DateUtil;
import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageConversionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.Requestor;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.federation.translator.FederationDatasourceTranslatorV2;
import gov.va.med.imaging.federation.webservices.intf.v2.ImageFederationMetadata;
import gov.va.med.imaging.federation.webservices.soap.v2.ImageMetadataFederationServiceLocator;
import gov.va.med.imaging.federation.webservices.types.v2.FederationFilterType;
import gov.va.med.imaging.federation.webservices.types.v2.FederationImageAccessLogEventType;
import gov.va.med.imaging.federation.webservices.types.v2.FederationStudyLoadLevelType;
import gov.va.med.imaging.federation.webservices.types.v2.FederationStudyType;
import gov.va.med.imaging.federation.webservices.types.v2.PatientSensitiveCheckResponseType;
import gov.va.med.imaging.federation.webservices.types.v2.RequestorType;
import gov.va.med.imaging.federation.webservices.types.v2.RequestorTypePurposeOfUse;
import gov.va.med.imaging.federation.webservices.types.v2.StudiesType;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.ImageXChangeHttpCommonsSender;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;

/**
 * This proxy should not be used for retrieving images - this is not currently supported by this proxy!
 * 
 * @author vhaiswwerfej
 *
 */
public class FederationProxyV2 
extends AbstractFederationProxy 
implements IFederationProxy
{
	private final static FederationDatasourceTranslatorV2 federationTranslator = 
		new FederationDatasourceTranslatorV2();
	
	private final static Logger LOGGER = Logger.getLogger(FederationProxyV2.class);
	
	private ImageFormatQualityList currentImageFormatQualityList = null;
	
	public FederationProxyV2(ProxyServices proxyServices, FederationConfiguration federationConfiguration)
	{
		super(proxyServices, federationConfiguration);
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
            LOGGER.debug("FederationProxyV2.addOptionalGetInstanceHeaders() --> Adding content type with sub type header value [{}]", headerValue);
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
	SecurityCredentialsExpiredException, ImageConversionException, ConnectionException, MethodException
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
	
	private ImageFederationMetadata getImageMetadataService() 
	throws ConnectionException
	{
		try
		{
			URL localTestUrl = new URL(proxyServices.getProxyService(ProxyServiceType.metadata).getConnectionURL());
			ImageMetadataFederationServiceLocator locator = new ImageMetadataFederationServiceLocator();
			ImageFederationMetadata imageMetadata = locator.getImageMetadataFederationV2(localTestUrl);
			((org.apache.axis.client.Stub)imageMetadata).setTimeout(getMetadataTimeoutMs());
			return imageMetadata;
		}
		catch(MalformedURLException murlX)
		{
			String msg = "FederationProxyV2.getImageMetadataService() --> Error creating URL to access service: " + murlX.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, murlX);
		}
		catch(ServiceException sX)
		{
			String msg = "FederationProxyV2.getImageMetadataService() --> Encountered service exception: " +  sX.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, sX);
		}
	}
	
	private Requestor getRequestor()
	{
		TransactionContext transactionContext = TransactionContextFactory.get();

		if(transactionContext != null)
			return new Requestor(transactionContext.getFullName(), transactionContext.getSsn(), transactionContext.getSiteNumber(), transactionContext.getSiteName());
		return null;
	}
	
	private void setMetadataCredentials(ImageFederationMetadata imageMetadata)
	{
		try
		{
			ProxyService metadataService = proxyServices.getProxyService(ProxyServiceType.metadata);
			
			System.out.println("Metadata parameters is " + (metadataService == null ? "NULL" : "NOT NULL") );
			
			System.out.println("UID = '" + metadataService.getUid() + "'.");
			System.out.println(StringUtil.cleanString("PWD = '" + metadataService.getCredentials() + "'."));
			
			if(metadataService.getUid() != null)
				((Stub)imageMetadata)._setProperty(Stub.USERNAME_PROPERTY, metadataService.getUid());
			
			if(metadataService.getCredentials() != null)
				((Stub)imageMetadata)._setProperty(Stub.PASSWORD_PROPERTY, metadataService.getCredentials());
		
		}
		catch(ProxyServiceNotFoundException psnfX)
		{
            LOGGER.warn("FederationProxyV2.setMetadataCredentials() --> Proxy service not found: {}", psnfX.getMessage());
		}
	}
	
	public SortedSet<Study> getStudies(String patientIcn, StudyFilter filter, 
			String siteId, StudyLoadLevel studyLoadLevel)
	throws InsufficientPatientSensitivityException, MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV2.getStudies() --> Transaction Id [{}] initiated", transactionId);
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);

		Requestor requestor = getRequestor();
		
		RequestorType rt = requestor == null ?
				new RequestorType() : 
				new RequestorType(
				requestor.getUsername(), 
				requestor.getSsn(), 
				requestor.getFacilityId(), 
				requestor.getFacilityName(), 
				RequestorTypePurposeOfUse.value1);
		FederationStudyLoadLevelType loadLevel = federationTranslator.transformStudyLoadLevel(studyLoadLevel);
		
		//StudyFilter filter = parameters.getFilter();
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
					"urn:bhiestudy:" + filter.getStudyId());
		StudiesType wsResult = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			wsResult = imageMetadata.getPatientStudyList(
					rt, 
					ft, 
					patientIcn, 
					transactionId, 
					siteId,
					BigInteger.valueOf(filter.getMaximumAllowedLevel().getCode()), 
					loadLevel);
		}
		catch(RemoteException rX)
		{
            LOGGER.error("FederationProxyV2.getStudies() --> Error:{}", rX.getMessage());
			translateRemoteException(rX);
			return null; // this will never happen because translateRemoteException always throws an exception
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}

        LOGGER.info("FederationProxyV2.getStudies() --> Transaction Id [{}] returned [{}] results", transactionId, wsResult == null ? "null" : "not null");
		return federationTranslator.transformStudies(wsResult, filter, patientIcn, studyLoadLevel);
	}
	
	public gov.va.med.imaging.federation.webservices.types.v2.PatientType [] searchPatients(
			Site site, String searchCriteria)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV2.searchPatients() --> Transaction Id [{}] initiated, search criteria [{}] to site number [{}]", transactionId, searchCriteria, site.getSiteNumber());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			gov.va.med.imaging.federation.webservices.types.v2.PatientType[] patientsResult = 
				imageMetadata.searchPatients(searchCriteria, transactionId, 
						site.getSiteNumber());
            LOGGER.info("FederationProxyV2.searchPatients() --> Transaction Id [{}] returned response of [{}] patient(s).", transactionId, patientsResult == null ? 0 : patientsResult.length);
			return patientsResult;
		}
		catch(RemoteException rX)
		{
            LOGGER.error("FederationProxyV2.searchPatients() --> Error: {}", rX.getMessage());
			translateRemoteException(rX);
			return null; // this will never happen because translateRemoteException always throws an exception
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
	}
	
	public FederationStudyType getStudyFromCprsIdentifier(Site site, String patientIcn,
		CprsIdentifier cprsIdentifier)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV2.getStudyFromCprsIdentifier() --> Transaction Id [{}] initiated, patient ICN [{}] to site number [{}]", transactionId, patientIcn, site.getSiteNumber());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			
			FederationStudyType studyType = 
				imageMetadata.getStudyFromCprsIdentifier(patientIcn, 
						transactionId, site.getSiteNumber(), 
						cprsIdentifier.getCprsIdentifier());
            LOGGER.info("FederationProxyV2.getStudyFromCprsIdentifier() --> Transaction Id [{}] returned [{}] study result", transactionId, studyType == null ? "null" : "not null");
			return studyType;		
		}
		catch(RemoteException rX)
		{
            LOGGER.error("FederationProxyV2.getStudyFromCprsIdentifier() --> Error: {}", rX.getMessage());
			translateRemoteException(rX);
			return null; // this will never happen because translateRemoteException always throws an exception
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}		
	}
	
	public PatientSensitiveCheckResponseType getPatientSensitiveValue(Site site, String patientIcn)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV2.getPatientSensitiveValue() --> Transaction Id [{}] initiated, patient ICN [{}] to site number [{}]", transactionId, patientIcn, site.getSiteNumber());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			PatientSensitiveCheckResponseType responseType = imageMetadata.getPatientSensitivityLevel(transactionId, site.getSiteNumber(), patientIcn);
            LOGGER.info("FederationProxyV2.getPatientSensitiveValue() --> Transaction Id [{}] returned sensitive code of [{}]", transactionId, responseType == null ? "null" : responseType.getPatientSensitivityLevel().getValue());
			return responseType;
		}
		catch(RemoteException rX)
		{
            LOGGER.error("FederationProxyV2.getPatientSensitiveValue() --> Error: {}", rX.getMessage());
			translateRemoteException(rX);
			return null; // this will never happen because translateRemoteException always throws an exception
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
	}

	public String[] getPatientSitesVisited(Site site, String patientIcn)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV2.getPatientSitesVisited() --> Transaction Id [{}] initiated, patient ICN [{}] to site number [{}]", transactionId, patientIcn, site.getSiteNumber());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			String [] sites = imageMetadata.getPatientSitesVisited(patientIcn, transactionId, site.getSiteNumber());
            LOGGER.info("FederationProxyV2.getPatientSitesVisited() --> Transaction Id [{}] returned [{}] site(s)", transactionId, sites == null ? 0 : sites.length);
			return sites;
		}
		catch(RemoteException rX)
		{
            LOGGER.error("FederationProxyV2.getPatientSitesVisited() --> Error: {}", rX.getMessage());
			translateRemoteException(rX);
			return null; // this will never happen because translateRemoteException always throws an exception
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
	}
	
	public boolean logImageAccessEvent(ImageAccessLogEvent logEvent)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV2.logImageAccessEvent() --> Transaction Id [{}] initiated, event Type [{}]", transactionId, logEvent.getEventType().toString());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		
		FederationImageAccessLogEventType federationLogEvent = federationTranslator.transformLogEvent(logEvent);
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			boolean result = imageMetadata.postImageAccessEvent(transactionId, federationLogEvent);
            LOGGER.info("FederationProxyV2.logImageAccessEvent() --> Transaction Id [{}] logged image access event [{}]", transactionId, result == true ? "ok" : "failed");
			return result;
		}
		catch(RemoteException rX)
		{
            LOGGER.error("FederationProxyV2.logImageAccessEvent() --> Error: {}", rX.getMessage());
			translateRemoteException(rX);
			return false; // this will never happen because translateRemoteException always throws an exception
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
	}	
	
	public String getImageInformation(AbstractImagingURN imagingUrn)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV2.getImageInformation() --> Transaction Id [{}] initiated, image URN [{}]", transactionId, imagingUrn.toString());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		String result = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			result = imageMetadata.getImageInformation(imagingUrn.toString(), transactionId);
		}
		catch(RemoteException rX)
		{
            LOGGER.error("FederationProxyV2.getImageInformation() --> Error: {}", rX.getMessage());
			translateRemoteException(rX);
			return null; // this will never happen because translateRemoteException always throws an exception
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
        LOGGER.info("FederationProxyV2.getImageInformation() --> Transaction Id [{}] returned response of length [{}] byte(s)", transactionId, result == null ? 0 : result.length());
		return result;
	}
	
	public String getImageSystemGlobalNode(AbstractImagingURN imagingUrn)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV2.getImageSystemGlobalNode() --> Transaction Id [{}] initiated, image URN [{}]", transactionId, imagingUrn.toString());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		String result = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			result = imageMetadata.getImageSystemGlobalNode(imagingUrn.toString(), transactionId);
		}
		catch(RemoteException rX)
		{
            LOGGER.error("FederationProxyV2.getImageSystemGlobalNode() --> Error: {}", rX.getMessage());
			translateRemoteException(rX);
			return null; // this will never happen because translateRemoteException always throws an exception
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
        LOGGER.info("getImageSystemGlobalNode, Transaction [{}] returned response of length [{}] byte(s)", transactionId, result == null ? 0 : result.length());
		return result;
	}	
	
	public String getImageDevFields(AbstractImagingURN imagingUrn, String flags)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV2.getImageDevFields() -->  Transaction Id [{}] initiated, image URN [{}]", transactionId, imagingUrn.toString());
		ImageFederationMetadata imageMetadata = getImageMetadataService();
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata);
		String result = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			result = imageMetadata.getImageDevFields(imagingUrn.toString(), flags, transactionId);
		}
		catch(RemoteException rX)
		{
            LOGGER.error("FederationProxyV2.getImageDevFields() --> Error: {}", rX.getMessage());
			translateRemoteException(rX);
			return null; // this will never happen because translateRemoteException always throws an exception
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);	
		}
        LOGGER.info("FederationProxyV2.getImageDevFields() --> Transaction Id [{}] returned response of length [{}] byte(s)", transactionId, result == null ? 0 : result.length());
		return result;
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
		return "2";
	}
}
