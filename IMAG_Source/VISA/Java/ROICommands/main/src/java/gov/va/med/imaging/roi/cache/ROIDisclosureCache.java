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

import gov.va.med.PatientIdentifier;
import gov.va.med.imaging.GUID;
import gov.va.med.imaging.exchange.storage.cache.ImmutableInstance;
import gov.va.med.imaging.router.commands.provider.ImagingCommandContext;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIDisclosureCache
extends AbstractROICache
{
	private final PatientIdentifier patientIdentifier;
	private final GUID guid;
	
	public ROIDisclosureCache(ImagingCommandContext commandContext, PatientIdentifier patientIdentifier, GUID guid)
	{
		super(commandContext);
		this.patientIdentifier = patientIdentifier;
		this.guid = guid;
	}
	
	public static ROIDisclosureCache getInstance(ImagingCommandContext commandContext, 
			PatientIdentifier patientIdentifier, GUID guid)
	{
		return new ROIDisclosureCache(commandContext, patientIdentifier, guid);
	}

	public PatientIdentifier getPatientIdentifier()
	{
		return patientIdentifier;
	}

	public GUID getGuid()
	{
		return guid;
	}

	@Override
	protected String getCacheItemName()
	{
		return "ROI Disclosure";
	}

	@Override
	protected String getCacheItemDescription()
	{
		return "patient [" + getPatientIdentifier() + "], with GUID [" + guid.toLongString() + "].";
	}


	@Override
	protected ImmutableInstance createCacheItem()
	throws CacheException
	{
		return commandContext.getIntraEnterpriseCacheCache().createROIRelease(getPatientIdentifier(), guid);
	}

	@Override
	protected ImmutableInstance getItemFromCache() 
	throws CacheException
	{
		 return commandContext.getIntraEnterpriseCacheCache().getROIRelease(getPatientIdentifier(), guid);
	}
}
