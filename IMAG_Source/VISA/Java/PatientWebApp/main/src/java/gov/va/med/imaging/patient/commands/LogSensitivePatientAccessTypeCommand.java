/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 9, 2012
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
package gov.va.med.imaging.patient.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.patient.PatientRouter;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.rest.types.RestCoreTranslator;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author VHAISWWERFEJ
 *
 */
public class LogSensitivePatientAccessTypeCommand
extends AbstractPatientCommand<Boolean, RestBooleanReturnType>
{

	private final String siteId;
	private final PatientIdentifier patientIdentifier;
	private final String interfaceVersion;
	
	public LogSensitivePatientAccessTypeCommand(String siteId,
			PatientIdentifier patientIdentifier,  String interfaceVersion)
	{
		super("logSensitivePatientAccess");
		this.siteId = siteId;
		this.patientIdentifier = patientIdentifier;
		this.interfaceVersion = interfaceVersion;
	}

	public String getSiteId()
	{
		return siteId;
	}

	@Override
	protected Boolean executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		PatientRouter router = getRouter();	
		
		try
		{
			RoutingToken routingToken =
					RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			Boolean result= 
				router.postSensitivePatientAccess(routingToken, patientIdentifier);
			return result;
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}


	@Override
	public String getInterfaceVersion() 
	{
		return this.interfaceVersion;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "patient identifier: [" + patientIdentifier + "]";
	}

	@Override
	protected Class<RestBooleanReturnType> getResultClass() 
	{
		return RestBooleanReturnType.class;
	}

	@Override
	protected RestBooleanReturnType translateRouterResult(Boolean routerResult) 
	throws TranslationException 
	{
		return RestCoreTranslator.translate(routerResult);
	}

	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}
	
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() 
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		if(getPatientIdentifier() != null && patientIdentifier.getPatientIdentifierType() == PatientIdentifierType.icn)
			transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientIdentifier().getValue());

		return transactionContextFields;
	}
}
