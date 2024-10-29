/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 15, 2010
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
package gov.va.med.imaging.federation.proxy.v4;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;

import javax.ws.rs.core.MediaType;

import org.apache.commons.httpclient.methods.GetMethod;
import gov.va.med.logging.Logger;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.federation.rest.endpoints.FederationPatientRestUri;
import gov.va.med.imaging.federation.rest.proxy.AbstractFederationRestImageProxy;
import gov.va.med.imaging.federation.rest.proxy.FederationRestGetClient;
import gov.va.med.imaging.federation.rest.proxy.FederationRestPostClient;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationPatientSensitiveType;
import gov.va.med.imaging.federation.rest.types.FederationPatientType;
import gov.va.med.imaging.federation.rest.types.FederationStringArrayType;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationRestPatientProxyV4 
extends AbstractFederationRestImageProxy
{	
	private final static Logger logger = Logger.getLogger(FederationRestPatientProxyV4.class);

	public FederationRestPatientProxyV4(ProxyServices proxyServices, 
			FederationConfiguration federationConfiguration)
	{
		super(proxyServices, federationConfiguration);
	}
	
	@Override
	protected String getRestServicePath() 
	{
		return FederationPatientRestUri.patientServicePath;
	}

	@Override
	protected ProxyServiceType getProxyServiceType() 
	{
		return ProxyServiceType.metadata;
	}
	
	public List<String> getPatientSitesVisited(RoutingToken routingToken, String patientIcn, boolean includeTrailingCharactersForSite200)
	throws ConnectionException, MethodException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
        logger.info("getPatientSitesVisited, Transaction [{}] initiated, patient '{}' to '{}'.", transactionContext.getTransactionId(), patientIcn, routingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("getPatientSitesVisited");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", routingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{patientIcn}", patientIcn);
		
		String url = getWebResourceUrl(FederationPatientRestUri.patientVisitedPath, urlParameterKeyValues ); 
				
		FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		FederationStringArrayType sites = getClient.executeRequest(FederationStringArrayType.class);
        logger.info("getPatientSitesVisited, Transaction [{}] returned [{}] sites.", transactionContext.getTransactionId(), sites == null ? "null" : "" + (sites.getValues() == null ? "null" : "" + sites.getValues().length));
		List<String> result = FederationRestTranslator.translate(FederationRestTranslator.translateStringArray(sites));
        logger.info("getPatientSitesVisited, Transaction [{}] returned response of [{}] site number business objects.", transactionContext.getTransactionId(), result == null ? "null" : "" + result.size());
		return result;		
	}

	public SortedSet<Patient> findPatients(RoutingToken routingToken, String searchName)
	throws ConnectionException, MethodException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
        logger.info("findPatients, Transaction [{}] initiated, search name '{}' to '{}'.", transactionContext.getTransactionId(), searchName, routingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("findPatients");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", routingToken.toRoutingTokenString());
			
		String url = getWebResourceUrl(FederationPatientRestUri.patientSearchPath, urlParameterKeyValues ); 				
		FederationRestPostClient getClient = new FederationRestPostClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		FederationPatientType[] patients = getClient.executeRequest(FederationPatientType[].class, searchName);
        logger.info("findPatients, Transaction [{}] returned [{}] patients.", transactionContext.getTransactionId(), patients == null ? "null" : "" + patients.length);
		SortedSet<Patient> result = FederationRestTranslator.translateToSet(patients);
        logger.info("findPatients, Transaction [{}] returned response of [{}] patients business objects.", transactionContext.getTransactionId(), result == null ? "null" : "" + result.size());
		return result;		
	}
	
	public PatientSensitiveValue getPatientSensitivityLevel(RoutingToken routingToken, String patientIcn)
	throws ConnectionException, MethodException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
        logger.info("getPatientSensitiveValue, Transaction [{}] initiated, patient Icn '{}' to '{}'.", transactionContext.getTransactionId(), patientIcn, routingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("getPatientSensitiveValue");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", routingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{patientIcn}", patientIcn);
		String url = getWebResourceUrl(FederationPatientRestUri.patientSensitivePath, urlParameterKeyValues);
		FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		FederationPatientSensitiveType patientSensitiveType = getClient.executeRequest(FederationPatientSensitiveType.class);

        logger.info("getPatientSensitiveValue, Transaction [{}] returned [{}] patient sensitivity webservice object.", transactionContext.getTransactionId(), patientSensitiveType == null ? "null" : "not null");
		PatientSensitiveValue result = FederationRestTranslator.translate(patientSensitiveType);
        logger.info("getPatientSensitiveValue, Transaction [{}] returned sensitive code of [{}] business object.", transactionContext.getTransactionId(), result == null ? "null" : "" + result.getSensitiveLevel().getCode());
		
		return result;
	}
	
	public boolean logPatientSensitiveAccess(RoutingToken routingToken, String patientIcn)
	throws ConnectionException, MethodException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
        logger.info("logPatientSensitiveAccess, Transaction [{}] initiated, patient Icn '{}' to '{}'.", transactionContext.getTransactionId(), patientIcn, routingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("logPatientSensitiveAccess");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", routingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{patientIcn}", patientIcn);
		String url = getWebResourceUrl(FederationPatientRestUri.patientLogSensitiveAccessPath, urlParameterKeyValues);
		FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		RestBooleanReturnType result = getClient.executeRequest(RestBooleanReturnType.class);
        logger.info("logPatientSensitiveAccess, Transaction [{}] returned [{}] result.", transactionContext.getTransactionId(), result == null ? "null" : "" + result.isResult());
		return result.isResult();
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
	protected void addOptionalGetInstanceHeaders(GetMethod getMethod) 
	{
		// don't need to do anything here since image not actually loaded here
	}

	@Override
	protected String getDataSourceVersion()
	{
		return "4";
	}

}
