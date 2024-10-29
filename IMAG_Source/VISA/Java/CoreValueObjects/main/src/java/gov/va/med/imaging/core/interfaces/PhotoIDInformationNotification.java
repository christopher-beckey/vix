/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Apr 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.core.interfaces;

import gov.va.med.imaging.exchange.business.PatientPhotoIDInformation;


/**
 * @author Julian
 *
 */
public interface PhotoIDInformationNotification
{
	
	public void photoIDInformation(PatientPhotoIDInformation photoIdInformation);

}
