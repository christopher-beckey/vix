package gov.va.med.imaging.ax.webservices.rest.types;

import gov.va.med.imaging.ax.webservices.rest.types.ReferenceType;

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
 * This DocumentReference class is for FHIR DocumentRefernce bundled response use, ***? JSON tailored
 * Cardinality: Bundle 1-1 Patient 1..* DocumentReference
 */
@XmlRootElement
public class DocumentReference
{	
//	private static final long serialVersionUID = -5185851367113539916L;
//	private static final char q = '"';
	private TextType text; 				// document name
	private String resourceType="DocumentReference"; // FHIR resource
	private Value masterIdentifier;	// 	Master Version Specific Identifier - VistA Imaging documentURN
	private ReferenceType subject;		// reference to patient ID from creator enterprise (ICN for VA, EDI_PI for DOD): {"reference": patient/... }
	private CodeType type;				// R!  Kind of document (LOINC if available) -- 34794-8 (documents) is default!
//	private CodeType Class;				// specialty (-ology); *** "class" cannot be used in java... ***
	private ReferenceType[] author;		// "Practitioner/???" and "Organization/VistA Imaging"
    private ReferenceType custodian;	// "Organization/VHA"
	private String created;				// when document was created (yyyy-MM-ddTHH:MI:SS+HH:MI UTC format)
	private String indexed;				// when this document reference was created (yyyy-MM-ddTHH:MI:SS+HH:MI UTC format); uploaded to server cache??
	private String status="current";	// hardcoded
	private String description;			// Human-readable description - Doc Title to display in listing (along with "created" & content type & size)
	private CodeType[] securityLabel;		// Document security-tags - for VA sens code: none -> L, 1 -> M, 2 -> N; 3 -> R; >=4 -> V
	private ContentType[] content;		// has one attachment structure with contentType, url, size & hashcode for each element -- that is always one :-)

	public DocumentReference()
	{
		// set hard coded values
		resourceType = "DocumentReference";
		status = "current";
	}

	public TextType getText() {
		return text;
	}

	public void setText(TextType text) {
		this.text = text;
	}

	public String getResourceType() {
		return resourceType;
	}

	public ReferenceType getSubject() {
		return subject;
	}

	public void setSubject(ReferenceType subject) {
		this.subject = subject;
	}

	public Value getMasterIdentifier() {
		return this.masterIdentifier;
	}

	public void setMasterIdentifier(Value masterID) {
		this.masterIdentifier = masterID;
	}

	public CodeType getType() {
		return this.type;
	}

	public void setType(CodeType type) {
		this.type = type;
	}

//	public CodeType getClass1() {
//		return this.Class;
//	}
//
//	public void setClass1(CodeType class1) {
//		this.Class = class1;
//	}

	public ReferenceType[] getAuthor() {
		return author;
	}

	public void setAuthor(ReferenceType[] author) {
		this.author = author;
	}

	public ReferenceType getCustodian() {
		return custodian;
	}

	public void setCustodian(ReferenceType custodian) {
		this.custodian = custodian;
	}

	public String getCreated() {
		return created;
	}

	public void setCreated(String created) {
		this.created = created;
	}

	public String getIndexed() {
		return indexed;
	}

	public void setIndexed(String indexed) {
		this.indexed = indexed;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public CodeType[] getSecurityLabel() {
		return securityLabel;
	}

	public void setSecurityLabel(CodeType[] securityLabel) {
		this.securityLabel = securityLabel;
	}

	public ContentType[] getContent() {
		return content;
	}

	public void setContent(ContentType[] content) {
		this.content = content;
	}

	public void setResourceType(String resourceType) {
		this.resourceType = resourceType;
	}

//	public void setSerieses(SeriesesType serieses) {
//		this.serieses = serieses;
//		this.numberOfSeries = this.serieses.getSerieses().length;
//		this.numberOfInstances=0;
//		for (int i=0; i<numberOfSeries; i++)
//			this.numberOfInstances += this.serieses.getSerieses()[i].getInstances().getInstances().length;
//	}
	
	
//	@Override
//	public int compareTo(ImagingStudy that) 
//	{
//		return this.uid.compareTo(that.uid);
//	}
}
