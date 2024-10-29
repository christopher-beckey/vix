/**
 * Per VHA Directive 2004-038, this routine should not be modified.
 * Property of the US Government.  No permission to copy or redistribute this software is given. 
 * Use of unreleased versions of this software requires the user to execute a written agreement 
 * with the VistA Imaging National Project Office of the Department of Veterans Affairs.  
 * Please contact the National Service Desk at(888)596-4357 or vhaistnsdtusc@va.gov in order to 
 * reach the VistA Imaging National Project office.
 * 
 * The Food and Drug Administration classifies this software as a medical device.  As such, it 
 * may not be changed in any way.  Modifications to this software may result in an adulterated 
 * medical device under 21CFR, the use of which is considered to be a violation of US Federal Statutes.
 * 
 * Federal law restricts this device to use by or on the order of either a licensed practitioner or persons 
 * lawfully engaged in the manufacture, support, or distribution of the product.
 * 
 * Created: Mar 8, 2012
 * Author: VHAISWBECKEC
 */
package gov.va.med.log4j.encryption;

public enum PatternLayoutField
{
	CATEGORY('c'),
	CLASSNAME('C'),
	DATE('d'),
	FILENAME('F'),
	LOCATION('l'),
	LINENUMBER('L'),
	MESSAGE('m'),
	METHOD('M'),
	LINESEPERATOR('n'),
	PRIORITY('p'),
	ELAPSED('r'),
	THREAD('t'),
	NDC('x'),
	MDC('X');
	
	
	private char fieldChar;
	PatternLayoutField(char fieldChar)
	{
		this.fieldChar = fieldChar;
	}
	
	public static PatternLayoutField findByFieldChar(char fieldChar)
	{
		for( PatternLayoutField patternLayoutField : PatternLayoutField.values() )
			if(patternLayoutField.fieldChar == fieldChar)
				return patternLayoutField;
		
		return null;
	}
}
