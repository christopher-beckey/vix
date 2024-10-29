/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 9, 2018
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaisltjahjb
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
package gov.va.med.imaging.federation.proxy.v9;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import org.apache.commons.httpclient.methods.GetMethod;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.GUID;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.federation.proxy.v8.FederationRestExternalPackageProxyV8;
import gov.va.med.imaging.federation.rest.endpoints.FederationWorkListRestUri;
import gov.va.med.imaging.federation.rest.proxy.FederationRestGetClient;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationWorkItemType;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.rest.RestProxyCommon;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author vhaisltjahjb
 *
 */
public class FederationRestExternalPackageProxyV9
extends FederationRestExternalPackageProxyV8
{
	public FederationRestExternalPackageProxyV9(ProxyServices proxyServices, 
			FederationConfiguration federationConfiguration)
	{
		super(proxyServices, federationConfiguration);
	}
	
	@Override
	protected String getDataSourceVersion()
	{
		return "9";
	}


	@Override
	protected ProxyServiceType getTextFileRequestProxyServiceType()
	{
		return null;
	}
	

	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod) 
	{
	}

	@Override
	protected ProxyServiceType getInstanceRequestProxyServiceType() 
	{
		return null;
	}

	public List<WorkItem> getWorkItemList(RoutingToken globalRoutingToken, String idType,
			String patientId, String cptCode)
	throws MethodException, ConnectionException 
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		if(transactionContext.getTransactionId() == null)
		{
			getLogger().info("getWorkItemList - Generated transaction ID.");
			transactionContext.setTransactionId( (new GUID()).toLongString() );
		}
		
		getLogger().debug("executing getWorkItemList method in FederationRestExternalPackageProxyV9.");
		setDataSourceMethodAndVersion("getWorkItemList");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{idType}", idType);
		urlParameterKeyValues.put("{patientId}", patientId);
		urlParameterKeyValues.put("{cptCode}", cptCode);
		
		String url = getWebResourceUrl(FederationWorkListRestUri.getWorkListMethodPath, urlParameterKeyValues);
		FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		
		FederationWorkItemType [] workItems = getClient.executeRequest(FederationWorkItemType[].class);
        getLogger().info("getWorkItemList, Transaction [{}] returned [{}].", transactionContext.getTransactionId(), workItems == null ? "null" : "not null");
		List<WorkItem> result = FederationRestTranslator.translate(workItems);
        getLogger().info("getWorkItemList, Transaction [{}] returned [{}] work items.", transactionContext.getTransactionId(), result == null ? "null" : "" + result.size());
		return result;
	}

	public boolean deleteWorkItem(RoutingToken globalRoutingToken, String id) 
	throws MethodException, ConnectionException 
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		getLogger().debug("executing deleteWorkItem method in FederationRestWorkListProxyV9.");
		setDataSourceMethodAndVersion("deleteWorkItem");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{id}", id);
		
		String url = getWebResourceUrl(FederationWorkListRestUri.deleteWorkItemMethodPath, urlParameterKeyValues);
		FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);

		RestBooleanReturnType result = getClient.executeRequest(RestBooleanReturnType.class);
        getLogger().info("deleteWorkItem, Transaction [{}] returned [{}] result.", transactionContext.getTransactionId(), result == null ? "null" : "" + result.isResult());
		return result.isResult();
	}

	protected String getWebResourceUrl(String methodUri, Map<String, String> urlParameterKeyValues)
	throws ConnectionException
	{
		StringBuilder url = new StringBuilder();
		url.append(proxyServices.getProxyService(getProxyServiceType()).getConnectionURL());
		//url.append("http://localhost:8080/FederationWebApp/restservices/");
		url.append(getRestServicePath());
		url.append("/");
		url.append(RestProxyCommon.replaceMethodUriWithValues(methodUri, urlParameterKeyValues));		
		
		return url.toString();
	}

	protected ProxyServiceType getProxyServiceType()
	{
		return ProxyServiceType.externalpackage;
	}

}
