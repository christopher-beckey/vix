package gov.va.med.imaging.ax.webservices.rest.types;

import gov.va.med.imaging.ax.webservices.rest.types.DocumentReference;

import javax.xml.bind.annotation.XmlRootElement;

// import java.io.Serializable;
// import java.util.ArrayList;
// import java.util.Iterator;
// import java.util.List;
// import java.util.Date;
// import java.util.SortedSet;
// import java.util.TreeSet;
// import java.util.SortedSet;
// import java.util.TreeSet;

/**
 * @author VACOTITTOC
 *
 * This OperationOutcome class is for FHIR  error responses (not for 200 errors), JSON tailored
 * Cardinality: OperationOutcome 1-* Issue 1..1 Details
 */
@XmlRootElement(name="OperationOutcome")
public class OperationOutcome // implements Serializable, /* Iterable<Series>,*/ Comparable<ImagingStudy> 
{	
//	private static final long serialVersionUID = -5185851367113539916L;
//	private static final char q = '"';
	private String id; // OperationOutcome id == the error code (??)
	private String resourceType; // FHIR "OperationOutcome", used for error handling (not for 200 errors)
	private TextType text;	// 
	private Issue[] issue;	// the issue (always 1 record)

	public OperationOutcome(String code, String message)
	{
		id = code;
		resourceType="OperationOutcome";
		text = new TextType("additional", "<div>" + message + "</div>");
		issue = new Issue[1]; // (always 1 record)
		issue[0]=new Issue("error", code, message);
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getResourceType() {
		return resourceType;
	}

	public void setResourceType(String resourceType) {
		this.resourceType = resourceType;
	}

	public TextType getText() {
		return text;
	}

	public void setText(TextType text) {
		this.text = text;
	}

	public void setIssue(Issue[] issue) {
		this.issue = issue;
	}

	public Issue[] getIssue() {
		return issue;
	}

	public void setEntry(Issue[] issue) {
		this.issue = issue;
	}

}
