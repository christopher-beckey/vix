package gov.va.med.imaging.tiu.federation.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.URNFactory;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class AssociateImageWithTIUNoteFederationTIUCommand 
extends AbstractFederationTIUCommand<Boolean, RestBooleanReturnType> {

	private String routingTokenString;
	private String interfaceVersion;
	private String imageUrn;
	private String patientTIUNoteUrn;
	
	public AssociateImageWithTIUNoteFederationTIUCommand(String routingTokenString, String imageUrn, 
			String patientTIUNoteUrn, String interfaceVersion) {
		super("associateImageWithTIUNote");
		this.routingTokenString = routingTokenString;
		this.interfaceVersion = interfaceVersion;
		this.imageUrn = imageUrn;
		this.patientTIUNoteUrn = patientTIUNoteUrn;

	}
	
	
	public String getRoutingTokenString() {
		return routingTokenString;
	}

	public String getImageUrn() {
		return imageUrn;
	}

	public String getPatientTIUNoteUrn() {
		return patientTIUNoteUrn;
	}

	@Override
	protected Boolean executeRouterCommand() throws MethodException, ConnectionException {
		try {
			AbstractImagingURN imageUrn = URNFactory.create(getImageUrn(), AbstractImagingURN.class);
			PatientTIUNoteURN noteUrn = URNFactory.create(getPatientTIUNoteUrn(), PatientTIUNoteURN.class);
			return getRouter().associateImageWithTIUNote(imageUrn, noteUrn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error associating image with tiu note via router", e);
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
		return 0;
	}

}
