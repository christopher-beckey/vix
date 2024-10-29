/**
 * 
 */
package gov.va.med.cache.gui.shared;

import java.util.List;
import java.util.SortedSet;

/**
 * @author VHAISWBECKEC
 *
 */
public class RootVO 
extends AbstractNamedVO
{
	private static final long	serialVersionUID	= 1L;

	@Override
	public int getChildCount(){return 0;}

	@Override
	public AbstractNamedVO childWithName(String name)
	{
		return null;
	}
	@Override
	public SortedSet<AbstractNamedVO> getChildren()
	{
		return null;
	}
	
	@Override
	public boolean removeChild(AbstractNamedVO child){return false;}

	@Override
	public CacheItemPath getPath()
	{
		return null;
	}
}
