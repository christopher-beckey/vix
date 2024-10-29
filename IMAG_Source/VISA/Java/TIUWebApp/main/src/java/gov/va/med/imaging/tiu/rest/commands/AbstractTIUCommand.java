/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.tiu.router.TIUContext;
import gov.va.med.imaging.tiu.router.TIUContextHolder;
import gov.va.med.imaging.tiu.router.TIURouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author Julian Werfel
 *
 */
public abstract class AbstractTIUCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{

	/**
	 * @param methodName
	 */
	public AbstractTIUCommand(String methodName)
	{
		super(methodName);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getRouter()
	 */
	@Override
	protected TIURouter getRouter()
	{
		return TIUContext.getRouter();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getWepAppName()
	 */
	@Override
	protected String getWepAppName()
	{
		return "TIU Web App";
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#setAdditionalTransactionContextFields()
	 */
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
