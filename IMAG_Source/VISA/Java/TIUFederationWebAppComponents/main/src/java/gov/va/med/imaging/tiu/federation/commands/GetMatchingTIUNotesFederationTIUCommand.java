package gov.va.med.imaging.tiu.federation.commands;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.tiu.TIUNote;
import gov.va.med.imaging.tiu.federation.translator.TIUFederationRestTranslator;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteArrayType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class GetMatchingTIUNotesFederationTIUCommand 
extends AbstractFederationTIUCommand<List<TIUNote>, FederationTIUNoteArrayType> {

	private String routingTokenString;
	private String interfaceVersion;
	private String searchText;
	private String titleList;
	
	public GetMatchingTIUNotesFederationTIUCommand(String routingTokenString, String searchText, String titleList,
				String interfaceVersion) {
		super("GetMatchingTIUNotes");
		this.routingTokenString = routingTokenString;
		this.interfaceVersion = interfaceVersion;
		this.searchText = searchText;
		this.titleList = titleList;
	}
	
	public String getRoutingTokenString() {
		return routingTokenString;
	}

	public String getSearchText() {
		return searchText;
	}

	public String getTitleList() {
		return titleList;
	}

	@Override
	protected List<TIUNote> executeRouterCommand() throws MethodException, ConnectionException {
		try {
			//RoutingToken routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(getRoutingTokenString());
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			
			return getRouter().getTIUNotes(routingToken, getSearchText(), getTitleList());
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting matching tiu notes via router", e);
		}
	}

	@Override
	protected String getMethodParameterValuesString() {
		return "acquisition sites from " + getRoutingTokenString();
	}

	@Override
	protected FederationTIUNoteArrayType translateRouterResult(List<TIUNote> routerResult)
			throws TranslationException, MethodException {
		return TIUFederationRestTranslator.translateTIUNotesType(routerResult);
	}

	@Override
	protected Class<FederationTIUNoteArrayType> getResultClass() {
		return FederationTIUNoteArrayType.class;
	}

	//LEARN
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
	public Integer getEntriesReturned(FederationTIUNoteArrayType translatedResult) {
		return translatedResult == null ? 0 : translatedResult.getValues().length;
	}


}
