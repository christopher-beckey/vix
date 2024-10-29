/**
 * 
 * 
 * Date Created: Feb 13, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.enums;

/**
 * @author Julian Werfel
 *
 */
public enum TIUNoteRequestStatus
{
	signedAll("1"),
	unsigned("2"),
	uncosigned("3"),
	byAuthor("4"),
	signedDateRange("5");
	
	final String value;
	
	TIUNoteRequestStatus(String value)
	{
		this.value = value;
	}

	/**
	 * @return the value
	 */
	public String getValue()
	{
		return value;
	}

}
