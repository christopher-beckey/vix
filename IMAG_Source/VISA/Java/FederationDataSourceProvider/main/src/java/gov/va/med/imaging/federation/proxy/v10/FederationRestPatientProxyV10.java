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
package gov.va.med.imaging.federation.proxy.v10;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.ws.rs.core.MediaType;

//import org.apache.commons.httpclient.methods.GetMethod;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.PatientPhotoIDInformation;
import gov.va.med.imaging.federation.proxy.v8.FederationRestPatientProxyV8;
import gov.va.med.imaging.federation.rest.endpoints.FederationPatientRestUri;
import gov.va.med.imaging.federation.rest.proxy.FederationRestGetClient;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationPatientIdentificationImageInformationType;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author vhaisltjahjb
 *
 */
public class FederationRestPatientProxyV10
extends FederationRestPatientProxyV8
{
	public FederationRestPatientProxyV10(ProxyServices proxyServices, 
			FederationConfiguration federationConfiguration)
	{
		super(proxyServices, federationConfiguration);
	}
	
	@Override
	protected String getDataSourceVersion()
	{
		return "10";
	}


	public PatientPhotoIDInformation getPatientIdentificationImageInformation(String patientIcn, RoutingToken routingToken)
	throws MethodException, ConnectionException, URNFormatException 
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		
		if(transactionContext.getTransactionId() == null)
		{
			transactionContext.setTransactionId(UUID.randomUUID().toString());
		}

        getLogger().info("getPatientIdentificationImageInformation, Transaction [{}] initiated, patient '{}' to '{}'.", transactionContext.getTransactionId(), patientIcn, routingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("getPatientIdentificationImageInformation");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", routingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{patientIcn}", patientIcn);
		
		String url = getWebResourceUrl(FederationPatientRestUri.patientPhotoIDInformationPath, urlParameterKeyValues ); 
				
		FederationRestGetClient getClient = new FederationRestGetClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		FederationPatientIdentificationImageInformationType patientPhotoIdInformation = getClient.executeRequest(FederationPatientIdentificationImageInformationType.class);
        getLogger().debug("Patient Info.  site: {} patient Icn: {} patient name: {} studyIen: {} ImageIen: {} filename: {} extension: {} date capture: {} image format: {}", patientPhotoIdInformation.getSiteId(), patientPhotoIdInformation.getPatientIcn(), patientPhotoIdInformation.getPatientName(), patientPhotoIdInformation.getStudyIen(), patientPhotoIdInformation.getImageIen(), patientPhotoIdInformation.getFilename(), patientPhotoIdInformation.getImageExtension(), patientPhotoIdInformation.getDateCaptured(), patientPhotoIdInformation.getImageFormat());

        getLogger().info("getPatientIdentificationImageInformation, Transaction [{}] returned [{}] patient.", transactionContext.getTransactionId(), patientPhotoIdInformation == null ? "null" : "not null");
		PatientPhotoIDInformation result = FederationRestTranslator.translate(patientPhotoIdInformation);

        getLogger().info("getPatientIdentificationImageInformation, Transaction [{}] returned response of [{}] patient business object.", transactionContext.getTransactionId(), result == null ? "null" : "not null");
		return result;	
	}


}
