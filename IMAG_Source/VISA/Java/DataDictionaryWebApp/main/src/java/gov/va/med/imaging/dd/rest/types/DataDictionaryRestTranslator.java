/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 12, 2011
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
package gov.va.med.imaging.dd.rest.types;

import java.util.List;

import gov.va.med.imaging.exchange.business.dd.DataDictionaryFile;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryFileField;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryQuery;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryResult;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryResultEntry;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryResultEntryField;
import gov.va.med.imaging.url.vista.StringUtils;

/**
 * @author VHAISWWERFEJ
 *
 */
public class DataDictionaryRestTranslator
{
	public static DataDictionaryFileType [] translate(List<DataDictionaryFile> files)
	{
		if(files == null)
			return null;
		DataDictionaryFileType [] result = 
			new DataDictionaryFileType[files.size()];
		
		for(int i= 0; i < files.size(); i++)
		{
			result[i] = translate(files.get(i));
		}
		
		return result;
	}
	
	public static DataDictionaryFileType translate(DataDictionaryFile file)
	{
		DataDictionaryFileType result = new DataDictionaryFileType();
		result.setName(file.getName());
		result.setNumber(file.getNumber());
		DataDictionaryFileFieldType[] fields = new DataDictionaryFileFieldType[file.getFields().size()];
		for (int i = 0; i < fields.length; i++){
			fields[i] = translate(file.getFields().get(i));
		}
		result.setFields(fields);
		return result;
	}
	
	public static DataDictionaryResultType translate(DataDictionaryResult result)
	{
		if(result == null)
			return null;
		
		DataDictionaryResultType resultType = 
			new DataDictionaryResultType();
		resultType.setMore(result.isMore());
		resultType.setMoreParameter(result.getMoreParameter());
		DataDictionaryResultEntryType [] resultEntries = 
			new DataDictionaryResultEntryType[result.getResults().size()];
		int i = 0;
		for(DataDictionaryResultEntry entry : result.getResults())
		{
			resultEntries[i] = translate(entry);// new DataDictionaryResultEntryType(entry.getResult());
			i++;
		}
		resultType.setResults(resultEntries);
		resultType.setDataDictionaryQuery(translate(result.getDataDictionaryQuery()));
		return resultType;
	}
	
	public static DataDictionaryResultEntryType translate(DataDictionaryResultEntry entry)
	{
		DataDictionaryResultEntryType result = new DataDictionaryResultEntryType();
		result.setIen(entry.getIen());
		
		DataDictionaryResultEntryFieldType [] fieldTypes = 
			new DataDictionaryResultEntryFieldType[entry.getFields().size()];
		
		int i = 0;
		for(DataDictionaryResultEntryField field : entry.getFields())
		{
			fieldTypes[i] = new DataDictionaryResultEntryFieldType(field.getField(), 
					field.getInternalValue(), field.getExternalValue());
			i++;		
		}
		result.setFields(fieldTypes);
		
		return result;
	}
	
	private static DataDictionaryQueryType translate(DataDictionaryQuery query)
	{
		DataDictionaryQueryType result = new DataDictionaryQueryType();
		result.setFileNumber(query.getFileNumber());
		result.setMaximumResults(query.getMaximumResults());
		result.setMoreParameter(query.getMoreParameter());
		result.setFields(query.getFields());
		return result;
	}

	public static String [] translateFieldsToArray(String fields)
	{
		String [] f = StringUtils.Split(fields, StringUtils.STICK);
		return f;
	}
	
	public static DataDictionaryFileFieldType translate(DataDictionaryFileField fileField)
	{
		if(fileField == null)
			return null;
		DataDictionaryFileFieldType result = new DataDictionaryFileFieldType();
		result.setFieldName(fileField.getFieldName());
		result.setFieldNumber(fileField.getFieldNumber());
		result.setPointerFileNumber(fileField.getPointerFileNumber());
		return result;
	}
}
