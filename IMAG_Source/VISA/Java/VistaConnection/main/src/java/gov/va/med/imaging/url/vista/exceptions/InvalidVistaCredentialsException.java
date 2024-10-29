package gov.va.med.imaging.url.vista.exceptions;

/**
 * An exception thrown by the VistaConnection when a security exception has occurred.
 * 
 * @author VHAISWBECKEC
 *
 */
public class InvalidVistaCredentialsException 
extends Exception
{
    private static final long serialVersionUID = 1L;

    /**
     * Construct a Vista specific InvalidCredentialsException with a message
     * specific to the type of login we're tying to do.
     * 
     * @param attemptingRemoteLogin
     */
    public InvalidVistaCredentialsException(boolean attemptingRemoteLogin, String duz, String accessCode)
    {
    	this( attemptingRemoteLogin ? 
    		"Unable to connect to Vista using remote credentials, DUZ is '" + duz + "'." :
    		"Unable to connect to Vista using local credentials, access code is '" + accessCode + "'." 
    	);
    }
    
	public InvalidVistaCredentialsException()
	{
		super();
	}

	public InvalidVistaCredentialsException(String message)
	{
		super(message);
	}

	public InvalidVistaCredentialsException(Throwable cause)
	{
		super(cause);
	}

	public InvalidVistaCredentialsException(String message, Throwable cause)
	{
		super(message, cause);
	}
}
