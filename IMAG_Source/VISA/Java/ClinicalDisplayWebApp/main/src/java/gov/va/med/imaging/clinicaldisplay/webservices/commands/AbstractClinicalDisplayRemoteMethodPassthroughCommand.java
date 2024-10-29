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

import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.PassthroughInputMethod;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractClinicalDisplayRemoteMethodPassthroughCommand
extends AbstractClinicalDisplayWebserviceCommand<String, String>
{
	private final String siteId;
	private final String methodName;
	
	public AbstractClinicalDisplayRemoteMethodPassthroughCommand(String siteId,
			String methodName)
	{
		super("remoteMethodPassthrough");
		this.siteId = siteId;
		this.methodName = methodName;
	}
	
	protected abstract PassthroughInputMethod getPassthroughInputMethod();

	public String getSiteId()
	{
		return siteId;
	}

	public String getMethodName()
	{
		return methodName;
	}

	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		ClinicalDisplayRouter rtr = getRouter(); 
		try
		{
			String response = rtr.postPassthroughMethod(RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteId()), 
					getPassthroughInputMethod());
			return response;
		}
		catch (RoutingTokenFormatException rtfX)
		{			
			throw new MethodException("RoutingTokenFormatException, unable to retrieve study metadata", rtfX);
		}	
	}

	@Override
	public Integer getEntriesReturned(String translatedResult)
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "calling method '" + getMethodName() + "' going to site number [" + getSiteId() + "]";
	}

	@Override
	protected Class<String> getResultClass()
	{
		return String.class;
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
	protected String translateRouterResult(String routerResult)
			throws TranslationException
	{
		return routerResult;
	}

}
