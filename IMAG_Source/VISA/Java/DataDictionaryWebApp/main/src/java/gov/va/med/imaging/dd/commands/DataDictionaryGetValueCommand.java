/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 24, 2011
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
import gov.va.med.imaging.dd.rest.types.DataDictionaryResultEntryType;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryEntryQuery;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryResultEntry;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

/**
 * @author VHAISWWERFEJ
 *
 */
public class DataDictionaryGetValueCommand
extends AbstractDataDictionaryQueryCommand<DataDictionaryResultEntry, DataDictionaryResultEntryType>
{
	private final String ien;
	private final String file;
	private final String fields;
	
	public DataDictionaryGetValueCommand(String file, String ien, String fields)
	{
		super("getValue");
		this.ien = ien;
		this.file = file;
		this.fields = fields;
	}

	public String getIen()
	{
		return ien;
	}

	public String getFile()
	{
		return file;
	}

	public String getFields()
	{
		return fields;
	}

	@Override
	protected DataDictionaryResultEntry executeRouterCommand()
			throws MethodException, ConnectionException
	{
		DataDictionaryRouter router = getRouter();
		
		String [] f = DataDictionaryRestTranslator.translateFieldsToArray(getFields());
		DataDictionaryEntryQuery dataDictionaryEntryQuery = 
			new DataDictionaryEntryQuery(getFile(), f, getIen());
		return router.getDataDictionaryValue(dataDictionaryEntryQuery);
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "from file '" + file + "'";
	}

	@Override
	protected DataDictionaryResultEntryType translateRouterResult(
			DataDictionaryResultEntry routerResult)
			throws TranslationException, MethodException
	{
		return DataDictionaryRestTranslator.translate(routerResult);
	}

	@Override
	protected Class<DataDictionaryResultEntryType> getResultClass()
	{
		return DataDictionaryResultEntryType.class;
	}

	@Override
	public Integer getEntriesReturned(
			DataDictionaryResultEntryType translatedResult)
	{
		return translatedResult == null ? 0 : 1;
	}

}
