package gov.va.med.imaging.viewer.datasource;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.viewer.business.TreatingFacilityResult;

public interface ViewerImagingCvixDataSourceSpi
extends VersionableDataSourceSpi
{
	public abstract List<TreatingFacilityResult> getCvixTreatingFacilities(
			RoutingToken globalRoutingToken,
			String patientIcn,
			String patientDfn)
	throws MethodException, ConnectionException;
	
}
