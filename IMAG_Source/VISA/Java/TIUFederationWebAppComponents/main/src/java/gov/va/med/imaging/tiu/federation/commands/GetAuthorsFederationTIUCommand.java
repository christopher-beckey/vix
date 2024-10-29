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
import gov.va.med.imaging.tiu.TIUAuthor;
import gov.va.med.imaging.tiu.federation.translator.TIUFederationRestTranslator;
import gov.va.med.imaging.tiu.federation.types.FederationTIUAuthorArrayType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class GetAuthorsFederationTIUCommand 
extends AbstractFederationTIUCommand<List<TIUAuthor>, FederationTIUAuthorArrayType> {

	private String routingTokenString;
	private String interfaceVersion;
	private String searchText;

	
	public GetAuthorsFederationTIUCommand(String routingTokenString,
				String searchText, String interfaceVersion) {
		super("getAuthors");
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
	protected List<TIUAuthor> executeRouterCommand() throws MethodException, ConnectionException {
		try {
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			
			return getRouter().getTIUAuthors(routingToken, getSearchText());
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting tiu authors via router", e);
		}
	}
	@Override
	protected String getMethodParameterValuesString() {
		return "acquisition sites from " + getRoutingTokenString();
	}
	@Override
	protected FederationTIUAuthorArrayType translateRouterResult(List<TIUAuthor> routerResult)
			throws TranslationException, MethodException {
		return TIUFederationRestTranslator.translateTIUAuthorsType(routerResult);
	}
	@Override
	protected Class<FederationTIUAuthorArrayType> getResultClass() {
		return FederationTIUAuthorArrayType.class;
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
		return this.interfaceVersion;
	}
	@Override
	public Integer getEntriesReturned(FederationTIUAuthorArrayType translatedResult) {
		return translatedResult == null ? 0 : translatedResult.getValues().length;
	}
	
	
}
