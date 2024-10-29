/**
 * Copyright 2012 ISI Group, LLC
 */
package gov.va.med.imaging.configuration;

import gov.va.med.imaging.encryption.AesEncryption;
import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;

import gov.va.med.logging.Logger;

import com.thoughtworks.xstream.converters.SingleValueConverter;

/**
 * This converted checsk for EncryptedString properties and encrypts/decrypts them
 * 
 * @author jwerfel
 *
 */
public class EncryptedStringSingleValueConverter 
implements SingleValueConverter
{
	private final static Logger LOGGER = Logger.getLogger(EncryptedStringSingleValueConverter.class);

	@SuppressWarnings("rawtypes" )
	@Override
	public boolean canConvert(Class type) 
	{
		return type.equals(EncryptedString.class);
	}

	@Override
	public Object fromString(String arg0) 
	{
		String decrypted = null;
		
		try
		{
			decrypted = AesEncryption.decodeByteArray(arg0);
		}
		catch(AesEncryptionException eX)
		{
            LOGGER.warn("EncryptedStringSingleValueConverter.fromString() --> Error decrypting string [{}]: {}", arg0, eX.getMessage());
		}
		
		return new EncryptedString(decrypted);
	}

	@Override
	public String toString(Object arg0) 
	{
		
		EncryptedString es = (EncryptedString)arg0;
		
		try
		{
			return AesEncryption.encrypt(es.getValue());
		}
		catch(AesEncryptionException eX)
		{
            LOGGER.error("EncryptedStringSingleValueConverter.toString() --> Error encrypting string [{}]: {}", es.getValue(), eX.getMessage());
		}
		
		return null;
	}

}
