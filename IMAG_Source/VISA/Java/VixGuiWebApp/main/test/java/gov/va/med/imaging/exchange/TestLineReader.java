/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 16, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWBECKEC
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
package gov.va.med.imaging.exchange;

import static org.junit.Assert.*;

import java.io.IOException;
import java.io.InputStreamReader;

import org.junit.Test;

/**
 * @author VHAISWBECKEC
 *
 */
public class TestLineReader
{
	@Test
	public void testIsTerminator() 
	throws IOException
	{
		assertFalse( LineReader.isTerminator("\r\n".toCharArray(), 0, new char[]{0x0d, 0x0a}) );
		assertTrue( LineReader.isTerminator("\r\n".toCharArray(), 1, new char[]{0x0d, 0x0a}) );
		assertFalse( LineReader.isTerminator("Hello World \r\n".toCharArray(), 0, new char[]{0x0d, 0x0a}) );
		assertFalse( LineReader.isTerminator("Hello World\r\n".toCharArray(), 6, new char[]{0x0d, 0x0a}) );
		assertTrue( LineReader.isTerminator("Hello World\r\n".toCharArray(), 12, new char[]{0x0d, 0x0a}) );
	}
	
	@Test
	public void testLogFileRead() 
	throws IOException
	{
		LineReader lineReader = new LineReader(
			new InputStreamReader(
				getClass().getClassLoader().getResourceAsStream("ImagingExchangeWebApp.log")
			),
			new char[]{0x0D, 0x0A} );
		
		for( String line = lineReader.readLine(); line != null; line = lineReader.readLine() )
		{
			System.out.println("===================================================================================");
			System.out.println(line);
			System.out.println("===================================================================================");
		}
	}
}
