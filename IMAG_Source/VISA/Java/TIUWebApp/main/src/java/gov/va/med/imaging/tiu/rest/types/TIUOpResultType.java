package gov.va.med.imaging.tiu.rest.types;

import javax.ws.rs.core.Response.Status;

public class TIUOpResultType {
	private Status httpStatus;
	private String message;
	
	/**
	 * Default constructor
	 */
	public TIUOpResultType() {
		super();
	}

	/**
	 * Convenient constructor
	 * 
	 * @param Status			HTTP status of the operation
	 * @param String			message to send
	 * 
	 */
	public TIUOpResultType(Status httpStatus, String message) {
		this.httpStatus = httpStatus;
		this.message = message;
	}
	
	public Status getHttpStatus() {
		return httpStatus;
	}
	public void setHttpStatus(Status httpStatus) {
		this.httpStatus = httpStatus;
	}
	
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
}
