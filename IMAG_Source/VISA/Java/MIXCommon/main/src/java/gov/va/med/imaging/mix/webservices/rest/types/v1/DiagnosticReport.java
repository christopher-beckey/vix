package gov.va.med.imaging.mix.webservices.rest.types.v1;

import javax.xml.bind.annotation.XmlRootElement;
// import java.io.Serializable;
// import java.util.ArrayList;
// import java.util.Iterator;
// import java.util.List;
// import java.util.Date;
// import java.util.SortedSet;
// import java.util.TreeSet;

/**
 * @author VACOTITTOC
 *
 * This DiagnosticReport class is for FHIR DiagnosticReport model support.
 * It refers to ImagingStudy children, instead it includes a ShallowStudy list.
 * the Accession Number hooks the report to the study(ies)
 * Cardinality: Patient 1..* DiagnosticReport 0..* ImagingStudy 0..* Series 0..* Instance
 *
 */
@XmlRootElement (name="DiagnosticReport")
public class DiagnosticReport // implements Serializable, /* Iterable<ShallowStudy>,*/ Comparable<DiagnosticReport>
{	
//	private static final long serialVersionUID = -5185851367113539915L;
//	private static final char q = '"';
	private String resourceType="DiagnosticReport"; // FHIR resource
	private String id;					// Diagnostic Report ID -- accession is preferred (if null from the enterprise, it will be a hashcode of the full report)
	private TextType text;				// contains the actual report (to/from ImagingStudy's additional text extension element) -- never null or empty!
	private String status="final";		// R! registered | partial | final | corrected | appended | cancelled | entered-in-error -- always final
	private CodeType category;			// Service category -- "radiology", "ophthalmology", etc. -- the discipline that provided the report - not used in exchange
	private CodeType code;				// R! Code|text for this diagnostic report - CPT Or LOINC (by order filler); initially "RAD|Radiology Report"
	private ReferenceType subject;		// R! reference to the patient of the order/report -- the enterprise's patient ID ("Patient/<icn>" or "Patient/<edipi>")
	private String encounter;			// Health care event when  test ordered (date-time) -- can be provided (yyyy-MM-ddTHH:MI:SS+HH:MI UTC format), but not required
	private String effectiveDateTime;	// when study was done & read (yyyy-MM-ddTHH:MI:SS+HH:MI UTC format) -- for date range the start value
	private String issued;				// R!  DateTime (yyyy-MM-ddTHH:MI:SS+HH:MI UTC format) the report was released
	private ReferenceType performer; 	// R!  Responsible Diagnostic Service - "radiology", etc. -- at least "VHA" or "DOD" must be set!
	private String request; 			// What was requested -- not maintained by image exchange
	private String specimen; 			// Specimens this report is based on -- -- might be used for Pathology -- not currently received
    private String result;				// Observations - simple, or complex nested groups -- not maintained by image exchange
    private String image=null;			// Key images associated with this report {comment, link //R!} -- not maintained for image exchange
	private String conclusion;			// Clinical Interp. of test results - Concise/clinically contextualized narrative interp. of the Diag.Report - if avail
	private String codedDiagnosis;		// Codes for the conclusion -- not maintained by image exchange
	private String presentedForm;		// Entire report as issued (attachment) -- not maintained by image exchange, see formattedTextReport field!
	private String imagingStudy=null;	// read only (non FHIR) field -- the ImagingStudies SET size
	private ShallowStudy[] shallowStudies; // for REST compliance
//	private List<ShallowStudy> shallowStudies = new ArrayList<ShallowStudy>(); // *** should be Sorted List?
//	private SortedSet<ImagingStudy> imagingStudies = new TreeSet<ImagingStudy>(new ImagingStudyComparator());

