/**
 * Date Created: Apr 25, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.commands;


import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.viewer.ViewerImagingContext;
import gov.va.med.imaging.viewer.ViewerImagingContextHolder;
import gov.va.med.imaging.viewer.ViewerImagingRouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;

/**
 * @author vhaisltjahjb
 *
 */
public abstract class AbstractViewerImagingCommands<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{
	
	public AbstractViewerImagingCommands(String methodName)	
	{
		super(methodName);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getRouter()
	 */
	@Override
	protected ViewerImagingRouter getRouter()
	{
		return ViewerImagingContext.getRouter();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getWepAppName()
	 */
	@Override
	protected String getWepAppName()
	{
		return "Viewer Imaging Web App";
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
			String siteNumber = ViewerImagingContextHolder.getViewerImagingContext().getAppConfiguration().getLocalSiteNumber();
			return RoutingTokenHelper.createSiteAppropriateRoutingToken(siteNumber);
		}
		catch(RoutingTokenFormatException rtfX)
		{
			throw new MethodException(rtfX);
		}
	}

}
