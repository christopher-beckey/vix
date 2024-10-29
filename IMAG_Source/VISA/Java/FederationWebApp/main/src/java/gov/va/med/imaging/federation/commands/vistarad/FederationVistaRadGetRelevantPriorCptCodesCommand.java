/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 27, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.federation.commands.vistarad;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationStringArrayType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationVistaRadGetRelevantPriorCptCodesCommand
extends AbstractFederationVistaRadCommand<String[], FederationStringArrayType>
{
	private final String routingTokenString;
	private final String cptCode;
	private final String interfaceVersion;

	public FederationVistaRadGetRelevantPriorCptCodesCommand(String routingTokenString, String cptCode, 
			String interfaceVersion)
	{
		super("getRelevantPriorCptCodes");
		this.routingTokenString = routingTokenString;
		this.cptCode = cptCode;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected String[] executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			FederationRouter router = getRouter();
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());			
			String [] cptCodes = router.getRelevantPriorCptCodes(routingToken, cptCode);
            getLogger().info("{}, transaction({}) got {} CPT Codes from router.", getMethodName(), getTransactionId(), cptCodes == null ? "null" : "" + cptCodes.length);
			return cptCodes;
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
	public Integer getEntriesReturned(FederationStringArrayType translatedResult)
	{
		return translatedResult == null ? 0 : (translatedResult.getValues() == null ? 0 : translatedResult.getValues().length);
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for cptCode '" + getCptCode() + "', at site [" + getRoutingTokenString() + "]";
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
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);		

		return transactionContextFields;
	}

	@Override
	protected FederationStringArrayType translateRouterResult(
			String[] routerResult) 
	throws TranslationException
	{
		return FederationRestTranslator.translateStringArray(routerResult);
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
