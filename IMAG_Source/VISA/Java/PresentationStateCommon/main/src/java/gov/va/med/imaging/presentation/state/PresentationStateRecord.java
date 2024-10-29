/**
 * 
 */
package gov.va.med.imaging.presentation.state;

/**
 * @author William Peterson
 *
 */
public class PresentationStateRecord {

	private String studyUID = null;
	private String pStateUID = null;
	private String pStateName = null;
	private String source = null;
	private String timeStored = null;
	private String duz = null;
	
	private boolean includeDeleted = false;
	private boolean includeOtherUsers = true;
	private boolean includeDetails = false;

	private String psData;
	
	//contextid in Vista is used as cross reference and defined with max 64chars
	private final int MAXCONTEXTIDLENGTH = 64; 
	
	public PresentationStateRecord() {
	
	}

	public PresentationStateRecord(String studyUID, String pStateUID, String pStateName, String source) {
		super();
		this.studyUID = studyUID;
		this.pStateUID = pStateUID;
		this.pStateName = pStateName;
		this.source = source;
	}


	public String getpStateUID() {
		return pStateUID;
	}

	public void setpStateUID(String pStateUID) {
		this.pStateUID = pStateUID; 
	}


	public String getStudyUID() {
		return studyUID;
	}

	public void setStudyUID(String studyUID) {
		if (studyUID.length() > MAXCONTEXTIDLENGTH)
		{
			studyUID = studyUID.substring(0, MAXCONTEXTIDLENGTH); 
		}
		this.studyUID = studyUID;
	}

	public String getSource() {
		return source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getPsData() {
		return psData;
	}

	public void setPsData(String psData) {
		this.psData = psData;
	}

	public boolean isIncludeDeleted() {
		return includeDeleted;
	}

	public void setIncludeDeleted(boolean includeDeleted) {
		this.includeDeleted = includeDeleted;
	}

	public boolean isIncludeOtherUsers() {
		return includeOtherUsers;
	}

	public void setIncludeOtherUsers(boolean includeOtherUsers) {
		this.includeOtherUsers = includeOtherUsers;
	}

	public boolean isIncludeDetails() {
		return includeDetails;
	}

	public void setIncludeDetails(boolean includeDetails) {
		this.includeDetails = includeDetails;
	}

	public String getpStateName() {
		return pStateName;
	}

	public void setpStateName(String pStateName) {
		this.pStateName = pStateName;
	}	
	
	public String getTimeStored() {
		return timeStored;
	}

	public void setTimeStored(String timeStored) {
		this.timeStored = timeStored;
	}

	public String getDuz() {
		return duz;
	}

	public void setDuz(String duz) {
		this.duz = duz;
	}

	@Override
	public String toString() {
		
		boolean hasData = psData != null ? true : false;
		
		return "PresentationStateRecord [studyUID=" + studyUID + ", pStateUID="
				+ pStateUID + ", pStateName=" + pStateName + ", source="
				+ source + ", timeStored=" + timeStored + ", duz=" + duz 
				+ ", includeDeleted=" + includeDeleted
				+ ", includeOtherUsers=" + includeOtherUsers
				+ ", includeDetails=" + includeDetails + ", psData=" + hasData
				+ "]";
	}
	
}
