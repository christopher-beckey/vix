/**
 * 
 */
package gov.va.med.imaging.storage.cache.impl;

import gov.va.med.imaging.storage.cache.EvictionJudge;
import gov.va.med.imaging.storage.cache.InstanceByteChannelFactory;
import gov.va.med.imaging.storage.cache.MutableNamedObject;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;

import java.lang.ref.Reference;
import java.lang.ref.ReferenceQueue;
import java.lang.ref.SoftReference;
import java.util.ArrayList;
import java.util.Collection;
import java.util.ConcurrentModificationException;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.ReentrantReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock.ReadLock;
import java.util.concurrent.locks.ReentrantReadWriteLock.WriteLock;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWBECKEC
 * 
 * An abstract class that represents a set of persistent instances in a cache implementation.
 * This class is responsible for synchronizing the persistent and the internal (transient) 
 * set references.
 * In practical terms, this class and its subclasses, keep the file instances synchronized
 * with the internal references.
 * 
 * NOTE: methods that may make changes to the Set are declared as final so that the locking
 * can be relied on.
 *
 * Known Derivations:
 * @see gov.va.med.imaging.storage.cache.impl.PersistentGroupSet
 * @see gov.va.med.imaging.storage.cache.impl.PersistentInstanceSet
 * @see NullMutableNamedObjectSet
 */
