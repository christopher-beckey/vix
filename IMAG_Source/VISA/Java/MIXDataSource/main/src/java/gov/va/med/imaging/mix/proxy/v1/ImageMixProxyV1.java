/**
 * 
  Package: MAG - VistA Imaging
  Date Created: Dec 4, 2016
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
package gov.va.med.imaging.mix.proxy.v1;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;







// import gov.va.med.imaging.StudyURN;
// import gov.va.med.imaging.proxy.ImageXChangeHttpCommonsSender;
import com.sun.jersey.client.apache.ApacheHttpClient;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.ecia.scu.configuration.EciaDicomConfiguration;
import gov.va.med.imaging.dicom.ecia.scu.dto.StudyDTO;
import gov.va.med.imaging.dicom.ecia.scu.find.EciaFindSCU;
import gov.va.med.imaging.mix.webservices.rest.exceptions.MIXMetadataException;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorTypePurposeOfUse;
import gov.va.med.imaging.mix.webservices.rest.v1.ImageMetadata;
import gov.va.med.imaging.mix.webservices.translator.v1.MixTranslatorV1;
import gov.va.med.imaging.mix.proxy.MixProxy;
import gov.va.med.imaging.mixdatasource.MixDataSourceProvider;
import gov.va.med.imaging.proxy.ImagingProxy;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.services.ProxyService;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.mix.configuration.EciaDicomSiteConfiguration;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;

import java.util.List;

import javax.xml.rpc.Stub;

import org.apache.commons.httpclient.methods.GetMethod;

/**
 * @author vacotittoc
 *
 */
