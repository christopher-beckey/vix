package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.utils.NetUtilities;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.DicomDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;

public class GetDicomGatewayConfigCommandImpl 
extends AbstractDicomDataSourceCommandImpl<Boolean>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "loadDicomGatewayConfig";
	private String hostName = null;

	public GetDicomGatewayConfigCommandImpl()
	{
		hostName = NetUtilities.getUnsafeLocalHostName();

		if (DicomServerConfiguration.getConfiguration().getFakeHostName() != null) {
			hostName = DicomServerConfiguration.getConfiguration().getFakeHostName();
		}
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{hostName} ;
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
	protected Boolean getCommandResult(DicomDataSourceSpi spi)
	throws ConnectionException, MethodException, SecurityCredentialsExpiredException 
	{
		spi.loadDicomGatewayConfig(hostName);
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName() {
		return SPI_METHOD_NAME;
	}

}