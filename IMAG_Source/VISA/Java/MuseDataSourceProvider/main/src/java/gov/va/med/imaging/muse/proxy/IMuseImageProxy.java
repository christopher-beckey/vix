/**
 * 
 */
package gov.va.med.imaging.muse.proxy;

import gov.va.med.imaging.MuseImageURN;
import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageConversionException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNearLineException;
import gov.va.med.imaging.core.interfaces.exceptions.ImageNotFoundException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.exchange.business.ImageFormatQualityList;

/**
 * @author William Peterson
 *
 */
public interface IMuseImageProxy {

	
	public SizedInputStream getImage(MuseImageURN imageUrn, ImageFormatQualityList requestFormatQualityList) 
			throws ImageNearLineException, ImageNotFoundException,
			SecurityCredentialsExpiredException, ImageConversionException, MethodException, ConnectionException;

}
