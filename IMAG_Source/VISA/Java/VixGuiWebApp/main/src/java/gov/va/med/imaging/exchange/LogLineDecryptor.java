/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 15, 2012
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

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.Level;
import gov.va.med.logging.Logger;

/**
 * 
 * The decryptor decrypts each log line as decrypt() is called. 
 * If the log line has an encrypted field, i.e. it matches the pattern,
 * then we create a decryptor using the name in the log line and decrypt
 * field.
 * The decryptors are cached for later use, since most (usually all) of the decryption in the
 * log file should use the same decryption.
 * 
 * @author VHAISWBECKEC
 *
 */
public class LogLineDecryptor
{
	private transient Logger logger = Logger.getLogger(this.getClass());
	
	// the encrypted field pattern match depends on having BASE64 encoded encrypted field values
	// that is A-Z a-z 0-9 / +
	// If we don't use that character set for BASE64 encoding than we need to update the REGEX
	// + is 0x2B
	// / is 0x2F
	// { is ox7B
	// } is 0x7D
	private static final String DECRYPTION_PATTERN_REGEX = "\\x7B([\\w_]+)\\x7D([A-Za-z0-9+/=]+)";
	static final Pattern DECRYPTION_PATTERN = Pattern.compile(DECRYPTION_PATTERN_REGEX);
	static final int DECRYPTION_FIELD_ENCRYPTOR_GROUP = 1;
	static final int DECRYPTION_FIELD_VALUE_GROUP = 2;
	
	public static final String DEFAULT_ENCRYPTION_PACKAGE = "gov.va.med.log4j.encryption";
	
	// IMPORTANT NOTE:
	// The decryption class must have the following methods, we can't rely on the interface that declares these
	// to be available so we must use reflection to validate the decryption class and make the calls.
	// Sometime soon we should move the encrypting layout into the main code base and eliminate this ... maybe 
	// public abstract byte[] decrypt(byte[] encrypted);
	public static final String DEFAULT_DECRYPTION_METHOD_NAME = "decrypt";
	public static final Class<?>[] DECRYPTION_METHOD_PARAMETER_TYPES = new Class<?>[]{byte[].class};
	public static final Class<?> DECRYPTION_METHOD_RETURN_TYPE = byte[].class;
	// public abstract byte[] decode(String  encoded);
	public static final String DEFAULT_DECODING_METHOD_NAME = "decode";
	public static final Class<?>[] DECODING_METHOD_PARAMETER_TYPES = new Class<?>[]{String.class};
	public static final Class<?> DECODING_METHOD_RETURN_TYPE = byte[].class;
	
	// disable to avoid recursive logging
	private Boolean disableLogging = false;
	public Boolean getDisableLogging() {
		return disableLogging;
	}

	public void setDisableLogging(Boolean disableLogging) {
		this.disableLogging = disableLogging;
	}

	private void log(Level logLevel, String msg)
	{
		if (!disableLogging)
		{
			if (logLevel == Level.DEBUG) {
				logger.debug(msg);
			} else if (logLevel == Level.INFO) {
				logger.info(msg);
			} else if (logLevel == Level.WARN) {
				logger.warn(msg);
			} else if (logLevel == Level.ERROR) {
				logger.error(msg);
			} else if (logLevel == Level.FATAL) {
				logger.fatal(new Exception(msg));
			}

		}
	}
	
	/**
	 * 
	 */
	String decryptLine(final String logLine) 
	throws IllegalArgumentException, IllegalAccessException, InvocationTargetException
	{
		// couldn't be encrypted, just return it
		if(logLine == null || logLine.length() == 0)
			return logLine;
		
		StringBuilder decryptedLogLine = new StringBuilder();
		
		int startClearTextIndex = 0;
		
		// see if elements in the line match the REGEX pattern for a line with a decrypted field, and if it
		// does then decrypt it and replace it
		Matcher encryptedFieldMatcher = DECRYPTION_PATTERN.matcher(logLine);
		log(Level.DEBUG, "Finding '" + encryptedFieldMatcher.pattern().toString() + "' in '" + logLine + "'.");
		while( encryptedFieldMatcher.find() ) 
		{
			// copy the clear text between the last match (or the beginning) and the start of this match
			String interveningClearText = logLine.substring(startClearTextIndex, encryptedFieldMatcher.start());
			decryptedLogLine.append(interveningClearText);
			
			String encryptionName = encryptedFieldMatcher.group(DECRYPTION_FIELD_ENCRYPTOR_GROUP);
			String encryptedFieldValue = encryptedFieldMatcher.group(DECRYPTION_FIELD_VALUE_GROUP);
			log(Level.DEBUG, "Found encrypted field {" + encryptionName + "}" + encryptedFieldValue );
			
			DecryptorInstance decryptorInstance = getDecryptorInstance(encryptionName);
			if( decryptorInstance != null )
			{
				log(Level.DEBUG, "Found decryptor for encryption type " + encryptionName );
				String decryptedFieldValue = decryptorInstance.decodeAndDecrypt(encryptedFieldValue);
				decryptedLogLine.append(decryptedFieldValue);		// copy the decrypted text into the string builder
				log(Level.DEBUG, "Decrypted using encryption type " + encryptionName );
			}
			else
			{
				log(Level.WARN, "Unable to decrypt encryption type " + encryptionName );
				// copy the encrypted field as is, we can't decrypt it
				String encryptedFieldText = logLine.substring(encryptedFieldMatcher.start(), encryptedFieldMatcher.end());
				decryptedLogLine.append(encryptedFieldText);
			}

			// keep note of where we stopped so we can copy an clear text
			startClearTextIndex = encryptedFieldMatcher.end();
		}
		
		// copy any remaining text since the last match, or all the text if no matches
		String interveningClearText = logLine.substring(startClearTextIndex, logLine.length());
		decryptedLogLine.append(interveningClearText);

		return decryptedLogLine.toString();
	}
	
