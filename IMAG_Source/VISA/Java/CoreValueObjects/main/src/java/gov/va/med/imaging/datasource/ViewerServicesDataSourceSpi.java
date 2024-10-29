/**
 * 
 */
package gov.va.med.imaging.datasource;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.business.WorkItem;

/**
 * @author William Peterson
 *
 */
public interface ViewerServicesDataSourceSpi 
extends VersionableDataSourceSpi {

	public boolean sendViewerPreCacheWorkItems(RoutingToken routinToken, SiteConnection connection, 
			List<WorkItem> workItems) throws MethodException, ConnectionException;
}
