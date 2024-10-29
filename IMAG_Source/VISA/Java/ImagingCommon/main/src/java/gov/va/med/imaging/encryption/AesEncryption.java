/**
 *
 Package: MAG - VistA Imaging
 WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 Date Created: Feb 7, 2012
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
package gov.va.med.imaging.encryption;

import gov.va.med.imaging.Base64;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;
import gov.va.med.logging.Logger;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Properties;

/**
 * @author VHAISWWERFEJ
 *
 */
public class AesEncryption
{
	private static final Logger LOGGER = Logger.getLogger(AesEncryption.class);

	// Session key length doubled; AES_256 requires a 32-bit length key
	private final static byte [] SESSION_KEY = "0123456789abcdef0123456789abcdef".getBytes();
	// Cipher name (should be included in Java 1.8; see https://docs.oracle.com/javase/8/docs/technotes/guides/security/StandardNames.html#Cipher)
	private final static String ALOG = "AES_256/GCM/NoPadding";
	// Encryption key spec name
	private final static String KEY_SPEC_NAME = "AES";
	// "tlen" value used for GCM key
	private static final int TLEN = 16 * 8;

	// Old algorithm values
	private final static byte [] OLD_SESSION_KEY = "0123456789abcdef".getBytes();
	private final static String OLD_ALOG = "AES";

	// Configuration (temporary for p269)
	private static Boolean useOldAlgorithm = null;
	private static final Object SYNC_OBJECT = new Object();
	private static final String PROPERTY_USE_OLD_ALGORITHM = "UseOldAlgorithm";

	public static boolean useOldAlgorithm() {
		synchronized (SYNC_OBJECT) {
			if (useOldAlgorithm == null) {
				// Get the configuration file, if one exists
				File configurationFile = getConfigurationFile();
                LOGGER.debug("[AesEncryption] - Got configuration file of \"{}\"", (configurationFile == null) ? (null) : (configurationFile.getAbsolutePath()));

				// Try to read the value or write out a new one
				if ((configurationFile != null) && (configurationFile.exists())) {
					LOGGER.debug("[AesEncryption] - Reading AesEncryption configuration file");
					try (FileInputStream fileInputStream = new FileInputStream(configurationFile)) {
						Properties properties = new Properties();
						properties.load(fileInputStream);
						useOldAlgorithm = Boolean.parseBoolean(properties.getProperty(PROPERTY_USE_OLD_ALGORITHM, "false"));
					} catch (Exception e) {
						LOGGER.warn("[AesEncryption] - Error reading AesEncryption configuration file; defaulting to \"false\"");
						useOldAlgorithm = false;
					}
				} else {
					LOGGER.debug("[AesEncryption] - Writing AesEncryption configuration file");
					try (FileWriter fileWriter = new FileWriter(configurationFile)) {
						fileWriter.write(PROPERTY_USE_OLD_ALGORITHM);
						fileWriter.write("=false\n");
						useOldAlgorithm = false;
					} catch (Exception e) {
						LOGGER.warn("[AesEncryption] - Error writing AesEncryption configuration file; defaulting to \"false\"");
						useOldAlgorithm = false;
					}
				}
			}

            LOGGER.debug("[AesEncryption] - Returning \"{}\"", useOldAlgorithm);
			return useOldAlgorithm;
		}
	}

	private static File getConfigurationFile()
	{
		String configurationDirectoryName = (System.getenv("vixconfig") == null) ? ((System.getProperty("user.home") == null) ? ("C:\\VixConfig") : (System.getProperty("user.home"))) : (System.getenv("vixconfig"));
		return new File(StringUtil.cleanString(configurationDirectoryName) + File.separator + "Aes-0.1.config");
	}

	/**
	 * encrypts and base 64 encodes the clearText string
	 * @param clearText
	 * @return
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchPaddingException
	 * @throws InvalidKeyException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 */
	public static String encrypt(String clearText)
			throws AesEncryptionException
	{
		return encryptBase(clearText, Base64.URL_SAFE);
	}

	public static String encrypt64(String clearText)
			throws AesEncryptionException
	{
		return encryptBase(clearText, 0);
	}

	private static String encryptBase(String clearText, int encoding) throws AesEncryptionException {
		return (useOldAlgorithm()) ? (oldEncryptBase(clearText, encoding)) : (newEncryptBase(clearText, encoding));
	}

