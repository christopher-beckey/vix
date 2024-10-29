/**
 * 
 * 
 * Date Created: Jan 8, 2014
 * Developer: Administrator
 */
package gov.va.med.imaging.ingest;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.ingest.IngestRouter;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author Administrator
 *
 */
public class IngestContext
{
	private final static Logger logger = Logger.getLogger(IngestContext.class);
	private final IAppConfiguration appConfiguration;
	
	public static IngestRouter getRouter() 
	{
		IngestRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(IngestRouter.class);
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
	public IngestContext(IAppConfiguration appConfiguration)
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
