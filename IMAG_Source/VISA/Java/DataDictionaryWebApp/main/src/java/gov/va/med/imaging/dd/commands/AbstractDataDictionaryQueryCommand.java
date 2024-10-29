/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 23, 2011
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
package gov.va.med.imaging.dd.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.imaging.dd.DataDictionaryContext;
import gov.va.med.imaging.dd.DataDictionaryRouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author VHAISWWERFEJ
 *
 */
public abstract class AbstractDataDictionaryQueryCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{
	
	public AbstractDataDictionaryQueryCommand(String methodName)
	{
		super(methodName);
	}

	@Override
	protected DataDictionaryRouter getRouter()
	{
		return DataDictionaryContext.getRouter();
	}

	@Override
	protected String getWepAppName()
	{
		return "Data Dictionary WebApp";
	}

	@Override
	public String getInterfaceVersion()
	{
		return "V1";
	}
	
	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	@Override
	protected String getRequestTypeAdditionalDetails()
	{
		return null;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.patientId, transactionContextNaValue);

		return transactionContextFields;
	}
}
