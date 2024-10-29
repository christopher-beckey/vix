/**
 * 
 * 
 * Date Created: Feb 13, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.rest.types;

import java.util.Date;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="patientNote")
@XmlType(propOrder = {"patientTIUNoteUrn", "title", "date", "patientName", "authorName", "authorDuz", "hospitalLocation", "signatureStatus",
					  "dischargeDate", "numberAssociatedImages", "parentPatientTIUNoteUrn", "siteVixUrl", "imageUrn"})
public class TIUPatientNoteType
{
	private String patientTIUNoteUrn;
	private String title;
	private Date date;
	private String patientName;
	private String authorName;
	private String authorDuz;
	private String hospitalLocation;
	private String signatureStatus;
	private Date dischargeDate;
	private int numberAssociatedImages;
	private String parentPatientTIUNoteUrn;
	private String siteVixUrl;
	private String imageUrn;
	
	public TIUPatientNoteType()
	{
		super();
	}

	/**
	 * Convenient constructor
	 * 
	 * @param String						patient TIU note URN
	 * @param String						title
	 * @param Date							date
	 * @param String						patient name
	 * @param String						author name
	 * @param String						author DUZ
	 * @param String						hospital location
	 * @param String						signature status
	 * @param Date 							discharge date
	 * @param int							number associated images
	 * @param String						parent patient TIU note URN
	 * @param String						site VIX URL
	 * 
	 */
	public TIUPatientNoteType(String patientTiuNoteUrn, String title,
		Date date, String patientName, String authorName, String authorDuz,
		String hospitalLocation, String signatureStatus, Date dischargeDate,
		int numberAssociatedImages, String parentPatientTiuNoteUrn, String siteVixUrl)
	{
		super();
		this.patientTIUNoteUrn = patientTiuNoteUrn;
		this.title = title;
		this.date = date;
		this.patientName = patientName;
		this.authorName = authorName;
		this.authorDuz = authorDuz;
		this.hospitalLocation = hospitalLocation;
		this.signatureStatus = signatureStatus;
		this.dischargeDate = dischargeDate;
		this.numberAssociatedImages = numberAssociatedImages;
		this.parentPatientTIUNoteUrn = parentPatientTiuNoteUrn;
		this.siteVixUrl = siteVixUrl;
	}

	/**
	 * @return the patientTiuNoteUrn
	 */
	public String getPatientTIUNoteUrn()
	{
		return patientTIUNoteUrn;
	}

	/**
	 * @param patientTiuNoteUrn the patientTiuNoteUrn to set
	 */
	public void setPatientTIUNoteUrn(String patientTiuNoteUrn)
	{
		this.patientTIUNoteUrn = patientTiuNoteUrn;
	}

	/**
	 * @return the title
	 */
	public String getTitle()
	{
		return title;
	}

	/**
	 * @param title the title to set
	 */
	public void setTitle(String title)
	{
		this.title = title;
	}

	/**
	 * @return the date
	 */
	public Date getDate()
	{
		return date;
	}

	/**
	 * @param date the date to set
	 */
	public void setDate(Date date)
	{
		this.date = date;
	}

	/**
	 * @return the patientName
	 */
	public String getPatientName()
	{
		return patientName;
	}

	/**
	 * @param patientName the patientName to set
	 */
	public void setPatientName(String patientName)
	{
		this.patientName = patientName;
	}

	/**
	 * @return the authorName
	 */
	public String getAuthorName()
	{
		return authorName;
	}

	/**
	 * @param authorName the authorName to set
	 */
	public void setAuthorName(String authorName)
	{
		this.authorName = authorName;
	}

	/**
	 * @return the authorDuz
	 */
	public String getAuthorDuz()
	{
		return authorDuz;
	}

	/**
	 * @param authorDuz the authorDuz to set
	 */
	public void setAuthorDuz(String authorDuz)
	{
		this.authorDuz = authorDuz;
	}

	/**
	 * @return the hospitalLocation
	 */
	public String getHospitalLocation()
	{
		return hospitalLocation;
	}

	/**
	 * @param hospitalLocation the hospitalLocation to set
	 */
	public void setHospitalLocation(String hospitalLocation)
	{
		this.hospitalLocation = hospitalLocation;
	}

	/**
	 * @return the signatureStatus
	 */
	public String getSignatureStatus()
	{
		return signatureStatus;
	}

	/**
	 * @param signatureStatus the signatureStatus to set
	 */
	public void setSignatureStatus(String signatureStatus)
	{
		this.signatureStatus = signatureStatus;
	}

	/**
	 * @return the dischargeDate
	 */
	public Date getDischargeDate()
	{
		return dischargeDate;
	}

	/**
	 * @param dischargeDate the dischargeDate to set
	 */
	public void setDischargeDate(Date dischargeDate)
	{
		this.dischargeDate = dischargeDate;
	}

	/**
	 * @return the numberAssociatedImages
	 */
	public int getNumberAssociatedImages()
	{
		return numberAssociatedImages;
	}

	/**
	 * @param numberAssociatedImages the numberAssociatedImages to set
	 */
	public void setNumberAssociatedImages(int numberAssociatedImages)
	{
		this.numberAssociatedImages = numberAssociatedImages;
	}

	public String getParentPatientTIUNoteUrn() {
		return parentPatientTIUNoteUrn;
	}

	public void setParentPatientTIUNoteUrn(String parentPatientTIUNoteUrn) {
		this.parentPatientTIUNoteUrn = parentPatientTIUNoteUrn;
	}

	public String getSiteVixUrl() {
		return siteVixUrl;
	}

	public void setSiteVixUrl(String siteVixUrl) {
		this.siteVixUrl = siteVixUrl;
	}

	public String getImageUrn() {
		return imageUrn;
	}

	public void setImageUrn(String imageUrn) {
		this.imageUrn = imageUrn;
	}

	@Override
	public String toString() {
		return "TIUPatientNoteType [patientTIUNoteUrn=" + patientTIUNoteUrn + ", title=" + title + ", date=" + date
				+ ", patientName=" + patientName + ", authorName=" + authorName + ", authorDuz=" + authorDuz
				+ ", hospitalLocation=" + hospitalLocation + ", signatureStatus=" + signatureStatus + ", dischargeDate="
				+ dischargeDate + ", numberAssociatedImages=" + numberAssociatedImages + ", parentPatientTIUNoteUrn="
				+ parentPatientTIUNoteUrn + ", siteVixUrl=" + siteVixUrl + ", imageUrn=" + imageUrn + "]";
	}	

}
