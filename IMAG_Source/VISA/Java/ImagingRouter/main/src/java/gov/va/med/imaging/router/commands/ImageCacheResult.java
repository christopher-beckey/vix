/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Dec 21, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.router.commands;

import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;

/**
 * @author Julian
 *
 */
public class ImageCacheResult
{
	private final ImageURN imageUrn;
	private final ImageFormat imageFormat;
	private final ImageQuality imageQuality;
	
	public ImageCacheResult(ImageURN imageUrn, ImageFormat imageFormat,
			ImageQuality imageQuality) 
	{
		super();
		this.imageUrn = imageUrn;
		this.imageFormat = imageFormat;
		this.imageQuality = imageQuality;
	}

	public ImageURN getImageUrn() {
		return imageUrn;
	}

	public ImageFormat getImageFormat() {
		return imageFormat;
	}

	public ImageQuality getImageQuality() {
		return imageQuality;
	}
}