	public static String oldEncryptBase(String clearText, int encoding) throws AesEncryptionException
	{

		byte [] bytes = clearText.getBytes();
		Cipher cipher = null;
		byte[] ciphertext = null;
		String encodedResult = null;

		try {
			cipher = Cipher.getInstance(StringUtil.cleanString(OLD_ALOG));
			cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(OLD_SESSION_KEY, "AES"));
			ciphertext = cipher.doFinal(bytes);
		} catch (Exception e) {
            LOGGER.error("Error encrypting value using old algorithm {}", e.getMessage());
			throw new AesEncryptionException("Error encrypting value using old algorithm", e);
		}

		encodedResult = (encoding > 0) ? (Base64.encodeBytes(ciphertext, encoding)) : (Base64.encodeBytes(ciphertext));

		return encodedResult.replace("\n", "");
	}

	public static String newEncryptBase(String clearText, int encoding)
			throws AesEncryptionException
	{

		byte [] bytes = clearText.getBytes();
		Cipher cipher = null;
		byte[] ciphertext = null;
		String encodedResult = null;

		try {
			cipher = Cipher.getInstance(StringUtil.cleanString(ALOG));
			cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(SESSION_KEY, KEY_SPEC_NAME), new GCMParameterSpec(TLEN, SESSION_KEY));
			ciphertext = cipher.doFinal(bytes);
		} catch (NoSuchAlgorithmException | NoSuchPaddingException e) {
			throw new AesEncryptionException("Exception finding AES algorithm", e);
		} catch (InvalidKeyException e) {
			throw new AesEncryptionException("Exception initializing cipher", e);
		} catch (IllegalBlockSizeException | BadPaddingException | InvalidAlgorithmParameterException e) {
			throw new AesEncryptionException("Exception during encryption", e);
		}

		if (encoding > 0)
		{
			encodedResult = Base64.encodeBytes(ciphertext, encoding);
		}
		else
		{
			encodedResult = Base64.encodeBytes(ciphertext);
		}

		encodedResult = encodedResult.replace("\n", "");
		return encodedResult;
	}

	private static String encrypt(byte[] iv, String clearText) throws AesEncryptionException {
		return (useOldAlgorithm()) ? (oldEncrypt(iv, clearText)) : (newEncrypt(iv, clearText));
	}

	public static String oldEncrypt(byte[] iv, String clearText)
			throws AesEncryptionException
	{
		byte[] bytes = clearText.getBytes();
		Cipher cipher = null;
		byte[] ciphertext = null;

		try {
			cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
			cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(OLD_SESSION_KEY, "AES"), new IvParameterSpec(iv));
			ciphertext = cipher.doFinal(bytes);
		} catch (Exception e) {
            LOGGER.error("Error decrypting value using old algorithm {}", e.getMessage());
			throw new AesEncryptionException("Error decrypting value using old algorithm", e);
		}
		return encodeByteArray(ciphertext);
	}

	/**
	 * encrypts and base 64 encodes the clearText string to be used for the AWIV
	 * @param iv which is ignored
	 * @param clearText
	 * @return
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchPaddingException
	 * @throws InvalidKeyException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 */
	private static String newEncrypt(byte[] iv, String clearText)
			throws AesEncryptionException
	{
		byte[] bytes = clearText.getBytes();
		Cipher cipher = null;
		byte[] ciphertext = null;

		try {
			cipher = Cipher.getInstance(StringUtil.cleanString(ALOG));
			cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(SESSION_KEY, KEY_SPEC_NAME), new GCMParameterSpec(TLEN, SESSION_KEY));
			ciphertext = cipher.doFinal(bytes);
		} catch (NoSuchAlgorithmException | NoSuchPaddingException e) {
			throw new AesEncryptionException("Exception finding AES algorithm", e);
		} catch (InvalidAlgorithmParameterException e) {
			throw new AesEncryptionException("Invalid algorithm parameter", e);
		} catch (InvalidKeyException e) {
			throw new AesEncryptionException("Exception initializing cipher", e);
		} catch (IllegalBlockSizeException | BadPaddingException e) {
			throw new AesEncryptionException("Exception during encryption", e);
		}
		return encodeByteArray(ciphertext);
	}

	public static byte[] getInitializationVector()
	{
		// Create a byte array holding 16 bytes
		byte[] byteArray = new byte[16];

		// Fill it with random data

		// Fortify change: use SecureRandom
		SecureRandom r = new SecureRandom();

		r.nextBytes(byteArray);

		// Convert it to a string and return it --> QN: not happening here
		return byteArray;

	}

	public static String encodeByteArray(byte[] byteArray)
	{
		String encodedResult = Base64.encodeBytes(byteArray, Base64.URL_SAFE);
		encodedResult = encodedResult.replace("\n", "");
		return encodedResult;
	}

	public static String decodeByteArray(String base64Encrypted) throws AesEncryptionException {
		// Try one, then try the other
		try {
			return newDecodeByteArray(base64Encrypted);
		} catch (Throwable t) {
			try {
				return oldDecodeByteArray(base64Encrypted);
			} catch (AesEncryptionException e) {
                LOGGER.error("Error decrypting using old algorithm (second try) {}", e.getMessage());
				throw new AesEncryptionException("Error decrypting using old algorithm (second try)", e);
			}
		}
	}

	private static String oldDecodeByteArray(String base64Encrypted) throws AesEncryptionException
	{
		byte [] encoded = Base64.decode(base64Encrypted, Base64.URL_SAFE);
		Cipher cipher = null;
		byte[] decodedText = null;

		try {
			cipher = Cipher.getInstance(StringUtil.cleanString(OLD_ALOG));
			cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(OLD_SESSION_KEY, "AES"));
			decodedText = cipher.doFinal(encoded);
		} catch (Exception e) {
            LOGGER.error("Error decoding byte array using old algorithm {}", e.getMessage());
			throw new AesEncryptionException("Error decoding byte array using old algorithm", e);
		}
		
		return new String(decodedText);
	}

	private static String newDecodeByteArray(String base64Encrypted) throws AesEncryptionException
	{
		byte [] encoded = Base64.decode(base64Encrypted, Base64.URL_SAFE);
		Cipher cipher = null;
		byte[] decodedText = null;

		try {
			cipher = Cipher.getInstance(StringUtil.cleanString(ALOG));
			cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(SESSION_KEY, KEY_SPEC_NAME), new GCMParameterSpec(TLEN, SESSION_KEY));
			decodedText = cipher.doFinal(encoded);
		} catch (NoSuchAlgorithmException | NoSuchPaddingException e) {
			throw new AesEncryptionException("Exception finding AES algorithm", e);
		} catch (InvalidKeyException e) {
			throw new AesEncryptionException("Exception initializing cipher", e);
		} catch (IllegalBlockSizeException | BadPaddingException | InvalidAlgorithmParameterException e) {
			throw new AesEncryptionException("Exception during decryption", e);
		}
		return new String(decodedText);
	}

	// default decryption with new or when unsuccessful, old algorithm
	public static String decrypt(String base64Encrypted)
			throws AesEncryptionException
	{
		return (useOldAlgorithm()) ? (decrypt(base64Encrypted, 0)) : (newEncryptBase(base64Encrypted, 1));
	}
	
	// decryption with either algorithm
	public static String decrypt(String base64Encrypted, int method)
			throws AesEncryptionException
	{
		byte [] encoded = java.util.Base64.getDecoder().decode(base64Encrypted.trim().replace("-", "+").replace("_", "/"));
		Cipher cipher = null;
		byte[] decodedText = null;

		try {
			if (method == 0) { // old method
				cipher = Cipher.getInstance(OLD_ALOG);
				cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(OLD_SESSION_KEY, KEY_SPEC_NAME));
			}
			else { // new method
				cipher = Cipher.getInstance(ALOG);
				cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(SESSION_KEY, KEY_SPEC_NAME), new GCMParameterSpec(TLEN, SESSION_KEY));
			}
			decodedText = cipher.doFinal(encoded);
		} catch (NoSuchAlgorithmException e) {
			throw new AesEncryptionException("Exception finding AES algorithm for NoSuchAlgorithmException", e);
		} catch (NoSuchPaddingException e) {
			throw new AesEncryptionException("Exception finding AES algorithm for NoSuchPaddingException", e);
		} catch (InvalidKeyException e) {
			throw new AesEncryptionException("Exception initializing cipher for InvalidKeyException", e);
		} catch (IllegalBlockSizeException e) {
			throw new AesEncryptionException("Exception during decryption for IllegalBlockSizeException", e);
		} catch (BadPaddingException e) {
			throw new AesEncryptionException("Exception during decryption for BadPaddingException", e);
		} catch (InvalidAlgorithmParameterException e) {
			throw new AesEncryptionException("Exception during decryption for InvalidAlgorithmParameterException", e);
		}
		return new String(decodedText);
	}

}
