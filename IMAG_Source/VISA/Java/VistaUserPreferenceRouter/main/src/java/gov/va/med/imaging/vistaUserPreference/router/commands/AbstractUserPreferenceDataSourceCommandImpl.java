/**
 * 
 * Date Created: Jul 27, 2017
 * Developer: haisltjahjb
 */
package gov.va.med.imaging.vistaUserPreference.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.vistaUserPreference.datasource.VistaUserPreferenceDataSourceSpi;

/**
 * @author Budy Tjahjo
 *
 */
public abstract class AbstractUserPreferenceDataSourceCommandImpl<R>
extends AbstractDataSourceCommandImpl<R, VistaUserPreferenceDataSourceSpi>
{

	private static final long serialVersionUID = -5334310602947770481L;
	private final RoutingToken routingToken;

	/**
	 * @param routingToken
	 */
	public AbstractUserPreferenceDataSourceCommandImpl(RoutingToken routingToken)
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
	protected Class<VistaUserPreferenceDataSourceSpi> getSpiClass() {
		return VistaUserPreferenceDataSourceSpi.class;
	}

	@Override
	protected String getSiteNumber() {
		return getRoutingToken().getRepositoryUniqueId();
	}

	
	
}
