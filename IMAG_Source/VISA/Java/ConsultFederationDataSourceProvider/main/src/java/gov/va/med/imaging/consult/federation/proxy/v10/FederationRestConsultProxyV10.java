package gov.va.med.imaging.consult.federation.proxy.v10;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.consult.Consult;
import gov.va.med.imaging.consult.ConsultFederationProxyServiceType;
import gov.va.med.imaging.consult.datasource.IConsultRestProxy;
import gov.va.med.imaging.consult.federation.endpoints.FederationConsultRestUri;
import gov.va.med.imaging.consult.federation.translator.ConsultFederationRestTranslator;
import gov.va.med.imaging.consult.federation.types.FederationConsultArrayType;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.rest.proxy.AbstractFederationRestProxy;
import gov.va.med.imaging.federation.rest.proxy.FederationRestGetClient;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public class FederationRestConsultProxyV10 
extends AbstractFederationRestProxy 
implements IConsultRestProxy
{

	private final static Logger LOGGER = Logger.getLogger(FederationRestConsultProxyV10.class);
	
	public FederationRestConsultProxyV10(ProxyServices proxyServices, FederationConfiguration federationConfiguration) {
		super(proxyServices, federationConfiguration);
	}

	@Override
	protected String getRestServicePath() {
		return FederationConsultRestUri.consultServicePath;
	}

	@Override
	protected ProxyServiceType getProxyServiceType() {
		return new ConsultFederationProxyServiceType();
	}

	@Override
	protected String getDataSourceVersion() {
		return "10";
	}

	public List<Consult> getPatientConsults(RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier)
			throws MethodException, ConnectionException {
		TransactionContext transactionContext = TransactionContextFactory.get();

        LOGGER.info("FederationRestConsultProxyV10.getPatientConsults() --> Transaction Id [{}] initiated, patient Icn {}] to [{}]", transactionContext.getTransactionId(), patientIdentifier.getValue(), globalRoutingToken.toRoutingTokenString());
		
		setDataSourceMethodAndVersion("getPatientConsults");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{patientIcn}", patientIdentifier.getValue());
				
		String url = getWebResourceUrl(FederationConsultRestUri.getConsultsPath, urlParameterKeyValues );
		FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		FederationConsultArrayType consultsArrayType = null;
		
        try
        {
             consultsArrayType = getClient.executeRequest(FederationConsultArrayType.class);
        }
        catch(ConnectionException ex)
        {
               String msg = ex.getMessage();
               
               if(msg != null && msg.contains("XMLStreamException: ParseError"))
               {
                     LOGGER.warn("FederationRestConsultProxyV10.getPatientConsults() --> Got ConnectionException indicating parse error. This means no studies were returned, returning empty consultResult");
                     
                     List<Consult> consultResult = new ArrayList<Consult>(0);
                     return consultResult;
               }
               throw ex;
        }

        LOGGER.debug("FederationRestConsultProxyV10.getPatientConsults() --> Transaction [{}] returned [{}] study webservice objects.", transactionContext.getTransactionId(), consultsArrayType == null ? "null" : consultsArrayType.getValues().length);

        List<Consult> consultResult = null;
		
        if(consultsArrayType != null){
			List<Consult> result = ConsultFederationRestTranslator.translateFederationConsultTypes(consultsArrayType);
			consultResult = new ArrayList<Consult>(result.size());
			consultResult.addAll(result);
		}
		else{
               consultResult = new ArrayList<Consult>(0);				
		}

        LOGGER.debug("FederationRestConsultProxyV10.getPatientConsults() --> Transaction [{}] returned [{}] study business objects.", transactionContext.getTransactionId(), consultResult == null ? "null" : consultResult.size());
		return consultResult;
	}
}
