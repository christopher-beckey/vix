package gov.va.med.imaging.core.router.commands.worklist;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.WorkListDataSourceSpi;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public class PutWorkItemServiceCommandImpl 
extends AbstractWorkListDataSourceCommandImpl<String>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "updateWorkItemService";
	
	private final String service;
	private final String modality;
	private final String procedure;
	private final String newService;

	public PutWorkItemServiceCommandImpl(String service, String modality, String procedure, String newService)
	{
		this.service = service;
		this.modality = modality;
		this.procedure = procedure;
		this.newService = newService;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{String.class, String.class, String.class, String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getService(), getModality(), getProcedure(), getNewService()};
	}

	@Override
	protected String parameterToString()
	{
		return getService() + ", " + getModality() + ", " + getProcedure() + ", " + getNewService();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected String getCommandResult(WorkListDataSourceSpi spi) 
	throws ConnectionException, MethodException, SecurityCredentialsExpiredException 
	{
		return spi.updateWorkItemService(service, modality, procedure, newService);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName() {
		return SPI_METHOD_NAME;
	}

	public String getService() {
		return service;
	}

	public String getModality() {
		return modality;
	}

	public String getProcedure() {
		return procedure;
	}

	public String getNewService() {
		return newService;
	}
	
	@Override
	protected String postProcessResult(String result)
	{
		TransactionContextFactory.get().setDataSourceEntriesReturned(result == null ? 0 : 1);
		return result;
	}

}
