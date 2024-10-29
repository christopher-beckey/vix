/**
 * Date Created: Apr 23, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceSpi;

/**
 * @author vhaisltjahjb
 *
 */
public class DeleteImageFilterCommandImpl
extends AbstractViewerImagingDataSourceCommandImpl<String>
{
	private static final long serialVersionUID = -5803914547363562027L;

	private final RoutingToken globalRoutingToken;
	private final String filterIen;

	/**
	 * @param globalRoutingToken
	 * @param filterIen
	 */
	public DeleteImageFilterCommandImpl(
			RoutingToken globalRoutingToken,
			String filterIen)
	{
		super();
		this.globalRoutingToken = globalRoutingToken;
		this.filterIen = filterIen;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getRoutingToken()
	 */
	@Override
	public RoutingToken getRoutingToken()
	{
		return globalRoutingToken;
	}

	/**
	 * @return the filterIen
	 */
	public String getFilterIen()
	{
		return filterIen;
	}

	/**

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "deleteFilterImage";
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
		return new Object[] {
				getRoutingToken(), 
				this.getFilterIen()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected String getCommandResult(ViewerImagingDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.deleteImageFilter(
				getRoutingToken(), 
				this.getFilterIen());
	}

}
