/**
 * 
 */
package gov.va.med.imaging.ihe.request.filter;

import java.util.Iterator;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class TestFilterTerm
extends TestCase
{
	public void testSimpleTerm() 
	throws InvalidTermValueFormatException
	{
		FilterTerm t = new SimpleTerm("'a'");
		assertTrue(t.matches("a"));
		
		t = new SimpleTerm("'_'");
		assertTrue(t.matches("a"));
		assertTrue(t.matches("5"));
		assertTrue(t.matches("A"));
		assertFalse(t.matches("abcdef"));
		
		t = new SimpleTerm("'%'");
		assertTrue(t.matches("a"));
		assertTrue(t.matches("5"));
		assertTrue(t.matches("A"));
		assertTrue(t.matches("abcdef"));
	}
	
	public void testDisjunctionTerm() 
	throws InvalidTermValueFormatException
	{
		FilterTerm leftTerm = new SimpleTerm("'a'");
		FilterTerm rightTerm = new SimpleTerm("'b'");
		FilterTerm t = new DisjunctionTerm(leftTerm, rightTerm);
		assertFalse(t.matches("a"));

		leftTerm = new SimpleTerm("'a'");
		rightTerm = new SimpleTerm("'_'");
		t = new DisjunctionTerm(leftTerm, rightTerm);
		assertTrue(t.matches("a"));
		
		leftTerm = new SimpleTerm("'abc_e'");
		rightTerm = new SimpleTerm("'___d_'");
		t = new DisjunctionTerm(leftTerm, rightTerm);
		assertTrue(t.matches("abcde"));
	}
	
	public void testConjunctionTerm()
	throws InvalidTermValueFormatException
	{
		FilterTerm leftTerm = new SimpleTerm("'a'");
		FilterTerm rightTerm = new SimpleTerm("'b'");
		FilterTerm t = new ConjunctionTerm(leftTerm, rightTerm);
		assertTrue(t.matches("a"));
		assertTrue(t.matches("b"));
		assertFalse(t.matches("c"));
		assertFalse(t.matches("ab"));

		leftTerm = new SimpleTerm("'a'");
		rightTerm = new SimpleTerm("'b'");
		t = new ConjunctionTerm(leftTerm, rightTerm);
		assertTrue(t.matches("a"));
		
		leftTerm = new SimpleTerm("'abc_e'");
		rightTerm = new SimpleTerm("'___d_'");
		t = new ConjunctionTerm(leftTerm, rightTerm);
		assertTrue(t.matches("abcde"));
	}
	
	public void testComplexTerm()
	throws InvalidTermValueFormatException
	{
		// represent ("ab%" OR "xyz") and '__cd'
		// "abcd" should match
		FilterTerm t = 
			new DisjunctionTerm(
				new ConjunctionTerm(new SimpleTerm("'ab%'"), new SimpleTerm("'xyz'")),
				new SimpleTerm("'__cd'")
			);
		assertTrue(t.matches("abcd"));
		assertFalse(t.matches("xyz"));
		assertFalse(t.matches("abcdef"));
		
		// represent ("ab%" AND "__cd") OR 'xyz'
		// "abcd" and "xyz" should match
		t = 
			new ConjunctionTerm(
				new DisjunctionTerm(new SimpleTerm("'ab%'"), new SimpleTerm("'__cd'")),
				new SimpleTerm("'xyz'")
			);
		assertTrue(t.matches("abcd"));
		assertTrue(t.matches("xyz"));
		assertFalse(t.matches("abcdef"));
	}
	
	public void testIteration()
	throws InvalidTermValueFormatException
	{
		FilterTerm t = 
			new DisjunctionTerm(
				new ConjunctionTerm(new SimpleTerm("'ab%'"), new SimpleTerm("'xyz'")),
				new SimpleTerm("'__cd'")
			);

		for( Iterator<SimpleTerm> stIter = t.getSimpleTermIterator(); stIter.hasNext();)
			System.out.println(stIter.next().toString());
	}
}
