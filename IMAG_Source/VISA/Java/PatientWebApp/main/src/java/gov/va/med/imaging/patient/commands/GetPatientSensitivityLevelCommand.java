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
package gov.va.med.imaging.patient.commands;

import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.patient.PatientRouter;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

import com.thoughtworks.xstream.XStream;

/**
 * @author vhaiswlouthj
 *
 */
public class GetPatientSensitivityLevelCommand 
extends AbstractPatientCommand<PatientSensitiveValue, String>
{
	private final PatientIdentifier patientIdentifier;
	private final String interfaceVersion;
	
	public GetPatientSensitivityLevelCommand(PatientIdentifier patientIdentifier,  String interfaceVersion)
	{
		super("logSensitivePatientAccess");
		this.patientIdentifier = patientIdentifier;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected PatientSensitiveValue executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		PatientRouter router = getRouter();		
		PatientSensitiveValue result = router.getPatientSensitivityLevel(getLocalRoutingToken(), patientIdentifier);
		setEntriesReturned(0);
		return result;
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
	protected Class<String> getResultClass() 
	{
		return String.class;
	}

	@Override
	protected String translateRouterResult(PatientSensitiveValue routerResult) 
	throws TranslationException 
	{
		XStream xstream = getXStream();
		xstream.alias("PatientSensitiveLevel", PatientSensitiveValue.class);
    	return xstream.toXML(routerResult);
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
