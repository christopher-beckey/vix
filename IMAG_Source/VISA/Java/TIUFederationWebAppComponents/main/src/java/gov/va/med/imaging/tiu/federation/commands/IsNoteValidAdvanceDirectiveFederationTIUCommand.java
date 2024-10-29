package gov.va.med.imaging.tiu.federation.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.URNFactory;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class IsNoteValidAdvanceDirectiveFederationTIUCommand 
extends AbstractFederationTIUCommand<Boolean, RestBooleanReturnType> {

	private String routingTokenString;
	private String interfaceVersion;
	private String tiuItemUrn;

	
	public IsNoteValidAdvanceDirectiveFederationTIUCommand(String routingTokenString, String tiuItemUrn,
				String interfaceVersion) {
		super("isNoteValidAdvanceDirective");
		this.routingTokenString = routingTokenString;
		this.interfaceVersion = interfaceVersion;
		this.tiuItemUrn = tiuItemUrn;
		
	}

	public String getRoutingTokenString() {
		return routingTokenString;
	}

	public String getTiuItemUrn() {
		return tiuItemUrn;
	}

	@Override
	protected Boolean executeRouterCommand() throws MethodException, ConnectionException {
		try {
			TIUItemURN itemUrn = URNFactory.create(getTiuItemUrn(), TIUItemURN.class);

			return getRouter().isTiuNoteAdvanceDirective(itemUrn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error checking if tiu note is advance directive via router", e);
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
	public Integer getEntriesReturned(RestBooleanReturnType translatedResult) {
		return translatedResult == null ? 0 : 1;
	}
	
	
}
