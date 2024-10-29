/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 25, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.facade.configuration;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.encryption.AesEncryption;
import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;

import com.thoughtworks.xstream.converters.SingleValueConverter;

/**
 * @author VHAISWWERFEJ
 *
 */
public class EncryptedConfigurationPropertyStringSingleValueConverter
implements SingleValueConverter
{
	private final static Logger LOGGER = Logger.getLogger(EncryptedConfigurationPropertyStringSingleValueConverter.class);

	/* (non-Javadoc)
	 * @see com.thoughtworks.xstream.converters.ConverterMatcher#canConvert(java.lang.Class)
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public boolean canConvert(Class type)
	{
		return type.equals(EncryptedConfigurationPropertyString.class);
	}

	/* (non-Javadoc)
	 * @see com.thoughtworks.xstream.converters.SingleValueConverter#fromString(java.lang.String)
	 */
	@Override
	public EncryptedConfigurationPropertyString fromString(String arg0)
	{
		String decryptedString = null;
		
		if(arg0 == null) 
		{
			LOGGER.debug("EncryptedConfigurationPropertyStringSingleValueConverter.fromString() --> Given arg is null.  Return null.");
			return null;
		}
		
		if(!isEncrypted(arg0))
		{
			return handleUnencryptedPropertyValue(arg0);
		}
		
		try
		{
			decryptedString = AesEncryption.decodeByteArray(arg0);
		}
		catch(AesEncryptionException aesX)
		{
            LOGGER.warn("EncryptedConfigurationPropertyStringSingleValueConverter.fromString() --> Error decrypting string [{}]: {}", arg0, aesX.getMessage());
		}
		
		return new EncryptedConfigurationPropertyString(decryptedString);
	}

	/* (non-Javadoc)
	 * @see com.thoughtworks.xstream.converters.SingleValueConverter#toString(java.lang.Object)
	 */
	@Override
	public String toString(Object arg0)
	{
		if(arg0 == null)
		{
			LOGGER.debug("EncryptedConfigurationPropertyStringSingleValueConverter.toString() --> Given arg is null.  Return null.");
			return null;
		}
		
		EncryptedConfigurationPropertyString encryptedProperty = (EncryptedConfigurationPropertyString) arg0;
		
		try
		{
			return AesEncryption.encrypt(encryptedProperty.getValue());
		}
		catch(AesEncryptionException | NullPointerException aesX)
		{
            LOGGER.warn("EncryptedConfigurationPropertyStringSingleValueConverter.toString() --> Error encrypting object [{}]: {}", arg0, aesX.getMessage());
		}
		
		return null;
	}

	private EncryptedConfigurationPropertyString handleUnencryptedPropertyValue(String arg0)
	{
		EncryptedConfigurationPropertyString retVal = new EncryptedConfigurationPropertyString(arg0);
		retVal.setUnencryptedAtRest(true);
		
		return retVal;
	}

	private boolean isEncrypted(String arg0)
	{
		try
		{
			//check if value is valid base64, if not we are converting a stored unencrypted value and re-storing it
			String testDecrypt = AesEncryption.decodeByteArray(arg0);
			
			if(testDecrypt == null || testDecrypt.length() == 0)
			{
				return false;
			}
		}
		catch (AesEncryptionException | NullPointerException | IllegalArgumentException ex)
		{
            LOGGER.warn("EncryptedConfigurationPropertyStringSingleValueConverter.isEncrypted() --> Return false. Encountered exception [{}]: {}", ex.getClass().getSimpleName(), ex.getMessage());
			return false;
		}
		
		return true;
	}

}
