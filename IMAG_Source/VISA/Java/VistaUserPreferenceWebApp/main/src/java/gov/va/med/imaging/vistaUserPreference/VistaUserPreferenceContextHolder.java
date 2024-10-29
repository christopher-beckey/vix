/**
 * 
 * Date Created: Jul 27, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.vistaUserPreference;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * @author Budy Tjahjo
 *
 */
public class VistaUserPreferenceContextHolder
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
	
	private static VistaUserPreferenceContext userPreferenceContext = null;
	
	public static synchronized VistaUserPreferenceContext getUserReferenceContext()
	{
		if(userPreferenceContext == null)
		{
			userPreferenceContext = (VistaUserPreferenceContext)appContext.getBean("vistaUserPreferenceContext");
		}
		return userPreferenceContext;
	}
}
