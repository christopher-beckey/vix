/**
 * Date Created: Feb 17, 2018
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.viewer.business.TreatingFacilityResult;
import gov.va.med.imaging.viewer.datasource.ViewerImagingCvixDataSourceSpi;

/**
 * @author vhaisltjahjb
 *
 */
public class GetCvixTreatingFacilitiesCommandImpl
extends AbstractViewerImagingCvixDataSourceCommandImpl<List<TreatingFacilityResult>>
{
	private static final long serialVersionUID = -4933914547363362029L;

	private final RoutingToken globalRoutingToken;
	private String patientIcn;
	private String patientDfn;
	
	/**
	 * @param globalRoutingToken
	 * @param imageUrns
	 */
	public GetCvixTreatingFacilitiesCommandImpl(
			RoutingToken globalRoutingToken,
			String patientIcn,
			String patientDfn)
	{
		super();
		this.globalRoutingToken = globalRoutingToken;
		this.patientIcn = patientIcn;
		this.patientDfn = patientDfn;
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
		return "getCvixTreatingFacilities";
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
				this.getPatientIcn(),
				this.getPatientDfn()
		};
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<TreatingFacilityResult> getCommandResult(ViewerImagingCvixDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.getCvixTreatingFacilities(
				getRoutingToken(), 
				getPatientIcn(),
				getPatientDfn());
	}

	private String getPatientDfn() {
		return patientDfn;
	}

	private String getPatientIcn() {
		return patientIcn;
	}


}
