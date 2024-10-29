/**
 * 
 * Date Created: Jul 27, 2017
 * Developer: Budy Tjahjo
 */
package gov.va.med.imaging.vistaUserPreference.commands;


import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.vistaUserPreference.VistaUserPreferenceContext;
import gov.va.med.imaging.vistaUserPreference.VistaUserPreferenceContextHolder;
import gov.va.med.imaging.vistaUserPreference.VistaUserPreferenceRouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;

/**
 * @author Budy Tjahjo
 *
 */
public abstract class AbstractUserPreferenceCommands<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{
	
	public AbstractUserPreferenceCommands(String methodName)	
	{
		super(methodName);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getRouter()
	 */
	@Override
	protected VistaUserPreferenceRouter getRouter()
	{
		return VistaUserPreferenceContext.getRouter();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getWepAppName()
	 */
	@Override
	protected String getWepAppName()
	{
		return "User Reference Web App";
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
			String siteNumber = VistaUserPreferenceContextHolder.getUserReferenceContext().getAppConfiguration().getLocalSiteNumber();
			return RoutingTokenHelper.createSiteAppropriateRoutingToken(siteNumber);
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}

}
