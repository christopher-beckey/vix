package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.dicom.DGWEmailInfo;
import gov.va.med.imaging.exchange.business.dicom.ModalityConfig;

import java.lang.reflect.Method;
import java.util.List;

public class GetDgwEmailInfoCommandImpl 
extends AbstractDicomStorageDataSourceCommandImpl<DGWEmailInfo>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getDgwEmailInfo";

	private final String hostName;
	
	public GetDgwEmailInfoCommandImpl(String hostName)
	{
		this.hostName = hostName;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getHostName()} ;
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
	protected DGWEmailInfo getCommandResult(
			DicomStorageDataSourceSpi spi) 
	throws ConnectionException, MethodException, SecurityCredentialsExpiredException 
	{
		return spi.getDgwEmailInfo(getHostName());
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
	 * @return the hostName
	 */
	public String getHostName() {
		return hostName;
	}
}
