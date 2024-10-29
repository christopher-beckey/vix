package gov.va.med.imaging.dicom.ecia.scu.dto;

import java.io.Serializable;

/**
 * Wrapper object for a Series data from source.
 * Closely matched with VA InstanceType class but could
 * be changed to add more data.  If so, re-generate or add
 * to the three generated methods as well.
 * 
 * DO NOT remove any existing fields.  Will break.
 * 
 * @author Quoc Nguyen
 *
 */
public class ImageDTO implements Serializable
{
	/**
	* Determines if a de-serialized file is compatible with this class.
	* Included here as a reminder of its importance.  DO NOT CHANGE.
	*/
	private static final long serialVersionUID = 3336471155622776147L;

	/**  
	 * Default constructor
	 */
	public ImageDTO () 
	{
		super();
	}
	
	/**  
	 * Convenient constructor
	 */
	public ImageDTO (String sopInstanceUID, Integer instanceNumber, String seriesInstanceUID) 
	{
		super();
		setSopInstanceUID(sopInstanceUID);
		setInstanceNumber(instanceNumber);
		setSeriesInstanceUID(seriesInstanceUID);
	}
	
	public ImageDTO (String sopInstanceUID, Integer instanceNumber, String seriesInstanceUID, String sopClassUID) {
		super();
		setSopInstanceUID(sopInstanceUID);
		setInstanceNumber(instanceNumber);
		setSeriesInstanceUID(seriesInstanceUID);
		setSopClassUID(sopClassUID);
	}
	
	private String sopInstanceUID;
	private Integer instanceNumber;
	private String seriesInstanceUID;
	private String sopClassUID;

//++++++++++++++++ Getters +++++++++++++++++++++++++
	
	public String getSopInstanceUID() {
		return sopInstanceUID;
	}
	public Integer getInstanceNumber() {
		return instanceNumber;
	}
	public String getSeriesInstanceUID() {
		return seriesInstanceUID;
	}
	public String getSopClassUID() {
		return sopClassUID;
	}
	
//++++++++++++++++ Setters +++++++++++++++++++++++++
	
	public void setSopInstanceUID(String sopInstanceUID) {
		this.sopInstanceUID = sopInstanceUID;
	}
	public void setInstanceNumber(Integer instanceNumber) {
		this.instanceNumber = instanceNumber;
	}
	public void setSeriesInstanceUID(String seriesInstanceUID) {
		this.seriesInstanceUID = seriesInstanceUID;
	}
	public void setSopClassUID(String sopClassUID) {
		this.sopClassUID = sopClassUID;
	}
	
//++++++++++++++++ Eclipse generated codes +++++++++++++++++++++++++
	
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((instanceNumber == null) ? 0 : instanceNumber.hashCode());
		result = prime * result + ((seriesInstanceUID == null) ? 0 : seriesInstanceUID.hashCode());
		result = prime * result + ((sopInstanceUID == null) ? 0 : sopInstanceUID.hashCode());
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
		ImageDTO other = (ImageDTO) obj;
		if (instanceNumber == null) {
			if (other.instanceNumber != null)
				return false;
		} else if (!instanceNumber.equals(other.instanceNumber))
			return false;
		if (seriesInstanceUID == null) {
			if (other.seriesInstanceUID != null)
				return false;
		} else if (!seriesInstanceUID.equals(other.seriesInstanceUID))
			return false;
		if (sopInstanceUID == null) {
			if (other.sopInstanceUID != null)
				return false;
		} else if (!sopInstanceUID.equals(other.sopInstanceUID))
			return false;
		return true;
	}
	
	@Override
	public String toString() {
		return "ImageDTO [sopInstanceUID=" + sopInstanceUID + ", instanceNumber="
				+ instanceNumber + ", seriesInstanceUID=" + seriesInstanceUID + "]";
	}
}