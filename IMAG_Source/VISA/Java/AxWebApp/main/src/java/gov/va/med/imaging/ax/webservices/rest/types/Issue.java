/**
 * 
 */
package gov.va.med.imaging.ax.webservices.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VACOTITTOC
 *
 */
@XmlRootElement
public class Issue
{	    
	protected String severity; // fatal|error|warning|information
	protected String code; // HTTP code for us
	protected Details details;


	public Issue(String severity, String code, String message)
	{
		this.severity = severity;
		this.code = code;
		details = new Details(message);
		details.setText(message);
	}


	public String getSeverity() {
		return severity;
	}


	public void setSeverity(String severity) {
		this.severity = severity;
	}


	public String getCode() {
		return code;
	}


	public void setCode(String code) {
		this.code = code;
	}


	public Details getDetails() {
		return details;
	}


	public void setDetails(Details details) {
		this.details = details;
	}

}
