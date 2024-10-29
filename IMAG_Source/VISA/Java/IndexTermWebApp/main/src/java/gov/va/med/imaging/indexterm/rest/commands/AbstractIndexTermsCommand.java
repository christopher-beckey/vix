/**
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.rest.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.imaging.indexterm.router.IndexTermContext;
import gov.va.med.imaging.indexterm.router.IndexTermRouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author Julian Werfel
 *
 */
public abstract class AbstractIndexTermsCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{

	/**
	 * @param methodName
	 */
	public AbstractIndexTermsCommand(String methodName)
	{
		super(methodName);
	}

	@Override
	protected IndexTermRouter getRouter()
	{
		return IndexTermContext.getRouter();
	}

	@Override
	protected String getWepAppName()
	{
		return "Index Term Web App";
	}


	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getRequestTypeAdditionalDetails()
	 */
	@Override
	protected String getRequestTypeAdditionalDetails()
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

		return transactionContextFields;
	}
	
}
