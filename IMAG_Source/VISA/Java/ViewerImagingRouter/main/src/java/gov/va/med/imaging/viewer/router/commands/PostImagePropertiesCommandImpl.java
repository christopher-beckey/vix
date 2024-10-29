/**
 * Date Created: May 2, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.viewer.business.ImageFilterFieldValue;
import gov.va.med.imaging.viewer.business.ImageProperty;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceSpi;

/**
 * @author vhaisltjahjb
 *
 */
public class PostImagePropertiesCommandImpl
extends AbstractViewerImagingDataSourceCommandImpl<String>
{
	private static final long serialVersionUID = -7703914547367762027L;

	private final RoutingToken globalRoutingToken;
	private final List<ImageProperty> imageProperties;

	/**
	 * @param globalRoutingToken
	 * @param imageIEN
	 * @param flags
	 * @param imageProperties
	 */
	public PostImagePropertiesCommandImpl(
			RoutingToken globalRoutingToken,
			List<ImageProperty> imageProperties) 
	{
		super();
		this.globalRoutingToken = globalRoutingToken;
		this.imageProperties = imageProperties;
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
	 * @return the imageProperties
	 */
	public List<ImageProperty> getImageProperties()
	{
		return imageProperties;
	}

	/**

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "setImageProperties";
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
		return new Object[] {
				getRoutingToken(), 
				this.getImageProperties()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected String getCommandResult(ViewerImagingDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.setImageProperties(
				getRoutingToken(), 
				this.getImageProperties());
	}

}
