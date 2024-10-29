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
import java.util.Map;

import gov.va.med.imaging.exchange.business.dd.DataDictionaryEntryQuery;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryQuery;
import gov.va.med.imaging.url.vista.VistaQuery;

/**
 * @author VHAISWTITTOC
 *
 */
public class VistaImagingFileManQueryFactory
{
	private final static String RPC_FILEMAN_FIELD_LIST = "MAG FILEMAN FIELD LIST"; // generic FM Lister
	private final static String RPC_FILEMAN_FIELD_ATTS = "MAG FILEMAN FIELD ATTS"; // generic FM ATTS of a field	
	private final static String RPC_SEARCH_BY_ATTR = "MAGV SEARCH BY ATTRIBUTE"; // generic Query RPC
	
	private final static String input_separator = "`";
	private final static String output_separator = "|";
	
	public static VistaQuery createGetFileManFieldsQuery(String fileNum)
	{
		VistaQuery query = new VistaQuery(RPC_FILEMAN_FIELD_LIST);
		query.addParameter(VistaQuery.LITERAL, fileNum);
		query.addParameter(VistaQuery.LITERAL, "N"); // numericOrder? flag
		return query;
	}
	
	public static VistaQuery createFileManAttributesQuery(String fileNumber, String fieldNumber)
	{
		VistaQuery query = new VistaQuery(RPC_FILEMAN_FIELD_ATTS);
		query.addParameter(VistaQuery.LITERAL, fileNumber);
		query.addParameter(VistaQuery.LITERAL, fieldNumber); 
		return query;
	}
	
	public static VistaQuery createGetFileManEntryByValue(String fileNumber, String keyName, String keyValue)
	{
		VistaQuery query = new VistaQuery(RPC_SEARCH_BY_ATTR);
		query.addParameter(VistaQuery.LITERAL, fileNumber);
		HashMap <String, String> hm = new HashMap <String, String>();
		hm.put("1", keyName + input_separator + keyValue);
//		hm.put("2", keyName2 + input_separator + keyValue2);
		query.addParameter(VistaQuery.LIST, hm);
		return query;
	}

	
//	private static String getFieldsString(String [] fieldsArray)
//	{
//		String delimiter = "";
//		StringBuilder fields = new StringBuilder();
//		for(String field : fieldsArray)
//		{
//			fields.append(delimiter);
//			fields.append(field);
//			delimiter = ";";
//		}
//		return fields.toString();
//	}

}
