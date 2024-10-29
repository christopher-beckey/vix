/**
 * 
 */
package gov.va.med.imaging.url.vista.exceptions;

/**
 * If a response from Vista includes an phrase indicating an M
 * error then the response is caught and thrown as an exception
 * of this class. 
 * 
 * @author VHAISWBECKEC
 *
 */
public class VistaMException 
extends VistaMethodException
{
    private static final long serialVersionUID = 1L;

	/**
	 * 
	 */
	public VistaMException()
	{
		super();
	}

	/**
	 * @param message
	 */
	public VistaMException(String message)
	{
		super(message);
	}

	/**
	 * @param cause
	 */
	public VistaMException(Throwable cause)
	{
		super(cause);
	}

	/**
	 * @param message
	 * @param cause
	 */
	public VistaMException(String message, Throwable cause)
	{
		super(message, cause);
	}

}
