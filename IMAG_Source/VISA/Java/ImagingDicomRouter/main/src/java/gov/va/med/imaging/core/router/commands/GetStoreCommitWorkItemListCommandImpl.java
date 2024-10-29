package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.WorkListDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.SCWorkItemQueryParameters;
import gov.va.med.imaging.exchange.business.dicom.StorageCommitWorkItem;

import java.util.List;

public class GetStoreCommitWorkItemListCommandImpl 
extends AbstractDicomSCDataSourceCommandImpl<List<StorageCommitWorkItem>>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "listSCWorkItems";

	private final SCWorkItemQueryParameters queryParams;
	
	public GetStoreCommitWorkItemListCommandImpl(SCWorkItemQueryParameters parameters){
		this.queryParams = parameters;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{SCWorkItemQueryParameters.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getQueryParams()} ;
	}

	@Override
	protected String parameterToString()
	{
		return this.queryParams.toString();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<StorageCommitWorkItem> getCommandResult(
			WorkListDataSourceSpi spi) 
	throws ConnectionException, MethodException 
	{
		return spi.listSCWorkItems(getQueryParams());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
//	@Override
	protected String getSpiMethodName() 
	{
		return SPI_METHOD_NAME;
	}

	public SCWorkItemQueryParameters getQueryParams() {
		return queryParams;
	}

}
