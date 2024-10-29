/**
 * 
 * Date Created: Jan 20, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.datasource.IndexTermDataSourceSpi;
import gov.va.med.imaging.indexterm.enums.IndexClass;

/**
 * @author Administrator
 *
 */
public class GetSpecialtiesIndexTermsCommandImpl
extends AbstractIndexTermDataSourceCommandImpl
{
	private static final long serialVersionUID = -2111081985087286526L;
	
	private final List<IndexClass> indexClasses; 
	private final List<IndexTermURN> eventUrns;

	/**
	 * @param routingToken
	 */
	public GetSpecialtiesIndexTermsCommandImpl(RoutingToken routingToken,
		List<IndexClass> indexClasses, List<IndexTermURN> eventUrns)
	{
		super(routingToken);
		this.indexClasses = indexClasses;
		this.eventUrns = eventUrns;
	}

	/**
	 * @return the indexClasses
	 */
	public List<IndexClass> getIndexClasses()
	{
		return indexClasses;
	}


	public List<IndexTermURN> getEventUrns()
	{
		return eventUrns;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "getSpecialties";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, List.class, List.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getRoutingToken(), getIndexClasses(), getEventUrns()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<IndexTermValue> getCommandResult(IndexTermDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getSpecialties(getRoutingToken(), getIndexClasses(), getEventUrns());
	}

}
