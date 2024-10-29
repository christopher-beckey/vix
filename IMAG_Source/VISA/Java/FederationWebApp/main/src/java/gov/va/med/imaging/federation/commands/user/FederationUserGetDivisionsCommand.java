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
import gov.va.med.imaging.exchange.business.Division;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationDivisionType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationUserGetDivisionsCommand
extends AbstractFederationCommand<List<Division>, FederationDivisionType[]>
{
	private final String routingTokenString;
	private final String accessCode;
	private final String interfaceVersion;
	
	public FederationUserGetDivisionsCommand(String routingTokenString, String accessCode,
			String interfaceVersion)
	{
		super("getUserDivisions");
		this.routingTokenString = routingTokenString;
		this.accessCode = accessCode;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<Division> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			FederationRouter router = getRouter();		
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			List<Division> divisions = router.getDivisionList(getAccessCode(), routingToken);
            getLogger().info("{}, transaction({}) got {} divisions from router.", getMethodName(), getTransactionId(), divisions == null ? "null" : "" + divisions.size());
			return divisions;
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
	protected FederationDivisionType[] translateRouterResult(
			List<Division> routerResult) 
	throws TranslationException, MethodException
	{
		return FederationRestTranslator.translateDivisionList(routerResult);
	}

	@Override
	protected Class<FederationDivisionType[]> getResultClass()
	{
		return FederationDivisionType[].class;
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
	public Integer getEntriesReturned(FederationDivisionType[] translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.length;
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public String getAccessCode()
	{
		return accessCode;
	}

}
