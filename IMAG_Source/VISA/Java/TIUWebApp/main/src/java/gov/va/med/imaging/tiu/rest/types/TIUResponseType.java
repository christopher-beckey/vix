package gov.va.med.imaging.tiu.rest.types;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * @author Quoc Nguyen
 *
 */
@XmlRootElement(name = "ingestResponse")
@XmlType(propOrder = {"status", "message"}) // assure "errorCode" appears before message
public class TIUResponseType {
	
	private String status;
	private String message;
	
	/**
	 * Default constructor
	 */
	public TIUResponseType() {
		super();
	}

	/**
	 * Convenient constructor
	 * 
	 * @param String			HTTP status of the operation
	 * @param String			message to send
	 * 
	 */
	public TIUResponseType (String status, String message) {
		super();
		this.status = status;
		this.message = message;
	}
	
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
}
