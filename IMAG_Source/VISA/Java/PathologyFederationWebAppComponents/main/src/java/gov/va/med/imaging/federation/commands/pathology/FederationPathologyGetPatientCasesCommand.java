/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 22, 2012
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
package gov.va.med.imaging.federation.commands.pathology;

import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.pathology.rest.translator.PathologyFederationRestTranslator;
import gov.va.med.imaging.federation.pathology.rest.types.PathologyFederationCaseType;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.pathology.PathologyCase;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationPathologyGetPatientCasesCommand
extends AbstractFederationPathologyCommand<List<PathologyCase>, PathologyFederationCaseType[]>
{
	private final String routingTokenString;
	private final String patientIcn;
	private final String requestingSiteId;
	private final String interfaceVersion;

	/**
	 * @param methodName
	 */
	public FederationPathologyGetPatientCasesCommand(String routingTokenString, String patientIcn, String requestingSiteId,
			String interfaceVersion)
	{
		super("getPathologyPatientCases");
		this.routingTokenString = routingTokenString;
		this.patientIcn = patientIcn;
		this.requestingSiteId = requestingSiteId;
		this.interfaceVersion = interfaceVersion;
	}
	
	public FederationPathologyGetPatientCasesCommand(String routingTokenString, String patientIcn, 
			String interfaceVersion)
	{
		this(routingTokenString, patientIcn, null, interfaceVersion);
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public String getPatientIcn()
	{
		return patientIcn;
	}

	public String getRequestingSiteId()
	{
		return requestingSiteId;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected List<PathologyCase> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken = 
				FederationRestTranslator.translateRoutingToken(getRoutingTokenString());
			if(getRequestingSiteId() == null)
				return getRouter().getPatientCases(routingToken, 
						new PatientIdentifier(getPatientIcn(), PatientIdentifierType.icn));
			else
				return getRouter().getPatientCases(routingToken, 
					new PatientIdentifier(getPatientIcn(), PatientIdentifierType.icn),
					getRequestingSiteId());
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for patient '" + getPatientIcn() + "'" + (getRequestingSiteId() == null ? "." : " to requesting site '" + getRequestingSiteId() + "'.");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected PathologyFederationCaseType[] translateRouterResult(
			List<PathologyCase> routerResult) 
	throws TranslationException, MethodException
	{
		return PathologyFederationRestTranslator.translateCases(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<PathologyFederationCaseType[]> getResultClass()
	{
		return PathologyFederationCaseType[].class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getTransactionContextFields()
	 */
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
	public Integer getEntriesReturned(
			PathologyFederationCaseType[] translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.length;
	}

}
