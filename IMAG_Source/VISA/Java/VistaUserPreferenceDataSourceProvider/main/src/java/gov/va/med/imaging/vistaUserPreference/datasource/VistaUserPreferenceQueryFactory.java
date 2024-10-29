/**
 * 
 * Date Created: Jul 28, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.vistaUserPreference.datasource;

import java.text.DecimalFormat;
import java.util.HashMap;

import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;

/**
 * @author Budy Tjahjo
 *
 */
public class VistaUserPreferenceQueryFactory
{
	
	public static VistaQuery createGetUserPreferenceQuery(
			String entity, 
			String key)
	{
		VistaQuery query = new VistaQuery("MAGN PARAM GET VALUE");

		HashMap<String, String> parameters = new HashMap<String, String>();
		
		parameters.put("\"" + "INSTANCE" + "\"", key);
		parameters.put("\"" + "ENTITY" + "\"", entity);

		query.addParameter(VistaQuery.LIST, parameters);

		return query;
	}
	
	public static VistaQuery createPostUserPreferenceQuery(String entity, String key, String value)
	{
		VistaQuery query = new VistaQuery("MAGN PARAM SET LIST");
		
		HashMap<String, String> parameters = new HashMap<String, String>();
		
		parameters.put("\"" + "ENTITY" + "\"", entity);
		parameters.put("\"" + "INSTANCE001" + "\"", key);
		parameters.put("\"" + "VALUE001" + "\"", "");

		DecimalFormat nf = new DecimalFormat("#000000");
		String[] valArray = StringUtils.Split(value, StringUtils.NEW_LINE);

		int lineCount = 0;
		for (String val: valArray)
		{
			lineCount++;
			parameters.put("\"" + "VALUE001_" + nf.format(lineCount) + "\"", val);
		}

		query.addParameter(VistaQuery.LIST, parameters);
		
		return query;
	}
	
	public static VistaQuery createDeleteUserPeferenceQuery(String entity, String key)
	{
		VistaQuery query = new VistaQuery("MAGN PARAM SET LIST");
		
		HashMap<String, String> parameters = new HashMap<String, String>();
		
		parameters.put("\"" + "ENTITY" + "\"", entity);
		parameters.put("\"" + "INSTANCE001" + "\"", key);
		parameters.put("\"" + "VALUE001" + "\"", "@");

		query.addParameter(VistaQuery.LIST, parameters);
		
		return query;
	}
	
	
	public static VistaQuery createGetUserPreferenceKeysQuery(String entity)
	{
		VistaQuery query = new VistaQuery("MAGN PARAM GET LIST");
		HashMap<String, String> parameters = new HashMap<String, String>();
		
		//parameters.put("\"" + "USER" + "\"", userID);
		parameters.put("\"" + "ENTITY" + "\"", entity);

		query.addParameter(VistaQuery.LIST, parameters);

		return query;
	}
	

}
