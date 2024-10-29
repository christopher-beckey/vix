/**
 * 
 */
package gov.va.med.imaging.ihe.exceptions;

/**
 * @author vhaiswbeckec
 *
 */
public class ParameterDateFormatException
extends ParameterFormatException
{
	private static final long serialVersionUID = 1L;

	private static final String msg = "The parameter %1 is expected to be a date value but it is not.";

	private static String getMsg(String parameterName)
	{
		return msg.replaceAll("%1", parameterName);
	}
	
	public ParameterDateFormatException(String parameterName)
	{
		super(getMsg(parameterName));
	}
}
