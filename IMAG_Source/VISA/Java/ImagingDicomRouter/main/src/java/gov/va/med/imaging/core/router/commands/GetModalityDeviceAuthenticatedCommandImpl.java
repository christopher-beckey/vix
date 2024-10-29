package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.DicomDataSourceSpi;

public class GetModalityDeviceAuthenticatedCommandImpl 
extends AbstractDicomDataSourceCommandImpl<Boolean>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "isModalityDeviceAuthenticated";

	private final String manufacturer;
	private final String model;
	private final String softwareVersion;
;
	
	public GetModalityDeviceAuthenticatedCommandImpl(String manufacturer, String model, String softwareVersion)
	{
		this.manufacturer = manufacturer;
		this.model = model;
		this.softwareVersion = softwareVersion;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{String.class, String.class, String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{manufacturer, model, softwareVersion} ;
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
		return spi.isModalityDeviceAuthenticated(getManufacturer(), getModel(), getSoftwareVersion());
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
	 * @return the manufacturer
	 */
	public String getManufacturer() {
		return manufacturer;
	}

	/**
	 * @return the model
	 */
	public String getModel() {
		return model;
	}

	/**
	 * @return the softwareVersion
	 */
	public String getSoftwareVersion() {
		return softwareVersion;
	}

	
}
