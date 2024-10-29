package gov.va.med.imaging.consult.federation;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public class FederationConsultContext {

	private static Logger logger = Logger.getLogger(FederationConsultContext.class);
	
	public static FederationConsultRouter getFederationRouter()
	{
		FederationConsultRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(FederationConsultRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "FederationConsultContext.getFederationRouter() --> Error getting FederationConsultRouter instance: " + x.getMessage();
			logger.warn(msg);
			TransactionContextFactory.get().setErrorMessage(msg);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_CONFLICT + "");
		}
		
		return router;
	}	
}
