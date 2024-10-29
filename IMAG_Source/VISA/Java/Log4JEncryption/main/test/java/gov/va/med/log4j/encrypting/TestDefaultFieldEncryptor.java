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

import java.io.UnsupportedEncodingException;

import gov.va.med.log4j.encryption.DefaultFieldEncryptor;
import gov.va.med.log4j.encryption.FieldEncryptor;
import junit.framework.TestCase;

/**
 * @author VHAISWBECKEC
 *
 */
public class TestDefaultFieldEncryptor 
extends TestCase
{
	private DefaultFieldEncryptor fieldEncryptor;
	
	@Override
	protected void setUp() 
	throws Exception
	{
		super.setUp();
		this.fieldEncryptor = new DefaultFieldEncryptor();
	}
	
	public DefaultFieldEncryptor getFieldEncryptor()
	{
		return fieldEncryptor;
	}

	public void testEncryptionDecryption()
	{
		byte[] bytes = getFieldEncryptor().decode("Hello World");
		encryptDecryptAndCompare(bytes);
	}
	
	private void encryptDecryptAndCompare(byte[] cleartextBytes)
	{
		byte[] encryptedBytes = getFieldEncryptor().encrypt(cleartextBytes);
		byte[] decryptedBytes = getFieldEncryptor().decrypt(encryptedBytes);
	
		for(int index=0; index < cleartextBytes.length; ++index)
			assertEquals(cleartextBytes[index], decryptedBytes[index]);
	}
	
	public void testEncodingDecoding()
	{
		encodeDecodeAndCompare(new byte[]{0x01, 0x11, (byte)0x80, (byte)0x80});
	}
	
	private void encodeDecodeAndCompare(byte[] value)
	{
		String encoded = getFieldEncryptor().encode(value);
		byte[] decoded = getFieldEncryptor().decode(encoded);
		
		for(int index = 0; index < value.length; ++index)
			assertEquals(encoded,  value[index], decoded[index]);
	}
	
	public void testAssumptions() 
	throws UnsupportedEncodingException
	{
		assertEquals( "Hello World", new String("Hello World".getBytes("UTF8"), "UTF8") );
	}
}
