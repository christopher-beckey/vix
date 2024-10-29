/**
 * 
 * Date Created: Jan 24, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.indexterm.rest.translator;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.URNFactory;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.enums.IndexClass;
import gov.va.med.imaging.indexterm.rest.types.IndexTermValueType;
import gov.va.med.imaging.indexterm.rest.types.IndexTermValuesType;
import gov.va.med.imaging.tomcat.vistarealm.StringUtils;

/**
 * @author Julian Werfel
 *
 */
public class IndexTermRestTranslator
{
	private final static Logger logger = Logger.getLogger(IndexTermRestTranslator.class);
	
	public static IndexTermValuesType translateIndexTerms(List<IndexTermValue> indexTerms)
	{
		if(indexTerms == null)
			return null;
		IndexTermValueType [] result = new IndexTermValueType[indexTerms.size()];
		
		for(int i = 0; i < indexTerms.size(); i++)
		{
			result[i] = translate(indexTerms.get(i));
		}
		
		return new IndexTermValuesType(result);
		
	}
	
	private static IndexTermValueType translate(IndexTermValue value)
	{
		IndexTermValueType type = new IndexTermValueType(value.getIndexTermUrn().toString(), 
				value.getName(), 
				value.getAbbreviation());
		
		type.setSiteVixUrl(value.getSiteVixUrl());
		
		return type;
	}
	
	public static List<IndexClass> toIndexClasses(String classes)
	{
		List<IndexClass> result = new ArrayList<IndexClass>();
		if(classes == null)
			return result;
		String [] classNames =  StringUtils.Split(classes,  StringUtils.COMMA);
		for(String className : classNames)
		{
			IndexClass indexClass = IndexClass.fromValue(className);
			if(indexClass != null)
				result.add(indexClass);
			else
                logger.warn("Could not map [{}] to index class", className);
		}
		return result;
	}
	
	public static List<String> toString(String commaSeparatedValues)
	{
		List<String> result = new ArrayList<String>();
		if(commaSeparatedValues == null)
			return result;
		String [] pieces = StringUtils.Split(commaSeparatedValues, StringUtils.COMMA);
		for(String piece : pieces)
		{
			result.add(piece);
		}
		return result;
	}
	
	public static List<IndexTermURN> toURNs(String commaSeparatedValues)
	throws MethodException
	{
		List<IndexTermURN> result = new ArrayList<IndexTermURN>();
		if(commaSeparatedValues == null)
			return result;
		String [] pieces = StringUtils.Split(commaSeparatedValues, StringUtils.COMMA);
		for(String piece : pieces)
		{
			try
			{
				IndexTermURN urn = URNFactory.create(piece, IndexTermURN.class);
				result.add(urn);
			}
			catch(URNFormatException urnfX)
			{
				throw new MethodException(urnfX);
			}
		}
		return result;	
	}

}