	// a simple caching mechanism so that we create 1 DecryptorInstance to
	// do all of the decryption that use the same decryptor description
	private Map<String, DecryptorInstance> decryptorMap = new HashMap<String, DecryptorInstance>();
	
	private DecryptorInstance getDecryptorInstance(String decryptorName)
	{
		DecryptorInstance decryptorInstance = decryptorMap.get(decryptorName);
		if(decryptorInstance == null)
		{
			decryptorInstance = createDecryptorInstance(decryptorName);
			if(decryptorInstance != null)
			{
				log(Level.DEBUG,"Adding " + decryptorName + " to the decryptorMap.");
				decryptorMap.put(decryptorName, decryptorInstance);
			}
		}
		return decryptorInstance;
	}
	
	/**
	 * Create an instance of a decryptor from the name found in the log file
	 */
	private DecryptorInstance createDecryptorInstance(String decryptorName) 
	{
		String decryptorClassName = decryptorName.indexOf('.') > 0 ?
			decryptorName :
			(DEFAULT_ENCRYPTION_PACKAGE + "." + decryptorName);
		
		try 
		{
			Class<?> decryptorClass = Class.forName(decryptorClassName);
			Method decryptionMethod = decryptorClass.getMethod(DEFAULT_DECRYPTION_METHOD_NAME, DECRYPTION_METHOD_PARAMETER_TYPES);
			if( DECRYPTION_METHOD_RETURN_TYPE != decryptionMethod.getReturnType())
				throw new Exception("decyption method '" + DEFAULT_DECRYPTION_METHOD_NAME + "' does not return a " + DECRYPTION_METHOD_RETURN_TYPE.getName() + " and must.");
			
			Method decodingMethod = decryptorClass.getMethod(DEFAULT_DECODING_METHOD_NAME, DECODING_METHOD_PARAMETER_TYPES);
			if( DECODING_METHOD_RETURN_TYPE != decryptionMethod.getReturnType())
				throw new Exception("decoding method '" + DEFAULT_DECRYPTION_METHOD_NAME + "' does not return a " + DECODING_METHOD_RETURN_TYPE.getName() + " and must.");
			
			return new DecryptorInstance(decryptorClass.newInstance(), decodingMethod, decryptionMethod);
		} 
		catch (Exception e) 
		{
			log(Level.ERROR, "Unable to load or create decryptor of class '" + decryptorClassName + ", encrypted fields will not be decrypted." + e.getMessage());
		}
		return null;
	}

	/**
	 * A simple value object of the Decryptor instance and the method in the decryptor
	 * to call to do the decryption.
	 * Also includes a convenience method to decode and decrypt in one step.
	 */
	private class DecryptorInstance
	{
		private Object instance;
		private Method decryptionMethod;
		private Method decodingMethod;
		
		public DecryptorInstance(Object instance, Method decodingMethod, Method decryptionMethod) {
			super();
			this.instance = instance;
			this.decodingMethod = decodingMethod;
			this.decryptionMethod = decryptionMethod;
		}

		String decodeAndDecrypt(String encodedEncryptedValue) 
		throws IllegalArgumentException, IllegalAccessException, InvocationTargetException
		{
			byte[] decoded = (byte[]) decodingMethod.invoke(instance, new Object[]{encodedEncryptedValue});
			byte[] decrypted = (byte[]) decryptionMethod.invoke(instance, new Object[]{decoded});
			if(decrypted == null)
				return "";
			String result = new String(decrypted);

			return result.trim();
		}
	}
}
