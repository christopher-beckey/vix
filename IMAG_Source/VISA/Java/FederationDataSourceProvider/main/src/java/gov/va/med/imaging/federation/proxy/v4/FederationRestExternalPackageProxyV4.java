/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 1, 2010
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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;

import javax.ws.rs.core.MediaType;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.rest.endpoints.FederationExternalPackageRestUri;
import gov.va.med.imaging.federation.rest.proxy.AbstractFederationRestProxy;
import gov.va.med.imaging.federation.rest.proxy.FederationRestPostClient;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationCprsIdentifierType;
import gov.va.med.imaging.federation.rest.types.FederationStudyType;
import gov.va.med.imaging.federationdatasource.configuration.FederationConfiguration;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationRestExternalPackageProxyV4 
extends AbstractFederationRestProxy
{
	public FederationRestExternalPackageProxyV4(ProxyServices proxyServices, 
			FederationConfiguration federationConfiguration)
	{
		super(proxyServices, federationConfiguration);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.rest.proxy.AbstractFederationRestImageProxy#getProxyServiceType()
	 */
	@Override
	protected ProxyServiceType getProxyServiceType()
	{
		return ProxyServiceType.metadata;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federation.rest.proxy.AbstractFederationRestImageProxy#getRestServicePath()
	 */
	@Override
	protected String getRestServicePath()
	{
		return FederationExternalPackageRestUri.externalPackageServicePath;
	}
	
	public List<Study> getStudiesFromCprsIdentifier(RoutingToken routingToken, String patientIcn,
			CprsIdentifier cprsIdentifier)
	throws MethodException, ConnectionException
	{
		String transactionId = TransactionContextFactory.get().getTransactionId();

        getLogger().info("FederationRestExternalPackageProxyV4.getStudiesFromCprsIdentifier() --> Transaction Id [{}] initiated, patient Icn '{}' to '{}'.", transactionId, patientIcn, routingToken.toRoutingTokenString());
		setDataSourceMethodAndVersion("getStudiesFromCprsIdentifier");
		Map<String, String> urlParameterKeyValues = new HashMap<String, String>();
		urlParameterKeyValues.put("{routingToken}", routingToken.toRoutingTokenString());
		urlParameterKeyValues.put("{patientIcn}", patientIcn);
		
		FederationCprsIdentifierType federationCprsIdentifier = FederationRestTranslator.translate(cprsIdentifier);
		
		String url = getWebResourceUrl(FederationExternalPackageRestUri.getStudyFromCprsMethodPath, urlParameterKeyValues );
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
                     getLogger().info("FederationRestExternalPackageProxyV4.getStudiesFromCprsIdentifier() --> Got ConnectionException indicating parse error. This means no studies were returned, returning empty studyResult");
                     
                     List<Study> studyResult = new ArrayList<Study>(0);
                     return studyResult;
               }
               throw ex;
        }

        getLogger().info("FederationRestExternalPackageProxyV4.getStudiesFromCprsIdentifier() --> Transaction Id [{}] returned [{}] study webservice object(s)", transactionId, studiesType == null ? 0 : studiesType.length);
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
            getLogger().info("FederationRestExternalPackageProxyV4.getStudiesFromCprsIdentifier() --> Transaction Id [{}] returned [{}] study business object(s)", transactionId, studyResult == null ? 0 : studyResult.size());
			return studyResult;
		}
		catch(TranslationException tX)
		{
			String msg = "FederationRestExternalPackageProxyV4.getStudiesFromCprsIdentifier() --> Error: " + tX.getMessage();
			getLogger().error(msg);
			throw new MethodException(msg, tX);
		}
	}
	
	@Override
	protected String getDataSourceVersion()
	{
		return "4";
	}

}
