/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 13, 2012
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
package gov.va.med.imaging.roi.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.WorkItemTags;
import gov.va.med.imaging.roi.ROIExtendedWorkItem;
import gov.va.med.imaging.roi.ROIStudyList;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIWorkItemTag;
import gov.va.med.imaging.roi.cache.ROIMetadataCache;
import gov.va.med.imaging.router.commands.AbstractImagingCommandImpl;
import gov.va.med.imaging.storage.cache.exceptions.CacheException;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.util.List;

/**
 * @author VHAISWWERFEJ
 *
 */
public class GetROIWorkItemByGuidCommandImpl
extends AbstractImagingCommandImpl<ROIWorkItem>
{
	private static final long serialVersionUID = -626656186185865224L;
	
	private final String guid;
	private final boolean includeExtendedInformation;
	
	public GetROIWorkItemByGuidCommandImpl(String guid,
			boolean includeExtendedInformation)
	{
		this.guid = guid;
		this.includeExtendedInformation = includeExtendedInformation;
	}
	
	public GetROIWorkItemByGuidCommandImpl(String guid)
	{
		this(guid, false); 
	}

	public String getGuid()
	{
		return guid;
	}

	public boolean isIncludeExtendedInformation()
	{
		return includeExtendedInformation;
	}

	@Override
	public ROIWorkItem callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException
	{
		ROIWorkItemFilter filter = new ROIWorkItemFilter();
		filter.setSiteId(getCommandContext());
		WorkItemTags tags = new WorkItemTags();
		tags.addTag(ROIWorkItemTag.guid.getTagName(), getGuid());
		filter.setTags(tags);
		
		List<WorkItem> results = WorkListContext.getInternalRouter().getWorkItemList(filter);
		TransactionContextFactory.get().setServicedSource(getCommandContext().getLocalSite().getArtifactSource().createRoutingToken().toRoutingTokenString());
		
		if(results == null || results.size() == 0)
		{
			throw new MethodException("Got 0 work items that match guid '" + getGuid() + "'.");
		}
		if(results.size() > 1)
		{
			throw new MethodException("Got " + results.size() + " work items that match guid '" + getGuid() + "', should only be 1.");
		}
		
		WorkItem workItem = results.get(0);
		ROIWorkItem roiWorkItem = new ROIWorkItem(workItem);
		
		if(isIncludeExtendedInformation())
		{
			try
			{
				ROIStudyList roiStudyList = ROIMetadataCache.getROIStudyList(getCommandContext(), 
						roiWorkItem.getPatientIdentifier(), guid);
				return new ROIExtendedWorkItem(workItem, roiStudyList);
			} 
			catch (CacheException e)
			{
                getLogger().error("CacheException reading extended information, {}", e.getMessage());
				throw new MethodException("CacheException reading extended information, " + e.getMessage());
			}
		}
		return roiWorkItem;
	}

	@Override
	public boolean equals(Object obj)
	{		
		return false;
	}

	@Override
	protected String parameterToString()
	{
		return getGuid();
	}

}
