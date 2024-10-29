package gov.va.med.imaging.muse.webservices.rest.type.image.response;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name="WebMethodReturnOfbase64Binary", namespace="http://schemas.datacontract.org/2004/07/MUSEAPIData")
public class MuseTestReportResultType 
implements Serializable{
	
	private static final long serialVersionUID = 5793797861321171770L;

	@XmlElement(name="ErrorMessage")
	private String errorMessage = null;
	
	@XmlElement(name="Exception")
	private String exception = null;
	
	@XmlElement(name="Status")
	private String status = null;
	
	@XmlElement(name="TheResult")
	private byte[] result = null;

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
	public byte[] getResult() {
		return result;
	}

	


}
