/**
 * 
 */
package gov.va.med.imaging.federation.commands.externalpackage;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationWorkItemType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author vhaisltjahjb
 *
 */
public class FederationExternalPackageGetWorkListCommand 
extends AbstractFederationCommand<List<WorkItem>, FederationWorkItemType[]>
{
	private final String routingTokenString; 
	private final String idType;
	private final String patientId;
	private final String cptCode;
	private final String interfaceVersion;

	public FederationExternalPackageGetWorkListCommand(
			String routingTokenString, 
			String idType, 
			String patientId, 
			String cptCode,
			String interfaceVersion)
	{
		super("getWorkList");
		this.routingTokenString = routingTokenString;
		this.cptCode = cptCode;
		this.idType = idType;
		this.patientId = patientId;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<WorkItem> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		getLogger().debug("executing FederationWorkListGetWorkListCommand.");
		FederationRouter router = getRouter();	
		List<WorkItem> workList = null;
		try 
		{
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			workList = router.getRemoteWorkItemList(
					routingToken,
					getIdType(),
					getPatientId(), 
					getCptCode());
            getLogger().info("{}, transaction({}) got {} Workitem business objects from router.", getMethodName(), getTransactionId(), workList == null ? "null" : "" + workList.size());
            getLogger().debug("Number of workitems: {}", workList.size());
			getLogger().debug(workList.toString());
		} catch (RoutingTokenFormatException e) {
			throw new MethodException(e);
		}

		return workList;
	}

	private String getPatientId() 
	{
		return patientId;
	}

	private String getIdType() 
	{
		return idType;
	}

	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(FederationWorkItemType[] translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.length;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for patient [" + getIdType() + "," + getPatientId() + "], cpt code [" + getCptCode()
			+ "] at site [" + getRoutingTokenString() + "]";
	}

	@Override
	protected Class<FederationWorkItemType[]> getResultClass()
	{
		return FederationWorkItemType[].class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientId());

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	@Override
	protected FederationWorkItemType[] translateRouterResult(List<WorkItem> routerResult)
	throws TranslationException
	{
		return FederationRestTranslator.translateWorkItems(routerResult);
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public String getCptCode()
	{
		return cptCode;
	}

}
