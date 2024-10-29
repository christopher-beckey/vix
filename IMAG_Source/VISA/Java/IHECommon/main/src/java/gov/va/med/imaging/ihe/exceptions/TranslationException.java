/**
 * 
 */
package gov.va.med.imaging.ihe.exceptions;

/**
 * @author vhaiswbeckec
 *
 */
public class TranslationException
	extends Exception
{
	private static final long serialVersionUID = 1L;

	/**
	 * 
	 */
	public TranslationException()
	{
	}

	/**
	 * @param message
	 */
	public TranslationException(String message)
	{
		super(message);
	}

	/**
	 * @param cause
	 */
	public TranslationException(Throwable cause)
	{
		super(cause);
	}

	/**
	 * @param message
	 * @param cause
	 */
	public TranslationException(String message, Throwable cause)
	{
		super(message, cause);
	}

}
