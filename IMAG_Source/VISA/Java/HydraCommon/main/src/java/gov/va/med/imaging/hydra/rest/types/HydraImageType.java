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
@XmlRootElement(name="image")
public class HydraImageType
{
	private String imageId;
	private String description;
	private Date procedureDate;
	private String procedure;
    
	private String imageClass;    
    
	private String imageUid; // DICOM Image UID
	private String imageNumber; // DICOM Image sequence number
	
	public HydraImageType()
	{
		super();
	}
	
	public HydraImageType(String imageId, String description,
			Date procedureDate, String procedure, String imageClass,
			String imageUid, String imageNumber) 
	{
		super();
		this.imageId = imageId;
		this.description = description;
		this.procedureDate = procedureDate;
		this.procedure = procedure;
		this.imageClass = imageClass;
		this.imageUid = imageUid;
		this.imageNumber = imageNumber;
	}

	public String getImageId() {
		return imageId;
	}

	public void setImageId(String imageId) {
		this.imageId = imageId;
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

	public String getProcedure() {
		return procedure;
	}

	public void setProcedure(String procedure) {
		this.procedure = procedure;
	}

	public String getImageClass() {
		return imageClass;
	}

	public void setImageClass(String imageClass) {
		this.imageClass = imageClass;
	}

	public String getImageUid() {
		return imageUid;
	}

	public void setImageUid(String imageUid) {
		this.imageUid = imageUid;
	}

	public String getImageNumber() {
		return imageNumber;
	}

	public void setImageNumber(String imageNumber) {
		this.imageNumber = imageNumber;
	}
}
