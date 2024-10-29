/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 26, 2012
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
package gov.va.med.imaging.roi;

import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;

import java.io.Serializable;

import com.thoughtworks.xstream.XStream;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIImage
implements Serializable
{
	private static final long serialVersionUID = -4993522299648864344L;
	
	private String imageUrn;
	private boolean hasAnnotations;
	private boolean imageLoaded;
	private boolean annotationsBurned;
	private ImageFormat cachedImageFormat;
	private ImageQuality cachedImageQuality;
	private String imageError;
	
	public ROIImage()
	{
		super();
		imageLoaded = false;
		annotationsBurned = false;
		cachedImageFormat = null;
		cachedImageQuality = null;
		imageError = null;
	}

	public ROIImage(String imageUrn, boolean hasAnnotations)
	{
		this();
		this.imageUrn = imageUrn;
		this.hasAnnotations = hasAnnotations;
	}

	public String getImageUrn()
	{
		return imageUrn;
	}

	public void setImageUrn(String imageUrn)
	{
		this.imageUrn = imageUrn;
	}

	public boolean isHasAnnotations()
	{
		return hasAnnotations;
	}

	public void setHasAnnotations(boolean hasAnnotations)
	{
		this.hasAnnotations = hasAnnotations;
	}
	
	private static XStream getXStream()
	{
		XStream xstream = new XStream();
		xstream.aliasField("urn", ROIImage.class, "imageUrn");
		xstream.aliasField("ha", ROIImage.class, "hasAnnotations"); // hasAnnotations
		xstream.aliasField("il", ROIImage.class, "imageLoaded"); // hasAnnotations
		xstream.aliasField("ab", ROIImage.class, "annotationsBurned"); // hasAnnotations
		xstream.alias("img", ROIImage.class);
		return xstream;
	}
	
	public static String toXml(ROIImage [] images)
	{
		XStream xstream = getXStream();
		return xstream.toXML(images);
	}
	
	public static ROIImage [] fromXml(String xml)
	{
		XStream xstream = getXStream();
		return (ROIImage[])xstream.fromXML(xml);
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

	public ImageFormat getCachedImageFormat()
	{
		return cachedImageFormat;
	}

	public void setCachedImageFormat(ImageFormat cachedImageFormat)
	{
		this.cachedImageFormat = cachedImageFormat;
	}

	public ImageQuality getCachedImageQuality()
	{
		return cachedImageQuality;
	}

	public void setCachedImageQuality(ImageQuality cachedImageQuality)
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
