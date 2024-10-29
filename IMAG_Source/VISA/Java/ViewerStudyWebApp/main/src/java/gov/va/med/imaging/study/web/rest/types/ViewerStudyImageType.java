/**
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.rest.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;

import gov.va.med.imaging.exchange.enums.ObjectStatus;

/**
 * @author Julian
 *
 */
@XmlRootElement
public class ViewerStudyImageType
{

	private String imageId;
    private String dicomUid;
    private Integer imageNumber;
    private String dicomSequenceNumber;
    private String dicomImageNumber;
    private String imageType;
    private String thumbnailImageUri;
    private String referenceImageUri;
    private String diagnosticImageUri;
    private String imageModality;
    private String description;
    private String alternateExamNumber;
	
	private boolean sensitive = false;
	private Date documentDate = null;
	private Date captureDate = null;
	private String imageStatus;
	private String imageViewStatus;
	
    
    public ViewerStudyImageType()
    {
    	super();
    }

	public String getImageId() {
		return imageId;
	}

	public void setImageId(String imageId) {
		this.imageId = imageId;
	}

	public String getDicomUid() {
		return dicomUid;
	}

	public void setDicomUid(String dicomUid) {
		this.dicomUid = dicomUid;
	}

	public Integer getImageNumber() {
		return imageNumber;
	}

	public void setImageNumber(Integer imageNumber) {
		this.imageNumber = imageNumber;
	}

	public String getImageType() {
		return imageType;
	}

	public void setImageType(String imageType) {
		this.imageType = imageType;
	}

	public String getThumbnailImageUri()
	{
		return thumbnailImageUri;
	}

	public void setThumbnailImageUri(String thumbnailImageUri)
	{
		this.thumbnailImageUri = thumbnailImageUri;
	}

	public String getReferenceImageUri()
	{
		return referenceImageUri;
	}

	public void setReferenceImageUri(String referenceImageUri)
	{
		this.referenceImageUri = referenceImageUri;
	}

	public String getDiagnosticImageUri()
	{
		return diagnosticImageUri;
	}

	public void setDiagnosticImageUri(String diagnosticImageUri)
	{
		this.diagnosticImageUri = diagnosticImageUri;
	}

	public String getImageModality() {
		return imageModality;
	}

	public void setImageModality(String imageModality) {
		this.imageModality = imageModality;
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

	public Date getCaptureDate()
	{
		return captureDate;
	}

	public void setCaptureDate(Date captureDate)
	{
		this.captureDate = captureDate;
	}

	public String getDicomSequenceNumber()
	{
		return dicomSequenceNumber;
	}

	public void setDicomSequenceNumber(String dicomSequenceNumber)
	{
		this.dicomSequenceNumber = dicomSequenceNumber;
	}

	public String getDicomImageNumber()
	{
		return dicomImageNumber;
	}

	public void setDicomImageNumber(String dicomImageNumber)
	{
		this.dicomImageNumber = dicomImageNumber;
	}

	/**
	 * @return the description
	 */
	public String getDescription()
	{
		return description;
	}

	/**
	 * @param description the description to set
	 */
	public void setDescription(String description)
	{
		this.description = description;
	}

	public String getAlternateExamNumber() {
		return alternateExamNumber;
	}

	public void setAlternateExamNumber(String alternateExamNumber) {
		this.alternateExamNumber = alternateExamNumber;
	}

	public String getImageStatus() {
		return this.imageStatus;
	}

	public void setImageStatus(String imageStatus) {
		this.imageStatus = imageStatus;
	}

	public String getImageViewStatus() {
		return this.imageViewStatus;
	}
	
	public void setImageViewStatus(String imageViewStatus) {
		this.imageViewStatus = imageViewStatus;
	}
	
}
