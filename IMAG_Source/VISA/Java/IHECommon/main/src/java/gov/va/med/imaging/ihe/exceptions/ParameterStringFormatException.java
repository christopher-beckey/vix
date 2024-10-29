/**
 * 
 */
package gov.va.med.imaging.ihe.exceptions;

/**
 * @author vhaiswbeckec
 *
 */
public class ParameterStringFormatException
extends ParameterFormatException
{
	private static final long serialVersionUID = 1L;

	/**
	 * 
	 */
	public ParameterStringFormatException()
	{
	}

	/**
	 * @param message
	 */
	public ParameterStringFormatException(String message)
	{
		super(message);
	}

	/**
	 * @param cause
	 */
	public ParameterStringFormatException(Throwable cause)
	{
		super(cause);
	}

	/**
	 * @param message
	 * @param cause
	 */
	public ParameterStringFormatException(String message, Throwable cause)
	{
		super(message, cause);
	}
}
