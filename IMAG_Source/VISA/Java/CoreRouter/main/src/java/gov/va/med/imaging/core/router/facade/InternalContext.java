/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 4, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswlouthj
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
package gov.va.med.imaging.core.router.facade;

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
public class InternalContext
implements ApplicationContextAware
{
	private static ApplicationContext appContext;
	private static Logger logger = Logger.getLogger(InternalContext.class);

	/**
	 * 
	 * @return
	 */
	public static InternalRouter getRouter() 
	{
		InternalRouter router = null;
		TransactionContext transactionContext = TransactionContextFactory.get();
		try
		{
			router = FacadeRouterUtility.getFacadeRouter(InternalRouter.class);
		} 
		catch (Exception x)
		{
			String msg = "InternalContext.getRouter() --> Error getting InternalRouter instance: " + x.getMessage();			 
			TransactionContextFactory.get().setErrorMessage(msg);
			logger.warn(msg);
			transactionContext.setExceptionClassName(x.getClass().getSimpleName());
			//TODO - figure out what to do here: transactionContext.setResponseCode(HttpServletResponse.SC_CONFLICT + "");
		}
		return router;
	} 
	
	@Override
	public void setApplicationContext(ApplicationContext context)
			throws BeansException {
		appContext = context;
	}
}
