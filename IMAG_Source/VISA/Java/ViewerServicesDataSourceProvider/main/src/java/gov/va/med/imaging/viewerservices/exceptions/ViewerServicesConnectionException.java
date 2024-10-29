package gov.va.med.imaging.viewerservices.exceptions;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;

public class ViewerServicesConnectionException 
extends ConnectionException {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public ViewerServicesConnectionException() {
		// TODO Auto-generated constructor stub
	}

	public ViewerServicesConnectionException(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	public ViewerServicesConnectionException(Throwable cause) {
		super(cause);
		// TODO Auto-generated constructor stub
	}

	public ViewerServicesConnectionException(String message, Throwable cause) {
		super(message, cause);
		// TODO Auto-generated constructor stub
	}

}
