/**
 * 
 */
package gov.va.med.imaging.storage.cache.events;

/**
 * @author VHAISWBECKEC
 *
 */
public class GroupLifecycleEvent
{
	private final LifecycleEvent lifecycleEvent;
	private final String name;
	
	public GroupLifecycleEvent(LifecycleEvent lifecycleEvent, String name)
	{
		super();
		this.lifecycleEvent = lifecycleEvent;
		this.name = name;
	}

	/**
	 * @return the lifecycleEvent
	 */
	public LifecycleEvent getLifecycleEvent()
	{
		return this.lifecycleEvent;
	}

	/**
	 * @return the name
	 */
	public String getName()
	{
		return this.name;
	}

}