public abstract class PersistentSet<T extends MutableNamedObject>
extends HashSet<SoftReference<? extends T>>
{
	private static final long serialVersionUID = 1L;
	private  final static Logger LOGGER = Logger.getLogger(PersistentSet.class);
	
	private ReentrantReadWriteLock accessLock = new ReentrantReadWriteLock(); // a read write lock protecing against simultaneous access where changes may occur

	private InstanceByteChannelFactory byteChannelFactory; // passed to the Group instances created within here so they can create Instances, which need the factory
	private int secondsReadWaitsForWriteCompletion;
	private boolean setModificationTimeOnRead;
	
	// set to true to queue soft references when they are GC'd and print a log message
	private static boolean monitorSoftReferences = false;
	private static ReferenceQueue dereferencedMembers;
	private static ReferenceQueueNotification queueNotification;
	
	static
	{
		if(monitorSoftReferences)
		{
			dereferencedMembers = new ReferenceQueue();
			queueNotification = new ReferenceQueueNotification(dereferencedMembers);
			
			(new Thread(queueNotification)).start();
		}
	}
	
	// ============================================================================================================================================
	// Constructors
	// ============================================================================================================================================
	protected PersistentSet(
		InstanceByteChannelFactory byteChannelFactory,
		int secondsReadWaitsForWriteCompletion,
		boolean setModificationTimeOnRead)
	{
		this.byteChannelFactory = byteChannelFactory;
		this.secondsReadWaitsForWriteCompletion = secondsReadWaitsForWriteCompletion;
		this.setModificationTimeOnRead = setModificationTimeOnRead;
	}
	
	// ============================================================================================================================================
	// Property Accessors
	// ============================================================================================================================================
	public InstanceByteChannelFactory getByteChannelFactory()
	{
		return this.byteChannelFactory;
	}

	public int getSecondsReadWaitsForWriteCompletion()
	{
		return this.secondsReadWaitsForWriteCompletion;
	}

	public boolean isSetModificationTimeOnRead()
	{
		return this.setModificationTimeOnRead;
	}
	
	private ReentrantReadWriteLock getAccessLock()
	{
		return this.accessLock;
	}
	
	private ReadLock getReadLock()
	{
		return getAccessLock().readLock();
	}
	
	private WriteLock getWriteLock()
	{
		return getAccessLock().writeLock();
	}

	public boolean isWriteLocked() 
	throws InterruptedException
	{
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
    	WriteLock writeLock = getWriteLock();
    	boolean lockAcquired = false;
    	
    	try
    	{
    		writeLock.tryLock(0L, TimeUnit.SECONDS);

    		lockAcquired = writeLock.tryLock(0L, TimeUnit.SECONDS);
    		
    		if(lockAcquired)
    			writeLock.unlock();
    	}
    	finally
    	{
			// Fortify change: added finally block; check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();
    	}
		
		return !lockAcquired;
	}
	
	/**
	 * This will step through the collection and remove any SoftReferences to null.
	 * Note that this does not guarantee that there will be no more SoftReferences to null,
	 * because some may fall out of reference as this method runs.
	 */
	public void pruneNullSoftReferences()
	{
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
    	WriteLock writeLock = getWriteLock();

    	try
    	{
    		writeLock.lock();
    		
			List<SoftReference<? extends T>> deadMen = new ArrayList<SoftReference<? extends T>>();
			
			// prune unused references in two steps to avoid ConcurrentModicicationException
			for( Iterator<SoftReference<? extends T>> iter=iterator(); iter.hasNext(); )
			{
				SoftReference<? extends T> ref = iter.next();
				if( ref.get() == null )
					deadMen.add(ref);
			}
			for(SoftReference<? extends T> deadRef : deadMen)
				remove(deadRef);
			
		}
		finally
		{
			// Fortify change: check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();	
		}
	}
	
	// ============================================================================================================================================
	// Abstract (type specific)
	// ============================================================================================================================================
	/**
	 * May create an implementation specific group or instance, so an abstract method
	 * 
	 * @param name
	 * @param create
	 * @return
	 * @throws CacheException
	 */
	protected abstract T getOrCreate(String name, boolean create) 
	throws CacheException;
	
	/**
	 * Method in the derived class that actually does the persistent to
	 * transient synchronization. 
	 * 
	 * @throws CacheException
	 */
	protected abstract void internalSynchronizeChildren()
	throws CacheException;
	
	/**
	 * Assure that the internal representation of child instances matches
	 * what is in the persistent storage (file system). 
	 * 
	 * @throws CacheException
	 */
	private final void synchronizeChildren()
	throws CacheException
	{
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
    	WriteLock writeLock = getWriteLock();

    	try
    	{
    		writeLock.lock();
			internalSynchronizeChildren();
		}
		finally
		{
			// Fortify change: check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();	
		}
		
	}
	// ============================================================================================================================================
	// Overrides to provide locking as required
	// ============================================================================================================================================
	/**
     * @see java.util.HashSet#add(java.lang.Object)
     */
    @Override
    public boolean add(SoftReference<? extends T> e)
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
    	WriteLock writeLock = getWriteLock();

    	try
    	{
    		writeLock.lock();
    		return super.add(e);
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();		
    	}
    }

	/**
     * @see java.util.HashSet#clear()
     */
    @Override
    public void clear()
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
    	WriteLock writeLock = getWriteLock();

    	try
    	{
    		writeLock.lock();
    		super.clear();
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();	
    	}
    }

	/**
     * @see java.util.HashSet#remove(java.lang.Object)
     */
    @Override
    public boolean remove(Object o)
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
    	WriteLock writeLock = getWriteLock();

    	try
    	{
    		writeLock.lock();
    	    return super.remove(o);
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();		
    	}
    }

    /**
     * Remove the object that has the given that has the name given from the Set .
     * 
     * @param name
     * @return
     */
    public boolean removeByName(String name)
    {
    	if(name == null)
    		return false;
    	
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
    	WriteLock writeLock = getWriteLock();

    	try
    	{
    		writeLock.lock();
    		
    		for(SoftReference<? extends T> member : this)
    		{
    			T referent = member.get();
    			if( referent != null && name.equals(referent.getName()) )
    			{
    				this.remove(member);
    				return true;
    			}
    		}
    		return false;
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();	
    	}
    }
    
	/**
     * @see java.util.AbstractSet#removeAll(java.util.Collection)
     */
    @Override
    public boolean removeAll(Collection<?> c)
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
    	WriteLock writeLock = getWriteLock();

    	try
    	{
    		writeLock.lock();
    	    return super.removeAll(c);
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();	
    	}
    }

	/**
     * @see java.util.AbstractCollection#addAll(java.util.Collection)
     */
    @Override
    public boolean addAll(Collection<? extends SoftReference<? extends T>> c)
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
    	WriteLock writeLock = getWriteLock();

    	try
    	{
    		writeLock.lock();
    	    return super.addAll(c);
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();	
    	}
    }

	/**
     * @see java.util.AbstractCollection#containsAll(java.util.Collection)
     */
    @Override
    public boolean containsAll(Collection<?> c)
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
		ReadLock readLock = getReadLock();

    	try
    	{
    		readLock.lock();
    	    return super.containsAll(c);
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(readLock != null)
				readLock.unlock();	
    	}
    }

	/**
     * @see java.util.AbstractCollection#retainAll(java.util.Collection)
     */
    @Override
    public boolean retainAll(Collection<?> c)
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
    	WriteLock writeLock = getWriteLock();

    	try
    	{
    		writeLock.lock();
    	    return super.retainAll(c);
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();
    	}
    }
    
	/**
     * @see java.util.HashSet#clone()
     */
    @Override
    public Object clone()
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
		ReadLock readLock = getReadLock();

    	try
    	{
    		readLock.lock();
    		return super.clone();
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(readLock != null)
				readLock.unlock();
    	}
    }

	/**
     * @see java.util.HashSet#contains(java.lang.Object)
     */
    @Override
    public boolean contains(Object o)
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
		ReadLock readLock = getReadLock();

    	try
    	{
    		readLock.lock();
    		return super.contains(o);
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(readLock != null)
				readLock.unlock();
    	}
    }

	/**
     * @see java.util.HashSet#isEmpty()
     */
    @Override
    public boolean isEmpty()
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
		ReadLock readLock = getReadLock();

    	try
    	{
    		readLock.lock();
    		return super.isEmpty();
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(readLock != null)
				readLock.unlock();
    	}
    }

	/**
     * @see java.util.HashSet#size()
     */
    @Override
    public int size()
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
		ReadLock readLock = getReadLock();

    	try
    	{
    		readLock.lock();
    		return super.size();
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(readLock != null)
				readLock.unlock();
    	}
    }

	/**
     * @see java.util.AbstractCollection#toArray()
     */
    @Override
    public Object[] toArray()
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
		ReadLock readLock = getReadLock();

    	try
    	{
    		readLock.lock();
    		return super.toArray();
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(readLock != null)
				readLock.unlock();
    	}
    }

	/**
     * @see java.util.AbstractCollection#toArray(T[])
     */
    @Override
    public <S> S[] toArray(S[] a)
    {
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
		ReadLock readLock = getReadLock();

    	try
    	{
    		readLock.lock();
    		return super.toArray(a);
    	}
    	finally
    	{
			// Fortify change: check for null first and use local variable
			if(readLock != null)
				readLock.unlock();
    	}
    }

    /**
     * Override the iterator and throw UnsuppportedOperationException when
     * calling remove() so that ConcurrentModificationException cannot occur,
     * at least when single threaded.
     */
	@Override
	public Iterator<SoftReference<? extends T>> iterator()
	{
		return new Iterator<SoftReference<? extends T>>()
		{
			private Iterator<SoftReference<? extends T>> wrappedIter = PersistentSet.super.iterator();
			private SoftReference<? extends T> current = null;
			private SoftReference<? extends T> previous = null;

			@Override
			public boolean hasNext()
			{
				return wrappedIter.hasNext();
			}

			@Override
			public SoftReference<? extends T> next()
			{
				previous = current;
				current = wrappedIter.next();
				return current;
			}

			@Override
			public void remove()
			{
				if(current != null)
				{
					// Fortify change: get lock into local variable to use. The same call may not return the same object.
					WriteLock writeLock = PersistentSet.this.getWriteLock();

					try
					{
						writeLock.lock();
						PersistentSet.this.remove(current);
						resetToPrevious();
					}
					finally
					{
						// Fortify change: check for null first and use local variable
						if(writeLock != null)
							writeLock.unlock();
					}
				}
				//throw new UnsupportedOperationException("PersistentSet.Iterator does not support remove() operation.");
			}

			// Create a new wrapped iterator and iterate on it until we get back to
			// the previous
			private void resetToPrevious() 
			{
				wrappedIter = PersistentSet.super.iterator();
				if(previous != null)
					while(wrappedIter.hasNext() && wrappedIter.next() != previous );
				current = null;
			}
		};
	}

	// ============================================================================================================================================
	// Business Methods (child groups instance management)
	// ============================================================================================================================================
	/**
	 * Get, and possibly create, a child Instance.  Synchronize the transient and persistent
	 * Instances.
	 * 
	 * @param instanceName
	 * @param create
	 * @return
	 * @throws CacheException
	 */
	public final T getChild(String name, boolean create) 
	throws CacheException
	{
		if(name == null)
			return null;

		// lock for write always, we cannot upgrade a read-lock and we must
		// have a write lock to add to the set
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
		WriteLock writeLock = getWriteLock();

		try
		{
			writeLock.lock();
			
			T child = getTransient(name);
			if(child != null)
				return child;
			
			child = getOrCreate(name, create);
			if(child != null)
				add( 
					monitorSoftReferences ? 
					new SoftReference<T>(child, dereferencedMembers) :
					new SoftReference<T>(child)
				);
			return child;
		}
		finally
		{
			// Fortify change: check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();
		}
	}
	
	/**
	 * Get the child instance from transient (memory), if it is loaded.
	 * DO NOT LOAD FROM PERSISTENT STORAGE.
	 * 
	 * @param instanceName
	 * @return
	 */
	protected T getTransient(String name)
	{
		SoftReference<? extends T> childRef = getTransientReference(name);
		return childRef == null ? null : childRef.get();
	}

	/**
	 * Get a reference to a transient instance if it is loaded.
	 * Not that this just gets the SoftReference, the existence of the referent Instance is
	 * not guaranteed, though it is very likely to be there.
	 * 
	 * @param instanceName
	 * @return
	 */
	protected final SoftReference<? extends T> getTransientReference(String name)
	{
		// Synchronize access so that other threads cannot modify it while we are searching.
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
		ReadLock readLock = getReadLock();

		try
		{
			readLock.lock();
			
			for(SoftReference<? extends T> softRef : this )
			{
				T child = softRef.get();
				if( child != null && child.getName() != null && child.getName().equals(name) )
					return softRef;
			}
		}
		finally
		{
			// Fortify change: check for null first and use local variable
			if(readLock != null)
				readLock.unlock();
		}
		return null;
	}
	
	/**
	 * @throws CacheException 
	 * 
	 */
	public final void deleteChild(T child, boolean forceDelete) 
	throws CacheException
	{
		if(child == null)
			return;
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
		WriteLock writeLock = getWriteLock();

		try
		{
			writeLock.lock();

            LOGGER.info("PersistentSet.deleteChild() --> Removing SoftReference to [{}] from PersistentSet.", child.getName());
			SoftReference<? extends T> ref = getTransientReference(child.getName());
			if( ! remove(ref) )
                LOGGER.info("PersistentSet.deleteChild() --> Failed to remove SoftReference to [{}] from PersistentSet.  This may be simply because it is no longer in the memory view of the cache but that is unusual.", child.getName());
			ref.clear();			// clear the reference so there are no more hard references to the child, except the parameter to this method
			child.delete(forceDelete);			// remove the corresponding file
			child = null;			// wholly unnecessary, just here to reinforce the idea that no references to child should exist.
		}
		finally
		{
			// Fortify change: check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();
		}
	}
	
	public final void deleteAll(boolean forceDelete) 
	throws CacheException
	{
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
		WriteLock writeLock = getWriteLock();
		
		synchronizeChildren();
		
		try
		{
			writeLock.lock();
			for(SoftReference<? extends T> child : this)
			{
				T childRef = child.get();
				// if the reference still exists, remove it
				if(childRef != null)
					childRef.delete(forceDelete);
			}
			clear();
		}
		finally
		{
			// Fortify change: check for null first and use local variable
			if(writeLock != null)
				writeLock.unlock();
		}
	}
	
	public final long getSize() 
	throws CacheException
	{
		synchronizeChildren();
		return size();
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
	public final Set<T> evictableChildren(EvictionJudge<T> judge)
	{
		Set<T> evictableChildren = null;
		
		// Fortify change: get lock into local variable to use. The same call may not return the same object.
		ReadLock readLock = getReadLock();
		
		// wait a very short time for a read lock
		// if we can't get it return an empty set of evictable
		// groups
		try
		{
			if( readLock.tryLock(1, TimeUnit.SECONDS) )
			{
				try
				{
					evictableChildren = internalEvictableGroups(judge);
				}
				catch(ConcurrentModificationException cmX)
				{
					LOGGER.warn("PersistentSet.evictableChildren() --> Concurrent modification of child groups while running an eviction sweep.  Region not completely cleaned but subsequent sweeps will do so. ");
				}
				finally
				{
					// Fortify change: check for null first and use local variable
					if(readLock != null)
						readLock.unlock();
				}
			}
		} 
		catch (InterruptedException e)
		{
            LOGGER.warn("PersistentSet.evictableChildren() --> Unable to evict: {}", e.getMessage());
		}
	
		return evictableChildren;
	}

	/**
	 * @param judge
	 * @param evictableChildren
	 */
	private Set<T> internalEvictableGroups(EvictionJudge<T> judge)
	{
		Set<T> evictableChildren = new HashSet<T>();
		
		for(SoftReference<? extends T> childRef : this)
		{
			T child = childRef.get();
			
			// the child group may no longer be referenced
			if(child != null)
			{
				try
				{
					if( judge.isEvictable(child) )
					{
                        LOGGER.info("PersistentSet.internalEvictableGroups() --> Queueing group [{}] for eviction.", child.getName());
						evictableChildren.add(child);
					}
				} 
				catch (CacheException e)
				{
                    LOGGER.error("PersistentSet.internalEvictableGroups() --> CacheException evaluating eviction criteria for group [{}], which may have to be manually deleted.", child.toString(), e);
				}
			}
		}
		
		return evictableChildren;
	}
	
	
	// =============================================================================================================================
	// The group iterator and the iterator class
	// =============================================================================================================================
	
	public Iterator<T> hardReferenceIterator()
	{
		try
		{
			return new PersistentSetIterator<T>(this);
		} 
		catch (CacheException e)
		{
			LOGGER.error(e);
			return null;
		}
	}

	class PersistentSetIterator<S extends MutableNamedObject>
	implements Iterator<S>
	{
		private Iterator<SoftReference<? extends S>> wrappedIterator = null;
		
		PersistentSetIterator(PersistentSet<S> parent)
		throws CacheException
		{
			internalSynchronizeChildren();
			wrappedIterator = parent.iterator();
		}
		
		public boolean hasNext()
		{
			return wrappedIterator.hasNext();
		}

		public S next()
		{
			SoftReference<? extends S> ref = wrappedIterator.next();
			return ref.get();
		}

		public void remove()
		{
			throw new UnsupportedOperationException();
		}
	};
	
	static class ReferenceQueueNotification
	implements Runnable
	{
		private static final long serialVersionUID = 1L;
		private final ReferenceQueue queue;

		public ReferenceQueueNotification(ReferenceQueue queue)
		{
			this.queue = queue;
		}
		
		public void run()
		{
			try
			{
				for( Reference ref = queue.remove(); ref != null; ref = queue.remove() )
					System.out.println( "ReferenceQueueNotification.run() --> PersistentSet reference queue [" + ref.getClass().getName() + "] freed.");
			} 
			catch (Exception x)
			{
				// ignore it
			}
		}
	}

}
