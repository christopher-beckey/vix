/**
 * 
  Property of ISI Group, LLC
  Date Created: May 9, 2014
  Developer:  Julian Werfel
 */
package gov.va.med.imaging.hydra.rest.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="study")
public class HydraStudyType
{

	private String studyId;
    private String dicomUid;
    private String description;
    private Date procedureDate;
    private String procedureDescription;
    private String patientIcn; 
    private String patientName;
    
    private int imageCount;
    private String specialtyDescription;
    private String imageType;
    private String event;
    private String origin;
    private String studyClass;
    private String cptCode;
    
    private HydraSeriesesType serieses;
    
    public HydraStudyType()
    {
    	super();
    }

	public HydraStudyType(String studyId, String dicomUid, String description,
			Date procedureDate, String procedureDescription, String patientIcn,
			String patientName, int imageCount, String specialtyDescription,
			String imageType, String event, String origin, String studyClass,
			String cptCode, HydraSeriesesType serieses) 
	{
		super();
		this.studyId = studyId;
		this.dicomUid = dicomUid;
		this.description = description;
		this.procedureDate = procedureDate;
		this.procedureDescription = procedureDescription;
		this.patientIcn = patientIcn;
		this.patientName = patientName;
		this.imageCount = imageCount;
		this.specialtyDescription = specialtyDescription;
		this.imageType = imageType;
		this.event = event;
		this.origin = origin;
		this.studyClass = studyClass;
		this.cptCode = cptCode;
		this.serieses = serieses;
	}

	public String getStudyId() {
		return studyId;
	}

	public void setStudyId(String studyId) {
		this.studyId = studyId;
	}

	public String getDicomUid() {
		return dicomUid;
	}

	public void setDicomUid(String dicomUid) {
		this.dicomUid = dicomUid;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Date getProcedureDate() {
		return procedureDate;
	}

	public void setProcedureDate(Date procedureDate) {
		this.procedureDate = procedureDate;
	}

	public String getProcedureDescription() {
		return procedureDescription;
	}

	public void setProcedureDescription(String procedureDescription) {
		this.procedureDescription = procedureDescription;
	}

	public String getPatientIcn() {
		return patientIcn;
	}

	public void setPatientIcn(String patientIcn) {
		this.patientIcn = patientIcn;
	}

	public String getPatientName() {
		return patientName;
	}

	public void setPatientName(String patientName) {
		this.patientName = patientName;
	}

	public int getImageCount() {
		return imageCount;
	}

	public void setImageCount(int imageCount) {
		this.imageCount = imageCount;
	}

	public String getSpecialtyDescription() {
		return specialtyDescription;
	}

	public void setSpecialtyDescription(String specialtyDescription) {
		this.specialtyDescription = specialtyDescription;
	}

	public String getImageType() {
		return imageType;
	}

	public void setImageType(String imageType) {
		this.imageType = imageType;
	}

	public String getEvent() {
		return event;
	}

	public void setEvent(String event) {
		this.event = event;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getStudyClass() {
		return studyClass;
	}

	public void setStudyClass(String studyClass) {
		this.studyClass = studyClass;
	}

	public String getCptCode() {
		return cptCode;
	}

	public void setCptCode(String cptCode) {
		this.cptCode = cptCode;
	}

	public HydraSeriesesType getSerieses()
	{
		return serieses;
	}

	public void setSerieses(HydraSeriesesType serieses)
	{
		this.serieses = serieses;
	}
}
