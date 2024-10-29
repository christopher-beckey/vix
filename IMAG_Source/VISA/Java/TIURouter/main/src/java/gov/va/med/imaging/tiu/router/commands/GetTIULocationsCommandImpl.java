/**
 * 
 * 
 * Date Created: Feb 7, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.tiu.TIULocation;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author Julian Werfel
 *
 */
public class GetTIULocationsCommandImpl
extends AbstractTIUGetDataSourceCommandImpl<List<TIULocation>>
{	
	private static final long serialVersionUID = -8978159214127926583L;

	public GetTIULocationsCommandImpl(RoutingToken routingToken, String searchText)
	{
		super(routingToken, searchText);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "getLocations";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<TIULocation> getCommandResult(TIUNoteDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getLocations(getRoutingToken(), getSearchText());
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#postProcessResult(java.lang.Object)
	 */
	@Override
	protected List<TIULocation> postProcessResult(List<TIULocation> result)
	{
		TransactionContextFactory.get().setDataSourceEntriesReturned(result == null ? 0 : result.size());
		return result;
	}

}
