package gov.va.med.imaging.tiu.federation.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author William Peterson
 *
 */
@XmlRootElement
public enum FederationTIUNoteRequestStatusType {

	signedAll("1"),
	unsigned("2"),
	uncosigned("3"),
	byAuthor("4"),
	signedDateRange("5");
	
	private String value;
	
	FederationTIUNoteRequestStatusType(String value)
	{
		this.value = value;
	}
	
	

	private FederationTIUNoteRequestStatusType() {
	}



	/**
	 * @return the value
	 */
	public String getValue()
	{
		return value;
	}



	public void setValue(String value) {
		this.value = value;
	}

}
