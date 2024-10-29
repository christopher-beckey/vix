/**
 * 
 * Date Created: Mar 14, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands.facade;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author Julian Werfel
 *
 */
public class TIUCommandsContext
{

	private final static Logger logger = Logger.getLogger(TIUCommandsContext.class);
	
	
	public static TIUCommandsRouter getRouter() 
	{
		TIUCommandsRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(TIUCommandsRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "Error getting TIU commands router instance.  Application deployment is probably incorrect.";			 
			TransactionContextFactory.get().setErrorMessage(msg + "\n" + x.getMessage());
			logger.error(msg, x);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
		}
		return router;
	}
}