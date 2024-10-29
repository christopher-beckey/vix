/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 9, 2012
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

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.exchange.storage.cache.VASourcedCache;
import gov.va.med.imaging.roi.ROIStudyList;
import gov.va.med.imaging.router.commands.provider.ImagingCommandContext;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIMetadataCache
{
	
	public static void cacheROIRequest(ImagingCommandContext commandContext, PatientIdentifier patientIdentifier, 
			String guid, ROIStudyList roiStudyList)
	throws CacheException
	{		
		ROIVASourcedCache roiCache = getRoiVaSourcedCache(commandContext);
		roiCache.createROIStudyList(patientIdentifier, guid, roiStudyList);		
	}
	
	private static ROIVASourcedCache getRoiVaSourcedCache(ImagingCommandContext commandContext)
	{
		VASourcedCache vaSourcedCache = commandContext.getIntraEnterpriseCacheCache(); 
		ROIVASourcedCache roiCache = ROIVASourcedCacheDecorator.getInstance(vaSourcedCache);
		return roiCache;
	}
	
	public static ROIStudyList getROIStudyList(ImagingCommandContext commandContext, 
			PatientIdentifier patientIdentifier, String guid)
	throws CacheException
	{
		ROIVASourcedCache roiCache = getRoiVaSourcedCache(commandContext);
		return roiCache.getROIStudyList(patientIdentifier, guid);	
	}

}
