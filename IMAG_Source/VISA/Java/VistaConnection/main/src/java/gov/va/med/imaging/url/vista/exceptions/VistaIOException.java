/**
 * 
 */
package gov.va.med.imaging.url.vista.exceptions;

import java.io.IOException;

/**
 * @author VHAISWBECKEC
 *
 */
public class VistaIOException 
extends IOException
{
    private static final long serialVersionUID = 1L;

	/**
	 * 
	 */
	public VistaIOException()
	{
	}

	/**
	 * @param message
	 */
	public VistaIOException(String message)
	{
		super(message);
	}

	/**
	 * @param cause
	 */
	public VistaIOException(Throwable cause)
	{
		super(cause);
	}

	/**
	 * @param message
	 * @param cause
	 */
	public VistaIOException(String message, Throwable cause)
	{
		super(message, cause);
	}
}
