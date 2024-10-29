/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 26, 2010
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
package gov.va.med.imaging.federation.commands.passthrough;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.PassthroughInputMethod;
import gov.va.med.imaging.exchange.enums.ImagingSecurityContextType;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationRemoteMethodType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationPassthroughRemoteMethodCommand
extends AbstractFederationCommand<String, String>
{
	private final String routingTokenString;
	private final FederationRemoteMethodType federationRemoteMethodType;
	private final String interfaceVersion;
	
	public FederationPassthroughRemoteMethodCommand(String routingTokenString, 
			FederationRemoteMethodType federationRemoteMethodType, String interfaceVersion)
	{
		super("remoteMethodPassthrough");
		this.routingTokenString = routingTokenString;
		this.federationRemoteMethodType = federationRemoteMethodType;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			PassthroughInputMethod inputMethod = FederationRestTranslator.translate(getFederationRemoteMethodType());
			TransactionContext transactionContext = getTransactionContext();			
			FederationRouter router = getRouter();
			String result = router.postPassthroughMethod(FederationRestTranslator.translateRoutingToken(getRoutingTokenString()), 
					inputMethod);
            getLogger().info("{}, transaction({}) got {} bytes back from router.", getMethodName(), getTransactionId(), result == null ? "null" : "" + result.length());
			transactionContext.setFacadeBytesSent(result == null ? 0L : result.length());
			return result;
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
		return interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(String translatedResult)
	{
		return null;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "method '" + getFederationRemoteMethodType().getMethodName() + "'";
	}

	@Override
	protected Class<String> getResultClass()
	{
		return String.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, transactionContextNaValue);
		// here so it can set the method name, will overwrite value set in abstract class
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.requestType, getWepAppName() + " " + getInterfaceVersion() +  " " + getMethodName() + "(" + getFederationRemoteMethodType().getMethodName() + ")");

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields()
	{
		ImagingSecurityContextType securityContext = ImagingSecurityContextType.MAG_WINDOWS;
		String imagingContextType = getFederationRemoteMethodType().getImagingSecurityContext();
		if((imagingContextType != null) && (imagingContextType.length() > 0))
		{
			securityContext = ImagingSecurityContextType.valueOf(imagingContextType);	
		}
		getTransactionContext().setImagingSecurityContextType(securityContext.toString());		
	}

	@Override
	protected String translateRouterResult(String routerResult)
	throws TranslationException
	{		
		return routerResult;
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public FederationRemoteMethodType getFederationRemoteMethodType()
	{
		return federationRemoteMethodType;
	}
}
