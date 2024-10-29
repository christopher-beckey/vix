/**
 * 
 */
package gov.va.med.imaging.presentation.state.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.presentation.state.datasource.PresentationStateDataSourceSpi;

/**
 * @author William Peterson
 * @param <R>
 *
 */
public abstract class AbstractPresentationStateDataSourceCommandImpl<R>
extends AbstractDataSourceCommandImpl<R, PresentationStateDataSourceSpi> {
	
	private static final long serialVersionUID = -5232519266583174692L;
	private final RoutingToken routingToken;

	/**
	 * @param routingToken
	 * @param indexField
	 */
	public AbstractPresentationStateDataSourceCommandImpl(RoutingToken routingToken)
	{
		super();
		this.routingToken = routingToken;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getRoutingToken()
	 */
	@Override
	public RoutingToken getRoutingToken()
	{
		return routingToken;
	}

	@Override
	protected R postProcessResult(R result) {
		return super.postProcessResult(result);
	}

	@Override
	protected Class<PresentationStateDataSourceSpi> getSpiClass() {
		return PresentationStateDataSourceSpi.class;
	}

	@Override
	protected String getSiteNumber() {
		return getRoutingToken().getRepositoryUniqueId();
	}

	
	
}
