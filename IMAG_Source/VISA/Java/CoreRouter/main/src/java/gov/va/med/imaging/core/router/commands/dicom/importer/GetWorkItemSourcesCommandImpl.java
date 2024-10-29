package gov.va.med.imaging.core.router.commands.dicom.importer;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.DicomImporterDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.ImporterFilter;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.util.List;

public class GetWorkItemSourcesCommandImpl 
extends AbstractDicomImporterDataSourceCommandImpl<List<ImporterFilter>>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getWorkItemSources";

	public GetWorkItemSourcesCommandImpl() {
	}

	@Override
	protected String parameterToString()
	{
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected List<ImporterFilter> getCommandResult(DicomImporterDataSourceSpi spi) 
	throws ConnectionException, MethodException, SecurityCredentialsExpiredException 
	{
		return spi.getWorkItemSources();
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

	@Override
	protected List<ImporterFilter> postProcessResult(List<ImporterFilter> result)
	{
		TransactionContextFactory.get().setDataSourceEntriesReturned(result == null ? 0 : result.size());
		return result;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return null;
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return null;
	}
	
}
