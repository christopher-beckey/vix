package gov.va.med.imaging.mix.webservices.rest.types.v1;

import gov.va.med.imaging.mix.webservices.rest.types.v1.Series;

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
 * This ImagingStudy class is for FHIR ImagingStudy model support (referring to the equivalent DICOM Study term), ***? JSON tailored
 * Cardinality: Patient 1..* DiagnosticReport 0..* ImagingStudy 0..* Series 0..* Instance
 */
@XmlRootElement(name="ImagingStudy")
public class ImagingStudy // implements Serializable, /* Iterable<Series>,*/ Comparable<ImagingStudy> 
{	
//	private static final long serialVersionUID = -5185851367113539916L;
//	private static final char q = '"';
	private String resourceType="ImagingStudy"; // FHIR resource
	private String started;				// when study started (yyyy-MM-ddTHH:MI:SS+HH:MI UTC format)
	private ReferenceType patient;		// R! reference to patient ID from creator enterprise (ICN for VA, EDI_PI for DOD): {"reference": patient/... }
	private String uid;					// R! DICOM Study UID -- To non-VA requester a morphed studyURN is given (built-in VA site number, etc.) 
	private String accession;			// hooks studies to one report, that is one order (max 16/DICOM)
	private String identifier;			// the Study's ID string (Max 16 chars) -- Other identifier for the Study
	private String order;				// Order(s) that caused this study to be performed -- ? old HL7 term (Placer Order#) -- not used 
	private ModCodeType[] modalityList;		// One or more Modalities separated by ','
	private String referrer; 			// Referring physician - not maintained
	private String availability; 		// ONLINE | OFFLINE | NEARLINE | UNAVAILABLE -- only ONLINE data is maintained for exchange
	private String url; 				// Location of the referenced study -- not used
    private ReferenceType procedure;			// Type of procedure performed -- not maintained for exchange, available from VistA!
    private String interpreter;			// Who interpreted images -- not maintained for exchange
	private String description;			// Max 64 chars free text
	// here are the Read Only attributes; they have Getters only and must be set only internally by DB API call
	private Integer numberOfSeries;		// R! -- supposed to match series SET size
	private Integer numberOfInstances;	// R! -- supposed to match sum of Instance SET sizes from all series SET
	private Series[] serieses;
	//	private List<Series> series = new ArrayList<Series>(); // *** should be Sorted List?
	// private SortedSet<Series> series = new TreeSet<Series>(new SeriesComparator());

	public ImagingStudy()
	{
		started = uid = accession = identifier = order = referrer = url = interpreter = description = null;
		modalityList = null;
		procedure = null;
		patient = null;
		availability = "ONLINE";
		numberOfSeries = 0;
		numberOfInstances = 0;
		this.serieses = new Series[0];
	}

//	/**
//	 * Create a new ImagingStudy
//	 * @param sDT when study started (yyyy-MM-ddTHH:MI:SS+HH:MI UTC format)
//	 * @param sPatID patient ID of study creator enterprise (ICN for VA, EDI_PI for DOD)
//	 * @param sIUID DICOM Study UID -- To non-VA requester a morphed studyURN is given (built-in VA site number, etc.)
//	 * @param sAccN AccessionNumber -- hooks studies to one report, that is one order (max 16/DICOM)
//	 * @param sID the Study's ID string (max 16 in DICOM)
//	 * @param sOrder Placer Order number - not maintained
//	 * @param mtysInStd One or more Modalities in study separated by ','
//	 * @param sRef Referring physician - not maintained for exchange
//	 * @param sAvail ONLINE | OFFLINE | NEARLINE | UNAVAILABLE -- only ONLINE data is maintained for exchange 
//	 * @param sUrl location of the referenced study -- not used for for exchange
//	 * @param sProc Type of procedure performed -- not maintained for exchange
//	 * @param sInterp Who interpreted images -- not maintained for exchange
//	 * @param description free text (64/DICOM)
//	 */
//	public ImagingStudy(String sDT, String sPatID, String sIUID, String sAccN, String sID, 
//			     String sOrder, String mtysInStd,  String sRef, String sAvail, String sUrl, String sProc, String sInterp, String sDesc)
//	{
//		this.started = sDT;
//		this.setPatientID(sPatID);
//		this.uid = sIUID;
//		this.accession = sAccN;
//		this.identifier = sID;
//		this.order = sOrder;
//		this.modalityList = mtysInStd;
//		this.referrer = sRef;
//		this.availability = sAvail;
//		this.procedure = sProc;
//		this.interpreter = sInterp;
//		this.description = sDesc;
//		
//		this.numberOfSeries = 0;
//		this.numberOfInstances = 0;
//		this.serieses = new SeriesesType();
//	}

	public String getResourceType() {
		return resourceType;
	}

	public String getStarted() {
		return started;
	}

	public void setStarted(String startDateTime) {
		this.started = startDateTime;
	}

