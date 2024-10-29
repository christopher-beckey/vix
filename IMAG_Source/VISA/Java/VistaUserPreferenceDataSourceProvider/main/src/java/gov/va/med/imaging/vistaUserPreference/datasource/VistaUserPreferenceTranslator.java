/**
 * 
 * Date Created: Jul 28, 2017
 * Developer: vhaisltjahjb
 */
package gov.va.med.imaging.vistaUserPreference.datasource;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.url.vista.StringUtils;


/**
 * @author Budy Tjahjo
 *
 */
public class VistaUserPreferenceTranslator
{
	public static List<String> getUserPreferenceKeys(String vistaResult)
	{
		List<String> rows = new ArrayList<String>();
		String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);

		for(int i = 1; i < lines.length; i++)
		{
			String [] key = StringUtils.Split(lines[i], "^");
			rows.add(key[0]);
		}
		
		return rows;
	}

}
