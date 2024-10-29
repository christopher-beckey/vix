package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.dicom.PatientRef;
import gov.va.med.imaging.exchange.business.dicom.PatientStudyInfo;
import gov.va.med.imaging.exchange.business.dicom.PatientStudyLookupResults;
import gov.va.med.imaging.exchange.business.dicom.ProcedureRef;
import gov.va.med.imaging.exchange.business.dicom.Study;

import java.lang.reflect.Method;

public class GetPatientStudyLookupResultsCommandImpl 
extends AbstractDicomStorageDataSourceCommandImpl<PatientStudyLookupResults>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getPatientStudyLookupResults";

	private final PatientStudyInfo patientStudyInfo;
	
	public GetPatientStudyLookupResultsCommandImpl(PatientStudyInfo patientStudyInfo)
	{
		this.patientStudyInfo = patientStudyInfo;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{PatientStudyInfo.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{patientStudyInfo} ;
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
	protected PatientStudyLookupResults getCommandResult(DicomStorageDataSourceSpi spi) 
	throws ConnectionException, MethodException, SecurityCredentialsExpiredException 
	{
		return spi.getPatientStudyLookupResults(getPatientStudyInfo());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName() 
	{
		return SPI_METHOD_NAME;
	}

	/**
	 * @return the patientStudyInfo
	 */
	public PatientStudyInfo getPatientStudyInfo() {
		return patientStudyInfo;
	}

}
