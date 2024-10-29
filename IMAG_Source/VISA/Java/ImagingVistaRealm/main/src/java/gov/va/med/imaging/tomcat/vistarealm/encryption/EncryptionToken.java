/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 21, 2012
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
package gov.va.med.imaging.tomcat.vistarealm.encryption;

import gov.va.med.imaging.encryption.AesEncryption;
import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;
import gov.va.med.imaging.tomcat.vistarealm.VistaRealmPrincipal.AuthenticationCredentialsType;
import gov.va.med.imaging.tomcat.vistarealm.VistaRealmSecurityContext;
import gov.va.med.imaging.transactioncontext.ClientPrincipal;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.StringUtils;

import java.util.*;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class EncryptionToken
{
	// Constants
	private final static String DELIMITER = "||";
	private final static String DELIMITER_REGEX = "\\|\\|";
	private final static long EXPIRATION_TIME_MS = 86400000L; // One day
	private final static Logger LOGGER = Logger.getLogger(EncryptionToken.class);

	// Map of this token's values-*
	private EnumMap<TokenField, String> tokenValues = new EnumMap<>(TokenField.class);

	/**
	 * Construct a token with an expiration time
	 */
	public EncryptionToken() {
		// Soft expiration time
		tokenValues.put(TokenField.EXPIRATION_TIME, String.valueOf(System.currentTimeMillis() + EXPIRATION_TIME_MS));
	}

	/**
	 * Construct a token from a formatted String (see {@link #toString()}). Should not be encrypted
	 *
	 * @param tokenString The formatted string to construct a token from
	 */
	public EncryptionToken(String tokenString) {
		// Split based on our delimiter
		String[] tokens = tokenString.split(DELIMITER_REGEX);

		// Set any provided token value
		for (TokenField tokenField : TokenField.values()) {
			if (tokens.length > tokenField.ordinal()) {
				tokenValues.put(tokenField, tokens[tokenField.ordinal()]);
			}
		}
	}

	/**
	 * Returns the value for the requested TokenField or an empty string
	 *
	 * @param tokenField The field to retrieve a value for
	 * @return That field's value, or "" (empty string)
	 */
	public String getValue(TokenField tokenField) {
		String value = tokenValues.get(tokenField);
		return (value == null) ? ("") : (value);
	}

	/**
	 * Sets the value for the requested TokenField to the value provided
	 *
	 * @param tokenField The field to set the value for
	 * @param value The value for that field
	 */
	public void setValue(TokenField tokenField, String value) {
		tokenValues.put(tokenField, value);
	}

	/**
	 * Checks the expiration timeout for this token and returns true if it has not yet expired. If the token is missing
	 * or malformed this method will also return false.
	 *
	 * @return true if this token is still valid, otherwise false
	 */
	public boolean isValid() {
		// Get the string value
		String expirationString = tokenValues.get(TokenField.EXPIRATION_TIME);
		if (expirationString != null) {
			// Attempt to parse it as a long
			try {
				long value = Long.parseLong(expirationString);

				// Make sure the expiration time is still in the future
				return (System.currentTimeMillis() < value);
			} catch (Exception e) {
				return false;
			}
		}

		return false;
	}

	@Override
	public String toString() {
		// Provide a DELIMITER-concatenated string using the ordinality of the TokenField type
		StringBuilder stringBuilder = new StringBuilder();

		boolean firstToken = true;
		for (TokenField tokenField : TokenField.values()) {
			if (firstToken) {
				firstToken = false;
			} else {
				stringBuilder.append(DELIMITER);
			}

			String value = tokenValues.get(tokenField);
			if (value != null) {
				stringBuilder.append(value);
			}
		}

		return stringBuilder.toString();
	}

	public static String encryptUserCredentials() throws AesEncryptionException {
		TransactionContext transactionContext = TransactionContextFactory.get();
		return encryptUserCredentials(transactionContext.getBrokerSecurityToken());
	}

	public static String encryptUserCredentials(String securityToken) throws AesEncryptionException {
		// Generate a new token
		EncryptionToken token = new EncryptionToken();

		// Set values from the transaction context
		TransactionContext transactionContext = TransactionContextFactory.get();
		token.setValue(TokenField.FULL_NAME, transactionContext.getFullName());
		token.setValue(TokenField.DUZ, transactionContext.getDuz());
		token.setValue(TokenField.SSN, transactionContext.getSsn());
		token.setValue(TokenField.SITE_NAME, transactionContext.getSiteName());
		token.setValue(TokenField.SITE_NUMBER, transactionContext.getSiteNumber());
		token.setValue(TokenField.APPLICATION_NAME, transactionContext.getSecurityTokenApplicationName());

		// Provided security token
		token.setValue(TokenField.SECURITY_TOKEN, securityToken);

		// Intentionally left blank (non-null)
		token.setValue(TokenField.ACCESS_CODE, "");
		token.setValue(TokenField.VERIFY_CODE, "");

		// Encrypt and return the token
		return AesEncryption.encrypt(token.toString());
	}
	
	public static EncryptionToken decryptUserCredentials(String encryptedParameters) throws AesEncryptionException {
		// Decrypt the provided token
		String decryptedTokenString = AesEncryption.decodeByteArray(encryptedParameters);

		// Construct a token from it
		EncryptionToken token = new EncryptionToken(decryptedTokenString);

		// Check if the token is valid
		if (! (token.isValid())) {
			// Curiously, this exception extends AesEncryptionException
			LOGGER.info("User has provided an expired token");
			throw new TokenExpiredException("Token has expired");
		}

		// Create a principal
		ClientPrincipal principal = new ClientPrincipal(
				token.getValue(TokenField.SITE_NUMBER), true, AuthenticationCredentialsType.Password, token.getValue(TokenField.ACCESS_CODE), token.getValue(TokenField.VERIFY_CODE),
				token.getValue(TokenField.DUZ), token.getValue(TokenField.FULL_NAME), token.getValue(TokenField.SSN), token.getValue(TokenField.SITE_NUMBER), token.getValue(TokenField.SITE_NAME),
				new ArrayList<String>(),
				new HashMap<String, Object>()
		);

		// Set authenticated to false (access and verify code are always forced to blank)
		principal.setAuthenticatedByVista(false);
		VistaRealmSecurityContext.set(principal);
		
		// Override context values
		TransactionContext transactionContext = TransactionContextFactory.get(); 
		transactionContext.setBrokerSecurityApplicationName("VISTA IMAGING VIX");
		transactionContext.setBrokerSecurityToken(token.getValue(TokenField.SECURITY_TOKEN));
		transactionContext.setSecurityTokenApplicationName(token.getValue(TokenField.APPLICATION_NAME));

		// Return the created token
		return token;
	}

}
