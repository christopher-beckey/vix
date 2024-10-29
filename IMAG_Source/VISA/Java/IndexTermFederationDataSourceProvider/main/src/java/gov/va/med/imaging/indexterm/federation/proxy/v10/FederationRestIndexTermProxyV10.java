package gov.va.med.imaging.indexterm.federation.proxy.v10;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.federation.rest.proxy.AbstractFederationRestProxy;
import gov.va.med.imaging.federation.rest.proxy.FederationRestGetClient;
import gov.va.med.imaging.federation.rest.proxy.FederationRestPostClient;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.indexterm.IndexTermFederationProxyServiceType;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.datasource.IIndexTermRestProxy;
import gov.va.med.imaging.indexterm.enums.IndexClass;
import gov.va.med.imaging.indexterm.federation.endpoints.FederationIndexTermRestUri;
import gov.va.med.imaging.indexterm.federation.translator.IndexTermFederationRestTranslator;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexClassAndURNType;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexClassArrayType;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexTermValueArrayType;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexTermValueType;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.rest.types.RestStringArrayType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public class FederationRestIndexTermProxyV10 
extends AbstractFederationRestProxy
implements IIndexTermRestProxy
{

	public FederationRestIndexTermProxyV10(ProxyServices proxyServices,
			FederationConfiguration federationConfiguration) {
		super(proxyServices, federationConfiguration);
	}

	@Override
	protected String getRestServicePath() {
		return FederationIndexTermRestUri.indexTermServicePath;
	}

	
	@Override
	protected ProxyServiceType getProxyServiceType() {
		return new IndexTermFederationProxyServiceType();
	}

	@Override
	protected String getDataSourceVersion() {
		return "10";
	}

	public List<IndexTermValue> getOrigins(RoutingToken globalRoutingToken) throws MethodException, ConnectionException {
		TransactionContext transactionContext = TransactionContextFactory.get();

        getLogger().info("getOrigins, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), globalRoutingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("getOrigins");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
				
		String url = getWebResourceUrl(FederationIndexTermRestUri.getOriginsPath, urlParameterKeyValues );
		FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		FederationIndexTermValueArrayType indexTermValueArrayType = null;
        try
        {
        	indexTermValueArrayType = getClient.executeRequest(FederationIndexTermValueArrayType.class);
        }
        catch(ConnectionException ex)
        {
               String msg = ex.getMessage();
               if(msg != null && msg.contains("XMLStreamException: ParseError"))
               {
                     getLogger().info("Got ConnectionException indicating parse error. This means no studies were returned, returning empty consultResult");
                     
                     List<IndexTermValue> indexTermValueResult = new ArrayList<IndexTermValue>(0);
                     return indexTermValueResult;
               }
               throw ex;
        }

        FederationIndexTermValueType[] indexTermValuesType = indexTermValueArrayType.getValues();
        getLogger().info("getOrigins, Transaction [{}] returned [{}] IndexTermValue webservice objects.", transactionContext.getTransactionId(), indexTermValuesType == null ? "null" : "" + indexTermValuesType.length);
		List<IndexTermValue> indexTermValueResult = null;
		if(indexTermValuesType != null){
			List<IndexTermValue> result = IndexTermFederationRestTranslator.translateIndexTermValues(indexTermValuesType);
			indexTermValueResult = new ArrayList<IndexTermValue>(result.size());
			indexTermValueResult.addAll(result);
		}
		else{
			indexTermValueResult = new ArrayList<IndexTermValue>(0);				
		}
        getLogger().info("getOrigins, Transaction [{}] returned [{}] IndexTermValue business objects.", transactionContext.getTransactionId(), indexTermValueResult == null ? "null" : "" + indexTermValueResult.size());
		return indexTermValueResult;
	}

	public List<IndexTermValue> getSpecialties(RoutingToken globalRoutingToken, List<IndexClass> indexClasses, List<IndexTermURN> eventUrns)
			throws MethodException, ConnectionException {
		TransactionContext transactionContext = TransactionContextFactory.get();

        getLogger().info("getSpecialties, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), globalRoutingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("getSpecialties");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
		
		FederationIndexClassArrayType federationIndexClasses = IndexTermFederationRestTranslator.translateIndexClassesType(indexClasses);
		RestStringArrayType federationIndexTermURNs = IndexTermFederationRestTranslator.translateStringArrayType(eventUrns);
		FederationIndexClassAndURNType bodyType = new FederationIndexClassAndURNType();
		bodyType.setFederationIndexClasses(federationIndexClasses);
		bodyType.setFederationIndexTermURNs(federationIndexTermURNs);
		String url = getWebResourceUrl(FederationIndexTermRestUri.getSpecialtiesPath, urlParameterKeyValues );
		FederationRestPostClient postClient = new FederationRestPostClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		FederationIndexTermValueArrayType indexTermValueArrayType = null;
        try
        {
        	indexTermValueArrayType = postClient.executeRequest(FederationIndexTermValueArrayType.class, bodyType);
        }
        catch(ConnectionException ex)
        {
               String msg = ex.getMessage();
               if(msg != null && msg.contains("XMLStreamException: ParseError"))
               {
                     getLogger().info("Got ConnectionException indicating parse error. This means no studies were returned, returning empty studyResult");
                     
                     List<IndexTermValue> indexTermValueResult = new ArrayList<IndexTermValue>(0);
                     return indexTermValueResult;
               }
               throw ex;
        }

        FederationIndexTermValueType[] indexTermValuesType = indexTermValueArrayType.getValues();
        getLogger().info("getSpecialties, Transaction [{}] returned [{}] IndexTermValue webservice objects.", transactionContext.getTransactionId(), indexTermValuesType == null ? "null" : "" + indexTermValuesType.length);
		List<IndexTermValue> indexTermValueResult = null;
		if(indexTermValuesType != null){
			List<IndexTermValue> result = IndexTermFederationRestTranslator.translateIndexTermValues(indexTermValuesType);
			indexTermValueResult = new ArrayList<IndexTermValue>(result.size());
			indexTermValueResult.addAll(result);
		}
		else{
			indexTermValueResult = new ArrayList<IndexTermValue>(0);				
		}
        getLogger().info("getSpecialties, Transaction [{}] returned [{}] IndexTermValue business objects.", transactionContext.getTransactionId(), indexTermValueResult == null ? "null" : "" + indexTermValueResult.size());
		return indexTermValueResult;
	}

	public List<IndexTermValue> getProcedureEvents(RoutingToken globalRoutingToken, List<IndexClass> indexClasses, List<IndexTermURN> specialtyUrns)
			throws MethodException, ConnectionException {
		TransactionContext transactionContext = TransactionContextFactory.get();

        getLogger().info("getProcedureEvents, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), globalRoutingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("getProcedureEvents");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
		
		FederationIndexClassArrayType federationIndexClasses = IndexTermFederationRestTranslator.translateIndexClassesType(indexClasses);
		RestStringArrayType federationIndexTermURNs = IndexTermFederationRestTranslator.translateStringArrayType(specialtyUrns);
		FederationIndexClassAndURNType bodyType = new FederationIndexClassAndURNType();
		bodyType.setFederationIndexClasses(federationIndexClasses);
		bodyType.setFederationIndexTermURNs(federationIndexTermURNs);

		String url = getWebResourceUrl(FederationIndexTermRestUri.getProcedureEventsPath, urlParameterKeyValues );
		FederationRestPostClient postClient = new FederationRestPostClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		FederationIndexTermValueArrayType indexTermValueArrayType = null;
        try
        {
        	indexTermValueArrayType = postClient.executeRequest(FederationIndexTermValueArrayType.class, bodyType);
        }
        catch(ConnectionException ex)
        {
               String msg = ex.getMessage();
               if(msg != null && msg.contains("XMLStreamException: ParseError"))
               {
                     getLogger().info("Got ConnectionException indicating parse error. This means no studies were returned, returning empty indexTermValueResult");
                     
                     List<IndexTermValue> indexTermValueResult = new ArrayList<IndexTermValue>(0);
                     return indexTermValueResult;
               }
               throw ex;
        }

        FederationIndexTermValueType[] indexTermValuesType = indexTermValueArrayType.getValues();
        getLogger().info("getProcedureEvents, Transaction [{}] returned [{}] IndexTermValue webservice objects.", transactionContext.getTransactionId(), indexTermValuesType == null ? "null" : "" + indexTermValuesType.length);
		List<IndexTermValue> indexTermValueResult = null;
		if(indexTermValuesType != null){
			List<IndexTermValue> result = IndexTermFederationRestTranslator.translateIndexTermValues(indexTermValuesType);
			indexTermValueResult = new ArrayList<IndexTermValue>(result.size());
			indexTermValueResult.addAll(result);
		}
		else{
			indexTermValueResult = new ArrayList<IndexTermValue>(0);				
		}
        getLogger().info("getProcedureEvents, Transaction [{}] returned [{}] IndexTermValue business objects.", transactionContext.getTransactionId(), indexTermValueResult == null ? "null" : "" + indexTermValueResult.size());
		return indexTermValueResult;
	}

	public List<IndexTermValue> getTypes(RoutingToken globalRoutingToken, List<IndexClass> indexClasses)
			throws MethodException, ConnectionException {
		TransactionContext transactionContext = TransactionContextFactory.get();

        getLogger().info("getTypes, Transaction [{}] initiated, '{}'.", transactionContext.getTransactionId(), globalRoutingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("getTypes");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
		
		FederationIndexClassArrayType federationIndexClasses = IndexTermFederationRestTranslator.translateIndexClassesType(indexClasses);
		
		String url = getWebResourceUrl(FederationIndexTermRestUri.getTypesPath, urlParameterKeyValues );
		FederationRestPostClient postClient = new FederationRestPostClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		FederationIndexTermValueArrayType indexTermValueArrayType = null;
        try
        {
        	indexTermValueArrayType = postClient.executeRequest(FederationIndexTermValueArrayType.class, federationIndexClasses);
        }
        catch(ConnectionException ex)
        {
               String msg = ex.getMessage();
               if(msg != null && msg.contains("XMLStreamException: ParseError"))
               {
                     getLogger().info("Got ConnectionException indicating parse error. This means no studies were returned, returning empty studyResult");
                     
                     List<IndexTermValue> indexTermValueResult = new ArrayList<IndexTermValue>(0);
                     return indexTermValueResult;
               }
               throw ex;
        }

        FederationIndexTermValueType[] indexTermValuesType = indexTermValueArrayType.getValues();
        getLogger().info("getTypes, Transaction [{}] returned [{}] IndexTermValue webservice objects.", transactionContext.getTransactionId(), indexTermValuesType == null ? "null" : "" + indexTermValuesType.length);
		List<IndexTermValue> indexTermValueResult = null;
		if(indexTermValuesType != null){
			List<IndexTermValue> result = IndexTermFederationRestTranslator.translateIndexTermValues(indexTermValuesType);
			indexTermValueResult = new ArrayList<IndexTermValue>(result.size());
			indexTermValueResult.addAll(result);
		}
		else{
			indexTermValueResult = new ArrayList<IndexTermValue>(0);				
		}
        getLogger().info("getTypes, Transaction [{}] returned [{}] IndexTermValue business objects.", transactionContext.getTransactionId(), indexTermValueResult == null ? "null" : "" + indexTermValueResult.size());
		return indexTermValueResult;
	}

	//@Override	
	//public List<IndexTermValue> getIndexTermValues(RoutingToken globalRoutingToken, List<IndexTerm> terms)
	//		throws MethodException, ConnectionException {
		
	//	return null;
	//}


	
}