public class ImageMixProxyV1
extends ImagingProxy
implements MixProxy
{
	protected final MIXConfiguration mixConfiguration;
	protected final static String defaultDatasource = "200";
	
	public ImageMixProxyV1(ProxyServices proxyServices, MIXConfiguration mixConfiguration)
	{
		super(proxyServices, true);
		this.mixConfiguration = mixConfiguration;
	}
	
	protected gov.va.med.imaging.mix.webservices.rest.v1.ImageMetadata getImageMetadataService() 
//	throws ConnectionException
	{
//		try
//		{
			ImageMixMetadataImpl imageMetadata = new ImageMixMetadataImpl(proxyServices, MixDataSourceProvider.getMixConfiguration());
			return imageMetadata;		
//		}
//		catch(MalformedURLException murlX)
//		{
//			logger.error("Error creating URL to access service.", murlX);
//			throw new ConnectionException(murlX);
//		}
//		catch(ServiceException sX)
//		{
//			logger.error("Service exception." + sX);
//			throw new ConnectionException(sX);
//		}
	}

	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod)
	{
		// not needed here
	}

	@Override
	protected ProxyServiceType getInstanceRequestProxyServiceType()
	{
		return ProxyServiceType.image;
	}

	@Override
	protected ProxyServiceType getTextFileRequestProxyServiceType()
	{
		return ProxyServiceType.text;
	}	
	
	public String getStudyReport(String patientIcn,
			GlobalArtifactIdentifier studyId) 
	throws MethodException, ConnectionException
	{
		boolean useECIA = (this.mixConfiguration == null) ? (MIXConfiguration.DEFAULT_USE_ECIA) : (this.mixConfiguration.useEcia());

        logger.info("getStudyReport() --> switch to ECIA = {}", useECIA);
		
		if (useECIA) {
			return getStudyReportFromECIA(patientIcn, studyId);
		} else {
			return getStudyReportFromMIX(patientIcn, studyId);
		}
	}
	
	public String getStudyReportFromECIA(String patientIcn, GlobalArtifactIdentifier studyId) throws MethodException, ConnectionException
	{
		// Initialize the ECIA query class
		if(logger.isDebugEnabled()){logger.debug("getStudyReportFromECIA() --> Initializing EciaFindSCU");}
		EciaFindSCU eciaFindScu;
		try {
			EciaDicomSiteConfiguration eciaSiteConfig = (EciaDicomSiteConfiguration) this.mixConfiguration.getSiteConfiguration(MIXConfiguration.DEFAULT_ECIA_DICOM_SITE, MIXConfiguration.DEFAULT_ECIA_DICOM_SITE);			
			eciaFindScu = new EciaFindSCU(new EciaDicomConfiguration(eciaSiteConfig.getHost(), eciaSiteConfig.getPort(), eciaSiteConfig.getCallingAE(), eciaSiteConfig.getCalledAE(), eciaSiteConfig.getConnectTimeOut(), eciaSiteConfig.getCfindRspTimeOut()));
		} catch (Exception e) {
			throw new ConnectionException("Error retrieiving ECIA configuration", e);
		}
		
		// Get the study object
		if(logger.isDebugEnabled()){logger.debug("getStudyReportFromECIA() --> Getting the study object");}
		List<StudyDTO> studyDTOResults;
		try {
			studyDTOResults = eciaFindScu.getStudyByStudyUID(studyId.toString(SERIALIZATION_FORMAT.NATIVE), null, this.mixConfiguration);
		} catch (Exception e) {
			throw new ConnectionException("Error while querying ECIA for studyDTO", e);
		}
		
		// Handle no study being found
		if ((studyDTOResults == null) || (studyDTOResults.size() == 0)) {
			if(logger.isDebugEnabled()){logger.debug("getStudyReportFromECIA() --> No study object found");}
			return "1^^\nNo study was found and no report is available"; 
		}
		
		StudyDTO studyDTO = studyDTOResults.get(0);
		
		// Return the report contents with carets (^) replaced
		String reportText = (studyDTO.getReportTextValue() == null) ? ("No study report is available") : (studyDTO.getReportTextValue());
		return "1^^\n" + reportText.replaceAll("\\^", ",");
	}
	
	public String getStudyReportFromMIX(String patientIcn,
			GlobalArtifactIdentifier studyId) 
	throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();

        logger.info("Transaction [{}] initiated ", transactionContext.getTransactionId());
		// ImageMetadata imageMetadata = getImageMetadataService();
		ImageMixMetadataImpl imageMetadata = new ImageMixMetadataImpl(proxyServices, MixDataSourceProvider.getMixConfiguration()); // *** getImageMetadataService();

		
		// if the metadata connection parameters are not null and the metadata connection parameters
		// specifies a user ID then set the UID/PWD parameters as XML parameters, which should
		// end up as a BASIC auth parameter in the HTTP header
		// *** setMetadataCredentials(imageMetadata);
		
		// JMW 8/13/08 - set the connection socket timeout to 30 seconds (default of 600 seconds)
		// CPT 11/14/16 - take care of timeouts inside MIX call
		// ((org.apache.axis.client.Stub)imageMetadata).setTimeout(mixConfiguration.getMetadataTimeout());
		// ((org.apache.axis.client.Stub)imageMetadata).setTimeout(30000);
		RequestorType rt = 
				new RequestorType(
						transactionContext.getFullName(), 
						transactionContext.getSsn(), 
						transactionContext.getSiteNumber(), 
						transactionContext.getSiteName(), 
				RequestorTypePurposeOfUse.value1);		
		
		String datasource = defaultDatasource;
		ClassLoader loader = Thread.currentThread().getContextClassLoader();
		ReportType reportType = null;
		try
		{
			// StudyURN studyUrn = (StudyURN)studyId;
			String studyID = studyId.toString(SERIALIZATION_FORMAT.NATIVE); // expecting studyUID
			Thread.currentThread().setContextClassLoader(ApacheHttpClient.class.getClassLoader());
			reportType = 
				imageMetadata.getPatientReport(datasource, rt, patientIcn, studyID, // opaque identifier, instead of studyUrn.toString(SERIALIZATION_FORMAT.NATIVE));
						transactionContext.getTransactionId()); 
			
		}
		catch(MIXMetadataException mmde)
		{
			logger.error("Error in getPatientReport", mmde);
			throw new ConnectionException(mmde);
		}
		finally
		{
			Thread.currentThread().setContextClassLoader(loader);
		}
        logger.info("Transaction [{}] returned {} study report response", transactionContext.getTransactionId(), reportType == null ? "null report type" : "" + (reportType.getRadiologyReport() == null ? "null report" : "" + reportType.getRadiologyReport().length() + " bytes"));
		
		return MixTranslatorV1.translate(reportType);	
	}
	
	protected void setMetadataCredentials(ImageMetadata imageMetadata)
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
			logger.error(psnfX);
		}
	}
	
	public String getAlienSiteNumber()
	{
		if(proxyServices instanceof MixProxyServices)
		{
			MixProxyServices eps = (MixProxyServices)proxyServices;
			return eps.getAlienSiteNumber();
		}
		return null;
	}
}
