/**
 * 
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;


/**
 * @author Julian Werfel
 *
 */
public class TIUContextHolder
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
	
	private static TIUContext tiuContext = null;
	
	public static synchronized TIUContext getTIUContext()
	{
		if(tiuContext == null)
		{
			tiuContext = (TIUContext)appContext.getBean("tiuContext");
		}
		return tiuContext;
	}
}
