/**
 * 
 */
package gov.va.med.imaging.presentation.state;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author William Peterson
 *
 */
public class PresentationStateContext {
	
	private final static Logger logger = Logger.getLogger(PresentationStateContext.class);
	private final IAppConfiguration appConfiguration;
	
	public static PresentationStateRouter getRouter() 
	{
		PresentationStateRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(PresentationStateRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "Error getting PresentationStateRouter instance.  Application deployment is probably incorrect.";			 
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
	public PresentationStateContext(IAppConfiguration appConfiguration)
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
