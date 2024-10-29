/**
 * Date Created: Apr 23, 2018
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
public class GetImageFilterDetailCommandImpl
extends AbstractViewerImagingDataSourceCommandImpl<List<ImageFilterFieldValue>>
{
	private static final long serialVersionUID = -4703914547363362027L;

	private final RoutingToken globalRoutingToken;
	private String filterIen;
	private String userId;
	private String filterName;
	
	/**
	 * @param globalRoutingToken
	 * @param imageUrns
	 */
	public GetImageFilterDetailCommandImpl(
			RoutingToken globalRoutingToken,
			String filterIen, 
			String filterName, 
			String userId)
	{
		super();
		this.globalRoutingToken = globalRoutingToken;
		this.setFilterIen(filterIen);
		this.setFilterName(filterName);
		this.setUserId(userId);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getRoutingToken()
	 */
	@Override
	public RoutingToken getRoutingToken()
	{
		return globalRoutingToken;
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName()
	{
		return "getImageFilterDetail";
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
				this.getFilterIen(),
				this.getFilterName(),
				this.getUserId()};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<ImageFilterFieldValue> getCommandResult(ViewerImagingDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getImageFilterDetail(
				getRoutingToken(), 
				getFilterIen(),
				getFilterName(),
				getUserId());
	}

	public String getFilterIen() {
		return filterIen;
	}

	public void setFilterIen(String filterIen) {
		this.filterIen = filterIen;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getFilterName() {
		return filterName;
	}

	public void setFilterName(String filterName) {
		this.filterName = filterName;
	}


}
