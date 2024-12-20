/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswlouthj
  Description: DICOM Study cache manager. Maintains the cache of study instances
  			   and expires old studies after 15 minutes. 

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
package gov.va.med.imaging.core.router.storage;

import gov.va.med.imaging.core.FacadeRouterUtility;
import gov.va.med.imaging.core.interfaces.IAppConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import gov.va.med.logging.Logger;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * @author vhaiswlouthj
 *
 */
public class StorageContext
implements ApplicationContextAware
{
	private static ApplicationContext appContext;
	private static Logger logger = Logger.getLogger(StorageContext.class);
	private IAppConfiguration appConfiguration;
	private static StorageContext storageContext;

	/**
	 * 
	 * @return
	 */
	public static StorageBusinessRouter getBusinessRouter() 
	{
		StorageBusinessRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(StorageBusinessRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "StorageContext.getBusinessRouter() --> Error getting StorageRouter instance: " + x.getMessage();			 
			TransactionContextFactory.get().setErrorMessage(msg);
			logger.warn(msg);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
		}
		return router;
	} 

	/**
	 * 
	 * @return
	 */
	public static StorageDataSourceRouter getDataSourceRouter() 
	{
		StorageDataSourceRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(StorageDataSourceRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "StorageContext.getDataSourceRouter() --> Error getting StorageRouter instance: " + x.getMessage();			 
			TransactionContextFactory.get().setErrorMessage(msg);
			logger.warn(msg);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
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
		if(storageContext == null)
		{
			storageContext = new StorageContext();
		}		
	}
	
	public static synchronized IAppConfiguration getAppConfiguration()
	{
		initializeImagingContext();
		if(storageContext.appConfiguration == null)
		{
			Object appConfigObj = appContext.getBean("appConfiguration");
			storageContext.appConfiguration = (IAppConfiguration)appConfigObj;			
		}
		return storageContext.appConfiguration;
	}
	
}
