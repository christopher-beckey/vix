package gov.va.med.imaging.tiu.federation;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public class FederationTIUContext {
	private static Logger logger = Logger.getLogger(FederationTIUContext.class);
	
	public static FederationTIURouter getFederationRouter()
	{
		FederationTIURouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(FederationTIURouter.class);
		} 
		catch (Exception x)
		{
			String msg = "Error getting FederationTIURouter instance.  Application deployment is probably incorrect.";			 
			TransactionContextFactory.get().setErrorMessage(msg + "\n" + x.getMessage());
			logger.error(msg, x);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_CONFLICT + "");
		}
		return router;
	}	

}
