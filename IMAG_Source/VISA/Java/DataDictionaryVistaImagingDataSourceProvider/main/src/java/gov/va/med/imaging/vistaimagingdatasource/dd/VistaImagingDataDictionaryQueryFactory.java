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
 * @author VHAISWWERFEJ
 *
 */
public class VistaImagingDataDictionaryQueryFactory
{
	private final static String RPC_MAGDDR_LISTER = "MAGDDR LISTER";
	private final static String RPC_MAGDDR_GETS_ENTRY_DATA = "MAGDDR GETS ENTRY DATA";
	
	private final static String filesFile = "1";
	
	public static VistaQuery createGetEntryValue(DataDictionaryEntryQuery dataDictionaryEntryQuery)
	{
		VistaQuery query = new VistaQuery(RPC_MAGDDR_GETS_ENTRY_DATA);
		Map<String, String> parameters = new HashMap<String, String>();
		String fields = getFieldsString(dataDictionaryEntryQuery.getFields());
		parameters.put("\"FILE\"", dataDictionaryEntryQuery.getFileNumber());
		parameters.put("\"FIELDS\"", fields);
		parameters.put("\"IENS\"", dataDictionaryEntryQuery.getIen() + ",");
		//parameters.put("\"OPTIONS\"", "U?");//.01;99");
		// I=internal, E=External - getting both right now
		parameters.put("\"FLAGS\"", "IE");//.01;99");
		
		query.addParameter(VistaQuery.LIST, parameters);
		return query;
	}
	
	public static VistaQuery createGetFilesQuery()
	{
		VistaQuery query = new VistaQuery(RPC_MAGDDR_LISTER);
		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("\"FILE\"", filesFile);			
		parameters.put("\"FIELDS\"", ".01");
		
		query.addParameter(VistaQuery.LIST, parameters);
		return query;
	}
	
	public static VistaQuery createDDRListerQuery(DataDictionaryQuery dataDictionaryQuery)
	{
		VistaQuery query = new VistaQuery(RPC_MAGDDR_LISTER);
		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("\"FILE\"", dataDictionaryQuery.getFileNumber());
		
		String fields = getFieldsString(dataDictionaryQuery.getFields());
		
		parameters.put("\"FIELDS\"", fields);
		if(dataDictionaryQuery.isMaxSpecified())
			parameters.put("\"MAX\"", dataDictionaryQuery.getMaximumResults() + "");
		if(dataDictionaryQuery.isMoreParameterSpecified())
			parameters.put("\"FROM\"", dataDictionaryQuery.getMoreParameter());
		
		query.addParameter(VistaQuery.LIST, parameters);
		return query;
	}
	
	private static String getFieldsString(String [] fieldsArray)
	{
		String delimiter = "";
		StringBuilder fields = new StringBuilder();
		for(String field : fieldsArray)
		{
			fields.append(delimiter);
			fields.append(field);
			delimiter = ";";
		}
		return fields.toString();
	}

}