	public DiagnosticReport()
	{
		text=null; // new TextType("additional", "<div>...</div>");
		encounter = effectiveDateTime = issued = request = specimen = result =
			 conclusion = codedDiagnosis = presentedForm = null;
		subject = null; // new ReferenceType("Patient/{icn}");
		performer = null; // new ReferenceType("Organization/VHA");
		id=null;
		status="final";
		code = null;
		category = null;
		image=null;
		imagingStudy=null;
		shallowStudies = new ShallowStudy[0];
	}


//	/**
//	 * Create a new DiagnosticReport (no shallowStudy set, imagingStudy and image stay null)
//	 * @param reportId accession is preferred (if null from the enterprise, it will be a hashcode of the full report)
//	 * @param dTextReport The actual report from FHIR ImagingStudy's additional text extension element; should never be null
//	 * @param dRID Diagnostic Report ID -- auto set report hashcode if null is given -- supposed to be localID from creator enterprise
//	 * @param dCategory Service category -- "radiology", "ophthalmology", etc.- not used in exchange
//	 * @param dCode Code|text For this diagnostic report - CPT Or LOINC (by order filler) or at least ; "RAD|Radiology Report"
//	 * @param dPatID Patient ID of study creator enterprise (ICN for "VHA", EDI_PI for "DOD")
//	 * @param dEnc Health care event when test ordered (date-time) -- can be provided (yyyy-MM-ddTHH:MI:SS+HH:MI UTC format), but not required
//	 * @param dEDT When study was done & read (yyyy-MM-ddTHH:MI:SS+HH:MI UTC format) -- for date range the start value
//	 * @param dIssued DateTime (yyyy-MM-ddTHH:MI:SS+HH:MI UTC format) the report was released
//	 * @param dPerfr Responsible Diagnostic Service - "radiology", etc.; "VHA" or "DOD" at least
//	 * @param dReq What was requested -- not maintained by image exchange
//	 * @param dSpecimen Specimens this report is based on -- -- could be used for Pathology
//	 * @param dResult Observations - simple, or complex nested groups -- not maintained by image exchange
//	 * @param dConcl Clinical Interp. of test results - concise/clinically contextualized narrative interp. of the Diag.Report - if avail
//	 * @param dCodeDiag Codes for the conclusion -- not maintained by image exchange
//	 * @param dPresForm attachment is not maintained by image exchange, see formattedTextReport field!
//	 */
//	public DiagnosticReport(Integer reportId, String dTextReport, String dCategory, String dCode, String dPatID, String dEnc, String dEDT, String dIssued, 
//			     String dPerfr, String dReq, String dSpecimen, String dResult, String dConcl, String dCodeDiag, String dPresForm)
//			     throws Exception
//	{
//		if ((dTextReport == null) || dTextReport.isEmpty()) {
//			throw new Exception("Formatted Text Report (Escaped XHTML) cannot be empty.");
//		}
//		if ((dPatID == null) || dPatID.isEmpty()) {
//			throw new Exception("Report's subject(patientID) cannot be empty.");
//		}
//		if ((dCode == null) || dCode.isEmpty()) {
//			throw new Exception("Procedure Code cannot be empty.");
//		}
//		if ((dIssued == null) || dIssued.isEmpty()) {
//			throw new Exception("Report's release date cannot be empty.");
//		}
//		if ((dPerfr == null) || dPerfr.isEmpty()) {
//			throw new Exception("Performer cannot be empty, use \"VHA\" or \"DOD\".");
//		}
//		this.setText(dTextReport);
//
//		if (this.id == null) { // set report hashcode here
//			this.id= this.getText().hashCode();
//		} else
//			this.id = reportId;
//		
//		this.setCode(dCode);
//
//		this.status = "final"; // hardcoded
//		this.category = dCategory;
//		this.setSubject(dPatID);
//		this.encounter = dEnc;
//		this.effectiveDateTime = dEDT;
//		this.issued = dIssued;
//		this.performer = dPerfr;
//		this.request = dReq;
//		this.specimen = dSpecimen;
//		this.result = dResult;
//		this.image = null; // hardcoded
//		this.imagingStudy = null; // hardcoded
//		this.conclusion = dConcl;
//		this.codedDiagnosis = dCodeDiag;
//		this.presentedForm = dPresForm;
//		this.shallowStudies = new ShallowStudiesType();
//	}

