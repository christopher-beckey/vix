/**
 * Date Created: Apr 26, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.viewer.business.DeleteImageUrn;
import gov.va.med.imaging.viewer.business.DeleteImageUrnResult;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceSpi;

/**
 * @author vhaisltjahjb
 *
 */
public class DeleteImagesCommandImpl
extends AbstractViewerImagingDataSourceCommandImpl<List<DeleteImageUrnResult>>
{
	private static final long serialVersionUID = -4703914547363562027L;

	private final RoutingToken globalRoutingToken;
	private final List<DeleteImageUrn> imageUrns;

	/**
	 * @param globalRoutingToken
	 * @param imageUrn
	 * @param deleteImageFile
	 * @param deleteGroup
	 * @param reason
	 */
	public DeleteImagesCommandImpl(
			RoutingToken globalRoutingToken,
			List<DeleteImageUrn> imageUrns)
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
	public List<DeleteImageUrn> getImageUrns()
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
		return "deleteImages";
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
	protected List<DeleteImageUrnResult> getCommandResult(ViewerImagingDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.deleteImages(
				getRoutingToken(), 
				this.getImageUrns());
	}

}
