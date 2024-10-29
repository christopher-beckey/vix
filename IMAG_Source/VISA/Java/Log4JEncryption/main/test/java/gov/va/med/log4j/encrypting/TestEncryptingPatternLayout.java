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
package gov.va.med.log4j.encrypting;

import gov.va.med.log4j.encryption.EncryptingPatternLayout;

import java.util.regex.Matcher;

import gov.va.med.logging.Logger;

import junit.framework.TestCase;

public class TestEncryptingPatternLayout extends TestCase
{
	private Logger logger;
	
	@Override
	protected void setUp() 
	throws Exception
	{
		super.setUp();
		this.logger = Logger.getLogger(this.getClass());
	}

	public void testParameterSetting()
	{
		this.logger.warn("Hello World");
	}
	
	public void testNullMessage()
	{
		this.logger.warn("null");
	}
	
	public void testFieldFinderRegex()
	{
		Matcher fieldMatcher; 
			
		fieldMatcher = EncryptingPatternLayout.FIELD_PATTERN.matcher("%d{DATE} %5p [%t] (%F:%L) - %{des}m%n");
		fieldMatcher.find();
		assertEquals( "%{des}m", fieldMatcher.group());
		
		fieldMatcher = EncryptingPatternLayout.FIELD_PATTERN.matcher("%d{DATE} %5{des}p [%{655321}t] (%F:%L) - %{des}m%n");
		fieldMatcher.find();
		assertEquals( "%5{des}p", fieldMatcher.group());
		fieldMatcher.find();
		assertEquals( "%{655321}t", fieldMatcher.group());
		fieldMatcher.find();
		assertEquals( "%{des}m", fieldMatcher.group());
	}
	
	public void testFieldParserRegex()
	{
		Matcher fieldMatcher; 
			
		fieldMatcher = EncryptingPatternLayout.FIELD_PATTERN.matcher("%{des}m");
		assertTrue(fieldMatcher.toString(), fieldMatcher.matches());
		assertEquals( "", fieldMatcher.group(EncryptingPatternLayout.TABBING_GROUP) );
		assertEquals( null, fieldMatcher.group(EncryptingPatternLayout.NEGATION_GROUP) );
		assertEquals( null, fieldMatcher.group(EncryptingPatternLayout.FRACTIONAL_GROUP) );
		assertEquals( "{des}", fieldMatcher.group(EncryptingPatternLayout.ENCRYPTION_GROUP) );
		assertEquals( "m", fieldMatcher.group(EncryptingPatternLayout.FIELD_GROUP) );
		
		fieldMatcher = EncryptingPatternLayout.FIELD_PATTERN.matcher("%{655321}m");
		assertTrue(fieldMatcher.toString(), fieldMatcher.matches());
		assertEquals( "", fieldMatcher.group(EncryptingPatternLayout.TABBING_GROUP) );
		assertEquals( null, fieldMatcher.group(EncryptingPatternLayout.NEGATION_GROUP) );
		assertEquals( null, fieldMatcher.group(EncryptingPatternLayout.FRACTIONAL_GROUP) );
		assertEquals( "{655321}", fieldMatcher.group(EncryptingPatternLayout.ENCRYPTION_GROUP) );
		assertEquals( "m", fieldMatcher.group(EncryptingPatternLayout.FIELD_GROUP) );
		
		fieldMatcher = EncryptingPatternLayout.FIELD_PATTERN.matcher("%6{655321}m");
		assertTrue(fieldMatcher.toString(), fieldMatcher.matches());
		assertEquals( "6", fieldMatcher.group(EncryptingPatternLayout.TABBING_GROUP) );
		assertEquals( null, fieldMatcher.group(EncryptingPatternLayout.NEGATION_GROUP) );
		assertEquals( null, fieldMatcher.group(EncryptingPatternLayout.FRACTIONAL_GROUP) );
		assertEquals( "{655321}", fieldMatcher.group(EncryptingPatternLayout.ENCRYPTION_GROUP) );
		assertEquals( "m", fieldMatcher.group(EncryptingPatternLayout.FIELD_GROUP) );
		
		fieldMatcher = EncryptingPatternLayout.FIELD_PATTERN.matcher("%-6{655321}m");
		assertTrue(fieldMatcher.toString(), fieldMatcher.matches());
		assertEquals( "-6", fieldMatcher.group(EncryptingPatternLayout.TABBING_GROUP) );
		assertEquals( "-", fieldMatcher.group(EncryptingPatternLayout.NEGATION_GROUP) );
		assertEquals( null, fieldMatcher.group(EncryptingPatternLayout.FRACTIONAL_GROUP) );
		assertEquals( "{655321}", fieldMatcher.group(EncryptingPatternLayout.ENCRYPTION_GROUP) );
		assertEquals( "m", fieldMatcher.group(EncryptingPatternLayout.FIELD_GROUP) );
		
		fieldMatcher = EncryptingPatternLayout.FIELD_PATTERN.matcher("%6.5{655321}m");
		assertTrue(fieldMatcher.toString(), fieldMatcher.matches());
		assertEquals( "6.5", fieldMatcher.group(EncryptingPatternLayout.TABBING_GROUP) );
		assertEquals( null, fieldMatcher.group(EncryptingPatternLayout.NEGATION_GROUP) );
		assertEquals( ".5", fieldMatcher.group(EncryptingPatternLayout.FRACTIONAL_GROUP) );
		assertEquals( "{655321}", fieldMatcher.group(EncryptingPatternLayout.ENCRYPTION_GROUP) );
		assertEquals( "m", fieldMatcher.group(EncryptingPatternLayout.FIELD_GROUP) );

		fieldMatcher = EncryptingPatternLayout.FIELD_PATTERN.matcher("%-6.5{655321}m");
		assertTrue(fieldMatcher.toString(), fieldMatcher.matches());
		assertEquals( "-6.5", fieldMatcher.group(EncryptingPatternLayout.TABBING_GROUP) );
		assertEquals( "-", fieldMatcher.group(EncryptingPatternLayout.NEGATION_GROUP) );
		assertEquals( ".5", fieldMatcher.group(EncryptingPatternLayout.FRACTIONAL_GROUP) );
		assertEquals( "{655321}", fieldMatcher.group(EncryptingPatternLayout.ENCRYPTION_GROUP) );
		assertEquals( "m", fieldMatcher.group(EncryptingPatternLayout.FIELD_GROUP) );

	}
}
