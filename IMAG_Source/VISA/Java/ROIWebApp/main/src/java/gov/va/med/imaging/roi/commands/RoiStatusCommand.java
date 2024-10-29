/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 23, 2012
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
package gov.va.med.imaging.roi.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.rest.translator.ROIRestTranslator;
import gov.va.med.imaging.roi.rest.types.ROIRequestType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author VHAISWWERFEJ
 *
 */
public class RoiStatusCommand
extends AbstractROICommand<ROIWorkItem, ROIRequestType>
{
	private final String roiRequestId;
	private final boolean includeExtendedInformation;
	
	/**
	 * @param methodName
	 */
	public RoiStatusCommand(String roiRequestId, String extended)
	{
		super("getRoiStatus");
		this.roiRequestId = roiRequestId;
		this.includeExtendedInformation = ("true".equalsIgnoreCase(extended));
	}

	public String getRoiRequestId()
	{
		return roiRequestId;
	}

	public boolean isIncludeExtendedInformation()
	{
		return includeExtendedInformation;
	}

	@Override
	protected ROIWorkItem executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		return getRouter().getRoiRequest(getRoiRequestId(), isIncludeExtendedInformation());
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for ROI request '" + getRoiRequestId() + "'.";
	}

	@Override
	protected ROIRequestType translateRouterResult(ROIWorkItem routerResult)
	throws TranslationException, MethodException
	{
		return ROIRestTranslator.translate(routerResult);
	}

	@Override
	protected Class<ROIRequestType> getResultClass()
	{
		return ROIRequestType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getRoiRequestId());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, transactionContextNaValue);

		return transactionContextFields;
	}

	@Override
	public Integer getEntriesReturned(ROIRequestType translatedResult)
	{
		return translatedResult == null ? 0 : 1;
	}

}
