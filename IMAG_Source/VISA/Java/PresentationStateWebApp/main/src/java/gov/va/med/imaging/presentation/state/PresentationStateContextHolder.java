/**
 * 
 */
package gov.va.med.imaging.presentation.state;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * @author William Peterson
 *
 */
public class PresentationStateContextHolder 
implements ApplicationContextAware {


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
	
	private static PresentationStateContext presentationStateContext = null;
	
	public static synchronized PresentationStateContext getPresentationStateContext()
	{
		if(presentationStateContext == null)
		{
			presentationStateContext = (PresentationStateContext)appContext.getBean("presentationStateContext");
		}
		return presentationStateContext;
	}
}
