/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Dec 19, 2013
 * Developer: Administrator
 */
package gov.va.med.imaging.exchange.business;

import java.io.Serializable;
import java.util.Date;

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.exchange.enums.ImageFormat;

/**
 * @author Administrator
 *
 */
public class PatientPhotoIDInformation
implements Serializable
{
	private static final long serialVersionUID = 7629246002829055979L;
	
	private final ImageURN imageUrn;
	private final PatientIdentifier patientIdentifier;
	private final String patientName;
	private final Date dateCaptured;
	private final ImageFormat imageFormat;
	private final String filename;
	
	/**
	 * @param patientIdentifier
	 * @param patientName
	 * @param dateCaptured
	 * @param imageFormat
	 * @param filename
	 */
	public PatientPhotoIDInformation(ImageURN imageUrn, PatientIdentifier patientIdentifier,
		String patientName, Date dateCaptured, ImageFormat imageFormat, String filename)
	{
		super();
		this.imageUrn = imageUrn;
		this.patientIdentifier = patientIdentifier;
		this.patientName = patientName;
		this.dateCaptured = dateCaptured;
		this.imageFormat = imageFormat;
		this.filename = filename;
	}
	

	public PatientPhotoIDInformation(ImageURN imageUrn, PatientIdentifier patientIdentifier,
			String patientName, Date dateCaptured, ImageFormat imageFormat)
	{
		this(imageUrn, patientIdentifier, patientName, dateCaptured, imageFormat, null);
	}
	
	/**
	 * @return the patientIdentifier
	 */
	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}
	
	/**
	 * @return the patientName
	 */
	public String getPatientName()
	{
		return patientName;
	}
	
	/**
	 * @return the dateCaptured
	 */
	public Date getDateCaptured()
	{
		return dateCaptured;
	}

	/**
	 * @return the imageUrn
	 */
	public ImageURN getImageUrn()
	{
		return imageUrn;
	}

	/**
	 * @return the imageFormat
	 */
	public ImageFormat getImageFormat()
	{
		return imageFormat;
	}

	/**
	 * @return the filename
	 */
	public String getFilename() {
		return filename;
	}
}
