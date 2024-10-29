/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Apr 23, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.exchange.business;

import java.io.InputStream;

/**
 * @author Julian
 *
 */
public class PatientPhotoID
{
	private final InputStream inputStream;
	private final PatientPhotoIDInformation photoIdInformation;
	
	/**
	 * @param inputStream
	 * @param photoIdInformation
	 */
	public PatientPhotoID(InputStream inputStream,
		PatientPhotoIDInformation photoIdInformation)
	{
		super();
		this.inputStream = inputStream;
		this.photoIdInformation = photoIdInformation;
	}
	
	/**
	 * @return the inputStream
	 */
	public InputStream getInputStream()
	{
		return inputStream;
	}
	
	/**
	 * @return the photoIdInformation
	 */
	public PatientPhotoIDInformation getPhotoIdInformation()
	{
		return photoIdInformation;
	}
}
