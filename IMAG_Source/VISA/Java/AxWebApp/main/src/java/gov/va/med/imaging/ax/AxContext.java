/**
 * 
 */
package gov.va.med.imaging.ax;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * @author VACOTITTOC
 *
 */
public class AxContext
implements ApplicationContextAware 
{

	private static ApplicationContext appContext;
	private static Logger logger = Logger.getLogger(AxContext.class);

	private IAppConfiguration appConfiguration = null;
	
	private static AxContext imagingContext;
	
	/* (non-Javadoc)
	 * @see org.springframework.context.ApplicationContextAware#setApplicationContext(org.springframework.context.ApplicationContext)
	 */
	@Override
	public void setApplicationContext(ApplicationContext context)
			throws BeansException {
		appContext = context;
	}
	
	public static AxWebAppRouter getAxRouter()
	{
		AxWebAppRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(AxWebAppRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "Error getting AxWebAppRouter instance.  Application deployment is probably incorrect.";			 
			TransactionContextFactory.get().setErrorMessage(msg + "\n" + x.getMessage());
			logger.error(msg, x);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_CONFLICT + "");
		}
		return router;
	}	
	
	private static void initializeImagingContext()
	{
		if(imagingContext == null)
		{
			imagingContext = new AxContext();
		}		
	}
	
	public static synchronized IAppConfiguration getAppConfiguration()
	{
		initializeImagingContext();
		if(imagingContext.appConfiguration == null)
		{
			Object appConfigObj = appContext.getBean("appConfiguration");
			imagingContext.appConfiguration = (IAppConfiguration)appConfigObj;			
		}
		return imagingContext.appConfiguration;
	}
}