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
public class GetProcedureEventsIndexTermsCommandImpl
extends AbstractIndexTermDataSourceCommandImpl
{
	private static final long serialVersionUID = -2062973564603994411L;
	
	private final List<IndexClass> indexClasses;
	private final List<IndexTermURN> specialtyUrns;

	/**
	 * @param routingToken
	 */
	public GetProcedureEventsIndexTermsCommandImpl(RoutingToken routingToken,List<IndexClass> indexClasses, 
		List<IndexTermURN> specialtyUrns)
	{
		super(routingToken);
		this.indexClasses = indexClasses;
		this.specialtyUrns = specialtyUrns;
	}
	
	public GetProcedureEventsIndexTermsCommandImpl(RoutingToken routingToken)
	{
		this(routingToken, null, null);
	}

	/**
	 * @return the indexClasses
	 */
	public List<IndexClass> getIndexClasses()
	{
		return indexClasses;
	}

	public List<IndexTermURN> getSpecialtyUrns()
	{
		return specialtyUrns;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "getProcedureEvents";
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
		return new Object[] {getRoutingToken(), getIndexClasses(), getSpecialtyUrns()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<IndexTermValue> getCommandResult(IndexTermDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getProcedureEvents(getRoutingToken(), getIndexClasses(), getSpecialtyUrns());
	}

}
