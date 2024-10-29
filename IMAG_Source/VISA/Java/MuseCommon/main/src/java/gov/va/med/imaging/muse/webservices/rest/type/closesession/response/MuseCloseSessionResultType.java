package gov.va.med.imaging.muse.webservices.rest.type.closesession.response;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement(name="WebMethodReturn")
public class MuseCloseSessionResultType 
implements Serializable{
	
	private static final long serialVersionUID = 441485030758514994L;

	@XmlElement(name="ErrorMessage")
	private String errorMessage = null;
	
	@XmlElement(name="Exception", type=MuseCloseSessionResultExceptionType.class)
	private MuseCloseSessionResultExceptionType exception = null;
	
	@XmlElement(name="Status")
	private String status = null;

	/**
	 * @return the errorMessage
	 */
	public String getErrorMessage() {
		return errorMessage;
	}

	/**
	 * @return the exception
	 */
	public MuseCloseSessionResultExceptionType getException() {
		return exception;
	}

	/**
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}	
}
