package gov.va.med.imaging.muse.webservices.rest.type.image.request;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlRootElement(name="GetTestReportIn", namespace="http://schemas.datacontract.org/2004/07/MUSEAPIRESTInterfaces.Test")
public class MuseTestReportInputType 
implements Serializable{

	private static final long serialVersionUID = -4955950875514718034L;


	@XmlElement(name="Token", namespace="http://schemas.datacontract.org/2004/07/MUSEAPIRESTInterfaces")
	private String token = null;
	
	@XmlElement(name="outputType")
	private String outputType = null;
	
	@XmlElement(name="reportFormatId")
	private String reportFormatId = null;
	
	@XmlElement(name="testId")
	private String testId = null;
	
	
	public MuseTestReportInputType() {
		
	}


	/**
	 * @param token the token to set
	 */
	public void setToken(String token) {
		this.token = token;
	}


	/**
	 * @param outputType the outputType to set
	 */
	public void setOutputType(String outputType) {
		this.outputType = outputType;
	}


	/**
	 * @param reportFormatId the reportFormatId to set
	 */
	public void setReportFormatId(String reportFormatId) {
		this.reportFormatId = reportFormatId;
	}


	/**
	 * @param testId the testId to set
	 */
	public void setTestId(String testId) {
		this.testId = testId;
	}
	


}
