/**
 * 
 * 
 * Date Created: Feb 12, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.URNFactory;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author Julian Werfel
 *
 */
public class GetTIUNoteIsAdvanceDirective
extends AbstractTIUCommand<Boolean, RestBooleanReturnType>
{
	private final String tiuUrnString;
	private final String interfaceVersion;
	
	/**
	 * @param methodName
	 * @param tiuNoteUrnString
	 * @param interfaceVersion
	 */
	public GetTIUNoteIsAdvanceDirective(String tiuUrnString, String interfaceVersion)
	{
		super("isNoteAdvanceDirective");
		this.tiuUrnString = tiuUrnString;
		this.interfaceVersion = interfaceVersion;
	}
	
	/**
	 * @return the tiuUrnString
	 */
	public String getTiuUrnString()
	{
		return tiuUrnString;
	}
	
	/**
	 * @return the interfaceVersion
	 */
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected Boolean executeRouterCommand()
	throws MethodException, ConnectionException
	{
		try {
			TIUItemURN noteUrn = URNFactory.create(getTiuUrnString(), TIUItemURN.class);
			return getRouter().isTiuNoteAdvanceDirective(noteUrn);
		} catch (ConnectionException e) {
			throw e;
		} catch (Exception e) {
			throw new MethodException("General error getting if tiu note is advance directive via router", e);
		}
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "note [" + getTiuUrnString() + "]";
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected RestBooleanReturnType translateRouterResult(Boolean routerResult)
	throws TranslationException, MethodException
	{
		return new RestBooleanReturnType(routerResult);
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<RestBooleanReturnType> getResultClass()
	{
		return RestBooleanReturnType.class;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(RestBooleanReturnType translatedResult)
	{
		return null;
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
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getTiuUrnString());
	
		return transactionContextFields;
	}

}
