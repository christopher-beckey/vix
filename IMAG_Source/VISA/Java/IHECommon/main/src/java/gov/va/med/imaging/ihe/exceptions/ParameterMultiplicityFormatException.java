/**
 * 
 */
package gov.va.med.imaging.ihe.exceptions;

/**
 * @author vhaiswbeckec
 *
 */
public class ParameterMultiplicityFormatException
extends ParameterFormatException
{
	private static final long serialVersionUID = 1L;
	private static final String msg = "The parameter %1 is expected to be a single value but multiple values were passed.";

	private static String getMsg(String parameterName)
	{
		return msg.replaceAll("%1", parameterName);
	}
	
	/**
	 * @param message
	 */
	public ParameterMultiplicityFormatException(String parameterName)
	{
		super(getMsg(parameterName));
	}

}
