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
package gov.va.med.imaging.vistaimagingdatasource.dd;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.imaging.exchange.business.dd.DataDictionaryEntryQuery;
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
public class VistaImagingDataDictionaryTranslator
{
	public static DataDictionaryResultEntry translateDataDictionaryResultEntry(DataDictionaryEntryQuery dataDictionaryEntryQuery,
			String rtn)
	{
		DataDictionaryResultEntry result = new DataDictionaryResultEntry(dataDictionaryEntryQuery.getIen());
		String [] lines = StringUtils.Split(rtn.trim(), StringUtils.NEW_LINE);
		
		String moreParameter = null;
		boolean processingMisc = false;
		boolean processingData = false;
		String line = "", internalValue = "", externalValue = "";
		
		for (int i = 0; i < lines.length; i++)
		{
			line = lines[i].trim();
			if("[Misc]".equals(line))
			{
				processingMisc = true;
				processingData = false;
			}
			else if("[Data]".equals(line))
			{
				processingData = true;
				processingMisc = false;
			}
			else
			{
				if(processingData)
				{
					internalValue = "";
					externalValue = "";
					// 2005.2^8,^.01^DRKINGHASHED^DRKINGHASHED
					// 2005.2^8,^.04^1^SALT LAKE CITY
					String fieldNumber = StringUtils.MagPiece(line, StringUtils.CARET, 3);
					if (!"[WORD PROCESSING]".equals(StringUtils.MagPiece(line, StringUtils.CARET, 4)))
					{
						internalValue = StringUtils.MagPiece(line, StringUtils.CARET, 4);
						externalValue = StringUtils.MagPiece(line, StringUtils.CARET, 5);
					}
					else
					{
						i++;
						while (!lines[i].startsWith("$$END$$")){
							if (internalValue != "")
								internalValue += "\r\n";
							internalValue += lines[i].trim();
							i++;
						}
						i++;
					}
					result.addField(new DataDictionaryResultEntryField(fieldNumber, internalValue, externalValue));
				}
				else if(processingMisc)
				{
					if(line.startsWith("MORE"))
					{
						moreParameter = StringUtils.MagPiece(line, StringUtils.CARET, 2);
					}
				}
			}
		}
		
		return result;		
	}
	
	public static List<DataDictionaryFile> translateDataDictionaryFileList(String rtn)
	{
		String [] lines = StringUtils.Split(rtn.trim(), StringUtils.NEW_LINE);
		List<DataDictionaryFile> files = 
			new ArrayList<DataDictionaryFile>();
		String moreParameter = null;
		boolean processingMisc = false;
		boolean processingData = false;
		for(String line : lines)
		{
			line = line.trim();
			if("[Misc]".equals(line))
			{
				processingMisc = true;
				processingData = false;
			}
			else if("[Data]".equals(line))
			{
				processingData = true;
				processingMisc = false;
			}
			else
			{
				if(processingData)
				{					
					String ien = StringUtils.MagPiece(line, StringUtils.CARET, 1).trim();
					String name = StringUtils.MagPiece(line, StringUtils.CARET, 2).trim();
					files.add(new DataDictionaryFile(ien, name));
				}
				else if(processingMisc)
				{
					if(line.startsWith("MORE"))
					{
						moreParameter = StringUtils.MagPiece(line, StringUtils.CARET, 2);
					}
				}
			}
		}
		return files;
	}
	
	public static DataDictionaryResult translateDataDictionaryQuery(DataDictionaryQuery dataDictionaryQuery,
			String rtn)
	{
		String [] lines = StringUtils.Split(rtn.trim(), StringUtils.NEW_LINE);
		List<DataDictionaryResultEntry> resultEntries = 
			new ArrayList<DataDictionaryResultEntry>();
		String moreParameter = null;
		boolean processingMisc = false;
		boolean processingData = false;
		for(String line : lines)
		{
			line = line.trim();
			if("[Misc]".equals(line))
			{
				processingMisc = true;
				processingData = false;
			}
			else if("[Data]".equals(line))
			{
				processingData = true;
				processingMisc = false;
			}
			else
			{
				if(processingData)
				{					
					//DataDictionaryResultEntry entry = new DataDictionaryResultEntry(line);
					resultEntries.add(translateLine(line, dataDictionaryQuery));
				}
				else if(processingMisc)
				{
					if(line.startsWith("MORE"))
					{
						moreParameter = StringUtils.MagPiece(line, StringUtils.CARET, 2);
					}
				}
			}
		}
		
		return new DataDictionaryResult(dataDictionaryQuery, resultEntries, 
				(moreParameter != null), moreParameter);
	}

	private static DataDictionaryResultEntry translateLine(String line, DataDictionaryQuery query)
	{
		String [] pieces = StringUtils.Split(line.trim(), StringUtils.CARET);
		String ien = pieces[0];
		
		DataDictionaryResultEntry entry = new DataDictionaryResultEntry(ien);
		Map<String, DataDictionaryResultEntryField> fieldsMap = new HashMap<String, DataDictionaryResultEntryField>();
		for(int i = 1; i < pieces.length; i++)
		{
			String field = query.getFields()[i - 1];
			String value = pieces[i].trim();
			String internalValue = null;
			String externalValue = null;
			if(field.endsWith("I"))
			{
				internalValue = value;
				field = field.substring(0, field.length() - 1);
			}
			else
			{
				// default is the external value
				externalValue = value;
				if(field.endsWith("E"))
				{
					field = field.substring(0, field.length() - 1);
				}
			}
			
			DataDictionaryResultEntryField entryField = fieldsMap.get(field);
			if(entryField == null)
			{
				entryField = new DataDictionaryResultEntryField(field, internalValue, externalValue);
				entry.addField(entryField);
				fieldsMap.put(field, entryField);
			}
			if(internalValue != null)
				entryField.setInternalValue(internalValue);
			if(externalValue != null)
				entryField.setExternalValue(externalValue);
		}
		
		return entry;
	}
	
	public static DataDictionaryFileField[] translateFileFields(String fileNumber, String rtn)
	{
		String[] lines = StringUtils.Split(rtn.trim(), StringUtils.NEW_LINE);
		DataDictionaryFileField[] result = null;
		if ((StringUtils.MagPiece(lines[0], StringUtils.BACKTICK, 1))
				.charAt(0) != '0')
		{
			result = new DataDictionaryFileField[1];
			result[0] = new DataDictionaryFileField(fileNumber, ".01", "root");
			return result;
		}
		result = new DataDictionaryFileField[lines.length - 1];
		String[] fieldParts;
		for (int i=1; i<lines.length; i++)
		{
			fieldParts = StringUtils.Split(lines[i].trim(),
					StringUtils.BACKTICK);
			result[i - 1] = new DataDictionaryFileField(fileNumber,
					fieldParts[0], fieldParts[1]);
		}
		return result;
	}
}
