/**
 * 
 * 
 * Date Created: Feb 12, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.consult.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.consult.datasource.ConsultDataSourceSpi;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;

/**
 * @author Julian Werfel
 *
 */
public abstract class AbstractConsultDataSourceCommandImpl<R>
extends AbstractDataSourceCommandImpl<R, ConsultDataSourceSpi>
{

	private static final long serialVersionUID = -8644367893527604306L;
	
	private final RoutingToken routingToken;
	
	public AbstractConsultDataSourceCommandImpl(RoutingToken routingToken)
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
	protected Class<ConsultDataSourceSpi> getSpiClass()
	{
		return ConsultDataSourceSpi.class;
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
