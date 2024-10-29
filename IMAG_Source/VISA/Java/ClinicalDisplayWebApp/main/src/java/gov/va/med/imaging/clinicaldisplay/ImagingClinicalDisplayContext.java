/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 5, 2008
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
package gov.va.med.imaging.clinicaldisplay;

import javax.servlet.http.HttpServletResponse;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import gov.va.med.logging.Logger;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ImagingClinicalDisplayContext
implements ApplicationContextAware
{
	private static ApplicationContext appContext;
	private static Logger logger = Logger.getLogger(ImagingClinicalDisplayContext.class);
	
	private IAppConfiguration appConfiguration = null;
	
	private static ImagingClinicalDisplayContext imagingContext;

	/**
	 * 
	 * @return
	 */
	public static ClinicalDisplayRouter getRouter() 
	{
		ClinicalDisplayRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(ClinicalDisplayRouter.class);
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
	
	@Override
	public void setApplicationContext(ApplicationContext context)
			throws BeansException {
		appContext = context;
	}
	
	private static synchronized void initializeImagingContext()
	{
		if(imagingContext == null)
		{
			imagingContext = new ImagingClinicalDisplayContext();
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
