package gov.va.med.imaging.indexterm.federation;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public class FederationIndexTermContext {
	private static Logger logger = Logger.getLogger(FederationIndexTermContext.class);
	
	public static FederationIndexTermRouter getFederationRouter()
	{
		FederationIndexTermRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(FederationIndexTermRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "Error getting FederationIndexTermRouter instance.  Application deployment is probably incorrect.";			 
			TransactionContextFactory.get().setErrorMessage(msg + "\n" + x.getMessage());
			logger.error(msg, x);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_CONFLICT + "");
		}
		return router;
	}	

}
