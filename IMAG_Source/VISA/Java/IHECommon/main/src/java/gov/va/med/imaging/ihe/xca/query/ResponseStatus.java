/**
 * 
 */
package gov.va.med.imaging.ihe.xca.query;

/**
 * @author vhaiswbeckec
 *
 */
public enum ResponseStatus
{
	success("urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Success"),
	failure("urn:oasis:names:tc:ebxml-regrep:ResponseStatusType:Failure"),
	partialSuccess("urn:ihe:iti:2007:ResponseStatusType:PartialSuccess");
	
	private final String key;
	
	ResponseStatus(String key)
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
	public static ResponseStatus valueOfKey(String key)
	{
		if(key == null)
			return null;
		
		for(ResponseStatus qp : ResponseStatus.values())
			if(key.equals(qp.key))
				return qp;
		
		return null;
	}

}
