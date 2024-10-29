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

import java.util.Date;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement
public class StudyImageType
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
    private boolean imageHasAnnotations;
	// if the image is associated with a progress note, indicates if it is resulted
	private String associatedNoteResulted;
	
	private StudyObjectStatusType imageStatus = StudyObjectStatusType.NO_STATUS;
	private StudyObjectStatusType imageViewStatus = StudyObjectStatusType.NO_STATUS;
	private boolean sensitive = false;
	private Date documentDate = null;
	private Date captureDate = null;
	private boolean dicom;
	
    
    public StudyImageType()
    {
    	super();
    }

	public String getImageId() {
		return imageId;
	}

	public void setImageId(String imageId) {
		this.imageId = imageId;
	}

	@XmlElement(nillable=true)
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

	public boolean isImageHasAnnotations()
	{
		return imageHasAnnotations;
	}

	public void setImageHasAnnotations(boolean imageHasAnnotations)
	{
		this.imageHasAnnotations = imageHasAnnotations;
	}

	public String getAssociatedNoteResulted()
	{
		return associatedNoteResulted;
	}

	public void setAssociatedNoteResulted(String associatedNoteResulted)
	{
		this.associatedNoteResulted = associatedNoteResulted;
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

	public StudyObjectStatusType getImageStatus()
	{
		return imageStatus;
	}

	public void setImageStatus(StudyObjectStatusType imageStatus)
	{
		this.imageStatus = imageStatus;
	}

	public StudyObjectStatusType getImageViewStatus()
	{
		return imageViewStatus;
	}

	public void setImageViewStatus(StudyObjectStatusType imageViewStatus)
	{
		this.imageViewStatus = imageViewStatus;
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

	public boolean isDicom() {
		return dicom;
	}

	public void setDicom(boolean dicom) {
		this.dicom = dicom;
	}
}
