/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Jan 10, 2014
 * Developer: Administrator
 */
package gov.va.med.imaging.data;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;


/**
 * @author Budy Tjahjo
 *
 */
public class ImagingDataContextHolder
implements ApplicationContextAware
{

	private static ApplicationContext appContext;

	/* (non-Javadoc)
	 * @see org.springframework.context.ApplicationContextAware#setApplicationContext(org.springframework.context.ApplicationContext)
	 */
	public void setApplicationContext(ApplicationContext context)
	throws BeansException
	{
		appContext = context;
	}
	
	private static ImagingDataContext imagingDataContext = null;
	
	public static synchronized ImagingDataContext getImagingDataContext()
	{
		if(imagingDataContext == null)
		{
			imagingDataContext = (ImagingDataContext)appContext.getBean("imagingDataContext");
		}
		return imagingDataContext;
	}
}
