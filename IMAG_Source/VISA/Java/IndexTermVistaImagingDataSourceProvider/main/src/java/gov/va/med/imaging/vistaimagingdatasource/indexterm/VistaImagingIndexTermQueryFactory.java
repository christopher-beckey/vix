/**
 * 
 * Date Created: Jan 20, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.vistaimagingdatasource.indexterm;

import java.util.List;

import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.enums.IndexClass;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;

/**
 * @author Administrator
 *
 */
public class VistaImagingIndexTermQueryFactory
{
	public static VistaQuery createGetOriginIndexQuery()
	{
		VistaQuery vistaQuery = new VistaQuery("MAG4 INDEX GET ORIGIN");		
		return vistaQuery;
	}
	
	public static VistaQuery createGetSpecialtyIndexQuery(List<IndexClass> indexClasses,
		List<IndexTermURN> eventUrns)
	{
		VistaQuery vistaQuery = new VistaQuery("MAG4 INDEX GET SPECIALTY");
		vistaQuery.addParameter(VistaQuery.LITERAL, getClassString(indexClasses));
		vistaQuery.addParameter(VistaQuery.LITERAL, getStringList(eventUrns, StringUtils.COMMA));
		// ;  FLGS : An '^' delimited string
		// ;     1 IGN: Flag to IGNore the Status field
		// ;     2 INCL: Include Class in the Output string
		// ;     3 INST: Include Status in the Output String
		// ;     4 INSP: Include Specialty in the OutPut String 		
		vistaQuery.addParameter(VistaQuery.LITERAL, "0^0^0^0");
		return vistaQuery;
	}
	
	public static VistaQuery createProcedureEventsIndexQuery(List<IndexClass> indexClasses,
		List<IndexTermURN> specialtyUrns)
	{
		VistaQuery vistaQuery = new VistaQuery("MAG4 INDEX GET EVENT");
		vistaQuery.addParameter(VistaQuery.LITERAL, getClassString(indexClasses));
		vistaQuery.addParameter(VistaQuery.LITERAL, getStringList(specialtyUrns, StringUtils.COMMA));
		return vistaQuery;
	}
	
	public static VistaQuery createTypesIndexQuery(List<IndexClass> indexClasses)
	{
		VistaQuery vistaQuery = new VistaQuery("MAG4 INDEX GET TYPE");
		vistaQuery.addParameter(VistaQuery.LITERAL, getClassString(indexClasses));
		return vistaQuery;
	}
	
	private static String getClassString(List<IndexClass> indexClasses)
	{
		if(indexClasses == null)
			return "";
		StringBuilder sb = new StringBuilder();
		String prefix = "";
		for(IndexClass indexClass : indexClasses)
		{
			sb.append(prefix);
			sb.append(indexClass.getValue());
			prefix=",";
		}
		
		return sb.toString();
	}
	
	private static String getStringList(List<IndexTermURN> urns, String delimiter)
	{
		if(urns == null)
			return "";
		StringBuilder sb = new StringBuilder();
		String prefix = "";
		for(IndexTermURN urn : urns)
		{
			sb.append(prefix);
			sb.append(urn.getFieldId());
			prefix= delimiter;
		}
		return sb.toString();
	}
}