	public TextType getText() {
//		String reportText=null;
//		if ((text!=null) && !text.isEmpty()) {
//			reportText = text.substring(text.lastIndexOf("<div>")+1, text.lastIndexOf("</div>}"));
//		}
//		return reportText;
		return text;
	}

	public void setText(TextType textType) { // formattedTextReport) {
//      this.text = "{\"status\": \"additional\", \"div\": \"<div>" + formattedTextReport + "</div>"\"}"
//		this.text = "{" +q+"status"+q+":" +q+"additional"+q+"," +q+"div"+q+":" +q+"<div>"+formattedTextReport+"</div>"+q+ "}";
		this.text = textType;
	}

	public String getResourceType() {
		return resourceType;
	}

	public String getId() {
		return id;
	}

	public void setId(String reportId) {
		this.id = reportId;
	}

	public String getStatus() {
		return status;
	}

	public CodeType getCategory() {
//		String codeValue=null;
//		if ((category!=null) && !category.isEmpty()) {
//			codeValue = category.substring(category.lastIndexOf(", \"code\":\"")+1, category.lastIndexOf("\"}"));
//		}
//		return codeValue;
		return category;
	}

	public void setCategory(CodeType category) {
//		this.category = "[{\"code\": [{\"coding\": {\"system\": \"http://hl7.org/fhir/v2/0074\", \"code\":\"" + category + "\"}]]";
//		this.category = "[{" +q+"code"+q+ ": [{" +q+"coding"+q+ ": {" +q+"system"+q+ ": " +q+"http://hl7.org/fhir/v2/0074"+q+ ", " +q+"code"+q+ ":" +q+category+q+ "}]]";
		this.category = category;
	}

	public CodeType getCode() {
//		String codeValue=null;
//		if ((code!=null) && !code.isEmpty()) {
//			codeValue = code.substring(code.lastIndexOf(", \"code\":\"")+1, code.lastIndexOf("\", \"display\""));
//		}
//		return codeValue;
		return code;
	}

	public void setCode(CodeType code) {
//		this.code = "[{\"code\": [{\"coding\": {\"system\": \"http://hl7.org/fhir/v2/0074\", \"code\":\"" + code + "\", \"display\": \"Radiology Report\"}]";
//		this.code = "[{" +q+"code"+q+ ": [{" +q+"coding"+q+ ": {" +q+"system"+q+ ": " +q+"http://hl7.org/fhir/v2/0074"+q+ ", " 
//						 +q+"code"+q+ ":" +q+code+q+ ", " +q+"display"+q+":" +q+"Radiology Report"+q+ "}]";
		this.code = code;
	}

	public ReferenceType getSubject() {
//		String patientId=null;
//		if ((subject!=null) && !subject.isEmpty()) {
//			patientId = subject.substring(subject.lastIndexOf("Patient/"), subject.lastIndexOf("\"}"));
//		}
//		return patientId;
		return subject;
	}

	public void setSubject(ReferenceType patRef) { // (String patientID) {
//		this.subject = "{\"reference\": \"Patient/" + patientID + "\"}";
//		this.subject = "{" +q+"reference"+q+": " +q+"Patient/"+patientID+q + "}";
		this.subject = patRef;
	}

	public String getEncounter() {
		return encounter;
	}

	public void setEncounter(String encounter) {
		this.encounter = encounter;
	}

	public String getEffectiveDateTime() {
		return effectiveDateTime;
	}

	public void setEffectiveDateTime(String effectiveDateTime) {
		this.effectiveDateTime = effectiveDateTime;
	}

	public String getIssued() {
		return issued;
	}

	public void setIssued(String issued) {
		this.issued = issued;
	}

	public ReferenceType getPerformer() {
		return performer;
	}

