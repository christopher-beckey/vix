/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 21, 2011
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
package gov.va.med.imaging.federation.proxy.v5;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.ws.rs.core.MediaType;

import org.apache.commons.httpclient.methods.GetMethod;
import gov.va.med.logging.Logger;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Division;
import gov.va.med.imaging.exchange.business.UserInformation;
import gov.va.med.imaging.federation.proxy.v4.FederationRestPatientProxyV4;
import gov.va.med.imaging.federation.rest.endpoints.FederationUserRestUri;
import gov.va.med.imaging.federation.rest.proxy.AbstractFederationRestImageProxy;
import gov.va.med.imaging.federation.rest.proxy.FederationRestGetClient;
import gov.va.med.imaging.federation.rest.proxy.FederationRestPostClient;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationDivisionType;
import gov.va.med.imaging.federation.rest.types.FederationStringArrayType;
import gov.va.med.imaging.federation.rest.types.FederationUserInformationType;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationRestUserProxyV5
extends AbstractFederationRestImageProxy
{
	private final static Logger logger = Logger.getLogger(FederationRestUserProxyV5.class);

	public FederationRestUserProxyV5(ProxyServices proxyServices, 
			FederationConfiguration federationConfiguration)
	{
		super(proxyServices, federationConfiguration);
	}

	@Override
	protected String getRestServicePath()
	{
		return FederationUserRestUri.userServicePath;
	}

	@Override
	protected ProxyServiceType getProxyServiceType()
	{
		return ProxyServiceType.metadata;
	}

	@Override
	protected String getDataSourceVersion()
	{
		return "5";
	}

	@Override
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod)
	{
		// don't need to do anything here since image not actually loaded here
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
	
	public List<String> getUserKeys(RoutingToken globalRoutingToken)
	throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
        logger.info("getUserKeys, Transaction [{}] initiated.", transactionContext.getTransactionId());
		setDataSourceMethodAndVersion("getUserKeys");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
		String url = getWebResourceUrl(FederationUserRestUri.userKeysPath, urlParameterKeyValues);
		FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);		
		FederationStringArrayType userKeys = getClient.executeRequest(FederationStringArrayType.class);
        logger.info("getUserKeys, Transaction [{}] returned [{}] user keys webservice objects.", transactionContext.getTransactionId(), userKeys == null ? "null" : "not null");
		List<String> result = FederationRestTranslator.translate(userKeys);
        logger.info("getUserKeys, Transaction [{}] returned [{}] user keys.", transactionContext.getTransactionId(), result == null ? "null" : "" + result.size());
		
		return result;
	}

	public List<Division> getDivisionList(String accessCode,
			RoutingToken globalRoutingToken) 
	throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
        logger.info("getDivisionList, Transaction [{}] initiated.", transactionContext.getTransactionId());
		setDataSourceMethodAndVersion("getDivisionList");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
		String url = getWebResourceUrl(FederationUserRestUri.divisionListPath, urlParameterKeyValues);
		FederationRestPostClient postClient = new FederationRestPostClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);		
		FederationDivisionType [] divisions = postClient.executeRequest(FederationDivisionType[].class, accessCode);
        logger.info("getDivisionList, Transaction [{}] returned [{}] divisions webservice objects.", transactionContext.getTransactionId(), divisions == null ? "null" : "not null");
		List<Division> result = FederationRestTranslator.translate(divisions);
        logger.info("getDivisionList, Transaction [{}] returned [{}] divisions.", transactionContext.getTransactionId(), result == null ? "null" : "" + result.size());
		
		return result;
	}

	public UserInformation getUserInformation(RoutingToken globalRoutingToken)
	throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
        logger.info("getUserInformation, Transaction [{}] initiated.", transactionContext.getTransactionId());
		setDataSourceMethodAndVersion("getUserInformation");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
		String url = getWebResourceUrl(FederationUserRestUri.information, urlParameterKeyValues);
		FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);		
		FederationUserInformationType userInformation = getClient.executeRequest(FederationUserInformationType.class);
        logger.info("getUserInformation, Transaction [{}] returned [{}] user information webservice objects.", transactionContext.getTransactionId(), userInformation == null ? "null" : "not null");
		UserInformation result = FederationRestTranslator.translate(userInformation);
        logger.info("getUserInformation, Transaction [{}] returned [{}] user information.", transactionContext.getTransactionId(), result == null ? "null" : "not null");
		
		return result;
	}

}
