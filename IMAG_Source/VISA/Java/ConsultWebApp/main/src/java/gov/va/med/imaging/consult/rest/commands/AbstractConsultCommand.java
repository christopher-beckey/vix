/**
 * 
 * 
 * Date Created: Feb 12, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.consult.rest.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.imaging.consult.router.ConsultContext;
import gov.va.med.imaging.consult.router.ConsultRouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author Julian Werfel
 *
 */
public abstract class AbstractConsultCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{
	/**
	 * @param methodName
	 */
	public AbstractConsultCommand(String methodName)
	{
		super(methodName);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getRouter()
	 */
	@Override
	protected ConsultRouter getRouter()
	{
		return ConsultContext.getRouter();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getWepAppName()
	 */
	@Override
	protected String getWepAppName()
	{
		return "Consult Web App";
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#setAdditionalTransactionContextFields()
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

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getRequestTypeAdditionalDetails()
	 */
	@Override
	protected String getRequestTypeAdditionalDetails()
	{
		return null;
	}
	
	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	
}
