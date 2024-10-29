package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.ParentREFDeletedMethodException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.PatientRef;
import gov.va.med.imaging.exchange.business.dicom.ProcedureRef;
import gov.va.med.imaging.exchange.business.dicom.SOPInstance;
import gov.va.med.imaging.exchange.business.dicom.Series;
import gov.va.med.imaging.exchange.business.dicom.Study;
import gov.va.med.imaging.exchange.business.dicom.rdsr.Dose;

public class PostRadiationDoseCommandImpl 
extends AbstractDicomStorageDataSourceCommandImpl<Dose>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "createRadiationDose";

	private PatientRef patient;
	private ProcedureRef procedure;
	private Study study;
	private Series series;
	private Dose dose;
	
	public PostRadiationDoseCommandImpl(PatientRef patient, ProcedureRef procedure, Study study, Series series, Dose dose)
	{
		this.patient = patient;
		this.procedure = procedure;
		this.study = study;
		this.series = series;
		this.dose = dose;
	}
	
	@Override
	public RoutingToken getRoutingToken() {
		return DicomServerConfiguration.getConfiguration().getRoutingToken();
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{PatientRef.class, ProcedureRef.class, Study.class, Series.class, Dose.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{patient, procedure, study, series, dose} ;
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
	protected Dose getCommandResult(DicomStorageDataSourceSpi spi)
	throws ConnectionException, MethodException, ParentREFDeletedMethodException 
	{
		return spi.createRadiationDose(patient, procedure, study, series, dose);
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
