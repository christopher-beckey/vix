/**
 * 
 */
package gov.va.med.imaging.federation.proxy.v6;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;

import javax.ws.rs.core.MediaType;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.proxy.v5.FederationRestExternalPackageProxyV5;
import gov.va.med.imaging.federation.rest.endpoints.FederationExternalPackageRestUri;
import gov.va.med.imaging.federation.rest.proxy.FederationRestPostClient;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationCprsIdentifiersType;
import gov.va.med.imaging.federation.rest.types.FederationStudyType;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author William Peterson
 *
 */
public class FederationRestExternalPackageProxyV6 
extends FederationRestExternalPackageProxyV5 {

	/**
	 * @param proxyServices
	 * @param federationConfiguration
	 */
	public FederationRestExternalPackageProxyV6(ProxyServices proxyServices,
			FederationConfiguration federationConfiguration) {
		super(proxyServices, federationConfiguration);
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.rest.proxy.AbstractFederationRestImageProxy#getProxyServiceType()
	 */
	@Override
	protected ProxyServiceType getProxyServiceType()
	{
		return ProxyServiceType.externalpackage;
	}

	
	@Override
	protected String getDataSourceVersion()
	{
		return "6";
	}

	public List<Study> postStudiesFromCprsIdentifiers(
			RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier,
			List<CprsIdentifier> cprsIdentifiers) throws MethodException,
			ConnectionException {
		
		String transactionId = TransactionContextFactory.get().getTransactionId();

        getLogger().info("FederationRestExternalPackageProxyV6.postStudiesFromCprsIdentifiers() --> Transaction Id [{}] initiated, patient ICN [{}] to routing token [{}]", transactionId, patientIdentifier.getValue(), globalRoutingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("postStudiesFromCprsIdentifiers");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{patientIcn}", patientIdentifier.getValue());
		
		FederationCprsIdentifiersType federationCprsIdentifiers = FederationRestTranslator.translateCprsIdentifierList(cprsIdentifiers);
		
		String url = getWebResourceUrl(FederationExternalPackageRestUri.postStudiesFromCprsMethodPath, urlParameterKeyValues );
		FederationRestPostClient postClient = new FederationRestPostClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		FederationStudyType[] studiesType = null;
        try
        {
               studiesType = postClient.executeRequest(FederationStudyType[].class, federationCprsIdentifiers);
        }
        catch(ConnectionException ex)
        {
               String msg = ex.getMessage();
               if(msg != null && msg.contains("XMLStreamException: ParseError"))
               {
                     getLogger().info("FederationRestExternalPackageProxyV6.postStudiesFromCprsIdentifiers() --> Got ConnectionException indicating parse error. This means no studies were returned, returning empty studyResult");
                     List<Study> studyResult = new ArrayList<Study>(0);
                     return studyResult;
               }
               throw ex;
        }

        getLogger().info("FederationRestExternalPackageProxyV6.postStudiesFromCprsIdentifiers() --> Transaction Id [{}] returned [{}] study webservice objects.", transactionId, studiesType == null ? "null" : studiesType.length);
		try
		{
			List<Study> studyResult = null;
			if(studiesType != null){
				SortedSet<Study> result = FederationRestTranslator.translate(studiesType);
				studyResult = new ArrayList<Study>(result.size());
				studyResult.addAll(result);
			}
			else{
                studyResult = new ArrayList<Study>(0);				
			}
            getLogger().info("FederationRestExternalPackageProxyV6.postStudiesFromCprsIdentifiers() --> Transaction Id [{}] returned [{}] study business objects.", transactionId, studyResult == null ? "null" : studyResult.size());
			return studyResult;
		}
		catch(TranslationException tX)
		{
			String msg = "FederationRestExternalPackageProxyV6.postStudiesFromCprsIdentifiers() --> Encountered URNFormatException while translating exams: " + tX.getMessage();
			getLogger().error(msg);
			throw new MethodException(msg, tX);
		}
	}
}
