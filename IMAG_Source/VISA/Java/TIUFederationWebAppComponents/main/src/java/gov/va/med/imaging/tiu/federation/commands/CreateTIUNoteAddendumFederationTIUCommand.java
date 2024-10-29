package gov.va.med.imaging.tiu.federation.commands;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import gov.va.med.URNFactory;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.federation.translator.TIUFederationRestTranslator;
import gov.va.med.imaging.tiu.federation.types.FederationTIUNoteAddendumInputType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class CreateTIUNoteAddendumFederationTIUCommand 
extends AbstractFederationTIUCommand<PatientTIUNoteURN, RestStringType> {

	private String routingTokenString;
	private String interfaceVersion;
	private String patientTIUNoteUrn;
	private FederationTIUNoteAddendumInputType addendumTextType;

	public CreateTIUNoteAddendumFederationTIUCommand(String routingTokenString, 
			String patientTIUNoteUrn, FederationTIUNoteAddendumInputType addendumTextType, String interfaceVersion) {
		super("createTIUNoteAddendum");
		this.routingTokenString = routingTokenString;
		this.interfaceVersion = interfaceVersion;
		this.patientTIUNoteUrn = patientTIUNoteUrn;
		this.addendumTextType = addendumTextType;
	}
	
	
	public String getRoutingTokenString() {
		return routingTokenString;
	}
	
	public String getPatientTIUNoteUrn() {
		return patientTIUNoteUrn;
	}
	
	

	public FederationTIUNoteAddendumInputType getAddendumTextType() {
		return addendumTextType;
	}


	@Override
	protected PatientTIUNoteURN executeRouterCommand() throws MethodException, ConnectionException {
		try {
			PatientTIUNoteURN noteUrn = URNFactory.create(getPatientTIUNoteUrn(), PatientTIUNoteURN.class);
			//FIXME
			Date date = new Date(getAddendumTextType().getDate());
			String addendumText = getAddendumTextType().getAddendumText();
			return getRouter().createTIUNoteAddendum(noteUrn, date, addendumText);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error creating TIU note addendum via router", e);
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
