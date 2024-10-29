/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Nov 21, 2013
 * Developer: Administrator
 */
package gov.va.med.exceptions;

/**
 * @author Administrator
 *
 */
public class PatientIdentifierParseException
extends Exception
{
	private static final long serialVersionUID = 6899088386934127069L;
	
	public PatientIdentifierParseException(String message)
	{
		super(message);
	}

}
