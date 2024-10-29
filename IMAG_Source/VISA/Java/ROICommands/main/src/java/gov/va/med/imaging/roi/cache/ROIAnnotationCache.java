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
package gov.va.med.imaging.roi.cache;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.imaging.exchange.enums.ImageFormat;
import gov.va.med.imaging.exchange.enums.ImageQuality;
import gov.va.med.imaging.exchange.storage.cache.ImmutableInstance;
import gov.va.med.imaging.router.commands.provider.ImagingCommandContext;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIAnnotationCache 
extends AbstractROICache
{
	private final GlobalArtifactIdentifier gaid;
	private final ImageQuality imageQuality;
	private final ImageFormat imageFormat;
	
	public ROIAnnotationCache(ImagingCommandContext commandContext,
			GlobalArtifactIdentifier gaid, ImageQuality imageQuality, 
			ImageFormat imageFormat)
	{
		super(commandContext);
		this.gaid = gaid;
		this.imageQuality = imageQuality;
		this.imageFormat = imageFormat;
	}
	
	public static ROIAnnotationCache getInstance(ImagingCommandContext commandContext,
			GlobalArtifactIdentifier gaid, ImageQuality imageQuality, 
			ImageFormat imageFormat)
	{
		return new ROIAnnotationCache(commandContext, gaid, imageQuality, imageFormat);
	}

	public GlobalArtifactIdentifier getGaid()
	{
		return gaid;
	}

	public ImageQuality getImageQuality()
	{
		return imageQuality;
	}

	public ImageFormat getImageFormat()
	{
		return imageFormat;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.roi.cache.AbstractROICache#getCacheItemName()
	 */
	@Override
	protected String getCacheItemName()
	{
		return "ROI Annotation";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.roi.cache.AbstractROICache#getCacheItemDescription()
	 */
	@Override
	protected String getCacheItemDescription()
	{
		return "image [" + gaid.toString() + "], with format [" + getImageFormat().name() + "].";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.roi.cache.AbstractROICache#createCacheItem()
	 */
	@Override
	protected ImmutableInstance createCacheItem() 
	throws CacheException
	{
		return commandContext.getIntraEnterpriseCacheCache().createAnnotatedImage(
				getGaid(), getImageQuality(), getImageFormat());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.roi.cache.AbstractROICache#getItemFromCache()
	 */
	@Override
	protected ImmutableInstance getItemFromCache() 
	throws CacheException
	{
		return commandContext.getIntraEnterpriseCacheCache().getAnnotatedImage(
				getGaid(), getImageQuality(), getImageFormat());
	}

}
