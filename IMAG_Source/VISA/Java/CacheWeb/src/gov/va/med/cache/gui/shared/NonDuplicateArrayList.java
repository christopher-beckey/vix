/**
 * 
 */
package gov.va.med.cache.gui.shared;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Set;

/**
 * An ArrayList derivation that does not allow duplicates.
 * This class follows the Set contract for add, addAll, set, etc ...
 * where adding duplicates are concerned.
 * 
 * NOTE: this class throws UnsupportedOperationException when a method result would be 
 * ambiguous (Set and List specify different behavior).
 */
public class NonDuplicateArrayList<T> 
extends ArrayList<T>
implements Set<T>
{
	private static final long	serialVersionUID	= 1L;

	/**
	 * 
	 * 
	 */
	public NonDuplicateArrayList()
	{
		super();
	}

	/**
	 * Creates a new NonDuplicateArrayList and adds all of the non-duplicate
	 * members of the given Collection.
	 * 
	 * @param c
	 */
	public NonDuplicateArrayList(Collection<? extends T> c)
	{
		super();
		this.addAll(c);
	}

	/**
	 * Create a new NonDuplicateArrayList with the specified capacity.
	 * 
	 * @param initialCapacity
	 */
	public NonDuplicateArrayList(int initialCapacity)
	{
		super(initialCapacity);
	}

	/**
	 * Always throws UnsupportedOperationException because the Set contract for duplicate
	 * elements cannot be honored through the defined method signature.
	 * 
	 * @throws UnsupportedOperationException
	 */
	@Override
	public T set(int index, T element)
	{
		throw new UnsupportedOperationException("NonDuplicateArrayList does not support the 'set' method.");
	}


	/**
	 * Add an element to the NonDuplicateArrayList if the new element is neither a 
	 * duplicate of an existing element or is null when the NonDuplicateArrayList
	 * already contains a null element.
	 * 
	 * @return - true if the element was added
	 */
	@Override
	public boolean add(T e)
	{
		if( contains(e) || (e == null && contains(null)) )
			return false;
		return super.add(e);
	}

	/**
	 * Always throws UnsupportedOperationException because the Set contract for duplicate
	 * elements cannot be honored through the defined method signature.
	 * 
	 */
	@Override
	public void add(int index, T element)
	{
		throw new UnsupportedOperationException("NonDuplicateArrayList does not support the 'add(int, T)' method.");
	}

	/**
	 * Adds all elements of 'c' to the NonDuplicateArrayList if the new element is neither a 
	 * duplicate of an existing element or is null when the NonDuplicateArrayList
	 * already contains a null element.
	 * 
	 * @return - true if any elements were added
	 */
	@Override
	public boolean addAll(Collection<? extends T> c)
	{
		boolean result = false;
		for(T newElement : c)
			result |= add(newElement);
		return result;
	}

	/**
	 * Always throws UnsupportedOperationException because the Set contract for duplicate
	 * elements cannot be honored through the defined method signature.
	 * 
	 */
	@Override
	public boolean addAll(int index, Collection<? extends T> c)
	{
		throw new UnsupportedOperationException("NonDuplicateArrayList does not support the 'addAll(int, Collection<? extends T>)' method.");
	}
}
