package gov.va.med.imaging.dx;

public class DesPollerData {
	private String title;
	private String content;
	private String recordId;
	private String enteredDate;
	private String contentType;
	private String facilityId;
	private String clinicalType;
	private String descr;
	private String homeCommunityId;
	private String repositoryId;
	private String documentId;
	private String oid;
	private Integer size;

	public String getOriginId() {
		return oid;
	}

	public void setOriginId(String oid) {
		this.oid = oid;
	}

	public String getHomeCommunityId() {
		return homeCommunityId;
	}

	public void setHomeCommunityId(String homeCommunityId) {
		this.homeCommunityId = homeCommunityId;
	}

	public String getClinicalType() {
		return clinicalType;
	}

	public void setClinicalType(String clinicalType) {
		this.clinicalType = clinicalType;
	}

	public String getDescription()
	{
		return descr;
	}

	public void setDescription(String descr) {
		this.descr = descr;
	}

	public Integer getSize()
	{
		return size;
	}
	
	public void setSize(Integer size)
	{
		this.size = size;
	}

	public String getTitle()
	{
		return title;
	}
	
	public void setTitle(String title)
	{
		this.title = title;
	}
	
	public String getContent()
	{
		return content;
	}
	
	public void setContent(String content)
	{
		this.content = content;
	}

	public String getRecordId()
	{
		return recordId;
	}
	
	public void setRecordId(String recordId)
	{
		this.recordId = recordId;
	}

	public String getRepositoryId() {
		return this.repositoryId;
	}

	public void setRepositoryId(String repositoryId) {
		this.repositoryId = repositoryId;
	}

	public String getEnteredDate() {
		return this.enteredDate;
	}

	public void setEnteredDate(String enteredDate) {
		this.enteredDate = enteredDate;
	}

	public String getContentType() {
		return this.contentType;
	}

	public void setContentType(String contentType) {
		this.contentType = contentType;
	}

	public String getFacilityId() {
		return this.facilityId;
	}

	public void setFacilityId(String facilityId) {
		this.facilityId = facilityId;
	}

	public String getDocumentId() {
		return this.documentId;
	}

	public void setDocumentId(String documentId) {
		this.documentId = documentId;
	}


}
