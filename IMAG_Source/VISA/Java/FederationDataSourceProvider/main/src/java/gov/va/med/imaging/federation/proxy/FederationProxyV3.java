/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 16, 2009
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
import java.util.List;
import java.util.SortedSet;
import java.util.zip.Checksum;

import javax.xml.rpc.ServiceException;
import javax.xml.rpc.Stub;

import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.methods.GetMethod;
import gov.va.med.logging.Logger;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.ImageURNFactory;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URN;
import gov.va.med.URNFactory;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.DateUtil;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageConversionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.PassthroughInputMethod;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.Requestor;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.vistarad.ActiveExams;
import gov.va.med.imaging.exchange.business.vistarad.Exam;
import gov.va.med.imaging.exchange.business.vistarad.ExamImages;
import gov.va.med.imaging.exchange.business.vistarad.PatientRegistration;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.translation.AbstractTranslator;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.exchange.utility.Base32ConversionUtility;
import gov.va.med.imaging.federation.webservices.intf.v3.ImageFederationMetadata;
import gov.va.med.imaging.federation.webservices.translation.v3.Translator;
import gov.va.med.imaging.federation.webservices.types.v3.FederationMethodExceptionFaultType;
import gov.va.med.imaging.federation.webservices.types.v3.FederationSecurityCredentialsExpiredExceptionFaultType;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.ImageXChangeHttpCommonsSender;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.transactioncontext.TransactionContextHttpHeaders;
import gov.va.med.imaging.url.federation.exceptions.FederationMethodException;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationProxyV3 
extends AbstractFederationProxy 
implements IFederationProxy 
{
	// Registering the translator class allows other translators to use the translators
	// methods through reflection and type comparison.
	static
	{
		AbstractTranslator.registerTranslatorClass(gov.va.med.imaging.federation.webservices.translation.v3.Translator.class);
	}
	
	private final static Logger LOGGER = Logger.getLogger(FederationProxyV3.class);

	private ImageFormatQualityList currentImageFormatQualityList = null;

	public FederationProxyV3(ProxyServices proxyServices, FederationConfiguration federationConfiguration)
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
            LOGGER.debug("FederationProxyV3.addOptionalGetInstanceHeaders() --> Adding content type with sub type header value [{}]", headerValue);
			getMethod.setRequestHeader(new Header(TransactionContextHttpHeaders.httpHeaderContentTypeWithSubType, 
				headerValue));
		}
	}
	
	private ImageFederationMetadata getImageMetadataService(ProxyServiceType proxyServiceType) 
	throws ConnectionException
	{
		try
		{
			URL localTestUrl = new URL(proxyServices.getProxyService(proxyServiceType).getConnectionURL());
			gov.va.med.imaging.federation.webservices.soap.v3.ImageMetadataFederationServiceLocator locator = 
				new gov.va.med.imaging.federation.webservices.soap.v3.ImageMetadataFederationServiceLocator();
			ImageFederationMetadata imageMetadata = locator.getImageMetadataFederationV3(localTestUrl);
			((org.apache.axis.client.Stub)imageMetadata).setTimeout(getMetadataTimeoutMs());
			return imageMetadata;
		}
		catch(MalformedURLException murlX)
		{
			String msg = "FederationProxyV3.getImageMetadataService() --> Error creating URL to access service: " + murlX.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, murlX);
		}
		catch(ServiceException sX)
		{
			String msg = "FederationProxyV3.getImageMetadataService() --> Encountered service exception: " +  sX.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(msg, sX);
		}
	}
	
	private void setMetadataCredentials(ImageFederationMetadata imageMetadata, ProxyServiceType proxyServiceType)
	{
		try
		{
			ProxyService metadataService = proxyServices.getProxyService(ProxyServiceType.metadata);
			
			System.out.println("Metadata parameters is " + (metadataService == null ? "NULL" : "NOT NULL") );
			
			System.out.println("UID = '" + metadataService.getUid() + "'.");
			System.out.println("PWD = '" + metadataService.getCredentials() + "'.");
			
			if(metadataService.getUid() != null)
				((Stub)imageMetadata)._setProperty(Stub.USERNAME_PROPERTY, metadataService.getUid());
			
			if(metadataService.getCredentials() != null)
				((Stub)imageMetadata)._setProperty(Stub.PASSWORD_PROPERTY, metadataService.getCredentials());
		
		}
		catch(ProxyServiceNotFoundException psnfX)
		{
            LOGGER.warn("FederationProxyV3.setMetadataCredentials() --> Proxy service not found: {}", psnfX.getMessage());
		}
	}

	/**
	 * Override to encode the study and image IDs in Base32
	 */
	@Override
	public SizedInputStream getInstance(
		String imageUrn, 
		ImageFormatQualityList requestFormatQualityList, 
		Checksum checksum, 
		boolean includeVistaSecurityContext) 
	throws ImageNearLineException, ImageNotFoundException, 
	SecurityCredentialsExpiredException, ImageConversionException, MethodException, ConnectionException
	{
		try
		{
			// JMW 3/15/2011 Patch 104
			// The patch 104 VIX/CVIX introduces new image formats to support (XLS, DOCX, etc). When making a request
			// to a patch 83 VIX if those new formats are included, it causes an exception (not really sure why).
			// To solve this issue, the new formats are removed from the request when being made from a P104 VIX to a P83 VIX
			List<ImageFormat> fedV3AllowedImageFormats = 
				federationConfiguration.getAllowedImageFormats().get(FederationConfiguration.federationVersion3Number);
			requestFormatQualityList.pruneToAllowedFormats(fedV3AllowedImageFormats);
			currentImageFormatQualityList = requestFormatQualityList;
			try
			{
				URN urn = URNFactory.create(imageUrn, SERIALIZATION_FORMAT.RAW);
				if(urn instanceof ImageURN)
				{
					urn = ImageURNFactory.create(((ImageURN) urn).getOriginatingSiteId(),
						Base32ConversionUtility.base32Encode( ((ImageURN) urn).getImageId() ), 
						Base32ConversionUtility.base32Encode( ((ImageURN) urn).getStudyId() ), 
						((ImageURN) urn).getPatientId(), 
						((ImageURN) urn).getImageModality(),
						ImageURN.class
					);
					imageUrn = urn.toString();
				}
			}
			catch (URNFormatException x)
			{
                LOGGER.warn("FederationProxyV3.getInstance() --> Exception creating ImageURN object from [{}]", imageUrn);
			}		
			return super.getInstance(imageUrn, requestFormatQualityList, checksum, includeVistaSecurityContext);
		}
		finally
		{
			currentImageFormatQualityList = null;
		}
	}	
	
	public String getExamRequisitionReport(StudyURN studyUrn)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getExamRequisitionReport() --> Transaction Id [{}] initiated for studyURN [{}]", transactionId, studyUrn.toString());
		setDataSourceMethodAndVersion("getExamRequisitionReport");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.vistaRadMetadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.vistaRadMetadata);
		String result = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			result = imageMetadata.getVistaRadRequisitionReport(transactionId, studyUrn.toString(SERIALIZATION_FORMAT.PATCH83_VFTP));
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getExamRequisitionReport() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getExamRequisitionReport() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new FederationMethodException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getExamRequisitionReport() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new FederationMethodException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
        LOGGER.info("FederationProxyV3.getExamRequisitionReport() --> Transaction Id [{}] returned response of length [{}] byte(s)", transactionId, result == null ? 0 : result.length());
		return result;
	}
	
	public String getExamRadiologyReport(StudyURN studyUrn)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getExamRequisitionReport() --> Transaction Id [{}] initiated for studyURN [{}]", transactionId, studyUrn.toString());
		setDataSourceMethodAndVersion("getExamRadiologyReport");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.vistaRadMetadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.vistaRadMetadata);
		String result = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			result = imageMetadata.getVistaRadRadiologyReport(transactionId, studyUrn.toString(SERIALIZATION_FORMAT.PATCH83_VFTP));
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getExamRequisitionReport() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getExamRequisitionReport() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new FederationMethodException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getExamRequisitionReport() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new ConnectionException(rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
        LOGGER.info("FederationProxyV3.getExamRequisitionReport() --> Transaction Id [{}] returned response of length [{}] byte(s)", transactionId, result == null ? 0 : result.length());
		return result;
	}
	
	public ActiveExams getActiveExams(Site site, String listDescriptor)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getActiveExams() --> Transaction Id [{}] initiated, list descriptor [{}] to site number [{}]", transactionId, listDescriptor, site.getSiteNumber());
		setDataSourceMethodAndVersion("getActiveExams");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.vistaRadMetadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.vistaRadMetadata);
		gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadActiveExamsType activeExams = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			activeExams = imageMetadata.getActiveWorklist(transactionId, site.getSiteNumber(), listDescriptor);

            LOGGER.info("FederationProxyV3.getActiveExams() --> Transaction Id [{}] returned [{}] active exams webservice object(s).", transactionId, activeExams == null ? "null" : "not null");
			ActiveExams result = gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(activeExams);
				//translator.transformActiveExams(activeExams);		
            LOGGER.info("FederationProxyV3.getActiveExams() --> Transaction Id [{}] returned [{}] active exams business object(s).", transactionId, result == null ? 0 : result.size());
			return result;
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getActiveExams() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getActiveExams() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getActiveExams() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}		
	}
	
	public ExamImages getExamImagesForExam(StudyURN studyUrn)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getExamImagesForExam() --> Transaction Id [{}] initiated for studyURN [{}]", transactionId, studyUrn.toString());
		setDataSourceMethodAndVersion("getExamImagesForExam");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.vistaRadMetadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.vistaRadMetadata);
		gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamImagesType examImagesType = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			String base32EncodedStudyUrn = studyUrn.toString(SERIALIZATION_FORMAT.PATCH83_VFTP);
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			examImagesType = imageMetadata.getExamImagesForExam(transactionId, base32EncodedStudyUrn);								
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getExamImagesForExam() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getExamImagesForExam() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getExamImagesForExam() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
		try
		{
            LOGGER.info("FederationProxyV3.getExamImagesForExam() --> Transaction Id [{}] returned [{}] exam images webservice object(s)", transactionId, examImagesType == null ? "null" : "not null");
			ExamImages result = gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(examImagesType); 
				// translator.transformExamImages(examImagesType);
            LOGGER.info("FederationProxyV3.getExamImagesForExam() --> Transaction Id [{}] returned [{}] exam images business object(s)", transactionId, result == null ? 0 : result.size());
			return result;
		}
		catch (URNFormatException urnFX)
		{
			String msg = "FederationProxyV3.getExamImagesForExam() --> Error translating exam image(s): " + urnFX.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg, urnFX);
		}
	}
	
	public Exam getExam(StudyURN studyUrn)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getExam() --> Transaction Id [{}] initiated for studyURN [{}]", transactionId, studyUrn.toString());
		setDataSourceMethodAndVersion("getExam");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.vistaRadMetadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.vistaRadMetadata);
		gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamType exam = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			String base32EncodedStudyUrn = studyUrn.toString(SERIALIZATION_FORMAT.PATCH83_VFTP);
            LOGGER.info("FederationProxyV3.getExam() --> studyURN base 32 encoded [{}]", base32EncodedStudyUrn);
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			exam = imageMetadata.getPatientExam(transactionId, base32EncodedStudyUrn);					
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getExam() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getExam() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getExam() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
		
		try
		{
            LOGGER.info("FederationProxyV3.getExam() --> Transaction Id [{}] returned [{}] exam webservice object(s)", transactionId, exam == null ? "null" : "not null");
			Exam result = gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(exam); 
				//translator.transformExam(exam);		
            LOGGER.info("getExam, Transaction [{}] returned [{}] patient exams business object(s)", transactionId, result == null ? "null" : "not null");
			return result;
		}
		catch (URNFormatException urnFX)
		{			
			String msg = "FederationProxyV3.getExamImagesForExam() --> Error translating exam(s): " + urnFX.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg, urnFX);
		}
	}
	
	public List<Exam> getExamsForPatient(Site site, String patientIcn,
			boolean fullyLoadExams)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getExamsForPatient() --> Transaction Id [{}] initiated for patient ICN [{}] to site number [{}]", transactionId, patientIcn, site.getSiteNumber());
		setDataSourceMethodAndVersion("getExamsForPatient");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.vistaRadMetadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.vistaRadMetadata);
		gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadExamType [] exams = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			exams = imageMetadata.getPatientExams(transactionId, site.getSiteNumber(), patientIcn, fullyLoadExams);					
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getExamsForPatient() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getExamsForPatient() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getExamsForPatient() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
		try
		{
            LOGGER.info("FederationProxyV3.getExamsForPatient() --> Transaction Id [{}] returned [{}] exams webservice object(s)", transactionId, exams == null ? "null" : "not null");
			List<Exam> result = gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(exams); 

				//translator.transformExams(exams);		
            LOGGER.info("FederationProxyV3.getExamsForPatient() --> Transaction Id [{}] returned [{}] patient exams business object(s)", transactionId, result == null ? "null" : result.size());
			return result;
		}
		catch (URNFormatException urnFX)
		{
			String msg = "FederationProxyV3.getExamsForPatient() --> Error translating exam(s): " + urnFX.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg, urnFX);
		}
	}
	
	public PatientRegistration getNextPatientRegistration(Site site)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getNextPatientRegistration() --> Transaction Id [{}] initiated, to site number [{}]", transactionId, site.getSiteNumber());
		setDataSourceMethodAndVersion("getNextPatientRegistration");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.vistaRadMetadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.vistaRadMetadata);
		gov.va.med.imaging.federation.webservices.types.v3.FederationVistaRadPatientRegistrationType patientRegistration = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			patientRegistration = imageMetadata.getNextPatientRegistration(transactionId, site.getSiteNumber());

            LOGGER.info("FederationProxyV3.getNextPatientRegistration() --> Transaction Id [{}] returned [{}] patient registration webservice object(s)", transactionId, patientRegistration == null ? "null" : "not null");
			PatientRegistration result = gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(patientRegistration);
            LOGGER.info("FederationProxyV3.getNextPatientRegistration() --> Transaction Id [{}] returned [{}] patient registration business object(s)", transactionId, result == null ? "null" : "not null");
			return result;
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getNextPatientRegistration() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getNextPatientRegistration() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getNextPatientRegistration() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
	}
	
	public String[] getRelevantPriorCptCodes(Site site, String cptCode)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getRelevantPriorCptCodes() --> Transaction Id [{}] initiated, cpt code [{}], to site number [{}]", transactionId, cptCode, site.getSiteNumber());
		setDataSourceMethodAndVersion("getRelevantPriorCptCodes");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.vistaRadMetadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.vistaRadMetadata);
		String [] cptCodes = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			cptCodes = imageMetadata.getRelevantPriorCptCodes(transactionId, cptCode, site.getSiteNumber());
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getRelevantPriorCptCodes() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getRelevantPriorCptCodes() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getRelevantPriorCptCodes() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}

        LOGGER.info("FederationProxyV3.getRelevantPriorCptCodes() --> Transaction Id [{}] returned [{}] cpt code(s)", transactionId, cptCodes == null ? 0 : cptCodes.length);
		return cptCodes;
	}
	
	public SortedSet<Study> getStudies(String patientIcn, StudyFilter filter, 
			String siteId, StudyLoadLevel studyLoadLevel)
	throws InsufficientPatientSensitivityException, MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();
		
		setDataSourceMethodAndVersion("getStudies");
        LOGGER.info("FederationProxyV3.getStudies() --> Transaction [{}] initiated", transactionId);
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.metadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.metadata);

		Requestor requestor = getRequestor();
		
		gov.va.med.imaging.federation.webservices.types.v3.StudiesType wsResult = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			
			gov.va.med.imaging.federation.webservices.types.v3.RequestorType rt = requestor == null ?
				new gov.va.med.imaging.federation.webservices.types.v3.RequestorType() : 
				new gov.va.med.imaging.federation.webservices.types.v3.RequestorType(
				requestor.getUsername(), 
				requestor.getSsn(), 
				requestor.getFacilityId(), 
				requestor.getFacilityName(), 
				gov.va.med.imaging.federation.webservices.types.v3.RequestorTypePurposeOfUse.value1);
				gov.va.med.imaging.federation.webservices.types.v3.FederationStudyLoadLevelType loadLevel = 
					gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(studyLoadLevel);
					//translator.transformStudyLoadLevel(studyLoadLevel);
		
			//StudyFilter filter = parameters.getFilter();
				
			// need to base 32 encode the study Id if it is included in the filter
			String studyId = null;
			if(filter.isStudyIenSpecified())
			{
				GlobalArtifactIdentifier gai = filter.getStudyId();
				if(gai instanceof StudyURN)
				{
					StudyURN studyUrn = (StudyURN)gai;
					studyId = Base32ConversionUtility.base32Encode(studyUrn.getStudyId());
                    LOGGER.info("FederationProxyV3.getStudies() --> Filter study Id [{}] converted to study Id [{}]", filter.getStudyId(), studyId);
				}
			}				
				
			gov.va.med.imaging.federation.webservices.types.v3.FederationFilterType ft = filter == null ? 
				new gov.va.med.imaging.federation.webservices.types.v3.FederationFilterType() : 
				new gov.va.med.imaging.federation.webservices.types.v3.FederationFilterType(
					filter.getStudy_package(), 
					filter.getStudy_class(), 
					filter.getStudy_type(), 
					filter.getStudy_event(), 
					filter.getStudy_specialty(), 
					filter.getFromDate() == null ? null : DateUtil.getShortDateFormat().format(filter.getFromDate()), 
					filter.getToDate() == null ? null : DateUtil.getShortDateFormat().format(filter.getToDate()),
					gov.va.med.imaging.federation.webservices.translation.v3.Translator.translateOrigin(filter.getOrigin()),				
							// translator.transformOrigin(filter.getOrigin()),
					studyId
				);
			
			wsResult = imageMetadata.getPatientStudyList(
				rt, 
				ft, 
				patientIcn, 
				transactionId, 
				siteId,
				BigInteger.valueOf(filter.getMaximumAllowedLevel().getCode()), 
				loadLevel);

            LOGGER.info("FederationProxyV3.getStudies() --> Transaction Id [{}] returned [{}] web service result(s)", transactionId, wsResult == null ? "null" : "not null");
			SortedSet<Study> result = 
				gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(wsResult, filter, patientIcn);
            LOGGER.info("FederationProxyV3.getStudies() --> Transaction Id [{}] returned [{}] study business object(s)", transactionId, result == null ? 0 : result.size());
			return result;
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getStudies() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getStudies() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getStudies() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		catch (TranslationException tX)
		{
			String msg = "FederationProxyV3.getStudies() --> Error translating study: " + tX.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg, tX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
	}
	
	public Study getStudyFromCprsIdentifier(Site site, String patientIcn,
			CprsIdentifier cprsIdentifier)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getStudyFromCprsIdentifier() --> Transaction Id [{}] initiated for patient ICN [{}] to site number [{}]", transactionId, patientIcn, site.getSiteNumber());
		setDataSourceMethodAndVersion("getStudyFromCprsIdentifier");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.metadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.metadata);
		gov.va.med.imaging.federation.webservices.types.v3.FederationStudyType studyType = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			
			studyType = imageMetadata.getStudyFromCprsIdentifier(patientIcn, transactionId, site.getSiteNumber(), cprsIdentifier.getCprsIdentifier());

            LOGGER.info("FederationProxyV3.getStudyFromCprsIdentifier() --> Transaction Id [{}] returned [{}] study webservice object(s)", transactionId, studyType == null ? "null" : "not null");
			Study result = gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(studyType);
				// translator.transformStudy(studyType);
            LOGGER.info("FederationProxyV3.getStudyFromCprsIdentifier() --> Transaction Id [{}] returned [{}] study business object(s)", transactionId, result == null ? "null" : "not null");
			return result;
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getStudyFromCprsIdentifier() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getStudyFromCprsIdentifier() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getStudyFromCprsIdentifier() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		catch (TranslationException tX)
		{
			String msg = "FederationProxyV3.getStudyFromCprsIdentifier() --> Error translating study: " + tX.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg, tX);
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

        LOGGER.info("FederationProxyV3.logImageAccessEvent() --> Transaction Id [{}] initiated, event Type [{}]", transactionId, logEvent.getEventType().toString());
		setDataSourceMethodAndVersion("logImageAccessEvent");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.metadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.metadata);
		
		boolean result = false;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			gov.va.med.imaging.federation.webservices.types.v3.FederationImageAccessLogEventType federationLogEvent =
				gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(logEvent);
				// translator.transformLogEvent(logEvent);
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			result = imageMetadata.postImageAccessEvent(transactionId, federationLogEvent);		
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.logImageAccessEvent() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.logImageAccessEvent() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.logImageAccessEvent() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}

        LOGGER.info("FederationProxyV3.logImageAccessEvent() --> Transaction Id [{}] logged image access event [{}]", transactionId, result == true ? "ok" : "failed");
		return result;
	}
	
	public SortedSet<Patient> searchPatients(Site site, String searchCriteria)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.searchPatients() --> Transaction Id [{}] initiated, search criteria [{}] to site number [{}]", transactionId, searchCriteria, site.getSiteNumber());
		setDataSourceMethodAndVersion("searchPatients");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.metadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.metadata);
		gov.va.med.imaging.federation.webservices.types.v3.PatientType[] patients = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			patients = imageMetadata.searchPatients(searchCriteria, transactionId, site.getSiteNumber());

            LOGGER.info("FederationProxyV3.searchPatients() --> Transaction Id [{}] returned [{}] patient webservice object(s)", transactionId, patients == null ? "null" : "not null");
			SortedSet<Patient> result = gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(patients);
				//translator.transformPatients(patients);
            LOGGER.info("searchPatients, Transaction [{}] returned response of [{}] patients business object(s)", transactionId, result == null ? "null" : result.size());
			return result;
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.searchPatients() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.searchPatients() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.searchPatients() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
	}
	
	public PatientSensitiveValue getPatientSensitiveValue(Site site, String patientIcn)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getPatientSensitiveValue() --> Transaction Id [{}] initiated, patient ICN [{}] to site number [{}]", transactionId, patientIcn, site.getSiteNumber());
		setDataSourceMethodAndVersion("getPatientSensitiveValue");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.metadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.metadata);
		gov.va.med.imaging.federation.webservices.types.v3.PatientSensitiveCheckResponseType patientSensitivity = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			patientSensitivity = imageMetadata.getPatientSensitivityLevel(transactionId, site.getSiteNumber(), patientIcn);

            LOGGER.info("FederationProxyV3.getPatientSensitiveValue() --> Transaction Id [{}] returned [{}] patient sensitivity webservice object", transactionId, patientSensitivity == null ? "null" : "not null");
			PatientSensitiveValue result = gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(PatientSensitiveValue.class, patientSensitivity);
				//translator.transformPatientSensitiveValue(patientSensitivity);
            LOGGER.info("FederationProxyV3.getPatientSensitiveValue() --> Transaction Id [{}] returned sensitive code of [{}] business object", transactionId, result == null ? "null" : result.getSensitiveLevel().getCode());
			return result;
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getPatientSensitiveValue() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getPatientSensitiveValue() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getPatientSensitiveValue() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		catch (TranslationException tX)
		{
			String msg = "FederationProxyV3.getPatientSensitiveValue() --> Error translating patient sensitivity: " + tX.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg, tX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
	}
	
	public List<String> getPatientSitesVisited(Site site, String patientIcn)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getPatientSitesVisited() --> Transaction Id [{}] initiated, patient ICN '{}] to site number [{}]", transactionId, patientIcn, site.getSiteNumber());
		setDataSourceMethodAndVersion("getPatientSitesVisited");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.metadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.metadata);
		String [] sites = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			sites = imageMetadata.getPatientSitesVisited(patientIcn, transactionId, site.getSiteNumber());

            LOGGER.info("FederationProxyV3.getPatientSitesVisited() --> Transaction Id [{}] returned [{}] site webservice object(s)", transactionId, sites == null ? "null" : "not null");
			List<String> result = gov.va.med.imaging.federation.webservices.translation.v3.Translator.translateSites(sites); 
				//translator.transformSiteNumbers(sites);
            LOGGER.info("FederationProxyV3.getPatientSitesVisited() --> Transaction Id [{}] returned [{}] site business object(s)", transactionId, result == null ? "null" : result.size());
			return result;
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getPatientSitesVisited() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getPatientSitesVisited() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getPatientSitesVisited() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		catch (TranslationException tX)
		{
			String msg = "FederationProxyV3.getPatientSitesVisited() --> Error translating site: " + tX.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg, tX);
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

        LOGGER.info("FederationProxyV3.getImageInformation() --> Transaction Id [{}] initiated, image URN [{}]", transactionId, imagingUrn.toString());
		setDataSourceMethodAndVersion("getImageInformation");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.metadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.metadata);
		String result = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			result = imageMetadata.getImageInformation(imagingUrn.toString(SERIALIZATION_FORMAT.PATCH83_VFTP), transactionId);
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getImageInformation() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getImageInformation() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getImageInformation() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
        LOGGER.info("FederationProxyV3.getImageInformation() --> Transaction Id [{}] returned response of length [{}] bytes(s)", transactionId, result == null ? "null" : result.length());
		return result;
	}
	
	public String getImageSystemGlobalNode(AbstractImagingURN imagingUrn)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getImageSystemGlobalNode() --> Transaction Id [{}] initiated, image URN [{}]", transactionId, imagingUrn.toString());
		setDataSourceMethodAndVersion("getImageSystemGlobalNode");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.metadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.metadata);
		String result = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			result = imageMetadata.getImageSystemGlobalNode(imagingUrn.toString(SERIALIZATION_FORMAT.PATCH83_VFTP), transactionId);
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getImageSystemGlobalNode() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getImageSystemGlobalNode() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getImageSystemGlobalNode() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
        LOGGER.info("FederationProxyV3.getImageSystemGlobalNode() --> Transaction Id [{}] returned response of length [{}] byte(s)", transactionId, result == null ? "null" : result.length());
		return result;
	}	
	
	public String getImageDevFields(AbstractImagingURN imagingUrn, String flags)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.getImageDevFields() --> Transaction Id [{}] initiated, image URN [{}]", transactionId, imagingUrn.toString());
		setDataSourceMethodAndVersion("getImageDevFields");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.metadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.metadata);
		String result = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());
			result = imageMetadata.getImageDevFields(imagingUrn.toString(SERIALIZATION_FORMAT.PATCH83_VFTP), flags, transactionId);
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.getImageDevFields() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.getImageDevFields() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.getImageDevFields() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);	
		}
        LOGGER.info("FederationProxyV3.getImageDevFields() --> Transaction Id [{}] returned response of length [{}] byte(s)", transactionId, result == null ? "null" : result.length());
		return result;
	}
	
	public String executePassthroughMethod(Site site, PassthroughInputMethod method)
	throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		String transactionId = transactionContext.getTransactionId();

        LOGGER.info("FederationProxyV3.executePassthroughMethod() --> Transaction Id [{}] initiated, method name [{}] to site number [{}]", transactionId, method.getMethodName(), site.getSiteNumber());
		setDataSourceMethodAndVersion("executePassthroughMethod");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.metadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.metadata);
		String result = null;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());			

			gov.va.med.imaging.federation.webservices.types.v3.FederationRemoteMethodParameterType[] parameters = 
				gov.va.med.imaging.federation.webservices.translation.v3.Translator.translate(method.getParameters());
				// translator.transformPassthroughMethodParameters(method.getParameters());
			
			result = imageMetadata.remoteMethodPassthrough(transactionId, site.getSiteNumber(), method.getMethodName(), parameters,	transactionContext.getImagingSecurityContextType());
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.executePassthroughMethod() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.executePassthroughMethod() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.executePassthroughMethod() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
        LOGGER.info("FederationProxyV3.executePassthroughMethod() --> Transaction Id [{}] returned [{}] byte(s) from webservice.", transactionId, result == null ? 0 : result.length());
		return result;
	}
	
	public boolean postExamAccess(Site site, String inputParameter)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        LOGGER.info("FederationProxyV3.postExamAccess() --> Transaction Id [{}] initiated to site number [{}]", transactionId, site.getSiteNumber());
		setDataSourceMethodAndVersion("postExamAccess");
		ImageFederationMetadata imageMetadata = getImageMetadataService(ProxyServiceType.vistaRadMetadata);
		
		// if the metadata connection parameters is not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		setMetadataCredentials(imageMetadata, ProxyServiceType.vistaRadMetadata);
		boolean result = false;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		try
		{
			// the 3rd piece of the string is the image URN, it must be base32 encoded to pass to a P83 VIX
			String encodedInputParameter = Translator.translateEncodeExamImageAccessInputParameter(inputParameter);
			if(encodedInputParameter == null)
				return false;
            LOGGER.info("FederationProxyV3.postExamAccess() --> Converted input parameter from [{}] into [{}]", inputParameter, encodedInputParameter);
			
			Thread.currentThread().setContextClassLoader(ImageXChangeHttpCommonsSender.class.getClassLoader());			
			result = imageMetadata.postVistaRadExamAccessEvent(transactionId, site.getSiteNumber(), encodedInputParameter);
		}
		catch(FederationSecurityCredentialsExpiredExceptionFaultType fsveXft)
		{
			String msg = "FederationProxyV3.postExamAccess() --> Error: " + fsveXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fsveXft);
		}
		catch(FederationMethodExceptionFaultType fmXft)
		{
			String msg = "FederationProxyV3.postExamAccess() --> Error: " + fmXft.getMessage1();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, fmXft);
		}
		catch(RemoteException rX)
		{
			// RemoteExceptions should not happen anymore unless major problem on server, use connection exception since it is safer for router
			String msg = "FederationProxyV3.postExamAccess() --> Error: " + rX.getMessage();
			LOGGER.error(msg);
			throw new SecurityCredentialsExpiredException(msg, rX);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
        LOGGER.info("FederationProxyV3.postExamAccess() --> Transaction Id [{}] returned [{}] from webservice.", transactionId, result);
		return result;
	}
	
	private Requestor getRequestor()
	{
		TransactionContext transactionContext = TransactionContextFactory.get();

		if(transactionContext != null)
			return new Requestor(transactionContext.getFullName(), transactionContext.getSsn(), 
					transactionContext.getSiteNumber(), transactionContext.getSiteName());
		return null;
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
		return "3";
	}
}
