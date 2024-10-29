package gov.va.med.imaging.viewerservices.common.webservices.rest.type;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="image")
public class PreCacheNotificationImageType 
implements Serializable{

	private static final long serialVersionUID = 1L;
	private String description = null;
	private String diagnosticImageUri = null;
	private String imageId = null;
	private String imageType = null;
	
	public PreCacheNotificationImageType() {

	}

	/**
	 * @param description the description to set
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	public String getDescription() {
		return description;
	}

	/**
	 * @param diagnosticImageUri the diagnosticImageUri to set
	 */
	public void setDiagnosticImageUri(String diagnosticImageUri) {
		this.diagnosticImageUri = diagnosticImageUri;
	}

	public String getDiagnosticImageUri() {
		return diagnosticImageUri;
	}

	/**
	 * @param imageId the imageId to set
	 */
	public void setImageId(String imageId) {
		this.imageId = imageId;
	}

	public String getImageId() {
		return imageId;
	}

	/**
	 * @param imageType the imageType to set
	 */
	public void setImageType(String imageType) {
		this.imageType = imageType;
	}
	
	public String getImageType() {
		return imageType;
	}
	

}
