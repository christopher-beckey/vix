/**
 * 
 * 
 * Date Created: Jan 20, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.datasource.IndexTermDataSourceSpi;
import gov.va.med.imaging.indexterm.enums.IndexClass;

/**
 * @author Administrator
 *
 */
public class GetTypesIndexTermsCommandImpl
extends AbstractIndexTermDataSourceCommandImpl
{
	private static final long serialVersionUID = -3496255429673260988L;
	
	private final List<IndexClass> indexClasses;

	/**
	 * @param routingToken
	 */
	public GetTypesIndexTermsCommandImpl(RoutingToken routingToken, List<IndexClass> indexClasses)
	{
		super(routingToken);
		this.indexClasses = indexClasses;
	}

	/**
	 * @return the indexClasses
	 */
	public List<IndexClass> getIndexClasses()
	{
		return indexClasses;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "getTypes";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, List.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {getRoutingToken(), getIndexClasses()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<IndexTermValue> getCommandResult(IndexTermDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getTypes(getRoutingToken(), getIndexClasses());
	}

}
