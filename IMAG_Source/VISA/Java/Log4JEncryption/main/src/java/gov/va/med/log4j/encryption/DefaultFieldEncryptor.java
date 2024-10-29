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

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.Charset;
import java.security.InvalidKeyException;
import java.security.Key;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Properties;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.ShortBufferException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class DefaultFieldEncryptor implements FieldEncryptor {	
	
	private String transformation;
	private Key	key;
	private Cipher encryptionCipher = null;
	private Cipher decryptionCipher = null;
	private Charset charset;
	
	private final static String DEFAULT_ALGORITHM = "AES";
	private final static String DEFAULT_TRANSFORMATION = "AES/CBC/PKCS5Padding";
	private final static byte[] DEFAULT_KEY_DATA = 
	{ (byte)-2, (byte)-88, (byte)-14, (byte)59, (byte)-111, (byte)-118, (byte)-42, (byte)100 };
	
	private static byte[] iv = new byte[16];
	private final static SecureRandom random = new SecureRandom();

	private static IvParameterSpec ivSpec;
	private static int ivSize = 16;
	
	public synchronized void setTransformation(String transformation)
	{
		this.transformation = transformation;
		this.encryptionCipher = null;
		this.decryptionCipher = null;
	}
	
	public synchronized String getTransformation()
	{
		if(this.transformation == null)
			this.transformation = DEFAULT_TRANSFORMATION;
		return this.transformation;
	}

	public synchronized String getAlgorithm()
	{
		return getTransformation().split("/")[0];
	}

	public synchronized Key getKey() throws Exception {

		if(this.key == null) 
			try
			{
				key = getDefaultKey();
			}
			catch (InvalidKeyException e)
			{
				e.printStackTrace();
			}
			catch (InvalidKeySpecException e)
			{
				e.printStackTrace();
			}
			catch (NoSuchAlgorithmException e)
			{
				e.printStackTrace();
			}			
			
		return key;
	}
	
	public synchronized void setKey(Key key)
	{
		this.key = key;
		this.encryptionCipher = null;
		this.decryptionCipher = null;
	}

	private Key getDefaultKey() 
	throws InvalidKeySpecException, InvalidKeyException, NoSuchAlgorithmException
	{
		MessageDigest digest = null;
		digest = MessageDigest.getInstance("SHA-256");
		digest.update(DEFAULT_KEY_DATA);
		byte[] keyBytes = new byte[16];
		System.arraycopy(digest.digest(), 0, keyBytes, 0, keyBytes.length);		
		SecretKeySpec keySpec = new SecretKeySpec(keyBytes, DEFAULT_ALGORITHM);
		return keySpec;
	}
	
	@Override
	public synchronized Charset getCharset()
	{
		if(this.charset == null)
			this.charset = Charset.defaultCharset();
		
		return charset;
	}
	@Override
	public synchronized void setCharset(Charset charset)
	{
		this.charset = charset;
	}
	
	public byte[] encrypt(byte[] input) {
		
		try {
			//Generating IV
		    random.nextBytes(iv);
			ivSpec = new IvParameterSpec(iv);

			// Encryption
			byte[] encrypted = new byte[getEncryptionCipher().getOutputSize(input.length)];
			int encryptedLength = getEncryptionCipher().update(input, 0, input.length, encrypted, 0);
			encryptedLength += getEncryptionCipher().doFinal(encrypted, encryptedLength);

			// Combine IV and encrypted part.
	        byte[] encryptedIVAndText = new byte[ivSize + encryptedLength];
	        System.arraycopy(iv, 0, encryptedIVAndText, 0, ivSize);
	        System.arraycopy(encrypted, 0, encryptedIVAndText, ivSize, encryptedLength);

	        return encryptedIVAndText;
	        
		}
		catch (ShortBufferException e)
		{
			e.printStackTrace();
		}
		catch (IllegalBlockSizeException e)
		{
			e.printStackTrace();
		}
		catch (BadPaddingException e)
		{
			e.printStackTrace();
		}
		
		return null;
	}
	
    public byte[] decrypt(byte[] encrypted) {
    	
    	try {
    		// Extract IV
            iv = new byte[ivSize];
            System.arraycopy(encrypted, 0, iv, 0, iv.length);
            ivSpec = new IvParameterSpec(iv);
        	
            // Extract encrypted part.
            int encryptedSize = encrypted.length - ivSize;
            byte[] encryptedBytes = new byte[encryptedSize];
            System.arraycopy(encrypted, ivSize, encryptedBytes, 0, encryptedSize);
            byte[] decrypted = getDecryptionCipher().doFinal(encryptedBytes);

			return decrypted;
		}
		catch (IllegalBlockSizeException e)
		{
			e.printStackTrace();
		}
		catch (BadPaddingException e)
		{
			e.printStackTrace();
		}
		
		return null;
	}

	@Override
	public String encode(byte[] encrypted)
	{
		return Base64.encodeBytes(encrypted);
	}
	
	@Override
	public byte[] decode(String encoded)
	{
		return Base64.decode(encoded);
	}

	private synchronized Cipher getEncryptionCipher()
	{
		if(this.encryptionCipher == null)
		{
			try
			{
				this.encryptionCipher = Cipher.getInstance(getTransformation());
				this.encryptionCipher.init(Cipher.ENCRYPT_MODE, getKey(), ivSpec);
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}
		return this.encryptionCipher;
	}
	
	private synchronized Cipher getDecryptionCipher()
	{
		if(this.decryptionCipher == null)
		{
			try
			{
				this.decryptionCipher = Cipher.getInstance(getTransformation());
				this.decryptionCipher.init(Cipher.DECRYPT_MODE, getKey(), ivSpec);
			}
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}
		return this.decryptionCipher;
	}
	
	/**
	 * 
	 * @param argv
	 */
	//public static void main(String[] argv)
	//{
	//	KeyGenerator kgen;
	//	try
	//	{
	//		kgen = KeyGenerator.getInstance("DES");
	  //      SecretKey skey = kgen.generateKey();
	    //    
	//        byte[] raw = skey.getEncoded();
	//        
    //    	System.out.println( "Start of key");
	//        for(byte rawByte : raw)
	//        	System.out.print( rawByte + " ");
    //    	System.out.println( "\r\nEnd of key");

    //		DESKeySpec keySpec = new DESKeySpec(raw);
    //		SecretKeyFactory keyFactory = SecretKeyFactory.getInstance("DES");
    //		SecretKey secretKey = keyFactory.generateSecret(keySpec);
		
    		
	//	}
	//	catch (Exception e)
	//	{
	//		e.printStackTrace();
	//	}
	//}
}
