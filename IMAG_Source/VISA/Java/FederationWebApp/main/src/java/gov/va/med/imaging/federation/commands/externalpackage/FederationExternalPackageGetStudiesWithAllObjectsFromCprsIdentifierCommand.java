/**
 * 
 */
package gov.va.med.imaging.federation.commands.externalpackage;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.GlobalArtifactIdentifierFormatException;
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
import gov.va.med.imaging.federation.rest.types.FederationCprsIdentifierType;
import gov.va.med.imaging.federation.rest.types.FederationFilterType;
import gov.va.med.imaging.federation.rest.types.FederationStudyType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author William Peterson
 *
 */
public class FederationExternalPackageGetStudiesWithAllObjectsFromCprsIdentifierCommand
		extends AbstractFederationCommand<List<Study>, FederationStudyType[]> {

	private final String routingTokenString; 
	private final String patientIcn;
	private final FederationCprsIdentifierType cprsIdentifier;
	private final String interfaceVersion;
	private final String bothdb;

	public FederationExternalPackageGetStudiesWithAllObjectsFromCprsIdentifierCommand(
			String routingTokenString, 
			String patientIcn, 
			FederationCprsIdentifierType cprsIdentifier, 
			String bothdb,
			String interfaceVersion)
	{
		super("getBothDBStudiesFromCprsIdentifier");
		this.routingTokenString = routingTokenString;
		this.cprsIdentifier = cprsIdentifier;
		this.patientIcn = patientIcn;
		this.interfaceVersion = interfaceVersion;
		this.bothdb = bothdb;
	}

	@Override
	protected List<Study> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			FederationRouter router = getRouter();		
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			
			StudyFilter filter = new StudyFilter();
			filter.setIncludeAllObjects(getBothdb().equals("true"));
			filter.setIncludeImages(true);

			List<Study> studies = router.getStudiesByCprsIdentifierAndFilter(
					getPatientIcn(), 
					routingToken, 
					new CprsIdentifier(getCprsIdentifier().getCprsIdentifier()),
					filter);
            getLogger().info("{}, transaction({}) got {} Study business objects from router.", getMethodName(), getTransactionId(), studies == null ? "null" : "" + studies.size());
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
		return "for CprsIdentifier [" + getCprsIdentifier().getCprsIdentifier()
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

	public FederationCprsIdentifierType getCprsIdentifier()
	{
		return cprsIdentifier;
	}
	
	public String getBothdb()
	{
		return bothdb;
	}

}
