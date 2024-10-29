package gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.response;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement(name="WebMethodReturnOfArrayOfTestNM5mT7rE")
public class MuseArtifactResultsType 
implements Serializable{
	
	private static final long serialVersionUID = -3115933820854745642L;

	@XmlElement(name="ErrorMessage")
	private String errorMessage = null;
	
	@XmlElement(name="Exception")
	private String exception = null;
	
	@XmlElement(name="Status")
	private String status = null;
	
	@XmlElement(name="TheResult", type=MuseArtifactTheResultType.class)
	private MuseArtifactTheResultType results = null;

	/**
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}

	/**
	 * @return the results
	 */
	public MuseArtifactTheResultType getResults() {
		return results;
	}

	/**
	 * @return the serialversionuid
	 */
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

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


}
