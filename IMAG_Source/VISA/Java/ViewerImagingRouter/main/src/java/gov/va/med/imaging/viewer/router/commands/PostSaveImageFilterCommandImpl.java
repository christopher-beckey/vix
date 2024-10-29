/**
 * Date Created: Jun 1, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.viewer.business.ImageFilterFieldValue;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceSpi;

/**
 * @author vhaisltjahjb
 *
 */
public class PostSaveImageFilterCommandImpl
extends AbstractViewerImagingDataSourceCommandImpl<String>
{
	private static final long serialVersionUID = -7703914547363362027L;

	private final RoutingToken globalRoutingToken;
	private final List<ImageFilterFieldValue> imageFilterFieldValues;

	/**
	 * @param globalRoutingToken
	 * @param imageFilterValues
	 */
	public PostSaveImageFilterCommandImpl(
			RoutingToken globalRoutingToken,
			List<ImageFilterFieldValue> imageFilterFieldValues) 
	{
		super();
		this.globalRoutingToken = globalRoutingToken;
		this.imageFilterFieldValues = imageFilterFieldValues;
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
	 * @return the imageFilterValues
	 */
	public List<ImageFilterFieldValue> getImageFilterFieldValues()
	{
		return imageFilterFieldValues;
	}

	/**

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "saveImageFilter";
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
				this.getImageFilterFieldValues()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected String getCommandResult(ViewerImagingDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.saveImageFilter(
				getRoutingToken(), 
				this.getImageFilterFieldValues());
	}

}
