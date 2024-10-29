/**
 * 
 */
package gov.va.med.imaging.federation.commands.externalpackage;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.Map;

/**
 * @author vhaisltjahjb
 *
 */
public class FederationExternalPackageDeleteWorkItemCommand 
extends AbstractFederationCommand<Boolean, RestBooleanReturnType>
{
	private final String routingTokenString; 
	private final String id;
	private final String interfaceVersion;

	public FederationExternalPackageDeleteWorkItemCommand(
			String routingTokenString, 
			String id,
			String interfaceVersion)
	{
		super("deleteWorkItem");
		this.routingTokenString = routingTokenString;
		this.id = id;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected Boolean executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			FederationRouter router = getRouter();		
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			Boolean ok = router.deleteRemoteWorkItem(
					routingToken,
					getId());
			
//			getLogger().info(getMethodName() + ", transaction(" + getTransactionId() + "), deleteWorkItem = "
//					+ ok);

			return ok;
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
	protected String getMethodParameterValuesString()
	{
		return "for work item id [" + getId()
			+ "] at site [" + getRoutingTokenString() + "]";
	}

	@Override
	protected Class<RestBooleanReturnType> getResultClass()
	{
		return RestBooleanReturnType.class;
	}

	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}


	public String getId()
	{
		return id;
	}

	@Override
	protected RestBooleanReturnType translateRouterResult(Boolean routerResult)
			throws TranslationException, MethodException {
		return new RestBooleanReturnType(routerResult);
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() {
		return null;
	}

	@Override
	public Integer getEntriesReturned(RestBooleanReturnType translatedResult) {
		return 1;
	}

}
