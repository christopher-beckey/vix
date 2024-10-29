/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jul 19, 2010
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
package gov.va.med.imaging.clinicaldisplay.webservices.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.RoutingTokenImpl;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractClinicalDisplayGetPatientSensitivityCommand<E extends Object>
extends AbstractClinicalDisplayWebserviceCommand<PatientSensitiveValue, E>
{
	private final String siteId;
	private final String patientId;
	
	public AbstractClinicalDisplayGetPatientSensitivityCommand(String siteId, String patientId)
	{
		super("getPatientSensitivityLevel");
		this.siteId = siteId;
		this.patientId = patientId;
	}
	
	public String getSiteId()
	{
		return siteId;
	}

	public String getPatientId()
	{
		return patientId;
	}

	@Override
	protected PatientSensitiveValue executeRouterCommand()
	throws MethodException, ConnectionException
	{
		ClinicalDisplayRouter rtr = getRouter();
		try
		{
			return rtr.getPatientSensitiveValue(RoutingTokenImpl.createVARadiologySite(getSiteId()), 
					getPatientId());
		}
		catch (RoutingTokenFormatException rtfX)
		{			
			throw new MethodException("RoutingTokenFormatException, unable to retrieve patient sensitivity level", rtfX);
		}
	}
	
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for patient '" + getPatientId() + "' at site '" + getSiteId() + "'.";
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getPatientId());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}
}
