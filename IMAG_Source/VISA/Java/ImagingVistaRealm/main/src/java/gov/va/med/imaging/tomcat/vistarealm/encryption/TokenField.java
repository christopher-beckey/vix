package gov.va.med.imaging.tomcat.vistarealm.encryption;

/**
 * Enumeration type providing an ordered list of components in a security token (see {@link EncryptionToken}).
 * Existing items should not be removed, re-ordered, or re-purposed
 */
public enum TokenField {
    FULL_NAME,
    DUZ,
    SSN,
    SITE_NAME,
    SITE_NUMBER,
    SECURITY_TOKEN,
    ACCESS_CODE,
    VERIFY_CODE,
    APPLICATION_NAME,
    EXPIRATION_TIME;
}
