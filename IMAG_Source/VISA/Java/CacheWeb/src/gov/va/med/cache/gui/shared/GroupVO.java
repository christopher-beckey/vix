/**
 * 
 */
package gov.va.med.cache.gui.shared;

import gov.va.med.cache.gui.client.Utilities;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.SortedSet;
import java.util.TreeSet;

import com.google.gwt.user.client.rpc.IsSerializable;

/**
 * @author VHAISWBECKEC
 *
 */
public class GroupVO
extends AbstractGroupParent
implements Serializable, IsSerializable
{
	private static final long	serialVersionUID	= 1L;
	Set<InstanceVO> instances = new HashSet<InstanceVO>();
	private CACHE_POPULATION_DEPTH depth;
	private String semanticTypeName;
	private CacheGroupMetadata metadata = null;
	private CacheItemPath path = null;
	
	public GroupVO(){}

	public GroupVO(String name, CacheGroupMetadata metadata, CACHE_POPULATION_DEPTH depth, String semanticTypeName)
	{
		super(name);
		this.metadata = metadata;
		this.semanticTypeName = semanticTypeName;
		this.depth = depth;
	}

	public GroupVO(String name, CacheGroupMetadata metadata, CACHE_POPULATION_DEPTH depth, String semanticTypeName, CacheItemPath path)
	{
		super(name);
		this.metadata = metadata;
		this.semanticTypeName = semanticTypeName;
		this.depth = depth;
		this.path = path;
	}
	
	public CacheGroupMetadata getMetadata() {
		return metadata;
	}

	public void setMetadata(CacheGroupMetadata metadata) {
		this.metadata = metadata;
	}

	/**
	 * Indicates a semantic to be applied to this group, the specifics are dependent on the
	 * individual caches, the UI will use this as a CSS style name.
	 * @return
	 */
	public String getSemanticTypeName() {return semanticTypeName;}
	public void setSemanticTypeName(String semanticTypeName) {this.semanticTypeName = semanticTypeName;}
	
	public boolean addInstance(InstanceVO instance){return instances.add(instance);}
	public boolean addAllInstance(Collection<InstanceVO> instanceCollection){return instances.addAll(instanceCollection);}
	
	public boolean removeInstance(InstanceVO instance){return instances.remove(instance);}
	public boolean removeAllInstance(Collection<InstanceVO> instanceCollection){return instances.removeAll(instanceCollection);}
	
	public Iterator<InstanceVO> iteratorInstance(){return instances.iterator();}

	public int getInstanceCount(){return this.instances.size();}
	
	public List<InstanceVO> getInstances()
	{
		return Collections.unmodifiableList( new ArrayList<InstanceVO>(this.instances) );
	}
	
	public CACHE_POPULATION_DEPTH getDepth()
	{
		return depth;
	}
	public void setDepth(CACHE_POPULATION_DEPTH depth)
	{
		this.depth = depth;
	}
	@Override
	public int getChildCount(){return getInstanceCount() + getGroupCount();}
	
	@Override
	public void merge(AbstractNamedVO other) 
	throws MergeException
	{
		if(other instanceof GroupVO)
		{
			super.merge(other);
			if(this.getMetadata() == null && ((GroupVO)other).getMetadata() != null)
				this.setMetadata( ((GroupVO)other).getMetadata() );
			
			mergeCollections(this, this.instances, ((GroupVO)other).instances);
			// retain the original depth
		}
		else
			throw new MergeException("GroupVO is unable to merge with '" + other.toString() + "'.");
		
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
			logger.severe( "GroupVO.getParent() returns null." );
			return null;
		}
	}
	
	@Override
	public AbstractNamedVO childWithName(String name)
	{
		AbstractNamedVO child = this.searchChildCollection(getGroups(), name);
		return child == null ?
			this.searchChildCollection(getInstances(), name) :
			child;
	}
	
	@Override
	public SortedSet<AbstractNamedVO> getChildren()
	{
		SortedSet<AbstractNamedVO> children = new TreeSet<AbstractNamedVO>();  
		children.addAll( getGroups() );
		children.addAll( getInstances() );
		
		return children;
	}
	
	@Override
	public boolean removeChild(AbstractNamedVO child)
	{
		if(child instanceof InstanceVO)
			return removeInstance((InstanceVO)child);
		else if(child instanceof GroupVO)
			return remove((GroupVO)child);
		else
			return false;
	}
	
}
