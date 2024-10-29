/**
 * 
 */
package gov.va.med.imaging.federation.commands.externalpackage;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationCprsIdentifiersType;
import gov.va.med.imaging.federation.rest.types.FederationStudyType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author William Peterson
 *
 */
public class FederationExternalPackagePostStudiesFromCprsIdentifiersCommand
		extends AbstractFederationCommand<List<Study>, FederationStudyType[]> {
			
	private final String routingTokenString; 
	private final String patientIcn;
	private final FederationCprsIdentifiersType cprsIdentifiers;
	private final String interfaceVersion;

	public FederationExternalPackagePostStudiesFromCprsIdentifiersCommand(String routingTokenString, 
			String patientIcn, 
			FederationCprsIdentifiersType cprsIdentifiers,
			String interfaceVersion){
		super("postStudiesFromCprsIdentifiers");
		this.routingTokenString = routingTokenString;
		this.cprsIdentifiers = cprsIdentifiers;
		this.patientIcn = patientIcn;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<Study> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		getLogger().debug("executing FederationExternalPackagePostStudiesFromCprsIdentifiersCommand.");
		try
		{
			FederationRouter router = getRouter();		
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			List<Study> studies = router.postStudiesByCprsIdentifiers(
					PatientIdentifier.icnPatientIdentifier(getPatientIcn()), 
					routingToken, 
					getCprsIdentifiers());

            getLogger().info("{}, transaction({}) got {} Study business objects from router.", getMethodName(), getTransactionId(), studies == null ? "null" : "" + studies.size());
            getLogger().debug("Number of studies: {}", studies.size());
			getLogger().debug(studies.toString());

			return studies;
		}
		catch(RoutingTokenFormatException rtfX)
		{
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new ConnectionException(rtfX);
		}
	}

	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(FederationStudyType[] translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.length;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for CprsIdentifier [" + getCprsIdentifiers().get(0)
			+ "] at site [" + getRoutingTokenString() + "]";
	}

	@Override
	protected Class<FederationStudyType[]> getResultClass()
	{
		return FederationStudyType[].class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIcn());

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	@Override
	protected FederationStudyType[] translateRouterResult(List<Study> routerResult)
	throws TranslationException
	{
		return FederationRestTranslator.translate(routerResult);
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public String getPatientIcn()
	{
		return patientIcn;
	}

	public List<CprsIdentifier> getCprsIdentifiers()
	{
		return FederationRestTranslator.translate(cprsIdentifiers);
	}

}
