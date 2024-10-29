/**
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.router;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;


/**
 * @author Julian Werfel
 *
 */
public class IndexTermContextHolder
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
	
	private static IndexTermContext indexTermContext = null;
	
	public static synchronized IndexTermContext getIndexTermContext()
	{
		if(indexTermContext == null)
		{
			indexTermContext = (IndexTermContext)appContext.getBean("indexTermContext");
		}
		return indexTermContext;
	}
}
