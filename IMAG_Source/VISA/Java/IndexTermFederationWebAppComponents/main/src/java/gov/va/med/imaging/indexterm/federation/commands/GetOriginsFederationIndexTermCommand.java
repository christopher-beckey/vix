/**
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.federation.commands;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.federation.translator.IndexTermFederationRestTranslator;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexTermValueArrayType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author Julian Werfel
 *
 */
public class GetOriginsFederationIndexTermCommand
extends AbstractFederationIndexTermCommand<List<IndexTermValue>,FederationIndexTermValueArrayType>
{
	private final String routingTokenString;
	private final String interfaceVersion;
		
	public GetOriginsFederationIndexTermCommand(String routingTokenString, String interfaceVersion)
	{
		super("getOrigins");
		this.routingTokenString = routingTokenString;
		this.interfaceVersion = interfaceVersion;
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}


	@Override
	protected List<IndexTermValue> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());

			
			return getRouter().getOrigins(routingToken);
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "acquisition sites from " + getRoutingTokenString();
	}

	@Override
	protected FederationIndexTermValueArrayType translateRouterResult(List<IndexTermValue> routerResult) throws TranslationException, MethodException {
		return IndexTermFederationRestTranslator.translateIndexTermValuesType(routerResult);
	}

	@Override
	protected Class<FederationIndexTermValueArrayType> getResultClass() {
		return FederationIndexTermValueArrayType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() {
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
				new HashMap<WebserviceInputParameterTransactionContextField, String>();
			
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		
		return transactionContextFields;
	}

	@Override
	public Integer getEntriesReturned(FederationIndexTermValueArrayType translatedResult) {
		return translatedResult == null ? 0 : translatedResult.getValues().length;
	}

	@Override
	public void setAdditionalTransactionContextFields() {
		// TODO Auto-generated method stub
		
	}
	
}
