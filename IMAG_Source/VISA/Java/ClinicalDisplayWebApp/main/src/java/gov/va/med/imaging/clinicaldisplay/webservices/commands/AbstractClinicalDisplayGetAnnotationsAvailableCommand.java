/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 17, 2011
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
package gov.va.med.imaging.clinicaldisplay.webservices.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author VHAISWWERFEJ
 *
 */
public abstract class AbstractClinicalDisplayGetAnnotationsAvailableCommand
extends AbstractClinicalDisplayWebserviceCommand<Boolean, Boolean>
{
	private final String siteId;
	
	public AbstractClinicalDisplayGetAnnotationsAvailableCommand(String siteId)
	{
		super("getAnnotationsAvailable");
		this.siteId = siteId;
	}

	public String getSiteId()
	{
		return siteId;
	}

	@Override
	protected Boolean executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			RoutingToken routingToken = 
				RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId());
			ClinicalDisplayRouter rtr = getRouter();
			return rtr.isSiteAnnotationSupported(routingToken);
		}
		catch (RoutingTokenFormatException rtfX)
		{
			throw new MethodException("RoutingTokenFormatException, unable to create site from site number '" + getSiteId() + "'.", rtfX);
		}
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for site '" + getSiteId() + "'.";
	}

	@Override
	protected Boolean translateRouterResult(Boolean routerResult)
	throws TranslationException, MethodException
	{
		return routerResult;
	}
	
	@Override
	protected Class<Boolean> getResultClass()
	{
		return Boolean.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}
	
	@Override
	public Integer getEntriesReturned(Boolean translatedResult)
	{
		return null;
	}

}
