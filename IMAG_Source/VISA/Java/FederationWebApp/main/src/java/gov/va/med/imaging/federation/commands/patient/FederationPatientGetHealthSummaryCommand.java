/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 8, 2012
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

import gov.va.med.HealthSummaryURN;
import gov.va.med.PatientIdentifier;
import gov.va.med.URNFactory;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.rest.types.RestCoreTranslator;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.Map;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationPatientGetHealthSummaryCommand
extends AbstractFederationCommand<String, RestStringType>
{
	private final String healthSummaryId;
	private final String patientIcn;
	private final String interfaceVersion;

	/**
	 * @param methodName
	 */
	public FederationPatientGetHealthSummaryCommand(String healthSummaryId, String patientIcn, String interfaceVersion)
	{
		super("getPatientHealthSummary");
		this.healthSummaryId = healthSummaryId;
		this.patientIcn = patientIcn;
		this.interfaceVersion = interfaceVersion;
	}

	public String getHealthSummaryId()
	{
		return healthSummaryId;
	}

	public String getPatientIcn()
	{
		return patientIcn;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		FederationRouter router = getRouter();
		try
		{
			HealthSummaryURN healthSummaryUrn = 
				URNFactory.create(getHealthSummaryId(), HealthSummaryURN.class);
			String result = router.getHealthSummary(healthSummaryUrn, 
					PatientIdentifier.icnPatientIdentifier(getPatientIcn()));
            getLogger().info("{}, transaction({}) got {} Health Summary business object from router.", getMethodName(), getTransactionId(), result == null ? "null" : "not null");
			return result;
		}
		catch(URNFormatException urnfX)
		{
			// must throw new instance of exception or else Jersey translates it to a 500 error
			throw new ConnectionException(urnfX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for summary '" + getHealthSummaryId() + "' for patient '" + getPatientIcn() + "'.";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected RestStringType translateRouterResult(String routerResult)
	throws TranslationException, MethodException
	{
		return RestCoreTranslator.translate(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<RestStringType> getResultClass()
	{
		return RestStringType.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getTransactionContextFields()
	 */
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#setAdditionalTransactionContextFields()
	 */
	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getInterfaceVersion()
	 */
	@Override
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(RestStringType translatedResult)
	{
		return null;
	}

}
