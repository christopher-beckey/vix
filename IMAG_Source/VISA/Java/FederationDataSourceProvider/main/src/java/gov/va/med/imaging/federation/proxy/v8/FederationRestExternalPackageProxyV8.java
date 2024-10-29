/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 22, 2017
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
 package gov.va.med.imaging.federation.proxy.v8;

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
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.proxy.v6.FederationRestExternalPackageProxyV6;
import gov.va.med.imaging.federation.rest.endpoints.FederationExternalPackageRestUri;
import gov.va.med.imaging.federation.rest.proxy.FederationRestPostClient;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationCprsIdentifierType;
import gov.va.med.imaging.federation.rest.types.FederationCprsIdentifiersType;
import gov.va.med.imaging.federation.rest.types.FederationStudyType;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author vhaisltjahb
 *
 */
public class FederationRestExternalPackageProxyV8 
extends FederationRestExternalPackageProxyV6 {

	/**
	 * @param proxyServices
	 * @param federationConfiguration
	 */
	public FederationRestExternalPackageProxyV8(ProxyServices proxyServices,
			FederationConfiguration federationConfiguration) {
		super(proxyServices, federationConfiguration);
	}
	
	
	@Override
	protected String getDataSourceVersion()
	{
		return "8";
	}

	private int getLocalVersion()
	{
		return Integer.parseInt(getDataSourceVersion());
	}
	
	public List<Study> postStudiesFromCprsIdentifiersAndFilter(
			RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier,
			List<CprsIdentifier> cprsIdentifiers,
			StudyFilter filter)
		throws MethodException, ConnectionException 
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        getLogger().info("FederationRestExternalPackageProxyV8.postStudiesFromCprsIdentifiersAndFilter() --> Transaction Id [{}] initiated, patient ICN [{}] to routing token [{}]", transactionId, patientIdentifier.getValue(), globalRoutingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("postStudiesFromCprsIdentifiersAndFilter");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{patientIcn}", patientIdentifier.getValue());

		String url = getWebResourceUrl(
				FederationExternalPackageRestUri.postStudiesFromCprsMethodPath,  
				urlParameterKeyValues );
		url = url + "?bothdb=true"; //This will be used by p185 and up, pre p185 will ignore it
		
		FederationCprsIdentifiersType federationCprsIdentifiers = FederationRestTranslator.translateCprsIdentifierList(cprsIdentifiers);
		
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
                     getLogger().info("FederationRestExternalPackageProxyV8.postStudiesFromCprsIdentifiersAndFilter() --> Got ConnectionException indicating parse error. This means no studies were returned, returning empty studyResult");
                     
                     List<Study> studyResult = new ArrayList<Study>(0);
                     return studyResult;
               }
               throw ex;
        }

        getLogger().info("FederationRestExternalPackageProxyV8.postStudiesFromCprsIdentifiersAndFilter() --> [{}] returned [{}] study webservice objects.", transactionId, studiesType == null ? "null" : studiesType.length);
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
            getLogger().info("FederationRestExternalPackageProxyV8.postStudiesFromCprsIdentifiersAndFilter() --> [{}] returned [{}] study business objects.", transactionId, studyResult == null ? "null" : studyResult.size());
			return studyResult;
		}
		catch(TranslationException tX)
		{
			String msg = "FederationRestExternalPackageProxyV8.postStudiesFromCprsIdentifiersAndFilter() --> Encountered translation exception : " + tX.getMessage();
			getLogger().error(msg);
			throw new MethodException(msg, tX);
		}
	}

	public List<Study> getStudiesFromCprsIdentifierAndFilter(
			RoutingToken globalRoutingToken, 
			String patientIcn,
			CprsIdentifier cprsIdentifier,
			StudyFilter filter)
	throws MethodException, ConnectionException 
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        getLogger().info("FederationRestExternalPackageProxyV8.getStudiesFromCprsIdentifierAndFilter() --> Transaction Id [{}] initiated, patient ICN [{}] to routing token [{}]", transactionId, patientIcn, globalRoutingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("getStudiesFromCprsIdentifierAndFilter");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", globalRoutingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{patientIcn}", patientIcn);
		
		FederationCprsIdentifierType federationCprsIdentifier = FederationRestTranslator.translate(cprsIdentifier);		
	
		String url = getWebResourceUrl(
				FederationExternalPackageRestUri.getStudyFromCprsMethodPath, 
				urlParameterKeyValues );

		url = url + "?bothdb=true"; //This will be used by p185 and up, pre 185 will ignore it
		
		FederationRestPostClient postClient = new FederationRestPostClient(url, MediaType.APPLICATION_XML_TYPE, federationConfiguration);
		FederationStudyType[] studiesType = null;
        try
        {
               studiesType = postClient.executeRequest(FederationStudyType[].class, federationCprsIdentifier);
        }
        catch(ConnectionException ex)
        {
               String msg = ex.getMessage();
               if(msg != null && msg.contains("XMLStreamException: ParseError"))
               {
                     getLogger().info("FederationRestExternalPackageProxyV8.getStudiesFromCprsIdentifierAndFilter() --> Got ConnectionException indicating parse error. This means no studies were returned, returning empty studyResult");
                     
                     List<Study> studyResult = new ArrayList<Study>(0);
                     return studyResult;
               }
               throw ex;
        }

        getLogger().info("FederationRestExternalPackageProxyV8.getStudiesFromCprsIdentifierAndFilter() --> Transaction Id [{}] returned [{}] study webservice objects.", transactionId, studiesType == null ? "null" : studiesType.length);
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
            getLogger().info("FederationRestExternalPackageProxyV8.getStudiesFromCprsIdentifierAndFilter() --> Transaction Id [{}] returned [{}] study business objects.", transactionId, studyResult == null ? "null" : studyResult.size());
			return studyResult;
		}
		catch(TranslationException tX)
		{
			String msg = "FederationRestExternalPackageProxyV8.getStudiesFromCprsIdentifierAndFilter() --> Encountered translation exception : " + tX.getMessage();
			getLogger().error(msg);
			throw new MethodException(msg, tX);
		}
	}
}
