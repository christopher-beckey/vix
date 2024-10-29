/**
 * 
 */
package gov.va.med.imaging.muse.proxy.rest.v1;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.URN;
import gov.va.med.imaging.MuseImageURN;
import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageConversionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;
import gov.va.med.imaging.exchange.business.MuseOpenSessionResults;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.muse.proxy.rest.AbstractMuseImageRestProxy;
import gov.va.med.imaging.muse.proxy.rest.MuseRestPostClient;
import gov.va.med.imaging.muse.webservices.rest.endpoints.MuseRestUri;
import gov.va.med.imaging.muse.webservices.rest.translator.MuseRestTranslator;
import gov.va.med.imaging.muse.webservices.rest.type.image.request.MuseTestReportInputType;
import gov.va.med.imaging.muse.webservices.rest.type.image.response.MuseTestReportResultType;
import gov.va.med.imaging.musedatasource.configuration.MuseConfiguration;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.GetMethod;

/**
 * @author William Peterson
 *
 */
public class MuseImageRestProxyV1 
extends AbstractMuseImageRestProxy {

	private final static String MUSE_SERVER_VERSION = "8.0";
	private final static String RESTPROXY_VERSION = "1";
	private final static String PDFOUTPUT = "PDF";


	public MuseImageRestProxyV1(ProxyServices proxyServices,
			MuseConfiguration museConfiguration, MuseServerConfiguration museServer, boolean instanceUrlEscaped) {
		super(proxyServices, museConfiguration, museServer, instanceUrlEscaped);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseImageRestProxy#getFileLength()
	 */
	@Override
	public int getFileLength() {
		return 0;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseImageRestProxy#getImageChecksum()
	 */
	@Override
	public String getImageChecksum() {
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseImageRestProxy#getRequestedQuality()
	 */
	@Override
	public ImageQuality getRequestedQuality() {
		return ImageQuality.DIAGNOSTICUNCOMPRESSED;
	}

	@Override
	public String getRestProxyVersion() {
		return RESTPROXY_VERSION;
	}
	
	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseImageRestProxy#getMuseServerVersion()
	 */
	@Override
	public String getMuseServerVersion() {
		return MUSE_SERVER_VERSION;
	}

	@Override
	public String createImageUrl(String imageUrn,
			ImageFormatQualityList requestFormatQualityList)
			throws ProxyServiceNotFoundException {
		return super.createImageUrl(imageUrn, requestFormatQualityList);
	}

	@Override
	protected void addSecurityContextToHeader(HttpClient client,
			GetMethod getMethod, boolean includeVistaSecurityContext) {
		super.addSecurityContextToHeader(client, getMethod, includeVistaSecurityContext);
	}

	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod) {
		super.addOptionalGetInstanceHeaders(getMethod);
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMusePatientArtifactRestProxy#encodeGai(gov.va.med.GlobalArtifactIdentifier)
	 */
	@Override
	protected String encodeGai(GlobalArtifactIdentifier gai)
			throws MethodException {
		return super.encodeGai(gai);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMusePatientArtifactRestProxy#encodeString(java.lang.String)
	 */
	@Override
	protected String encodeString(String value) throws MethodException {
		return super.encodeString(value);
	}
	
	/**
	 * Converts test type description String into the appropriate reportFormatId value.
	 * An incorrect value will result in degraded image quality.
	 * 
	 * @param testType - The description String representing test type associated with the image
	 * 
	 * @return A String containing the reportFormatId value, defaults to "1" if type is null or unknown.
	 */
	private String getReportFormatIdForTestType(String testType) {
		String reportFormatId = "1";
		
		if (testType == null) {
            getLogger().debug("Using default reportFormatId ({}) for NULL testType", reportFormatId);
			return reportFormatId;
		}
		
		if (testType.toUpperCase().contains("RESTING")) {
			reportFormatId = "6";
		}
		else if (testType.toUpperCase().contains("STRESS")) {
			reportFormatId = "7";
		}
		else if (testType.toUpperCase().contains("HOLTER")) {
			reportFormatId = "8";
		}
		else if (testType.toUpperCase().contains("HIRES")) {
			reportFormatId = "9";
		}
		else if (testType.toUpperCase().contains("ZIO")) {
			reportFormatId = "16";
		}
		/*
		else if (testType.toUpperCase().contains("GENERAL")) {
			reportFormatId = "1";
		}
		*/

        getLogger().debug("Using reportFormatId '{}' for testType '{}'", reportFormatId, testType);
		return reportFormatId;
	}
	
	private String getImageKeyFromImageUrn(MuseImageURN museImageUrn) {
		final StringBuilder builder = new StringBuilder();
		
		builder.append(museImageUrn.getOriginatingSiteId());
		builder.append(URN.namespaceSpecificStringDelimiter);
		builder.append(museImageUrn.getGroupId());
		builder.append(URN.namespaceSpecificStringDelimiter);
		builder.append(museImageUrn.getPatientId());
		
		return builder.toString();
	}

	@Override
	public SizedInputStream getImage(MuseImageURN museImageUrn, ImageFormatQualityList requestFormatQualityList)
			throws ImageNearLineException, ImageNotFoundException,
			SecurityCredentialsExpiredException, ImageConversionException,
			MethodException, ConnectionException {
		
		MuseOpenSessionResults sessionResults = openMuseSession(museImageUrn.toRoutingTokenString());
        getLogger().debug("Muse Server # {} Session is now open.", museServer.getMuseSiteNumber());

		TransactionContext transactionContext = TransactionContextFactory.get();
        getLogger().info("getImage, Transaction [{}] initiated, getImage for {}' to '{}'.", transactionContext.getTransactionId(), museImageUrn, museImageUrn.toRoutingTokenString());
		setDataSourceMethodAndVersion("getImage V1");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		
		urlParameterKeyValues.put("{siteNumber}", getMuseServerConfiguration().getMuseSiteNumber());
		String url = getWebResourceUrl(getRestServicePath(), urlParameterKeyValues);
		MuseRestPostClient postClient = new MuseRestPostClient(url, MediaType.APPLICATION_XML_TYPE, 
				getMetadataTimeoutMs());
		
		StringBuffer buffer = new StringBuffer();
		buffer.append("tID=");
		buffer.append(museImageUrn.getGroupId());
		buffer.append(",vID=");
		buffer.append(museImageUrn.getImageId());
		
		final String key = getImageKeyFromImageUrn(museImageUrn);
		final String testType = MuseRestTranslator.findTestTypeForImageKey(key);
		
		final String reportFormatId = getReportFormatIdForTestType(testType);
		
		MuseTestReportInputType input = new MuseTestReportInputType();
		input.setOutputType(PDFOUTPUT);		
		input.setReportFormatId(reportFormatId);
		input.setTestId(buffer.toString());
		input.setToken(sessionResults.getBinaryToken());
		MuseTestReportResultType museResults = postClient.executeRequest(MuseTestReportResultType.class, input);
		if(museResults == null)
		{
			getLogger().error("Got null results with Muse GetTestReport request.");			
			return null;
		}
        getLogger().info("getImage, Transaction [{}] returned [{}] MuseArtifactResultsType.", transactionContext.getTransactionId(), museResults == null ? "null" : "not null");
		SizedInputStream result = null;
		try
		{
			result = MuseRestTranslator.translate(museResults);
			transactionContext.addDebugInformation(result == null ? "null Muse Image" : "received Muse image.");
		}
		catch(TranslationException tX)
		{
            getLogger().error("Error translating artifact results into business objects, {}", tX.getMessage(), tX);
			throw new MethodException(tX);			
		}
		finally{
			try{
				//Only close the session if the cache is disabled
				if(!museConfiguration.isEnableSessionCache()) {
					closeMuseSession(sessionResults, museImageUrn.toRoutingTokenString());
				}
			}
			catch(MethodException mX){
				getLogger().warn("Muse Server Session did not close properly.");
			}
			catch(ConnectionException cX){
				getLogger().warn("Muse Server Session did not close properly.");
			}

		}
        getLogger().info("getImage, Transaction [{}] returned response of [{}] SizedInputStream business object.", transactionContext.getTransactionId(), result == null ? "null" : "not null");
		return result;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseImageRestProxy#getRestServicePath()
	 */
	@Override
	protected String getRestServicePath() {
		return MuseRestUri.ImagePath;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMusePatientArtifactRestProxy#getWebResourceUrl(java.lang.String, java.util.Map)
	 */
	@Override
	public String getWebResourceUrl(String methodUri,
			Map<String, String> urlParameterKeyValues)
			throws ConnectionException {
		return super.getWebResourceUrl(methodUri, urlParameterKeyValues);
	}

	
	
	private MuseOpenSessionResults openMuseSession(String routingTokenString) throws MethodException, ConnectionException{
		MuseOpenUserSessionRestProxyV1 userSession = 
				new MuseOpenUserSessionRestProxyV1(proxyServices, getMuseConfiguration(),
						getMuseServerConfiguration(), instanceUrlEscaped);
		
		MuseOpenSessionResults results = userSession.openMuseSession(routingTokenString);
		
		return results;
		
	}

	private void closeMuseSession(MuseOpenSessionResults openResults, String routingTokenString) throws MethodException, ConnectionException{
		MuseCloseUserSessionRestProxyV1 userSession = 
				new MuseCloseUserSessionRestProxyV1(proxyServices, getMuseConfiguration(), 
						getMuseServerConfiguration(), instanceUrlEscaped);
				
		userSession.closeMuseSession(openResults, routingTokenString);
		return;
	}

}
