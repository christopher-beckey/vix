/**
 * 
 * 
 * Date Created: Feb 13, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu;

import java.util.Date;

/**
 * @author Julian Werfel
 *
 */
public class PatientTIUNote
{
	private final PatientTIUNoteURN patientTiuNoteUrn;
	private final String title;
	private final Date date;
	private final String patientName;
	private final String authorName;
	private final String authorDuz;
	private final String hospitalLocation;
	private final String signatureStatus;
	private final Date dischargeDate;
	private final int numberAssociatedImages;
	private final PatientTIUNoteURN parentPatientTiuNoteUrn;
	private String siteVixUrl;
	
	/**
	 * @param patientTiuNoteUrn
	 * @param title
	 * @param date
	 * @param patientName
	 * @param authorName
	 * @param authorDuz
	 * @param hospitalLocation
	 * @param signatureStatus
	 * @param dischargeDate
	 * @param numberAssociatedImages
	 */
	public PatientTIUNote(PatientTIUNoteURN patientTiuNoteUrn, String title,
		Date date, String patientName, String authorName, String authorDuz,
		String hospitalLocation, String signatureStatus, Date dischargeDate,
		int numberAssociatedImages, PatientTIUNoteURN parentPatientTiuNoteUrn)
	{
		super();
		this.patientTiuNoteUrn = patientTiuNoteUrn;
		this.title = title;
		this.date = date;
		this.patientName = patientName;
		this.authorName = authorName;
		this.authorDuz = authorDuz;
		this.hospitalLocation = hospitalLocation;
		this.signatureStatus = signatureStatus;
		this.dischargeDate = dischargeDate;
		this.numberAssociatedImages = numberAssociatedImages;
		this.parentPatientTiuNoteUrn = parentPatientTiuNoteUrn;
	}

	/**
	 * @return the patientTiuNoteUrn
	 */
	public PatientTIUNoteURN getPatientTiuNoteUrn()
	{
		return patientTiuNoteUrn;
	}

	/**
	 * @return the title
	 */
	public String getTitle()
	{
		return title;
	}

	/**
	 * @return the date
	 */
	public Date getDate()
	{
		return date;
	}

	/**
	 * @return the patientName
	 */
	public String getPatientName()
	{
		return patientName;
	}

	/**
	 * @return the authorName
	 */
	public String getAuthorName()
	{
		return authorName;
	}

	/**
	 * @return the authorDuz
	 */
	public String getAuthorDuz()
	{
		return authorDuz;
	}

	/**
	 * @return the hospitalLocation
	 */
	public String getHospitalLocation()
	{
		return hospitalLocation;
	}

	/**
	 * @return the signatureStatus
	 */
	public String getSignatureStatus()
	{
		return signatureStatus;
	}

	/**
	 * @return the dischargeDate
	 */
	public Date getDischargeDate()
	{
		return dischargeDate;
	}

	/**
	 * @return the numberAssociatedImages
	 */
	public int getNumberAssociatedImages()
	{
		return numberAssociatedImages;
	}

	/**
	 * @return the parentPatientTiuNoteUrn
	 */
	public PatientTIUNoteURN getParentPatientTiuNoteUrn()
	{
		return parentPatientTiuNoteUrn;
	}

	public String getSiteVixUrl() {
		return siteVixUrl;
	}

	public void setSiteVixUrl(String siteVixUrl) {
		this.siteVixUrl = siteVixUrl;
	}

}
