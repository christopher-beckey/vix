package gov.va.med.imaging.vistaUserPreference.commands;


import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Budy Tjahjo
 *
 */
public class DeleteUserPreferenceUserEntityCommand
extends AbstractUserPreferenceCommands<String, RestStringType>
{
	private final String siteNumber;
	private final String userID;
	private final String key;
	private final String interfaceVersion;

	public DeleteUserPreferenceUserEntityCommand(
			String siteNumber,
			String userID,
			String key,
			String interfaceVersion)
	{
		super("deleteUserPreference");
		this.siteNumber = siteNumber;
		this.userID = userID;
		this.key = key;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken = 
					RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteNumber());
			return getRouter().deleteUserPreference(routingToken, "USR.`" + getUserID(), getKey());
		}
		catch(Exception e)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(e);
		}
	}

	/**
	 * @return the siteNumber
	 */
	public String getSiteNumber()
	{
		return this.siteNumber;
	}
	
	/**
	 * @return the userID
	 */
	public String getUserID()
	{
		return userID;
	}
	
	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(RestStringType translatedResult)
	{
		return 1; 
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "from site [" + getSiteNumber() + "] userID [" + this.getUserID() + "] key [" + this.getKey() + "]";
	}

	
	private String getKey() {
		return this.key;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<RestStringType> getResultClass()
	{
		return RestStringType.class;
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
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected RestStringType translateRouterResult(String routerResult)
	throws TranslationException, MethodException
	{
		return new RestStringType(routerResult);
	}



}


