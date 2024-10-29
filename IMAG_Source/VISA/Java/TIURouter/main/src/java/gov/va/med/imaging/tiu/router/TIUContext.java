/**
 * 
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author Julian Werfel
 *
 */
public class TIUContext
{

	private final static Logger logger = Logger.getLogger(TIUContext.class);
	private final IAppConfiguration appConfiguration;
	
	public static TIURouter getRouter() 
	{
		TIURouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(TIURouter.class);
		} 
		catch (Exception x)
		{
			String msg = "Error getting TIURouter instance.  Application deployment is probably incorrect.";			 
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
	public TIUContext(IAppConfiguration appConfiguration)
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
