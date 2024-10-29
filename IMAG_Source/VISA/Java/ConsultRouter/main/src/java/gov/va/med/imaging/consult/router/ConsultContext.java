/**
 * 
 * 
 * Date Created: Jan 8, 2014
 * Developer: Administrator
 */
package gov.va.med.imaging.consult.router;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author Administrator
 *
 */
public class ConsultContext
{
	private final static Logger logger = Logger.getLogger(ConsultContext.class);
	private final IAppConfiguration appConfiguration;
	
	public static ConsultRouter getRouter() 
	{
		ConsultRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(ConsultRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "Error getting ConsultRouter instance.  Application deployment is probably incorrect.";			 
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
	public ConsultContext(IAppConfiguration appConfiguration)
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
