/**
 * 
  Property of ISI Group, LLC
  Date Created: Jun 5, 2014
  Developer:  Julian Werfel
 */
package gov.va.med.imaging.tomcat.vistarealm.encryption;

import gov.va.med.imaging.encryption.exceptions.AesEncryptionException;

/**
 * @author Julian Werfel
 *
 */
public class TokenExpiredException
extends AesEncryptionException
{
	private static final long serialVersionUID = 8074606202364939736L;

	public TokenExpiredException(String msg)
	{
		super(msg);
	}

}
