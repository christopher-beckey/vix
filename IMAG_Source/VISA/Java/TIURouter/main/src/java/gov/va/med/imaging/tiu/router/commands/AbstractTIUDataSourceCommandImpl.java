/**
 * 
 * 
 * Date Created: Feb 7, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;

/**
 * @author Julian Werfel
 *
 */
public abstract class AbstractTIUDataSourceCommandImpl<R>
extends AbstractDataSourceCommandImpl<R, TIUNoteDataSourceSpi>
{
	private static final long serialVersionUID = -3267760018866320504L;
	
	private final RoutingToken routingToken;
	
	public AbstractTIUDataSourceCommandImpl(RoutingToken routingToken)
	{
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
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiClass()
	 */
	@Override
	protected Class<TIUNoteDataSourceSpi> getSpiClass()
	{
		return TIUNoteDataSourceSpi.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSiteNumber()
	 */
	@Override
	protected String getSiteNumber()
	{
		return getRoutingToken().getRepositoryUniqueId();
	}
}
