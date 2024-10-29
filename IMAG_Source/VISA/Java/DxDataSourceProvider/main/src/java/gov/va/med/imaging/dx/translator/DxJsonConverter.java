package gov.va.med.imaging.dx.translator;

import java.util.List;
import java.util.ArrayList;

import gov.va.med.logging.Logger;
import org.json.*;

import gov.va.med.WellKnownOID;
import gov.va.med.imaging.dx.DesPollerData;
import gov.va.med.imaging.dx.DesPollerResult;
import gov.va.med.imaging.url.vista.StringUtils;

public class DxJsonConverter
{
	private static final Logger LOGGER = Logger.getLogger(DxJsonConverter.class);	

	public static String ConvertJsonDpasQueryResult(String jsonResponse)
	{
		String result = null;
		
		try 
		{
		     JSONObject obj = new JSONObject(jsonResponse);
		     result = (String) obj.get("queryid");
		}
		catch (JSONException je) {
            LOGGER.warn("DxJsonConverter.ConvertJsonDpasQueryResult() --> response JSON data object error: {}", je.getMessage());
		}
		
		return result;
	}
	
	public static DesPollerResult ConvertJsonDpasPollerResult(String jsonResponse, String ipAddress) 
	{
		DesPollerResult desPollerResult = new DesPollerResult();
		try 
		{
		    JSONObject obj = new JSONObject(jsonResponse);
		    JSONObject objDataList = obj.getJSONObject("dataList");
		    JSONArray objDocuments = objDataList.getJSONArray("documents");

            LOGGER.debug("DxJsonConverter.ConvertJsonDpasQueryResult() --> objDocuments size [{}]", objDocuments.length());
		    
		    for (int i = 0; i < objDocuments.length(); i++)
		    {
		    	JSONObject objDoc = objDocuments.getJSONObject(i);
		    	
		    	JSONArray dataDomain = objDoc.getJSONArray("dataDomain");
		    	String originId = getJSONArrayValue(dataDomain,"system");
		    	
			    String strEnteredDate = "";
			    if (objDoc.has("enteredDate"))
			    {
			    	JSONObject enteredDate = objDoc.getJSONObject("enteredDate");
			    	strEnteredDate = getJSONObjectValue(enteredDate, "start");
			    }

			    String strFacility = "";
			    if (objDoc.has("facility"))
			    {
			    	JSONObject facility = objDoc.getJSONObject("facility");
			    	strFacility = getJSONObjectValue(facility, "name");
			    }
		    	
		    	String strContentType = "";
			    if (objDoc.has("contentType"))
			    {
			    	JSONArray contentType = objDoc.getJSONArray("contentType");
			    	strContentType = getJSONArrayValue(contentType,"code");
			    }
		    	
			    String strDescr = "";
			    String clinicalType = "";
			    if (objDoc.has("type"))
			    {
			    	JSONArray descr = objDoc.getJSONArray("type");
			    	strDescr = getJSONArrayValue(descr,"display");
			    	clinicalType = getJSONArrayValue(descr,"code");
			    }
			    
			    String title = "";
		    	if (objDoc.has("title"))
			    {
		    		title = objDoc.getString("title");
			    }
		    	
		    	//Use this wellknown hcid rather than the real DES hcid so that VIX can recognize it a valid hcid. 
	    		String homeCommunityId = WellKnownOID.HAIMS_DOCUMENT.getCanonicalValue().toString(); 
				
		    	JSONObject recordId = objDoc.getJSONObject("recordId");
		    	String strRecordId = getJSONObjectValue(recordId, "id");
		    	String documentId = strRecordId + "-" + ipAddress;
				documentId = documentId.replace('^', '_');

	    		String repositoryId = getJSONObjectValue(recordId, "assigningAuthority");
	    		
		    	String content = "";
	    		if (objDoc.has("complexDataUrl"))
			    {
		    		content = StringUtils.Piece(objDoc.getString("complexDataUrl"),"/",9);
		    		content = StringUtils.Piece(content,"?requestSource",1);
			    }
		    	
		    	Integer size = 0;
		    	if (objDoc.has("size"))
		    	{
		    		size = (int) objDoc.getLong("size");
		    	}
		    	
		    	DesPollerData data = new DesPollerData();
		    	data.setTitle(title);
		    	data.setDescription(strDescr);
		    	data.setContent(content);
		    	data.setContentType(strContentType);
		    	data.setRecordId(strRecordId);
		    	data.setRepositoryId(repositoryId);
		    	data.setDocumentId(documentId);
		    	data.setFacilityId(strFacility);
		    	data.setEnteredDate(strEnteredDate);
		    	data.setSize(size);
		    	data.setHomeCommunityId(homeCommunityId);
		    	data.setClinicalType(clinicalType);
				data.setOriginId(originId);
		    	
		    	desPollerResult.addRecord(data);
		    }
			
			return desPollerResult;
		}
		catch (JSONException je) {
            LOGGER.warn("DxJsonConverter.ConvertJsonDpasPollerResult() --> response JSON data object error: {}", je.getMessage());
			return null;
		}
	}
	
	private static String getJSONStringValueList(List<String> result)
	{
	    if (result.size() == 1)
	    {
	    	return result.get(0);
	    }
	    else
	    {
	    	String jsonArray="[";
		    for (int i = 0; i < result.size(); i++) {
		    	jsonArray += result.get(i);
		    	if ((i>0) && (i<(result.size()-1)))
		    		jsonArray += ",";
		    }
	    	return jsonArray + "]";
	    }	
	}
	
	private static String getJSONArrayValue(JSONArray contentType, String attr) {
	    List<String> result = new ArrayList<String>();
	    
		for (int i = 0; i < contentType.length(); i++)
	    {
	    	try {
				JSONObject obj = contentType.getJSONObject(i);
				result.add(obj.getString(attr));
			} catch (JSONException e) {
                LOGGER.error("JSON Exception error: {}", e.getMessage());
			}
	    }
	    
	    return getJSONStringValueList(result);
	}

	private static String getJSONObjectValue(JSONObject obj, String attr) {
		try {
			return obj.getString(attr);
		} catch (JSONException e) {
			return null;
		}
	}

	public static Boolean isPollerCompleted(String jsonResponse) {
		try 
		{
		    JSONObject obj = new JSONObject(jsonResponse);
		    if (!obj.has("queryComplete"))
		    	return false;
		    
			Object isCompleted = obj.get("queryComplete");

			if ((isCompleted instanceof JSONString) || (isCompleted instanceof String)) 
			{
				String strCompleted = obj.getString("queryComplete");
				return (strCompleted.equals("1") || strCompleted.equals("true") ? true : false);
			}
			else if (isCompleted instanceof Integer)
			{
				int intCompleted = obj.getInt("queryComplete");
				return intCompleted == 1;
			}
			else if (isCompleted instanceof Boolean)
			{
				return obj.getBoolean("queryComplete");
			}
			else
			{
				return false;
			}
		}
		catch (JSONException je) {
            LOGGER.debug("DxJsonConverter.isPollerCompleted() --> response JSON data object error: {}", je.getMessage());
			return null;
		}
	}

	private static String urlSplit(String url, String prop) {
		String res = "";
		
		String[] props = url.split(prop + "=");
		if (props.length > 1) {
			res = props[1];
		}
		
		props = res.split("&");
		if (props.length > 1) {
			res = props[0];
		}
		
		props = res.split("\\?");
		if (props.length > 1) {
			res = props[0];
		}
		
		return res;
	}
}

