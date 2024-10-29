/**
 * 
 * 
 * Date Created: Jan 9, 2014
 * Developer: Administrator
 */
package gov.va.med.imaging.ingest;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

/**
 * @author Administrator
 *
 */
public class IngestContextHolder
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
	
	private static IngestContext ingestContext = null;
	
	public static synchronized IngestContext getIngestContext()
	{
		if(ingestContext == null)
		{
			ingestContext = (IngestContext)appContext.getBean("ingestContext");
		}
		return ingestContext;
	}
}
