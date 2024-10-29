/**
 * 
 */
package gov.va.med.imaging.core.router.commands.datasource;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.ViewerServicesDataSourceSpi;
import gov.va.med.imaging.exchange.business.SiteConnection;
import gov.va.med.imaging.exchange.business.WorkItem;

/**
 * @author William Peterson
 *
 */
public class SendViewerPreCacheWorkItemsFromDataSourceCommandImpl 
extends AbstractDataSourceCommandImpl<Boolean, ViewerServicesDataSourceSpi> {

	private static final long serialVersionUID = 1L;
	private RoutingToken routingToken = null;
	private SiteConnection siteConnection = null;
	private List<WorkItem> workItems = null;
	private static final String SPI_METHOD_NAME = "sendViewerPreCacheWorkItems";
	
	
	/**
	 * 
	 * @param routingToken
	 * @param searchName
	 */
	public SendViewerPreCacheWorkItemsFromDataSourceCommandImpl(RoutingToken routingToken, SiteConnection siteConnection,
			List<WorkItem> items)
	{
		this.routingToken = routingToken;
		this.siteConnection = siteConnection;
		this.workItems = items;
	}

	
	@Override
	public RoutingToken getRoutingToken() {
		return this.routingToken;
	}
	
	public SiteConnection getSiteConnection() {
		return siteConnection;
	}

	public List<WorkItem> getWorkItems() {
		return workItems;
	}

	@Override
	protected Boolean getCommandResult(ViewerServicesDataSourceSpi spi)
			throws ConnectionException, MethodException {
		return spi.sendViewerPreCacheWorkItems(getRoutingToken(), getSiteConnection(), getWorkItems());
	}


	@Override
	protected Class<ViewerServicesDataSourceSpi> getSpiClass() {
		return ViewerServicesDataSourceSpi.class;
	}

	@Override
	protected String getSpiMethodName() {
		return SPI_METHOD_NAME;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{RoutingToken.class, SiteConnection.class, List.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getRoutingToken(), getSiteConnection(), getWorkItems()};
	}

	@Override
	protected String getSiteNumber() {
		return getRoutingToken().getRepositoryUniqueId();
	}







	
	

}
