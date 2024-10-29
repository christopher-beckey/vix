package gov.va.med.imaging.tiu.federation.commands;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import gov.va.med.PatientIdentifier;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.PatientIdentifierParseException;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.federation.translator.TIUFederationRestTranslator;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteInputType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class CreateTIUNoteFederationTIUCommand 
extends AbstractFederationTIUCommand<PatientTIUNoteURN, RestStringType> {

	private String routingTokenString;
	private String interfaceVersion;
	private FederationTIUNoteInputType inputType;

	public CreateTIUNoteFederationTIUCommand(String routingTokenString, 
			FederationTIUNoteInputType inputType, String interfaceVersion) {
		super("createTIUNote");
		this.routingTokenString = routingTokenString;
		this.interfaceVersion = interfaceVersion;
		this.inputType = inputType;
	}
	
	
	public String getRoutingTokenString() {
		return routingTokenString;
	}

	public FederationTIUNoteInputType getInputType() {
		return inputType;
	}

	@Override
	protected PatientTIUNoteURN executeRouterCommand() throws MethodException, ConnectionException {
		try {
			// Get input type
			FederationTIUNoteInputType inputType = getInputType();

			// Get note urn
			TIUItemURN noteUrn = null;
			if ((inputType.getNoteUrn() != null) && (inputType.getNoteUrn().getValue() != null)) {
				noteUrn = URNFactory.create(inputType.getNoteUrn().getValue(), TIUItemURN.class);
			}

			// Get location urn
			TIUItemURN locationUrn = null;
			if ((inputType.getLocationUrn() != null) && (inputType.getLocationUrn().getValue() != null)) {
				locationUrn = URNFactory.create(inputType.getLocationUrn().getValue(), TIUItemURN.class);
			}

			// Get patient identifier
			PatientIdentifier patientIdentifier = null;
			if ((inputType.getPatientIdentifier() != null) && (inputType.getPatientIdentifier().getValue() != null)) {
				patientIdentifier = PatientIdentifier.fromString(inputType.getPatientIdentifier().getValue());
			}

			// Get note date
			Date noteDate = inputType.getNoteDate();

			// Get consult urn
			ConsultURN consultUrn = null;
			if ((inputType.getConsultUrn() != null) && (inputType.getConsultUrn().getValue().length() > 0)) {
				consultUrn = URNFactory.create(inputType.getConsultUrn().getValue(), ConsultURN.class);
			}

			// Get note text
			String noteText = null;
			if ((inputType.getNoteText() != null) && (inputType.getNoteText().getValue() != null)) {
				noteText = TIUFederationRestTranslator.translate(inputType.getNoteText());
				if (noteText == null) {
					noteText = "";
				}
			}

			// Get author urn
			TIUItemURN authorUrn = null;
			if ((inputType.getAuthorUrn() != null) && (inputType.getAuthorUrn().getValue() != null) && (inputType.getAuthorUrn().getValue().length() > 0)) {
				authorUrn = URNFactory.create(inputType.getAuthorUrn().getValue(), TIUItemURN.class);
			}

			// Call service
			return getRouter().createTIUNote(noteUrn, patientIdentifier, locationUrn, noteDate, consultUrn, noteText, authorUrn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error TIU note via router", e);
		}
	}
	@Override
	protected String getMethodParameterValuesString() {
		return "acquisition sites from " + getRoutingTokenString();
	}
	@Override
	protected RestStringType translateRouterResult(PatientTIUNoteURN routerResult)
			throws TranslationException, MethodException {
		return TIUFederationRestTranslator.translateUrn(routerResult);
	}
	@Override
	protected Class<RestStringType> getResultClass() {
		return RestStringType.class;
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
	public Integer getEntriesReturned(RestStringType translatedResult) {
		return translatedResult == null ? 0 : 1;
	}

	
}
