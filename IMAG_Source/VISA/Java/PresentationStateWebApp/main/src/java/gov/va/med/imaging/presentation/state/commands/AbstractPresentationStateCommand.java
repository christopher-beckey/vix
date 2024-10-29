/**
 * 
 */
package gov.va.med.imaging.presentation.state.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.presentation.state.PresentationStateContext;
import gov.va.med.imaging.presentation.state.PresentationStateContextHolder;
import gov.va.med.imaging.presentation.state.PresentationStateRouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author William Peterson
 *
 */
public abstract class AbstractPresentationStateCommand<D, E extends Object> 
extends AbstractWebserviceCommand<D, E> {

	/**
	 * @param methodName
	 */
	public AbstractPresentationStateCommand(String methodName)
	{
		super(methodName);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getRouter()
	 */
	@Override
	protected PresentationStateRouter getRouter()
	{
		return PresentationStateContext.getRouter();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getWepAppName()
	 */
	@Override
	protected String getWepAppName()
	{
		return "Presentation State Web App";
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
	
	protected RoutingToken createLocalRoutingToken()
	throws MethodException
	{
		try
		{
			return RoutingTokenHelper.createSiteAppropriateRoutingToken(PresentationStateContextHolder.getPresentationStateContext().getAppConfiguration().getLocalSiteNumber());
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
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
