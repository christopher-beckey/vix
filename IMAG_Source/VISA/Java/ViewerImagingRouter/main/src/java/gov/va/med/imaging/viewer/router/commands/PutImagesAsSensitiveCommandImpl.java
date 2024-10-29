/**
 * Date Created: Jun 1, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.viewer.business.FlagSensitiveImageUrn;
import gov.va.med.imaging.viewer.business.FlagSensitiveImageUrnResult;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceSpi;

/**
 * @author vhaisltjahjb
 *
 */
public class PutImagesAsSensitiveCommandImpl
extends AbstractViewerImagingDataSourceCommandImpl<List<FlagSensitiveImageUrnResult>>
{
	private static final long serialVersionUID = -4703914547363362027L;

	private final RoutingToken globalRoutingToken;
	private final List<FlagSensitiveImageUrn> imageUrns;

	/**
	 * @param globalRoutingToken
	 * @param imageUrns
	 */
	public PutImagesAsSensitiveCommandImpl(
			RoutingToken globalRoutingToken,
			List<FlagSensitiveImageUrn> imageUrns)
	{
		super();
		this.globalRoutingToken = globalRoutingToken;
		this.imageUrns = imageUrns;
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
	 * @return the imageUrns
	 */
	public List<FlagSensitiveImageUrn> getImageUrns()
	{
		return imageUrns;
	}

	/**

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "flagImagesAsSensitive";
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
				this.getImageUrns()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<FlagSensitiveImageUrnResult> getCommandResult(ViewerImagingDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.flagImagesAsSensitive(
				getRoutingToken(), 
				getImageUrns());
	}

}
