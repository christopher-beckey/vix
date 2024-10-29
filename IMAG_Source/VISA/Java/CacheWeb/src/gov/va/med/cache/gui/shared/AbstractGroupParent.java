/**
 * 
 */
package gov.va.med.cache.gui.shared;

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
public abstract class AbstractGroupParent 
extends AbstractNamedVO
implements Serializable, IsSerializable
{
	private static final long	serialVersionUID	= 1L;
	SortedSet<GroupVO> groups = new TreeSet<GroupVO>();

	public AbstractGroupParent(){}
	
	public AbstractGroupParent(String name)
	{
		super(name);
	}
	
	public boolean add(GroupVO group){return groups.add(group);}
	public boolean addAll(Collection<GroupVO> groupCollection){return groups.addAll(groupCollection);}
	
	public boolean remove(GroupVO group){return groups.remove(group);}
	public boolean removeAll(Collection<GroupVO> groupCollection){return groups.removeAll(groupCollection);}
	
	public Iterator<GroupVO> iterator(){return groups.iterator();}

	public int getGroupCount(){return this.groups.size();}
	
	public SortedSet<GroupVO> getGroups()
	{
		return this.groups;
	}
	
	@Override
	public void merge(AbstractNamedVO other) 
	throws MergeException
	{
		if(other instanceof AbstractGroupParent)
		{
			super.merge(other);
			mergeCollections(this, this.groups, ((AbstractGroupParent)other).groups);
		}
		else
		{
			String msg = "AbstractGroupParent is unable to merge '" + other.toString() + "'";
			logger.severe(msg);
			throw new MergeException(msg);
		}
	}
}
