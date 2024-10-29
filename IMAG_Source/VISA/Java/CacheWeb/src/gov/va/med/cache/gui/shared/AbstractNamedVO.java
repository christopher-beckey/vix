/**
 * 
 */
package gov.va.med.cache.gui.shared;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.SortedSet;
import java.util.logging.Logger;

import com.google.gwt.user.client.rpc.IsSerializable;

/**
 * @author VHAISWBECKEC
 *
 */
public abstract class AbstractNamedVO 
implements Serializable, IsSerializable, Mergable<AbstractNamedVO>, Comparable<AbstractNamedVO>
{
	private static final long	serialVersionUID	= 1L;
	
	protected transient Logger logger = Logger.getLogger("AbstractNamedVO");
	private String name;			// the name is both the displayed name and the primary key
	private transient boolean childrenPopulated = false;
	private transient AbstractNamedVO parent;				// transient because the parent is not
															// set until it joins the client-side cached hierarchy

	public AbstractNamedVO(){ this.name = null;}
	public AbstractNamedVO(String name)
	{
		this.name = name;
	}

	public String getName()
	{
		return name;
	}

	public AbstractNamedVO getParent()
	{
		return parent;
	}
	
	public void setParent(AbstractNamedVO parent)
	{
		this.parent = parent;
	}
	
	public boolean isChildrenPopulated()
	{
		return childrenPopulated;
	}
	public void setChildrenPopulated(boolean childrenPopulated)
	{
		this.childrenPopulated = childrenPopulated;
	}
	
	public abstract CacheItemPath getPath();

	/**
	 * Return a count of the total number of children regardless of type.
	 * i.e. GroupVO includes its child groups and instances.
	 * @return
	 */
	public abstract int getChildCount();
	
	/**
	 * 
	 * @param name
	 * @return
	 */
	public abstract AbstractNamedVO childWithName(String name);

	/**
	 * 
	 * @param childName
	 * @return
	 */
	public AbstractNamedVO removeChild(String childName)
	{
		AbstractNamedVO child = childWithName(childName);
		
		return removeChild(child) ? child : null;
	}
	
	protected abstract boolean removeChild(AbstractNamedVO child);
	
	/**
	 * 
	 * @param <T>
	 * @param children
	 * @param name
	 * @return
	 */
	protected <T extends AbstractNamedVO> T searchChildCollection(Collection<T> children, String name)
	{
		for( T child : children )
			if( child.getName().equals(name) )
				return child;
		
		return null;
	}
	
	/**
	 * 
	 * @param other
	 * @throws MergeException
	 */
	@Override
	public void merge(AbstractNamedVO other) 
	throws MergeException
	{
		// NOTE, the name field is NOT merged because they must be equal to do a merge
		if(! this.equals(other))
			throw new MergeException(
				"Attempt to merge unequal objects '" 
				+ this.getName() 
				+ "' and '" 
				+ other.getName() 
				+ "'.");
		
		if(isChildrenPopulated() || other.isChildrenPopulated())
			setChildrenPopulated(true);
	}

	// ==========================================================================================
	// 
	// ==========================================================================================
	/**
	 * 
	 * @param <T>
	 * @param thisCollection
	 * @param otherCollection
	 * @throws MergeException 
	 */
	protected <C extends AbstractNamedVO, T extends AbstractNamedVO> void mergeCollections(
		C				parent,
		Collection<T>	thisCollection, 
		Collection<T>	otherCollection) 
	throws MergeException
	{
		for(Iterator<T> otherIter = otherCollection.iterator(); otherIter.hasNext(); )
		{
			T otherElement = otherIter.next();
			if( thisCollection.contains(otherElement) )
			{
				for(T thisElement : thisCollection)
					if(otherElement.equals(thisElement))
					{
						otherElement.setParent(parent);
						thisElement.setParent(parent);		// this is a kludge !!!!
						thisElement.merge(otherElement);
						logger.info("Merged '" + otherElement.getName() + "' into '" + thisElement.getName() + "', child of '" + parent.getName() + "'.");
						break;
					}
			}
			else
			{
				logger.info("Adding '" + otherElement.getName() + "' as child of '" + parent.getName() + "'.");
				otherElement.setParent(parent);
				thisCollection.add(otherElement);
			}
		}
	}
	
	/**
	 * Get ALL of the children as one List.
	 * @return
	 */
	public abstract <E extends AbstractNamedVO> SortedSet<E> getChildren();

	/**
	 * 
	 * @return
	 */
	public List<AbstractNamedVO> getChildrenAsList()
	{
		List<AbstractNamedVO> list = new ArrayList<AbstractNamedVO>();
		
		for(Iterator<AbstractNamedVO> itr = getChildren().iterator(); itr.hasNext(); )
			list.add(itr.next());
		
		return list;
	}
	
	/**
	 * 
	 * @param path
	 * @param currentDepth
	 */
	protected AbstractNamedVO removeItem(CacheItemPath path, CACHE_POPULATION_DEPTH currentDepth)
	{
		String 					name = path.getNameAt(currentDepth),
				strPath = path.toString(),
				strCurrentDepth = currentDepth.toString();
		
		/*
			Gary Pham (oitlonphamg)
			P314
			Validate string for nonprintable characters based on Fortify software recommendation.
	   */
		if (strPath.matches("[A-Za-z0-9 _.,!\"'/$;:%]+") &&
			strCurrentDepth.matches("[A-Za-z0-9 _.,!\"'/$;:%]+") )
		{
			CACHE_POPULATION_DEPTH 	childDepth = path.nextDepth(currentDepth); 
			String 					childName = childDepth == null ? null : path.getNameAt(childDepth);
			boolean					childIsEndOfPath = childDepth == null ? false : path.nextDepth(childDepth) == null;
	
			logger.info("removeItem(" + strPath + "," + strCurrentDepth + ")");
			
			// the name of the item at the current depth must not be null
			if(name != null)
			{
				// if the child name is null, we somehow went too far down the chain,
				// this is an error
				if(childName == null)
				{
					logger.severe("Unable to removeItem(" + strPath + ", " + strCurrentDepth + "), name at child depth is null.");
				}
				else
					if(childIsEndOfPath)
					{
						AbstractNamedVO orphanedChild = this.removeChild(childName);
						orphanedChild.setParent(null);
						logger.info("'" + orphanedChild.getName() + "' has been deleted.");
						return orphanedChild;
					}
				else
				{
					return childWithName(childName).removeItem(path, childDepth);
				}
			}
			else
				logger.severe("Unable to removeItem(" + strPath + ", " + strCurrentDepth + "), name at current depth is null.");
		}
		
		return null;
	}

	// ===========================================================================================
	// Generated .equals and .hashCode applies to all derived classes, if the names are the same
	// then the instances are the same.
	// ===========================================================================================
	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj)
	{
		if (this == obj) return true;
		if (obj == null) return false;
		if (getClass() != obj.getClass()) return false;
		AbstractNamedVO other = (AbstractNamedVO) obj;
		if (name == null)
		{
			if (other.name != null) return false;
		}
		else if (!name.equals(other.name)) return false;

		// the parents must be equals also, all the way back to the root
		if(this.getParent() == null)		// if there is no parent, then we're at our root
			return true;
		
		return this.getParent().equals(other.getParent());
	}
	
	@Override
	public int compareTo(AbstractNamedVO that) 
	{
		if(that == null)
			return -1;
		
		return this.getName().compareTo(that.getName());
	}
	
	
}
