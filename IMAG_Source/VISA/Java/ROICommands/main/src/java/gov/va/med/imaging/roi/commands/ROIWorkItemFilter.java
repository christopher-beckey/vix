/**
 * 
 */
package gov.va.med.imaging.roi.commands;

import gov.va.med.imaging.core.interfaces.router.CommandContext;
import gov.va.med.imaging.exchange.business.WorkItemFilter;
import gov.va.med.imaging.roi.ROIValues;

/**
 * An extension of the WorkItemFilter that sets fields specific to ROI that are always used for ROI.
 * Most importantly this sets the placeId to the siteId of the VIX which is critical to ensure the
 * VIX using this filter only finds items for the specified site
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ROIWorkItemFilter 
extends WorkItemFilter
{
	
	public ROIWorkItemFilter()
	{
		// CommandContext is null when a command is created
		this.setType(ROIValues.ROI_WORKITEM_TYPE);
		this.setSubtype(ROIValues.ROI_WORKITEM_SUBTYPE);
	}
	
	public void setSiteId(CommandContext commandContext)
	{
		String siteId = 
				commandContext.getLocalSite().getArtifactSource().createRoutingToken().getRepositoryUniqueId();
		this.setPlaceId(siteId);
	}

}
