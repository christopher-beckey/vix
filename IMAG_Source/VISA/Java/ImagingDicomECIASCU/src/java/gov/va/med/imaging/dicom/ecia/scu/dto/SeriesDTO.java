package gov.va.med.imaging.dicom.ecia.scu.dto;

import java.io.Serializable;
import java.util.List;

/**
 * Wrapper object for a Series data from source.
 * Closely matched with VA SeriesType class but could
 * be changed to add more data.  If so, re-generate or add
 * to the three generated methods as well.
 * 
 * DO NOT remove any existing fields.  Will break.
 * 
 * @author Quoc Nguyen
 *
 */
public class SeriesDTO implements Serializable
{
	/**
	* Determines if a de-serialized file is compatible with this class.
	* Included here as a reminder of its importance.  DO NOT CHANGE.
	*/
	private static final long serialVersionUID = 2226471155622776147L;

	/**  
	 * Default constructor
	 */
	public SeriesDTO () 
	{
		super();
	}
	
	/**  
	 * Convenient constructor
	 */
	public SeriesDTO (String seriesInstanceUID) 
	{
		super();
		setSeriesInstanceUID(seriesInstanceUID);
	}
	
	private String clinicalTrialSeriesId; // no equivalence of seriesId to studyId.  Good???
	private String seriesInstanceUID;
	private Integer seriesNumber;
	private String seriesDescription;
	private String modality;
	private int imageCount;
	private String studyInstanceUID;
	List<ImageDTO> imageDTOs;
	
//++++++++++++++++ Getters +++++++++++++++++++++++++
	
	public String getClinicalTrialSeriesId() {
		return clinicalTrialSeriesId;
	}
	public String getSeriesInstanceUID() {
		return seriesInstanceUID;
	}
	public Integer getSeriesNumber() {
		return seriesNumber;
	}
	public String getSeriesDescription() {
		return seriesDescription;
	}
	public String getModality() {
		return modality;
	}
	public int getImageCount() {
		return imageCount;
	}
	public String getStudyInstanceUID() {
		return studyInstanceUID;
	}
	public List<ImageDTO> getImageDTOs() {
		return imageDTOs;
	}
	
//++++++++++++++++ Setters +++++++++++++++++++++++++
	
	public void setClinicalTrialSeriesId(String clinicalTrialSeriesId) {
		this.clinicalTrialSeriesId = clinicalTrialSeriesId;
	}
	public void setSeriesInstanceUID(String seriesInstanceUID) {
		this.seriesInstanceUID = seriesInstanceUID;
	}
	public void setSeriesNumber(Integer seriesNumber) {
		this.seriesNumber = seriesNumber == null ? new Integer(-1) : seriesNumber;
	}
	public void setSeriesDescription(String seriesDescription) {
		this.seriesDescription = seriesDescription;
	}
	public void setModality(String modality) {
		this.modality = modality;
	}
	public void setImageCount(int imageCount) {
		this.imageCount = imageCount;
	}
	public void setStudyInstanceUID(String studyInstanceUID) {
		this.studyInstanceUID = studyInstanceUID;
	}
	public void setImageDTOs(List<ImageDTO> imageDTOs) {
		this.imageDTOs = imageDTOs;
	}
	
//++++++++++++++++ Eclipse generated codes +++++++++++++++++++++++++

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((clinicalTrialSeriesId == null) ? 0 : clinicalTrialSeriesId.hashCode());
		result = prime * result + imageCount;
		result = prime * result + ((imageDTOs == null) ? 0 : imageDTOs.hashCode());
		result = prime * result + ((modality == null) ? 0 : modality.hashCode());
		result = prime * result + ((seriesDescription == null) ? 0 : seriesDescription.hashCode());
		result = prime * result + ((seriesInstanceUID == null) ? 0 : seriesInstanceUID.hashCode());
		result = prime * result + ((seriesNumber == null) ? 0 : seriesNumber.hashCode());
		result = prime * result + ((studyInstanceUID == null) ? 0 : studyInstanceUID.hashCode());
		return result;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		SeriesDTO other = (SeriesDTO) obj;
		if (clinicalTrialSeriesId == null) {
			if (other.clinicalTrialSeriesId != null)
				return false;
		} else if (!clinicalTrialSeriesId.equals(other.clinicalTrialSeriesId))
			return false;
		if (imageCount != other.imageCount)
			return false;
		if (imageDTOs == null) {
			if (other.imageDTOs != null)
				return false;
		} else if (!imageDTOs.equals(other.imageDTOs))
			return false;
		if (modality == null) {
			if (other.modality != null)
				return false;
		} else if (!modality.equals(other.modality))
			return false;
		if (seriesDescription == null) {
			if (other.seriesDescription != null)
				return false;
		} else if (!seriesDescription.equals(other.seriesDescription))
			return false;
		if (seriesInstanceUID == null) {
			if (other.seriesInstanceUID != null)
				return false;
		} else if (!seriesInstanceUID.equals(other.seriesInstanceUID))
			return false;
		if (seriesNumber == null) {
			if (other.seriesNumber != null)
				return false;
		} else if (!seriesNumber.equals(other.seriesNumber))
			return false;
		if (studyInstanceUID == null) {
			if (other.studyInstanceUID != null)
				return false;
		} else if (!studyInstanceUID.equals(other.studyInstanceUID))
			return false;
		return true;
	}
	
	@Override
	public String toString() {
		return "SeriesDTO [clinicalTrialSeriesId=" + clinicalTrialSeriesId + ", seriesInstanceUID=" + seriesInstanceUID
				+ ", seriesNumber=" + seriesNumber + ", seriesDescription=" + seriesDescription + ", modality="
				+ modality + ", imageCount=" + imageCount + ", studyInstanceUID=" + studyInstanceUID + ", imageDTOs="
				+ imageDTOs + "]";
	}
}
