/**
 * Copyright 2012 ISI Group, LLC
 */
package gov.va.med.imaging.configuration;

/**
 * @author Administrator
 *
 */
public class EncryptedString 
{
	private String value;
	
	public EncryptedString()
	{
		super();
	}

	/**
	 * @param value
	 */
	public EncryptedString(String value) 
	{
		super();
		this.value = value;
	}

	public String getValue() 
	{
		return value;
	}

	public void setValue(String value) 
	{
		this.value = value;
	}

	@Override
	public String toString() 
	{
		return getValue();
	}

}
