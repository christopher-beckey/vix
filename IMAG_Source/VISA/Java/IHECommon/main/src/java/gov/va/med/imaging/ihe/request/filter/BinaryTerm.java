/**
 * 
 */
package gov.va.med.imaging.ihe.request.filter;

import java.util.Iterator;
import java.util.NoSuchElementException;

public abstract class BinaryTerm
extends FilterTerm
{
	private final FilterTerm leftTerm;
	private final FilterTerm rightTerm;
	
	public BinaryTerm(String codingScheme, FilterTerm leftTerm, FilterTerm rightTerm)
	{
		super(codingScheme);
		this.leftTerm = leftTerm;
		this.rightTerm = rightTerm;
	}
	
	public BinaryTerm(FilterTerm leftTerm, FilterTerm rightTerm)
	{
		super();
		this.leftTerm = leftTerm;
		this.rightTerm = rightTerm;
	}

	public FilterTerm getLeftTerm()
	{
		return this.leftTerm;
	}

	public FilterTerm getRightTerm()
	{
		return this.rightTerm;
	}

	@Override
	public Iterator<SimpleTerm> getSimpleTermIterator()
	{
		final BinaryTerm parent = this;
		
		return new Iterator<SimpleTerm>()
		{
			private IteratorPosition position = IteratorPosition.LEFT;
			private Iterator<SimpleTerm> leftIterator = getLeftTerm().getSimpleTermIterator();
			private Iterator<SimpleTerm> rightIterator = getRightTerm().getSimpleTermIterator();
			
			@Override
			public boolean hasNext()
			{
				return position == IteratorPosition.LEFT ||
				 position == IteratorPosition.RIGHT && rightIterator.hasNext();
			}

			@Override
			public SimpleTerm next()
			{
				if(position == IteratorPosition.LEFT)
				{
					if(leftIterator.hasNext())
						return leftIterator.next();
					position = IteratorPosition.RIGHT;
					return rightIterator.next();
				}
				else if(position == IteratorPosition.RIGHT)
				{
					return rightIterator.next();
				}
				else
					throw new NoSuchElementException();
			}

			@Override
			public void remove(){}
		};
	}
	enum IteratorPosition{LEFT, RIGHT, OVERFLOW};
}