/**
 * 
 */
package gov.va.med.cache.gui.shared;

/**
 * @author VHAISWBECKEC
 *
 */
public class MergeException 
extends Exception
{
	private static final long	serialVersionUID	= 1L;

	public MergeException()
	{
		super();
	}

	public MergeException(String message, Throwable cause)
	{
		super(message, cause);
	}

	public MergeException(String message)
	{
		super(message);
	}

	public MergeException(Throwable cause)
	{
		super(cause);
	}
}
