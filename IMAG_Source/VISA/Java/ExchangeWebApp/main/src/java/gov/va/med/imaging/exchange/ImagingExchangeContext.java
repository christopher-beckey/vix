/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 30, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.exchange;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.core.interfaces.exceptions.ProcedureFilterTermsException;
import gov.va.med.imaging.exchange.configuration.ExchangeInterfaceProcedureFilterTerms;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.logging.Logger;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ImagingExchangeContext 
implements ApplicationContextAware 
{

	private static ApplicationContext appContext;
	private final static Logger LOGGER = Logger.getLogger(ImagingExchangeContext.class);
	
	private IAppConfiguration appConfiguration = null;
	private ExchangeInterfaceProcedureFilterTerms exchangeFilterTerms = null;
	
	private static ImagingExchangeContext imagingContext;
	
	private static ExchangeRouter router = null;
	public static ExchangeRouter getExchangeRouter()
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(ExchangeRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "ImagingExchangeContext.getExchangeRouter() --> Error getting FederationRouter instance: " + x.getMessage();			 
			TransactionContextFactory.get().setErrorMessage(msg);
			LOGGER.warn(msg);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
			transactionContext.setResponseCode(HttpServletResponse.SC_CONFLICT + "");
		}
		return router;
	}	
	
	@Override
	public void setApplicationContext(ApplicationContext context)
			throws BeansException {
		appContext = context;
	}
	
	private static synchronized void initializeImagingContext()
	{
		if(imagingContext == null)
		{
			imagingContext = new ImagingExchangeContext();
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
	
	public static synchronized ExchangeInterfaceProcedureFilterTerms getExchangeInterfaceProcedureFilterTerms()
	{
		initializeImagingContext();
		if(imagingContext.exchangeFilterTerms == null)
		{
			IAppConfiguration app = getAppConfiguration();
			imagingContext.exchangeFilterTerms = new ExchangeInterfaceProcedureFilterTerms(app);
			try {
				imagingContext.exchangeFilterTerms.init();
			}
			catch(ProcedureFilterTermsException pftX)
			{
                LOGGER.warn("ImagingExchangeContext.getExchangeInterfaceProcedureFilterTerms() --> Error: {}", pftX.getMessage());
				imagingContext.exchangeFilterTerms = null;
			}
		}
		return imagingContext.exchangeFilterTerms;
	}

}
