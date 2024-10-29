package gov.va.med.imaging;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

/**
 * 
 * @author VHAISWBECKEC
 *
 * @param <E>
 */
public class ReadWriteLockListWrapper<E> 
implements ReadWriteLockList<E>
{
	private List<E> wrappedList = null;
	private ReadWriteLock readWriteLock = new ReentrantReadWriteLock();
	
	ReadWriteLockListWrapper(List<E> wrappedList)
	{
		this.wrappedList = wrappedList;
		this.readWriteLock = new ReentrantReadWriteLock();
	}
	
	/**
	 * A private constructor used for sub lists, where the underlying list
	 * is a subset of our underlying list and we use the same readWriteLock
	 * to assure synchronization.
	 * 
	 * @param wrappedList
	 * @param readWriteLock
	 */
	private ReadWriteLockListWrapper(List<E> wrappedList, ReadWriteLock readWriteLock)
	{
		this.wrappedList = wrappedList;
		this.readWriteLock = readWriteLock;
	}

	/**
	 * @return the readWriteLock
	 */
	private ReadWriteLock getReadWriteLock()
	{
		return this.readWriteLock;
	}

	public boolean add(E element)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			return wrappedList.add(element);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public void add(int index, E element)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			wrappedList.add(index, element);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	// unchecked warnings suppressed to allow addAll to implement
	// List interface
	@SuppressWarnings("unchecked")
	public boolean addAll(Collection<? extends E> c)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			return wrappedList.addAll(c);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public boolean addAll(int index, Collection<? extends E> c)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			return wrappedList.addAll(index, c);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public void clear()
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			wrappedList.clear();
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public void clearAndAddAll(List<E> list)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			wrappedList.clear();
			wrappedList.addAll(list);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}
	
	public boolean contains(Object o)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.readLock();

		try
		{
			localLock.lock();
			return wrappedList.contains(o);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public boolean containsAll(Collection<?> c)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.readLock();

		try
		{
			localLock.lock();
			return wrappedList.containsAll(c);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public E get(int index)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			return wrappedList.get(index);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public int indexOf(Object o)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.readLock();

		try
		{
			localLock.lock();
			return wrappedList.indexOf(o);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public int lastIndexOf(Object o)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.readLock();

		try
		{
			localLock.lock();
			return wrappedList.lastIndexOf(o);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public boolean isEmpty()
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.readLock();

		try
		{
			localLock.lock();
			return wrappedList.isEmpty();
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public boolean remove(Object o)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			return wrappedList.remove(o);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public E remove(int index)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			return wrappedList.remove(index);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public boolean removeAll(Collection<?> c)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			return wrappedList.removeAll(c);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public boolean retainAll(Collection<?> c)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			return wrappedList.retainAll(c);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public E set(int index, E element)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			return wrappedList.set(index, element);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public int size()
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.readLock();

		try
		{
			localLock.lock();
			return wrappedList.size();
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	/**
	 * The returned sublist uses the same readWriteLock as this instance.
	 */
	public List<E> subList(int fromIndex, int toIndex)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.readLock();
				
		try
		{
			localLock.lock();
			return new ReadWriteLockListWrapper<E>( wrappedList.subList(fromIndex, toIndex), this.readWriteLock );
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	public Object[] toArray()
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			return wrappedList.toArray();
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}

	@SuppressWarnings("unchecked")
	public Object[] toArray(Object[] a)
	{
		// Fortify change: see note in set(E o) method
		Lock localLock = readWriteLock.writeLock();

		try
		{
			localLock.lock();
			return wrappedList.toArray(a);
		}
		catch(RuntimeException rX)
		{
			throw rX;
		}
		finally
		{
			if(localLock != null) 
			{
				localLock.unlock();
			}
		}
	}
	
	public Iterator<E> iterator()
	{
		return new ListReadWriteLockIterator(this);
	}

	public ListIterator<E> listIterator()
	{
		return new ListReadWriteLockIterator(this);
	}

	public ListIterator<E> listIterator(int index)
	{
		return new ListReadWriteLockIterator(this, index);
	}
	
	/**
	 * The iterator class wraps the iterator returned by the wrapped class
	 * using the lists readWriteLock for synchronization.
	 * 
	 * @author VHAISWBECKEC
	 *
	 */
	class ListReadWriteLockIterator
	implements ListIterator<E>
	{
		private ReadWriteLockListWrapper<E> list = null;
		private ListIterator<E> wrappedIterator = null;
		
		ListReadWriteLockIterator(ReadWriteLockListWrapper<E> list)
		{
			this(list, 0);
		}

		ListReadWriteLockIterator(ReadWriteLockListWrapper<E> list, int initialIndex)
		{
			this.list = list;
			this.wrappedIterator = this.list.listIterator(initialIndex);
		}
		
		public void add(E o)
		{
			// Fortify change: see note in set(E o) method
			Lock localLock = list.readWriteLock.writeLock();

			try
			{
				localLock.lock();
				wrappedIterator.add(o);
			}
			catch(RuntimeException rX)
			{
				throw rX;
			}
			finally
			{
				if(localLock != null) 
				{
					localLock.unlock();
				}
			}
		}

		public boolean hasNext()
		{
			// Fortify change: see note in set(E o) method
			Lock localLock = list.readWriteLock.readLock();

			try
			{
				localLock.lock();
				return wrappedIterator.hasNext();
			}
			catch(RuntimeException rX)
			{
				throw rX;
			}
			finally
			{
				if(localLock != null) 
				{
					localLock.unlock();
				}
			}
		}

		public boolean hasPrevious()
		{
			// Fortify change: see note in set(E o) method
			Lock localLock = list.readWriteLock.readLock();

			try
			{
				localLock.lock();
				return wrappedIterator.hasPrevious();
			}
			catch(RuntimeException rX)
			{
				throw rX;
			}
			finally
			{
				if(localLock != null) 
				{
					localLock.unlock();
				}
			}
		}

		public E next()
		{
			// Fortify change: see note in set(E o) method
			Lock localLock = list.readWriteLock.readLock();

			try
			{
				localLock.lock();
				return wrappedIterator.next();
			}
			catch(RuntimeException rX)
			{
				throw rX;
			}
			finally
			{
				if(localLock != null) 
				{
					localLock.unlock();
				}
			}
		}

		public int nextIndex()
		{
			// Fortify change: see note in set(E o) method
			Lock localLock = list.readWriteLock.readLock();

			try
			{
				localLock.lock();
				return wrappedIterator.nextIndex();
			}
			catch(RuntimeException rX)
			{
				throw rX;
			}
			finally
			{
				if(localLock != null) 
				{
					localLock.unlock();
				}
			}
		}

		public E previous()
		{
			// Fortify change: see note in set(E o) method
			Lock localLock = list.readWriteLock.readLock();

			try
			{
				localLock.lock();
				return wrappedIterator.previous();
			}
			catch(RuntimeException rX)
			{
				throw rX;
			}
			finally
			{
				if(localLock != null) 
				{
					localLock.unlock();
				}
			}
		}

		public int previousIndex()
		{
			// Fortify change: see note in set(E o) method
			Lock localLock = list.readWriteLock.readLock();

			try
			{
				localLock.lock();
				return wrappedIterator.previousIndex();
			}
			catch(RuntimeException rX)
			{
				throw rX;
			}
			finally
			{
				if(localLock != null) 
				{
					localLock.unlock();
				}
			}
		}

		public void remove()
		{
			// Fortify change: see notes in set(E o) method
			Lock localLock = list.readWriteLock.writeLock();
			
			try
			{
				localLock.lock();
				wrappedIterator.remove();
			}
			catch(RuntimeException rX)
			{
				throw rX;
			}
			finally
			{
				if(localLock != null) 
				{
					localLock.unlock();
				}
			}
		}

		public void set(E o)
		{
			// Fortify change: created and stored a Lock object in local variable b/c Fortify
			// can't tell if the two calls to get the lock at different times result in the same object.
			Lock localLock = list.readWriteLock.readLock();;
			
			try
			{
				localLock.lock();
				wrappedIterator.set(o);
			}
			catch(RuntimeException rX)
			{
				throw rX;
			}
			finally
			{
				// Fortify change: shouldn't happen but check anyway
				if(localLock != null) 
				{
					localLock.unlock();
				}
			}
		}
		
	}
}
