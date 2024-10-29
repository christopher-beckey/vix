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

import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.clinicaldisplay.configuration.ClinicalDisplayWebAppConfiguration;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.util.ExchangeUtil;
import gov.va.med.imaging.exchange.enums.SiteConnectivityStatus;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractClinicalDisplayPingServerCommand<E extends Object>
extends AbstractClinicalDisplayWebserviceCommand<SiteConnectivityStatus, E>
{
	private final String clientWorkstation;
	private final String requestSiteNumber;

	public AbstractClinicalDisplayPingServerCommand(String clientWorkstation, String requestSiteNumber)
	{
		super("pingServerEvent");
		this.clientWorkstation = clientWorkstation;
		this.requestSiteNumber = requestSiteNumber;
	}

	public String getClientWorkstation()
	{
		return clientWorkstation;
	}

	public String getRequestSiteNumber()
	{
		return requestSiteNumber;
	}

	@Override
	protected SiteConnectivityStatus executeRouterCommand()
	throws MethodException, ConnectionException
	{
		SiteConnectivityStatus result = SiteConnectivityStatus.VIX_UNAVAILABLE;
		ClinicalDisplayRouter rtr = getRouter();
		try
		{
			ClinicalDisplayWebAppConfiguration configuration = getClinicalDisplayConfiguration();
			// if the requested site is DOD or if V2V is allowed, then check for site status
			// if not DOD and V2V not allowed, don't bother checking, just return unavailable
			if(ExchangeUtil.isSiteDOD(requestSiteNumber) || (configuration.getAllowV2V()))
			{
				result = rtr.isSiteAvailable(RoutingTokenHelper.createSiteAppropriateRoutingToken(requestSiteNumber));
			}
		}
		catch (RoutingTokenFormatException rtfX)
		{
			throw new MethodException("RoutingTokenFormatException, unable to create site from site number '" + getRequestSiteNumber() + "'.", rtfX);
		}	
		return result;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "from [" + clientWorkstation + "] going to site number [" + requestSiteNumber + "]";
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		//transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}
}
