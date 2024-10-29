package gov.va.med.imaging.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.StudyGraphDataSourceSpi;
import gov.va.med.imaging.exchange.business.StoredStudyFilter;

public class GetStoredFiltersCommandImpl 
extends AbstractDataSourceCommandImpl<List<StoredStudyFilter>, StudyGraphDataSourceSpi>
{

	/**
	 * 
	 */
	private static final long serialVersionUID = 8363350567525201387L;
	
	private RoutingToken routingToken;
	
	public GetStoredFiltersCommandImpl(RoutingToken routingToken) 
	{
		super();
		this.routingToken = routingToken;
	}

	public void setRoutingToken(RoutingToken routingToken) {
		this.routingToken = routingToken;
	}

	@Override
	public RoutingToken getRoutingToken() {
		return routingToken;
	}

	@Override
	protected Class<StudyGraphDataSourceSpi> getSpiClass() {
		return StudyGraphDataSourceSpi.class;
	}

	@Override
	protected String getSpiMethodName() {
		return "getStoredFilters";
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{RoutingToken.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getRoutingToken()};
	}

	@Override
	protected String getSiteNumber() {
		return getRoutingToken().getRepositoryUniqueId();
	}

	@Override
	protected List<StoredStudyFilter> getCommandResult(StudyGraphDataSourceSpi spi)
	throws ConnectionException, MethodException 
	{
		return spi.getStoredFilters(getRoutingToken());
	}

}
