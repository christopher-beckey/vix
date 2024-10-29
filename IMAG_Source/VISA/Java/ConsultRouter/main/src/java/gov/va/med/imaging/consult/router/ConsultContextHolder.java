/**
 * 
 * 
 * Date Created: Jan 9, 2014
 * Developer: Administrator
 */
package gov.va.med.imaging.consult.router;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * @author Administrator
 *
 */
public class ConsultContextHolder
implements ApplicationContextAware
{

	private static ApplicationContext appContext;

	/* (non-Javadoc)
	 * @see org.springframework.context.ApplicationContextAware#setApplicationContext(org.springframework.context.ApplicationContext)
	 */
	@Override
	public void setApplicationContext(ApplicationContext context)
	throws BeansException
	{
		appContext = context;
	}
	
	private static ConsultContext consultContext = null;
	
	public static synchronized ConsultContext getConsultContext()
	{
		if(consultContext == null)
		{
			consultContext = (ConsultContext)appContext.getBean("consultContext");
		}
		return consultContext;
	}
}
