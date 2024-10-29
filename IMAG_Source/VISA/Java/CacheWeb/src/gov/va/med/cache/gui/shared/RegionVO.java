/**
 * 
 */
package gov.va.med.cache.gui.shared;

import java.io.Serializable;
import java.util.SortedSet;

import com.google.gwt.user.client.rpc.IsSerializable;

/**
 * @author VHAISWBECKEC
 *
 */
public class RegionVO
extends AbstractGroupParent
implements Serializable, IsSerializable
{
	private static final long	serialVersionUID	= 1L;
	private CacheRegionMetadata metadata = null;
	private CacheItemPath path = null;
	
	public RegionVO(){}
	
	/**
	 * 
	 * @param name - must NOT be null
	 * @param metadata - may be null
	 */
	public RegionVO(String name, CacheRegionMetadata metadata)
	{
		super(name);
		this.metadata = metadata;
	}
	
	/**
	 * 
	 * @param name - must NOT be null
	 * @param metadata - may be null
	 * @param path - may be null
	 */
	public RegionVO(String name, CacheRegionMetadata metadata, CacheItemPath path)
	{
		super(name);
		this.metadata = metadata;
		this.path = path;
	}

	public CacheRegionMetadata getMetadata() {
		return metadata;
	}

	public void setMetadata(CacheRegionMetadata metadata) {
		this.metadata = metadata;
	}

	@Override
	public void merge(AbstractNamedVO other) 
	throws MergeException
	{
		if(other instanceof RegionVO)
		{
			super.merge(other);
			if(this.getMetadata() == null && ((RegionVO)other).getMetadata() != null)
				this.setMetadata(((RegionVO)other).getMetadata());
		}
		else
		{
			String msg = "RegionVO is unable to merge '" + other.toString() + "'";
			logger.severe(msg);
			throw new MergeException(msg);
		}
	}
	
	@Override
	public CacheItemPath getPath()
	{
		if (path != null)
			return path;
		else if( getParent() != null )
		{
			CacheItemPath parentPath = getParent().getPath();
			path = parentPath.createChildPath(this.getName(), false);
			return path;
		}
		else
		{
			logger.severe( "RegionVO.getParent() returns null." );
			return null;
		}
	}
	
	@Override
	public int getChildCount(){return getGroupCount();}
	
	@Override
	public AbstractNamedVO childWithName(String name)
	{
		return this.searchChildCollection(getGroups(), name);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public SortedSet<GroupVO> getChildren()
	{
		return getGroups();
	}
	
	@Override
	public boolean removeChild(AbstractNamedVO child){return remove((GroupVO)child);}
}
