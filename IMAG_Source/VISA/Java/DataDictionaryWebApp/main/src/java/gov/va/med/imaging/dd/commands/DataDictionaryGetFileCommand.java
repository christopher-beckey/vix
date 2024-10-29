package gov.va.med.imaging.dd.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dd.DataDictionaryRouter;
import gov.va.med.imaging.dd.rest.types.DataDictionaryFileType;
import gov.va.med.imaging.dd.rest.types.DataDictionaryRestTranslator;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryFile;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

public class DataDictionaryGetFileCommand
extends AbstractDataDictionaryQueryCommand<DataDictionaryFile, DataDictionaryFileType>
{
	private final String fileNumber;
	
	public DataDictionaryGetFileCommand(String fileNumber)
	{
		super("getFile");
		this.fileNumber = fileNumber;
	}

	public String getFileNumber()
	{
		return fileNumber;
	}

	@Override
	protected DataDictionaryFile executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		DataDictionaryRouter router = getRouter();
		return router.getDataDictionaryFile(getFileNumber());
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return getFileNumber();
	}

	@Override
	protected DataDictionaryFileType translateRouterResult(
			DataDictionaryFile routerResult) 
	throws TranslationException, MethodException
	{
		return DataDictionaryRestTranslator.translate(routerResult);
	}

	@Override
	protected Class<DataDictionaryFileType> getResultClass()
	{
		return DataDictionaryFileType.class;
	}

	@Override
	public Integer getEntriesReturned(
			DataDictionaryFileType translatedResult)
	{
		return translatedResult == null ? 0 : 1;
	}

}
