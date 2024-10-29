/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Dec 19, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.vistaobjects;

import java.util.Date;

/**
 * @author Administrator
 *
 */
public class VistaPatientPhotoIDInformation
{
	private final String patientName;
	private final String filename;
	private final Date dateCaptured;
	private final String imageIen;
	
	/**
	 * @param patientIdentifier
	 * @param patientName
	 * @param filename
	 * @param dateCaptured
	 */
	public VistaPatientPhotoIDInformation(String patientName, String filename, Date dateCaptured, String imageIen)
	{
		super();
		this.patientName = patientName;
		this.filename = filename;
		this.dateCaptured = dateCaptured;
		this.imageIen = imageIen;
	}
	
	/**
	 * @return the patientName
	 */
	public String getPatientName()
	{
		return patientName;
	}
	/**
	 * @return the filename
	 */
	public String getFilename()
	{
		return filename;
	}
	/**
	 * @return the dateCaptured
	 */
	public Date getDateCaptured()
	{
		return dateCaptured;
	}

	/**
	 * @return the imageIen
	 */
	public String getImageIen()
	{
		return imageIen;
	}
	
	
}
