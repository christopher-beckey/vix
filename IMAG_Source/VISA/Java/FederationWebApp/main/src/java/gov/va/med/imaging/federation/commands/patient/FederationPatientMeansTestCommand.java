/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 16, 2012
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
package gov.va.med.imaging.federation.commands.patient;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.PatientMeansTestResult;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationPatientMeansTestResultType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationPatientMeansTestCommand
extends AbstractFederationCommand<PatientMeansTestResult, FederationPatientMeansTestResultType>
{

	private final String routingTokenString;
	private final String patientIcn;
	private final String interfaceVersion;
	
	public FederationPatientMeansTestCommand(String routingTokenString, String patientIcn, String interfaceVersion)
	{
		super("getPatientMeansTest");
		this.routingTokenString = routingTokenString;
		this.patientIcn = patientIcn;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected PatientMeansTestResult executeRouterCommand()
	throws MethodException, ConnectionException
	{
		FederationRouter router = getRouter();
		try
		{
			RoutingToken routingToken = FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			PatientMeansTestResult meansTestValue =  
				router.getPatientMeansTest(routingToken, 
						PatientIdentifier.icnPatientIdentifier(getPatientIcn()));
            getLogger().info("{}, transaction({}) got {} PatientMeansTestResult business object from router.", getMethodName(), getTransactionId(), meansTestValue == null ? "null" : "not null");
			return meansTestValue;
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
	public Integer getEntriesReturned(
			FederationPatientMeansTestResultType translatedResult)
	{		
		return null;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for patient [" + getPatientIcn() + "] at site [" + getRoutingTokenString() + "]";
	}

	@Override
	protected Class<FederationPatientMeansTestResultType> getResultClass()
	{
		return FederationPatientMeansTestResultType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIcn());

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	@Override
	protected FederationPatientMeansTestResultType translateRouterResult(
			PatientMeansTestResult routerResult) 
	throws TranslationException
	{
		return FederationRestTranslator.translate(routerResult);
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public String getPatientIcn()
	{
		return patientIcn;
	}
}
