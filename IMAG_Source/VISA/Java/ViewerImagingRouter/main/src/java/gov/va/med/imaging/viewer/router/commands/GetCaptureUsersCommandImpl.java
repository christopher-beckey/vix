/**
 * Date Created: Apr 12, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.viewer.business.CaptureUserResult;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceSpi;

/**
 * @author vhaisltjahjb
 *
 */
public class GetCaptureUsersCommandImpl
extends AbstractViewerImagingDataSourceCommandImpl<List<CaptureUserResult>>
{
	private static final long serialVersionUID = -4733914547463362029L;

	private final RoutingToken globalRoutingToken;
	private String appFlag;
	private String fromDate;
	private String throughDate;
	
	/**
	 * @param globalRoutingToken
	 * @param imageUrns
	 */
	public GetCaptureUsersCommandImpl(
			RoutingToken globalRoutingToken,
			String appFlag,
			String fromDate,
			String throughDate)
	{
		super();
		this.globalRoutingToken = globalRoutingToken;
		this.appFlag = appFlag;
		this.fromDate = fromDate;
		this.throughDate = throughDate;
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
		return "getTreatingFacilities";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes()
	{
		return new Class<?>[] {RoutingToken.class, String.class, String.class};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters()
	{
		return new Object[] {
				getRoutingToken(), 
				this.getAppFlag(),
				this.getFromDate(),
				this.getThroughDate()
		};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<CaptureUserResult> getCommandResult(ViewerImagingDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getCaptureUsers(
				getRoutingToken(), 
				getAppFlag(),
				getFromDate(),
				getThroughDate());
	}

	private String getAppFlag() {
		return appFlag;
	}

	private String getFromDate() {
		return fromDate;
	}

	private String getThroughDate() {
		return throughDate;
	}


}
