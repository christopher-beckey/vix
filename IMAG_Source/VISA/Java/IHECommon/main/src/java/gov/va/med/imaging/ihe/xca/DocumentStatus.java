/**
 * 
 */
package gov.va.med.imaging.ihe.xca;

/**
 * @author vhaiswbeckec
 *
 * document status types
 * VA returns only status of 'Approved'
 */
public enum DocumentStatus
{
	submitted("urn:oasis:names:tc:ebxml-regrep:StatusType:Submitted"),
	approved("urn:oasis:names:tc:ebxml-regrep:StatusType:Approved"),
	deprecated("urn:oasis:names:tc:ebxml-regrep:StatusType:Deprecated");
	
	private final String key;
	
	DocumentStatus(String key)
	{
		this.key = key;
	}

	public String getKey()
	{
		return this.key;
	}

	@Override
	public String toString()
	{
		return getKey();
	}
	
	/**
	 * 
	 * @param key
	 * @return
	 */
	public static DocumentStatus valueOfKey(String key)
	{
		if(key == null)
			return null;
		
		for(DocumentStatus qp : DocumentStatus.values())
			if(key.equals(qp.key))
				return qp;
		
		return null;
	}

}
