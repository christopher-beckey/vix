package gov.va.med.imaging.tiu.federation.commands;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.tiu.TIULocation;
import gov.va.med.imaging.tiu.federation.translator.TIUFederationRestTranslator;
import gov.va.med.imaging.tiu.federation.types.FederationTIULocationArrayType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class GetLocationsFederationTIUCommand 
extends AbstractFederationTIUCommand<List<TIULocation>, FederationTIULocationArrayType> {

	private String routingTokenString;
	private String interfaceVersion;
	private String searchText;

	public GetLocationsFederationTIUCommand(String routingTokenString, String searchText,
				String interfaceVersion) {
		super("getLocations");
		this.routingTokenString = routingTokenString;
		this.interfaceVersion = interfaceVersion;
		this.searchText = searchText;
	}

	
	public String getRoutingTokenString() {
		return routingTokenString;
	}

	public String getSearchText() {
		return searchText;
	}

	@Override
	protected List<TIULocation> executeRouterCommand() throws MethodException, ConnectionException {
		try {
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			
			return getRouter().getTIULocations(routingToken, getSearchText());
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting tiu locations via router", e);
		}
	}
	@Override
	protected String getMethodParameterValuesString() {
		return "acquisition sites from " + getRoutingTokenString();
	}
	@Override
	protected FederationTIULocationArrayType translateRouterResult(List<TIULocation> routerResult)
			throws TranslationException, MethodException {
		return TIUFederationRestTranslator.translateTIULocations(routerResult);
	}
	@Override
	protected Class<FederationTIULocationArrayType> getResultClass() {
		return FederationTIULocationArrayType.class;
	}
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() {
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
				new HashMap<WebserviceInputParameterTransactionContextField, String>();
			
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, transactionContextNaValue);
		
		return transactionContextFields;
	}
	@Override
	public String getInterfaceVersion() {
		return interfaceVersion;
	}
	@Override
	public Integer getEntriesReturned(FederationTIULocationArrayType translatedResult) {
		return translatedResult == null ? 0 : translatedResult.getValues().length;
	}
	
	
}
