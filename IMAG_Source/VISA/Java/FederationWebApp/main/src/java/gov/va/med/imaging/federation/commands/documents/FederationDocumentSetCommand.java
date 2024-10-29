/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 25, 2010
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
package gov.va.med.imaging.federation.commands.documents;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.DocumentFilter;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationDocumentFilterType;
import gov.va.med.imaging.federation.rest.types.FederationDocumentSetResultType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationDocumentSetCommand
extends AbstractFederationCommand<DocumentSetResult, FederationDocumentSetResultType>
{
	private final String interfaceVersion;
	private final String routingTokenString;
	private final FederationDocumentFilterType federationDocumentFilter;
	
	public FederationDocumentSetCommand(String routingTokenString,
			FederationDocumentFilterType federationDocumentFilter,
			String interfaceVersion)
	{
		super("getDocumentSets");
		this.routingTokenString = routingTokenString;
		this.federationDocumentFilter = federationDocumentFilter;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected DocumentSetResult executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();	
		DocumentFilter documentFilter = null;
		
		try
		{
			documentFilter = FederationRestTranslator.translate(getFederationDocumentFilter());
		}
		catch(TranslationException tX)
		{
			String msg = "FederationDocumentSetCommand.executeRouterCommand() --> Error translating given filter: " + tX.getMessage();
			getLogger().error(msg);
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new ConnectionException(msg, tX);
		}
		
		transactionContext.setQueryFilter(TransactionContextFactory.getFilterDateRange(documentFilter.getFromDate(), documentFilter.getToDate()));
		
		DocumentSetResult result = null;
		
		try
		{
			// not sure if this should be VARadiologysite? if VIX to CVIX want data from DoD site, if CVIX to VIX want from VA site... not sure?
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			FederationRouter router = getRouter();
			result = router.getDocumentSetResultFromSite(routingToken, documentFilter);
            getLogger().info("FederationDocumentSetCommand.executeRouterCommand() --> transaction Id [{}], got [{} DocumentSet business object(s) from router.", getTransactionId(), result == null ? 0 : (result.getArtifacts() == null ? 0 : result.getArtifacts().size()));
			return result;
		}
		catch(RoutingTokenFormatException rtfX)
		{
			String msg = "FederationDocumentSetCommand.executeRouterCommand() --> Encountered routing exception: " + rtfX.getMessage();
			getLogger().error(msg);
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new ConnectionException(msg, rtfX);
		}
	}

	@Override
	public Integer getEntriesReturned(FederationDocumentSetResultType translatedResult)
	{
		return translatedResult == null ? 0 : (translatedResult.getDocumentSets() == null ? 0 : translatedResult.getDocumentSets().length);
	}

	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "patient '" + getFederationDocumentFilter().getPatientId() + "' from site '" + getRoutingTokenString() + "'";
	}

	@Override
	protected Class<FederationDocumentSetResultType> getResultClass()
	{
		return FederationDocumentSetResultType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getFederationDocumentFilter().getPatientId());

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	@Override
	protected FederationDocumentSetResultType translateRouterResult(
			DocumentSetResult routerResult) 
	throws TranslationException
	{
		return FederationRestTranslator.translate(routerResult);
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public FederationDocumentFilterType getFederationDocumentFilter()
	{
		return federationDocumentFilter;
	}

}
