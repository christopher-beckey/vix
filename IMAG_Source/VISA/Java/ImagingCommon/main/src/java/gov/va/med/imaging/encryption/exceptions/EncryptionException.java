/**
 * Copyright 2012 ISI Group, LLC
 */
package gov.va.med.imaging.encryption.exceptions;

/**
 * @author Administrator
 *
 */
public class EncryptionException 
extends Exception
{
	private static final long serialVersionUID = -5943669050576872159L;
	
	public EncryptionException()
	{
		super();
	}
	
	public EncryptionException(Throwable t)
	{
		super(t);
	}
	
	public EncryptionException(String msg, Throwable t)
	{
		super(msg, t);
	}

}
