/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 27, 2010
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
package gov.va.med.imaging.federation.commands.imageaccesslogging;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationImageAccessLogEventType;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.rest.types.RestCoreTranslator;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationImageAccessLoggingPostImageAccessCommand
extends AbstractFederationCommand<Boolean, RestBooleanReturnType>
{
	private final FederationImageAccessLogEventType logEvent;
	private final String interfaceVersion;

	public FederationImageAccessLoggingPostImageAccessCommand(FederationImageAccessLogEventType logEvent,
			String interfaceVersion)
	{
		super("postImageAccessEvent");
		this.logEvent = logEvent;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected Boolean executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		ImageAccessLogEvent event = FederationRestTranslator.translate(getLogEvent());
		FederationRouter router = getRouter();
		router.logImageAccessEvent(event);
		return true;
	}

	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(RestBooleanReturnType translatedResult)
	{
		return null;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "image [" + getLogEvent().getImageId() + "].";
	}

	@Override
	protected Class<RestBooleanReturnType> getResultClass()
	{
		return RestBooleanReturnType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getLogEvent().getImageId());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, getLogEvent().getPatientIcn());

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	@Override
	protected RestBooleanReturnType translateRouterResult(Boolean routerResult)
	throws TranslationException
	{
		return RestCoreTranslator.translate(routerResult);
	}

	public FederationImageAccessLogEventType getLogEvent()
	{
		return logEvent;
	}
	
	@Override
	protected String getRequestTypeAdditionalDetails()
	{
		if(getLogEvent() == null)
			return null;
		return "[" + getLogEvent().getEventType() + "]";
	}
}
