/**
 * Date Created: May 1, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.viewer.business.QAReviewReportResult;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceSpi;

/**
 * @author vhaisltjahjb
 *
 */
public class GetQAReviewReportsCommandImpl
extends AbstractViewerImagingDataSourceCommandImpl<List<QAReviewReportResult>>
{
	private static final long serialVersionUID = -4733914547364462029L;

	private final RoutingToken globalRoutingToken;
	private String userId;
	
	/**
	 * @param globalRoutingToken
	 * @param imageUrns
	 */
	public GetQAReviewReportsCommandImpl(
			RoutingToken globalRoutingToken,
			String userId)
	{
		super();
		this.globalRoutingToken = globalRoutingToken;
		this.userId = userId;
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
		return "getQAReviewReports";
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
				this.getUserId()
		};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<QAReviewReportResult> getCommandResult(ViewerImagingDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getQAReviewReports(
				getRoutingToken(), 
				getUserId());
	}

	private String getUserId() {
		return userId;
	}


}
