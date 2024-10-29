/**
 * 
 * 
 * Date Created: Feb 6, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.tiu.TIUNote;
import gov.va.med.imaging.tiu.datasource.TIUNoteDataSourceSpi;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * @author Julian Werfel
 *
 */
public class GetTIUNotesCommandImpl
extends AbstractTIUGetDataSourceCommandImpl<List<TIUNote>>
{
	private static final long serialVersionUID = 8244131235924641415L;
	
	private final String titleList;
	
	/**
	 * @param routingToken
	 * @param searchText
	 */
	public GetTIUNotesCommandImpl(RoutingToken routingToken, String searchText, String titleList)
	{
		super(routingToken, searchText);
		this.titleList = titleList;

	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "getMatchingTIUNotes";
	}
	
	public String getTitleList() {
		return titleList;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, String.class, String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getRoutingToken(), getSearchText(), getTitleList()};
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<TIUNote> getCommandResult(TIUNoteDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getMatchingTIUNotes(getRoutingToken(), getSearchText(), getTitleList());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#postProcessResult(java.lang.Object)
	 */
	@Override
	protected List<TIUNote> postProcessResult(List<TIUNote> result)
	{
		TransactionContextFactory.get().setDataSourceEntriesReturned(result == null ? 0 : result.size());
		return result;
	}

}
