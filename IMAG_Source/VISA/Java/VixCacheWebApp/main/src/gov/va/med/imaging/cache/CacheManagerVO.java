package gov.va.med.imaging.cache;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public class CacheManagerVO
extends AbstractNamedVO
implements Serializable
{
	private static final long	serialVersionUID	= 1L;
	
	SortedSet<CacheVO> caches = new TreeSet<CacheVO>();

	public CacheManagerVO(){super("CacheManager");}

	public boolean add(CacheVO cache){return caches.add(cache);}
	public boolean addAll(Collection<CacheVO> cacheCollection){return caches.addAll(cacheCollection);}
	
	@Override
	public boolean removeChild(AbstractNamedVO child){return remove((CacheVO)child);}
	
	public boolean remove(CacheVO cache){return caches.remove(cache);}
	public boolean removeAll(Collection<CacheVO> cacheCollection){return caches.removeAll(cacheCollection);}
	
	public Iterator<CacheVO> iterator(){return caches.iterator();}

	public int getCacheCount(){return this.caches.size();}
	
	public SortedSet<CacheVO> getCaches()
	{
		return this.caches;
	}
	
	public List<CacheVO> getCachesAsList()
	{
		List<CacheVO> cacheList = new ArrayList<CacheVO>();
		
		for(Iterator<CacheVO> itr = getCaches().iterator(); itr.hasNext(); )
			cacheList.add(itr.next());
		
		return cacheList;
	}
	
	@Override
	public void merge(AbstractNamedVO other) 
	throws MergeException
	{
		if(other instanceof CacheManagerVO)
		{
			super.merge(other);
			mergeCollections(this, this.caches, ((CacheManagerVO)other).caches);
		}
		else
			throw new MergeException("CacheManagerVO is unable to merge with '" + other.toString() + "'.");
	}

	@Override
	public CacheItemPath getPath()
	{
		return null;
	}
	
	public AbstractNamedVO removeItem(CacheItemPath path)
	{
		CacheVO cacheVo = (CacheVO)childWithName(path.getCacheName());
		return cacheVo.removeItem(path, CACHE_POPULATION_DEPTH.CACHE);
	}
	
	@Override
	public int getChildCount(){return getCacheCount();}

	@Override
	public AbstractNamedVO childWithName(String name)
	{
		return this.searchChildCollection(getCaches(), name);
	}

	@SuppressWarnings("unchecked")
	@Override
	public SortedSet<CacheVO> getChildren()
	{
		return getCaches();
	}

}
