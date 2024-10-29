package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.dicom.PatientRef;

import java.lang.reflect.Method;

public class GetOrCreatePatientRefCommandImpl 
extends AbstractDicomStorageDataSourceCommandImpl<PatientRef>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getOrCreatePatientRef";

	private PatientRef patientRef;
	
	public GetOrCreatePatientRefCommandImpl(PatientRef patient)
	{
		this.patientRef = patient;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{PatientRef.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{patientRef} ;
	}

	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected PatientRef getCommandResult(DicomStorageDataSourceSpi spi)
	throws ConnectionException, MethodException 
	{
		return spi.getOrCreatePatientRef(patientRef);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName() 
	{
		return SPI_METHOD_NAME;
	}
	
	

}
