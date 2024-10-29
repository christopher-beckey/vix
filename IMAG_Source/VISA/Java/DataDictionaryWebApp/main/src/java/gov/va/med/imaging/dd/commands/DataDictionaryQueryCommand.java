/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 23, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.dd.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dd.DataDictionaryRouter;
import gov.va.med.imaging.dd.rest.types.DataDictionaryRestTranslator;
import gov.va.med.imaging.dd.rest.types.DataDictionaryResultType;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryQuery;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryResult;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

/**
 * @author VHAISWWERFEJ
 *
 */
public class DataDictionaryQueryCommand
extends AbstractDataDictionaryQueryCommand<DataDictionaryResult, DataDictionaryResultType>
{
	private final String file;
	private final String fields;
	private final Integer maxResults;
	private final String moreParameter;	

	public DataDictionaryQueryCommand(String file,
			String fields, Integer maxResults, String moreParameter)
	{
		super("getValues");
		this.file = file;
		this.fields = fields;
		this.maxResults = maxResults;
		this.moreParameter = moreParameter;
	}
	
	public DataDictionaryQueryCommand(String file,
			String fields, Integer maxResults)
	{
		this(file, fields, maxResults, null);
	}
	
	public DataDictionaryQueryCommand(String file,
			String fields)
	{
		this(file, fields, null, null);
	}

	public String getFile()
	{
		return file;
	}

	public String getFields()
	{
		return fields;
	}

	public Integer getMaxResults()
	{
		return maxResults;
	}

	public String getMoreParameter()
	{
		return moreParameter;
	}

	@Override
	protected DataDictionaryResult executeRouterCommand()
	throws MethodException, ConnectionException
	{
		DataDictionaryRouter router = getRouter();
		
		String [] f = DataDictionaryRestTranslator.translateFieldsToArray(getFields());
		DataDictionaryQuery dataDictionaryQuery = null;
		if(getMaxResults() == null)
			dataDictionaryQuery = new DataDictionaryQuery(getFile(), f);
		else if(getMoreParameter() == null)
			dataDictionaryQuery = new DataDictionaryQuery(getFile(), f, getMaxResults());
		else
			dataDictionaryQuery = new DataDictionaryQuery(getFile(), f, getMaxResults(), getMoreParameter());
		
		return router.getDataDictionaryValues(dataDictionaryQuery);
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "from file '" + file + "'";
	}

	@Override
	protected DataDictionaryResultType translateRouterResult(
			DataDictionaryResult routerResult) 
	throws TranslationException, MethodException
	{
		return DataDictionaryRestTranslator.translate(routerResult);
	}

	@Override
	protected Class<DataDictionaryResultType> getResultClass()
	{
		return DataDictionaryResultType.class;
	}

	@Override
	public Integer getEntriesReturned(DataDictionaryResultType translatedResult)
	{
		return translatedResult == null ? 0 : (translatedResult.getResults() == null ? 0 : translatedResult.getResults().length);
	}
}