	public void setPerformer(ReferenceType refType) { // (String performer) {
//		this.performer = "{\"reference\": \"Organization/VHA\"}";
//		this.performer = "{" +q+"reference"+q+": " +q+"Organization/VHA"+q+ "}";
		this.performer = refType;
	}

	public String getRequest() {
		return request;
	}

	public void setRequest(String request) {
		this.request = request;
	}

	public String getSpecimen() {
		return specimen;
	}

	public void setSpecimen(String specimen) {
		this.specimen = specimen;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}

	public String getImage() {
		return image;
	}

	public String getConclusion() {
		return conclusion;
	}

	public void setConclusion(String conclusion) {
		this.conclusion = conclusion;
	}

	public String getCodedDiagnosis() {
		return codedDiagnosis;
	}

	public void setCodedDiagnosis(String codedDiagnosis) {
		this.codedDiagnosis = codedDiagnosis;
	}

	public String getPresentedForm() {
		return presentedForm;
	}

	public void setPresentedForm(String presentedForm) {
		this.presentedForm = presentedForm;
	}

	public String getImagingStudy() {
		return imagingStudy;
	}


	public void setImagingStudy(String imagingStudy) {
		this.imagingStudy = imagingStudy;
	}


	public ShallowStudy[] getShallowStudy() { // use single (not plural) for REST JSOJN translation's sake
		return this.shallowStudies;
	}

	public Integer getNumberOfShallowStudies() {
		Integer num = 0;
		if (shallowStudies!=null)
			num = shallowStudies.length;
		return num;
	}

//	public void setShallowStudies(ShallowStudy[] shallowStudies) {
//		this.shallowStudies = shallowStudies;
//	}
	
	/**
	 * Add a ShallowStudy to the DiagnosticReport as a child
	 * @param shallowStudy a single ShallowStudy
	 */
	public void addShallowStudy(ShallowStudy shallowStudy) 
	{
		synchronized(this.shallowStudies)
		{
			ShallowStudy [] shallowStudyInList = this.shallowStudies;
			int numItems=0;
			if (shallowStudyInList.length==0) {
				shallowStudyInList = new ShallowStudy[1];
			} else {
				numItems = shallowStudyInList.length;
			}
			ShallowStudy [] shallowStudyOutList = new ShallowStudy[numItems+1];
			// copy In list to Out one first
			for (int i=0; i<numItems; i++) {
				shallowStudyOutList[i] = shallowStudyInList[i];
			}
			shallowStudyOutList[numItems] = shallowStudy; // add new element
			this.shallowStudies = shallowStudyOutList;
		}
	}

//	/**
//	 * Append all of the ShallowStudies in the given Set to the DiagnosticReport as children
//	 * @param imagingStudies is a SortedSet of ImagingStudy
//	 */
//	public void addShallowStudies(ShallowStudiesType shallowStudies) 
//	{
//		synchronized(this.shallowStudies)
//		{
//			this.shallowStudies.setStudy(shallowStudies);
//		}
//	}
//
//	@Override
//	public Iterator<ShallowStudy> iterator()
//	{
//		return shallowStudies.getStudies().iterator();
//	}
//


	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() 
	{
		return "ReportID[" + this.id + "] of patient[" + this.subject + "]; category=" + this.category + "]; performer=" + this.performer + "; Releae Date/Time=" + this.issued + 
				"; code=" + this.getCode() + "; Conclusion=" + this.conclusion + 
				"#shallowStudies=" + this.getNumberOfShallowStudies();
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((text == null) ? 0 : text.hashCode());
		result = prime * result
				+ ((subject == null) ? 0 : subject.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		final DiagnosticReport other = (DiagnosticReport) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!issued.equals(other.issued))
			return false;
		if (subject == null) {
			if (other.subject != null)
				return false;
		} else if (!subject.equals(other.subject))
			return false;
		return true;
	}	
	
//	@Override
//	public int compareTo(DiagnosticReport that) 
//	{
//		return (this.text.compareTo(that.text));
//	}
}
