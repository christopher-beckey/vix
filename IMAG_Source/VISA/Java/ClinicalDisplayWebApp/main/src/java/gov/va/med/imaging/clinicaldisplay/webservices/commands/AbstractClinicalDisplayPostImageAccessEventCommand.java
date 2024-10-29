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

import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractClinicalDisplayPostImageAccessEventCommand
extends AbstractClinicalDisplayWebserviceCommand<Boolean, Boolean>
{
	public AbstractClinicalDisplayPostImageAccessEventCommand()
	{
		super("postImageAccessEvent");
	}
	
	protected abstract ImageAccessLogEvent getImageAccessLogEvent()
	throws URNFormatException;

	@Override
	protected Boolean executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		ClinicalDisplayRouter rtr = getRouter(); 
		try
		{
			ImageAccessLogEvent logEvent = getImageAccessLogEvent();
			if(logEvent == null)
			{
				getLogger().warn("ImageAccessLogEvent is null, cannot log entry, returning false.");
				return false;
			}
			else
			{
				rtr.logImageAccessEvent(logEvent);
				return true;
			}
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException("URNFormatException, unable to log image access event", urnfX);
		}		
	}

	@Override
	public Integer getEntriesReturned(Boolean translatedResult)
	{
		return null;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		try
		{
			ImageAccessLogEvent logEvent = getImageAccessLogEvent();
			if(logEvent != null)
			{
				return "[" + logEvent.getEventType().toString() + "]";	
			}
			return null;
		}
		catch(URNFormatException urnfX)
		{
			return null;
		}
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
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);		
		try
		{
			ImageAccessLogEvent logEvent = getImageAccessLogEvent();
			transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, logEvent.getPatientIcn());
			transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, logEvent.getImageIen());
		}
		catch(URNFormatException urnfX)
		{
			getLogger().debug("URNFormatException setting transaction context fields", urnfX);
		}

		return transactionContextFields;
	}

	@Override
	protected Boolean translateRouterResult(Boolean routerResult)
	throws TranslationException
	{
		return routerResult;
	}

	@Override
	protected String getRequestTypeAdditionalDetails()
	{
		return getMethodParameterValuesString();
	}
	
}
