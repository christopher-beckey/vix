package gov.va.med.imaging.consult.federation.commands;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.consult.Consult;
import gov.va.med.imaging.consult.federation.translator.ConsultFederationRestTranslator;
import gov.va.med.imaging.consult.federation.types.FederationConsultArrayType;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

public class FederationConsultGetPatientConsultsCommand 
extends AbstractFederationConsultCommand<List<Consult>, FederationConsultArrayType> 
{
	
	private final String routingTokenString; 
	private final String patientIcn;
	private final String interfaceVersion;


	public FederationConsultGetPatientConsultsCommand(String routingTokenString, String patientIcn,
			String interfaceVersion) {
		super("getPatientConsults");
		this.routingTokenString = routingTokenString;
		this.patientIcn = patientIcn;
		this.interfaceVersion = interfaceVersion;
	}


	@Override
	protected List<Consult> executeRouterCommand() throws MethodException, ConnectionException {
		try
		{
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			PatientIdentifier patientIdentifier = new PatientIdentifier(getPatientIcn(), PatientIdentifierType.icn);

			return getRouter().getPatientConsults(routingToken, patientIdentifier);
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}


	@Override
	protected String getMethodParameterValuesString() {
		return "for patientIcn [" + patientIcn
				+ "] at site [" + getRoutingTokenString() + "]";
	}


	@Override
	protected FederationConsultArrayType translateRouterResult(List<Consult> routerResult)
			throws TranslationException, MethodException {
		return ConsultFederationRestTranslator.translateConsults(routerResult);
	}


	@Override
	protected Class<FederationConsultArrayType> getResultClass() {
		return FederationConsultArrayType.class;
	}


	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() {
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
				new HashMap<WebserviceInputParameterTransactionContextField, String>();
			
			transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIcn());

			return transactionContextFields;
	}


	@Override
	public String getInterfaceVersion() {
		return this.interfaceVersion;
	}


	@Override
	public Integer getEntriesReturned(FederationConsultArrayType translatedResult) {
		return translatedResult == null ? 0 : translatedResult.getValues().length;
	}


	public String getRoutingTokenString() {
		return routingTokenString;
	}


	public String getPatientIcn() {
		return patientIcn;
	}


	@Override
	public void setAdditionalTransactionContextFields() {
		// TODO Auto-generated method stub
		
	}


	
}
