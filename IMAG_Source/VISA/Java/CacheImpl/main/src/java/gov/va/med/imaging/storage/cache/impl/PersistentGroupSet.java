/**
 * 
 */
package gov.va.med.imaging.storage.cache.impl;

import gov.va.med.imaging.storage.cache.EvictionJudge;
import gov.va.med.imaging.storage.cache.Group;
import gov.va.med.imaging.storage.cache.InstanceByteChannelFactory;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;

import java.lang.ref.SoftReference;

import java.util.HashSet;
import java.util.Set;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWBECKEC
 * 
 * An abstract class that represents a Set of Group instances in a cache implementation
 * that persistent stores cache data.  Both Group and Region implementations have
 * sets of Group instances.  This class makes the management of those instances easier.
 *
 * Known Derivations:
 * @see gov.va.med.imaging.storage.cache.impl.filesystem.FileSystemGroupSet
 */
public abstract class PersistentGroupSet
extends PersistentSet<Group>
{
	private static final long serialVersionUID = 1L;
	private  static final Logger LOGGER = Logger.getLogger(PersistentGroupSet.class);

	// ============================================================================================================================================
	// Constructors
	// ============================================================================================================================================
	protected PersistentGroupSet(
		InstanceByteChannelFactory byteChannelFactory,
		int secondsReadWaitsForWriteCompletion,
		boolean setModificationTimeOnRead)
	{
		super(byteChannelFactory, secondsReadWaitsForWriteCompletion, setModificationTimeOnRead);
	}
	
	// =============================================================================================================================
	// The eviction group as determined by the given eviction judge
	// =============================================================================================================================
	/**
	 * Return the Set of Group instances that are evictable according to the
	 * given EvictionJudge.
	 * NOTE: this is not a recursive method.  The descendant groups, that may be
	 * evictable, are not included in this list.
	 * 
	 * @param judge
	 * @return
	 */
	public Set<? extends Group> internalEvictableGroups(EvictionJudge<Group> judge)
	{
		Set<Group> evictableGroups = new HashSet<Group>();
		
		for(SoftReference<? extends Group> childGroupRef : this)
		{
			Group childGroup = childGroupRef.get();
			
			// the child group may no longer be referenced
			if(childGroup != null)
			{
				try
				{
					if( judge.isEvictable(childGroup) )
					{
                        LOGGER.info("PersistentGroupSet.internalEvictableGroups() --> Queueing group [{}] for eviction.", childGroup.getName());
						evictableGroups.add(childGroup);
					}
				} 
				catch (CacheException e)
				{
                    LOGGER.warn("PersistentGroupSet.internalEvictableGroups() --> CacheException evaluating eviction criteria for group [{}], which may have to be manually deleted.", childGroup.toString(), e);
				}
			}
		}
		
		return evictableGroups;
	}
}