	public ReferenceType getPatient() {
//		String patientId=null;
//		if (patient!=null) {
//			patientId = patient.substring(patient.lastIndexOf("Patient/")+1, patient.lastIndexOf("\"}"));
//		}
//		return patientId;
		return patient;
	}

	public void setPatient(ReferenceType patRef) {
//		this.patient = "{\"reference\": \"Patient/" + patientID + "\"}";
//		this.patient = "{" +q+"reference"+q+": " +q+"Patient/"+patientID+q + "}";
		this.patient = patRef;
	}

	public String getUid() {
		return uid;
	}

	public void setUid(String studyUID) {
		this.uid = studyUID;
	}

	public String getAccessionNumber() {
		return accession;
	}

	public void setAccessionNumber(String accessionNumber) {
		this.accession = accessionNumber;
	}

	public String getIdentifier() {
		return identifier;
	}

	public void setIdentifier(String studyID) {
		this.identifier = studyID;
	}

	public String getOrder() {
		return order;
	}

	public void setOrder(String order) {
		this.order = order;
	}

	public ModCodeType[] getModalityList() {
		return modalityList;
	}

	public void setModalitiesInStudy(ModCodeType[] modalitiesInStudy) {
		this.modalityList = modalitiesInStudy;
	}

	public void setReferrer(String referrer) {
		this.referrer = referrer;	// DicomUtils.reformatDicomName(name);
	}
	public String getReferrer() {
		return referrer;
	}

	public String getAvailability() {
		return availability;
	}

	public void setAvailability(String availability) {
		this.availability = availability;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public ReferenceType getProcedure() {
		return procedure;
	}

	public void setProcedure(ReferenceType procedure) {
		this.procedure = procedure;
	}
	
	public String getInterpreter() {
		return interpreter;
	}

	public void setInterpreter(String interpreter) {
		this.interpreter = interpreter;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Integer getNumberOfSeries() {
		return numberOfSeries;
	}

	public Integer getNumberOfInstances() {
		return numberOfInstances;
	}

	public Series[] getSeries() { // use single (not serieses) for REST JSOJN translation's sake
		return this.serieses;
	}

//	public void setSerieses(SeriesesType serieses) {
//		this.serieses = serieses;
//		this.numberOfSeries = this.serieses.getSerieses().length;
//		this.numberOfInstances=0;
//		for (int i=0; i<numberOfSeries; i++)
//			this.numberOfInstances += this.serieses.getSerieses()[i].getInstances().getInstances().length;
//	}
	
	/**
	 * Add a series to the Study as a child; increments counters
	 * @param series as a single series
	 */
	public void addSeries(Series series) 
	{
		synchronized(this.serieses)
		{
			Series [] seriesInList = this.serieses;
			int numItems = 0;
			if (seriesInList.length==0) {
				seriesInList = new Series[1];
			} else {
				numItems = seriesInList.length;
			}
			Series [] seriesOutList = new Series[numItems+1];
			// copy In list to Out one first
			for (int i=0; i<numItems; i++) {
				seriesOutList[i] = seriesInList[i];
			}
			seriesOutList[numItems] = series;
			this.serieses = seriesOutList;

			numberOfSeries++;
			if (series.getInstance()!=null)
				numberOfInstances += series.getInstance().length; // getInstance returns Instance array
		}
	}

//	/**
//	 * Append all of the series of the given Set to the Study as children; increments counters
//	 * @param series as a List
//	 */
//	public void addSerieses(List<Series> series) 
//	{
//		synchronized(this.series)
//		{
//			this.series.addAll(series);
//			this.numberOfInstances=0;
//			for (int i=0; i<numberOfSeries; i++)
//				this.numberOfInstances += this.series.get(i).getInstances().size();
//		}
//	}
//
//	@Override
//	public Iterator<Series> iterator()
//	{
//		return series.iterator();
//	}



	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() 
	{
		return this.uid + " of patient[" + this.getPatient() + "]; accessionNum=" + this.accession + "; ID=" + this.identifier + 
				"; Desc=" + this.description + "; Proc=" + this.procedure + "; Modalities=" + this.modalityList + 
				"; StudyDateTime=" + this.started + " -- #Series=" + this.numberOfSeries + " #instances=" + this.numberOfInstances + ";";
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((uid == null) ? 0 : uid.hashCode());
		result = prime * result
				+ ((patient == null) ? 0 : patient.hashCode());
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
		final ImagingStudy other = (ImagingStudy) obj;
		if (uid == null) {
			if (other.uid != null)
				return false;
		} else if (!uid.equals(other.uid))
			return false;
		if (patient == null) {
			if (other.patient != null)
				return false;
		} else if (!patient.equals(other.patient))
			return false;
		return true;
	}	
	
//	@Override
//	public int compareTo(ImagingStudy that) 
//	{
//		return this.uid.compareTo(that.uid);
//	}
}
