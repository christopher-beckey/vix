/**
 * 
 */
package gov.va.med.imaging.muse.proxy.rest.v1;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.MuseOpenSessionResults;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.muse.proxy.rest.AbstractMusePatientArtifactRestProxy;
import gov.va.med.imaging.muse.proxy.rest.MuseRestPostClient;
import gov.va.med.imaging.muse.webservices.rest.endpoints.MuseRestUri;
import gov.va.med.imaging.muse.webservices.rest.translator.MuseRestTranslator;
import gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.request.MuseOrderCriteriaInputType;
import gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.request.MuseOrderQueryCriteriaInputType;
import gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.request.MuseOrdersByCriteriaInputType;
import gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.response.MuseArtifactResultsType;
import gov.va.med.imaging.musedatasource.configuration.MuseConfiguration;
import gov.va.med.imaging.musedatasource.configuration.MuseServerConfiguration;
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
public class MusePatientArtifactRestProxyV1 
extends AbstractMusePatientArtifactRestProxy {

	private final static String MUSE_SERVER_VERSION = "8.0";
	private final static String RESTPROXY_VERSION = "1";
	

	public MusePatientArtifactRestProxyV1(ProxyServices proxyServices,
			MuseConfiguration museConfiguration, MuseServerConfiguration museServer, boolean instanceUrlEscaped) {
		super(proxyServices, museConfiguration, museServer, instanceUrlEscaped);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMuseProxy#getDataSourceVersion()
	 */
	@Override
	public String getRestProxyVersion() {
		return RESTPROXY_VERSION;
	}
	
	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMusePatientArtifactRestProxy#getPatientSSN(java.lang.String)
	 */
	@Override
	protected String getMusePatientId(String musePatientId) {
		return null;
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

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMusePatientArtifactRestProxy#getPatientArtifacts(java.lang.String, gov.va.med.imaging.exchange.business.StudyFilter, gov.va.med.RoutingToken, gov.va.med.imaging.exchange.enums.StudyLoadLevel, boolean, boolean)
	 */
	@Override
	public ArtifactResults getPatientArtifacts(Site site, PatientIdentifier patientIdentifier,
			StudyFilter filter, RoutingToken routingToken,
			StudyLoadLevel studyLoadLevel, boolean includeImages,
			boolean includeDocuments)
			throws InsufficientPatientSensitivityException, MethodException,
			ConnectionException {

		MuseOpenSessionResults sessionResults = openMuseSession(routingToken.toRoutingTokenString());
        getLogger().debug(" Muse Server # {} Session is now open.", museServer.getMuseSiteNumber());

		String musePatientId = StringUtil.removeNonNumericChars(filter.getMusePatientId());
		TransactionContext transactionContext = TransactionContextFactory.get();
        getLogger().info("getPatientArtifacts, Transaction [{}] initiated, patient '{}' to '{}'.", transactionContext.getTransactionId(), musePatientId, routingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("getPatientArtifacts V1");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		
		urlParameterKeyValues.put("{siteNumber}", getMuseServerConfiguration().getMuseSiteNumber());
		String url = getWebResourceUrl(getRestServicePath(), urlParameterKeyValues);
		MuseRestPostClient postClient = new MuseRestPostClient(url, MediaType.APPLICATION_XML_TYPE, 
				getMetadataTimeoutMs());

		MuseOrderQueryCriteriaInputType query = new MuseOrderQueryCriteriaInputType();
		query.setComparison("Equal");
		query.setField("PatientId");
		query.setQueriableTypeStr("MUSEAPIData.Test");
		query.setValue(musePatientId);
		MuseOrderCriteriaInputType criteria = new MuseOrderCriteriaInputType();
		criteria.setQuery(query);
		MuseOrdersByCriteriaInputType input = new MuseOrdersByCriteriaInputType();
		input.setToken(sessionResults.getBinaryToken());
		input.setCriteria(criteria);
		MuseArtifactResultsType museResults = postClient.executeRequest(MuseArtifactResultsType.class, input);
		if(museResults == null)
		{
			getLogger().error("Got null results from Muse Query by Criteria.");			
			return null;
		}
        getLogger().info("getPatientArtifacts, Transaction [{}] returned [{}] MuseArtifactResultsType.", transactionContext.getTransactionId(), museResults == null ? "null" : "not null");
		ArtifactResults result = null;
		try
		{
			result = MuseRestTranslator.extractArtifactResults(site, studyLoadLevel, patientIdentifier, 
						filter, getMuseServerConfiguration().getId(), museResults);
			transactionContext.addDebugInformation(result == null ? "null PatientArtifacts" : "" + result.toString(true));
		}
		catch(TranslationException tX)
		{
            getLogger().error("Error translating artifact results into business objects, {}", tX.getMessage(), tX);
			throw new MethodException(tX);			
		}
		finally{
			try{
				closeMuseSession(sessionResults, routingToken.toRoutingTokenString());
			}
			catch(MethodException mX){
				getLogger().warn("Muse Server Session did not close properly.");
			}
			catch(ConnectionException cX){
				getLogger().warn("Muse Server Session did not close properly.");
			}
		}
        getLogger().info("getPatientArtifacts, Transaction [{}] returned response of [{}] ArtifactResults business object.", transactionContext.getTransactionId(), result == null ? "null" : "not null");
		
		return result;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMusePatientArtifactRestProxy#addSecurityContextToHeader(org.apache.commons.httpclient.HttpClient, org.apache.commons.httpclient.methods.GetMethod, boolean)
	 */
	@Override
	protected void addSecurityContextToHeader(HttpClient client,
			GetMethod getMethod, boolean includeVistaSecurityContext) {
		super.addSecurityContextToHeader(client, getMethod, includeVistaSecurityContext);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.muse.proxy.AbstractMusePatientArtifactRestProxy#getRestServicePath()
	 */
	@Override
	protected String getRestServicePath() {
		return MuseRestUri.patientArtifactsPath;
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
