package gov.va.med.imaging.vistaUserPreference.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.vistaUserPreference.rest.translator.UserPreferenceRestTranslator;
import gov.va.med.imaging.vistaUserPreference.rest.types.UserPreferenceKeysType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Budy Tjahjo
 *
 */
public class GetUserPreferenceKeysUserEntityCommand
extends AbstractUserPreferenceCommands<List<String>, UserPreferenceKeysType>

{
	private final String siteNumber;
	private final String userID;
	private final String interfaceVersion;

	public GetUserPreferenceKeysUserEntityCommand(
			String siteNumber,
			String userID,
			String interfaceVersion)
	{
		super("getUserPreferenceUserEntity");
		this.siteNumber = siteNumber;
		this.userID = userID;
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
			return getRouter().getUserPreferenceKeys(routingToken, "USR.`" + getUserID());  
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
		return this.userID;
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
		return "from site [" + getSiteNumber() + "] userID [" + this.getUserID() + "]";
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<UserPreferenceKeysType> getResultClass()
	{
		return UserPreferenceKeysType.class;
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
	protected UserPreferenceKeysType translateRouterResult(List<String> routerResult)
			throws TranslationException, MethodException {
		return UserPreferenceRestTranslator.translateUserPreferenceKeys(routerResult);
	}

	@Override
	public Integer getEntriesReturned(UserPreferenceKeysType translatedResult) {
		return translatedResult == null ? 0: 
			(translatedResult.getUserPreferenceKeys() == null ? 0 : translatedResult.getUserPreferenceKeys().length);
	}



}
