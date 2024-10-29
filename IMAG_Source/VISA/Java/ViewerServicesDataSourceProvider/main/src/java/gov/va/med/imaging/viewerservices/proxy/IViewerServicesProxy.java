package gov.va.med.imaging.viewerservices.proxy;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.viewerservices.exceptions.ViewerServicesConnectionException;
import gov.va.med.imaging.viewerservices.exceptions.ViewerServicesMethodException;

public interface IViewerServicesProxy {

	public boolean sendViewerPreCacheNotifications(RoutingToken routingToken, SiteConnection connection, 
			List<WorkItem> workItems) throws ViewerServicesMethodException, ViewerServicesConnectionException;

}
