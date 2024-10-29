/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands;

import gov.va.med.RoutingToken;

/**
 * @author Julian Werfel
 *
 */
public abstract class AbstractTIUGetDataSourceCommandImpl<R>
extends AbstractTIUDataSourceCommandImpl<R>
{

	private static final long serialVersionUID = 4441539771987373354L;
	
	private final String searchText;
	
	
	/**
	 * @param routingToken
	 * @param searchText
	 */
	public AbstractTIUGetDataSourceCommandImpl(RoutingToken routingToken, String searchText)
	{
		super(routingToken);
		this.searchText = searchText;
	}	

	/**
	 * @return the searchText
	 */
	public String getSearchText()
	{
		return searchText;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, String.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getRoutingToken(), getSearchText()};
	}

}
