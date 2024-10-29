package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.ParentREFDeletedMethodException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.SOPInstance;
import gov.va.med.imaging.exchange.business.dicom.Series;

public class PostSOPInstanceCommandImpl 
extends AbstractDicomStorageDataSourceCommandImpl<SOPInstance>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "createSOPInstance";

	private Series series;
	private SOPInstance sopInstance;
	
	public PostSOPInstanceCommandImpl(Series series, SOPInstance sopInstance)
	{
		this.series = series;
		this.sopInstance = sopInstance;
	}
	
	@Override
	public RoutingToken getRoutingToken() {
		return DicomServerConfiguration.getConfiguration().getRoutingToken();
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{Series.class, SOPInstance.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{series, sopInstance} ;
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
	protected SOPInstance getCommandResult(DicomStorageDataSourceSpi spi)
	throws ConnectionException, MethodException, ParentREFDeletedMethodException 
	{
		return spi.createSOPInstance(series, sopInstance);
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
