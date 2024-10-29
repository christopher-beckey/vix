/**
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.router;

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
public class IndexTermContext
{

	private final static Logger logger = Logger.getLogger(IndexTermContext.class);
	private final IAppConfiguration appConfiguration;
	
	public static IndexTermRouter getRouter() 
	{
		IndexTermRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(IndexTermRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "Error getting FederationRouter instance.  Application deployment is probably incorrect.";			 
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
	public IndexTermContext(IAppConfiguration appConfiguration)
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
