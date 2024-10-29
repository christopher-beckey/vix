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

import java.util.HashMap;

import gov.va.med.imaging.exchange.business.dd.DataDictionaryFileField;
import gov.va.med.imaging.exchange.business.dd.FileManFileFields;
import gov.va.med.imaging.url.vista.StringUtils;

/**
 * @author VHAISWTITTOC
 *
 */
public class VistaImagingFileManTranslator
{
	private static final String pointer = "POINTER";
	private static final String typeKey = "TYPE";
	private static final String openParens = "(";
	
	public static FileManFileFields translateFileManFieldNums(String rtn)
	{
		FileManFileFields fMFFs=null;
		String[] lines = StringUtils.Split(rtn.trim(), StringUtils.NEW_LINE);
		int j=lines.length;
		String[] fieldNums = new String[j-1];
		String[] fieldNames = new String[j-1];
		int i=0;
		for(String line : lines)
		{
			if (i==0) {
				if ((StringUtils.MagPiece(lines[0], StringUtils.BACKTICK, 1)).charAt(0)!='0') {
					// error returned -- fake root node
					fieldNums[0]=".01";
					fieldNames[0]="root";
					fMFFs=new FileManFileFields(fieldNums, fieldNames);
					return fMFFs;
				}
			} else {
				line = line.trim();
				String[] fieldParts = StringUtils.Split(line, StringUtils.BACKTICK);
				fieldNums[i-1]=fieldParts[0];
				fieldNames[i-1]=fieldParts[1];
			}
			i++;
		}
		
		fMFFs=new FileManFileFields(fieldNums, fieldNames);
		return fMFFs;		
	}	

	public static String [] translateFileSearchResult(String rtn)
	{
		String[] iENs=null;
		String[] lines = StringUtils.Split(rtn.trim(), StringUtils.NEW_LINE);
		int j=lines.length;
		if ((j==1) && ((StringUtils.MagPiece(lines[0], StringUtils.BACKTICK, 1)).charAt(0)!='0')) {
			// error returned -- ToDo: log error
			return iENs;					
		}
		iENs = new String[j];
		int i=0;
		for(String line : lines)
		{
			line = line.trim();
			String[] fieldParts = StringUtils.Split(line, StringUtils.BACKTICK);
			iENs[i]=fieldParts[2];
			i++;
		}
		
		return iENs;		
	}	

	public static DataDictionaryFileField translateDataDictionaryFileFieldAttributes(
			DataDictionaryFileField field, String rtn){
		String[] lines = StringUtils.Split(rtn.trim(), StringUtils.NEW_LINE);
		String[] lineParts;
		String key, value;
		HashMap<String, String> attributes = new HashMap<String, String>();
		for(String line : lines)
		{
			lineParts = StringUtils.Split(line.trim(), StringUtils.BACKTICK);
			key = lineParts[0];
			value = lineParts[1];
			attributes.put(key, value);
		}
		if (attributes.containsKey(typeKey)
				&& pointer.equals(attributes.get(typeKey))
				&& attributes.containsKey(pointer))
		{
			value = attributes.get(pointer);
			int beginIndex = value.indexOf(openParens) + 1;
			int endIndex = value.lastIndexOf(StringUtils.COMMA);
			if (beginIndex > 0 && endIndex > 0)
			{
				field.setPointerFileNumber(value.substring(beginIndex, endIndex));
			}
		}
		return field;
	}
}
