/**
 * Date Created: Apr 25, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * @author vhaisltjahjb
 *
 */
public class ViewerImagingContextHolder
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
	
	private static ViewerImagingContext viewerImagingContext = null;
	
	public static synchronized ViewerImagingContext getViewerImagingContext()
	{
		if(viewerImagingContext == null)
		{
			viewerImagingContext = (ViewerImagingContext)appContext.getBean("viewerImagingContext");
		}
		return viewerImagingContext;
	}
}
