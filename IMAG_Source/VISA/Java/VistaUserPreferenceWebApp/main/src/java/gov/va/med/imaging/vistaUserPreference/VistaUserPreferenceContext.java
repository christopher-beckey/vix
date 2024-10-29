/**
 * 
 * Date Created: July 27, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.vistaUserPreference;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;


/**
 * @author Budy Tjahjo
 *
 */
public class VistaUserPreferenceContext
{
	
	private final static Logger logger = Logger.getLogger(VistaUserPreferenceContext.class);
	
	private final IAppConfiguration appConfiguration;

	public static VistaUserPreferenceRouter getRouter() 
	{
		VistaUserPreferenceRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(VistaUserPreferenceRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "Error getting UserPreferenceRouter instance.  Application deployment is probably incorrect.";			 
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
	public VistaUserPreferenceContext(IAppConfiguration appConfiguration)
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
