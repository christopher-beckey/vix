/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.rest.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian
 *
 */
@XmlRootElement(name="study")
public class ViewerStudyStudyType
{
	
	private String studyId;
    private String dicomUid;
    private String description;
    private Date procedureDate;
    private String procedureDescription;
    private String patientId; 
    private String patientName;
    private String siteNumber;
    private String siteName;
    private String siteAbbreviation;
    private int imageCount;
    private String specialtyDescription;
    private String noteTitle;
    private String imagePackage;
    private String imageType;
    private String event;
    private String origin;
    private String studyPackage;
    private String studyClass;
    private String studyType;
    private String captureDate;
    private String capturedBy;
    private String firstImageId;
    private String groupIen;
    private String alternateExamNumber;
    private String contextId;
    private String errorMessage;

    private ViewerStudyImageType firstImage;
    private String [] studyModalities;
    
	private boolean sensitive = false;
	private Date documentDate = null;
	//private String accessionNumber;
	
	private ViewerStudySeriesesType series;
	
	public ViewerStudyStudyType()
	{
		super();
	}

	public String getStudyId()
	{
		return studyId;
	}

	public void setStudyId(String studyId)
	{
		this.studyId = studyId;
	}

	public String getDicomUid()
	{
		return dicomUid;
	}

	public void setDicomUid(String dicomUid)
	{
		this.dicomUid = dicomUid;
	}

	public String getDescription()
	{
		return description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}

	public Date getProcedureDate()
	{
		return procedureDate;
	}

	public void setProcedureDate(Date procedureDate)
	{
		this.procedureDate = procedureDate;
	}

	public String getProcedureDescription()
	{
		return procedureDescription;
	}

	public void setProcedureDescription(String procedureDescription)
	{
		this.procedureDescription = procedureDescription;
	}

	public String getPatientId()
	{
		return patientId;
	}

	public void setPatientId(String patientId)
	{
		this.patientId = patientId;
	}

	public String getPatientName()
	{
		return patientName;
	}

	public void setPatientName(String patientName)
	{
		this.patientName = patientName;
	}

	public String getSiteNumber()
	{
		return siteNumber;
	}

	public void setSiteNumber(String siteNumber)
	{
		this.siteNumber = siteNumber;
	}

	public String getSiteName()
	{
		return siteName;
	}

	public void setSiteName(String siteName)
	{
		this.siteName = siteName;
	}

	public String getSiteAbbreviation()
	{
		return siteAbbreviation;
	}

	public void setSiteAbbreviation(String siteAbbreviation)
	{
		this.siteAbbreviation = siteAbbreviation;
	}

	public int getImageCount()
	{
		return imageCount;
	}

	public void setImageCount(int imageCount)
	{
		this.imageCount = imageCount;
	}

	public String getSpecialtyDescription()
	{
		return specialtyDescription;
	}

	public void setSpecialtyDescription(String specialtyDescription)
	{
		this.specialtyDescription = specialtyDescription;
	}

	public String getNoteTitle()
	{
		return noteTitle;
	}

	public void setNoteTitle(String noteTitle)
	{
		this.noteTitle = noteTitle;
	}

	@XmlElement(name="package", nillable=true)
	public String getImagePackage()
	{
		return imagePackage;
	}

	public void setImagePackage(String imagePackage)
	{
		this.imagePackage = imagePackage;
	}

	@XmlElement(name="type")
	public String getImageType()
	{
		return imageType;
	}

	public void setImageType(String imageType)
	{
		this.imageType = imageType;
	}

	public String getEvent()
	{
		return event;
	}

	public void setEvent(String event)
	{
		this.event = event;
	}

	public String getOrigin()
	{
		return origin;
	}

	public void setOrigin(String origin)
	{
		this.origin = origin;
	}

	public String getStudyPackage()
	{
		return studyPackage;
	}

	public void setStudyPackage(String studyPackage)
	{
		this.studyPackage = studyPackage;
	}

	public String getStudyClass()
	{
		return studyClass;
	}

	public void setStudyClass(String studyClass)
	{
		this.studyClass = studyClass;
	}

	public String getStudyType()
	{
		return studyType;
	}

	public void setStudyType(String studyType)
	{
		this.studyType = studyType;
	}

	public String getCaptureDate()
	{
		return captureDate;
	}

	public void setCaptureDate(String captureDate)
	{
		this.captureDate = captureDate;
	}

	public String getCapturedBy()
	{
		return capturedBy;
	}

	public void setCapturedBy(String capturedBy)
	{
		this.capturedBy = capturedBy;
	}

	public String getFirstImageId()
	{
		return firstImageId;
	}

	public void setFirstImageId(String firstImageId)
	{
		this.firstImageId = firstImageId;
	}

	public ViewerStudyImageType getFirstImage()
	{
		return firstImage;
	}

	public void setFirstImage(ViewerStudyImageType firstImage)
	{
		this.firstImage = firstImage;
	}

	public String[] getStudyModalities()
	{
		return studyModalities;
	}

	public void setStudyModalities(String[] studyModalities)
	{
		this.studyModalities = studyModalities;
	}

	public boolean isSensitive()
	{
		return sensitive;
	}

	public void setSensitive(boolean sensitive)
	{
		this.sensitive = sensitive;
	}

	public Date getDocumentDate()
	{
		return documentDate;
	}

	public void setDocumentDate(Date documentDate)
	{
		this.documentDate = documentDate;
	}

	/**
	 * @return the series
	 */
	@XmlElement(name="serieses")
	public ViewerStudySeriesesType getSeries()
	{
		return series;
	}

	/**
	 * @param series the series to set
	 */
	public void setSeries(ViewerStudySeriesesType series)
	{
		this.series = series;
	}

	public String getGroupIen() {
		return groupIen;
	}

	public void setGroupIen(String groupIen) {
		this.groupIen = groupIen;
	}

	public String getAlternateExamNumber() {
		return alternateExamNumber;
	}

	public void setAlternateExamNumber(String alternateExamNumber) {
		this.alternateExamNumber = alternateExamNumber;
	}
	
	public String getContextId()
	{
		return contextId;
	}

	public void setContextId(String contextId)
	{
		this.contextId = contextId;
	}

	public String getErrorMessage()
	{
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage)
	{
		this.errorMessage = errorMessage;
	}

	/*
	public String getAccessionNumber() {
		return accessionNumber;
	}

	public void setAccessionNumber(String accessionNumber) {
		this.accessionNumber = accessionNumber;
	}
	*/
	
}
