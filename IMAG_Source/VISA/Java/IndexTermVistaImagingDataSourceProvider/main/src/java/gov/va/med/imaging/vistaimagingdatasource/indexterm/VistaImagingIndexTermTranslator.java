/**
 * 
 * Date Created: Jan 20, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.vistaimagingdatasource.indexterm;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.enums.IndexTerm;
import gov.va.med.imaging.url.vista.StringUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Administrator
 *
 */
public class VistaImagingIndexTermTranslator
{

	
	public static List<IndexTermValue> translateIndexFields(String vistaResult, Site site, IndexTerm indexTerm)
	throws MethodException
	{
		List<IndexTermValue> result = new ArrayList<IndexTermValue>();
		String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
		// skip the first two lines, they are headers
		for(int i = 2; i < lines.length; i++)
		{
			String line = lines[i];
			String [] stickPieces = StringUtils.Split(line.trim(), StringUtils.STICK);
			String [] nameAbbreviationPieces = StringUtils.Split(stickPieces[0], StringUtils.CARET);
			String name = nameAbbreviationPieces[0];
			String abbreviation = nameAbbreviationPieces[1];
			String ien = abbreviation;
			if(stickPieces.length > 1)
				ien = stickPieces[1];
						
			try
			{
				IndexTermURN indexTermUrn = IndexTermURN.create(site.getSiteNumber(), indexTerm, ien);
				IndexTermValue indexFieldValue = new IndexTermValue(indexTermUrn, name, abbreviation);
				result.add(indexFieldValue);
			}
			catch(URNFormatException urnfX)
			{
				throw new MethodException(urnfX);
			}
		}
		return result;
	}
}
