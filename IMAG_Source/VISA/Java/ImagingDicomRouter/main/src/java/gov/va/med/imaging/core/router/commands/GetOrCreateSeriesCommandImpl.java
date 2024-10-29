package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.ParentREFDeletedMethodException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.Series;
import gov.va.med.imaging.exchange.business.dicom.Study;

public class GetOrCreateSeriesCommandImpl 
extends AbstractDicomStorageDataSourceCommandImpl<Series>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getOrCreateSeries";

	private Study study;
	private Series series;
	private Integer iodValidationStatus;
	
	public GetOrCreateSeriesCommandImpl(Study study, Series series, Integer iodValidationStatus)
	{
		this.study = study;
		this.series = series;
		this.iodValidationStatus = new Integer(iodValidationStatus);
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{Study.class, Series.class, Integer.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{study, series, iodValidationStatus} ;
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
	protected Series getCommandResult(DicomStorageDataSourceSpi spi)
	throws ConnectionException, MethodException, ParentREFDeletedMethodException
	{
		return spi.getOrCreateSeries(study, series, iodValidationStatus);
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
