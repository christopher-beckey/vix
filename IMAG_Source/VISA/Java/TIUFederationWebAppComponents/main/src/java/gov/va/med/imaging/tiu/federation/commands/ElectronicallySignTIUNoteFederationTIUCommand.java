package gov.va.med.imaging.tiu.federation.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.URNFactory;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class ElectronicallySignTIUNoteFederationTIUCommand 
extends AbstractFederationTIUCommand<Boolean, RestBooleanReturnType> {

	private String routingTokenString;
	private String interfaceVersion;
	private String patientTIUNoteUrn;
	private RestStringType electronicSignature;

	public ElectronicallySignTIUNoteFederationTIUCommand(String routingTokenString, 
			String patientTIUNoteUrn, RestStringType electronicSignature, String interfaceVersion) {
		super("ElectronicallySignTIUNote");
		this.routingTokenString = routingTokenString;
		this.interfaceVersion = interfaceVersion;
		this.patientTIUNoteUrn = patientTIUNoteUrn;
		this.electronicSignature = electronicSignature;
		
	}
	

	public String getRoutingTokenString() {
		return routingTokenString;
	}

	public String getPatientTIUNoteUrn() {
		return patientTIUNoteUrn;
	}

	public RestStringType getElectronicSignature() {
		return electronicSignature;
	}

	@Override
	protected Boolean executeRouterCommand() throws MethodException, ConnectionException {
		try {
			PatientTIUNoteURN patientTIUNoteUrn = URNFactory.create(getPatientTIUNoteUrn(), PatientTIUNoteURN.class);

			return getRouter().electronicallyFileNote(patientTIUNoteUrn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error electronically filing tiu note via router", e);
		}
	}
	@Override
	protected String getMethodParameterValuesString() {
		return "acquisition sites from " + getRoutingTokenString();
	}
	@Override
	protected RestBooleanReturnType translateRouterResult(Boolean routerResult)
			throws TranslationException, MethodException {
		return new RestBooleanReturnType(routerResult);
	}
	@Override
	protected Class<RestBooleanReturnType> getResultClass() {
		return RestBooleanReturnType.class;
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
	public Integer getEntriesReturned(RestBooleanReturnType translatedResult) {
		return translatedResult == null ? 0 : 1;
	}
	
	
	
}
