/**
 * 
 */
package gov.va.med.imaging.ihe.exceptions;

/**
 * @author vhaiswbeckec
 *
 */
public abstract class ParameterFormatException
	extends Exception
{

	/**
	 * 
	 */
	public ParameterFormatException()
	{
	}

	/**
	 * @param message
	 */
	public ParameterFormatException(String message)
	{
		super(message);
	}

	/**
	 * @param cause
	 */
	public ParameterFormatException(Throwable cause)
	{
		super(cause);
	}

	/**
	 * @param message
	 * @param cause
	 */
	public ParameterFormatException(String message, Throwable cause)
	{
		super(message, cause);
	}

}
