package gov.va.med.imaging.router.commands.datasource;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.ExternalPackageDataSourceSpi;

public class DeleteRemoteWorkItemFromDataSourceCommandImpl 
extends AbstractDataSourceCommandImpl<Boolean, ExternalPackageDataSourceSpi> 
{

	private static final long serialVersionUID = -5378884875566937841L;

	private static final String SPI_METHOD_NAME = "deleteRemoteWorkItemFromDataSource";
	
	private RoutingToken remoteRoutingToken;
	private String id;
	
	public DeleteRemoteWorkItemFromDataSourceCommandImpl(RoutingToken remoteRoutingToken, String id) 
	{
		this.remoteRoutingToken = remoteRoutingToken;
		this.id = id;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{RoutingToken.class, String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getRoutingToken(), getId()} ;
	}

	@Override
	protected String parameterToString()
	{
		return getId();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName() 
	{
		return SPI_METHOD_NAME;
	}

	public String getId() 
	{
		return id;
	}

	@Override
	public RoutingToken getRoutingToken() 
	{
		return remoteRoutingToken;
	}

	@Override
	protected Class<ExternalPackageDataSourceSpi> getSpiClass() 
	{
		return ExternalPackageDataSourceSpi.class;
	}

	@Override
	protected String getSiteNumber() 
	{
		return getRoutingToken().getRepositoryUniqueId();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected Boolean getCommandResult(ExternalPackageDataSourceSpi spi) 
	throws ConnectionException, MethodException, SecurityCredentialsExpiredException 
	{
		return spi.deleteRemoteWorkItemFromDataSource(getRoutingToken(), getId());
	}


}
