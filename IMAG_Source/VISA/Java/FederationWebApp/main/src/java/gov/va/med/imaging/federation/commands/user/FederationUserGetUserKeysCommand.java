/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 22, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.federation.commands.user;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationStringArrayType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationUserGetUserKeysCommand
extends AbstractFederationCommand<List<String>, FederationStringArrayType>
{
	private final String routingTokenString;
	private final String interfaceVersion;

	public FederationUserGetUserKeysCommand(String routingToken, String interfaceVersion)
	{
		super("getUserKeys");
		this.routingTokenString = routingToken;
		this.interfaceVersion = interfaceVersion;
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	@Override
	protected List<String> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			FederationRouter router = getRouter();		
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			List<String> keys = router.getUserKeys(routingToken);
            getLogger().info("{}, transaction({}) got {} keys from router.", getMethodName(), getTransactionId(), keys == null ? "null" : "" + keys.size());
			return keys;
		}
		catch(RoutingTokenFormatException rtfX)
		{
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new ConnectionException(rtfX);
		}
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "to site [" + getRoutingTokenString() + "]";
	}

	@Override
	protected FederationStringArrayType translateRouterResult(
			List<String> routerResult) 
	throws TranslationException, MethodException
	{
		return FederationRestTranslator.translateStringList(routerResult);
	}

	@Override
	protected Class<FederationStringArrayType> getResultClass()
	{
		return FederationStringArrayType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, transactionContextNaValue);

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	@Override
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(FederationStringArrayType translatedResult)
	{
		return (translatedResult == null) ? 0 : (translatedResult.getValues() == null ? 0 : translatedResult.getValues().length);
	}
}
