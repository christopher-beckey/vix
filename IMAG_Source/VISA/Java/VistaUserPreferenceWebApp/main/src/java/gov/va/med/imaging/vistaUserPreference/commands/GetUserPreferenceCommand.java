package gov.va.med.imaging.vistaUserPreference.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestCoreTranslator;
import gov.va.med.imaging.rest.types.RestStringArrayType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Budy Tjahjo
 *
 */
public class GetUserPreferenceCommand
extends AbstractUserPreferenceCommands<List<String>, RestStringArrayType>

{
	private final String siteNumber;
	private final String entity;
	private final String key;
	private final String interfaceVersion;

	public GetUserPreferenceCommand(
			String siteNumber,
			String entity,
			String key,
			String interfaceVersion)
	{
		super("getUserPreference");
		this.siteNumber = siteNumber;
		this.entity = entity;
		this.key = key;
		this.interfaceVersion = interfaceVersion;
	}
	
	@Override
	protected List<String> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken = 
					RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteNumber());
			
			return getRouter().getUserPreference(
					routingToken, 
					getEntity(), 
					getKey());  
		}
		catch(Exception e)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(e);
		}
	}

	private String getKey() {
		return this.key;
	}

	/**
	 * @return the siteNumber
	 */
	public String getSiteNumber()
	{
		return this.siteNumber;
	}
	
	/**
	 * @return the level
	 */
	public String getEntity()
	{
		return this.entity;
	}
	

	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "from site [" + getSiteNumber() + "] level [" + this.getEntity() + "] key [" + this.getKey() + "]";
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<RestStringArrayType> getResultClass()
	{
		return RestStringArrayType.class;
	}


	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}
	
	@Override
	protected RestStringArrayType translateRouterResult(List<String> routerResult)
			throws TranslationException, MethodException {
		return RestCoreTranslator.translateStrings(routerResult);
	}

	@Override
	public Integer getEntriesReturned(RestStringArrayType translatedResult) {
		return translatedResult == null ? 0 :
			(translatedResult.getValue() == null ? 0 : translatedResult.getValue().length);
	}



}

