/**
 * Date Created: Jun 1, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.viewer.router.commands;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.viewer.business.LogAccessImageUrn;
import gov.va.med.imaging.viewer.business.LogAccessImageUrnResult;
import gov.va.med.imaging.viewer.datasource.ViewerImagingDataSourceSpi;

/**
 * @author vhaisltjahjb
 *
 */
public class PutLogImageAccessByUrnsCommandImpl
extends AbstractViewerImagingDataSourceCommandImpl<List<LogAccessImageUrnResult>>
{
	private static final long serialVersionUID = -4703914547363362027L;

	private final RoutingToken globalRoutingToken;
	private String patientIcn;
	private String patientDfn;
	private final List<LogAccessImageUrn> imageUrns;

	/**
	 * @param globalRoutingToken
	 * @param imageUrns
	 */
	public PutLogImageAccessByUrnsCommandImpl(
			RoutingToken globalRoutingToken,
			String patientIcn,
			String patientDfn,
			List<LogAccessImageUrn> imageUrns)
	{
		super();
		this.globalRoutingToken = globalRoutingToken;
		this.patientIcn = patientIcn;
		this.patientDfn = patientDfn;
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
	public List<LogAccessImageUrn> getImageUrns()
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
		return "logImageAccessByUrns";
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
	protected List<LogAccessImageUrnResult> getCommandResult(ViewerImagingDataSourceSpi spi)
	throws ConnectionException, MethodException
	{
		return spi.logImageAccessByUrns(
				getRoutingToken(), 
				getPatientIcn(),
				getPatientDfn(),
				this.getImageUrns());
	}

	private String getPatientDfn() {
		return patientDfn;
	}

	private String getPatientIcn() {
		return patientIcn;
	}


}
