package gov.va.med.imaging.tiu.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Quoc Nguyen
 *
 */
@XmlRootElement(name="noteInput") 
public class TIUNoteInputType {
	
	// Required fields for note and ingest
	private String tiuNoteTitleUrn;
	private String date;
	private String noteText;
	private String patientId;					// ingest only
	private String originIndex;					// ingest only
	private String typeIndex;					// ingest only
	private String siteId;						// ingest only and new for ICW new API
	private String shortDescription;			// new for ICW new API
	
	private TIUItemStreamType streamType;		// set instead of converting from XML
	
	// Not come in. Keep for backward compatibility
	private String tiuNoteLocationUrn;
	private String tiuNoteAuthorUrn;
	private String consultUrn;

	/**
	 * Default constructor
	 */
	public TIUNoteInputType() {
		super();
	}
	
	/**
	 * Convenient constructor
	 * 
	 * @param String					TIU note title URN
	 * @param String					patient Id
	 * @param String					note date
	 * @param String 					note text
	 * @param String					origin index
	 * @param String					type index
	 * @param String					short description
	 * @param TIUItemStreamType			container for uploaded file
	 * @param String					TIU note location URN (not used currently)
	 * @param String					TIU note author URN (not used currently)		
	 * @param String					consult URN (not used currently)
	 * 
	 */
	public TIUNoteInputType(String tiuNoteTitleUrn, String patientId, String date, String noteText, String originIndex,
			String typeIndex, String shortDescription, TIUItemStreamType streamType, String tiuNoteLocationUrn,
			String tiuNoteAuthorUrn, String consultUrn) {
		super();
		this.tiuNoteTitleUrn = tiuNoteTitleUrn;
		this.patientId = patientId;
		this.date = date;
		this.noteText = noteText;
		this.originIndex = originIndex;
		this.typeIndex = typeIndex;
		this.shortDescription = shortDescription;
		this.streamType = streamType;
		this.tiuNoteLocationUrn = tiuNoteLocationUrn;
		this.tiuNoteAuthorUrn = tiuNoteAuthorUrn;
		this.consultUrn = consultUrn;
	}

	public String getTiuNoteTitleUrn() {
		return tiuNoteTitleUrn;
	}

	public void setTiuNoteTitleUrn(String tiuNoteTitleUrn) {
		this.tiuNoteTitleUrn = tiuNoteTitleUrn;
	}

	public String getPatientId() {
		return patientId;
	}

	public void setPatientId(String patientId) {
		this.patientId = patientId;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getNoteText() {
		return noteText;
	}

	public void setNoteText(String noteText) {
		this.noteText = noteText;
	}

	public String getOriginIndex() {
		return originIndex;
	}

	public void setOriginIndex(String originIndex) {
		this.originIndex = originIndex;
	}

	public String getTypeIndex() {
		return typeIndex;
	}

	public void setTypeIndex(String typeIndex) {
		this.typeIndex = typeIndex;
	}

	public String getShortDescription() {
		return shortDescription;
	}

	public void setShortDescription(String shortDescription) {
		this.shortDescription = shortDescription;
	}

	public TIUItemStreamType getStreamType() {
		return streamType;
	}

	public void setStreamType(TIUItemStreamType streamType) {
		this.streamType = streamType;
	}

	public String getTiuNoteLocationUrn() {
		return tiuNoteLocationUrn;
	}

	public void setTiuNoteLocationUrn(String tiuNoteLocationUrn) {
		this.tiuNoteLocationUrn = tiuNoteLocationUrn;
	}

	public String getTiuNoteAuthorUrn() {
		return tiuNoteAuthorUrn;
	}

	public void setTiuNoteAuthorUrn(String tiuNoteAuthorUrn) {
		this.tiuNoteAuthorUrn = tiuNoteAuthorUrn;
	}

	public String getConsultUrn() {
		return consultUrn;
	}

	public void setConsultUrn(String consultUrn) {
		this.consultUrn = consultUrn;
	}

	public String getSiteId() {
		return siteId;
	}

	public void setSiteId(String siteId) {
		this.siteId = siteId;
	}

	@Override
	public String toString() {
		return "TIUNoteInputType [tiuNoteTitleUrn=" + tiuNoteTitleUrn + ", date=" + date + ", noteText=" + noteText
				+ ", patientId=" + patientId + ", originIndex=" + originIndex + ", typeIndex=" + typeIndex + ", siteId="
				+ siteId + ", shortDescription=" + shortDescription + ", streamType=" + streamType
				+ ", tiuNoteLocationUrn=" + tiuNoteLocationUrn + ", tiuNoteAuthorUrn=" + tiuNoteAuthorUrn
				+ ", consultUrn=" + consultUrn + "]";
	}
	
}
