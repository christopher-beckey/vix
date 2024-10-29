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
package gov.va.med.imaging.federation.commands.vistarad;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.vistarad.PatientRegistration;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationPatientRegistrationType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationVistaRadGetNextPatientRegistrationCommand 
extends AbstractFederationVistaRadCommand<PatientRegistration, FederationPatientRegistrationType> 
{
	private final String routingTokenString;
	private final String interfaceVersion;

	public FederationVistaRadGetNextPatientRegistrationCommand(String routingTokenString, String interfaceVersion)
	{	
		super("getNextPatientRegistration");
		this.routingTokenString = routingTokenString;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected PatientRegistration executeRouterCommand()
	throws MethodException, ConnectionException 
	{
		FederationRouter router = getRouter();
		
		try
		{
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			PatientRegistration patientRegistration = router.getNextPatientRegistration(routingToken);
            getLogger().info("{}, transaction({}) got {} patient registration business object from router.", getMethodName(), getTransactionId(), patientRegistration == null ? "null" : "not null");
			return patientRegistration;
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
	protected String getMethodParameterValuesString() {
		return "at site [" + getRoutingTokenString() + "]";
	}

	@Override
	protected Class<FederationPatientRegistrationType> getResultClass() 
	{
		return FederationPatientRegistrationType.class;
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
	protected FederationPatientRegistrationType translateRouterResult(
			PatientRegistration routerResult) 
	throws TranslationException 
	{
		return FederationRestTranslator.translate(routerResult);
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	@Override
	public Integer getEntriesReturned(
			FederationPatientRegistrationType translatedResult)
	{
		return null;
	}
}
