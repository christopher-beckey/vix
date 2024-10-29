package gov.va.med.imaging.muse.webservices.rest.type.opensession.response;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement (name="WebMethodReturnOfAuthTokenNM5mT7rE")
public class MuseOpenSessionAuthTokenType 
implements Serializable{
	
	private static final long serialVersionUID = -8031371354369536936L;

	@XmlElement(name="ErrorMessage")
	private String errorMessage = null;
	
	@XmlElement(name="Exception")
	private String exception = null;
	
	@XmlElement(name="Status")
	private String status = null;
	
	@XmlElement(name="TheResult", type=MuseOpenSessionTheResultType.class)
	private MuseOpenSessionTheResultType result = null;

	/**
	 * @return the errorMessage
	 */
	public String getErrorMessage() {
		return errorMessage;
	}

	/**
	 * @return the exception
	 */
	public String getException() {
		return exception;
	}

	/**
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * @return the result
	 */
	public MuseOpenSessionTheResultType getResult() {
		return result;
	}
}
