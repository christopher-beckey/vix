/**
 * 
 */
package gov.va.med.cache.gui.shared;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.SortedSet;
import java.util.TreeSet;

import com.google.gwt.user.client.rpc.IsSerializable;

/**
 * @author VHAISWBECKEC
 *
 */
public class CacheVO
extends AbstractNamedVO
implements Serializable, IsSerializable
{
	private static final long	serialVersionUID	= 1L;
	
	private CacheMetadata metadata = null;
	private SortedSet<RegionVO> regions = new TreeSet<RegionVO>();

	public CacheVO(){}		// required for GWT IsSerializable
	
	public CacheVO(String name, CacheMetadata metadata)
	{
		super(name);
		this.metadata = metadata;
	}

	@Override
	public CacheItemPath getPath()
	{
		return new CacheItemPath(getName());
	}

	public CacheMetadata getMetadata() {
		return metadata;
	}

	public void setMetadata(CacheMetadata metadata) {
		this.metadata = metadata;
	}

	public boolean add(RegionVO region){return regions.add(region);}
	public boolean addAll(Collection<RegionVO> regionCollection){return regions.addAll(regionCollection);}
	
	@Override
	public boolean removeChild(AbstractNamedVO child){return remove((RegionVO)child);}
	
	public boolean remove(RegionVO region){return regions.remove(region);}
	public boolean removeAll(Collection<RegionVO> regionCollection){return regions.removeAll(regionCollection);}
	
	public Iterator<RegionVO> iterator(){return regions.iterator();}
	
	public int getRegionCount(){return this.regions.size();}
	
	public SortedSet<RegionVO> getRegions()
	{
		return this.regions;
	}
	
	@Override
	public void merge(AbstractNamedVO other)
	throws MergeException
	{
		if(other instanceof CacheVO)
		{
			super.merge(other);
			
			CacheVO otherCache = (CacheVO)other;
			
			if(this.getMetadata() == null && otherCache.getMetadata() != null)
				this.setMetadata(otherCache.getMetadata());
			
			mergeCollections(this, this.regions, otherCache.regions);
		}
		else
			throw new MergeException("CacheVO is unable to merge with '" + other.toString() + "'.");
	}

	@Override
	public int getChildCount(){return getRegionCount();}
	
	@Override
	public AbstractNamedVO childWithName(String name)
	{
		return this.searchChildCollection(getRegions(), name);
	}
	
	@Override
	public SortedSet<RegionVO> getChildren()
	{
		return getRegions();
	}
}
