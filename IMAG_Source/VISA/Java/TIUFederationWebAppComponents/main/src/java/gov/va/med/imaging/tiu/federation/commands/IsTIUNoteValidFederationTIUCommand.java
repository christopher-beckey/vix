package gov.va.med.imaging.tiu.federation.commands;

import java.util.HashMap;
import java.util.Map;

import javax.ws.rs.PathParam;

import gov.va.med.RoutingToken;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class IsTIUNoteValidFederationTIUCommand 
extends AbstractFederationTIUCommand<Boolean, RestBooleanReturnType> {

	private String routingTokenString;
	private String interfaceVersion;
	private String tiuNoteUrn;
	private String patientTiuNoteUrn;
	private String typeIndex;
	
	public IsTIUNoteValidFederationTIUCommand(String routingTokenString, String tiuNoteUrn,
			String patientTiuNoteUrn, String typeIndex,	String interfaceVersion) 
	{
		super("isTIUNoteValidFederation");
		this.routingTokenString = routingTokenString;
		this.tiuNoteUrn = tiuNoteUrn;
		this.patientTiuNoteUrn = patientTiuNoteUrn;
		this.typeIndex = typeIndex;
		this.interfaceVersion = interfaceVersion;
	}

	public String getRoutingTokenString() {
		return routingTokenString;
	}

	public String getTiuNoteUrn() {
		return tiuNoteUrn;
	}

	public String getPatientTiuNoteUrn() {
		return patientTiuNoteUrn;
	}

	public String getTypeIndex() {
		return typeIndex;
	}

	@Override
	protected Boolean executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		try {
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			TIUItemURN noteUrn = null;
			PatientTIUNoteURN patientNoteUrn = null;
			
			if (getTiuNoteUrn() != null)
				noteUrn = URNFactory.create(getTiuNoteUrn(), TIUItemURN.class);
			
			if (getPatientTiuNoteUrn() != null)
				patientNoteUrn = parsePatientTIUNoteUrn(getPatientTiuNoteUrn());
			return getRouter().isTiuNoteValid(routingToken, noteUrn, patientNoteUrn, getTypeIndex());
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error checking if tiu note is valid via router", e);
		}
	}

	private PatientTIUNoteURN parsePatientTIUNoteUrn(String noteUrnString)
	throws MethodException
	{
		try
		{
			return URNFactory.create(noteUrnString, PatientTIUNoteURN.class);
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException(urnfX);
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
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getPatientTiuNoteUrn());
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
