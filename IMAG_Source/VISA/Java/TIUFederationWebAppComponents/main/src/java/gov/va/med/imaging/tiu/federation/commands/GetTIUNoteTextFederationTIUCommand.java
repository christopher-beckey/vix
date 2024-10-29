package gov.va.med.imaging.tiu.federation.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.URNFactory;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class GetTIUNoteTextFederationTIUCommand 
extends AbstractFederationTIUCommand<String, RestStringType> {

	private String routingTokenString;
	private String interfaceVersion;
	private String patientTIUNoteUrn;
	
	public GetTIUNoteTextFederationTIUCommand(String routingTokenString, String patientTIUNoteUrn,
				String interfaceVersion) {
		super("getTIUNoteText");
		this.routingTokenString = routingTokenString;
		this.interfaceVersion = interfaceVersion;
		this.patientTIUNoteUrn = patientTIUNoteUrn;
	}
	
	public String getRoutingTokenString() {
		return routingTokenString;
	}

	public String getPatientTIUNoteUrn() {
		return patientTIUNoteUrn;
	}

	@Override
	protected String executeRouterCommand() throws MethodException, ConnectionException {
		try {
			PatientTIUNoteURN patientUrn = URNFactory.create(getPatientTIUNoteUrn(), PatientTIUNoteURN.class);

			return getRouter().getTIUNoteText(patientUrn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting tiu note text via router", e);
		}
	}

	@Override
	protected String getMethodParameterValuesString() {
		return "acquisition sites from " + getRoutingTokenString();
	}

	@Override
	protected RestStringType translateRouterResult(String routerResult) throws TranslationException, MethodException {
		return new RestStringType(routerResult);
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
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getPatientTIUNoteUrn());
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
