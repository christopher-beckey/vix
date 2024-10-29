package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.ParentREFDeletedMethodException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.DicomUid;
import gov.va.med.imaging.exchange.business.dicom.rdsr.Dose;

import java.util.List;

public class GetDicomUidCommandImpl 
extends AbstractDicomStorageDataSourceCommandImpl<DicomUid>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getDicomUid";

	private String accessionNumber;
	private String siteId;
	private String instrument;
	private String type;
	
	public GetDicomUidCommandImpl(String accessionNumber, 
			String siteId, 
			String instrument,
			String type)
	{
		this.accessionNumber = accessionNumber;
		this.siteId = siteId;
		this.instrument = instrument;
		this.type = type;
	}
	
	@Override
	public RoutingToken getRoutingToken() {
		return DicomServerConfiguration.getConfiguration().getRoutingToken();
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{String.class, String.class, String.class, String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{accessionNumber, siteId, instrument, type} ;
	}
	

	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return accessionNumber + "_" + siteId + "_" + instrument + "_" + type;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected DicomUid getCommandResult(DicomStorageDataSourceSpi spi)
	throws ConnectionException, MethodException, ParentREFDeletedMethodException 
	{
		return spi.getDicomUid(accessionNumber, siteId, instrument, type);
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
