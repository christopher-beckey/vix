/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 4, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.roi.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement
public class ROIImageType
{
	private String imageId;
	private boolean hasAnnotations;
	private boolean imageLoaded;
	private boolean annotationsBurned;
	private String cachedImageFormat;
	private String cachedImageQuality;
	private String imageError;
	
	public ROIImageType()
	{
		super();
	}

	public String getImageId()
	{
		return imageId;
	}

	public void setImageId(String imageId)
	{
		this.imageId = imageId;
	}

	public boolean isHasAnnotations()
	{
		return hasAnnotations;
	}

	public void setHasAnnotations(boolean hasAnnotations)
	{
		this.hasAnnotations = hasAnnotations;
	}

	public boolean isImageLoaded()
	{
		return imageLoaded;
	}

	public void setImageLoaded(boolean imageLoaded)
	{
		this.imageLoaded = imageLoaded;
	}

	public boolean isAnnotationsBurned()
	{
		return annotationsBurned;
	}

	public void setAnnotationsBurned(boolean annotationsBurned)
	{
		this.annotationsBurned = annotationsBurned;
	}

	public String getCachedImageFormat()
	{
		return cachedImageFormat;
	}

	public void setCachedImageFormat(String cachedImageFormat)
	{
		this.cachedImageFormat = cachedImageFormat;
	}

	public String getCachedImageQuality()
	{
		return cachedImageQuality;
	}

	public void setCachedImageQuality(String cachedImageQuality)
	{
		this.cachedImageQuality = cachedImageQuality;
	}

	public String getImageError()
	{
		return imageError;
	}

	public void setImageError(String imageError)
	{
		this.imageError = imageError;
	}
}
