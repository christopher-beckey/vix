/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Sept 14, 2016
 * Developer: Budy Tjahjo
 */
package gov.va.med.imaging.data.commands;

import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.data.ImagingDataContext;
import gov.va.med.imaging.data.ImagingDataContextHolder;
import gov.va.med.imaging.data.ImagingDataRouter;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;

/**
 * @author Budy Tjahjo
 *
 */
public abstract class AbstractImagingDataCommands<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{
	
	public AbstractImagingDataCommands(String methodName)	
	{
		super(methodName);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getRouter()
	 */
	@Override
	protected ImagingDataRouter getRouter()
	{
		return ImagingDataContext.getRouter();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getWepAppName()
	 */
	@Override
	protected String getWepAppName()
	{
		return "Imaging Data Web App";
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
			String siteNumber = ImagingDataContextHolder.getImagingDataContext().getAppConfiguration().getLocalSiteNumber();
			return RoutingTokenHelper.createSiteAppropriateRoutingToken(siteNumber);
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}

}
