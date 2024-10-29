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
 * This Bundle class is for FHIR DocumentRefernce bundle response , ***? JSON tailored
 * Cardinality: Bundle 1-1 Patient 1..* DocumentReference
 */
@XmlRootElement
public class Entry // implements Serializable, /* Iterable<Series>,*/ Comparable<ImagingStudy> 
{	
//	private static final long serialVersionUID = -5185851367113539916L;
//	private static final char q = '"';
	private String id; // DocumentReference request transactionID
	private String fullUrl; // required if resource is present
	private DocumentReference resource; // DocumentReference
	private SearchModeType search; 		// always has '{"mode": "match"}'

	public Entry()
	{
		resource = new DocumentReference();
		search = new SearchModeType("match");
		fullUrl = "http://127.0.0.1/dstu2/DocumentReference/";
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public DocumentReference getResource() {
		return resource;
	}

	public void setResource(DocumentReference resource) {
		this.resource = resource;
	}

	public String getFullUrl() {
		return fullUrl;
	}

	public void setFullUrl(String fullUrl) {
		this.fullUrl = fullUrl;
	}

	public SearchModeType getSearch() {
		return search;
	}
}
