package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.dicom.PatientRef;
import gov.va.med.imaging.exchange.business.dicom.ProcedureRef;

import java.lang.reflect.Method;

public class GetOrCreateProcedureRefCommandImpl 
extends AbstractDicomStorageDataSourceCommandImpl<ProcedureRef>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getOrCreateProcedureRef";

	private PatientRef patientRef;
	private ProcedureRef procedureRef;
	
	public GetOrCreateProcedureRefCommandImpl(PatientRef patientRef, ProcedureRef procedureRef)
	{
		this.patientRef = patientRef;
		this.procedureRef = procedureRef;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{PatientRef.class, ProcedureRef.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{patientRef, procedureRef} ;
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
	protected ProcedureRef getCommandResult(DicomStorageDataSourceSpi spi)
	throws ConnectionException, MethodException 
	{
		return spi.getOrCreateProcedureRef(patientRef, procedureRef);
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
