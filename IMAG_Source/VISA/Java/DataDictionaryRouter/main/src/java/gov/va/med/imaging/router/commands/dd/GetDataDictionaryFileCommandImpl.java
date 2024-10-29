package gov.va.med.imaging.router.commands.dd;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryFile;
import gov.va.med.imaging.router.commands.dd.provider.DataDictionaryCommandContext;

public class GetDataDictionaryFileCommandImpl extends
		AbstractDataDictionaryCommandImpl<DataDictionaryFile> {
	private static final long serialVersionUID = -7061403198595614098L;

	private final String fileNumber;

	public GetDataDictionaryFileCommandImpl(String fileNumber) {
		super();
		this.fileNumber = fileNumber;
	}

	public String getFileNumber() {
		return fileNumber;
	}

	@Override
	public DataDictionaryFile callSynchronouslyInTransactionContext()
			throws MethodException, ConnectionException {
		setInitialTransactionContextFields();
        getLogger().info("Loading info for file {}", getFileNumber());
		DataDictionaryCommandContext dataDictionaryCommandContext = getDataDictionaryCommandContext();
		DataDictionaryFile result = DataDictionaryFileCache
				.getCachedFile(getFileNumber());
		if (result == null) {
            getLogger().debug("Failed to find file {} in cache.  Loading from VistA.", getFileNumber());
			result = dataDictionaryCommandContext.getDataDictionaryService()
					.getDataDictionaryFile(getFileNumber());
            getLogger().info("Caching file {}", getFileNumber());
			DataDictionaryFileCache.cacheFile(result);
		}
		setDataSourceEntriesReturned(result == null ? 0 : 1);
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		return false;
	}

	@Override
	protected String parameterToString() {
		return fileNumber;
	}
}
