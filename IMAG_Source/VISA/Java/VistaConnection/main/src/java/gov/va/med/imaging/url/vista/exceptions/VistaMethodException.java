package gov.va.med.imaging.url.vista.exceptions;

/**
 * Thrown when an error has occurred in a Vista application.
 * This is an internal exception only and may not be exposed to
 * the outside API.
 * 
 * @author VHAISWBECKEC
 *
 */
public class VistaMethodException 
extends Exception
{
    private static final String DEFAULT_ERROR_MESSAGE = "An error occured when calling a Vista method";
	private static final long serialVersionUID = -1;

	public VistaMethodException()
	{
		super(DEFAULT_ERROR_MESSAGE);
	}

	public VistaMethodException(String message)
	{
		super(message);
	}

	public VistaMethodException(Throwable cause)
	{
		super(cause);
	}

	public VistaMethodException(String message, Throwable cause)
	{
		super(message, cause);
	}
}
