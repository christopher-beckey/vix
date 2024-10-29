package gov.va.med.imaging.tiu.federation.commands;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.PatientIdentifierParseException;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.tiu.PatientTIUNote;
import gov.va.med.imaging.tiu.enums.TIUNoteRequestStatus;
import gov.va.med.imaging.tiu.federation.translator.TIUFederationRestTranslator;
import gov.va.med.imaging.tiu.federation.types.FederationPatientTIUNoteArrayType;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteInputParametersType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class GetPatientTIUNotesFederationTIUCommand 
extends AbstractFederationTIUCommand<List<PatientTIUNote>, FederationPatientTIUNoteArrayType> {

	private String routingTokenString;
	private String interfaceVersion;
	private FederationTIUNoteInputParametersType parameters;
	
	public GetPatientTIUNotesFederationTIUCommand(String routingTokenString, 
				FederationTIUNoteInputParametersType parameters, String interfaceVersion) {
		super("getPatientTIUNotes");
		this.routingTokenString = routingTokenString;
		this.interfaceVersion = interfaceVersion;
		this.parameters = parameters;
	}

	public String getRoutingTokenString() {
		return routingTokenString;
	}

	public FederationTIUNoteInputParametersType getParameters() {
		return parameters;
	}

	@Override
	protected List<PatientTIUNote> executeRouterCommand() throws MethodException, ConnectionException {
		try {
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			PatientIdentifier patientIdentifier = PatientIdentifier.fromString(getParameters().getPatientIdentifier().getValue());
			TIUNoteRequestStatus status = TIUFederationRestTranslator.translate(getParameters().getNoteStatus());
			return getRouter().getPatientTIUNotes(routingToken, status, patientIdentifier, 
					convertDateString(getParameters().getFromDate()), convertDateString(getParameters().getToDate()), getParameters().getAuthorDuz(), 
					getParameters().getCount(), getParameters().isAscending());
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting patient tiu notes via router", e);
		}
	}

	@Override
	protected String getMethodParameterValuesString() {
		return "acquisition sites from " + getRoutingTokenString();
	}

	@Override
	protected FederationPatientTIUNoteArrayType translateRouterResult(List<PatientTIUNote> routerResult)
			throws TranslationException, MethodException {
		return TIUFederationRestTranslator.translatePatientTIUNotes(routerResult);
	}

	@Override
	protected Class<FederationPatientTIUNoteArrayType> getResultClass() {
		return FederationPatientTIUNoteArrayType.class;
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
	public Integer getEntriesReturned(FederationPatientTIUNoteArrayType translatedResult) {
		return translatedResult == null ? 0 : translatedResult.getValues().length;
	}
	
	private Date convertDateString(String strDate){
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:sszzz");
	    Date date = null;

		if(strDate != null && !strDate.equals("")){
			try {
				date = sdf.parse(strDate);
			} catch (ParseException pX) {
				getLogger().warn("Failed to parse a Date. Will continue query without this query field.  ", pX);
			}
		}
		return date;

	}
	
}
