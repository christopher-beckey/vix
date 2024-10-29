/**
 * Date Created: Apr 23, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.viewer.business.ImageFilterResult;
import gov.va.med.imaging.viewer.business.ImageProperty;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceSpi;

/**
 * @author vhaisltjahjb
 *
 */
public class GetImagePropertiesCommandImpl
extends AbstractViewerImagingDataSourceCommandImpl<List<ImageProperty>>
{
	private static final long serialVersionUID = -5733914547468862029L;

	private final RoutingToken globalRoutingToken;
	private final String imageIEN;
	private final String props;
	private final String flags;
	
	/**
	 * @param globalRoutingToken
	 * @param userId
	 */
	public GetImagePropertiesCommandImpl(
			RoutingToken globalRoutingToken,
			String imageIEN,
			String props,
			String flags)
	{
		super();
		this.globalRoutingToken = globalRoutingToken;
		this.imageIEN = imageIEN;
		this.props = props;
		this.flags = flags;
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

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "getImageProperties";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, String.class, String.class, String.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {
				getRoutingToken(), 
				this.getImageIEN(),
				this.getProps(),
				this.getFlags()
		};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<ImageProperty> getCommandResult(ViewerImagingDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getImageProperties(
				getRoutingToken(), 
				this.getImageIEN(),
				this.getProps(),
				this.getFlags());
	}

	public String getImageIEN() {
		return imageIEN;
	}

	public String getProps() {
		return props;
	}

	public String getFlags() {
		return flags;
	}


}
