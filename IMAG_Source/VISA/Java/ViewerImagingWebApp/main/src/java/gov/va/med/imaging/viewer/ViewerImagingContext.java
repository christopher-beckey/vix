/**
 * Date Created: Apr 25, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 *
 */
public class ViewerImagingContext
{
	
	private final static Logger logger = Logger.getLogger(ViewerImagingContext.class);
	
	private final IAppConfiguration appConfiguration;

	public static ViewerImagingRouter getRouter() 
	{
		ViewerImagingRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(ViewerImagingRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "Error getting ViewerImagingRouter instance.  Application deployment is probably incorrect.";			 
			TransactionContextFactory.get().setErrorMessage(msg + "\n" + x.getMessage());
			logger.error(msg, x);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_CONFLICT + "");
		}
		return router;
	}
	
	/**
	 * @param appConfiguration
	 */
	public ViewerImagingContext(IAppConfiguration appConfiguration)
	{
		super();
		this.appConfiguration = appConfiguration;
	}

	/**
	 * @return the appConfiguration
	 */
	public IAppConfiguration getAppConfiguration()
	{
		return appConfiguration;
	}
}