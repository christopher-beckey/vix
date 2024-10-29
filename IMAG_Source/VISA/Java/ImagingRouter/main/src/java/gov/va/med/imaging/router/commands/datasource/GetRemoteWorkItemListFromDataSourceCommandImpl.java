package gov.va.med.imaging.router.commands.datasource;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.ExternalPackageDataSourceSpi;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.util.List;

public class GetRemoteWorkItemListFromDataSourceCommandImpl 
extends AbstractDataSourceCommandImpl<List<WorkItem>, ExternalPackageDataSourceSpi> 

{

	private static final long serialVersionUID = 5378884879566937941L;

	private static final String SPI_METHOD_NAME = "getRemoteWorkItemListFromDataSource";

	private RoutingToken remoteRoutingToken;
	private final String idType;
	private final String patientId;
	private final String cptCode;

	public GetRemoteWorkItemListFromDataSourceCommandImpl(
			RoutingToken remoteRoutingToken, 
			String idType,
			String patientId,
			String cptCode)
	{
		this.remoteRoutingToken = remoteRoutingToken;
		this.idType = idType;
		this.patientId = patientId;
		this.cptCode = cptCode;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{RoutingToken.class, String.class, String.class, String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getRoutingToken(), getIdType(), getPatientId(), getCptCode()} ;
	}

	@Override
	protected String parameterToString()
	{
		return getRoutingToken().toRoutingTokenString() + "," + getIdType() + "," + getPatientId() + "," + getCptCode();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<WorkItem> getCommandResult(ExternalPackageDataSourceSpi spi) 
	throws ConnectionException, MethodException, SecurityCredentialsExpiredException 
	{
		return spi.getRemoteWorkItemListFromDataSource(getRoutingToken(), getIdType(), getPatientId(), getCptCode());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName() {
		return SPI_METHOD_NAME;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getIdType() {
		return idType;
	}

	public String getPatientId() {
		return patientId;
	}

	public String getCptCode() {
		return cptCode;
	}

	@Override
	protected List<WorkItem> postProcessResult(List<WorkItem> result)
	{
		TransactionContextFactory.get().setDataSourceEntriesReturned(result == null ? 0 : result.size());
		return result;
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
	
}
