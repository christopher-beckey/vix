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
package gov.va.med.imaging.federation.commands.patient;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationPatientType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationPatientSearchCommand 
extends AbstractFederationCommand<List<Patient>, FederationPatientType []>
{
	private final String routingTokenString;
	private final String searchName;
	private final String interfaceVersion;
	
	public FederationPatientSearchCommand(String routingTokenString, String searchName, 
			String interfaceVersion)
	{
		super("searchPatients");
		this.routingTokenString = routingTokenString;
		this.searchName = searchName;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<Patient> executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		try
		{
			FederationRouter router = getRouter();		
			List<Patient> patients = 
				router.getPatientList(searchName, FederationRestTranslator.translateRoutingToken(getRoutingTokenString()) );
            getLogger().info("{}, transaction({}) got {} Patient business objects from router.", getMethodName(), getTransactionId(), patients == null ? "null" : "" + patients.size());
			return patients;
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
	protected String getMethodParameterValuesString() 
	{
		return "at site [" + getRoutingTokenString() + "]";
	}

	@Override
	protected Class<FederationPatientType[]> getResultClass() 
	{
		return FederationPatientType[].class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() 
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields() 
	{
		
	}

	@Override
	protected FederationPatientType[] translateRouterResult(
			List<Patient> routerResult) 
	throws TranslationException 
	{
		return FederationRestTranslator.translatePatientList(routerResult);
	}

	public String getRoutingTokenString()
	{
		return routingTokenString;
	}

	public String getSearchName()
	{
		return searchName;
	}

	@Override
	public Integer getEntriesReturned(FederationPatientType[] translatedResult)
	{
		return translatedResult == null ? 0 : translatedResult.length;
	}

}
