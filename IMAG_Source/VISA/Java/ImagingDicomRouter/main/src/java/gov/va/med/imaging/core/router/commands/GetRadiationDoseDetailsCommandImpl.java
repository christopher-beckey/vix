package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.ParentREFDeletedMethodException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.rdsr.Dose;

import java.util.List;

public class GetRadiationDoseDetailsCommandImpl 
extends AbstractDicomStorageDataSourceCommandImpl<List<Dose>>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getRadiationDoseDetails";

	private String patientDfn;
	private String accessionNumber;
	
	public GetRadiationDoseDetailsCommandImpl(String patientDfn, String accessionNumber)
	{
		this.patientDfn = patientDfn;
		this.accessionNumber = accessionNumber;
	}
	
	@Override
	public RoutingToken getRoutingToken() {
		return DicomServerConfiguration.getConfiguration().getRoutingToken();
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{String.class, String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{patientDfn, accessionNumber} ;
	}
	

	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return patientDfn + "_" + accessionNumber;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<Dose> getCommandResult(DicomStorageDataSourceSpi spi)
	throws ConnectionException, MethodException, ParentREFDeletedMethodException 
	{
		return spi.getRadiationDoseDetails(patientDfn, accessionNumber);
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
