/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 16, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.study.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.Arrays;
import java.util.Date;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement(name="study")
public class StudyType
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

	@Override
	public String toString() {
		return "StudyType{" +
				"studyId='" + studyId + '\'' +
				", dicomUid='" + dicomUid + '\'' +
				", description='" + description + '\'' +
				", procedureDate=" + procedureDate +
				", procedureDescription='" + procedureDescription + '\'' +
				", patientId='" + patientId + '\'' +
				", patientName='" + patientName + '\'' +
				", siteNumber='" + siteNumber + '\'' +
				", siteName='" + siteName + '\'' +
				", siteAbbreviation='" + siteAbbreviation + '\'' +
				", imageCount=" + imageCount +
				", specialtyDescription='" + specialtyDescription + '\'' +
				", noteTitle='" + noteTitle + '\'' +
				", imagePackage='" + imagePackage + '\'' +
				", imageType='" + imageType + '\'' +
				", event='" + event + '\'' +
				", origin='" + origin + '\'' +
				", studyPackage='" + studyPackage + '\'' +
				", studyClass='" + studyClass + '\'' +
				", studyType='" + studyType + '\'' +
				", captureDate='" + captureDate + '\'' +
				", capturedBy='" + capturedBy + '\'' +
				", firstImageId='" + firstImageId + '\'' +
				", awivParameters='" + awivParameters + '\'' +
				", firstImage=" + firstImage +
				", studyModalities=" + Arrays.toString(studyModalities) +
				", studyStatus=" + studyStatus +
				", studyViewStatus=" + studyViewStatus +
				", sensitive=" + sensitive +
				", documentDate=" + documentDate +
				", cptCode='" + cptCode + '\'' +
				", studyImagesHaveAnnotations=" + studyImagesHaveAnnotations +
				", studyHasImageGroup=" + studyHasImageGroup +
				", studyCanHaveReport=" + studyCanHaveReport +
				", numberOfDicomImages=" + numberOfDicomImages +
				", numberOfNonDicomImages=" + numberOfNonDicomImages +
				", numberOfSeries=" + numberOfSeries +
				", accessionNumber='" + accessionNumber + '\'' +
				", radiologyReport='" + radiologyReport + '\'' +
				'}';
	}

	private String firstImageId;
    private String awivParameters;

    private StudyImageType firstImage;
    private String [] studyModalities;
    
    private StudyObjectStatusType studyStatus = StudyObjectStatusType.NO_STATUS;
	private StudyObjectStatusType studyViewStatus = StudyObjectStatusType.NO_STATUS;
	private boolean sensitive = false;
	private Date documentDate = null;
	private String cptCode;
	private boolean studyImagesHaveAnnotations;
	private boolean studyHasImageGroup; // indicator to determine if study images should be requested 
	private boolean studyCanHaveReport; // indicator to determine if the study can have a report and it can be requested
	private int numberOfDicomImages;
	private int numberOfNonDicomImages;
	private int numberOfSeries;
	private String accessionNumber;
	
	private String radiologyReport = null;
	
	public StudyType()
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

	public StudyImageType getFirstImage()
	{
		return firstImage;
	}

	public void setFirstImage(StudyImageType firstImage)
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

	public StudyObjectStatusType getStudyStatus()
	{
		return studyStatus;
	}

	public void setStudyStatus(StudyObjectStatusType studyStatus)
	{
		this.studyStatus = studyStatus;
	}

	public StudyObjectStatusType getStudyViewStatus()
	{
		return studyViewStatus;
	}

	public void setStudyViewStatus(StudyObjectStatusType studyViewStatus)
	{
		this.studyViewStatus = studyViewStatus;
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

	public String getCptCode()
	{
		return cptCode;
	}

	public void setCptCode(String cptCode)
	{
		this.cptCode = cptCode;
	}

	public boolean isStudyImagesHaveAnnotations()
	{
		return studyImagesHaveAnnotations;
	}

	public void setStudyImagesHaveAnnotations(boolean studyImagesHaveAnnotations)
	{
		this.studyImagesHaveAnnotations = studyImagesHaveAnnotations;
	}

	public String getAwivParameters()
	{
		return awivParameters;
	}

	public void setAwivParameters(String awivParameters)
	{
		this.awivParameters = awivParameters;
	}

	public boolean isStudyHasImageGroup()
	{
		return studyHasImageGroup;
	}

	public void setStudyHasImageGroup(boolean studyHasImageGroup)
	{
		this.studyHasImageGroup = studyHasImageGroup;
	}

	public boolean isStudyCanHaveReport()
	{
		return studyCanHaveReport;
	}

	public void setStudyCanHaveReport(boolean studyCanHaveReport)
	{
		this.studyCanHaveReport = studyCanHaveReport;
	}

	public int getNumberOfDicomImages() {
		return numberOfDicomImages;
	}

	public void setNumberOfDicomImages(int numberOfDicomImages) {
		this.numberOfDicomImages = numberOfDicomImages;
	}

	public int getNumberOfNonDicomImages() {
		return numberOfNonDicomImages;
	}

	public void setNumberOfNonDicomImages(int numberOfNonDicomImages) {
		this.numberOfNonDicomImages = numberOfNonDicomImages;
	}

	public int getNumberOfSeries() {
		return numberOfSeries;
	}

	public void setNumberOfSeries(int numberOfSeries) {
		this.numberOfSeries = numberOfSeries;
	}

	public String getAccessionNumber() {
		return accessionNumber;
	}

	public void setAccessionNumber(String accessionNumber) {
		this.accessionNumber = accessionNumber;
	}

	public String getRadiologyReport() {
		return radiologyReport;
	}

	public void setRadiologyReport(String radiologyReport) {
		this.radiologyReport = radiologyReport;
	}
	
}
