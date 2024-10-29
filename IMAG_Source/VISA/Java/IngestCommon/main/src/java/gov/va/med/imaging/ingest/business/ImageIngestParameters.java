/**
 * 
 * 
 * Date Created: Dec 5, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.ingest.business;

import java.util.Date;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.exchange.enums.ImageFormat;

/**
 * @author Administrator
 *
 */
public class ImageIngestParameters
{
	private final PatientIdentifier patientIdentifier;
	private final Date procedureDate;
	private ImageFormat imageFormat;
	private final String procedure;
	private final String shortDescription;
	private final Date captureDate;
	
	private final String trackingNumber;
	private final String acquisitionDevice;
	private final StudyURN studyUrn;
	private final Date documentDate;
	private final String originIndex;
	private final String typeIndex;
	private final String specialtyIndex;
	private final String procedureEventIndex;
	private String originalFilename;
	private String mimeType;
	private final String captureUser;
	private final TIUNoteSignatureOption signatureOption;

	private final String imageDescription;
	
	/**
	 * @param patientIdentifier
	 * @param procedureDate
	 * @param imageFormat
	 * @param procedure
	 * @param shortDescription
	 * @param captureDate
	 * @param originIndex
	 */
	public ImageIngestParameters(PatientIdentifier patientIdentifier,
								 Date procedureDate, ImageFormat imageFormat, String procedure,
								 String shortDescription, Date captureDate, String trackingNumber,
								 String acquisitionDevice, Date documentDate, String originIndex,
								 String typeIndex, String specialtyIndex, String procedureEventIndex,
								 StudyURN studyUrn, String captureUser, String originalFilename, String mimeType,
								 String imageDescription, TIUNoteSignatureOption signatureOption)
	{
		super();
		this.patientIdentifier = patientIdentifier;
		this.procedureDate = procedureDate;
		this.imageFormat = imageFormat;
		this.procedure = procedure;
		this.shortDescription = shortDescription;
		this.captureDate = captureDate;		
		this.trackingNumber = trackingNumber;
		this.acquisitionDevice = acquisitionDevice;
		this.documentDate = documentDate;
		this.originIndex = originIndex;
		this.typeIndex = typeIndex;
		this.specialtyIndex = specialtyIndex;
		this.procedureEventIndex = procedureEventIndex;
		this.studyUrn = studyUrn;
		this.captureUser = captureUser;
		this.signatureOption = signatureOption;
		this.originalFilename = originalFilename;
		this.mimeType = mimeType;
		this.imageDescription = imageDescription;
	}
	
	public ImageIngestParameters(PatientIdentifier patientIdentifier,
								 Date procedureDate, ImageFormat imageFormat, String procedure,
								 String shortDescription, Date captureDate, String trackingNumber,
								 String acquisitionDevice, Date documentDate, String originIndex,
								 String typeIndex, String specialtyIndex, String procedureEventIndex)
	{
		this(patientIdentifier, procedureDate, imageFormat,
			procedure, shortDescription, captureDate,
			trackingNumber, acquisitionDevice, documentDate, 
			originIndex, typeIndex, specialtyIndex, procedureEventIndex,
			null, null, null, null, null, TIUNoteSignatureOption.EF);
	}

	/**
	 * @return the patientIdentifier
	 */
	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}

	/**
	 * @return the procedureDate
	 */
	public Date getProcedureDate()
	{
		return procedureDate;
	}

	/**
	 * @return the procedure
	 */
	public String getProcedure()
	{
		return procedure;
	}

	/**
	 * @return the description
	 */
	public String getShortDescription()
	{
		return shortDescription;
	}

	/**
	 * @return the captureDate
	 */
	public Date getCaptureDate()
	{
		return captureDate;
	}

	/**
	 * @return the trackingNumber
	 */
	public String getTrackingNumber()
	{
		return trackingNumber;
	}

	/**
	 * @return the acquisitionDevice
	 */
	public String getAcquisitionDevice()
	{
		return acquisitionDevice;
	}

	/**
	 * @return the studyUrn
	 */
	public StudyURN getStudyUrn()
	{
		return studyUrn;
	}

	/**
	 * @return the documentDate
	 */
	public Date getDocumentDate()
	{
		return documentDate;
	}

	/**
	 * @return the originIndex
	 */
	public String getOriginIndex()
	{
		return originIndex;
	}

	/**
	 * @return the typeIndex
	 */
	public String getTypeIndex()
	{
		return typeIndex;
	}

	/**
	 * @return the specialtyIndex
	 */
	public String getSpecialtyIndex()
	{
		return specialtyIndex;
	}

	/**
	 * @return the procedureEventIndex
	 */
	public String getProcedureEventIndex()
	{
		return procedureEventIndex;
	}

	public String getCaptureUser() {
		return captureUser;
	}

	public TIUNoteSignatureOption getSignatureOption() {
		return signatureOption;
	}

	public ImageFormat getImageFormat() {
		return imageFormat;
	}

	public void setImageFormat(ImageFormat imageFormat) {
		this.imageFormat = imageFormat;
	}

	public String getOriginalFilename() {
		return originalFilename;
	}

	public void setOriginalFilename(String originalFilename) {
		this.originalFilename = originalFilename;
	}

	public String getMimeType() {
		return mimeType;
	}

	public void setMimeType(String mimeType) {
		this.mimeType = mimeType;
	}

	public String getImageDescription() {
		return imageDescription;
	}

	@Override
	public String toString() {
		return "ImageIngestParameters [patientIdentifier=" + patientIdentifier + ", procedureDate=" + procedureDate
				+ ", imageFormat=" + imageFormat + ", procedure=" + procedure + ", shortDescription=" + shortDescription
				+ ", captureDate=" + captureDate + ", trackingNumber=" + trackingNumber + ", acquisitionDevice="
				+ acquisitionDevice + ", studyUrn=" + studyUrn + ", documentDate=" + documentDate + ", originIndex="
				+ originIndex + ", typeIndex=" + typeIndex + ", specialtyIndex=" + specialtyIndex
				+ ", procedureEventIndex=" + procedureEventIndex + ", originalFilename=" + originalFilename
				+ ", mimeType=" + mimeType + ", captureUser=" + captureUser + ", signatureOption=" + signatureOption
				+ ", imageDescription=" + imageDescription + "]";
	}
	
	
}
